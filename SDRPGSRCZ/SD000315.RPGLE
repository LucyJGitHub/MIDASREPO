     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD CRS Normal Cust/NAHO Classfn Upd-Main')       *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000315 - CRS Normal Customer/NAHO Classification Update    *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD050772           Date 28May18               *
      *  Prev Amend No. MD050775           Date 12May18               *
      *                 CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD050772 - Duplicate entries appears when running the normal *
      *             accounts tool in Information Mode                 *
      *  MD050775 - When pressing F11, the screen refreshed and       *
      *             inputs became blank                               *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
     FSD000315DFCF   E             WORKSTN INFSR(*PSSR)

      ** CRS Customers for Classfn Update - List
     FSDCRSHL0  UF   E           K DISK
     FSDCRSHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A)
     F                                     RENAME(SDCRSHD0:SDCRSHD1)

      ** CRS Non-Account Holders for Classfn Update - List
     FSDCRNHL0  UF   E           K DISK

      ** Normal CRS Customers Classfn Update File - Driver
     FSDCRNAL0  UF A E             DISK

      ** Main Customer Details File - Keyed
     FSDCUSTL0  IF   E           K DISK

      ** Main Non-Account Holders File - Keyed
     FSDNAHOL0  IF   E           K DISK

      ** Joint Accounts by Customer
     FSDJACCL4  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Joint Accounts by Non Account Holder
     FSDJACCL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDJACCD0:SDJACCD1)

      ** CRS Customer - Countries File
     FSDCRSDL2  IF   E           K DISK

      ** CRS Non-Account Holder - Countries File
     FSDCRSNL2  IF   E           K DISK

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D DSLDY         E DS                  EXTNAME(DSLDY)

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

      ** External DS for Bank Details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDSVAL        E DS                  EXTNAME(SDSVALPD)
     D SCRN_WVAL     E DS                  EXTNAME(SD000315DF:SD000315D0)
     D                                     PREFIX(W)
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Non-Account Holders File
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
      ** External DS for Country of Tax Codes
     D SDCTTX        E DS                  EXTNAME(SDCTTXPD)

     D WMsgLen         S             15P 5 INZ(70)
     D ##OV1           S             70    DIM(1) CTDATA PERRCD(1)
     D ##OV2           S             70    DIM(1) CTDATA PERRCD(1)
      *
     D Mode            S              7A
     D Step            S              7A
     D ReturnDS        DS
     D RetCode                        7A
     D ClsCode                        5A
     D ClsDesc                       50A
      *
     D DetMode         S              1A
     D DetRetCode      S              7A
     D DetClsCode      S              5A

      ** Data structure for AOSVALR0 string
     D P@VL01          DS           200
     D  WCRSForTINMan          1      1
     D P@VL02          DS           200
     D  WCRSLocTINMan          1      1
     D P@VL03          DS           200
     D  WDftClsNew             1      5
     D P@VL04          DS           200
     D  WEffStrDate            1      6
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** The Following /COPY Line Includes All The Defined Fields In
      ** the PSDS.  They Have Meaningful Names, Prefixed By 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WSFlRRN         S              4  0
     D WValErr         S              1
     D RtvInvoked      S              1
     D PRetCode        S              7    INZ(*Blanks)
     D POption         S              7    INZ(*Blanks)
     D PCustNo         S              6    INZ(*Blanks)
     D Recursive       S              1    INZ('N')
     D PError          S              7A
     D PDate           S              6  0
     D PDateFormat     S              1A
     D PDayNo          S              5  0
     D WVal            S              1
      *
     D ZAPGM           S             10    INZ('SD000315')
     D ZAPGRL          S              5    INZ(*Blanks)
     D ZAMSID          S              7    INZ(*Blanks)
     D ZAMSGF          S             10    INZ(*Blanks)
     D ZAMSDA          S            132    INZ(*Blanks)
     D ZAMSTP          S              7    INZ(*Blanks)
      *
     D WDftClsDesc     S             50A   INZ(*Blanks)
     D WClsCdValKey    S              5A   INZ(*Blanks)
     D WClsCdValCod    S              5A   INZ(*Blanks)
     D WClsCdValDsc    S             50A   INZ(*Blanks)

     D UsrActn         S              1A   INZ(*Blanks)
     D IsUsrAuth       S              1A   INZ('N')
     D InpRevwOK       S              1  0 INZ(0)
     D DrvLoaded       S              1  0 INZ(0)
     D PrcComplete     S              1  0 INZ(0)
     D IsFileLocked    S              1A   INZ('N')
     D LckRlsFlag      S              5A

     D CTRChk          S              1A   INZ(*Blanks)
     D JACChk          S              1A   INZ(*Blanks)
     D WDDCRSA         S              1A
     D WPCTRT          S              2A
     D WPCTRR          S              2A
     D WCNCD           S              2A
     D WCOLC           S              2A
     D NAINFC          S              1A
     D NAINFN          S              1A

      ** Parameter for AOCUSTR0
     D PKey1           S             10A
     D PKySt           S              7A

      ** Access Object Parameters
     D PRTCD           S              7A
     D POPTN           S              7A
     D PNAHO           S             10A

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** System value for CRS Foreign TIN Mandatory
     DWSysVal1         C                   'CRSForTINMandatory'
      ** System value for CRS Local TIN Mandatory
     DWSysVal2         C                   'CRSLocalTINMandatory'
      ** System value Default Classification for New Customers
      ** and Non-account Holders
     DWSysVal3         C                   'FATCADftCLsNewCustNH'
      ** System value CRS Effective Date
     DWSysVal4         C                   'CRSEffectStartDate'
      ** Exemption remark
     DWExemRem         C                   'Updated by Customer Type-
     D                                      and Allocation Electronic Tool'
      *****************************************************************
      *                                                               *
      * M A I N   P R O C E D U R E                                   *
      *                                                               *
      *****************************************************************
      *
     C                   EVAL      WVal = ' '
     C                   DOW       Step <> 'T'
      *
      ** Input New Classification Codes
      *
     C                   IF        Step = 'I'
     C                   EXSR      GetInputs
     C                   ENDIF
      *
      ** Customers / Non-Account Holders Driver File Load Loop
      *
     C                   IF        Step = 'D'
     C                   EXSR      LoadDriver
     C                   ENDIF
      *
      ** Generate Report
      *
     C                   IF        Step = 'P'
     C                   IF        (IsFileLocked = 'N' and  USRACTN = 'U')
     C                             OR (USRACTN = 'Z')
     C                   EXSR      GenReptUpd
     C                   ELSE
     C                   EVAL      Step = 'I'
     C                   ENDIF
     C                   ENDIF
      *
      ** Display List Screen
      *
     C                   IF        Step = 'L'
     C                   EXSR      ListScreen
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        LckRlsFlag = '*LOCK'
     C                   EVAL      LckRlsFlag = '*RLS '
     C                   EXSR      ChkFileLck
     C                   ENDIF
      *
      ** End Program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      /EJECT
      *
      *****************************************************************
      *                                                               *
      * S U B R O U T I N E S                                         *
      *                                                               *
      *****************************************************************
      *
      *******************************************************************
      *                                                                 *
      * GetInputs - Prompts the following inputs from user              *
      *                                                                 *
      *             For Customers with High Value Indicator = 'L'       *
      *             + New CRS Information Complete Flag                 *
      *                                                                 *
      *             For Customers with High Value Indicator = 'M'       *
      *             + New CRS Information Complete Flag                 *
      *******************************************************************
      *
     C     GetInputs     BEGSR
      *
      ** If input fields have already been set.
      *
     C                   EVAL      WValErr = '1'
     C                   EVAL      InpRevwOK = 0
     C                   EXSR      RstScrnInd
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
      *
      ** Do While - validation fails and main menu / previous not invoked
      *
     C**********         DOW       (WValErr = '1'                                           MD050772
     C**********                   or InpRevwOK = 0)                                        MD050772
     C                   DOW       WValErr = '1'                                            MD050772
     C                             and *INKC = *OFF
     C                             and *INKJ = *OFF

     C                   EXSR      RstScrnInd
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
     C                   EVAL      WValErr = ' '                                            MD050775
     C                   IF        WVal = 'Y'
     C                   EXSR      ValInput
     C                   ENDIF
     C                   EVAL      WVal = 'Y'
      **
     C                   IF        *INKM = *ON and InpRevwOK = 1
     C                             and WValErr <> '1'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0285'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   ENDIF

     C                   WRITE     SD000315F0
     C                   EXFMT     SD000315D0
      **
     C                   IF        *INKM = *ON and InpRevwOK = 0
     C                   EVAL      WValErr = '1'
     C                   ENDIF
     C                   IF        WNAINF1 <> NAINF1
     C                             or WNAINF2 <> NAINF2
     C                   EVAL      InpRevwOK = 0
     C                   ELSE
     C                   EVAL      InpRevwOK = 1
     C                   ENDIF
      **
     C                   ENDDO
      **
     C                   IF        (*INKK = *ON or *INKM = *ON)
     C                   EXSR      ChkUsrAuth
     C                   EVAL      Step = 'D'
     C                   ENDIF
      **
     C                   IF        *INKC = *ON or *INKJ = *ON
     C                   EVAL      Step = 'T'
     C                   ENDIF

     C     GetInputsE    ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * ChkUsrAuth - Check User Authority to Action                     *
      *                                                                 *
      *******************************************************************
      *
     C     ChkUsrAuth    BEGSR
     C                   EVAL      UsrActn = *BLANKS
     C                   IF        *INKK = *ON
     C                   EVAL      UsrActn = 'Z'
     C                   ELSEIF    *INKM = *ON
     C                   EVAL      UsrActn = 'U'
     C                   ENDIF

     C                   ENDSR
      *
      /EJECT
      *******************************************************************
      *                                                                 *
      * GenReptUpd - Generate Reports and Update Database               *
      *                                                                 *
      *******************************************************************
      *
     C     GenReptUpd    BEGSR
      *
     C                   CALL      'SD000317'
     C                   PARM      UsrActn       PMode

     C                   EVAL      PrcComplete = 1
     C                   EVAL      Step = 'L'
     C                   IF        UsrActn = 'U'
     C                   EVAL      LckRlsFlag = '*RLS '
     C                   EXSR      ChkFileLck
     C                   ELSE
     C                   EVAL      LckRlsFlag = '     '
     C                   ENDIF
      *
     C     GenReptUpdE   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * RstScrnInd - Reset Screen Indicators                            *
      *                                                                 *
      *******************************************************************
      *
     C     RstScrnInd    BEGSR
      *
     C                   EVAL      *IN12 = *OFF
     C                   EVAL      *IN13 = *OFF
     C                   EVAL      *IN14 = *OFF
     C                   EVAL      *IN15 = *OFF
      *
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * ValInput - Validate User Input                                  *
      *                                                                 *
      *******************************************************************
      *
     C     ValInput      BEGSR
     C                   EVAL      WValErr = '0'
     C                   EVAL      WNAINF1 = NAINF1
     C                   EVAL      WNAINF2 = NAINF2

      ** CRS Information Complete for Low Value Customers
     C                   IF        NAINF1 <> *BLANKS
     C                             and  NAINF1 <> 'A'
     C                             and  NAINF1 <> 'N'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0685'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   EVAL      *IN13 = *ON
     C                   EVAL      WValErr = '1'
     C                   GOTO      ValInputE
     C                   ENDIF

      ** CRS Information Complete for Medium Value Customers
     C                   IF        NAINF2 <> *BLANKS
     C                             and  NAINF2 <> 'A'
     C                             and  NAINF2 <> 'N'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0685'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   EVAL      *IN15 = *ON
     C                   EVAL      WValErr = '1'
     C                   GOTO      ValInputE
     C                   ENDIF

      ** If Update Mode, Check Files Allocations
     C                   IF        *INKM = *ON
     C                   EVAL      LckRlsFlag = '*LOCK'
     C                   EXSR      ChkFileLck
     C                   IF        IsFileLocked = 'Y'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0320'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   EVAL      WValErr = '1'
     C                   ENDIF
     C                   ENDIF

     C     ValInputE     ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * ChkFileLck - Check Files Allocation                             *
      *                                                                 *
      *******************************************************************
      *
     C     ChkFileLck    BEGSR
     C                   EVAL      IsFileLocked = 'N'
     C                   CALL      'SDC000558'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      'SD000315'    PCallerPGM       10
     C                   PARM      LckRlsFlag    PModeLck          7

     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      IsFileLocked = 'Y'
     C                   ENDIF
     C     ChkFileLckE   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * ListScreen - Display enquiry list screen                        *
      *                                                                 *
      *******************************************************************
      *
     C     ListScreen    BEGSR
     C                   CALL      'SD000316'
     C                   PARM      *BLANKS       PRetCode          7
     C                   PARM      UsrActn       PMode

     C                   IF        PRetCode = '*PREV'
     C                   EVAL      Step = 'I'
     C                   EVAL      InpRevwOK = 0
     C                   ELSEIF    PRetCode = '*QUIT'
     C                   EVAL      Step = 'T'
     C                   ENDIF
     C     ListScreenE   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * SetInfoCCUST - Determine and Set CRS Info Complete Flag         *
      *                                                                 *
      *******************************************************************
      *
     C     SetInfoCCUST  BEGSR
      *
     C                   EVAL      CTRChk = *BLANKS
     C                   EVAL      JACChk = *BLANKS
      *
      ** Determine the Accounts' High Value versus screen criteria's input
     C                   IF        CRHVAL = 'L'
     C                   EVAL      NAINFC = NAINF1
     C                   ELSEIF    CRHVAL = 'M'
     C                   EVAL      NAINFC = NAINF2
     C                   ENDIF
      *
     C                   EXSR      SrCTRCuChk
      *
     C                   IF        CRTYPE = 'J'
     C                   EXSR      SrJACCuChk
     C                   ENDIF
      *
      ** If CRS Information Complete Flag set to 'A'
     C                   IF        NAINFC = 'A'
      ** If field ‘High Value Indicator’ is blank
     C                             AND CRHVAL <> *BLANKS
      ** If field ‘CRS Customer Type’ is not defined
     C                             AND CRTYPE <> *BLANKS
      ** At least one country is subject to reporting and no TIN number is defined
      ** And the country has a CRS agreement if required for the system value setting
     C                             AND CTRChk <> 'Y'
      ** When the customer is a joint account, a member of the joint account
      ** has its ‘CRS Information Complete’ flag set to blank or N (No)
     C                             AND JACChk <> 'Y'
     C                   EVAL      NCINFC = NAINFC
      *
     C                   ELSEIF    NAINFC = 'N'
     C                   EVAL      NCINFC = NAINFC
      *
     C                   ELSE
     C                   EVAL      NCINFC = CRINFO
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * SetInfoCNAHO - Determine and Set CRS Info Complete Flag         *
      *                                                                 *
      *******************************************************************
      *
     C     SetInfoCNAHO  BEGSR
      *
     C                   EVAL      CTRChk = *BLANKS
     C                   EVAL      JACChk = *BLANKS
      *
      ** Determine the Accounts' High Value versus screen criteria's input
     C                   IF        NRHVAL = 'L'
     C                   EVAL      NAINFN = NAINF1
     C                   ELSEIF    NRHVAL = 'M'
     C                   EVAL      NAINFN = NAINF2
     C                   ENDIF
      *
     C                   EXSR      SrCTRNaChk
      *
     C                   IF        NRTYPE = 'J'
     C                   EXSR      SrJACNaChk
     C                   ENDIF
      *
      ** If CRS Information Complete Flag set to 'A'
     C                   IF        NAINFN = 'A'
      ** If field ‘High Value Indicator’ is blank
     C                             AND NRHVAL <> *BLANKS
      ** If field ‘CRS Type’ is not defined
     C                             AND NRTYPE <> *BLANKS
      ** At least one country is subject to reporting and no TIN number is defined
      ** And the country has a CRS agreement if required for the system value setting
     C                             AND CTRChk <> 'Y'
      ** When the NAHO is a joint account, a member of the joint account
      ** has its ‘CRS Information Complete’ flag set to blank or N (No)
     C                             AND JACChk <> 'Y'
     C                   EVAL      NCINFC = NAINFN
      *
     C                   ELSEIF    NAINFN = 'N'
     C                   EVAL      NCINFC = NAINFN
      *
     C                   ELSE
     C                   EVAL      NCINFC = NRINFO
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * SrCTRCuChk - Check CRS Country files for Customer regarding the *
      *              Subject to Reporting and TIN combinations          *
      *                                                                 *
      *******************************************************************
      *
     C     SrCTRCuChk    BEGSR
      *
      ** Subject to Reporting
     C     BBCUST        SETLL     SDCRSDL2
     C     BBCUST        READE     SDCRSDL2
      *
     C                   DOW       NOT %EOF(SDCRSDL2)
      *
      ** Retrieve first CRS Agreement
     C                   EXSR      SrRtvCRSAC
      *
     C                   IF        CDREPT = *BLANKS
     C                   EVAL      CTRChk = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        CDREPT = 'Y'
     C                             AND CDTINN = *BLANKS
      *
      ** If Country has a CRS agreement, or the system value defines the TIN as mandatory
      *
      ** If CRS Country is Local Country
     C                   IF        BJCNCD = CDCTRY
      *
     C                   IF        (WDDCRSA = 'Y' OR
     C                             WCRSLocTINMan = 'Y')
     C                   EVAL      CTRChk = 'Y'
     C                   LEAVE
     C                   ENDIF

     C                   ELSE
      ** If CRS Country is Foreign Country
     C                   IF        (WDDCRSA = 'Y' OR
     C                             WCRSForTINMan = 'Y')
     C                   EVAL      CTRChk = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     BBCUST        READE     SDCRSDL2
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * SrCTRNaChk - Check CRS Country files for Non-Acct regarding the *
      *              Subject to Reporting and TIN combinations          *
      *                                                                 *
      *******************************************************************
      *
     C     SrCTRNaChk    BEGSR
      *
      ** Subject to Reporting
     C     NCNAHO        SETLL     SDCRSNL2
     C     NCNAHO        READE     SDCRSNL2
      *
     C                   DOW       NOT %EOF(SDCRSNL2)
      *
      ** Retrieve first CRS Agreement
     C                   EXSR      SrRtvCRSAN
      *
     C                   IF        CNREPT = *BLANKS
     C                   EVAL      CTRChk = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        CNREPT = 'Y'
     C                             AND CNTINN = *BLANKS
      *
      ** If Country has a CRS agreement, or the system value defines the TIN as mandatory
      *
      ** If CRS Country is Local Country
     C                   IF        BJCNCD = CNCTRY
      *
     C                   IF        (WDDCRSA = 'Y' OR
     C                             WCRSLocTINMan = 'Y')
     C                   EVAL      CTRChk = 'Y'
     C                   LEAVE
     C                   ENDIF

     C                   ELSE
      ** If CRS Country is Foreign Country
     C                   IF        (WDDCRSA = 'Y' OR
     C                             WCRSForTINMan = 'Y')
     C                   EVAL      CTRChk = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     NCNAHO        READE     SDCRSNL2
      *
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvCRSAC - Retrieve CRS Agreement flag for country         *
      *                                                               *
      *****************************************************************
     C     SrRtvCRSAC    BEGSR

      ** Retrieve Country of Location
     C                   Eval      PKey1 = CRCUST

     C                   CALL      'AOCUSTR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PKey1
     C                   PARM                    PKySt
     C     SDCUST        PARM      SDCUST        DSSDY

      ** Database Error

     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE  =  901
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Get CRS agreement
     C                   EVAL      WCNCD = CDCTRY
     C                   EVAL      WCOLC = BBCOLC

     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         WPCTRT
     C                   PARM      WCOLC         WPCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      WCOLC = *BLANK
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         WPCTRT
     C                   PARM      WCOLC         WPCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = *BLANK
     C                   EVAL      WDDCRSA = EWCRSA
     C                   ELSE
     C                   EVAL      WDDCRSA = *Blanks
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WDDCRSA = EWCRSA
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvCRSAN - Retrieve CRS Agreement flag for country NAHO    *
      *                                                               *
      *****************************************************************
     C     SrRtvCRSAN    BEGSR

      ** Retrieve Country of Location

     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      CNNAHO        PNAHO
     C     SDNAHO        PARM      SDNAHO        DSSDY

      ** Database Error

     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBASE  =  901
     C                   EVAL      DBKEY  = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Get CRS agreement
     C                   EVAL      WCNCD = CNCTRY
     C                   EVAL      WCOLC = NHCOLC

     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         WPCTRT
     C                   PARM      WCOLC         WPCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = '*NRF   '
     C                   EVAL      WCOLC = *BLANK
     C                   CALL      'AOCTTXR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCNCD         WPCTRT
     C                   PARM      WCOLC         WPCTRR
     C     SDCTTX        PARM      SDCTTX        DSFDY

     C                   IF        PRTCD = *BLANK
     C                   EVAL      WDDCRSA = EWCRSA
     C                   ELSE
     C                   EVAL      WDDCRSA = *Blanks
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WDDCRSA = EWCRSA
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * SrJACCuChk - Check the Joint Account file for CRS Type 'J' and  *
      *              check the CRS Info Complete Flag if <> 'Y'         *
      *                                                                 *
      *******************************************************************
      *
     C     SrJACCuChk    BEGSR
      *
      ** Check whether customer has any joint accounts
     C     BBCUST        SETLL     SDJACCL4
     C     BBCUST        READE     SDJACCL4
      *
     C                   DOW       NOT %EOF(SDJACCL4)
     C     JCJANO        CHAIN     SDCRSHL1
     C                   IF        %FOUND(SDCRSHL1)
      *
     C                   IF        ACRINFO <> 'Y'
     C                   EVAL      JACChk = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
     C     BBCUST        READE     SDJACCL4
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * SrJACNaChk - Check the Joint Account file for CRS Type 'J' and  *
      *              check the CRS Info Complete Flag if <> 'Y'         *
      *                                                                 *
      *******************************************************************
      *
     C     SrJACNaChk    BEGSR
      *
      ** Check whether customer has any joint accounts
     C     NCNAHO        SETLL     SDJACCL7
     C     NCNAHO        READE     SDJACCL7
      *
     C                   DOW       NOT %EOF(SDJACCL7)
     C     JCJANO        CHAIN     SDCRSHL1
     C                   IF        %FOUND(SDCRSHL1)
      *
     C                   IF        ACRINFO <> 'Y'
     C                   EVAL      JACChk = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDIF
     C     NCNAHO        READE     SDJACCL7
     C                   ENDDO
      *
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * LoadDriver - Loop through the CRS Customers and Non-Account     *
      *                Holders to load into the driving file            *
      *                                                                 *
      *******************************************************************
      *
     C     LoadDriver    BEGSR
      *
     C                   IF        DrvLoaded = 1
     C                   EXSR      ClrDrvFil
     C                   EVAL      DrvLoaded = 0
     C                   ENDIF
      *
      **  CUSTOMERS
      *
     C     *LOVAL        SETLL     SDCRSHD0
     C                   READ      SDCRSHD0
     C                   DOW       %EOF = '0'
      *
      **  Tool - Scope: CRS Type = 'P', High Value = (L or M), Info Flag = (Blank or N)
     C                   IF        CRTYPE = 'P'
     C                             AND CRHVAL <> 'H'
     C                             AND CRHVAL <> *Blanks
     C                             AND CRHVAL <> 'N'
     C                             AND CRINFO <> 'Y'
     C                             AND CRINFO <> 'A'

     C                   EVAL      NCCUST = CRCUST
     C                   EVAL      NCNAHO = *Blanks

     C     NCCUST        CHAIN     @BBREBG                            90
     C                   IF        %FOUND = '1'
     C                   EVAL      NCRPNM = BBCRNM
     C                   EVAL      NCRPTN = BBCRTN
     C                   ENDIF
     C                   EVAL      NCHVAC = CRHVAL

     C                   EXSR      SetInfoCCUST

      ** Load to Driving File
     C                   EXSR      WrtToDriver

     C                   ENDIF

     C                   READ      SDCRSHD0
     C                   ENDDO
      *
      **  NON-ACCOUNT HOLDERS
      *
     C     *LOVAL        SETLL     SDCRNHD0
     C                   READ      SDCRNHD0
     C                   DOW       %EOF = '0'
      *
      **  Tool - Scope: CRS Type = 'P', High Value = (L or M), Info Flag = (Blank or N)
     C                   IF        NRTYPE = 'P'
     C                             AND NRHVAL <> 'H'
     C                             AND NRHVAL <> *Blanks
     C                             AND NRHVAL <> 'N'
     C                             AND NRINFO <> 'Y'
     C                             AND NRINFO <> 'A'

     C                   EVAL      NCCUST = *Blanks
     C                   EVAL      NCNAHO = NRNAHO

     C     NCNAHO        CHAIN     SDNAHOD0                           90
     C                   IF        %FOUND = '1'
     C                   EVAL      NCRPNM = NHNARN
     C                   EVAL      NCRPTN = NHNATW
     C                   ENDIF
     C                   EVAL      NCHVAC = NRHVAL

     C                   EXSR      SetInfoCNAHO

      ** Load to Driving File
     C                   EXSR      WrtToDriver

     C                   ENDIF

     C                   READ      SDCRNHD0
     C                   ENDDO
     C                   FEOD      SDCRNAL0
     C                   EVAL      DrvLoaded = 1

     C                   EVAL      Step = 'P'

     C     LoadDriverE   ENDSR
      *****************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * WrtToDriver - Write a record into the tool's driving file       *
      *                                                                 *
      *******************************************************************
      *
     C     WrtToDriver   BEGSR

     C                   WRITE     SDCRNAD0
     C                   EVAL      NCCUST = *Blanks
     C                   EVAL      NCNAHO = *Blanks
     C                   EVAL      NCRPNM = *Blanks
     C                   EVAL      NCRPTN = *Blanks
     C                   EVAL      NCHVAC = *Blanks
     C                   EVAL      NCINFC = *Blanks

     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * ClrDrvFil - Clear driving file                                  *
      *                                                                 *
      *******************************************************************
      *
     C     ClrDrvFil     BEGSR

     C     1             SETLL     SDCRNAD0
     C                   READ      SDCRNAD0
     C                   DOW       %EOF = '0'
     C                   DELETE    SDCRNAD0
     C                   READ      SDCRNAD0
     C                   ENDDO

     C                   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * ClrMsgQue - Clear program message queue                         *
      *                                                                 *
      *******************************************************************
      *
     C     ClrMsgQue     BEGSR

      * Clear messages from program message queue
     C                   CALL      'Y2CLMSC'
     C                   PARM                    ZAPGM
     C                   PARM      '*SAME'       ZAPGRL

     C                   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * ZASNMS - Send Message to Program Message Queue                  *
      *                                                                 *
      *******************************************************************
     C     ZASNMS        BEGSR

     C                   IF        ZAMSGF = *BLANKS
     C                   EVAL      ZAMSGF = 'SDUSRMSG'
     C                   END

     C                   CALL      'Y2SNMGC'
     C                   PARM                    ZAPGM                          Program queue
     C                   PARM                    ZAPGRL                         Rel queue
     C                   PARM                    ZAMSID                         Message Id
     C                   PARM                    ZAMSGF                         Message file
     C                   PARM                    ZAMSDA                         Message data
     C                   PARM                    ZAMSTP                         Message type

     C                   MOVEL     *BLANKS       ZAMSGF
     C                   MOVEL     *BLANKS       ZAMSDA
     C                   MOVEL     *BLANK        ZAMSID
     C                   MOVEL     *BLANK        ZAPGRL

     C                   ENDSR
      *******************************************************************
      *                                                                 *
      * *INZSR - Initialisation                                         *
      *                                                                 *
      *******************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    PMode             1

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV1
     C                   PARM                    WMsgLen

     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV2
     C                   PARM                    WMsgLen

     C                   EVAL      Step = 'I'
     C                   EVAL      WValErr = '1'
      ** Access installation control data
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*FIRST'      POption
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRetCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBPGM = 'SD000315'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   EVAL      SPGM = PSProcName
     C                   EVAL      NAUSER = PSUser
     C                   EVAL      NAJOBN = PSJobName
     C                   EVAL      NAMRDT = BJMRDT

     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRetCode          7
     C                   PARM      WSysVal1      P@OP01           20
     C                   PARM      *BLANKS       P@VL01
     C                   PARM      WSysVal2      P@OP02           20
     C                   PARM      *BLANKS       P@VL02
     C                   PARM      WSysVal3      P@OP03           20
     C                   PARM      *BLANKS       P@VL03
     C                   PARM      WSysVal4      P@OP04           20
     C                   PARM      *BLANKS       P@VL04
     C                   PARM      *BLANKS       P@OP05           20
     C                   PARM      *BLANKS       P@VL05          200
     C                   PARM      *BLANKS       P@OP06           20
     C                   PARM      *BLANKS       P@VL06          200
     C                   PARM      *BLANKS       P@OP07           20
     C                   PARM      *BLANKS       P@VL07          200
     C                   PARM      *BLANKS       P@OP08           20
     C                   PARM      *BLANKS       P@VL08          200
     C                   PARM      *BLANKS       P@OP09           20
     C                   PARM      *BLANKS       P@VL09          200
     C                   PARM      *BLANKS       P@OP10           20
     C                   PARM      *BLANKS       P@VL10          200

     C                   IF        PRetCode  <> *BLANKS
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBKEy = '*KEY   '
     C                   EVAL      DBase = 2
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Convert CRS effective date to Midas Day Number
     C                   MOVE      WEffStrDate   PDate
      *
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PError
     C                   PARM                    PDate
     C                   PARM      BJDFIN        PDateFormat
     C                   PARM                    PDayNo

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  -   Program exception error routine                    *
      *            Called automatically if a program error occurs,    *
      *            or directly by the program code using EXSR.        *
      *            This subroutine DUMPs the program just once.       *
      *                                                               *
      * Called by: *INZSR                                             *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        Recursive = *BLANK
     C                   EVAL      Recursive = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
** ##OV1
OVRDBF FILE(SDCRSHL0) SHARE(*NO)
** ##OV2
OVRDBF FILE(SDCRNHL0) SHARE(*NO)
