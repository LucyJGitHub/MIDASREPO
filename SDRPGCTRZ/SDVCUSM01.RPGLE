     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Customer Number for Joint A/cs')     *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDVCUSM01 - Midas SD Validate Customer Number for Joint      *
      *              Accounts                                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CER071             Date 01Aug16               *
      *  Prev Amend No. CER070             Date 19Aug14               *
      *                 MD027720           Date 30Jul14               *
      *                 MD026549           Date 12May14               *
      *                 MD026711           Date 12May14               *
      *                 CGL132             Date 01May13               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24489           Date 24Jun09               *
      *                 BUG23732           Date 23Apr09               *
      *                 CER034             Date 19Aug08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 232543             Date 31Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  MD027720 - Incorrect Error Message in Joint Account Member   *
      *             Maintenance                                       *
      *  MD026549 - Incorrect error messages/warning message in Joint *
      *             Account Member Maintenance                        *
      *  MD026711 - DBError when adding a new member                  *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG24489 - Threshold defined for non-resident is accepted    *
      *             and validated in Joint Account Members Maint      *
      *  BUG23732 - Joint Account Threshold                           *
      *  CER034 - German Features - New Fields and Enquiries          *
      *           (Recompile)                                         *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas SD Joint A/c Member Details by Joint A/c No./Customer No.
     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Additional Customer Details by Customer Number
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)
      *                                                                                     BUG23732
      ** SD Cust Details by Country fo Tax                                                  BUG23732
      *                                                                                     BUG23732
     FSDACTXL1  IF   E           K DISK    INFSR(*PSSR)                                     BUG23732
      *                                                                                     BUG23732
      ** Joint Account Member file                                                          BUG23732
      *                                                                                     BUG23732
     FSDJACCLB  IF   E           K DISK    INFSR(*PSSR)                                     BUG23732
     F                                     RENAME(SDJACCD0:SDJACCD1)                        BUG23732
     F                                     PREFIX(J)                                        BUG23732

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      **---------------------------------------------------------------
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** Standard D-specs
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------

      **---------------------------------------------------------------
      ** API Validation X Error Array Declarations
     D/COPY ZACPYSRC,ERR_XARRYS
      **---------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Customer Details Data Structure
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External DS for SAR details                                                          CGL132
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CGL132
                                                                                              CGL132
      ** Long Access Object Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                     BUG23732
      ** Short Access Object Data Structure                                                 BUG23732
      *                                                                                     BUG23732
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   BUG23732
      *                                                                                     BUG23732
      ** Long DS for access programs, long data structure                                   BUG23732
      *                                                                                     BUG23732
     D DSLDY         E DS                  EXTNAME(DSLDY)                                   BUG23732
      *                                                                                     BUG23732
      ** External DS for Branch Details                                                     BUG23732
      *                                                                                     BUG23732
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                BUG23732
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                   BUG23732
      *                                                                                     BUG23732
      ** External DS for Location  Details                                                  BUG23732
      *                                                                                     BUG23732
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                BUG23732
      *                                                                                     BUG23732
      ** Data Structure for Additional Customer Details                                     BUG23732
      *                                                                                     BUG23732
     D SDACUS        E DS                  EXTNAME(SDACUSPD)                                BUG23732
     D                                     PREFIX(C)                                        BUG23732
      *                                                                                     BUG23732
      ** External DS for Country of Tax Code                                                BUG23732
      *                                                                                     BUG23732
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)                                BUG23732

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Entry Parameters
     D PRetCode        S             10A
     D PDJANO          S              6A
     D PDCUST          S              6A
     D OKCUST          S              1A

      ** Access Object Parameters
     D PRtCd           S              7A
     D POptn           S              7A
     D PCust           S             10A
     D PKyst           S              7A
     D CGL132          S              1A                                                      CGL132

      ** Key Fields
     D KCust           S                   LIKE(E5CUST)
     D KJANo           S                   LIKE(JCJANO)

      ** Working Variables
     D Ix              S              3P 0
     D CER048          S              1A                                                    BUG23732
     D PDACTN          S              1A                                                    BUG23732
     D PSARD           S              6A                                                    BUG23732
     D PBrca           S              3A                                                    BUG23732
     D PLocn           S              3A                                                    BUG23732
     D KCtax           S              2A                                                    BUG23732
     D WTotThres       S              7P 0 INZ(0)                                           BUG23732
     D PCtrT           S              2A                                                    BUG23732
     D PCtrR           S              2A                                                    BUG23732
     D PCustT          S              6A                                                    BUG23732
     D WAxetxs         S              1A                                                    BUG23732
     D WMemThres       S              6P 0 INZ(0)                                           BUG23732

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +---------------- Start of Main Processing ------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      ** Initialise relevant variables.

     C                   EVAL      PRetCode  = *BLANKS
     C                   EVAL      FldNamXAr = *BLANKS
     C                   EVAL      MsgIDXAr  = *BLANKS
     C                   EVAL      MsgDtaXAr = *BLANKS
     C                   EVAL      Ix = *ZERO

      ** Validate Customer Number.

     C                   IF        PDCUST <> *BLANKS

     C                   EXSR      SRVCust

     C                   IF        OKCUST <> 'Y'
     C                   EVAL      PRetCode  = '*ERROR'
     C                   ENDIF

     C                   ENDIF

     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCust - Validates the Customer Number.                     *
      *                                                               *
      *****************************************************************
     C     SRVCust       BEGSR

      ** Check first if the given customer exists.

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      PDCUST        PCust
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        PRtCd = *BLANKS

     C                   IF        %SCAN('?':PDCUST) <> *ZERO
     C                   EVAL      PDCUST = BBCUST
     C                   ENDIF

     C                   ELSE

     C                   SELECT

     C                   WHEN      PRtCd = '*NRF   ' OR
     C                             PRtCd = '*KEY   '

      ** Invalid Customer Number.

     C                   EVAL      OKCUST = 'N'
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      FldNamXAr(Ix) = 'DDCUST'
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0113'

     C                   WHEN      PRtCd = '*NOSEL '
     C                   EVAL      PDCUST = *BLANKS

     C                   OTHER

     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey = PCust
     C                   EVAL      DBase = 101
     C                   OUT       LDA
     C                   EXSR      *PSSR

     C                   ENDSL

     C                   LEAVESR

     C                   ENDIF
     C                   IF        CGL132 = 'Y'                                               CGL132
                                                                                              CGL132
      ** Check if the Joint Account has itself defined as a member                            CGL132
                                                                                              CGL132
     C                   IF        PDCUST = PDJANO                                            CGL132
     C                   EVAL      OKCUST = 'N'                                               CGL132
     C                   EVAL      Ix = Ix + 1                                                CGL132
     C                   EVAL      FldNamXAr(Ix) = 'DDCUST'                                   CGL132
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0143'                                   CGL132
     C                   LEAVESR                                                              CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      ** Check if the customer has already been defined as Joint Account with                 CGL132
      ** with member as the Joint Account.                                                    CGL132
                                                                                              CGL132
     C                   EVAL      KJANo = PDCUST                                             CGL132
     C                   EVAL      KCust = PDJANO                                             CGL132
                                                                                              CGL132
     C     KJACC         CHAIN     SDJACCL1                                                   CGL132
                                                                                              CGL132
     C                   IF        %FOUND                                                     CGL132
                                                                                              CGL132
     C                   EVAL      OKCUST = 'N'                                               CGL132
     C                   EVAL      Ix = Ix + 1                                                CGL132
     C                   EVAL      FldNamXAr(Ix) = 'DDCUST'                                   CGL132
     C**********         EVAL      MsgIDXAr(Ix) = 'SDM0142'                          CGL132 MD027720
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0159'                                 MD027720
     C                   LEAVESR                                                              CGL132
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
     C                   ELSE                                                                 CGL132
      ** Check if the given customer is a Joint Account.                                      CGL132
                                                                                              CGL132
     C                   EVAL      KCust = PDCUST                                             CGL132
                                                                                              CGL132
     C     KCust         CHAIN     SDACUSL1                                                   CGL132
                                                                                              CGL132
     C                   IF        %FOUND AND                                                 CGL132
     C                             E5JATP = 'Y'                                               CGL132
                                                                                              CGL132
      ** Customer Number must not be a Joint Account.                                         CGL132
                                                                                              CGL132
     C                   EVAL      OKCUST = 'N'                                               CGL132
     C                   EVAL      Ix = Ix + 1                                                CGL132
     C                   EVAL      FldNamXAr(Ix) = 'DDCUST'                                   CGL132
     C                   EVAL      MsgIDXAr(Ix) = 'SDM0114'                                   CGL132
     C                   LEAVESR                                                              CGL132
     C                   ENDIF                                                                CGL132
     C                   ENDIF                                                                CGL132

      ***Check*if*the*given*customer*is*a*Joint*Account.***************                       CGL132
      **********                                                                              CGL132
     C**********         EVAL      KCust = PDCUST                                             CGL132
      **********                                                                              CGL132
     C*****KCust         CHAIN     SDACUSL1                                                   CGL132
      **********                                                                              CGL132
     C**********         IF        %FOUND AND                                                 CGL132
     C**********                   E5JATP = 'Y'                                               CGL132
      **********                                                                              CGL132
      ***Customer*Number*must*not*be*a*Joint*Account.******************                       CGL132
      **********                                                                              CGL132
     C**********         EVAL      OKCUST = 'N'                                               CGL132
     C**********         EVAL      Ix = Ix + 1                                                CGL132
     C**********         EVAL      FldNamXAr(Ix) = 'DDCUST'                                   CGL132
     C**********         EVAL      MsgIDXAr(Ix) = 'SDM0114'                                   CGL132
     C**********         LEAVESR                                                              CGL132
     C**********         ENDIF                                                                CGL132
      *                                                                                     BUG23732
     C                   IF        (PDACTN = ' ' OR                                         BUG23732
     C                             PDACTN = 'I') AND                                        BUG23732
     C                             OKCUST = 'Y' AND                                         BUG23732
     C                             CER048 = 'Y'                                             BUG23732
      *                                                                                     BUG23732
     C                   EVAL      WTotThres = *ZEROS                                       BUG23732
     C                   EVAL      WMemThres = *ZEROS                                       BUG23732
      *                                                                                     BUG23732
      ** To get the Details for Exemption Threshold for member                              BUG23732
      ** customer                                                                           BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOACUSR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY'        POptn                                      BUG23732
     C                   PARM      PDCUST        PCust                                      BUG23732
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS AND                                     BUG23732
     C                             PRtcd <> '*NRF'                                          BUG23732
     C                   EVAL      DBKEY = PCust                                            BUG23732
     C                   EVAL      DBFILE = 'SDACUSPD'                                      BUG23732
     C                   EVAL      DBASE = 107                                              BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd = '*NRF'                                           BUG23732
     C                   EVAL      CE5EXTH =  *ZEROS                                        BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   EVAL      WMemThres = CE5EXTH                                      BUG23732
      *                                                                                     BUG23732
      ** To get the Details for Exemption Threshold for joint                               BUG23732
      ** account number                                                                     BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOACUSR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY'        POptn                                      BUG23732
     C                   PARM      PDJANO        PCust                                      BUG23732
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS AND                                     BUG23732
     C                             PRtcd <> '*NRF'                                          BUG23732
     C                   EVAL      DBKEY = PCust                                            BUG23732
     C                   EVAL      DBFILE = 'SDACUSPD'                                      BUG23732
     C                   EVAL      DBASE = 107                                              BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd = '*NRF'                                           BUG23732
     C                   EVAL      CE5EXTH =  *ZEROS                                        BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   EVAL      WTotThres = CE5EXTH                                      BUG23732
      *                                                                                     BUG23732
      ** TO Get the Branch of Joint Account Customer.                                       BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOCUSTR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtCd                                      BUG23732
     C                   PARM      '*KEY   '     POptn                                      BUG23732
     C                   PARM      PDJANO        PCust                                      BUG23732
     C                   PARM      *BLANKS       PKyst                                      BUG23732
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS                                         BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBKEY =  PDJANO                                          BUG23732
     C                   EVAL      DBFILE = 'SDCUSTPD'                                      BUG23732
     C                   EVAL      DBASE = 109                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
      ** Check for Location Code                                                            BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOBRCHR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY   '     POptn                                      BUG23732
     C                   PARM      BBBRCD        PBrca                                      BUG23732
     C     SDBRCH        PARM      SDBRCH        DSFDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS                                         BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBKEY =  BBBRCD                                          BUG23732
     C                   EVAL      DBFILE = 'SDBRCHPD'                                      BUG23732
     C                   EVAL      DBASE = 109                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
      ** Check for Country Code                                                             BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOLOCNR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY   '     POptn                                      BUG23732
     C                   PARM      A8LCCD        PLocn                                      BUG23732
     C     SDLOCN        PARM      SDLOCN        DSFDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS                                         BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBKEY = A8LCCD                                           BUG23732
     C                   EVAL      DBFILE = 'SDLOCNPD'                                      BUG23732
     C                   EVAL      DBASE = 110                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
      ** CALL access object for Cust Details by Ctry of Tax                                 BUG23732
      ** to retrieve Joint Threshold                                                        BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOCTTXR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY   '     POptn                                      BUG23732
     C                   PARM      DVCNCD        PCtrT                                      BUG23732
     C                   PARM      BBCOLC        PCtrR                                      BUG23732
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS                                         BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOCTTXR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY   '     POptn                                      BUG23732
     C                   PARM      DVCNCD        PCtrT                                      BUG23732
     C                   PARM      *BLANKS       PCtrR                                      BUG23732
     C     SDCTTX        PARM      SDCTTX        DSFDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS                                         BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBKEY = DVCNCD                                           BUG23732
     C                   EVAL      DBFILE = 'SDCTTXPD'                                      BUG23732
     C                   EVAL      DBASE = 111                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   EVAL      PCustT = PDJANO                                          BUG23732
      *                                                                                     BUG23732
     C     PCustT        SETLL     SDJACCLB                                                 BUG23732
     C     PCustT        READE     SDJACCLB                                                 BUG23732
      *                                                                                     BUG23732
     C                   DOW       NOT %EOF(SDJACCLB)                                       BUG23732
      *                                                                                     BUG23732
     C                   IF        JJCCUST <> *BLANKS                                       BUG23732
      *                                                                                     BUG23732
     C                   EVAL      PCust = JJCCUST                                          BUG23732
     C                   EVAL      KCust = JJCCUST                                          BUG23732
      *                                                                                     BUG23732
     C                   EXSR      SRTaxSts                                                 BUG23732
      *                                                                                     BUG23732
      ** Get the Exemption Threshold for member customer                                    BUG23732
      *                                                                                     BUG23732
     C                   IF        AXETXS = 'T'                                             BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOACUSR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY'        POptn                                      BUG23732
     C                   PARM      JJCCUST       PCust                                      BUG23732
     C     SDACUS        PARM      SDACUS        DSLDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS AND                                     BUG23732
     C                             PRtcd <> '*NRF'                                          BUG23732
     C                   EVAL      DBKEY = PCust                                            BUG23732
     C                   EVAL      DBFILE = 'SDACUSPD'                                      BUG23732
     C                   EVAL      DBASE = 107                                              BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd = '*NRF'                                           BUG23732
     C                   EVAL      CE5EXTH =  *ZEROS                                        BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   IF        JJCCUST <> PDCUST                                        BUG23732
     C                   EVAL      WTotThres = WTotThres + CE5EXTH                          BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   IF        JJCCUST = PDCUST                                         BUG23732
     C                   EVAL      WAxetxs = AXETXS                                         BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C     PCustT        READE     SDJACCLB                                                 BUG23732
     C                   ENDDO                                                              BUG23732
      *                                                                                     BUG23732
     C                   IF        PDACTN = 'I'                                             BUG23732
     C                   EVAL      PCust = PDCUST                                           BUG23732
     C                   EVAL      KCust = PDCUST                                           BUG23732
     C                   EXSR      SRTaxSts                                                 BUG23732
     C                   EVAL      WAxetxs = AXETXS                                         BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG24489
      ** Check if threshold method is 'Y'                                                   BUG24489
      *                                                                                     BUG24489
     C                   IF        EWTHMD = 'Y'                                             BUG24489
      *                                                                                     BUG23732
      ** Add the Threshold of Member Customer to the Total Threshold                        BUG23732
      *                                                                                     BUG23732
     C                   IF        WAxetxs = 'T'                                            BUG23732
     C                   EVAL      WTotThres = WTotThres + WMemThres                        BUG23732
     C                   IF        WTotThres > EWJTTH                                       BUG23732
      *                                                                                     BUG23732
     C                   EVAL      OKCUST = 'S'                                             BUG23732
     C                   EVAL      Ix = Ix + 1                                              BUG23732
     C                   EVAL      FldNamXAr(Ix) = 'DDCUST'                                 BUG23732
     C                   EVAL      MsgIDXAr(Ix) = 'USR8329'                                 BUG23732
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732
     C                   ENDIF                                                              BUG23732
     C                   ENDIF                                                              BUG24489
      *                                                                                     BUG23732
     C                   ENDIF                                                              BUG23732

     C                   ENDSR
      *****************************************************************                     BUG23732
      /EJECT                                                                                BUG23732
      *****************************************************************                     BUG23732
      *                                                               *                     BUG23732
      *  SRTaxSts - Check Tax Status                                  *                     BUG23732
      *                                                               *                     BUG23732
      *  Called by: MAIN Processing                                   *                     BUG23732
      *                                                               *                     BUG23732
      *  Calls: None                                                  *                     BUG23732
      *                                                               *                     BUG23732
      *****************************************************************                     BUG23732
      *                                                                                     BUG23732
     C     SRTaxSts      BEGSR                                                              BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOCUSTR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtCd                                      BUG23732
     C                   PARM      '*KEY   '     POptn                                      BUG23732
     C                   PARM                    PCust                                      BUG23732
     C                   PARM      *BLANKS       PKyst                                      BUG23732
     C     SDCUST        PARM      SDCUST        DSSDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS                                         BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBKEY =  PCust                                           BUG23732
     C                   EVAL      DBFILE = 'SDCUSTPD'                                      BUG23732
     C                   EVAL      DBASE = 109                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
      ** Check for Tax status of Member Customer                                            BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOBRCHR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY   '     POptn                                      BUG23732
     C                   PARM      BBBRCD        PBrca                                      BUG23732
     C     SDBRCH        PARM      SDBRCH        DSFDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS                                         BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBKEY =  BBBRCD                                          BUG23732
     C                   EVAL      DBFILE = 'SDBRCHPD'                                      BUG23732
     C                   EVAL      DBASE = 109                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   CALL      'AOLOCNR0'                                               BUG23732
     C                   PARM      *BLANKS       PRtcd                                      BUG23732
     C                   PARM      '*KEY   '     POptn                                      BUG23732
     C                   PARM      A8LCCD        PLocn                                      BUG23732
     C     SDLOCN        PARM      SDLOCN        DSFDY                                      BUG23732
      *                                                                                     BUG23732
     C                   IF        PRtcd <> *BLANKS                                         BUG23732
     C     *LOCK         IN        LDA                                                      BUG23732
     C                   EVAL      DBKEY = A8LCCD                                           BUG23732
     C                   EVAL      DBFILE = 'SDLOCNPD'                                      BUG23732
     C                   EVAL      DBASE = 110                                              BUG23732
     C                   OUT       LDA                                                      BUG23732
     C                   EXSR      *PSSR                                                    BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
      ** Chain Customer Details by Country of Tax File to get                               BUG23732
      ** the European Tax Status                                                            BUG23732
      *                                                                                     BUG23732
     C                   EVAL      KCtax = DVCNCD                                           BUG23732
      *                                                                                     BUG23732
     C     KCustByTax    SETLL     SDACTXL1                                                 BUG23732
     C     KCustByTax    CHAIN     SDACTXL1                                                 BUG23732
      *                                                                                     BUG23732
      ** No Record Found                                                                    BUG23732
      *                                                                                     BUG23732
     C                   IF        NOT %FOUND(SDACTXL1)                                     BUG23732
     C                   EVAL      AXETXS = *BLANKS                                         BUG23732
     C                   ENDIF                                                              BUG23732
      *                                                                                     BUG23732
     C                   ENDSR                                                              BUG23732
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation subroutine.                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Input Parameters **
      ** Return Code
     C                   PARM                    PRetCode

      ** Joint Account Number
     C                   PARM                    PDJANO

      ** Customer Number
     C                   PARM                    PDCUST
      *                                                                                     BUG23732
      ** Action Code                                                                        BUG23732
      *                                                                                     BUG23732
     C                   PARM                    PDACTN                                     BUG23732
      *                                                                                     BUG23732
      ** Switchable feature German Taxes                                                    BUG23732
      *                                                                                     BUG23732
     C                   PARM                    CER048                                     BUG23732

      ** Output Parameters **
      ** Error Fields/Message IDs/Message Data (arrays) From/To Caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr

      ** OK - Customer Number
     C                   PARM                    OKCUST

      ** Check if CGL132 is ON                                                                CGL132
     C                   CALL      'AOSARDR0'                                                 CGL132
     C                   PARM      *BLANKS       PRTCD                                        CGL132
     C                   PARM      '*VERIFY'     POPTN                                        CGL132
     C                   PARM      'CGL132'      PSARD                                        CGL132
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL132
                                                                                              CGL132
     C                   IF        PRTCD <> *BLANKS                                           CGL132
     C                             AND PRTCD <> '*NRF   '                                   MD026711
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL132
     C                   MOVEL     '901'         DBASE                                        CGL132
     C                   MOVEL     PSARD         DBKEY                                        CGL132
     C                   EXSR      *PSSR                                                      CGL132
     C                   ELSE                                                                 CGL132
     C                   IF        PRTCD = '*NRF   '                                        MD026711
     C                   EVAL      CGL132 = 'N'                                             MD026711
     C                   ELSE                                                               MD026711
     C                   EVAL      CGL132 = 'Y'                                               CGL132
     C                   ENDIF                                                              MD026711
     C                   ENDIF                                                                CGL132
                                                                                              CGL132
      **---------------------------------------------------------------
      ** Program, module, and procedure names for DB error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **---------------------------------------------------------------

      ** Key Lists

     C     KJACC         KLIST
     C                   KFLD                    KJANo
     C                   KFLD                    KCust
     C     KCustByTax    KLIST                                                              BUG23732
     C                   KFLD                    KCust                                      BUG23732
     C                   KFLD                    KCtax                                      BUG23732

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception subroutine.                        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR

     C                   DUMP

     C                   CALLB     'DBERRCTL'

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2004
