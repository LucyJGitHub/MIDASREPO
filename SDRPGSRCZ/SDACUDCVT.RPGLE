     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Additional Customer Details Convert')         *
      *****************************************************************
      *                                                               *
      *  Midas - Module name   ILE Module                             *
      *                                                               *
      *  SDACUDCVT - SDACUSPD Transaction Details Conversion:         *
      *              File to Screen                                   *
      *                                                               *
      *  Function:  This module converts the fields of a SDACUDPD     *
      *             Transaction Detail from file to screen format     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER070             Date 19Aug14               *
      *  Prev Amend No. CGL132             Date 01May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 263252             Date 06Jan10               *
      *                 BUG26505           Date 20Oct09               *
      *                 CER045             Date 20Jul09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22529           Date 10Feb09               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSW207             Date 05Jul07               *
      *                 CSD029             Date 22Aug05               *
      *                 232543             Date 30Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  263252 - Document Expiry Date is not updated.                *
      *  BUG26505 - Inserted data in the State Code field disappeared *
      *             during enquiry                                    *
      *  CER045 - German Features - Reporting Bundesbank              *
      *  CER054 - German Features - Church Tax                        *
      *  BUG22529 - Global Additional Customer Details (Recompile)    *
      *  CER034 - German Features - New Fields and Enquiries          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  CSD029 - Customer Details Additional Fields.                 *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      /COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
      /COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      /COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
 
      ** SDACUSPD Transaction Details in File Format
     D TranFilFmt    E DS                  EXTNAME(SDACUSPD)
 
      ** SDACUDPD Transaction Details in Screen Format
     D TrnDets       E DS                  EXTNAME(SDACUDPD)
                                                                                              CGL132
      ** SDACU5DPD Transaction Details in Screen Format                                       CGL132
     D CustDets5     E DS                  EXTNAME(SDACU5DPD)                                 CGL132
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** First DS for Access Programs, short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for Access Programs, long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Midas SD Midas modules Data Structure                                                CSW207
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CSW207
                                                                                              CSW207
      *                                                                                       CER034
      ** SDACU1DPD Additional Customer Details in Screen - 2 format                           CER034
     D CustDet2      E DS                  EXTNAME(SDACU3DPD)                                 CER034
      *                                                                                       CER034
      ** SDACU2DPD Additional Customer Details in Screen - 3 format                           CER034
     D CustDet3      E DS                  EXTNAME(SDACU4DPD)                                 CER034
      *                                                                                       CER034
      ** SDCUSTPD Midas SD Customer details in file format                                    CER034
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER034
      *                                                                                       CER034
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameter for Access Object
     D PRtcd           S              7A
     D POptn           S              7A
 
      ** Parameter for ZEDIT
     D ZFIELD          S             16A
     D ZADEC           S              1  0
 
      ** Parameter for ZDATE2
     D ZDAYNO          S              5  0
     D ZDATE           S              6  0
     D ZADATE          S              7A
 
      ** Other Variables
     D ##ACTN          S              1A
     D CSD029          S              1A                                                      CSD029
     D PSARD           S              6A                                                      CSD029
 
      ** Swift installed flag                                                                 CSW207
     D CSW207          S              1A                                                      CSW207
                                                                                              CSW207
     D CER034          S              1A                                                      CER034
     D CER038          S              1A                                                      CER034
     D CER041          S              1A                                                      CER034
     D CER047          S              1A                                                      CER034
     D CER048          S              1A                                                      CER034
     D CER054          S              1A                                                      CER054
     D CER045          S              1A                                                      CER045
     D CLE134          S              1A                                                      CLE134
      *                                                                                       CER034
      ** Parameters for ZDATE9                                                                CER034
      *                                                                                       CER034
     D PDateOut        S              8S 0                                                    CER034
     D PErrFlag        S              1A                                                      CER034
      *                                                                                       263252
      ** Data Structure for Expiry Date                                                       263252
      *                                                                                       263252
     D ExpDate         DS             8                                                       263252
     D  ExpDay                 1      2                                                       263252
     D  ExpMonth               3      4                                                       263252
     D  ExpYear                5      8                                                       263252
      *                                                                                       263252
      ** Data Structure for ZDATE9 - PDateOut                                                 263252
      *                                                                                       263252
     D DateOut         DS             8                                                       263252
     D  DOYear                 1      4                                                       263252
     D  DOMonth                5      6                                                       263252
     D  DODay                  7      8                                                       263252
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Initialization
 
     C                   EXSR      SRInit
 
      ** Set screen fields
 
     C                   EXSR      SRScreen
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRScreen - Set Screen Fields
      *****************************************************************
     C     SRScreen      BEGSR
 
      ** Customer Number
     C                   EVAL      DDCUST = E5CUST
 
      ** Tax Identification Number
     C                   EVAL      DDTINO = E5TINO
 
      ** Joint Account Type
     C                   EVAL      DDJATP = E5JATP
 
      ** Identification Type
     C                   EVAL      DDIDTP = E5IDTP
 
      ** Issuing Country
     C                   EVAL      DDISCT = E5ISCT
 
      ** Issuing Date
     C**********         IF        E5ISDT = *ZERO                                             232543
     C**********         EVAL      DDISDT = *BLANKS                                           232543
     C**********         ELSE                                                                 232543
     C**********         EVAL      ZDAYNO = E5ISDT                                            232543
     C**********         EXSR      SRZDate2                                                   232543
     C**********         EVAL      DDISDT = *BLANKS                                           232543
     C**********         MOVEL     ZDATE         DDISDT                                       232543
     C**********         ENDIF                                                                232543
     C                   EVAL      DDISDT = E5ISDT                                            232543
 
      ** Alternative Number
     C                   EVAL      DDALTN = E5ALTN
 
      ** Fax Number
     C                   EVAL      DDFXNB = E5FXNB
 
      ** Identity Number
     C                   EVAL      DDIDNO = E5IDNO
 
      ** Telex Number
     C                   EVAL      DDTXNB = E5TXNB
 
      ** Date of Birth
     C                   EVAL      DDDBTH = E5DBTH
 
      ** Provisional Opening
     C                   EVAL      DDPRVO = E5PRVO
 
      ** Date of Last Visit
     C                   IF        E5DOLV = *ZERO
     C                   EVAL      DDDOLV = *BLANKS
     C                   ELSE
     C                   EVAL      ZDAYNO = E5DOLV
     C                   EXSR      SRZDate2
     C                   EVAL      DDDOLV = *BLANKS
     C                   MOVEL     ZDATE         DDDOLV
     C                   ENDIF
 
      ** Mail Details
     C                   EVAL      DDMDTL = E5MDTL
 
      ** Country of Birth
     C                   EVAL      DDBTHC = E5BTHC
 
      ** Town of Birth
     C                   EVAL      DDBTHT = E5BTHT
 
      ** Customer Name and Address 1
     C                   EVAL      DDCNA1 = E5CNA1
 
      ** Customer Name and Address 2
     C                   EVAL      DDCNA2 = E5CNA2
 
      ** Customer Name and Address 3
     C                   EVAL      DDCNA3 = E5CNA3
 
      ** Customer Name and Address 4
     C                   EVAL      DDCNA4 = E5CNA4
 
      ** City
     C                   EVAL      DDCITY = E5CITY
 
      ** Zip Code
     C                   EVAL      DDZIPC = E5ZIPC
 
      ** Code Word One
     C                   EVAL      DDCWL1 = E5CWL1
 
      ** Code Word Two
     C                   EVAL      DDCWL2 = E5CWL2
 
      ** Code Word Three
     C                   EVAL      DDCWL3 = E5CWL3
 
      ** Code Word Four
     C                   EVAL      DDCWL4 = E5CWL4
 
      ** Code Word Five
     C                   EVAL      DDCWL5 = E5CWL5
 
     C     CSD029        IFEQ      'Y'                                                        CSD029
      ** Field 01 details                                                                     CSD029
     C                   EVAL      DDF001 = E5FL01                                            CSD029
                                                                                              CSD029
      ** Field 02 details                                                                     CSD029
     C                   EVAL      DDF002 = E5FL02                                            CSD029
                                                                                              CSD029
      ** Field 03 details                                                                     CSD029
     C                   EVAL      DDF003 = E5FL03                                            CSD029
                                                                                              CSD029
      ** Field 04 details                                                                     CSD029
     C                   EVAL      DDF004 = E5FL04                                            CSD029
                                                                                              CSD029
      ** Field 05 details                                                                     CSD029
     C                   EVAL      DDF005 = E5FL05                                            CSD029
                                                                                              CSD029
      ** Field 06 details                                                                     CSD029
     C                   EVAL      DDF006 = E5FL06                                            CSD029
                                                                                              CSD029
      ** Field 07 details                                                                     CSD029
     C                   EVAL      DDF007 = E5FL07                                            CSD029
                                                                                              CSD029
      ** Field 08 details                                                                     CSD029
     C                   EVAL      DDF008 = E5FL08                                            CSD029
                                                                                              CSD029
      ** Field 09 details                                                                     CSD029
     C                   EVAL      DDF009 = E5FL09                                            CSD029
                                                                                              CSD029
      ** Field 10 details                                                                     CSD029
     C                   EVAL      DDF010 = E5FL10                                            CSD029
                                                                                              CSD029
     C                   ENDIF                                                                CSD029
                                                                                              CSW207
      ** Issuer Code                                                                          CSW207
     C                   IF        CSW207 = 'Y' OR BGN4ST = 'Y'                               CSW207
     C                   EVAL      DDISCD = E5ISCD                                            CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
      ** Alternative Tax Identification Numbers and TIN Countries                             CGL132
     C                   EVAL      DDTIN2 = E5TIN2                                            CGL132
     C                   EVAL      DDTNC2 = E5TNC2                                            CGL132
     C                   EVAL      DDTIN3 = E5TIN3                                            CGL132
     C                   EVAL      DDTNC3 = E5TNC3                                            CGL132
     C                   EVAL      DDTIN4 = E5TIN4                                            CGL132
     C                   EVAL      DDTNC4 = E5TNC4                                            CGL132
     C                   EVAL      DDTIN5 = E5TIN5                                            CGL132
     C                   EVAL      DDTNC5 = E5TNC5                                            CGL132
 
      *                                                                                       CER034
      ** Check if CER047 and CER048 is enabled.                                               CER034
      *                                                                                       CER034
     C                   IF        CER047 = 'Y' OR CER048 = 'Y'                               CER034
      *                                                                                       CER034
      ** Title                                                                                CER034
      *                                                                                       CER034
     C                   EVAL      DDTITL = E5TITL                                            CER034
      *                                                                                       CER034
      ** Maiden Name                                                                          CER034
      *                                                                                       CER034
     C                   EVAL      DDMDNM = E5MDNM                                            CER034
      *                                                                                       CER034
      ** Identification Document/Id                                                           CER034
      *                                                                                       CER034
     C                   EVAL      DDDCNM = E5DCID                                            CER034
      *                                                                                       CER034
      ** Identification Document/Id Issued Place                                              CER034
      *                                                                                       CER034
     C                   EVAL      DDISPL = E5DIPL                                            CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER047 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   IF        CER047 = 'Y'                                               CER034
      *                                                                                       CER034
      ** Expiry Date                                                                          CER034
      *                                                                                       CER034
     C                   IF        E5EXDT = *ZEROS                                            CER034
      *                                                                                       CER034
     C                   EVAL      DDEXDT = *BLANKS                                           CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   EVAL      ZDAYNO = E5EXDT                                            CER034
      *                                                                                       CER034
     C                   CALLB     'ZDATE9'                                                   CER034
     C                   PARM                    ZDAYNO                                       CER034
     C                   PARM                    PDateOut                                     CER034
     C                   PARM                    PErrFlag                                     CER034
      *                                                                                       CER034
     C**********         MOVEL     PDateOut      DDEXDT                                CER034 263252
     C                   MOVEL     PDateOut      DateOut                                      263252
     C                   EVAL      ExpDay = DODay                                             263252
     C                   EVAL      ExpMonth = DOMonth                                         263252
     C                   EVAL      ExpYear = DOYear                                           263252
     C                   EVAL      DDEXDT = ExpDate                                           263252
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Subject to 24C Flag                                                                  CER034
      *                                                                                       CER034
     C                   EVAL      DDS24C = E5S24C                                            CER034
      *                                                                                       CER034
      ** Remarks                                                                              CER034
      *                                                                                       CER034
     C                   EVAL      DDREM1 = E5REM1                                            CER034
     C                   EVAL      DDREM2 = E5REM2                                            CER034
     C                   EVAL      DDREM3 = E5REM3                                            CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER048 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   IF        CER048 = 'Y'                                               CER034
      *                                                                                       CER034
      ** Spouse/Husband Reference                                                             CER034
      *                                                                                       CER034
     C                   EVAL      DDSHRF = E5SHRF                                            CER034
      *                                                                                       CER034
      ** Partner/Associate Indicator                                                          CER034
      *                                                                                       CER034
     C                   EVAL      DDPIND = E5PIND                                            CER034
      *                                                                                       CER034
      ** Exemption Threshold                                                                  CER034
      *                                                                                       CER034
     C                   IF        E5EXTH = *ZEROS                                            CER034
      *                                                                                       CER034
     C                   EVAL      DDEXTH = *BLANKS                                           CER034
     C                   ELSE                                                                 CER034
     C                   EVAL      ZFIELD = *BLANKS                                           CER034
     C                   Z-ADD     0             ZADEC                                        CER034
     C                   MOVE      E5EXTH        ZFIELD                                       CER034
     C                   EXSR      SRZEdit                                                    CER034
     C                   MOVE      ZFIELD        DDEXTH                                       CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Exemption Threshold Approval Date                                                    CER034
      *                                                                                       CER034
     C                   IF        E5EADT = *ZEROS                                            CER034
      *                                                                                       CER034
     C                   EVAL      DDEADT = *BLANKS                                           CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   EVAL      ZDAYNO = E5EADT                                            CER034
     C                   EXSR      SRZDate2                                                   CER034
     C                   MOVEL     ZDATE         DDEADT                                       CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Exemption Threshold Value Date                                                       CER034
      *                                                                                       CER034
     C                   IF        E5EVDT = *ZEROS                                            CER034
      *                                                                                       CER034
     C                   EVAL      DDEVDT = *BLANKS                                           CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   EVAL      ZDAYNO = E5EVDT                                            CER034
     C                   EXSR      SRZDate2                                                   CER034
     C                   MOVEL     ZDATE         DDEVDT                                       CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Exemption Threshold Expiry Date                                                      CER034
      *                                                                                       CER034
     C                   IF        E5ETXT = *ZEROS                                            CER034
      *                                                                                       CER034
     C                   EVAL      DDETXT = *BLANKS                                           CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   EVAL      ZDAYNO = E5ETXT                                            CER034
     C                   EXSR      SRZDate2                                                   CER034
     C                   MOVEL     ZDATE         DDETXT                                       CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Characteristic of Demand/Claim                                                       CER034
      *                                                                                       CER034
     C                   EVAL      DDCDCL = E5CDCL                                            CER034
      *                                                                                     BUG26505
      ** State Codes                                                                        BUG26505
      *                                                                                     BUG26505
     C                   EVAL      DDSTCD = E5STCD                                          BUG26505
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER034 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   IF        CER034 = 'Y'                                               CER034
      *                                                                                       CER034
      ** FX Customer                                                                          CER034
      *                                                                                       CER034
     C                   EVAL      DDFXCU = E5FXCU                                            CER034
      *                                                                                       CER034
      ** Securities Customer                                                                  CER034
      *                                                                                       CER034
     C                   EVAL      DDSECU = E5SECU                                            CER034
      *                                                                                       CER034
      ** Staff Member                                                                         CER034
      *                                                                                       CER034
     C                   EVAL      DDSMBR = E5SMBR                                            CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER038 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   IF        CER038 = 'Y'                                               CER034
      *                                                                                       CER034
      ** Language ID                                                                          CER034
      *                                                                                       CER034
     C                   EVAL      DDLNID = E5LNID                                            CER034
      *                                                                                       CER034
      ** Correspondent Type                                                                   CER034
      *                                                                                       CER034
     C                   EVAL      DDCTYP = E5CTYP                                            CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER041 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   IF        CER041 = 'Y'                                               CER034
      *                                                                                       CER034
      ** Zero Confirmation Flag                                                               CER034
      *                                                                                       CER034
     C                   EVAL      DDZCFG = E5ZCFG                                            CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER054
      ** Check if CER054 is enabled.                                                          CER054
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
      *                                                                                       CER054
      ***State*Codes                                                                 CER054 BUG26505
      *                                                                                       CER054
     C**********         EVAL      DDSTCD = E5STCD                                   CER054 BUG26505
      *                                                                                       CER054
      ** Religious Affiliation Codes                                                          CER054
      *                                                                                       CER054
     C                   EVAL      DDRLAF = E5RLAF                                            CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER034
      ** Check if CER045 is enabled.                                                          CER045
      *                                                                                       CER045
     C                   IF        CER045 = 'Y'                                               CER045
      *                                                                                       CER045
      ** Borrower Sector Classification Code                                                  CER045
      *                                                                                       CER045
     C                   MOVEL     E5BSCC        DDBSCC                                       CER045
      *                                                                                       CER070
      ** Risk Classification Code                                                             CER070
      *                                                                                       CER070
     C                   MOVEL     E5RIGR        DDRIGR                                       CER070
      *                                                                                       CER045
      ** Economic Activity Code                                                               CER045
      *                                                                                       CER045
     C                   EVAL      DDECAC = E5ECAC                                            CER045
      *                                                                                       CER045
      ** Borrower Sector Classification/BISTA                                                 CER045
      *                                                                                       CER045
     C                   MOVEL     E5BIST        DDBIST                                       CER045
      *                                                                                       CER045
      ** Additional Borrowers Statistics Key                                                  CER045
      *                                                                                       CER045
     C                   EVAL      DDABSK = E5ABSK                                            CER045
      *                                                                                       CER045
      ** Customer Required for Bundesbank Reporting                                           CER045
      *                                                                                       CER045
     C                   EVAL      DDBEXT = E5BEXT                                            CER045
      *                                                                                       CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER045
     C                   IF        CLE134 = 'Y'                                               CLE134
     C                   EVAL      DDPDCU = E5PDCU                                            CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZDate2 - Format a date for output                           *
      *                                                               *
      *****************************************************************
     C     SRZDate2      BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZEdit - Edit an unsigned field                              *
      *                                                               *
      *****************************************************************
     C     SRZEdit       BEGSR
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      0             ZADEC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRInit - Initialization
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Blank outputs (Except for Action Code)
 
     C                   EVAL      ##ACTN = DDACTN
     C                   EVAL      TrnDets = *Blanks
     C                   EVAL      DDACTN = ##ACTN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
      **  Program Parameters
 
     C     *ENTRY        PLIST
 
      ** Input Parameters
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** SDACUSPD Transaction Details File Format
     C                   PARM                    TranFilFmt
 
      ** Output Parameters
      ** SDACUDPD Transaction Details Screen Format
     C                   PARM                    TrnDets
      ** SDACU5DPD Transaction Details Screen Format                                          CGL132
     C                   PARM                    CustDets5                                    CGL132
 
      *                                                                                       CER034
      ** SDACU1DPD Additional Customer Details Screen - 2 format                              CER034
      *                                                                                       CER034
     C                   PARM                    CustDet2                                     CER034
      *                                                                                       CER034
      ** SDACU2DPD Additional Customer Details Screen - 3 format                              CER034
      *                                                                                       CER034
     C                   PARM                    CustDet3                                     CER034
      *                                                                                       CER034
      ** Initialize program name
 
     C                   EVAL      DBPGM = 'SDACUDCVT'
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST  '    POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRtcd <> *BLANK
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 900
     C                   EXSR      *PSSR
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
 
      *                                                                                       CER034
      ** Check if CER034 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER034'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER034 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER034 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER034
     C                             (PRtcd <> '*NRF   ')                                       CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER034'                                           CER034
     C                   EVAL      DBASE = 903                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER038 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER038'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER038 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER038 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER034
     C                             (PRtcd <> '*NRF   ')                                       CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER038'                                           CER034
     C                   EVAL      DBASE = 904                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER041 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER041'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER041 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER041 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER034
     C                             (PRtcd <> '*NRF   ')                                       CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER041'                                           CER034
     C                   EVAL      DBASE = 905                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER047 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER047'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER047 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER047 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER034
     C                             (PRtcd <> '*NRF   ')                                       CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER047'                                           CER034
     C                   EVAL      DBASE = 907                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
      ** Check if CER048 is enabled.                                                          CER034
      *                                                                                       CER034
     C                   CALL      'AOSARDR0'                                                 CER034
     C                   PARM      *BLANKS       PRtcd                                        CER034
     C                   PARM      '*VERIFY'     POptn                                        CER034
     C                   PARM      'CER048'      PSard                                        CER034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER034
      *                                                                                       CER034
     C                   EVAL      CER048 = 'N'                                               CER034
      *                                                                                       CER034
     C                   IF        PRtcd = *BLANKS                                            CER034
      *                                                                                       CER034
     C                   EVAL      CER048 = 'Y'                                               CER034
      *                                                                                       CER034
     C                   ELSE                                                                 CER034
      *                                                                                       CER034
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER034
     C                             (PRtcd <> '*NRF   ')                                       CER034
      *                                                                                       CER034
     C     *LOCK         IN        LDA                                                        CER034
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER034
     C                   EVAL      DBKEY = 'CER048'                                           CER034
     C                   EVAL      DBASE = 908                                                CER034
     C                   OUT       LDA                                                        CER034
     C                   EXSR      *PSSR                                                      CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
     C                   ENDIF                                                                CER034
      *                                                                                       CER034
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
      *                                                                                       CER054
      ** Check if CER054 is enabled.                                                          CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtcd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'N'                                               CER054
      *                                                                                       CER054
     C                   IF        PRtcd = *BLANKS                                            CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
      *                                                                                       CER054
     C                   ELSE                                                                 CER054
      *                                                                                       CER054
     C                   IF        (PRtcd <> *BLANKS) AND                                     CER054
     C                             (PRtcd <> '*NRF   ')                                       CER054
      *                                                                                       CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER054
     C                   EVAL      DBKEY = 'CER054'                                           CER054
     C                   EVAL      DBASE = 909                                                CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      *                                                                                       CER045
      ** Check if CER045 is enabled                                                           CER045
      *                                                                                       CER045
     C                   CALL      'AOSARDR0'                                                 CER045
     C                   PARM      *BLANKS       PRtcd                                        CER045
     C                   PARM      '*VERIFY'     POptn                                        CER045
     C                   PARM      'CER045'      PSard                                        CER045
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER045
      *                                                                                       CER045
     C                   EVAL      CER045 = 'N'                                               CER045
      *                                                                                       CER045
     C                   IF        PRtcd = *BLANKS                                            CER045
      *                                                                                       CER045
     C                   EVAL      CER045 = 'Y'                                               CER045
     C                   ELSE                                                                 CER045
      *                                                                                       CER045
      ** Handle Datebase Error.                                                               CER045
      *                                                                                       CER045
     C                   IF        PRtcd <> '*NRF   '                                         CER045
     C     *LOCK         IN        LDA                                                        CER045
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER045
     C                   EVAL      DBKEY = 'CER045'                                           CER045
     C                   EVAL      DBASE = 956                                                CER045
     C                   OUT       LDA                                                        CER045
     C                   EXSR      *PSSR                                                      CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER045
     C                   ENDIF                                                                CER045
      *                                                                                       CER045
      ** Check if CLE134 is enabled.                                                          CLE134
      *                                                                                       CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       PRtcd                                        CLE134
     C                   PARM      '*VERIFY'     POptn                                        CLE134
     C                   PARM      'CLE134'      PSard                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
      *                                                                                       CLE134
     C                   EVAL      CLE134 = 'N'                                               CLE134
      *                                                                                       CLE134
     C                   IF        PRtcd = *BLANKS                                            CLE134
     C                   EVAL      CLE134 = 'Y'                                               CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
     C                   ENDSR
      ********************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
** CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2004
