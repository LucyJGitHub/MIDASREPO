     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Annual Tax Deducted Statement - Driver')      *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG006100 - Midas CG Annual Tax Deducted Statement - Driver   *
      *                                                               *
      *  Function:  This program drives the Annual Tax Deducted       *
      *             Statement                                         *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER071             Date 01Aug16               *
      *                 CER070             Date 19Aug14               *
      *                 CER069             Date 03Jul14               *
      *                 CLE134             Date 01Aug12               *
      *                 CER059             Date 19Jul10               *
      *                 CER045             Date 20Jul09               *
      *                 BUG24767           Date 07Jul09               *
      *                 BUG24487           Date 23Jun09               *
      *                 BUG24244A          Date 15Jun09               *
      *                 BUG23971           Date 12May09               *
      *                 BUG23518B          Date 22Apr09               *
      *                 BUG23147           Date 02Mar09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 236129             Date 27Sep05               *
      *                 232543             Date 10Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER071 - BAIS - Legal Form field (Recompile)                 *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0 (Recompile)          *
      *  CER069 - German Tax Enhancement                              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank (Recompile)  *
      *  BUG24767 - Cannot request annual tax deducted statement      *
      *  BUG24487 - Annual Tax Deducted statements report and Confo   *
      *             extract should have the same output               *
      *  BUG24244A-  Customer Closed field is not populated on Annual *
      *              Tax Deducted Statement                           *
      *  BUG23971 - Cannot run SD000769 Annual Tax Deducted Statement *
      *  BUG23518B - Annual Tax Deducted Statement not produced       *
      *  BUG23147 - Program dump in component SDC000769               *
      *  236129 - Dump if customer is closed                          *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Function of Indicators                                       *
      *                                                               *
      *  U7+U8 - Database Error                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRMain     - Main program execution                          *
      *  SRRead     - Read Customer and Non-Account Holder File       *
      *  SRRtvCTS   - Retrieve Customer Tax Status                    *
      *  SRRtvNTS   - Retrieve Non-Account Holder Tax Status          *
      *  SRPrint    - Print Statement                                 *
      *  SRPush     - Push values on the stack                        *
      *  SRPop      - Pop (unwinds) values off the stack              *
      *  SRClear    - Clear stack                                     *
      *  SRAudit    - Audit Report Processing                         *
      *  *INZSR     - Program Initialisation Subroutine               *
      *  *PSSR      - Program Exception Subroutine                    *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDACUSL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Additional Customer Details Retrieval
 
     FSDNAHOL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Non-Account Holder Retrieval
 
     FSDACTXL4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD CTTX by Customer Retrieval
 
     FSDNHTXL4  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD NHTX by Non-Account Holder Reference Retrieval
      *                                                                                    BUG24244A
      ** Midas SD Customer Details Retrieval                                               BUG24244A
     FSDCUSTL1  IF   E           K DISK    INFSR(*PSSR)                                    BUG24244A
 
      ** SD Customer Income - Customer Number                                               BUG24487
     FSDCSINL2  IF   E           K DISK    INFSR(*PSSR)                                     BUG24487
                                                                                            BUG24487
      ** SD Customer Income - Non A/c Holder Reference                                      BUG24487
     FSDCSINL3  IF   E           K DISK    INFSR(*PSSR)                                     BUG24487
     F                                     RENAME(SDCSIND0:SDCSIND3)                        BUG24487
                                                                                            BUG24487
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named Constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data strucutre for access objects, short DS                                        BUG24767
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   BUG24767
                                                                                            BUG24767
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Data structure for access objects, second DS
      ** DS for access objects - long  data structure                                         236129
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     236129
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Data structure for SD Customer details file
 
     D DSPARM          DS
      ** Data Structure of Parameters Passed to CG006110
     D PTaxYear                1      4  0
     D PRef                    5     14
     D PRefInd                15     15
     D PRepName               16     35
     D PRepTown               36     45
     D PBranch                46     48                                                     BUG23147
     D PAcus                  49     49                                                     BUG23971
     D  PTaxYrF1              50     53                                                     BUG24487
     D  PTaxYrT1              54     57                                                     BUG24487
 
     D PDATA           DS           100
     D PClose                  1      1                                                    BUG24244A
     D PTaxYrEnt               1      4
     D  PTaxYrF                5      8                                                     BUG24487
     D  PTaxYrT                9     12                                                     BUG24487
     D  PCust                 13     18                                                     BUG24487
     D  PCustF                19     24                                                     BUG24487
     D  PCustT                25     30                                                     BUG24487
     D WStaxYr         S              6P 0                                                  BUG24487
     D WStaxYrA        S              6A                                                    BUG24487
     D WDdMm           S              4A                                                    BUG24487
     D WEtaxYr         S              6P 0                                                  BUG24487
     D WSYear          S              5P 0                                                  BUG24487
     D WEYear          S              5P 0                                                  BUG24487
     D TYear           S              4P 0                                                  BUG24487
     D WYear2          S              2P 0                                                  BUG24487
     D WJeyd           S              5P 0                                                  BUG24487
     D WWYeaR          S              2P 0                                                  BUG24487
     D WWYeaRS         S              2P 0                                                  BUG24487
     D WwYr            S              2P 0                                                  BUG24487
     D PZADate         S              7A                                                    BUG24487
     D PZDate          S              6P 0                                                  BUG24487
     D PZDatfm         S              1A                                                    BUG24487
     D PZDayNo         S              5P 0                                                  BUG24487
     D PTaxYR          S              4A                                                    BUG24487
      *                                                                                     BUG24487
     D PDateIn         S              6P 0                                                  BUG24487
     D PErr            S              1A                                                    BUG24487
     D PFlag           S              1A                                                    BUG24487
      *                                                                                    BUG24244A
      ** Data structure for SD Additional Customer details file                            BUG24244A
     D SDACUS        E DS                  EXTNAME(SDACUSPD)                               BUG24244A
      *                                                                                    BUG24244A
      ** Externally described DS for Bank details                                          BUG24244A
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                               BUG24244A
      *                                                                                     BUG24767
      ** Externally described DS for Location details                                       BUG24767
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                BUG24767
      *                                                                                     BUG24767
      ** Externally described DS for Country code details                                   BUG24767
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                                BUG24767
                                                                                            BUG24767
      *                                                                                    BUG24244A
      ** Copy books for ZDATE9                                                             BUG24244A
      *                                                                                    BUG24244A
     D/COPY ZSRSRC,ZDATE9Z1LE                                                              BUG24244A
     D/COPY ZSRSRC,ZDATE9Z2LE                                                              BUG24244A
 
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Program Parameters
     D PRetCde         S              7A
     D PRtCd           S              7A
     D POptn           S              7A
     D PCustNo         S             10A
     D PErrInf         S              7A
     D W0CMT           S              3A
     D WProduce        S              1A
     D WAUTO           S              1A
     D PCustN          S              6A                                                   BUG24244A
     D WYear           S              4A                                                   BUG24244A
     D @@DAYN          S              5P 0                                                 BUG24244A
 
      ** Standard CG Utility Parameters
     D PZSeq           S              5A
 
      ** Work Variables
     D WRecCnt         S             15S 0
     D WValue          S             10A
     D WPrint          S              1A
     D WYr             S              2A                                                    BUG24767
     D WYrP            S              2P 0                                                  BUG24767
     D WYrEnd          S              6P 0                                                  BUG24767
     D WYrEndP         S              5P 0                                                  BUG24767
     D PLoc            S              3A                                                    BUG24767
     D PCtry           S              2A                                                    BUG24767
 
     D/COPY CGCPYSRC,SRERRDLE
      ** Fields, Data Structures, and Arrays Definition for CG Error Processing
 
     D/COPY CGCPYSRC,CGAUDTDLE
      ** Fields, Data Structures, and Arrays Definition for CG Audit Processing
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------- Start of Main Processing -------------------+
      ** ¦                                                            ¦
      ** ¦  *INZSR is automatically executed at program activation.   ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Push the currently running routine into the stack.
 
     C                   EVAL      WValue = 'Main'
     C                   EXSR      SRPush
 
      ** Main Processing
      ** ===============
 
     C                   EXSR      SRMain
 
      ** Audit Processing
      ** ================
 
     C                   EXSR      SRAudit
 
      ** Pop values off the stack.
 
     C                   EXSR      SRPop
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMain - Main program execution                              *
      *                                                               *
      *****************************************************************
     C     SRMain        BEGSR
 
     C                   EVAL      WValue = 'SRMain'
     C                   EXSR      SRPush
 
      ** If Extract for "Closed" Customers                                                 BUG24244A
      *                                                                                    BUG24244A
     C                   IF        PClose = 'Y'                                            BUG24244A
     C                   EXSR      SRClose                                                 BUG24244A
     C                   ELSE                                                              BUG24244A
      *                                                                                    BUG24244A
      ** for Active/Deleted Customers                                                      BUG24244A
      *                                                                                    BUG24244A
     C                   EXSR      SRRead
     C                   ENDIF                                                             BUG24244A
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                    BUG24244A
      *                                                               *                    BUG24244A
      *  SRClose - Closed Customer Processing                         *                    BUG24244A
      *                                                               *                    BUG24244A
      *  Called by : SRMain                                           *                    BUG24244A
      *                                                               *                    BUG24244A
      *  Calls     : SRRtvCTS                                         *                    BUG24244A
      *****************************************************************                    BUG24244A
     C     SRClose       BEGSR                                                             BUG24244A
      *                                                                                    BUG24244A
     C                   EVAL      WValue = 'SRClose'                                      BUG24244A
     C                   EXSR      SRPush                                                  BUG24244A
      *                                                                                    BUG24244A
     C                   EVAL      WRecCnt = *ZEROS                                        BUG24244A
      *                                                                                    BUG24244A
      ** Read Customer File                                                                BUG24244A
      *                                                                                    BUG24244A
     C     *LOVAL        SETLL     SDCUSTL1                                                BUG24244A
     C                   READ      SDCUSTL1                                                BUG24244A
                                                                                           BUG24244A
     C                   DOW       NOT %EOF                                                BUG24244A
      *                                                                                    BUG24244A
      ** If Customer Closed "Today"                                                        BUG24244A
      *                                                                                    BUG24244A
     C                   IF        BBCLDT = BJRDNB                                         BUG24244A
      *                                                                                    BUG24244A
      ** Retrieve Customer Closure 'Year'                                                  BUG24244A
      *                                                                                    BUG24244A
     C                   Z-ADD     BBCLDT        @@DAYN                                    BUG24244A
     C                   Z-ADD     *ZEROS        @@VDT                                     BUG24244A
      *                                                                                    BUG24244A
     C                   EXSR      ZDATE9                                                  BUG24244A
      *                                                                                    BUG24244A
      ** Save 'Year'                                                                       BUG24244A
      *                                                                                    BUG24244A
     C                   MOVEL     @@VDT         WYear                                     BUG24244A
      *                                                                                    BUG24244A
      ** Retrieve customer tax status                                                      BUG24244A
      *                                                                                    BUG24244A
     C                   EXSR      SRRtvCTS                                                BUG24244A
      *                                                                                    BUG24244A
     C                   ENDIF                                                             BUG24244A
      *                                                                                    BUG24244A
     C                   READ      SDCUSTL1                                                BUG24244A
      *                                                                                    BUG24244A
     C                   ENDDO                                                             BUG24244A
      *                                                                                    BUG24244A
     C                   EXSR      SRPop                                                   BUG24244A
      *                                                                                    BUG24244A
     C                   ENDSR                                                             BUG24244A
      *****************************************************************                    BUG24244A
      /EJECT                                                                               BUG24244A
      *****************************************************************
      *                                                               *
      *  SRRead - Read Customer and Non-Account Holder File           *
      *                                                               *
      *****************************************************************
     C     SRRead        BEGSR
 
     C                   EVAL      WValue = 'SRRead'
     C                   EXSR      SRPush
 
     C                   EVAL      WRecCnt = *ZERO
 
      ** Read customers file
      ** ===================
 
     C     *LOVAL        SETLL     SDACUSL1
     C                   READ      SDACUSL1
 
     C                   DOW       NOT %EOF
      *                                                                                     BUG24487
     C                   IF        (PCust = *BLANKS  AND                                    BUG24487
     C                             PCustF = *BLANKS AND                                     BUG24487
     C                             PCustT = *BLANKS)  OR                                    BUG24487
     C                             (PCust <> *BLANKS  AND                                   BUG24487
     C                             E5CUST = PCUST) OR                                       BUG24487
     C                             (PCust = *BLANKS AND                                     BUG24487
     C                             PCustF <= E5CUST AND                                     BUG24487
     C                             PCustT >= E5CUST)                                        BUG24487
      *                                                                                     BUG24487
     C                   MOVE      'N'           XRCDFD            1                        BUG24487
     C     E5CUST        CHAIN     SDCSINL2                           90                    BUG24487
     C                   DOW       *IN90 = *OFF                                             BUG24487
     C                   IF        TSRDNB >= WSYear AND                                     BUG24487
     C                             TSRDNB <= WEYear AND                                     BUG24487
     C                             TSSTAT = 'T'                                             BUG24487
     C                   MOVE      'Y'           XRCDFD            1                        BUG24487
     C                   LEAVE                                                              BUG24487
      *                                                                                     BUG24487
     C                   ENDIF                                                              BUG24487
     C     E5CUST        READE     SDCSINL2                               90                BUG24487
      *                                                                                     BUG24487
     C                   ENDDO                                                              BUG24487
 
      ** Retrieve customer tax status
 
     C     XRCDFD        IFEQ      'Y'                                                      BUG24487
     C                   EXSR      SRRtvCTS
     C                   ENDIF                                                              BUG24487
      *                                                                                     BUG24487
     C                   ENDIF                                                              BUG24487
 
     C                   READ      SDACUSL1
     C                   ENDDO
 
      ** Read non-account holders file
      ** =============================
 
     C     *LOVAL        SETLL     SDNAHOL1
     C                   READ      SDNAHOL1
 
     C                   DOW       NOT %EOF
      *                                                                                     BUG24487
     C                   MOVE      'N'           XRCDFD            1                        BUG24487
     C     NHNAHO        CHAIN     SDCSINL3                           90                    BUG24487
     C                   DOW       *IN90 = *OFF                                             BUG24487
     C                   MOVE      TSJOIN        WJOINA            6                        BUG24487
     C                   IF        TSRDNB >= WSYear AND                                     BUG24487
     C                             TSRDNB <= WEYear AND                                     BUG24487
     C                             TSSTAT = 'T' AND                                         BUG24487
     C                             (PCust = *BLANKS  AND                                    BUG24487
     C                             PCustF = *BLANKS AND                                     BUG24487
     C                             PCustT = *BLANKS)  OR                                    BUG24487
     C                             (PCust <> *BLANKS  AND                                   BUG24487
     C                             WJOINA = PCust) OR                                       BUG24487
     C                             (PCust = *BLANKS AND                                     BUG24487
     C                             PCustF <= WJOINA AND                                     BUG24487
     C                             PCustT >= WJOINA)                                        BUG24487
     C                   MOVE      'Y'           XRCDFD                                     BUG24487
     C                   LEAVE                                                              BUG24487
     C                   ENDIF                                                              BUG24487
     C     NHNAHO        READE     SDCSINL3                               90                BUG24487
     C                   ENDDO                                                              BUG24487
 
      ** Retrieve non-account holder tax status
 
     C     XRCDFD        IFEQ      'Y'                                                      BUG24487
     C                   EXSR      SRRtvNTS
     C                   ENDIF                                                              BUG24487
 
     C                   READ      SDNAHOL1
     C                   ENDDO
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvCTS - Retrieve customer tax status in every             *
      *             country of tax                                    *
      *                                                               *
      *****************************************************************
     C     SRRtvCTS      BEGSR
 
     C                   EVAL      WValue = 'SRRtvCTS'
     C                   EXSR      SRPush
 
     C                   EVAL      WPrint = 'N'
 
     C                   IF        PClose = 'Y'                                            BUG24244A
     C                   MOVE      WYear         PTaxYear                                  BUG24244A
     C                   ELSE                                                              BUG24244A
     C                   MOVE      PTaxYrEnt     PTaxYear
     C                   ENDIF                                                             BUG24244A
      *                                                                                    BUG24244A
     C                   IF        PClose = 'Y'                                            BUG24244A
     C                   EVAL      PRef = BBCUST                                           BUG24244A
     C                   ELSE                                                              BUG24244A
     C                   EVAL      PRef = E5CUST
     C                   ENDIF                                                             BUG24244A
      *                                                                                    BUG24244A
     C                   EVAL      PRefInd = 'C'
 
     C                   IF        PClose <> 'Y'                                           BUG24244A
     C                   EXSR      SRRRepDet
     C                   EVAL      PRepName = BBCRNM                                       BUG24244A
     C                   EVAL      PRepTown = BBCRTN                                       BUG24244A
     C                   ELSE                                                              BUG24244A
     C                   EVAL      PRepName = BBCRNM
     C                   EVAL      PRepTown = BBCRTN
     C                   ENDIF                                                             BUG24244A
      *                                                                                    BUG24244A
     C                   IF        PClose = 'Y'                                            BUG24244A
      *                                                                                    BUG24244A
     C                   CALL      'AOACUSR0'                                              BUG24244A
     C                   PARM      *BLANKS       PRtcd                                     BUG24244A
     C                   PARM      '*KEY'        POptn                                     BUG24244A
     C                   PARM      PRef          PCustN                                    BUG24244A
     C     SDACUS        PARM      SDACUS        DSLDY                                     BUG24244A
      *                                                                                    BUG24244A
     C                   IF        PRtcd = *BLANKS OR                                      BUG24244A
     C                             PRtcd = '*CUSCLO'                                       BUG24244A
     C                   EVAL      PAcus = 'Y'                                              BUG23971
     C                   ENDIF                                                             BUG24244A
      *                                                                                    BUG24244A
     C                   ELSE                                                              BUG24244A
     C                   EVAL      PAcus = 'Y'                                              BUG23971
     C                   ENDIF                                                             BUG24244A
 
     C     E5CUST        SETLL     SDACTXL4
     C     E5CUST        READE     SDACTXL4
 
     C                   DOW       NOT %EOF
 
      ***Print*statement when tax status is 'S'                                               232543
      ** Print statement when tax status is 'T'                                               232543
 
     C**********         IF        AXETXS = 'S'                                               232543
     C                   IF        AXETXS = 'T'                                               232543
     C                             OR AXETXS = 'Y'                                            CER069
     C                   EVAL      WPrint = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C     E5CUST        READE     SDACTXL4
     C                   ENDDO
 
     C                   IF        WPrint = 'Y'
     C                   EXSR      SRPrint
     C                   EVAL      WRecCnt = WRecCnt + 1
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvNTS - Retrieve non-account holder tax status in         *
      *             every country of tax                              *
      *                                                               *
      *****************************************************************
     C     SRRtvNTS      BEGSR
 
     C                   EVAL      WValue = 'SRRtvNTS'
     C                   EXSR      SRPush
 
     C                   EVAL      WPrint = 'N'
 
     C                   MOVE      PTaxYrEnt     PTaxYear
     C                   EVAL      PRef = NHNAHO
     C                   EVAL      PRefInd = 'N'
     C                   EVAL      PRepName = NHNARN
     C                   EVAL      PRepTown = NHNATW
     C                   EVAL      PAcus = 'N'                                              BUG23971
 
     C     NHNAHO        SETLL     SDNHTXL4
     C     NHNAHO        READE     SDNHTXL4
 
     C                   DOW       NOT %EOF
 
      ***Print*statement when tax status is 'S'                                               232543
      ** Print statement when tax status is 'T'                                               232543
 
     C**********         IF        NXETXS = 'S'                                               232543
     C                   IF        NXETXS = 'T'                                               232543
     C                             OR NXETXS = 'Y'                                            CER069
     C                   EVAL      WPrint = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C     NHNAHO        READE     SDNHTXL4
     C                   ENDDO
 
     C                   IF        WPrint = 'Y'
     C                   EXSR      SRPrint
     C                   EVAL      WRecCnt = WRecCnt + 1
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrint - Print Statement                                    *
      *                                                               *
      *****************************************************************
     C     SRPrint       BEGSR
 
     C                   EVAL      PBranch = BBBRCD                                         BUG23147
     C                   EVAL      WValue = 'SRPrint'
     C                   EXSR      SRPush
     C                   MOVE      PTaxYrF       PTaxYrF1                                   BUG24487
     C                   MOVE      PTaxYrT       PTaxYrT1                                   BUG24487
 
     C                   CALL      'CG006110'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    W0CMT
     C                   PARM                    WProduce
     C                   PARM                    WAUTO
     C                   PARM                    DSPARM
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'CG006110'
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBase = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPush - Push values on the stack                            *
      *                                                               *
      *****************************************************************
     C     SRPush        BEGSR
 
     C                   EVAL      Q = Q + 1
     C                   EVAL      @STK(Q) = WValue
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPop - Pop (unwind) values off the stack                    *
      *                                                               *
      *****************************************************************
     C     SRPop         BEGSR
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   EVAL      Q = Q - 1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClear - Clear stack                                        *
      *                                                               *
      *****************************************************************
     C     SRClear       BEGSR
 
     C                   MOVEA     *BLANKS       @STK(1)
     C                   EVAL      Q = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRRepDet - Retrieve Report Details                          *
      *                                                               *
      *****************************************************************
     C     SRRRepDet     BEGSR
 
     C                   EVAL      WValue = 'SRRRepDet'
     C                   EXSR      SRPush
 
     C                   MOVEL     E5CUST        PCustNo
 
     C**********         CALL      'AOCUSTR0'                                                 236129
     C                   CALL      'AOCUSTR1'                                                 236129
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCustNo
     C                   PARM      *BLANKS       PErrInf
     C*****SDCUST        PARM      SDCUST        DSSDY                                        236129
     C     SDCUST        PARM      SDCUST        DSLDY                                        236129
 
     C**********         IF        PRtcd <> *Blanks                                           236129
     C**********         IF        PRtcd <> *Blanks and BBCLST <> 'Y'               236129 BUG23518B
     C                   IF        PRtcd <> *BLANKS AND                                    BUG23518B
     C                             BBCLST <> 'Y' AND                                       BUG23518B
     C                             BBDTDL = *ZEROS                                         BUG23518B
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBase = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Audit Report Processing                            *
      *                                                               *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C                   EVAL      WValue = 'SRAudit'
     C                   EXSR      SRPush
 
      ** Output the count of records read.
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG006100'    I#REF
     C                   MOVEL     'CGD1909'     I#TITL
     C                   MOVEL     'CGD1910'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVEL     *BLANKS       I#SUB
     C                   MOVEL     'SDACUSPD'    I#SUB
     C                   MOVEL     'CAD1021'     I#TEXT
     C                   Z-ADD     WRecCnt       I#QTY
     C                   Z-ADD     *ZERO         I#DECS
     C                   MOVEL     '1'           I#EDIT
 
      ** Write a line of text.
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*LINE   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
      ** Skip a line.
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*SKIP   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
      ** Produce the Audit Report.
 
      ** Close the Audit printer file.
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG006120'    I#REF
     C                   MOVEL     'CGD1909'     I#TITL
     C                   MOVEL     'CGD1910'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
     C                   MOVEL     'CAD1008'     I#TEXT
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*CLOSE  '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
     C                   EXSR      SRPop
 
     C                   ENDSR
      *****************************************************************                     BUG24487
      /EJECT                                                                                BUG24487
      *****************************************************************                     BUG24487
      *                                                               *                     BUG24487
      *  SRZDate - Subroutine to convert day no to date               *                     BUG24487
      *                                                               *                     BUG24487
      *  Called By :                                                  *                     BUG24487
      *                                                               *                     BUG24487
      *  Calls : None                                                 *                     BUG24487
      *                                                               *                     BUG24487
      *****************************************************************                     BUG24487
     C     SRZDate       BEGSR                                                              BUG24487
      *                                                                                     BUG24487
     C                   CALL      'ZDATE2'                                                 BUG24487
     C                   PARM                    PZDayNo                                    BUG24487
     C                   PARM      BJDFIN        PZDatfm                                    BUG24487
     C                   PARM                    PZDate                                     BUG24487
     C                   PARM                    PZADate                                    BUG24487
      *                                                                                     BUG24487
     C                   ENDSR                                                              BUG24487
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Subroutine                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Entry Parameters
      ** ================
 
     C     *ENTRY        PLIST
 
      ** Return Code
     C                   PARM                    PRetCde
     C                   PARM                    W0CMT
     C                   PARM                    PDATA
      *                                                                                    BUG24244A
      ** Bank Details                                                                      BUG24244A
      *                                                                                    BUG24244A
     C                   CALL      'AOBANKR0'                                              BUG24244A
     C                   PARM      *BLANKS       PRtcd                                     BUG24244A
     C                   PARM      '*FIRST '     POptn                                     BUG24244A
     C     SDBANK        PARM      SDBANK        DSSDY                                     BUG24244A
      *                                                                                    BUG24244A
     C                   IF        PRtcd <> *Blanks                                        BUG24244A
     C     *LOCK         IN        LDA                                                     BUG24244A
     C                   EVAL      DBKey = POptn                                           BUG24244A
     C                   EVAL      DBFile = 'SDBANKPD'                                     BUG24244A
     C                   EVAL      DBase = 001                                             BUG24244A
     C                   OUT       LDA                                                     BUG24244A
     C                   EXSR      *PSSR                                                   BUG24244A
     C                   ENDIF                                                             BUG24244A
      *                                                                                     BUG24767
      ** Access location code                                                               BUG24767
      *                                                                                     BUG24767
     C                   CALL      'AOLOCNR0'                                               BUG24767
     C                   PARM      *BLANKS       PRtcd                                      BUG24767
     C                   PARM      '*KEY'        POptn                                      BUG24767
     C                   PARM      BJSLCD        PLoc                                       BUG24767
     C     SDLOCN        PARM      SDLOCN        DSFDY                                      BUG24767
      *                                                                                     BUG24767
      ** Database error                                                                     BUG24767
      *                                                                                     BUG24767
     C                   IF        PRtcd <> *BLANKS                                         BUG24767
     C     *LOCK         IN        LDA                                                      BUG24767
     C                   EVAL      DBKey = PLoc                                             BUG24767
     C                   EVAL      DBFile = 'SDLOCNPD'                                      BUG24767
     C                   EVAL      DBase = 003                                              BUG24767
     C                   OUT       LDA                                                      BUG24767
     C                   EXSR      *PSSR                                                    BUG24767
     C                   ENDIF                                                              BUG24767
      *                                                                                     BUG24767
      ** Access country codes                                                               BUG24767
      *                                                                                     BUG24767
     C                   CALL      'AOCTRYR0'                                               BUG24767
     C                   PARM      *BLANKS       PRtcd                                      BUG24767
     C                   PARM      '*KEY'        POptn                                      BUG24767
     C                   PARM      DVCNCD        PCtry                                      BUG24767
     C     SDCTRY        PARM      SDCTRY        DSFDY                                      BUG24767
      *                                                                                     BUG24767
      ** Database error                                                                     BUG24767
      *                                                                                     BUG24767
     C                   IF        PRtcd <> *BLANKS                                         BUG24767
     C     *LOCK         IN        LDA                                                      BUG24767
     C                   EVAL      DBKey = PCtry                                            BUG24767
     C                   EVAL      DBFile = 'SDCTRYPD'                                      BUG24767
     C                   EVAL      DBase = 004                                              BUG24767
     C                   OUT       LDA                                                      BUG24767
     C                   EXSR      *PSSR                                                    BUG24767
      *                                                                                     BUG24767
      ** Retrieve end of tax year                                                           BUG24767
      *                                                                                     BUG24767
     C                   ELSE                                                               BUG24767
     C                   IF        A4ETXY <> *ZERO                                          BUG24767
     C     2             SUBST     BJMRDT:6      WYr                                        BUG24767
     C                   MOVE      WYr           WYrP                                       BUG24767
     C                   MOVE      WYrP          WYrEnd                                     BUG24767
     C                   MOVEL     A4ETXY        WYrEnd                                     BUG24767
     C                   CALL      'ZDATE1'                                                 BUG24767
     C                   PARM      *BLANKS       PErr                                       BUG24767
     C                   PARM                    WYrEnd                                     BUG24767
     C                   PARM                    BJDFIN                                     BUG24767
     C                   PARM      *ZEROS        PZDayNo                                    BUG24767
     C                   Z-ADD     PZDAYNO       WYrEndP                                    BUG24767
     C                   IF        WYrEndP < BJRDNB                                         BUG24767
     C                   ADD       1             WYrP                                       BUG24767
     C                   MOVE      WYrP          WYrEnd                                     BUG24767
     C                   CALL      'ZDATE1'                                                 BUG24767
     C                   PARM      *BLANKS       PErr                                       BUG24767
     C                   PARM                    WYrEnd                                     BUG24767
     C                   PARM                    BJDFIN                                     BUG24767
     C                   PARM      *ZEROS        PZDayNo                                    BUG24767
     C                   Z-ADD     PZDAYNO       WYrEndP                                    BUG24767
     C                   ENDIF                                                              BUG24767
     C                   ENDIF                                                              BUG24767
     C                   ENDIF                                                              BUG24767
                                                                                            BUG24767
 
      ** Set the program name.
 
     C                   MOVEL     ##PGM         DBPgm
 
      ** Open the Audit printer file.
 
     C                   CLEAR                   I#DTA
     C                   MOVEL     'CG006120AU'  I#SPLN
     C                   MOVEL     'CG006120'    I#REF
     C                   MOVEL     'CGD1909'     I#TITL
     C                   MOVEL     'CGD1910'     I#TUL
     C                   MOVEL     'CGUSRMSG'    I#FILE
 
     C                   CALL      'CGZAUDIT'
     C                   PARM      *BLANKS       W0RTN
     C                   PARM      '*OPEN   '    W0ACT
     C                   PARM                    I#DTA
     C                   PARM                    PZSeq
 
      ** Clear stack.
 
     C                   EXSR      SRClear
      *                                                                                     BUG24487
      ** Calculate "Start" and "End" Date of Year only when Year is                         BUG24487
      ** entered                                                                            BUG24487
      *                                                                                     BUG24487
     C                   IF        PTaxYrEnt <> *BLANKS                                     BUG24487
     C                             OR (PTaxYrF <> *BLANKS AND                               BUG24487
     C                             PTaxYrT <> *BLANKS)                                      BUG24487
      *                                                                                     BUG24487
     C                   IF        PTaxYrEnt <> *BLANKS                                     BUG24487
     C                   MOVE      PTaxYrEnt     WWYeaR                                     BUG24487
     C                   MOVE      PTaxYrEnt     WWYeaRS                                    BUG24487
     C                   ELSE                                                               BUG24487
     C                   IF        PTaxYrF <> *BLANKS AND                                   BUG24487
     C                             PTaxYrT <> *BLANKS                                       BUG24487
     C                   MOVE      PTaxYrT       WWYeaR                                     BUG24487
     C                   MOVE      PTaxYrF       WWYeaRS                                    BUG24487
     C                   ENDIF                                                              BUG24487
     C                   ENDIF                                                              BUG24487
      *                                                                                     BUG24487
     C**********         EVAL      PZDayNo = BJEYD                                 BUG24487 BUG24767
     C                   EVAL      PZDayNo = WYrEndP                                        BUG24767
     C                   EXSR      SRZDate                                                  BUG24487
     C                   MOVE      PZDate        WwYr                                       BUG24487
      *                                                                                     BUG24487
     C                   IF        WWYeaR <> WwYr                                           BUG24487
      *                                                                                     BUG24487
     C                   EVAL      WETaxYr = PZDate                                         BUG24487
     C                   MOVE      WWYeaR        WETaxYr                                    BUG24487
      *                                                                                     BUG24487
      ** Convert the End of Year Date No. to DDMMYY format                                  BUG24487
      *                                                                                     BUG24487
     C                   MOVEL     WETaxYr       PDateIn                                    BUG24487
      *                                                                                     BUG24487
     C                   CALL      'ZDATE1'                                                 BUG24487
     C                   PARM      *BLANKS       PErr                                       BUG24487
     C                   PARM                    PDateIn                                    BUG24487
     C                   PARM                    BJDFIN                                     BUG24487
     C                   PARM      *ZEROS        PZDayNo                                    BUG24487
      *                                                                                     BUG24487
     C                   EVAL      WEYear = PZDayNo                                         BUG24487
      *                                                                                     BUG24487
     C                   ELSE                                                               BUG24487
      *                                                                                     BUG24487
     C**********         EVAL      WEYear = BJEYD                                  BUG24487 BUG24767
     C                   EVAL      WEYear = WYrEndP                                         BUG24767
      *                                                                                     BUG24487
     C                   ENDIF                                                              BUG24487
      *                                                                                     BUG24487
     C**********         EVAL      WJeyd = BJEYD + 1                               BUG24487 BUG24767
     C                   EVAL      WJeyd = WYrEndP + 1                                      BUG24767
      *                                                                                     BUG24487
      ** Convert the End of Year + 1 to DDMMYY format                                       BUG24487
      *                                                                                     BUG24487
     C                   EVAL      PZDayNo = WJeyd                                          BUG24487
     C                   EXSR      SRZDate                                                  BUG24487
     C                   EVAL      WStaxYr = PZDate                                         BUG24487
     C                   MOVEL     WStaxYr       WStaxYrA                                   BUG24487
     C                   EVAL      WDdMm = %SUBST(WStaxYrA:1:4)                             BUG24487
      *                                                                                     BUG24487
     C                   IF        WWYeaRS <= 39                                            BUG24487
     C                   MOVEL     20            TYear                                      BUG24487
     C                   ELSE                                                               BUG24487
     C                   MOVEL     19            TYear                                      BUG24487
     C                   ENDIF                                                              BUG24487
      *                                                                                     BUG24487
     C                   MOVE      WWYeaRS       TYear                                      BUG24487
      *                                                                                     BUG24487
     C                   IF        WDdMm <> '0101'                                          BUG24487
     C                   EVAL      TYear = TYear - 1                                        BUG24487
     C                   ENDIF                                                              BUG24487
      *                                                                                     BUG24487
     C                   MOVE      TYear         WYear2                                     BUG24487
     C                   MOVE      WYear2        WSTaxYr                                    BUG24487
      *                                                                                     BUG24487
      ** Convert the Start of Year in DDYYMM format into Day No                             BUG24487
      *                                                                                     BUG24487
     C                   MOVEL     WSTaxYr       PDateIn                                    BUG24487
      *                                                                                     BUG24487
     C                   CALL      'ZDATE1'                                                 BUG24487
     C                   PARM      *BLANKS       PErr                                       BUG24487
     C                   PARM                    PDateIn                                    BUG24487
     C                   PARM                    BJDFIN                                     BUG24487
     C                   PARM      *ZEROS        PZDayNo                                    BUG24487
      *                                                                                     BUG24487
     C                   EVAL      WSYear = PZDayNo                                         BUG24487
      *                                                                                     BUG24487
     C                   ENDIF                                                              BUG24487
      *                                                                                     BUG24487
 
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY CGCPYSRC,SRERRCLE
      /EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
      /EJECT
     C/COPY ZSRSRC,ZDATE9Z3LE                                                              BUG24244A
     C/EJECT                                                                               BUG24244A
      *****************************************************************
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN                     BUG24244A
00366007310109601461                                                                       BUG24244A
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                        BUG24244A
00000000310005900090001200015100181002120024300273003040033400365                          BUG24244A
