     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Normal Cust/NAHO Classfn Upd - Main')         *
      *****************************************************************
      *  Includes MD025277A, MD025277, MD025049, MD024916B,           *
      *           MD024639, MD024713, MD024711                        *
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000551 - Normal Customer/NAHO Classification Update        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. MD039670           Date 26Jul16               *
      *  Prev Amend No. MD030211A          Date 05Sep14               *
      *                 MD030211           Date 01Sep14               *
      *                 MD027209           Date 07Aug14               *
      *                 MD027334           Date 12Aug14               *
      *                 MD027033           Date 29May14               *
      *                 MD026826           Date 12May14               *
      *                 CGL132   *CREATE   Date 01May13               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD039670 - FATCA Housekeeping program                        *
      *  MD030211A - F11 and F13 needs to be pressed twice            *
      *  MD030211 - F11 and F13 needs to be pressed twice             *
      *  MD027209 - F4-Print Report is not available in USIT and NCUP *
      *  MD027334 - Validation on Mandatory Class Code removed        *
      *  MD027033 - NCUP Tool does not set FATCA Information Complete *
      *             Flag to A even if validations                     *
      *  MD026826 - NCUP include customers with same classification   *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *                                                               *
      *****************************************************************
     FSD000551DFCF   E             WORKSTN INFSR(*PSSR)
 
      ** FATCA Customers for Classfn Update - List
     FSDFTCSL5  UF   E           K DISK
 
      ** FATCA Non-Account Holders for Classfn Update - List
     FSDFTNHL5  UF   E           K DISK
 
      ** Normal FATCA Customers Classfn Update File - Driver
     FSDNACUPD  UF A E             DISK
 
      ** Main Customer Details File - Keyed
     FSDCUSTL0  IF   E           K DISK
 
      ** Main Non-Account Holders File - Keyed
     FSDNAHOL0  IF   E           K DISK
 
      ** Customer Extension
     FSDCUSXL0  IF   E           K DISK
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
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
     D SDACUS        E DS                  EXTNAME(SDACUSPD)
     D SDSVAL        E DS                  EXTNAME(SDSVALPD)
     D SDFATC        E DS                  EXTNAME(SDFATCPD)
     D SDNACU        E DS                  EXTNAME(SDNACUPD)
     D SCRN_WVAL     E DS                  EXTNAME(SD000551DF:SD000551D0)
     D                                     PREFIX(W)
 
     D CMDXC           S             50    DIM(1) CTDATA PERRCD(1)
     D ##OV1           S             50    DIM(1) CTDATA PERRCD(1)
     D ##OV2           S             50    DIM(1) CTDATA PERRCD(1)
     DPSDS            SDS
 
      ** Procedure name
     D PSProcName        *PROC
 
      ** Job name
     D PSJobName             244    253
 
      ** User name
     D PSUser                254    263
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
     D  WUsTinBrRqd            1      1
     D P@VL02          DS           200
     D  WDftClsTkOn            1      5
     D P@VL03          DS           200
     D  WDftClsNew             1      5
     D P@VL04          DS           200
     D  WEffStrDate            1      6
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
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
     D WVal            S              1                                                    MD030211A
      *
     D ZAPGM           S             10    INZ('SD000551')
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
     D PRTCD           S              7                                                     MD039670
     D POPTN           S              7                                                     MD039670
     D PKEY1           S             10                                                     MD039670
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** System value TIN and/or date and place of birth for
      ** customer and NAH subject to reporting
     DWSysVal1         C                   'FATCAUsTinBirthRqd'
      ** System value Default Classification for Take-on
     DWSysVal2         C                   'FATCADftCLsTakeon'
      ** System value Default Classification for New Customers
      ** and Non-account Holders
     DWSysVal3         C                   'FATCADftCLsNewCustNH'
      ** System value FATCA Effective Date
     DWSysVal4         C                   'FATCAEffectStartDate'
      ** Exemption remark
     DWExemRem         C                   'Updated by Customer Type-
     D                                      and Allocation Electronic Tool'
      *****************************************************************
      *                                                               *
      * M A I N   P R O C E D U R E                                   *
      *                                                               *
      *****************************************************************
      *
     C                   EVAL      WVal = ' '                                              MD030211A
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
     C                   EXSR      GenReptUpd
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
      *             + New classification code                           *
      *             + New FATCA Information Complete Flag               *
      *                                                                 *
      *             For Customers with High Value Indicator = 'M'       *
      *             + New classification code                           *
      *             + New FATCA Information Complete Flag               *
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
 
     C**********         WRITE     SD000551F0                                               MD027334
     C**********         EXFMT     SD000551D0                                               MD027334
 
     C                   DOW       (WValErr = '1'
     C                             or InpRevwOK = 0)
     C                             and *INKC = *OFF
     C                             and *INKJ = *OFF
 
     C                   EXSR      RstScrnInd
     C                   EXSR      ClrMsgQue
     C                   WRITE     #MSGCTL
     C                   IF        WVal = 'Y'                                              MD030211A
     C                   EXSR      ValInput
     C                   ENDIF                                                             MD030211A
     C                   EVAL      WVal = 'Y'                                              MD030211A
      **
     C                   IF        *INKM = *ON and InpRevwOK = 1
     C                             and WValErr <> '1'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0285'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   ENDIF
 
     C                   WRITE     SD000551F0
     C                   EXFMT     SD000551D0
      **
     C                   IF        *INKM = *ON and InpRevwOK = 0
     C                             and WValErr <> '1'                                       MD027334
     C                   EVAL      WValErr = '1'
     C                   ENDIF
     C                   IF        WNACCO1 <> NACCO1
     C                             AND WNACCO1 <> *BLANKS                                   MD027334
     C                             or WNACCO2 <> NACCO2
     C                             AND WNACCO2 <> *BLANKS                                   MD027334
     C                             or WNAINF1 <> NAINF1
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
     C                   IF        IsUsrAuth = 'Y'
     C                   EVAL      Step = 'D'
     C                   ENDIF
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
     C                   EVAL      *INKK = *OFF
     C                   ELSEIF    *INKM = *ON
     C                   EVAL      UsrActn = 'U'
     C                   EVAL      *INKM = *OFF
     C                   ENDIF
 
      ** Check Action Againsts User Authority
     C                   EVAL      IsUsrAuth = 'Y'
 
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
     C                   IF        UsrActn = 'U'                                            MD027209
     C                   CALL      'SD000553'
     C                   PARM      UsrActn       PMode
     C                   ENDIF                                                              MD027209
 
     C                   EVAL      PrcComplete = 1
     C                   EVAL      Step = 'L'
     C                   IF        UsrActn = 'U'
     C                   EVAL      LckRlsFlag = '*RLS '
     C                   EXSR      ChkFileLck
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
     C                   EVAL      WNACCO1 = NACCO1
     C                   EVAL      WNACCD1 = NACCD1
     C                   EVAL      WNACCO2 = NACCO2
     C                   EVAL      WNACCD2 = NACCD2
     C                   EVAL      WNAINF1 = NAINF1
     C                   EVAL      WNAINF2 = NAINF2
 
      ** Both Low and Medium Value Classification Codes are blank
     C**********         IF        %trim(WNACCO1) = *BLANKS                                 MD027334
     C**********                   and %trim(WNACCO2) = *BLANKS                             MD027334
     C**********         MOVEL     'SDUSRMSG'    ZAMSGF                                     MD027334
     C**********         MOVEL     'USS0446'     ZAMSID                                     MD027334
     C**********         EXSR      ZASNMS                                                   MD027334
     C**********         WRITE     #MSGCTL                                                  MD027334
     C**********         EVAL      *IN12 = *ON                                              MD027334
     C**********         EVAL      *IN14 = *ON                                              MD027334
     C**********         EVAL      WValErr = '1'                                            MD027334
     C**********         EVAL      NACCD1 = *BLANKS                                         MD027334
     C**********         EVAL      NACCD2 = *BLANKS                                         MD027334
     C**********         GOTO      ValInputE                                                MD027334
     C**********         ENDIF                                                              MD027334
 
      ** Classification Code for Low Value Account Customers
     C                   IF        WNACCO1 <> *BLANKS
     C                   EVAL      WClsCdValCod = WNACCO1
     C                   EXSR      RtvClassfn
     C                   EVAL      WNACCO1 = WClsCdValCod
     C                   EVAL      WNACCD1 = WClsCdValDsc
     C                   ELSE
     C                   EVAL      WNACCD1 = *BLANKS
     C                   ENDIF
     C                   IF        WValErr = '1'
     C                   EVAL      *IN12 = *ON
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0448'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   GOTO      ValInputE
     C                   ENDIF
     C                   EVAL      NACCO1 = WNACCO1
     C                   EVAL      NACCD1 = WNACCD1
 
      ** FATCA Information Complete for Low Value Customers
     C                   IF        NAINF1 <> *BLANKS
     C                             and  NAINF1 <> 'A'
     C                             and  NAINF1 <> 'N'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0447'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   EVAL      *IN13 = *ON
     C                   EVAL      WValErr = '1'
     C                   GOTO      ValInputE
     C                   ENDIF
 
      ** Classification Code for Medium Value Account Customers
     C                   IF        WNACCO2 <> *BLANKS
     C                   EVAL      WClsCdValCod = NACCO2
     C                   EXSR      RtvClassfn
     C                   EVAL      WNACCO2 = WClsCdValCod
     C                   EVAL      WNACCD2 = WClsCdValDsc
     C                   ELSE
     C                   EVAL      WNACCD2 = *BLANKS
     C                   ENDIF
     C                   IF        WValErr = '1'
     C                   EVAL      *IN14 = *ON
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0448'     ZAMSID
     C                   EXSR      ZASNMS
     C                   WRITE     #MSGCTL
     C                   GOTO      ValInputE
     C                   ENDIF
     C                   EVAL      NACCO2 = WNACCO2
     C                   EVAL      NACCD2 = WNACCD2
 
      ** FATCA Information Complete for Medium Value Customers
     C                   IF        NAINF2 <> *BLANKS
     C                             and  NAINF2 <> 'A'
     C                             and  NAINF2 <> 'N'
     C                   MOVEL     'SDUSRMSG'    ZAMSGF
     C                   MOVEL     'USS0447'     ZAMSID
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
     C                   PARM      'SDC000551'   PCallerPGM       10
     C                   PARM      LckRlsFlag    PModeLck          7
 
     C                   IF        PRetCode <> *BLANKS
     C                   EVAL      IsFileLocked = 'Y'
     C                   ENDIF
     C     ChkFileLckE   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * RtvClassfn - Check Classification Codes On File                 *
      *                                                                 *
      *******************************************************************
      *
     C     RtvClassfn    BEGSR
     C                   EVAL      WClsCdValDsc = *BLANKS
     C                   IF        %trim(WClsCdValCod) <> *BLANKS
      ** Either :
      ** Prompt user to select a classification code
      ** Or :
      ** Retrieve details of given Classification Code
     C                   EVAL      SDFATC = *BLANKS
     C                   CALL      'AOFATCR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM      WClsCdValCod  @CLAC             5
     C     SDFATC        PARM      SDFATC        DSFDY
 
     C                   IF        WClsCdValCod = '?'
     C                   EVAL      WClsCdValCod = *BLANKS
     C                   ENDIF
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      WClsCdValCod = FCCODE
     C                   EVAL      WClsCdValDsc = FCDESC
     C                   ENDIF
 
     C                   ENDIF
      ** Error Processing
      ** Error on input validation
     C                   IF        @RTCD <> *BLANKS
     C                             and WValErr = '0'
     C                   EVAL      WValErr = '1'
 
      ** Error on initialisation
     C                   ELSEIF    @RTCD <> *BLANKS
     C                             and WValErr <> '0'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     RtvClassfnE   ENDSR
      *******************************************************************
      /EJECT
      *******************************************************************
      *                                                                 *
      * ListScreen - Display enquiry list screen                        *
      *                                                                 *
      *******************************************************************
      *
     C     ListScreen    BEGSR
     C                   CALL      'SD000552'
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
      * SetInfoCCUST - Determine and Set FATCA Info Complete Flag       *
      *                                                                 *
      *******************************************************************
      *
     C     SetInfoCCUST  BEGSR
      ** Retrieve additional customer details
     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C**********         PARM      BBCUST        PCustNo                                    MD027334
     C                   PARM      FACUST        PCustNo                                    MD027334
     C     SDACUS        PARM      SDACUS        DSLDY
 
      ** Classification Code neither blank nor defaulted.
     C                   IF        FACLAC <> *BLANKS
     C                             and FACLAC <> WDftClsTkOn
     C                             and FACLAC <> WDftClsNew
      ** FATCA Reporting Type is not 'Unknown'.
     C                             and FARPTT <> 'U'
      ** High Value Indicator is blank.
     C                             and FAHVAC <> *BLANKS
      ** Subject for Reporting is blank.
     C                             and FAREPT <> *BLANKS
      ** No US Indicium system value is blank.
     C                             and FACISV <> *BLANKS
     C                             and FATXSV <> *BLANKS
     C                             and FACDSV <> *BLANKS
     C                             and FATESV <> *BLANKS
     C                             and FAGCSV <> *BLANKS
     C                             and FACBSV <> *BLANKS
     C                             and FAJASV <> *BLANKS
     C                             and FAHMSV <> *BLANKS
     C                             and FARPSV <> *BLANKS
     C                             and FAIDSV <> *BLANKS
     C                             and FAMCSV <> *BLANKS
     C                             and FAPHON <> *BLANKS                                    MD027033
     C                             and FAMAIL <> *BLANKS                                    MD027033
     C                             and FAGREC <> *BLANKS                                    MD027033
     C                             and FAEXEM <> *BLANKS                                    MD027033
      ** System Value for US TIN and/or Date and Place of Birth Required
      ** is observed.
     C                             and ( (WUsTinBrRqd = 'U'
     C                                    and FAUTIN <> *BLANKS)
     C                                or (WUsTinBrRqd = 'N')                                MD027033
     C                                or (WUsTinBrRqd = 'B'
     C                                    and E5DBTH <> *BLANKS
     C                                    and E5BTHT <> *BLANKS)
     C                                or (WUsTinBrRqd = 'Y'
     C                                    and FAUTIN <> *BLANKS
     C                                    and E5DBTH <> *BLANKS
     C                                    and E5BTHT <> *BLANKS))
      ** US TIN is defined if customer created after FATCA effective
      ** date is Subject for reporting
     C**********                   and ( (XCCRDT >= PDayNo                                  MD027033
     C**********                          and FAREPT = 'Y'                                  MD027033
     C**********                          and FAUTIN <> *BLANKS                             MD027033
     C**********                          and FALCTP = 'I')                                 MD027033
     C**********                      or (XCCRDT >= PDayNo                                  MD027033
     C**********                          and FAREPT = 'N'                                  MD027033
     C**********                          and FALCTP = 'I')                                 MD027033
     C**********                      or (XCCRDT < PDayNo and FALCTP = 'I')                 MD027033
     C**********                      or  FALCTP <> 'I')                                    MD027033
     C                             and ( (XCCRDT >= PDayNo                                  MD027033
     C                                    and FAREPT = 'Y'                                  MD027033
     C                                    and FAUTIN <> *BLANKS)                            MD027033
     C                                or (XCCRDT >= PDayNo                                  MD027033
     C                                    and FAREPT = 'N')                                 MD027033
     C                                or (XCCRDT < PDayNo))                                 MD027033
     C                             AND (NAINF1 <> *BLANKS                                   MD027334
     C                             AND  FAHVAC =  'L'                                       MD027334
     C                             OR   NAINF2 <> *BLANKS                                   MD027334
     C                             AND  FAHVAC =  'M')                                      MD027334
                                                                                            MD027334
     C                   IF        FAHVAC =  'L'                                            MD027334
     C                   EVAL      NCINFC = NAINF1
     C                   ELSEIF    FAHVAC =  'M'                                            MD027334
     C                   EVAL      NCINFC = NAINF2                                          MD027334
     C                   ENDIF                                                              MD027334
                                                                                            MD027334
     C                   ELSE
     C                   EVAL      NCINFC = FAINFC
     C                   ENDIF
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * SetInfoCNAHO - Determine and Set FATCA Info Complete Flag       *
      *                                                                 *
      *******************************************************************
      *
     C     SetInfoCNAHO  BEGSR
 
      ** Classification Code neither blank nor defaulted.
     C                   IF        FNCLAC <> *BLANKS
     C                             and FNCLAC <> WDftClsTkOn
     C                             and FNCLAC <> WDftClsNew
      ** FATCA Reporting Type is not 'Unknown'.
     C                             and FNRPTT <> 'U'
      ** High Value Indicator is blank.
     C                             and FNHVAC <> *BLANKS
      ** Subject for Reporting is blank.
     C                             and FNREPT <> *BLANKS
      ** No US Indicium system value is blank.
     C                             and FNCISV <> *BLANKS
     C                             and FNTXSV <> *BLANKS
     C                             and FNCDSV <> *BLANKS
     C                             and FNTESV <> *BLANKS
     C                             and FNGCSV <> *BLANKS
     C                             and FNCBSV <> *BLANKS
     C                             and FNJASV <> *BLANKS
     C                             and FNHMSV <> *BLANKS
     C                             and FNRPSV <> *BLANKS
     C                             and FNIDSV <> *BLANKS
     C                             and FNMCSV <> *BLANKS
     C                             and FNPHON <> *BLANKS                                    MD027033
     C                             and FNMAIL <> *BLANKS                                    MD027033
     C                             and FNGREC <> *BLANKS                                    MD027033
     C                             and FNEXEM <> *BLANKS                                    MD027033
      ** System Value for US TIN and/or Date and Place of Birth Required
      ** is observed.
     C                             and ( (WUsTinBrRqd = 'U'
     C                                    and FNUTIN <> *BLANKS)
     C                                or (WUsTinBrRqd = 'N')                                MD027033
     C                                or (WUsTinBrRqd = 'B'
     C                                    and NHDBTH <> *BLANKS
     C                                    and NHBTHT <> *BLANKS)
     C                                or (WUsTinBrRqd = 'Y'
     C                                    and FNUTIN <> *BLANKS
     C                                    and NHDBTH <> *BLANKS
     C                                    and NHBTHT <> *BLANKS))
      ** US TIN is defined if customer created after FATCA effective
      ** date is Subject for reporting
     C**********                   and ( (XCCRDT >= PDayNo                                  MD027033
     C**********                          and FNREPT = 'Y'                                  MD027033
     C**********                          and FNUTIN <> *BLANKS                             MD027033
     C**********                          and FNLCTP = 'I')                                 MD027033
     C**********                      or (XCCRDT >= PDayNo                                  MD027033
     C**********                          and FNREPT = 'N'                                  MD027033
     C**********                          and FNLCTP = 'I')                                 MD027033
     C**********                      or (XCCRDT < PDayNo and FNLCTP = 'I')                 MD027033
     C**********                      or  FNLCTP <> 'I')                                    MD027033
     C                             and ( (XCCRDT >= PDayNo                                  MD027033
     C                                    and FNREPT = 'Y'                                  MD027033
     C                                    and FNUTIN <> *BLANKS)                            MD027033
     C                                or (XCCRDT >= PDayNo                                  MD027033
     C                                    and FNREPT = 'N')                                 MD027033
     C                                or (XCCRDT < PDayNo))                                 MD027033
     C                             AND (NAINF1 <> *BLANKS                                   MD027334
     C                             AND  FNHVAC =  'L'                                       MD027334
     C                             OR   NAINF2 <> *BLANKS                                   MD027334
     C                             AND  FNHVAC =  'M')                                      MD027334
                                                                                            MD027334
     C                   IF        FNHVAC =  'M'                                            MD027334
     C                   EVAL      NCINFC = NAINF2
     C                   ELSEIF    FNHVAC =  'L'                                            MD027334
     C                   EVAL      NCINFC = NAINF1                                          MD027334
     C                   ENDIF                                                              MD027334
                                                                                            MD027334
     C                   ELSE
     C                   EVAL      NCINFC = FNINFC
     C                   ENDIF
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * LoadDriver - Loop through the FATCA Customers and Non-Account   *
      *                Holders to load into the driving file            *
      *                                                                 *
      *******************************************************************
      *
     C     LoadDriver    BEGSR
     C                   IF        DrvLoaded = 1
     C                   EXSR      ClrDrvFil
     C                   EVAL      DrvLoaded = 0
     C                   ENDIF
      *
      **  CUSTOMERS
      *
     C     *LOVAL        SETLL     SDFTCSD0
     C                   READ      SDFTCSD0
     C                   DOW       %EOF = '0'
                                                                                            MD026826
     C                   IF        FAHVAC = 'L'  and                                        MD026826
     C                             (NAINF1 <> *BLANKS OR                                    MD027334
     C                             NACCO1 <> *BLANKS and                                    MD026826
     C**********                   NACCO1 <> FACLAC                                MD026826 MD027334
     C                             NACCO1 <> FACLAC)                                        MD027334
     C                             OR                                                       MD026826
     C                             FAHVAC = 'M'  and                                        MD026826
     C                             (NAINF2 <> *BLANKS OR                                    MD027334
     C                             NACCO2 <> *BLANKS and                                    MD026826
     C**********                   NACCO2 <> FACLAC                                MD026826 MD027334
     C                             NACCO2 <> FACLAC)                                        MD027334
 
     C                   EVAL      NCCUST = FACUST
     C                   EVAL      NCNAHO = *Blanks
 
     C     NCCUST        CHAIN     @BBREBG                            90
     C                   IF        %FOUND = '1'
     C     BBCUST        CHAIN     SDCUSXL0
     C                   EVAL      NCRPNM = BBCRNM
     C                   EVAL      NCRPTN = BBCRTN
     C                   EVAL      SDCUST = *Blanks
     C                   ENDIF
     C                   EVAL      NCHVAC = FAHVAC
                                                                                            MD027334
      ** If there are no Classification Codes input                                         MD027334
      ** there should be no change in the class codes                                       MD027334
                                                                                            MD027334
     C                   IF        NACCO1 <> *BLANKS                                        MD027334
     C                             AND FAHVAC = 'L'                                         MD027334
     C                             OR  NACCO2 <> *BLANKS                                    MD027334
     C                             AND FAHVAC = 'M'                                         MD027334
     C                   EVAL      NCCCLS = FACLAC
     C                   ELSE                                                               MD027334
     C                   EVAL      NCCCLS = FAPCLA                                          MD027334
     C                   ENDIF                                                              MD027334
 
     C                   EVAL      WClsCdValCod = NCCCLS
     C                   EXSR      RtvClassfn
     C                   EVAL      NCCCLD = WClsCdValDsc
 
     C                   EXSR      GetNewClass
     C                   EXSR      SetInfoCCUST
 
      ** Load to Driving File
      ** Only if details were changed                                                       MD027334
     C                   IF        NCCCLS <> FAPCLA                                         MD027334
     C                             AND NACCO1 =  *BLANKS                                    MD027334
     C                             AND FAHVAC = 'L'                                         MD027334
     C                             OR  NCNCLS <> FACLAC                                     MD027334
     C                             AND NACCO1 <> *BLANKS                                    MD027334
     C                             AND FAHVAC = 'L'                                         MD027334
     C                             OR  NCCCLS <> FAPCLA                                     MD027334
     C                             AND NACCO2 =  *BLANKS                                    MD027334
     C                             AND FAHVAC = 'M'                                         MD027334
     C                             OR  NCNCLS <> FACLAC                                     MD027334
     C                             AND NACCO2 <> *BLANKS                                    MD027334
     C                             AND FAHVAC = 'M'                                         MD027334
     C                             OR  NCINFC <> FAINFC                                     MD027334
     C                             AND NAINF1 =  NCINFC                                     MD027334
     C                             AND FAHVAC = 'L'                                         MD027334
     C                             OR  NCINFC <> FAINFC                                     MD027334
     C                             AND NAINF2 =  NCINFC                                     MD027334
     C                             AND FAHVAC = 'M'                                         MD027334
     C                   EXSR      WrtToDriver
     C                   ENDIF                                                              MD027334
 
     C                   ENDIF                                                              MD026826
                                                                                            MD026826
     C                   READ      SDFTCSD0
     C                   ENDDO
      *
      **  NON-ACCOUNT HOLDERS
      *
     C     *LOVAL        SETLL     SDFTNHD0
     C                   READ      SDFTNHD0
     C                   DOW       %EOF = '0'
                                                                                            MD039670
     C                   EVAL      PKEY1 = FNNAHO                                           MD039670
     C                   IF        PKEY1 <> *BLANKS                                         MD039670
     C                   CALL      'AONAHOR0'                                               MD039670
     C                   PARM      *Blanks       PRTCD                                      MD039670
     C                   PARM      '*KEY   '     POPTN                                      MD039670
     C                   PARM                    PKEY1                                      MD039670
     C     SDNAHO        PARM      SDNAHO        DSSDY                                      MD039670
                                                                                            MD039670
     C                   IF        PRTCD = '*NRF'                                           MD039670
     C                             OR NHCHTP = 'D'                                          MD039670
     C                   READ      SDFTNHD0                                                 MD039670
     C                   ITER                                                               MD039670
     C                   ENDIF                                                              MD039670
     C                   ENDIF                                                              MD039670
                                                                                            MD039670
                                                                                            MD026826
     C                   IF        FNHVAC = 'L'  and                                        MD026826
     C                             (NAINF1 <> *BLANKS OR                                    MD027334
     C                             NACCO1 <> *BLANKS and                                    MD026826
     C**********                   NACCO1 <> FNCLAC                                MD026826 MD027334
     C                             NACCO1 <> FNCLAC)                                        MD027334
     C                             OR                                                       MD026826
     C                             FNHVAC = 'M'  and                                        MD026826
     C                             (NAINF2 <> *BLANKS OR                                    MD027334
     C                             NACCO2 <> *BLANKS and                                    MD026826
     C**********                   NACCO2 <> FNCLAC                                MD026826 MD027334
     C                             NACCO2 <> FNCLAC)                                        MD027334
 
     C                   EVAL      NCCUST = *Blanks
     C                   EVAL      NCNAHO = FNNAHO
 
     C     NCNAHO        CHAIN     SDNAHOD0                           90
     C                   IF        %FOUND = '1'
     C                   EVAL      NCRPNM = NHNARN
     C                   EVAL      NCRPTN = NHNATW
     C                   EVAL      SDNAHO = *Blanks
     C                   ENDIF
     C                   EVAL      NCHVAC = FNHVAC
                                                                                            MD027334
      ** If there are no Classification Codes input                                         MD027334
      ** there should be no change in the class codes                                       MD027334
                                                                                            MD027334
     C                   IF        NACCO1 <> *BLANKS                                        MD027334
     C                             AND FNHVAC = 'L'                                         MD027334
     C                             OR  NACCO2 <> *BLANKS                                    MD027334
     C                             AND FNHVAC = 'M'                                         MD027334
     C                   EVAL      NCCCLS = FNCLAC
     C                   ELSE                                                               MD027334
     C                   EVAL      NCCCLS = FNPCLA                                          MD027334
     C                   ENDIF                                                              MD027334
 
     C                   EVAL      WClsCdValCod = NCCCLS
     C                   EXSR      RtvClassfn
     C                   EVAL      NCCCLD = WClsCdValDsc
 
     C                   EXSR      GetNewClass
     C                   EXSR      SetInfoCNAHO
 
      ** Load to Driving File
      ** Only if details were changed                                                       MD027334
     C                   IF        NCCCLS <> FNPCLA                                         MD027334
     C                             AND NACCO1 =  *BLANKS                                    MD027334
     C                             AND FNHVAC = 'L'                                         MD027334
     C                             OR  NCNCLS <> FNCLAC                                     MD027334
     C                             AND NACCO1 <> *BLANKS                                    MD027334
     C                             AND FNHVAC = 'L'                                         MD027334
     C                             OR  NCCCLS <> FNPCLA                                     MD027334
     C                             AND NACCO2 =  *BLANKS                                    MD027334
     C                             AND FNHVAC = 'M'                                         MD027334
     C                             OR  NCNCLS <> FNCLAC                                     MD027334
     C                             AND NACCO2 <> *BLANKS                                    MD027334
     C                             AND FNHVAC = 'M'                                         MD027334
     C                             OR  NCINFC <> FNINFC                                     MD027334
     C                             AND NAINF1 =  NCINFC                                     MD027334
     C                             AND FNHVAC = 'L'                                         MD027334
     C                             OR  NCINFC <> FNINFC                                     MD027334
     C                             AND NAINF2 =  NCINFC                                     MD027334
     C                             AND FNHVAC = 'M'                                         MD027334
     C                   EXSR      WrtToDriver
     C                   ENDIF                                                              MD027334
 
     C                   ENDIF                                                              MD026826
                                                                                            MD026826
     C                   READ      SDFTNHD0
     C                   ENDDO
     C                   FEOD      SDNACUPD
     C*                  COMMIT
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
 
     C                   WRITE     SDNACUD0
     C                   EVAL      NCCUST = *Blanks
     C                   EVAL      NCNAHO = *Blanks
     C                   EVAL      NCRPNM = *Blanks
     C                   EVAL      NCRPTN = *Blanks
     C                   EVAL      NCHVAC = *Blanks
     C                   EVAL      NCINFC = *Blanks
     C                   EVAL      NCNCLS = *Blanks
     C                   EVAL      NCNCLD = *Blanks
     C                   EVAL      NCCCLS = *Blanks
     C                   EVAL      NCCCLD = *Blanks
 
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * GetNewClass - Returns new classification code based on FATCA    *
      *               Information Complete Flag                         *
      *                                                                 *
      *******************************************************************
      *
     C     GetNewClass   BEGSR
 
     C                   SELECT
     C                   WHEN      NCHVAC = 'L' and NACCO1 <> *BLANKS
     C                   EVAL      NCNCLS = NACCO1
     C                   EVAL      NCNCLD = NACCD1
                                                                                            MD027334
     C                   WHEN      NCHVAC = 'L' and NACCO1 = *BLANKS                        MD027334
     C                             AND NCNAHO = *BLANKS                                     MD027334
                                                                                            MD027334
     C                   EVAL      NCNCLS = FACLAC                                          MD027334
     C                   EVAL      NCNCLD = *BLANKS                                         MD027334
     C                   EVAL      WClsCdValCod = FACLAC                                    MD027334
     C                   EXSR      RtvClassfn                                               MD027334
     C                   EVAL      NCNCLD = WClsCdValDsc                                    MD027334
                                                                                            MD027334
     C                   WHEN      NCHVAC = 'L' and NACCO1 = *BLANKS                        MD027334
     C                             AND NCCUST = *BLANKS                                     MD027334
     C                   EVAL      NCNCLS = FNCLAC                                          MD027334
     C                   EVAL      NCNCLD = *BLANKS                                         MD027334
                                                                                            MD027334
     C                   WHEN      NCHVAC = 'M' and NACCO2 <> *BLANKS
     C                   EVAL      NCNCLS = NACCO2
     C                   EVAL      NCNCLD = NACCD2
                                                                                            MD027334
     C                   WHEN      NCHVAC = 'M' and NACCO2 =  *BLANKS                       MD027334
     C                             AND NCNAHO = *BLANKS                                     MD027334
                                                                                            MD027334
     C                   EVAL      NCNCLS = FACLAC                                          MD027334
     C                   EVAL      NCNCLD = *BLANKS                                         MD027334
     C                   EVAL      WClsCdValCod = FACLAC                                    MD027334
     C                   EXSR      RtvClassfn                                               MD027334
     C                   EVAL      NCNCLD = WClsCdValDsc                                    MD027334
                                                                                            MD027334
     C                   WHEN      NCHVAC = 'M' and NACCO2 =  *BLANKS                       MD027334
     C                             AND NCCUST = *BLANKS                                     MD027334
     C                   EVAL      NCNCLS = FNCLAC                                          MD027334
     C                   EVAL      NCNCLD = *BLANKS                                         MD027334
                                                                                            MD027334
     C                   OTHER
     C                   EVAL      NCNCLS = NCCCLS
     C                   EVAL      NCNCLD = NCCCLD
     C                   ENDSL
 
     C                   ENDSR
      /EJECT
      *******************************************************************
      *                                                                 *
      * ClrDrvFil - Clear driving file                                  *
      *                                                                 *
      *******************************************************************
      *
     C     ClrDrvFil     BEGSR
      * Clear driving file
     C*                  Z-ADD     50            CMDLEN           15 5
     C*                  CALL      'QCMDEXC'
     C*                  PARM                    CMDXC
     C*                  PARM                    CMDLEN
 
     C     1             SETLL     SDNACUD0
     C                   READ      SDNACUD0
     C                   DOW       %EOF = '0'
     C                   DELETE    SDNACUD0
     C                   READ      SDNACUD0
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
 
     C                   Z-ADD     50            CMDLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV1
     C                   PARM                    CMDLEN
 
     C                   Z-ADD     50            CMDLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OV2
     C                   PARM                    CMDLEN
 
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
     C                   EVAL      DBPGM = 'SD000551'
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
 
     C                   EVAL      WClsCdValCod = WDftClsTkOn
 
     C                   EXSR      RtvClassfn
 
     C                   IF        @RTCD = *Blanks
     C                   EVAL      WDftClsDesc = FCDESC
     C                   ELSE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Convert FATCA effective date to Midas Day Number
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
OVRDBF FILE(SDFTCSL5) SHARE(*NO)
** ##OV2
OVRDBF FILE(SDFTNHL5) SHARE(*NO)
