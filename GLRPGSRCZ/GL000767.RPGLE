     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2016')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL CRS Report Management Details')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000767 - Midas GL Report Management Processing             *
      *                                                               *
      *  Function: This is to generate Report Management Data         *
      *        for XML Input File                                     *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
      *                                                               *
      *  Last Amend No. MD054940           Date 18Feb20               *
      *  Prev Amend No. MD055078           Date 18Feb20               *
      *                 MD055071           Date 29Jan20               *
      *                 MD054986           Date 27Jan20               *
      *                 MD054905           Date 04Dec19               *
      *                 CGL185             Date 13Mar17               *
      *                 MD041589           Date 23Sep16               *
      *                 MD040916           Date 31Aug16               *
      *                 MD040873           Date 26Aug16               *
      *                 MD039670           Date 26Jul16               *
      *                 CGL177  *CREATE    Date 11Jan16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054940 - CRS Issue: Controlling Person Type                *
      *  MD055078 - Information on non-account holders is missing     *
      *  MD055071- Correct A/C Holder Type for N/PA. With ContPerson  *
      *            = CRS101, Wihtout ContPerson = CRS103              *
      *  MD054986 - CRS Issue: Account Holder/Organisation            *
      *  MD054905 - Change Message Ref Id format                      *
      *  CGL185 - FATCA XML 2.0                                       *
      *  MD041589 - Controlling person for CRS101 is not displayed    *
      *             in the Report                                     *
      *  MD040916 - Non Related Payment is listed in an Acct Holder   *
      *  MD040873 - Joint Acct Member did not report Joint Acct Assets*
      *  MD039670 - FATCA Housekeeping program                        *
      *  CGL177 - CRS Reporting Phase 2                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99 - Lookup                                                *
      *    LR                                                         *
      *    U7                                                         *
      *    U8                                                         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRReportFI    - Reporting FI                                 *
      *  SRDetRepType  - Determine Report Type                        *
      *  SRWriteMain   - Write to Main File                           *
      *  SRRepNew      - Main Processing for Report New Details       *
      *  SRRepCorrect  - Main Processing for Amend Report             *
      *  SRRepIncld    - Main Processing for Include Report           *
      *  SRCustCheck   - Check Customer Report Type                   *
      *  SRRepHeader   - Message Header Details                       *
      *  SRCsActRepHdr - Write Account Report to File                 *
      *  SRWrIndvRept  - Reporting Individual Account                 *
      *  SRAccBalance  - Report Account Balance                       *
      *  SRGenMsgID    - Generate Message Ref ID                      *
      *  SRConPersn    - Report Controlling Persons for Acct Holder   *
      *  SRAccSval     - Access System Values File                    *
      *  SRDetDocTyp   - Determine Document Type                      *
      *  SRAccCurr     - Access Currency Detail File                  *
      *  SRCvtDate     - Convert Midas Date to YYYYMMDD               *
      *  SRInit        - Initialise field                             *
      *  SRCompPaymt   - Compute Payment Details for Reporting        *
      *  SRListExcptn  - List all Customers or Non-acct Holder Excptn *
      *  SRWrite       - Write record Report Management Data          *
      *  SRAccCust     - Access Customer Details                      *
      *  SRAccNaho     - Access Non-Account Holder Details            *
      *  SRAccAcus     - Access Additional Customer Details           *
      *  SRAccBranch   - Access Branch Code Details                   *
      *  SRAccType     - Check if for Reporting if No Agreement       *
      *  SRCRSHDet     - Access CRS Customer Details File             *
      *  SRCRNHDet     - Access CRS NAHO Details File                 *
      *
      *  SRChkSRepCus  - Check Subject to Reporting                   *
      *  *PSSR         - Error Processing                             *
      *  *INZSR        - Initialise                                   *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Midas GL Report Management Extract Files
      ** GLCAPAPD, GLCSBAPD and GLFCABPD
     FGLCRMXL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL Report Management Extract Files
     FGLCRMXL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMXD0:GLCRMXD1)
      ** Midas GL Report Management Extract Files
     FGLCRMXL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMXD0:GLCRMXD2)
     F                                     PREFIX(X2)
      ** Midas SD CRS Customer Details File
     FSDCRSHL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD CRS Non-Account Holder Details File
     FSDCRNHL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD CRS Customer Details File - Exception
     FSDCRSHL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCRSHD0:SDCRSHD2)
     F                                     PREFIX(S_)

      ** Midas SD CRS Customer Details File - Exception
     FSDCRNHL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCRNHD0:SDCRNHD2)
     F                                     PREFIX(N_)
      ** Midas SD CRS Customer Details File
     FSDCRSDL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCRSDD0:SDCRSDD2)

      ** Midas SD CRS Customer Details File
     FSDCRSDL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD CRS Non-Account Holder Details File
     FSDCRSNL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCRSND0:SDCRSND2)

      ** Midas SD CRS Non-Account Holder Details File
     FSDCRSNL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Customer Details Ext C
     FSDCUSXL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Country Tax Codes File
     FSDCTTXL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas GL CRS XML Schema
     FGLGXMLL1  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Customer Authority Holder File
     FSDCUAHL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Customer Authority Holder File
     FSDCUAHL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCUAHD0:SDCUAHD1)
     F                                     PREFIX(L1_)

      ** Midas SD Joint Account Details File
     FSDJACCL0  IF   E           K DISK    INFSR(*PSSR)

      ** Midas SD Joint Account Details File
     FSDJACCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDJACCD0:SDJACCD1)
     F                                     PREFIX(M_)

      ** Midas SD Joint Account Details File
     FSDJACCL7  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDJACCD0:SDJACCD7)
     F                                     PREFIX(J_)

      ** Midas GL Report Management Includes Excludes
     FGLCRMIL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMID0:GLCRMID1)
     F                                     PREFIX(IE_)

      ** Midas GL Report Management Main File
     FGLCRMGL0  UF A E           K DISK    INFSR(*PSSR)

      ** Midas GL Report Management Main File
     FGLCRMGL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMGD0:GLCRMGD1)
     F                                     PREFIX(R1_)

      ** Midas GL Report Management Data File
     FGLCRMDL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMDD1)
     F                                     PREFIX(D1_)

      ** Midas GL Report Management Data File
     FGLCRMDLA  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMDP1)
     F                                     PREFIX(P1_)

      ** Midas GL Report Management Data File
     FGLCRMDL4  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMDD4)
     F                                     PREFIX(D4_)

     FGLCRMDL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLCRMDD0:GLCRMDD5)
     F                                     PREFIX(D5_)

      ** Midas SD FATCA Customer Details File
     FGLCRMDPD  O    E           K DISK    INFSR(*PSSR)

      ** Midas GL Report Management Includes Excludes
     FGLCRMIPD  UF A E           K DISK    INFSR(*PSSR)

      ** Midas GL Report Management                                                           CGL185
     FGLCAPAL1  UF A E           K DISK    INFSR(*PSSR)                                       CGL185
                                                                                              CGL185

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D SysVal1         C                   'CRSHighValCCY'
     D SysVal2         C                   'CRSReportVersion'

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** External data structure for Switchable Features Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** External data structure for Branch Code Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D                                     PREFIX(B_)

      ** External data structure for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)

      ** External data structure for Additional Customer Details
     D SDACUS        E DS                  EXTNAME(SDACUSPD)

      ** External data structure for Non-Account Holder
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)

      ** External data structure for Currency Code Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** External data structure for Report Management Details
     D GLCRMD        E DS                  EXTNAME(GLCRMDPD)

      ** External data structure for CRS Customer Details
     D SDCRSH        E DS                  EXTNAME(SDCRSHPD)

      ** External data structure for CRS Non Account Holder Details
     D SDCRNH        E DS                  EXTNAME(SDCRNHPD)

      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs, short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Second DS for access programs, long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)

     D WDTMST          DS
     D  WTMST                  1     26
     D  WWY1                   1      2
     D  WWY2                   3      4
     D  WWMM                   6      7
     D  WWDD                   9     10

      ***YYYYXXXZZ99999.001x format***********************************                      MD054905
     D*WMsgId***       DS                                                                   MD054905
     D**WMDate**               1      9                                                     MD054905
     D**WMsgNo**              10     14                                                     MD054905
     D**WMsgDot*              15     15    INZ('.')                                         MD054905
     D**WMsgAcSq              16     18                                                     MD054905
     D**WMsgDtyp              19     19                                                     MD054905
     D**WMsgActn              20     21                                                     MD054905
                                                                                            MD054905
      ** TTYYYYRRYYYYXXXZZ99999.001x format                                                 MD054905
     D WMsgId          DS                                                                   MD054905
     D  WMDate                 1     17                                                     MD054905
     D  WMsgNo                18     22                                                     MD054905
     D  WMsgDot               23     23    INZ('.')                                         MD054905
     D  WMsgAcSq              24     26                                                     MD054905
     D  WMsgDtyp              27     27                                                     MD054905
     D  WMsgActn              28     29                                                     MD054905

     D WTINS           DS
     D  WCTIN1                 1     25
     D  WCTIN2                26     50
     D  WCTIN3                51     75
     D  WCTIN4                76    100
     D  WCTIN5               101    125

     D WISCT           DS
     D  WISCT1                 1      2
     D  WISCT2                 3      4
     D  WISCT3                 5      6
     D  WISCT4                 7      8
     D  WISCT5                 9     10

     DWDS              DS
     D ArCorrDet                     83A   DIM(50)
     D  ACorrCust                    10A   OVERLAY(ArCorrDet:1)
     D  ACorrNum                     26A   OVERLAY(ArCorrDet:11)
     D  ACorDcRf                     33A   OVERLAY(ArCorrDet:37)
     D  ACorrMem                     10A   OVERLAY(ArCorrDet:70)
     D  ACorrTyp                      4A   OVERLAY(ArCorrDet:80)

     D ArExclDet                    280A   DIM(50)
     D  AExcCust                     10A   OVERLAY(ArExclDet:1)
     D  AExcRmrk                    256A   OVERLAY(ArExclDet:11)
     D  AExcMemb                     10A   OVERLAY(ArExclDet:267)
     D  AExcMTyp                      4A   OVERLAY(ArExclDet:277)
     D  AExclude                     14A   OVERLAY(ArExclDet:267)

     D ArInclDet                    278A   DIM(50)
     D  AInclFlg                      1A   OVERLAY(ArInclDet:1)
     D  AInclCust                    10A   OVERLAY(ArInclDet:2)
     D  AInclMIR                    256A   OVERLAY(ArInclDet:12)
     D  AInclude                     11A   OVERLAY(ArInclDet:1)

     D ArCtryLst                     27A   DIM(8)
     D  ACtryTinn                    25A   OVERLAY(ArCtryLst:1)
     D  ACtryIsBy                     2A   OVERLAY(ArCtryLst:26)

      ** Array of Fields for List of Customer/Non-Acct Holders
     D ArListCust      S              7A   DIM(28)
     D ArListNaho      S             11A   DIM(18)
     D ArAcctNumbr     S             83A   DIM(50)
     D ArExcCust       S            280A   DIM(50)
     D ArIncCust       S            278A   DIM(50)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Timestamp for the transaction
     D PTimeStamp      S               Z

      ** Parameters for ZXRATE
     D ZRATE1          S             13P 8
     D ZMDI1           S              1
     D ZRATE2          S             13P 8
     D ZMDI2           S              1
     D ZRATEX          S             13P 8
     D ZMDIX           S              1

      ** Parameters for ZCONVZ1
     D ZAMTCI          S             15  0
     D ZEXCH           S             13P 8
     D ZMD             S              1
     D ZCCYI           S              3
     D ZCCYO           S              3
     D ZCDPI           S              1  0
     D ZCDPO           S              1  0
     D ZAMTCO          S             15  0

      ** Paramaters for ZALIGN
     D ZalignOK        S              1A
     D Zfield          S             16A
     D Zadec           S              1P 0
     D Zadig           S              2P 0

      ** Data structure for GPAOSVALR0 string
     D SValK1          S             20
     D SVal1           S            200
     D SValK2          S             20
     D SVal2           S            200
     D SValK3          S             20
     D SVal3           S            200
     D SValK4          S             20
     D SVal4           S            200
     D SValK5          S             20
     D SVal5           S            200
     D SValK6          S             20
     D SVal6           S            200
     D SValK7          S             20
     D SVal7           S            200
     D SValK8          S             20
     D SVal8           S            200
     D SValK9          S             20
     D SVal9           S            200
     D SValK0          S             20
     D SVal10          S            200

     D PRtcd           S              7
     D PrtrnCode       S              7
     D PActn           S              1
     D PMsId           S                   LIKE(MGMSID)
     D PMsgId          S                   LIKE(MGMSID)
     D PMesgID         S                   LIKE(MGMSID)
     D W1AMID          S                   LIKE(MGMSID)
     D W3AMID          S                   LIKE(MGMSID)
     D KElemnam        S             30
     D WActn           S              1
     D POptn           S              7
     D PYear           S              4
     D PBrcd           S              3
     D PCtry           S              2
     D PStat           S              4
     D PWMsg           S             50
     D KCust           S             10
     D FCust           S              6
     D DCust           S              6
     D DNaho           S             10
     D KECus           S             10
     D KAcno           S             26
     D KAcho           S             10
     D KEFlag          S              1
     D KERef           S             10
     D KTpElt          S                   LIKE(MGTPMT)
     D KTopMT          S                   LIKE(MGTPMT)
     D WResCtry        S                   LIKE(MGDATA)
     D KMsgSeq         S              5S 0
     D PCUST           S             10
     D PCuah           S             10
     D PSub10          S             10
     D PSub6           S              6
     D WCuahFlg        S              1
     D WCuahFl2        S              1
     D PRType          S                   LIKE(GGRTYP)
     D PAcus           S              6
     D KNAHO           S             10
     D PNAHO           S             10
     D PCNST           S              7
     D PCurr           S                   LIKE(EXCCY)
     D WRUN            S              1
     D WBALN           S                   LIKE(EXBALN)
     D NCust           S                   LIKE(EXCUSD)
     D WCust           S                   LIKE(EXCUSD)
     D WIndAcc         S                   LIKE(EXACNO)
     D WIndCus         S                   LIKE(EXCUSD)
     D WRType          S                   LIKE(GGRTYP)
     D WCtry           S              2A   INZ(*BLANKS)
     D WExcIx          S              2S 0
     D WDocTyp         S             10A
     D WCorrDocRef     S             33A
     D WDocRef1        S             33A
     D WDocRef2        S             33A
     D WDocRef3        S             33A
     D WDocRef4        S             33A
     D WDocRef5        S             33A
     D WDocRef6        S             33A
     D KMsgNo          S                   LIKE(MGMSID)
     D WMsgSeq         S              5S 0
     D PBranch         S              3A
     D WField          S             11A
     D WExFld          S             14A
     D WBRIntCust      S              6A
     D WReportInd      S              1A
     D WReportJnt      S              1A
     D WActHldrTyp     S              8A
     D WTINCnt         S              2S 0
     D Iw              S              2S 0 INZ(0)
     D Ix              S              2S 0 INZ(0)
     D Iy              S              3S 0 INZ(0)
     D Iz              S              2S 0 INZ(0)
     D WHasContPer     S              1A
     D PRpDocRef       S             35A
     D WPrevRepIn      S              1A   INZ(' ')
     D WPrevRepJn      S              1A   INZ(' ')
     D WBrIntCOLC      S                   LIKE(BBCOLC)
     D WPayAct         S                   LIKE(EXACNO)
     D WPayTotCcy      S                   LIKE(EXPSTA)
     D WPrevCUSD       S                   LIKE(EXCUSD)
     D WPrevACNO       S                   LIKE(EXACNO)
     D WPrevPAYT       S                   LIKE(EXPAYT)
     D WPrevCCY        S                   LIKE(EXCCY)
     D WPrevPSTA       S                   LIKE(EXPSTA)
     D WPrevACTY       S                   LIKE(EXACTY)

     D KGroupNm        S                   LIKE(XMTPMT)
     D KElemNm         S                   LIKE(XMELMT)
     D IdxA            S                   LIKE(MGSEQU) INZ(0)
     D IdxB            S                   LIKE(MGSEQU) INZ(0)
     D IdxC            S                   LIKE(MGSEQU) INZ(0)
     D IxConPer        S                   LIKE(MGSEQU) INZ(0)
     D IxAccBal        S                   LIKE(MGSEQU) INZ(0)
     D IxPayment       S                   LIKE(MGSEQU) INZ(0)
     D SVTPMT          S                   LIKE(MGTPMT)

     D WkTYPE          S                   LIKE(EXTYPE)
     D WkSTYP          S                   LIKE(EXSTYP)
     D WkINFO          S                   LIKE(EXINFO)
     D WkHVAL          S                   LIKE(EXHVAL)
     D WkEXMP          S                   LIKE(EXEXMP)
     D WkDRMT          S                   LIKE(EXDRMT)
     D WkREPT          S              1A
     D WkCONS          S              1A
     D WReport         S              1A
     D WkAmend         S              1A
     D KJano           S             10A
     D XCust           S              6A
     D SCust           S              6A
     D WCttxRpt        S              1A
     D WCtryRprtng     S              1A
     D WCtryCRSA       S              1A
     D WRepYear        S              4S 0 INZ(0)
     D WCtryFRYR       S              4S 0 INZ(0)
     D KCTRR           S                   LIKE(BBCOLC)
     D KCTRT           S                   LIKE(BBCOLC)
     D ErrorFlag       S              1A
     D DateIn5         S              5P 0
     D DayOut8         S              8S 0
     D WkEFFYr         S              4S 0
     D WkEXPYr         S              4S 0
     D KDCus           S              6A
     D KDNAH           S             10A
     D KDCTY           S              2A
     D WNUM3           S              3S 0
     D WTINElem        S                   LIKE(MGELMT)                                     MD054940

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
      *
      ** Main Program

     C                   EXSR      SRAccSval
     C                   EVAL      PMesgID = PMsId
     C                   CLEAR                   GLCRMD

      ** Check Action to be taken

     C                   SELECT
     C                   WHEN      PActn = 'D'
     C                   MOVEL     PMsId         KMsgNo
     C                   EXSR      SRDelReport
      *
     C                   WHEN      PActn = 'N'
     C                             OR PActn = 'R'

      ** Processing reporting to write to Report Management Data File

     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId

     C                   EXSR      SRRepHeader
     C                   EXSR      SRReportFI

     C                   EVAL      GGAMID = *BLANKS
     C                   EXSR      SRWriteMain

     C                   EXSR      SRRepNew
     C                   EXSR      SRListExcptn

     C                   IF        PMSID <> *BLANKS
     C                             AND PActn = 'R'
     C                   EVAL      KMsgNo = PMSID
     C                   EXSR      SRDelReport
     C                   ENDIF

      ** For Amend and Corrected Reports

     C                   WHEN      PActn = 'C'

     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId

     C                   EVAL      GGAMID = *BLANKS
     C                   EXSR      SRWriteMain

     C                   EXSR      SRRepHeader
     C                   EXSR      SRReportFI

     C                   EXSR      SRRepCorrect
     C                   EXSR      SRListExcptn
      *
      ** For Include action from a 'DRAFT NEW' report
     C                   WHEN      PActn = 'I'
     C                             AND PRtype = 'DRAFT NEW'
      *
      ** Processing reporting to write to Report Management Data File
      *
     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId

     C                   EVAL      GGAMID = *BLANKS
     C                   EXSR      SRWriteMain

     C                   EVAL      kMsgNo = PMsID
     C                   EXSR      SRRepIncDrft
     C                   EXSR      SRRepIncld
      *
     C                   EXSR      SRListExcptn

     C                   IF        PMSID <> *BLANKS
     C                   EVAL      KMsgNo = PMSID
     C                   EXSR      SRDelReport
     C                   ENDIF

     C                   WHEN      PActn = 'I'
     C                             AND PRtype <> 'DRAFT NEW'
      *
      ** Processing reporting to write to Report Management Data File
      *
     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId

     C                   EXSR      SRRepHeader
     C                   EXSR      SRReportFI

     C                   EVAL      GGAMID = *BLANKS
     C                   EXSR      SRWriteMain

     C                   EXSR      SRRepIncld
     C                   EXSR      SRListExcptn
      *
      ** For Omit/Exclude action from a 'DRAFT NEW' report
     C                   WHEN      PActn = 'O'
     C                             AND PRtype = 'DRAFT NEW'

     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId

     C                   EVAL      GGAMID = *BLANKS
     C                   EXSR      SRWriteMain

     C                   EVAL      kMsgNo = PMsID
      ** Exclude Draft Report
     C                   EXSR      SRRepExcDraft

     C                   EXSR      SRListExcptn

     C                   IF        PMSID <> *BLANKS
     C                   EVAL      KMsgNo = PMSID
     C                   EXSR      SRDelReport
     C                   ENDIF

     C                   WHEN      PActn = 'O'
     C                             AND PRtype <> 'DRAFT NEW'
      ** Exclude Approved Report
     C                   EXSR      SRRepExcAppr
      *
     C                   WHEN      PActn = 'X'
     C                   MOVEL     PMsId         WMsgId
     C                   EXSR      SRGenMsgID
     C                   EVAL      kMsgNo = PMsID
     C                   EXSR      SRAppReport
      *
     C                   EVAL      GGAMID = PMsId
     C                   EVAL      W1AMID = GGAMID
     C                   EVAL      WRType = PRtype
     C                   EXSR      SRWriteMain
     C                   EVAL      W3AMID = GGMSID
     C                   EXSR      SRListExcptn
     C                   EXSR      SRCallXML

     C                   IF        W1AMID <> *BLANKS
     C                   EVAL      KMsgNo = W1AMID
     C                   EXSR      SRDelReport
     C                   ENDIF

     C                   ENDSL

     C                   EVAL      *INLR = *ON

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepHeader - Report Header Details                           *
      *                                                               *
      *****************************************************************
     C     SRRepHeader   BEGSR


     C                   EVAL      MGSEQU = 1
     C                   EVAL      MGELMT = 'CRS_OECD'
     C                   EVAL      MGTPMT = 'Root'
     C                   EVAL      MGDATA = Sval2
     C                   EVAL      MGCUST = *BLANKS
     C                   EVAL      MGACNO = *BLANKS
     C                   EVAL      MGACHO = *BLANKS
     C                   EVAL      MGMTYP = *BLANKS
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EXSR      SRWrite

     C                   EVAL      MGTPMT = 'MessageSpec'

     C                   EVAL      KGroupNm = 'CRS_OECD'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl

     C                   EVAL      PAcus = WBRIntCust
     C                   EXSR      SRAccAcus
     C                   EVAL      PCust = WBRIntCust
     C                   EXSR      SRAccCust
     C                   EVAL      WBrIntCOLC = BBCOLC

     C                   IF        PActn = 'N'
     C                             OR PActn = 'R'
     C                   EVAL      MGELMT = 'SendingCompanyIN'
     C                   EVAL      MGDATA = E5TINO
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'TransmittingCountry'
     C                   EVAL      MGDATA = WBrIntCOLC
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'ReceivingCountry'
     C                   EVAL      MGDATA = WBrIntCOLC
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'MessageType'
     C                   EVAL      MGDATA = 'CRS'
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'Warning'
     C                   EVAL      KMsgNo = PMesgID
     C                   EVAL      KElemnam = MGELMT
     C                   IF        PWMsg = *Blanks
     C     KWarn         CHAIN     GLCRMDL5
     C                   IF        %FOUND(GLCRMDL5)
     C                   EVAL      PWMsg = D5_MGDATA
     C                   ENDIF
     C                   ENDIF
     C                   EVAL      MGDATA = PWMsg
     C                   EVAL      PWMsg = *Blanks
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'MessageRefId'
     C                   EVAL      MGDATA = MGMSID
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'CorrMessageRefID'
     C                   IF        PActn = 'C'
     C                             OR PActn = 'O'
     C                             OR PActn = 'I'
     C                   EVAL      MGDATA = PMsid
     C                   ELSE
     C                   EVAL      MGDATA = *BLANK
     C                   ENDIF
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'ReportingPeriod'
     C                   EVAL      MGDATA = PYEAR + '-12-31'
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'Timestamp'
     C                   EVAL      MGDATA = %SUBST(WTMST:1:10)
     C                                      + 'T' + %SUBST(WTMST:12:2)
     C                                      + ':' + %SUBST(WTMST:15:2)
     C                                      + ':' + %SUBST(WTMST:18:2)
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'CrsBody'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      KGroupNm = 'CRS_OECD'
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'ReportingGroup'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      KGroupNm = 'CRS'
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EXSR      SRWrite

     C                   ELSE
     C                   EVAL      KMsgNo = PMsId
     C                   EVAL      KTopMT = 'MessageSpec'
     C     KRepFI        SETLL     GLCRMDL0
     C     KRepFI        READE     GLCRMDL0

     C                   DOW       NOT %EOF(GLCRMDL0)
     C                   EVAL      MGELMT = D1_MGELMT
     C                   EVAL      MGDATA = D1_MGDATA
     C                   EVAL      MGTPMT = D1_MGTPMT
     C                   EVAL      MGSEQU = D1_MGSEQU
     C                   EVAL      MGSEQ2 = D1_MGSEQ2
     C                   EVAL      MGDAT2 = D1_MGDAT2
     C                   EVAL      MGCUST = D1_MGCUST
     C                   EVAL      MGACHO = D1_MGACHO
     C                   EVAL      MGMTYP = D1_MGMTYP
     C                   EVAL      MGACNO = D1_MGACNO
     C                   EVAL      MGLEVL = D1_MGLEVL
     C                   SELECT
     C                   WHEN      MGELMT = 'MessageRefId'
     C                   EVAL      MGDATA = MGMSID
     C                   WHEN      MGELMT = 'CorrMessageRefID'
     C                   IF        PActn = 'C'
     C                             OR PActn = 'O'
     C                             OR PActn = 'I'
     C                   EVAL      MGDATA = PMsid
     C                   ENDIF
     C                   WHEN      MGELMT = 'Timestamp'
     C                   EVAL      MGDATA = %SUBST(WTMST:1:10)
     C                                      + 'T' + %SUBST(WTMST:12:2)
     C                                      + ':' + %SUBST(WTMST:15:2)
     C                                      + ':' + %SUBST(WTMST:18:2)
     C                   ENDSL

     C                   EXSR      SRWrite
     C     KRepFI        READE     GLCRMDL0
     C                   ENDDO
     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReportFI - Reporting FI                                     *
      *                                                               *
      *****************************************************************
     C     SRReportFI    BEGSR

     C                   IF        PRpDocRef <> *BLANKS
     C                             AND PActn = 'C'
     C                             OR PActn = 'N'
     C                             OR PActn = 'R'
     C                   EVAL      MGTPMT = 'ReportingFI'
     C                   EVAL      MGCUST = *BLANKS
     C                   EVAL      MGACNO = *BLANKS
     C                   EVAL      KGroupNm = 'CRS'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl

     C                   EVAL      MGELMT = 'ResCountryCode'
     C                   EVAL      MGDATA = WBrIntCOLC
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'IN'
     C                   EVAL      MGDATA = E5TINO
     C                   EVAL      MGDAT2 = *BLANKS
     C                   EVAL      MGDAT2 = E5ISCT
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS

     C                   EVAL      MGELMT = 'Name'
     C                   EVAL      MGDATA = E5CNA1
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'ReportingFI'
     C                   EVAL      KElemNm  = 'Address'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'ReportingFI'

     C                   EVAL      MGELMT = 'CountryCode'
     C                   EVAL      MGDATA = BBCOLC
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'AddressFree'
     C                   IF        E5CNA3 = *BLANKS
     C                             AND E5CNA4 = *BLANKS
     C                             AND E5ZIPC = *BLANKS
     C                             AND E5CITY = *BLANKS
     C                   EVAL      MGDATA = *BLANKS
     C                   ELSE
     C                   EVAL      MGDATA = %TRIM(E5CNA3)
     C                                    + '/' + %TRIM(E5CNA4)
     C                                    + '/' + %TRIM(E5ZIPC)
     C                                    + '/' + %TRIM(E5CITY)
     C                   ENDIF
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'ReportingFI'
     C                   EVAL      KElemNm  = 'DocSpec'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite

     C                   EVAL      MGTPMT = 'ReportingFI'

     C                   EVAL      MGELMT = 'DocTypeIndic'
     C                   EVAL      MGDATA = WDoctyp
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'DocRefId'
     C**********         EVAL      MGDATA = %TRIM(WBRIntCust)                               MD054905
     C                   EVAL      MGDATA = PCtry + %TRIM(WBRIntCust)                       MD054905
     C                                      + '.' + WMsgAcSq + WMsgDtyp
     C                                      + WMsgActn
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'CorrDocRefId'
     C                   EVAL      MGDATA = PRpDocRef
     C                   EXSR      SRWrite

     C                   ELSE
     C                   EVAL      KMsgNo = PMsId
     C                   EVAL      KTopMT = 'ReportingFI'
     C     KRepFI        SETLL     GLCRMDL0
     C     KRepFI        READE     GLCRMDL0

     C                   DOW       NOT %EOF(GLCRMDL0)
     C                   EVAL      MGELMT = D1_MGELMT
     C                   EVAL      MGDATA = D1_MGDATA
     C                   EVAL      MGTPMT = D1_MGTPMT
     C                   EVAL      MGSEQU = D1_MGSEQU
     C                   EVAL      MGSEQ2 = D1_MGSEQ2
     C                   EVAL      MGDAT2 = D1_MGDAT2
     C                   EVAL      MGCUST = D1_MGCUST
     C                   EVAL      MGACHO = D1_MGACHO
     C                   EVAL      MGMTYP = D1_MGMTYP
     C                   EVAL      MGACNO = D1_MGACNO
     C                   EVAL      MGLEVL = D1_MGLEVL
     C                   SELECT
     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      Iz = %SCAN('.':MGDATA) + 1
     C                   EVAL      %SUBST(MGDATA:Iz:6) = WMsgAcSq + WMsgDtyp
     C                                                   + WMsgActn
     C                   ENDSL

     C                   EXSR      SRWrite
     C     KRepFI        READE     GLCRMDL0
     C                   ENDDO
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepNew    - Main Processing for Report Details              *
      *                                                               *
      *****************************************************************
     C     SRRepNew      BEGSR

     C                   EXSR      SRInit
     C                   EVAL      IxPayment = 3001

     C     PBrcd         SETLL     GLCRMXL0
     C     PBrcd         READE     GLCRMXL0

      ** Record found
     C                   DOW       NOT %EOF(GLCRMXL0)

     C                   IF        EXJANO = *BLANKS
                                                                                              CGL185
      ** Check reporting for zero and negative balances                                       CGL185
     C                   IF        EXFILE = 'FCAB'                                            CGL185
     C                             OR EXFILE = 'CSBA'                                         CGL185
     C                   IF        EXBALN >= 0                                                CGL185
     C                             AND EXACSQ <> 0                                            CGL185
     C                             OR EXBALN <= 0                                             CGL185
     C                             AND EXACSQ = 0                                             CGL185
     C     EXACNO        CHAIN     GLCAPAL1                                                   CGL185
     C                   IF        NOT %FOUND (GLCAPAL1)                                      CGL185
      ** If no income/payment, flag as lowdep so that it will not be reported                 CGL185
     C                   EVAL      KCust = EXCUSD                                             CGL185
     C                   EVAL      KAcno = EXACNO                                             CGL185
     C     KBrAcno1      SETGT     GLCRMXL0                                                   CGL185
     C     PBrcd         READE     GLCRMXL0                                                   CGL185
     C                   ITER                                                                 CGL185
     C                   ENDIF                                                                CGL185
     C                   ENDIF                                                                CGL185
     C                   ENDIF                                                                CGL185
                                                                                              CGL185
     C                   EVAL      MGCUST = EXCUSD
     C                   EXSR      SRCustCheck
     C                   ELSE
     C                   EXSR      SRJaccCheck
     C                   ENDIF

     C                   SELECT
     C                   WHEN      WReportInd = 'Y'

      ** Report Header and Individual/Organization Details for the
      ** Account Holder

     C                   IF        WIndAcc <> EXACNO
     C                             OR WIndCus <> EXCUSD
     C                   EVAL      WIndCUS = EXCUSD
     C                   EVAL      WIndAcc = EXACNO
     C                   EXSR      SRCsActRepHdr
     C                   EXSR      SRWrIndvRept
     C                   IF        WActHldrTyp <> 'CRS103'
     C                             AND WActHldrTyp <> 'CRS102'
     C                   IF        WActHldrTyp = 'CRS101'
     C                   EXSR      SRConPersn
     C                   ENDIF
     C                   ENDIF

      ** Report Account Balance of the Account Holder

     C                   EXSR      SRAccBalance
     C                   ENDIF

     C                   WHEN      WReportJnt = 'Y'

     C                   IF        WIndAcc <> EXACNO
     C                             OR
     C                             WIndCus <> EXCUSD
     C                   EVAL      WIndCUS = EXCUSD
     C                   EVAL      WIndAcc = EXACNO
     C                   EXSR      SRWrJaccRept
     C                   IF        WActHldrTyp <> 'CRS103'                                  MD041589
     C                             AND WActHldrTyp <> 'CRS102'                              MD041589
     C                   IF        WActHldrTyp = 'CRS101'                                   MD041589
     C                   EXSR      SRConPersn                                               MD041589
     C                   ENDIF                                                              MD041589
     C                   ENDIF                                                              MD041589
     C                   ENDIF

     C                   OTHER

     C                   ENDSL


     C                   EVAL      IdxC = 0

     C                   SELECT
     C                   WHEN      WPrevRepIn = 'Y'
     C                   EXSR      SRCompPaymt
     C                   WHEN      WPrevRepJn = 'Y'
     C                   EXSR      SRComPayJac
     C                   WHEN      WReportInd = 'Y'
     C                             OR WReportJnt = 'Y'
     C                   EXSR      SRCompPaymt
     C                   ENDSL

     C     PBrcd         READE     GLCRMXL0

     C                   ENDDO

     C                   EVAL      IdxC = 0
     C                   EVAL      EXCUSD = *BLANKS
     C                   EVAL      EXACNO = *BLANKS

     C                   SELECT
     C                   WHEN      WPrevRepIn = 'Y'
     C                   EXSR      SRCompPaymt
     C                   WHEN      WPrevRepJn = 'Y'
     C                   EXSR      SRComPayJac
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepCorrect - Amend Report for selected Customers            *
      *                                                               *
      *****************************************************************
     C     SRRepCorrect  BEGSR

     C                   EXSR      SRInit
     C                   EVAL      IxPayment = 3001

     C                   EVAL      Ix = 1
     C                   EVAL      ArCorrDet = *BLANKS
     C                   MOVEA     ArAcctNumbr   ArCorrDet
      *
      ** Report Account Holder selected for Amended
      *
     C                   DOW       ACorrCust(Ix) <> *BLANKS
     C                             AND Ix < 50

     C                   EVAL      WIndAcc = *BLANKS
     C                   EVAL      KCust = ACorrCust(Ix)
     C                   EVAL      KAcno = ACorrNum(Ix)
     C                   EVAL      WCorrDocRef  = ACorDcRf(Ix)

     C     KBrAcno1      SETLL     GLCRMXL0
     C     KBrAcno1      READE     GLCRMXL0

     C                   DOW       NOT %EOF(GLCRMXL0)

     C                   IF        EXJANO = *BLANKS
                                                                                              CGL185
      ** Check reporting for zero and negative balances                                       CGL185
     C                   IF        EXFILE = 'FCAB'                                            CGL185
     C                             OR EXFILE = 'CSBA'                                         CGL185
     C                   IF        EXBALN >= 0                                                CGL185
     C                             AND EXACSQ <> 0                                            CGL185
     C                             OR EXBALN <= 0                                             CGL185
     C                             AND EXACSQ = 0                                             CGL185
     C     EXACNO        CHAIN     GLCAPAL1                                                   CGL185
     C                   IF        NOT %FOUND (GLCAPAL1)                                      CGL185
      ** If no income/payment, flag as lowdep so that it will not be reported                 CGL185
     C                   EVAL      KCust = EXCUSD                                             CGL185
     C                   EVAL      KAcno = EXACNO                                             CGL185
     C     KBrAcno1      SETGT     GLCRMXL0                                                   CGL185
     C     KBrAcno1      READE     GLCRMXL0                                                   CGL185
     C                   ITER                                                                 CGL185
     C                   ENDIF                                                                CGL185
     C                   ENDIF                                                                CGL185
     C                   ENDIF                                                                CGL185
                                                                                              CGL185
     C                   EXSR      SRCustCheck
     C                   ELSE
     C                   EXSR      SRJaccCheck
     C                   ENDIF

     C                   SELECT
     C                   WHEN      WReportInd = 'Y'
      ** Report Header and Individual/Organization Details for the
      ** Account Holder
      *
     C                   IF        WIndAcc <> EXACNO
     C                             OR
     C                             WIndCus <> EXCUSD
     C                   EVAL      WIndCUS = EXCUSD
     C                   EVAL      WIndAcc = EXACNO
     C                   EXSR      SRCsActRepHdr
     C                   EXSR      SRWrIndvRept
     C                   IF        WActHldrTyp <> 'CRS103'
     C                             AND WActHldrTyp <> 'CRS102'
     C                   IF        WActHldrTyp = 'CRS101'
     C                   EXSR      SRConPersn
     C                   ENDIF
     C                   ENDIF
      *
      ** Report Account Balance of the Account Holder
      *
     C                   EXSR      SRAccBalance
     C                   ENDIF

     C                   WHEN      WReportJnt = 'Y'

     C                   IF        WIndAcc <> EXACNO
     C                             OR
     C                             WIndCus <> EXCUSD
     C                   EVAL      WIndCUS = EXCUSD
     C                   EVAL      WIndAcc = EXACNO
     C                   EXSR      SRWrJaccRept
     C                   IF        WActHldrTyp <> 'CRS103'                                  MD041589
     C                             AND WActHldrTyp <> 'CRS102'                              MD041589
     C                   IF        WActHldrTyp = 'CRS101'                                   MD041589
     C                   EXSR      SRConPersn                                               MD041589
     C                   ENDIF                                                              MD041589
     C                   ENDIF                                                              MD041589
     C                   ENDIF
     C                   ENDSL

     C                   EVAL      IdxC = 0

     C                   SELECT
     C                   WHEN      WPrevRepIn = 'Y'
     C                   EXSR      SRCompPaymt
     C                   WHEN      WPrevRepJn = 'Y'
     C                   EXSR      SRComPayJac
     C                   WHEN      WReportInd = 'Y'
     C                             OR WReportJnt = 'Y'
     C                   EXSR      SRCompPaymt
     C                   ENDSL

     C     KBrAcno1      READE     GLCRMXL0
     C                   ENDDO

     C                   EVAL      Ix = Ix + 1
     C                   ENDDO

      ** Report last payment from Account Array
     C                   EVAL      EXCUSD = *BLANKS
     C                   EVAL      EXACNO = *BLANKS
     C                   EVAL      IdxC = 0

     C                   SELECT
     C                   WHEN      WPrevRepIn = 'Y'
     C                   EXSR      SRCompPaymt
     C                   WHEN      WPrevRepJn = 'Y'
     C                   EXSR      SRComPayJac
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepIncDrft - Include Draft Report                           *
      *                                                               *
      *****************************************************************
     C     SRRepIncDrft  BEGSR

     C                   EVAL      IxPayment = 3001
     C                   EVAL      ArInclDet = *BLANKS
     C                   MOVEA     ArIncCust     ArInclDet

     C     KMsgNo        SETLL     GLCRMDL0
     C     KMsgNo        READE     GLCRMDL0

     C                   DOW       NOT %EOF(GLCRMDL0)

     C                   EVAL      WField = %SUBST(D1_MGMTYP:1:1) + D1_MGCUST
     C                   IF        %LOOKUP(WField:AInclude) = 0
     C                             AND WField <> *BLANKS
     C                             OR WField = *BLANKS
     C                   EVAL      MGMSID = WMsgId
     C                   EVAL      MGELMT = D1_MGELMT
     C                   IF        MGELMT = 'MessageRefId'
     C                   EVAL      MGDATA = MGMSID
     C                   ELSE
     C                   EVAL      MGDATA = D1_MGDATA
     C                   ENDIF
     C                   SELECT
     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      Iz = %SCAN('.':MGDATA) + 1
     C                   EVAL      %SUBST(MGDATA:Iz:6) = WMsgAcSq + WMsgDtyp
     C                                                   + WMsgActn
     C                   WHEN      MGELMT = 'Timestamp'
     C                   EVAL      MGDATA = %SUBST(WTMST:1:10)
     C                                      + 'T' + %SUBST(WTMST:12:2)
     C                                      + ':' + %SUBST(WTMST:15:2)
     C                                      + ':' + %SUBST(WTMST:18:2)
     C                   WHEN      MGELMT = 'ReceivingCountry'
     C                   EVAL      WBrIntCOLC = D1_MGDATA
     C                   ENDSL
     C                   EVAL      MGTPMT = D1_MGTPMT
     C                   EVAL      MGSEQU = D1_MGSEQU
     C                   EVAL      MGSEQ2 = D1_MGSEQ2
     C                   EVAL      MGDAT2 = D1_MGDAT2
     C                   EVAL      MGCUST = D1_MGCUST
     C                   EVAL      MGACHO = D1_MGACHO
     C                   EVAL      MGMTYP = D1_MGMTYP
     C                   EVAL      MGACNO = D1_MGACNO
     C                   EVAL      MGLEVL = D1_MGLEVL
     C                   EXSR      SRWrite
     C                   ENDIF

     C     KMsgNo        READE     GLCRMDL0
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepIncld - Include Selected Customer to Report              *
      *                                                               *
      *****************************************************************
     C     SRRepIncld    BEGSR

     C                   EXSR      SRInit
     C                   EVAL      IxPayment = 3001

     C                   EVAL      Ix = 1
     C                   EVAL      ArInclDet = *BLANKS
     C                   MOVEA     ArIncCust     ArInclDet
      *
      ** Report Account Holder selected
      *
     C                   DOW       AInclCust(Ix) <> *BLANKS
     C                             AND Ix < 50
      ** For Customers
     C                   EVAL      KCust = AInclCust(Ix)

     C     KBrCust0      SETLL     GLCRMXL0
     C     KBrCust0      READE     GLCRMXL0

     C                   DOW       NOT %EOF(GLCRMXL0)

     C                   IF        EXJANO = *BLANKS
                                                                                              CGL185
      ** Check reporting for zero and negative balances                                       CGL185
     C                   IF        EXFILE = 'FCAB'                                            CGL185
     C                             OR EXFILE = 'CSBA'                                         CGL185
     C                   IF        EXBALN >= 0                                                CGL185
     C                             AND EXACSQ <> 0                                            CGL185
     C                             OR EXBALN <= 0                                             CGL185
     C                             AND EXACSQ = 0                                             CGL185
     C     EXACNO        CHAIN     GLCAPAL1                                                   CGL185
     C                   IF        NOT %FOUND (GLCAPAL1)                                      CGL185
      ** If no income/payment, flag as lowdep so that it will not be reported                 CGL185
     C                   EVAL      KCust = EXCUSD                                             CGL185
     C                   EVAL      KAcno = EXACNO                                             CGL185
     C     KBrAcno1      SETGT     GLCRMXL0                                                   CGL185
     C     KBrCust0      READE     GLCRMXL0                                                   CGL185
     C                   ITER                                                                 CGL185
     C                   ENDIF                                                                CGL185
     C                   ENDIF                                                                CGL185
     C                   ENDIF                                                                CGL185
                                                                                              CGL185
     C                   EXSR      SRCustCheck

     C                   ELSE

     C                   EXSR      SRJaccCheck
     C                   ENDIF

     C                   SELECT
     C                   WHEN      WReportInd = 'Y'
      ** Report Header and Individual/Organization Details for the
      ** Account Holder
      *
     C                   IF        WIndAcc <> EXACNO
     C                             OR
     C                             WIndCus <> EXCUSD
     C                   EVAL      WIndCUS = EXCUSD
     C                   EVAL      WIndAcc = EXACNO
     C                   EXSR      SRCsActRepHdr
     C                   EXSR      SRWrIndvRept
     C                   IF        WActHldrTyp <> 'CRS103'
     C                             AND WActHldrTyp <> 'CRS102'
     C                   IF        WActHldrTyp = 'CRS101'
     C                   EXSR      SRConPersn
     C                   ENDIF
     C                   ENDIF
      *
      ** Report Account Balance of the Account Holder
      *
     C                   EXSR      SRAccBalance
     C                   ENDIF

     C                   WHEN      WReportJnt = 'Y'

     C                   IF        WIndAcc <> EXACNO
     C                             OR
     C                             WIndCus <> EXCUSD
     C                   EVAL      WIndCUS = EXCUSD
     C                   EVAL      WIndAcc = EXACNO
     C                   EXSR      SRWrJaccRept
     C                   IF        WActHldrTyp <> 'CRS103'                                  MD041589
     C                             AND WActHldrTyp <> 'CRS102'                              MD041589
     C                   IF        WActHldrTyp = 'CRS101'                                   MD041589
     C                   EXSR      SRConPersn                                               MD041589
     C                   ENDIF                                                              MD041589
     C                   ENDIF                                                              MD041589
     C                   ENDIF

     C                   OTHER

     C                   ENDSL

     C                   EVAL      IdxC = 0

     C                   SELECT
     C                   WHEN      WPrevRepIn = 'Y'
     C                   EXSR      SRCompPaymt
     C                   WHEN      WPrevRepJn = 'Y'
     C                   EXSR      SRComPayJac
     C                   WHEN      WReportInd = 'Y'
     C                             OR WReportJnt = 'Y'
     C                   EXSR      SRCompPaymt
     C                   ENDSL

     C     KBrCust0      READE     GLCRMXL0
     C                   ENDDO

     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
      *
      ** Report last payment from Account Array
     C                   EVAL      EXCUSD = *BLANKS
     C                   EVAL      EXACNO = *BLANKS
     C                   EVAL      IdxC = 0

     C                   SELECT
     C                   WHEN      WPrevRepIn = 'Y'
     C                   EXSR      SRCompPaymt
     C                   WHEN      WPrevRepJn = 'Y'
     C                   EXSR      SRComPayJac
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCsActRepHdr - Write Account Report to File                  *
      *                                                               *
      *****************************************************************
     C     SRCsActRepHdr BEGSR

     C                   EVAL      MGSEQU = 1

     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'DocSpec'
     C                   EXSR      SRGetGrpLevl
      *
     C                   EVAL      MGCUST = EXCUSD
     C                   EVAL      MGACHO = EXCUSD
     C                   EVAL      MGMTYP = 'CUST'
     C                   EVAL      MGACNO = EXACNO
     C                   EVAL      MGTPMT = 'AccountReport'
     C                   EVAL      MGELMT = 'DocTypeIndic'
     C                   EVAL      MGDATA = WDocTyp
     C                   EXSR      SRWrite
      *
     C                   EVAL      MGELMT = 'DocRefId'
     C**********         EVAL      MGDATA = %TRIM(EXACNO)                                   MD054905
     C                   EVAL      MGDATA = PCtry + %TRIM(EXACNO)                           MD054905
     C                                      + '.' + WMsgAcSq + WMsgDtyp
     C                                      + WMsgActn
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'CorrDocRefId'
     C                   EVAL      MGDATA = WCorrDocRef
     C                   EXSR      SRWrite

     C                   EVAL      MGCUST = EXCUSD
     C                   EVAL      MGACNO = EXACNO
     C                   EVAL      MGTPMT = 'AccountReport'

     C                   EVAL      KGroupNm = 'ReportingGroup'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl

     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      MGDATA = EXACNO
     C                   EXSR      SRWrite
                                                                                              CGL185
     C                   EXSR      SRAcctClose                                                CGL185
                                                                                              CGL185
     C                   EVAL      KGroupNm = 'ReportingGroup'                                CGL185
     C                   EVAL      KElemNm  = MGTPMT                                          CGL185
     C                   EXSR      SRGetGrpLevl                                               CGL185

     C                   EVAL      MGELMT = 'AccountNumber(DormantAccount)'
     C                   IF        EXDRMT = 'Y'
     C                   EVAL      MGDATA = 'Y'
     C                   ELSE
     C                   EVAL      MGDATA = *BLANKS
     C                   ENDIF
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'AccountHolder'
     C                   EVAL      MGDATA = EXCUSD
     C                   EVAL      MGDAT2 = 'CUST'
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS

     C                   EVAL      MGELMT = 'AcctHolderType'
     C                   EVAL      MGDATA =  WActHldrTyp
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'AccountReport'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      KGroupNm = 'ReportingGroup'
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'AccountHolder'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGELMT = 'AccountHolder'
     C                   EXSR      SRWrite

     C                   IF        EXTYPE <> 'P'
     C                   EVAL      MGTPMT = 'AccountHolder'
     C                   EVAL      MGELMT = 'AcctHolderType'
     C                   EVAL      MGDATA = WActHldrTyp
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EXSR      SRWrite
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      *                                                               *
      * SRWrJaccRept  - Reporting Joint Account Members               *
      *                                                               *
      *****************************************************************
     C     SRWrJaccRept  BEGSR
      *
     C                   EVAL      MGSEQU = 0
     C                   EVAL      IdxA = 0
      *
      ** Check if the member is selected for Amend
     C                   IF        PActn = 'C'
     C                   IF        ACorrMem(Ix) <> EXCUSD
     C                             AND ACorrTyp(Ix) = EXACTY
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if Joint account member should be reported
      *
     C                   EVAL      IdxA = IdxA + 1
     C                   EVAL      MGSEQU = IdxA
      *
     C                   EVAL      MGCUST = EXCUSD
     C                   EVAL      MGACNO = EXACNO
     C                   EVAL      MGACHO = EXCUSD
     C                   EVAL      MGMTYP = EXACTY
      *
     C                   EVAL      MGELMT = 'AccountReport'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      KGroupNm = 'ReportingGroup'
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EXSR      SRWrite
      *
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'AccountHolder'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGELMT = 'AccountHolder'
     C                   EXSR      SRWrite
      *
     C                   EVAL      MGTPMT = 'AccountReport'
      *
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'DocSpec'
     C                   EXSR      SRGetGrpLevl
      *
      *
     C                   EVAL      MGELMT = 'DocTypeIndic'
     C                   EVAL      MGDATA = WDocTyp
     C                   EXSR      SRWrite
      *
     C                   EVAL      MGELMT = 'DocRefId'
     C**********         EVAL      MGDATA = %TRIM(EXACNO)                                   MD054905
     C                   EVAL      MGDATA = PCtry + %TRIM(EXACNO)                           MD054905
     C                                      + '.' + WMsgAcSq + WMsgDtyp
     C                                      + WMsgActn
     C                   EXSR      SRWrite
      *
     C                   EVAL      MGELMT = 'CorrDocRefId'
     C                   EVAL      MGDATA = WCorrDocRef
     C                   EXSR      SRWrite
      *
     C                   EVAL      KGroupNm = 'ReportingGroup'
     C                   EVAL      KElemNm  = 'AccountReport'
     C                   EXSR      SRGetGrpLevl
      *
     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      MGDATA = EXACNO
     C                   EXSR      SRWrite
                                                                                              CGL185
     C                   EXSR      SRAcctClose                                                CGL185
                                                                                              CGL185
     C                   EVAL      KGroupNm = 'ReportingGroup'                                CGL185
     C                   EVAL      KElemNm  = 'AccountReport'                                 CGL185
     C                   EXSR      SRGetGrpLevl                                               CGL185
      *
     C                   IF        EXACTY = 'CUST'
      *
      ** Get Customer Details of the Joint Account Member
      *
     C                   EVAL      FCust = EXCUSD
     C                   EXSR      SRCRSHDet
      *
     C                   EVAL      PAcus = EXCUSD
     C                   EXSR      SRAccAcus
      *
     C                   EVAL      PCust = EXCUSD
     C                   EXSR      SRAccCust
      *
      *
     C                   EVAL      MGELMT = 'AccountHolder'
     C                   EVAL      MGDATA = EXCUSD
     C                   EVAL      MGDAT2 = EXACTY
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
      *
     C                   EVAL      MGTPMT = 'AccountReport'
     C                   EVAL      MGELMT = 'AcctHolderType'
     C                   EVAL      MGDATA = WActHldrTyp
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
      *
     C                   EXSR      SRWrite
      *
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'AccountHolder'
     C                   EXSR      SRGetGrpLevl
      *
     C                   IF        CRTYPE <> 'P'
     C                   EVAL      MGTPMT = 'AccountHolder'
     C                   EXSR      SRWrite
     C                   ENDIF
      *
     C                   IF        CRTYPE = 'P'
     C                   EVAL      MGTPMT = 'Individual'
     C                   ELSE
     C                   EVAL      MGTPMT = 'Organisation'
     C                   ENDIF
      *
     C                   EVAL      MGELMT = 'AccountHolder'
     C                   EVAL      MGDATA = EXCUSD
     C                   EVAL      MGDAT2 = EXACTY
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
      *
     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGDATA = EXACNO
     C                   EXSR      SRWrite
      *
     C                   EVAL      KGroupNm = 'AccountHolder'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl
      *
     C                   EXSR      SRWrCusDetail
      *
     C                   IF        CRTYPE = 'P'
      *
     C                   EVAL      KGroupNm = 'Individual'
     C                   EVAL      KElemNm  = 'BirthInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'Individual'
      *
     C                   EVAL      MGELMT = 'BirthDate'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      MGDATA = E5DBTH
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'City'
     C                   EVAL      MGDATA = E5BTHT
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'BirthInfo'
     C                   EVAL      KElemNm  = 'CountryInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGELMT = 'CountryInfo'
     C                   EVAL      MGDATA = *Blanks
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'CountryInfo'
     C                   EVAL      KElemNm  = 'CountryCode'
     C                   EVAL      MGTPMT = KGroupNm
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = E5BTHC
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'Individual'

     C                   ENDIF
      *
     C                   ELSE
      *
      ** Get Non-Account Holder Details of the Joint Account Member
      *
     C                   EVAL      KNAHO  = EXCUSD
     C                   EXSR      SRCRNHDet
      *
     C                   EVAL      PNaho = EXCUSD
     C                   EXSR      SRAccNaho
      *
     C                   EVAL      MGELMT = 'AccountHolder'
     C                   EVAL      MGDATA = EXCUSD
     C                   EVAL      MGDAT2 = 'NAHO'
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
      *
     C                   IF        NRTYPE = 'P'
     C                   EVAL      MGLEVL = 0
     C                   ELSE
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'AccountHolder'
     C                   EXSR      SRGetGrpLevl
     C                   ENDIF
     C                   EVAL      MGTPMT = 'AccountReport'
     C                   EVAL      MGELMT = 'AcctHolderType'
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGDATA =  WActHldrTyp
     C                   EXSR      SRWrite
      *
     C                   IF        NRTYPE = 'P'
     C                   EVAL      MGTPMT = 'Individual'
     C                   ELSE
     C                   EVAL      MGTPMT = 'Organisation'
     C                   ENDIF
      *
     C                   EVAL      MGELMT = 'AccountHolder'
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGDATA = EXCUSD
     C                   EVAL      MGDAT2 = 'NAHO'
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
      *
     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGDATA = EXACNO
     C                   EXSR      SRWrite
      *
     C                   EVAL      KGroupNm = 'AccountHolder'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl
      *
     C                   EXSR      SRWrNahDetail
      *
     C                   IF        NRTYPE = 'P'
      *
     C                   EVAL      KGroupNm = 'Individual'
     C                   EVAL      KElemNm  = 'BirthInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'Individual'
      *
     C                   EVAL      MGELMT = 'BirthDate'
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVEL     NHDBTH        MGDATA
     C                   EXSR      SRWrite
      *
     C                   EVAL      MGELMT = 'City'
     C                   EVAL      MGDATA = NHBTHT
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'BirthInfo'
     C                   EVAL      KElemNm  = 'CountryInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGELMT = 'CountryInfo'
     C                   EVAL      MGDATA = *Blanks
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'CountryInfo'
     C                   EVAL      KElemNm  = 'CountryCode'
     C                   EVAL      MGTPMT = KGroupNm
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = NHBTHC
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'Individual'

     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Report Account Balance of the Account Holder
     C                   EXSR      SRAccBalance
      *
      ** Read next Joint Account member
      *
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrCusDetail - Reporting Individual Account                  *
      *                                                               *
      *****************************************************************
     C     SRWrCusDetail BEGSR
      *
     C                   EVAL      SVTPMT = MGTPMT
      *
     C                   IF        MGTPMT = 'Organisation'
     C**********         EVAL      MGELMT = 'ResCountryCode'                                MD054986
     C**********         EVAL      MGDATA = BBCOLC                                          MD054986
     C**********         EVAL      KGroupNm = MGTPMT                                        MD054986
     C**********         EVAL      KElemNm  = MGELMT                                        MD054986
     C**********         EXSR      SRGetGrpLevl                                             MD054986
     C**********         EXSR      SRWrite                                                  MD054986

     C                   EVAL      MGELMT = 'IN'
     C                   EVAL      WTINElem  = 'IN'                                         MD054940
     C                   EVAL      DCust =  CRCUST                                          MD054986
     C                   EXSR      SRCusCtryLst                                             MD054986
     C**********         EVAL      MGDATA = E5TINO                                          MD054986
     C**********         EVAL      MGDAT2 = E5ISCT                                          MD054986
     C**********         EVAL      KGroupNm = MGTPMT                                        MD054986
     C**********         EVAL      KElemNm  = MGELMT                                        MD054986
     C**********         EXSR      SRGetGrpLevl                                             MD054986
     C**********         EXSR      SRWrite                                                  MD054986
     C**********         EVAL      MGDAT2 = *BLANKS                                         MD054986
     C                   ELSE
     C                   EVAL      MGELMT = 'TIN'                                           MD054986
     C                   EVAL      WTINElem  = 'TIN'                                        MD054940
     C                   EVAL      DCust =  CRCUST
     C                   EXSR      SRCusCtryLst
     C                   ENDIF
      *
     C                   IF        CRTYPE = 'P'
     C                   EVAL      KGroupNm = SVTPMT
     C                   EVAL      KElemNm  = 'Name'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = SVTPMT
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'Name'
     C                   EVAL      KElemNm  = 'FirstName'
     C                   EVAL      MGELMT = 'FirstName'
     C                   EVAL      MGTPMT = 'Name'
     C                   EVAL      MGDATA = E5CNA2
     C                   EXSR      SRWrite
      *
     C                   EVAL      MGELMT = 'LastName'
     C                   EVAL      MGDATA = E5CNA1
     C                   EXSR      SRWrite
     C                   ELSE
     C                   EVAL      MGELMT = 'Name'
     C                   EVAL      MGDATA = BBCNA1
     C                   EXSR      SRWrite
     C                   ENDIF
      *
     C                   EVAL      KGroupNm = SVTPMT
     C                   EVAL      KElemNm  = 'Address'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = SVTPMT

     C                   EVAL      MGELMT = 'CountryCode'
     C                   EVAL      MGDATA = BBCOLC
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'AddressFree'
     C                   IF        E5CNA3 = *BLANKS
     C                             AND E5CNA4 = *BLANKS
     C                             AND E5ZIPC = *BLANKS
     C                             AND E5CITY = *BLANKS
     C                   EVAL      MGDATA = *BLANKS
     C                   ELSE
     C                   EVAL      MGDATA = %TRIM(E5CNA3)
     C                                    + '/' + %TRIM(E5CNA4)
     C                                    + '/' + %TRIM(E5ZIPC)
     C                                    + '/' + %TRIM(E5CITY)
     C                   ENDIF
     C                   EXSR      SRWrite
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrNahDetail - Reporting Detail for Non-Account Holder       *
      *                                                               *
      *****************************************************************
     C     SRWrNahDetail BEGSR

     C                   EVAL      SVTPMT = MGTPMT

     C                   IF        MGTPMT = 'Organisation'
     C**********         EVAL      MGELMT = 'ResCountryCode'                                MD054986
     C**********         EVAL      KGroupNm = MGTPMT                                        MD054986
     C**********         EVAL      KElemNm  = MGELMT                                        MD054986
     C**********         EXSR      SRGetGrpLevl                                             MD054986
     C**********         EVAL      MGDATA = NHCOLC                                          MD054986
     C**********         EXSR      SRWrite                                                  MD054986
     C                   EVAL      MGELMT = 'IN'
     C                   EVAL      WTINElem  = 'IN'                                         MD054940
     C                   EVAL      DNaho =  NRNAHO                                          MD054986
     C                   EXSR      SRNahCtryLst                                             MD054986
     C**********         EVAL      KGroupNm = MGTPMT                                        MD054986
     C**********         EVAL      KElemNm  = MGELMT                                        MD054986
     C**********         EXSR      SRGetGrpLevl                                             MD054986
     C**********         EVAL      MGDATA = NHTINO                                          MD054986
     C**********         EVAL      MGDAT2 = NHISCT                                          MD054986
     C**********         EXSR      SRWrite                                                  MD054986
     C**********         EVAL      MGDAT2 = *BLANKS                                         MD054986
     C                   ELSE
     C                   EVAL      MGELMT = 'TIN'                                           MD054986
     C                   EVAL      WTINElem  = 'TIN'                                        MD054940
     C                   EVAL      DNaho =  NRNAHO
     C                   EXSR      SRNahCtryLst
     C                   ENDIF

     C                   IF        NRTYPE = 'P'
     C                   EVAL      KGroupNm = SVTPMT
     C                   EVAL      KElemNm  = 'Name'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = SVTPMT
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'Name'
     C                   EVAL      KElemNm  = 'FirstName'
     C                   EVAL      MGTPMT = 'Name'
     C                   EVAL      MGELMT = 'FirstName'
     C                   EVAL      MGDATA = NHIDE2
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'LastName'
     C                   EVAL      MGDATA = NHIDE1
     C                   EXSR      SRWrite
     C                   ELSE
     C                   EVAL      MGELMT = 'Name'
     C                   EVAL      MGDATA = NHCNA1
     C                   EXSR      SRWrite
     C                   ENDIF

     C                   EVAL      KGroupNm =  SVTPMT
     C                   EVAL      KElemNm  = 'Address'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = SVTPMT

     C                   EVAL      MGELMT = 'CountryCode'
     C                   EVAL      MGDATA = NHCOLC
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'AddressFree'
     C                   IF        NHIDE3 = *BLANKS
     C                             AND NHIDE4 = *BLANKS
     C                             AND NHZIPC = *BLANKS
     C                             AND NHCITY = *BLANKS
     C                   EVAL      MGDATA = *BLANKS
     C                   ELSE
     C                   EVAL      MGDATA = %TRIM(NHIDE3)
     C                                    + '/' + %TRIM(NHIDE4)
     C                                    + '/' + %TRIM(NHZIPC)
     C                                    + '/' + %TRIM(NHCITY)
     C                   ENDIF
     C                   EXSR      SRWrite
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrIndvRept  - Reporting Individual Account                  *
      *                                                               *
      *****************************************************************
     C     SRWrIndvRept  BEGSR

     C                   EVAL      MGCUST = EXCUSD
     C                   EVAL      MGACHO = EXCUSD
     C                   EVAL      MGMTYP = 'CUST'
     C                   EVAL      MGACNO = EXACNO

     C                   IF        EXTYPE = 'P'
     C                   EVAL      MGTPMT = 'Individual'
     C                   ELSE
     C                   EVAL      MGTPMT = 'Organisation'
     C                   ENDIF
     C                   EVAL      SVTPMT = MGTPMT

     C                   EVAL      MGELMT = 'AccountHolder'
     C                   EVAL      MGDATA = EXCUSD
     C                   EVAL      MGDAT2 = 'CUST'
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS

     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGDATA = EXACNO
     C                   EXSR      SRWrite

     C                   IF        MGTPMT = 'Organisation'
     C**********         EVAL      MGELMT = 'ResCountryCode'                                MD054986
     C**********         EVAL      KGroupNm = MGTPMT                                        MD054986
     C**********         EVAL      KElemNm  = MGELMT                                        MD054986
     C**********         EXSR      SRGetGrpLevl                                             MD054986
     C**********         EVAL      MGDATA = EXCOLC                                          MD054986
     C**********         EXSR      SRWrite                                                  MD054986

     C                   EVAL      MGELMT = 'IN'
     C                   EVAL      WTINElem  = 'IN'                                         MD054940
     C                   EVAL      DCust =  EXCUSD                                          MD054986
     C                   EXSR      SRCusCtryLst                                             MD054986
     C**********         EVAL      KGroupNm = MGTPMT                                        MD054986
     C**********         EVAL      KElemNm  = MGELMT                                        MD054986
     C**********         EXSR      SRGetGrpLevl                                             MD054986
     C**********         EVAL      MGDATA = EXTINO                                          MD054986
     C**********         EVAL      MGDAT2 = EXISCT                                          MD054986
     C**********         EXSR      SRWrite                                                  MD054986
     C**********         EVAL      MGDAT2 = *BLANKS                                         MD054986
     C                   ELSE
     C                   EVAL      MGELMT = 'TIN'                                           MD054986
     C                   EVAL      WTINElem  = 'TIN'                                        MD054940
     C                   EVAL      DCust =  EXCUSD
     C                   EXSR      SRCusCtryLst
     C                   ENDIF

     C                   EVAL      KGroupNm = 'AccountHolder'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl

     C                   EVAL      MGDAT2 = *BLANKS

     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = 'Name'
     C                   EXSR      SRGetGrpLevl

     C                   IF        EXTYPE = 'P'
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = 'Name'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGELMT = 'FirstName'
     C                   EVAL      MGDATA = EXCNA2
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'LastName'
     C                   EVAL      MGDATA = EXCNA1
     C                   EXSR      SRWrite
     C                   ELSE
     C                   EVAL      KGroupNm = 'AccountHolder'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGELMT = 'Name'
     C                   EVAL      MGDATA = EXCNA1
     C                   EXSR      SRWrite
     C                   ENDIF

     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = 'Address'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = SVTPMT

     C                   EVAL      MGELMT = 'CountryCode'
     C                   EVAL      MGDATA = EXCOLC
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'AddressFree'
     C                   IF        EXCNA3 = *BLANKS
     C                             AND EXCNA4 = *BLANKS
     C                             AND EXZIPC = *BLANKS
     C                             AND EXCITY = *BLANKS
     C                   EVAL      MGDATA = *BLANKS
     C                   ELSE
     C                   EVAL      MGDATA = %TRIM(EXCNA3)
     C                                    + '/' + %TRIM(EXCNA4)
     C                                    + '/' + %TRIM(EXZIPC)
     C                                    + '/' + %TRIM(EXCITY)
     C                   ENDIF
     C                   EXSR      SRWrite

     C                   IF        EXTYPE = 'P'
     C                   EVAL      KElemNm  = 'BirthInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = SVTPMT

     C                   EVAL      MGELMT = 'BirthDate'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      MGDATA = EXDBTH
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'City'
     C                   EVAL      MGDATA = EXBTHT
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'BirthInfo'
     C                   EVAL      KElemNm  = 'CountryInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGELMT = 'CountryInfo'
     C                   EVAL      MGDATA = *Blanks
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'CountryInfo'
     C                   EVAL      KElemNm  = 'CountryCode'
     C                   EVAL      MGTPMT = KGroupNm
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = EXBTHC
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = SVTPMT

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelReport - Delete a Report                                 *
      *                                                               *
      *****************************************************************
     C     SRDelReport   BEGSR
      *
      ** Delete Header File
     C     KCtrMsId      SETLL     GLCRMGL0
     C     KCtrMsId      READE     GLCRMGL0
     C                   DOW       NOT %EOF(GLCRMGL0)
     C                   DELETE    GLCRMGL0
     C     KCtrMsId      READE     GLCRMGL0
     C                   ENDDO
      *
      ** Delete detail File
     C     KMsgNo        SETLL     GLCRMDL0
     C     KMsgNo        READE     GLCRMDL0
      *
     C                   DOW       NOT %EOF(GLCRMDL0)
     C                   DELETE    GLCRMDL0
     C     KMsgNo        READE     GLCRMDL0
     C                   ENDDO
      *
      ** Delete also Exception List
      *
     C     KMsgNo        SETLL     GLCRMIL0
     C     KMsgNo        READE     GLCRMIL0
     C                   DOW       NOT %EOF(GLCRMIL0)
     C                   DELETE    GLCRMIL0
     C     KMsgNo        READE     GLCRMIL0
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepExcDraft - Exclude Draft Report                          *
      *                                                               *
      *****************************************************************
     C     SRRepExcDraft BEGSR

     C                   EVAL      ArExclDet = *BLANKS
     C                   MOVEA     ArExcCust     ArExclDet
     C                   EVAL      WRtype = 'DRAFT NEW'

     C     KMsgNo        SETLL     GLCRMDL0
     C     KMsgNo        READE     GLCRMDL0

     C                   DOW       NOT %EOF(GLCRMDL0)

      ** Skip write if Customer is Excluded from the report
     C                   EVAL      WExFld = D1_MGACHO + D1_MGMTYP
     C                   IF        %LOOKUP(WExFld:AExclude) <> 0
     C                             AND WExFld <> *BLANKS
     C                   ELSE

     C                   EVAL      MGMSID = WMsgId
     C                   EVAL      MGELMT = D1_MGELMT
     C                   IF        MGELMT = 'MessageRefId'
     C                   EVAL      MGDATA = MGMSID
     C                   ELSE
     C                   EVAL      MGDATA = D1_MGDATA
     C                   ENDIF

     C                   SELECT
     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      Iz = %SCAN('.':MGDATA) + 1
     C                   EVAL      %SUBST(MGDATA:Iz:6) = WMsgAcSq + WMsgDtyp
     C                                                   + WMsgActn
     C                   WHEN      MGELMT = 'Timestamp'
     C                   EVAL      MGDATA = %SUBST(WTMST:1:10)
     C                                      + 'T' + %SUBST(WTMST:12:2)
     C                                      + ':' + %SUBST(WTMST:15:2)
     C                                      + ':' + %SUBST(WTMST:18:2)
     C                   ENDSL

     C                   EVAL      MGTPMT = D1_MGTPMT
     C                   EVAL      MGSEQU = D1_MGSEQU
     C                   EVAL      MGSEQ2 = D1_MGSEQ2
     C                   EVAL      MGDAT2 = D1_MGDAT2
     C                   EVAL      MGCUST = D1_MGCUST
     C                   EVAL      MGACHO = D1_MGACHO
     C                   EVAL      MGMTYP = D1_MGMTYP
     C                   EVAL      MGACNO = D1_MGACNO
     C                   EVAL      MGLEVL = D1_MGLEVL
     C                   EXSR      SRWrite

     C                   ENDIF
     C     KMsgNo        READE     GLCRMDL0
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepExcAppr - Exclude Approved Report                        *
      *                                                               *
      *****************************************************************
     C     SRRepExcAppr  BEGSR
      *
     C                   IF        ArExcCust(1) <> *BLANKS
     C                   EVAL      WRtype = 'DRAFT DELETE'
     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId
     C                   EXSR      SRRepHeader
     C                   EXSR      SRReportFI
     C                   EXSR      SRWriteMain
      *
     C                   EVAL      ArExclDet = *BLANKS
     C                   MOVEA     ArExcCust     ArExclDet
     C                   EVAL      Ix = 1
      *
     C                   DOW       AExcCust(Ix) <> *BLANKS
     C                             AND Ix < 50
      *
     C                   EVAL      kMsgNo   = *BLANKS
     C                   EVAL      kMsgNo   = PMsId
     C                   EVAL      KEcus    = AExcCust(Ix)
      *
     C     KExclude      SETLL     GLCRMDL4
     C     KExclude      READE     GLCRMDL4
      *
     C                   DOW       NOT %EOF(GLCRMDL4)
     C                   IF        D4_MGACHO = AExcMemb(Ix)
     C                             AND D4_MGMTYP = AExcMTyp(Ix)
      *
      ** Report Detail
     C                   EVAL      MGELMT = D4_MGELMT
     C                   EVAL      MGDATA = D4_MGDATA
     C                   SELECT
     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      Iz = %SCAN('.':MGDATA) + 1
     C                   EVAL      %SUBST(MGDATA:Iz:6) = WMsgAcSq + WMsgDtyp
     C                                                   + WMsgActn
     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                             AND D4_MGACNO <> *BLANKS
     C                   EVAL      Iz = %SCAN('.':PMsid)
     C                   EVAL      MGDATA = %TRIM(D4_MGACNO)
     C                                      + %SUBST(Pmsid:Iz:7)
     C                   WHEN      MGELMT = 'DocTypeIndic'
     C                   EVAL      MGDATA = WDoctyp
     C                   ENDSL
     C                   EVAL      MGTPMT = D4_MGTPMT
     C                   EVAL      MGSEQU = D4_MGSEQU
     C                   EVAL      MGSEQ2 = D4_MGSEQ2
     C                   EVAL      MGDAT2 = D4_MGDAT2
     C                   EVAL      MGCUST = D4_MGCUST
     C                   EVAL      MGACHO = D4_MGACHO
     C                   EVAL      MGMTYP = D4_MGMTYP
     C                   EVAL      MGACNO = D4_MGACNO
     C                   EVAL      MGLEVL = D4_MGLEVL
     C                   EXSR      SRWrite
      *
     C                   ENDIF
     C     KExclude      READE     GLCRMDL4
     C                   ENDDO
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
      *
      *
     C                   EXSR      SRListExcptn
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCusCtryLst - Get Customer Country List                      *
      *                                                               *
      *****************************************************************
     C     SRCusCtryLst  BEGSR
      *
     C                   EVAL      ArCtryLst = *BLANKS
     C                   EVAL      WTINCnt  = 0
     C                   EVAL      WResCtry = *BLANKS
      *
     C     DCust         SETLL     SDCRSDL2
     C     DCust         READE     SDCRSDL2
     C                   DOW       NOT %EOF(SDCRSDL2)

      ** Check Country Tax Codes if Country is for Reporting
     C                   EVAL      KCTRR = CDCTRY
     C                   EVAL      WCttxRpt = 'N'
     C                   EXSR      SRDetAgrTyp

      ** Get Year number of Effective Date
     C                   IF        CDEFFD <> 0
     C                   EVAL      DateIn5 = CDEFFD
     C                   EXSR      SRCvtDate
     C                   MOVEL     DayOut8       WkEFFYr
     C                   ELSE
     C                   EVAL      WkEFFYr = 0
     C                   ENDIF

      ** Get Year number of Expiry Date
     C                   IF        CDEXPD <> 0
     C                   EVAL      DateIn5 = CDEXPD
     C                   EXSR      SRCvtDate
     C                   MOVEL     DayOut8       WkEXPYr
     C                   ELSE
     C                   EVAL      WkEXPYr = 0
     C                   ENDIF

     C                   IF        WCttxRpt = 'Y'
     C                             AND ((WkEFFYr <= WRepYear
     C                             AND WkEFFYr <> 0)
     C                             OR  WkEFFYr = 0)
     C                             AND ((WkEXPYr >= WRepYear
     C                             AND WkEXPYr <> 0)
     C                             OR  WkEXPYr = 0)
     C                             AND CDREPT = 'Y'

     C                   EVAL      WResCtry = %TRIM(WResCtry) + CDCTRY

     C                   IF        CDTINN <> *BLANKS
     C                   EVAL      WTINCnt  = WTINCnt + 1
     C                   EVAL      ACtryTinn(WTINCnt) = CDTINN
     C                   EVAL      ACtryIsBy(WTINCnt) = CDCTRY
     C                   IF        WTINCnt > 7
     C**********         EVAL      MGELMT = 'TIN'                                           MD054986
     C                   EVAL      MGELMT = WTINElem                                        MD054940
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGDATA = ACtryTinn(1) + ACtryTinn(2)
     C                                      + ACtryTinn(3) + ACtryTinn(4)
     C                                      + ACtryTinn(5) + ACtryTinn(6)
     C                                      + ACtryTinn(7) + ACtryTinn(8)
     C                   EVAL      MGDAT2 = ACtryIsBy(1) + ACtryIsBy(2)
     C                                      + ACtryIsBy(3) + ACtryIsBy(4)
     C                                      + ACtryIsBy(5) + ACtryIsBy(6)
     C                                      + ACtryIsBy(7) + ACtryIsBy(8)
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS

      ** Reset fields
     C                   EVAL      ArCtryLst = *BLANKS
     C                   EVAL      WTINCnt  = 0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C     DCust         READE     SDCRSDL2
     C                   ENDDO

     C                   EVAL      MGELMT = 'ResCountryCode'
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGDATA = WResCtry
     C                   EXSR      SRWrite

      ** If there are remaining TINs not reported
     C                   IF        WTINCnt > 0
     C**********         EVAL      MGELMT = 'TIN'                                           MD054940
     C                   EVAL      MGELMT = WTINElem                                        MD054940
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGDATA = ACtryTinn(1) + ACtryTinn(2)
     C                                      + ACtryTinn(3) + ACtryTinn(4)
     C                                      + ACtryTinn(5) + ACtryTinn(6)
     C                                      + ACtryTinn(7) + ACtryTinn(8)
     C                   EVAL      MGDAT2 = ACtryIsBy(1) + ACtryIsBy(2)
     C                                      + ACtryIsBy(3) + ACtryIsBy(4)
     C                                      + ACtryIsBy(5) + ACtryIsBy(6)
     C                                      + ACtryIsBy(7) + ACtryIsBy(8)
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNahCtryLst - Get Non-Acct Holder Country List               *
      *                                                               *
      *****************************************************************
     C     SRNahCtryLst  BEGSR
      *
     C                   EVAL      ArCtryLst = *BLANKS
     C                   EVAL      WTINCnt  = 0
     C                   EVAL      WResCtry = *BLANKS
      *
     C     DNaho         SETLL     SDCRSNL2
     C     DNaho         READE     SDCRSNL2
     C                   DOW       NOT %EOF(SDCRSNL2)

      ** Check Country Tax Codes if Country is for Reporting
     C                   EVAL      KCTRR = CNCTRY
     C                   EVAL      WCttxRpt = 'N'
     C                   EXSR      SRDetAgrTyp

      ** Get Year number of Effective Date
     C                   IF        CNEFFD <> 0
     C                   EVAL      DateIn5 = CNEFFD
     C                   EXSR      SRCvtDate
     C                   MOVEL     DayOut8       WkEFFYr
     C                   ELSE
     C                   EVAL      WkEFFYr = 0
     C                   ENDIF

      ** Get Year number of Expiry Date
     C                   IF        CNEXPD <> 0
     C                   EVAL      DateIn5 = CNEXPD
     C                   EXSR      SRCvtDate
     C                   MOVEL     DayOut8       WkEXPYr
     C                   ELSE
     C                   EVAL      WkEXPYr = 0
     C                   ENDIF

     C                   IF        WCttxRpt = 'Y'
     C                             AND ((WkEFFYr <= WRepYear
     C                             AND WkEFFYr <> 0)
     C                             OR  WkEFFYr = 0)
     C                             AND ((WkEXPYr >= WRepYear
     C                             AND WkEXPYr <> 0)
     C                             OR  WkEXPYr = 0)
     C                             AND CNREPT = 'Y'

     C                   EVAL      WResCtry = %TRIM(WResCtry) + CNCTRY

     C                   IF        CNTINN <> *BLANKS
     C                   EVAL      WTINCnt  = WTINCnt + 1
     C                   EVAL      ACtryTinn(WTINCnt) = CNTINN
     C                   EVAL      ACtryIsBy(WTINCnt) = CNCTRY
     C                   IF        WTINCnt > 7
     C**********         EVAL      MGELMT = 'TIN'                                           MD054986
     C                   EVAL      MGELMT = WTINElem                                        MD054940
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGDATA = ACtryTinn(1) + ACtryTinn(2)
     C                                      + ACtryTinn(3) + ACtryTinn(4)
     C                                      + ACtryTinn(5) + ACtryTinn(6)
     C                                      + ACtryTinn(7) + ACtryTinn(8)
     C                   EVAL      MGDAT2 = ACtryIsBy(1) + ACtryIsBy(2)
     C                                      + ACtryIsBy(3) + ACtryIsBy(4)
     C                                      + ACtryIsBy(5) + ACtryIsBy(6)
     C                                      + ACtryIsBy(7) + ACtryIsBy(8)
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
      ** Reset fields
     C                   EVAL      ArCtryLst = *BLANKS
     C                   EVAL      WTINCnt  = 0
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C     DNaho         READE     SDCRSNL2
     C                   ENDDO

     C                   EVAL      MGELMT = 'ResCountryCode'
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGDATA = WResCtry
     C                   EXSR      SRWrite

      ** If there are remaining TINs not reported
     C                   IF        WTINCnt > 0
     C**********         EVAL      MGELMT = 'TIN'                                           MD054940
     C                   EVAL      MGELMT = WTINElem                                        MD054940
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGDATA = ACtryTinn(1) + ACtryTinn(2)
     C                                      + ACtryTinn(3) + ACtryTinn(4)
     C                                      + ACtryTinn(5) + ACtryTinn(6)
     C                                      + ACtryTinn(7) + ACtryTinn(8)
     C                   EVAL      MGDAT2 = ACtryIsBy(1) + ACtryIsBy(2)
     C                                      + ACtryIsBy(3) + ACtryIsBy(4)
     C                                      + ACtryIsBy(5) + ACtryIsBy(6)
     C                                      + ACtryIsBy(7) + ACtryIsBy(8)
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccBalance - Report Account Balance                         *
      *                                                               *
      *****************************************************************
     C     SRAccBalance  BEGSR
      *
     C                   EVAL      MGCUST = EXCUSD
     C                   EVAL      MGACNO = EXACNO
     C                   EVAL      WBALN  = 0
      *
     C                   EVAL      KGroupNm = 'ReportingGroup'
     C                   EVAL      KElemNm  = 'AccountReport'
     C                   EXSR      SRGetGrpLevl
      *
     C                   EVAL      MGTPMT = 'AccountBalance'
     C                   IF        EXACSQ <> 0
     C                   EVAL      WBALN  = EXBALN * -1
     C                   ELSE
     C                   EVAL      WBALN  = EXBALN
     C                   ENDIF
     C                   EVAL      MGELMT = 'AccountBalance'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      MGDATA = %CHAR(WBALN)
     C                   EVAL      MGDAT2 = EXCCY
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenMsgID - Generate Message Ref ID                          *
      *                                                               *
      *****************************************************************
     C     SRGenMsgID    BEGSR
      *
      ** Determine Document Type and Action
     C                   EXSR      SRDetDocTyp

     C                   SELECT
     C                   WHEN      PActn = 'N'

     C**********         EVAL      WMDate   = WWY1 + WWY2 + PBrcd + PCtry                   MD054905
     C                   EVAL      WMDate   = PCtry + PYear + PCtry                         MD054905
     C                                        + WWY1 + WWY2 + PBrcd + PCtry                 MD054905
     C                   EVAL      KMsgNo   = *BLANKS
     C                   EVAL      KMsgNo   = WMDate + '99999' + '.'

     C     KCtrMsId      SETGT     GLCRMGL1
     C                   READP     GLCRMGL1

     C                   IF        %EOF(GLCRMGL1)
     C**********                   OR WMDate <> %SUBST(R1_GGMSID:1:9)                       MD054905
     C                             OR WMDate <> %SUBST(R1_GGMSID:1:17)                      MD054905
     C                   EVAL      WMsgSeq = 1
     C                   ELSE
     C                   MOVE      R1_GGMSID     WMsgID
     C                   MOVE      WMsgNo        WMsgSeq
     C                   EVAL      WMsgSeq = WMsgSeq + 1
     C                   ENDIF
     C                   MOVE      WMsgSeq       WMsgNo
     C                   EVAL      WMsgDtyp = 'D'
     C                   EVAL      WMsgActn = 'N '
     C                   EVAL      WMsgAcSq = '001'

     C                   WHEN      PActn = 'R'
     C                             OR PActn = 'C'
     C                             OR PActn = 'I'
     C                             OR PActn = 'X'
     C                             OR PActn = 'O'

     C                   IF        PActn <> 'X'
     C                   MOVEL     PMsId         WMsgId
     C                   ENDIF
     C**********         EVAL      KMsgNo = %SUBST(WMSgId:1:15) + '999ZZZ'                  MD054905
     C                   EVAL      KMsgNo = %SUBST(WMSgId:1:23) + '999ZZZ'                  MD054905

     C     KCtrMsId      SETGT     GLCRMGL1
     C                   READP     GLCRMGL1

     C                   IF        %EOF(GLCRMGL1)
     C**********                   OR WMDate <> %SUBST(R1_GGMSID:1:9)                       MD054905
     C**********                   OR WMsgNo <> %SUBST(R1_GGMSID:10:5)                      MD054905
     C                             OR WMDate <> %SUBST(R1_GGMSID:1:17)                      MD054905
     C                             OR WMsgNo <> %SUBST(R1_GGMSID:18:5)                      MD054905
     C                   EVAL      WMsgSeq = 1
     C                   ELSE
     C**********         EVAL      WMsgAcSq = %SUBST(R1_GGMSID:16:3)                        MD054905
     C                   EVAL      WMsgAcSq = %SUBST(R1_GGMSID:24:3)                        MD054905
     C                   MOVE      WMsgAcSq      WMsgSeq
     C                   EVAL      WMsgSeq  = WMsgSeq + 1
     C                   ENDIF
     C                   MOVE      WMsgSeq       WMsgAcSq
     C                   IF        PActn = 'X'
     C                   EVAL      WMsgDtyp = 'A'
     C                   ELSE
     C                   EVAL      WMsgDtyp = 'D'
     C                   ENDIF
     C                   SELECT
     C                   WHEN      PActn = 'N'
     C                             OR PActn = 'I'
     C                             OR PActn = 'R'
     C                   EVAL      WMsgActn = 'N '
     C                   WHEN      PActn = 'C'
     C                   EVAL      WMsgActn = 'C '
     C                   WHEN      PActn = 'O'
     C                             AND WRtype = 'DRAFT DELETE'
     C                   EVAL      WMsgActn = 'D '
     C                   ENDSL

     C                   OTHER
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConPersn - Report Controlling Persons for Account Holder    *
      *                                                               *
      *****************************************************************
     C     SRConPersn    BEGSR

     C                   EVAL      IdxB = 0
     C                   EVAL      IxConPer = 1000
     C                   EVAL      XCust = EXCUSD
     C     XCust         SETLL     SDJACCL0
     C     XCust         READE     SDJACCL0

     C                   DOW       NOT %EOF(SDJACCL0)

     C                   IF        JCCUST <> *BLANKS
     C                   EVAL      PSub10 = JCCUST
     C                   ELSE
     C                   EVAL      PSub10 = JCNAHO
     C                   ENDIF
     C                   EVAL      WHasContPer = 'N'
     C                   EVAL      WCuahFlg = ' '
     C                   EXSR      SRChkSubCat
     C                   IF        WHasContPer <> 'Y'
     C     XCust         READE     SDJACCL0
     C                   ITER
     C                   ENDIF

     C                   EVAL      IxConPer =IxConPer + 1
     C                   EVAL      MGSEQU =  IxConPer
     C
     C                   EVAL      MGCUST = EXCUSD
     C                   EVAL      MGACHO = EXCUSD
     C                   EVAL      MGMTYP = 'CUST'
     C                   EVAL      MGACNO = EXACNO

     C                   EVAL      MGELMT = 'ControllingPerson'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      MGTPMT = 'AccountReport'
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EXSR      SRWrite

     C                   EVAL      MGTPMT = 'ControllingPerson'

     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl

     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      MGDATA = EXACNO
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'ControllingPerson'
     C                   IF        JCCUST <> *BLANK
     C                   EVAL      MGDATA = JCCUST
     C                   EXSR      SRWrite

     C                   EVAL      PCUST  = JCCUST
     C                   EXSR      SRAccCust
     C                   EVAL      PAcus  = JCCUST
     C                   EXSR      SRAccAcus
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'ControllingPerson'
     C                   EXSR      SRGetGrpLevl

     C                   EVAL      MGELMT = 'CtrlgPersonType'                               MD054940
     C                   EVAL      MGDATA = 'CRS812'                                        MD054940
     C                   EXSR      SRWrite                                                  MD054940
                                                                                            MD054940
     C                   EVAL      MGELMT = 'Individual'                                    MD054940
     C                   EVAL      MGDATA = *BLANKS                                         MD054940
     C                   EVAL      MGTPMT = 'ControllingPerson'                             MD054940
     C                   EVAL      KGroupNm = 'ControllingPerson'                           MD054940
     C                   EVAL      KElemNm  = MGELMT                                        MD054940
     C                   EXSR      SRGetGrpLevl                                             MD054940
     C                   EXSR      SRWrite                                                  MD054940
     C                   EVAL      MGTPMT = 'Individual'                                    MD054940
                                                                                            MD054940
     C                   EVAL      FCust  = JCCUST
     C                   EXSR      SRCRSHDet
     C                   EXSR      SRWrCusDetail

     C**********         EVAL      KGroupNm = 'ControllingPerson'                           MD054940
     C                   EVAL      KGroupNm = 'Individual'                                  MD054940
     C                   EVAL      KElemNm  = 'BirthInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C**********         EVAL      MGTPMT = 'ControllingPerson'                             MD054940
     C                   EVAL      MGTPMT = 'Individual'                                    MD054940

     C                   EVAL      MGELMT = 'BirthDate'
     C                   EVAL      MGDATA = E5DBTH
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'City'
     C                   EVAL      MGDATA = E5BTHT
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'BirthInfo2'
     C                   EVAL      KElemNm  = 'CountryInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGELMT = 'CountryInfo'
     C                   EVAL      MGDATA = *Blanks
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'CountryInfo'
     C                   EVAL      KElemNm  = 'CountryCode'
     C                   EVAL      MGTPMT = KGroupNm
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = E5BTHC
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'ControllingPerson'

     C                   ELSE

     C                   EVAL      MGDATA = JCNAHO
     C                   EXSR      SRWrite

      ** Get Non-Account Holder Details of the Joint Account Member

     C                   EVAL      PNAHO  = JCNAHO
     C                   EXSR      SRAccNaho

      ** Get FATCA Non-Account Holder Details of the Joint Account Member


     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'ControllingPerson'
     C                   EXSR      SRGetGrpLevl

     C                   EVAL      MGELMT = 'CtrlgPersonType'                               MD054940
     C                   EVAL      MGDATA = 'CRS812'                                        MD054940
     C                   EXSR      SRWrite                                                  MD054940
                                                                                            MD054940
     C                   EVAL      MGELMT = 'Individual'                                    MD054940
     C                   EVAL      MGDATA = *BLANKS                                         MD054940
     C                   EVAL      MGTPMT = 'ControllingPerson'                             MD054940
     C                   EVAL      KGroupNm = 'ControllingPerson'                           MD054940
     C                   EVAL      KElemNm  = MGELMT                                        MD054940
     C                   EXSR      SRGetGrpLevl                                             MD054940
     C                   EXSR      SRWrite                                                  MD054940
     C                   EVAL      MGTPMT = 'Individual'                                    MD054940
                                                                                            MD054940
     C                   EVAL      KNAHO  = JCNAHO
     C                   EXSR      SRCRNHDet
     C                   EXSR      SRWrNahDetail


     C**********         EVAL      KGroupNm = 'ControllingPerson'                           MD054940
     C                   EVAL      KGroupNm = 'Individual'                                  MD054940
     C                   EVAL      KElemNm  = 'BirthInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C**********         EVAL      MGTPMT = 'ControllingPerson'                             MD054940
     C                   EVAL      MGTPMT = 'Individual'                                    MD054940

     C                   EVAL      MGELMT = 'BirthDate'
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVEL     NHDBTH        MGDATA
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'City'
     C                   EVAL      MGDATA = NHBTHT
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'BirthInfo2'
     C                   EVAL      KElemNm  = 'CountryInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGELMT = 'CountryInfo'
     C                   EVAL      MGDATA = *Blanks
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'CountryInfo'
     C                   EVAL      KElemNm  = 'CountryCode'
     C                   EVAL      MGTPMT = KGroupNm
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = NHBTHC
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'ControllingPerson'

     C                   ENDIF

     C     XCust         READE     SDJACCL0
     C                   ENDDO

     C                   EVAL      MGSEQ2 = 0

     C                   IF        EXJANO = *BLANKS
     C                   EVAL      XCust = EXCUSD

      ** Authority Holders
     C     XCust         SETLL     SDCUAHL0
     C     XCust         READE     SDCUAHL0

     C                   DOW       NOT %EOF(SDCUAHL0)

     C                   IF        CAPCNT <> *Blanks
     C                   MOVE      CAPCNT        WNUM3                                      MD055078
     C                   ELSE                                                               MD055078
     C                   EVAL      WNUM3 = *ZERO                                            MD055078
     C                   ENDIF                                                              MD055078
     C**********         MOVE      CAPCNT        WNUM3                                      MD055078
     C                   IF        WNUM3 <> *ZERO                                           MD055078
     C                             OR CACINT = 'Y'                                          MD055078
     C                   EVAL      IxConPer =IxConPer + 1
     C                   EVAL      MGSEQU =  IxConPer
     C**********         IF        WNUM3 <> *ZERO                                           MD055078
     C                   EVAL      MGCUST = EXCUSD
     C                   EVAL      MGACHO = EXCUSD
     C                   EVAL      MGMTYP = 'CUST'
     C                   EVAL      MGACNO = EXACNO

     C                   EVAL      MGELMT = 'ControllingPerson'
     C                   EVAL      MGDATA = *BLANKS
     C**********         EVAL      MGTPMT = *BLANKS                                         MD054940
     C                   EVAL      MGTPMT = 'AccountReport'                                 MD054940
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EXSR      SRWrite

     C                   EVAL      MGTPMT = 'ControllingPerson'                             MD054940
     C                   EVAL      MGLEVL = 0

     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      MGDATA = EXACNO
     C                   EXSR      SRWrite

     C                   EVAL      MGELMT = 'ControllingPerson'
     C                   EVAL      PCuah = CAAUTH                                           MD055078
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCuah
     C                   PARM      *BLANKS       PCNST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      MGDATA = PCuah                                           MD054940
     C                   EXSR      SRWrite                                                  MD054940
                                                                                            MD054940
     C                   EVAL      PAcus  = PCuah
     C                   EXSR      SRAccAcus

     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'ControllingPerson'
     C                   EXSR      SRGetGrpLevl

     C                   EVAL      MGELMT = 'CtrlgPersonType'                               MD054940
     C                   EVAL      MGDATA = 'CRS812'                                        MD054940
     C                   EXSR      SRWrite                                                  MD054940
                                                                                            MD054940
     C                   EVAL      MGELMT = 'Individual'                                    MD054940
     C                   EVAL      MGDATA = *BLANKS                                         MD054940
     C                   EVAL      MGTPMT = 'ControllingPerson'                             MD054940
     C                   EVAL      KGroupNm = 'ControllingPerson'                           MD054940
     C                   EVAL      KElemNm  = MGELMT                                        MD054940
     C                   EXSR      SRGetGrpLevl                                             MD054940
     C                   EXSR      SRWrite                                                  MD054940
     C                   EVAL      MGTPMT = 'Individual'                                    MD054940
                                                                                            MD054940
     C                   EVAL      FCust  = PCuah
     C                   EXSR      SRCRSHDet
     C                   EXSR      SRWrCusDetail

     C                   IF        CRTYPE = 'P'                                             MD045184
     C**********         EVAL      KGroupNm = 'ControllingPerson'                           MD054940
     C                   EVAL      KGroupNm = 'Individual'                                  MD054940
     C                   EVAL      KElemNm  = 'BirthInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C**********         EVAL      MGTPMT = 'ControllingPerson'                             MD054940
     C                   EVAL      MGTPMT = 'Individual'                                    MD054940

     C                   EVAL      MGELMT = 'BirthDate'
     C                   EVAL      MGDATA = E5DBTH
     C                   EXSR      SRWrite
     C                   ENDIF                                                              MD045184

     C                   ELSE
      *
      ** Check if it is a valid Non - Account Holder
      *
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCuah
     C     SDNAHO        PARM      SDNAHO        DSLDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      MGDATA = PCuah
     C                   EXSR      SRWrite

     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'ControllingPerson'
     C                   EXSR      SRGetGrpLevl

     C                   EVAL      MGELMT = 'CtrlgPersonType'                               MD054940
     C                   EVAL      MGDATA = 'CRS812'                                        MD054940
     C                   EXSR      SRWrite                                                  MD054940
                                                                                            MD054940
     C                   EVAL      MGELMT = 'Individual'                                    MD054940
     C                   EVAL      MGDATA = *BLANKS                                         MD054940
     C                   EVAL      MGTPMT = 'ControllingPerson'                             MD054940
     C                   EVAL      KGroupNm = 'ControllingPerson'                           MD054940
     C                   EVAL      KElemNm  = MGELMT                                        MD054940
     C                   EXSR      SRGetGrpLevl                                             MD054940
     C                   EXSR      SRWrite                                                  MD054940
     C                   EVAL      MGTPMT = 'Individual'                                    MD054940
                                                                                            MD054940
     C                   EVAL      KNAHO  = PCuah
     C                   EXSR      SRCRNHDet
     C                   EXSR      SRWrNahDetail

     C                   IF        NRTYPE = 'P'                                             MD045184
     C**********         EVAL      KGroupNm = 'ControllingPerson'                           MD054940
     C                   EVAL      KGroupNm = 'Individual'                                  MD054940
     C                   EVAL      KElemNm  = 'BirthInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C**********         EVAL      MGTPMT = 'ControllingPerson'                             MD054940
     C                   EVAL      MGTPMT = 'Individual'                                    MD054940

     C                   EVAL      MGELMT = 'BirthDate'
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVEL     NHDBTH        MGDATA
     C                   EXSR      SRWrite
     C                   ENDIF                                                              MD045184
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF
     C**********         ENDIF                                                              MD055078
     C     XCust         READE     SDCUAHL0
     C                   ENDDO

     C                   EVAL      MGSEQ2 = 0
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCompPaymt - Compute Payment Details for Reporting           *
      *                                                               *
      *****************************************************************
     C     SRCompPaymt   BEGSR
      *
      ** Check if Currency has change or Payment Type changed, write to report
      ** Check if payments for the Account in FCAB and CSBA
      *
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'Payment'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      IdxC = IdxC + 1
     C                   EVAL      MGSEQ2 = IdxC
      *
     C                   IF        EXACNO = WPrevAcno
      *
      ** Aggregate by Payment Type and Currency
      *
     C                   IF        EXPAYT <> WPrevPAYT
     C                             AND WPrevPAYT <> *BLANKS
     C                             OR  EXCCY <> WPrevCCY
     C                             AND WPrevCCY <> *BLANKS
     C                             OR  EXACNO <> WPrevACNO
     C                             AND WPrevACNO <> *BLANKS
     C                   IF        WPayTotCcy <> 0
     C                   EVAL      IxPayment = IxPayment + 1
      *
     C                   EVAL      MGCUST = WPrevCUSD
     C                   EVAL      MGACHO = WPrevCUSD
     C                   EVAL      MGMTYP = WPrevACTY
     C                   EVAL      MGACNO = WPrevACNO
     C                   EVAL      MGTPMT = 'Payment'
      *
     C                   EVAL      MGELMT = 'AccountHolder'
     C                   EVAL      MGDATA = WPrevCUSD
     C                   EVAL      MGDAT2 = WPrevACTY
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
      *
     C                   EXSR      SRWrPaytDet
      *
      ** Initialise work field for next record processing
     C                   EVAL      WPayTotCcy = 0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
     C                   IF        WPrevPAYT <> *BLANKS
     C                             AND WPayTotCcy <> 0
     C                             AND (WPrevRepIn = 'Y'                                    MD040916
     C                             OR WPrevRepJn = 'Y')                                     MD040916
     C                   EVAL      IxPayment = IxPayment + 1
     C                   EVAL      MGCUST = WPrevCUSD
     C                   EVAL      MGACHO = WPrevCUSD
     C                   EVAL      MGMTYP = WPrevACTY
     C                   EVAL      MGACNO = WPrevACNO
     C                   EVAL      MGTPMT = 'Payment'
      *
     C                   EVAL      MGELMT = 'AccountHolder'
     C                   EVAL      MGDATA = WPrevCUSD
     C                   EVAL      MGDAT2 = WPrevACTY
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
      *
     C                   EXSR      SRWrPaytDet
      *
     C                   ENDIF                                                              MD040916
     C                   EVAL      WPayTotCcy = 0
     C**********         ENDIF                                                              MD040916
     C                   ENDIF
      *
     C                   EVAL      WPayTotCcy = WPayTotCcy + EXPSTA
      *
      ** Save previous details
     C                   EVAL      WPrevCUSD = EXCUSD
     C                   EVAL      WPrevACNO = EXACNO
     C                   EVAL      WPrevPAYT = EXPAYT
     C                   EVAL      WPrevCCY = EXCCY
     C                   EVAL      WPrevACTY = EXACTY
     C                   EVAL      WPrevRepIn = WReportInd
     C                   EVAL      WPrevRepJn = WReportJnt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrPaytDet - Write Payment Details                           *
      *                                                               *
      *****************************************************************
     C     SRWrPaytDet   BEGSR
      *
     C                   EVAL      MGSEQU = IxPayment
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'Payment'
     C                   EVAL      MGELMT = 'Type'
     C                   SELECT
     C                   WHEN      WPrevPAYT = 'D'
     C                   EVAL      MGDATA = 'CRS501'
     C                   WHEN      WPrevPAYT = 'I'
     C                   EVAL      MGDATA = 'CRS502'
     C                   WHEN      WPrevPAYT = 'G'
     C                   EVAL      MGDATA = 'CRS503'
     C                   OTHER
     C                   EVAL      MGDATA = 'CRS504'
     C                   ENDSL
     C                   EXSR      SRWrite
      *
     C                   EVAL      MGELMT = 'PaymentAmnt'
     C                   EVAL      MGDATA = %CHAR(WPayTotCcy)
     C                   EVAL      MGDAT2 = WPrevCCY
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
      *
     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      MGDATA = WPrevACNO
     C                   EXSR      SRWrite
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRComPayJac - Report Payments for Joint Account members       *
      *                                                               *
      *****************************************************************
     C     SRComPayJac   BEGSR
      *
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'Payment'
     C                   EXSR      SRGetGrpLevl
      *
     C                   IF        EXACNO = WPrevAcno
      *
      ** Aggregate by Payment Type and Currency
      *
     C                   IF        EXPAYT <> WPrevPAYT
     C                             AND WPrevPAYT <> *BLANKS
     C                             OR  EXCCY <> WPrevCCY
     C                             AND WPrevCCY <> *BLANKS
     C                             OR  EXACNO <> WPrevACNO
     C                             AND WPrevACNO <> *BLANKS
     C                   IF        WPayTotCcy <> 0
     C                   EVAL      IxPayment = IxPayment + 1
      *
     C                   EVAL      MGCUST = WPrevCUSD
     C                   EVAL      MGACNO = WPrevACNO
     C                   EVAL      MGTPMT = 'Payment'
     C                   EVAL      MGACHO = WPrevCUSD
     C                   EVAL      MGMTYP = WPrevACTY
     C                   EVAL      MGDATA = WPrevCUSD
     C                   EVAL      MGDAT2 = WPrevACTY
     C                   EVAL      IdxC = IdxC + 1
     C                   EVAL      MGSEQ2 = IdxC
     C                   EVAL      MGELMT = 'AccountHolder'
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
      *
     C                   EXSR      SRWrPaytDet
      *
      *
     C                   EVAL      WPayTotCcy = 0
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
      *
     C                   IF        WPrevPAYT <> *BLANKS
     C                             AND WPayTotCcy <> 0
     C                             AND (WPrevRepIn = 'Y'                                    MD040916
     C                             OR WPrevRepJn = 'Y')                                     MD040916
     C                   EVAL      IxPayment = IxPayment + 1
      *
     C                   EVAL      MGCUST = WPrevCUSD
     C                   EVAL      MGACNO = WPrevACNO
     C                   EVAL      MGTPMT = 'Payment'
      *
     C                   EVAL      MGACHO = WPrevCUSD
     C                   EVAL      MGMTYP = WPrevACTY
     C                   EVAL      MGDATA = WPrevCUSD
     C                   EVAL      MGDAT2 = WPrevACTY
     C                   EVAL      IdxC = IdxC + 1
     C                   EVAL      MGSEQ2 = IdxC
     C                   EVAL      MGELMT = 'AccountHolder'
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
      *
     C                   EXSR      SRWrPaytDet
      *
      *
     C                   ENDIF                                                              MD040916
     C                   EVAL      WPayTotCcy = 0
     C**********         ENDIF                                                              MD040916
     C                   ENDIF
      *
     C                   EVAL      WPayTotCcy = WPayTotCcy + EXPSTA
      *
     C                   EVAL      WPrevCUSD = EXCUSD
     C                   EVAL      WPrevACNO = EXACNO
     C                   EVAL      WPrevPAYT = EXPAYT
     C                   EVAL      WPrevCCY = EXCCY
     C                   EVAL      WPrevACTY = EXACTY
     C                   EVAL      WPrevRepIn = WReportInd
     C                   EVAL      WPrevRepJn = WReportJnt
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SListExcptn - List all Customers or Non-acct Holder with Excpt*
      *                                                               *
      *****************************************************************
     C     SRListExcptn  BEGSR

     C                   SELECT
     C                   WHEN      PActn = 'N'
     C                             OR PActn = 'R'

     C     *LOVAL        SETLL     SDCRSHL2
     C                   READ      SDCRSHL2
     C                   DOW       NOT %EOF(SDCRSHL2)
     C                   EVAL      WReportInd = 'N'
     C                   EVAL      WReportJnt  = 'N'

     C                   EVAL      KCust  = S_CRCUST
     C     KBrCust0      CHAIN     GLCRMXL1
     C                   IF        %FOUND(GLCRMXL1)
     C                   EVAL      WCust  = *BLANKS
     C                   EXSR      SRCustCheck
     C                   ENDIF
     C                   IF        WReportInd = 'Y'
     C                             OR WReportJnt  = 'Y'
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = S_CRCUST
     C                   EVAL      IEINEX = *BLANKS
     C                   EVAL      IECNFL = 'C'
     C                   EVAL      IERMRK = *BLANKS
     C                   EVAL      IEUSER = *BLANKS
     C                   EVAL      IETMST = *BLANKS

     C                   WRITE     GLCRMID0
     C                   ENDIF

     C                   READ      SDCRSHL2
     C                   ENDDO

     C     *LOVAL        SETLL     SDCRNHL2
     C                   READ      SDCRNHL2

     C                   DOW       NOT %EOF(SDCRNHL2)
                                                                                            MD039670
     C                   EVAL      PNAHO = N_NRNAHO                                         MD039670
     C                   IF        PNAHO <> *BLANKS                                         MD039670
     C                   CALL      'AONAHOR0'                                               MD039670
     C                   PARM      *BLANKS       PrtrnCode                                  MD039670
     C                   PARM      '*KEY   '     POPTN                                      MD039670
     C                   PARM                    PNAHO                                      MD039670
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      MD039670
                                                                                            MD039670
     C                   IF        PrtrnCode = '*NRF'                                       MD039670
     C                             OR NHCHTP = 'D'                                          MD039670
     C                   READ      SDCRNHL2                                                 MD039670
     C                   ITER                                                               MD039670
     C                   ENDIF                                                              MD039670
     C                   ENDIF                                                              MD039670
                                                                                            MD039670
     C                   EVAL      WReportJnt  = 'N'

     C     N_NRNAHO      SETLL     SDJACCL7
     C     N_NRNAHO      READE     SDJACCL7
     C                   DOW       NOT %EOF(SDJACCL7)
      ** Check Join Acct is for reporting
      ** Check NAHO member if also for reporting
     C     J_JCJANO      CHAIN     SDCRSHL0
     C                   IF        %FOUND(SDCRSHL0)
     C                   IF        CRTYPE = 'J'
     C                             AND (CRHVAL = 'H' OR CRHVAL = 'M')
     C                             AND (CRINFO = 'Y' OR CRINFO = 'A')
     C                             AND CREXMP <> 'Y'
      ** Check if Joint Account is for reporting in at least one of the countries
     C                   EVAL      PCust = CRCUST
     C                   EXSR      SRAccCust
     C                   EVAL      DCust  = CRCUST
     C                   EVAL      KDCty = BBCOLC
     C                   EXSR      SRChkSRepCus
     C                   EVAL      WkREPT = WCtryRprtng
     C                   IF        WCtryRprtng = 'Y'
     C                   EVAL      WReportJnt  = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   IF        WReportJnt  = 'Y'
     C                   EVAL      KNAHO  = J_JCNAHO
     C                   EXSR      SRCRNHDet
     C                   EVAL      PNaho = J_JCNAHO
     C                   EXSR      SRAccNaho
     C                   EVAL      WCust = J_JCNAHO
     C                   EVAL      NCust = J_JCNAHO
     C                   EVAL      WkTYPE = NRTYPE
     C                   EVAL      KDCty = NHCOLC
     C                   EXSR      SRChkSRepNah
     C                   EVAL      WkREPT = WCtryRprtng
     C                   EVAL      WkTYPE = NRTYPE
     C                   EVAL      WkSTYP = NRSTYP
     C                   EVAL      WkINFO = NRINFO
     C                   EVAL      WkHVAL = NRHVAL
     C                   EVAL      WkEXMP = NREXMP
      *
     C                   EXSR      SRAccType
     C                   IF        WReport = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C     N_NRNAHO      READE     SDJACCL7
     C                   ENDDO
     C                   IF        WReportJnt  = 'Y'
     C                             AND WReport = 'Y'
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = N_NRNAHO
     C                   EVAL      IEINEX = *BLANKS
     C                   EVAL      IECNFL = 'N'
     C                   EVAL      IERMRK = *BLANKS
     C                   EVAL      IEUSER = *BLANKS
     C                   EVAL      IETMST = *BLANKS

     C                   WRITE     GLCRMID0
     C                   ENDIF

     C                   READ      SDCRNHL2
     C                   ENDDO

     C                   WHEN      PActn = 'I'
      *
     C     PMSID         SETLL     GLCRMIL0
     C     PMSID         READE     GLCRMIL0

     C                   DOW       NOT %EOF(GLCRMIL0)
     C                   EVAL      WField = IE_IECNFL+IE_IECREF
     C                   IF        %LOOKUP(WField:AInclude) = 0
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = IE_IECREF
     C                   EVAL      IEINEX = IE_IEINEX
     C                   EVAL      IECNFL = IE_IECNFL
     C                   EVAL      IERMRK = IE_IERMRK
     C                   EVAL      IEUSER = IE_IEUSER
     C                   EVAL      IETMST = IE_IETMST

     C                   WRITE     GLCRMID0
     C                   ELSE
     C                   EVAL      Iz = %LOOKUP(WField:AInclude)
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = IE_IECREF
     C                   EVAL      IEINEX = 'I'
     C                   EVAL      IECNFL = IE_IECNFL
     C                   EVAL      IERMRK = AInclMIR(Iz)
     C                   EVAL      IEUSER = PSUSER
     C                   EVAL      IETMST = WTMST

     C                   WRITE     GLCRMID0
     C                   ENDIF

     C     PMSID         READE     GLCRMIL0
     C                   ENDDO

     C                   WHEN      PActn = 'O'
     C                             AND PRType <> 'APPROVED NEW'
     C     PMSID         SETLL     GLCRMIL0
     C     PMSID         READE     GLCRMIL0
     C                   DOW       NOT %EOF(GLCRMIL0)
     C                   IF        %LOOKUP(IE_IECREF:AExcMemb) = 0
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = IE_IECREF
     C                   EVAL      IEINEX = IE_IEINEX
     C                   EVAL      IECNFL = IE_IECNFL
     C                   EVAL      IERMRK = IE_IERMRK
     C                   EVAL      IEUSER = IE_IEUSER
     C                   EVAL      IETMST = IE_IETMST

     C                   WRITE     GLCRMID0
     C                   ENDIF

     C     PMSID         READE     GLCRMIL0
     C                   ENDDO
      *
      ** Customer excluded from Account Report
     C                   EVAL      Ix = 1
     C                   EVAL      ArExclDet = *BLANKS
     C                   MOVEA     ArExcCust     ArExclDet
     C                   DOW       AExcCust(Ix) <> *BLANKS
     C                             AND Ix < 50
      *
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = AExcMemb(Ix)
     C                   EVAL      IEINEX = 'O'
     C                   IF        AExcMTyp(Ix) = 'CUST'
     C                   EVAL      IECNFL = 'C'
     C                   ELSE
     C                   EVAL      IECNFL = 'N'
     C                   ENDIF
     C                   EVAL      IERMRK = AExcRmrk(Ix)
     C                   EVAL      IEUSER = PSUSER
     C                   EVAL      IETMST = WTMST

     C                   WRITE     GLCRMID0
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO

     C                   WHEN      PActn = 'O'
     C                             AND PRType = 'APPROVED NEW'

      ** Customer excluded from Account Report
     C                   EVAL      Ix = 1
     C                   EVAL      ArExclDet = *BLANKS
     C                   MOVEA     ArExcCust     ArExclDet
     C                   DOW       AExcCust(Ix) <> *BLANKS
     C                             AND Ix < 50
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = AExcMemb(Ix)
     C                   EVAL      IEINEX = 'O'
     C                   IF        AExcMTyp(Ix) = 'CUST'
     C                   EVAL      IECNFL = 'C'
     C                   ELSE
     C                   EVAL      IECNFL = 'N'
     C                   ENDIF
     C                   EVAL      IERMRK = AExcRmrk(Ix)
     C                   EVAL      IEUSER = PSUSER
     C                   EVAL      IETMST = WTMST

     C                   WRITE     GLCRMID0
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO

     C                   WHEN      PActn = 'C'
     C                             OR PActn = 'X'

     C     PMSID         SETLL     GLCRMIL0
     C     PMSID         READE     GLCRMIL0
     C                   DOW       NOT %EOF(GLCRMIL0)
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = IE_IECREF
     C                   EVAL      IEINEX = IE_IEINEX
     C                   EVAL      IECNFL = IE_IECNFL
     C                   EVAL      IERMRK = IE_IERMRK
     C                   EVAL      IEUSER = IE_IEUSER
     C                   EVAL      IETMST = IE_IETMST
     C                   WRITE     GLCRMID0
     C     PMSID         READE     GLCRMIL0
     C                   ENDDO
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetRepType - Determine Report Type                          *
      *                                                               *
      *****************************************************************
     C     SRDetRepType  BEGSR
      *
     C                   SELECT
     C                   WHEN      PActn = 'N'
     C                             OR PActn = 'I'
     C                             OR PActn = 'R'
     C                             OR (PActn = 'O'
     C                             AND PRType = 'DRAFT NEW')
     C                   EVAL      WRType = 'DRAFT NEW'
      *
     C                   WHEN      PActn = 'C'
     C                             AND PRType = 'APPROVED NEW'
     C                   EVAL      WRType = 'DRAFT CORRECTED'
      *
     C                   WHEN      PActn = 'O'
     C                             AND PRType = 'APPROVED'
     C                   EVAL      WRType = 'DRAFT DELETE'
      *
     C                   WHEN      PActn = 'X'
     C                             AND PRType = 'DRAFT NEW'
     C                   EVAL      WRType = 'APPROVED NEW'
      *
     C                   WHEN      PActn = 'X'
     C                             AND PRType = 'DRAFT AMEND'
     C                   EVAL      WRType = 'APPROVED AMEND'
      *
     C                   WHEN      PActn = 'X'
     C                             AND PRType = 'DRAFT CORRECTED'
     C                   EVAL      WRType = 'APPROVED CORRECTED'
      *
     C                   WHEN      PActn = 'X'
     C                             AND PRType = 'DRAFT DELETE'
     C                   EVAL      WRType = 'APPROVED DELETE'
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAppReport - Approve Report                                  *
      *                                                               *
      *****************************************************************
     C     SRAppReport   BEGSR

     C     KMsgNo        SETLL     GLCRMDL0
     C     KMsgNo        READE     GLCRMDL0

     C                   DOW       NOT %EOF(GLCRMDL0)

     C                   EVAL      MGMSID = WMsgId
     C                   EVAL      MGELMT = D1_MGELMT
     C                   IF        MGELMT = 'MessageRefId'
     C                   EVAL      MGDATA = MGMSID
     C                   ELSE
     C                   EVAL      MGDATA = D1_MGDATA
     C                   ENDIF
     C                   SELECT
     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      Iz = %SCAN('.':MGDATA) + 1
     C                   EVAL      %SUBST(MGDATA:Iz:6) = WMsgAcSq + WMsgDtyp
     C                                                   + WMsgActn
     C                   WHEN      MGELMT = 'Timestamp'
     C                   EVAL      MGDATA = %SUBST(WTMST:1:10)
     C                                      + 'T' + %SUBST(WTMST:12:2)
     C                                      + ':' + %SUBST(WTMST:15:2)
     C                                      + ':' + %SUBST(WTMST:18:2)
     C                   ENDSL
     C                   EVAL      MGTPMT = D1_MGTPMT
     C                   EVAL      MGSEQU = D1_MGSEQU
     C                   EVAL      MGSEQ2 = D1_MGSEQ2
     C                   EVAL      MGDAT2 = D1_MGDAT2
     C                   EVAL      MGCUST = D1_MGCUST
     C                   EVAL      MGACHO = D1_MGACHO
     C                   EVAL      MGMTYP = D1_MGMTYP
     C                   EVAL      MGACNO = D1_MGACNO
     C                   EVAL      MGLEVL = D1_MGLEVL
     C                   EXSR      SRWrite

     C     KMsgNo        READE     GLCRMDL0
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWriteMain - Write to Main File                              *
      *                                                               *
      *****************************************************************
     C     SRWriteMain   BEGSR

     C                   EXSR      SRDetRepType
     C                   EVAL      GGRYER = PYear
     C                   EVAL      GGRBRC = PBrcd
     C                   EVAL      GGRCTR = PCtry
     C                   EVAL      GGRVER = Sval2
     C                   EVAL      GGRTYP = WRType
     C                   EVAL      GGSTAT = PStat
     C                   EVAL      GGMSID = WMsgId
     C                   EVAL      GGUSER = PSUSER
     C                   MOVEL     WTMST         GGDTTM

     C                   WRITE     GLCRMGD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCallXML - Call XML Generation                               *
      *                                                               *
      *****************************************************************
     C     SRCallXML     BEGSR

     C                   CALL      'GLC000769'
     C                   PARM      WMsgId        PMsgId
     C                   PARM      *BLANKS       Prtcd

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccType - Check Account Type for reporting                  *
      *                                                               *
      *****************************************************************
     C     SRAccType     BEGSR

     C                   EVAL      WReport = 'N'
     C                   SELECT
     C                   WHEN      WkTYPE = 'N'
     C                             AND WkSTYP = 'PA'
     C                             AND WkCONS = 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND (WkHVAL = 'H' OR WkHVAL = 'M')
     C                             AND (WkINFO = 'Y' OR WkINFO = 'A')
     C                             AND WkEXMP <> 'Y'
     C                   EVAL      WReport = 'Y'
     C                   EVAL      WActHldrTyp = 'CRS101'

     C                   WHEN      WkTYPE = 'N'
     C                             AND WkSTYP = 'AC'
     C                             AND WkREPT = 'Y'
     C                             AND (WkHVAL = 'H' OR WkHVAL = 'M')
     C                             AND (WkINFO = 'Y' OR WkINFO = 'A')
     C                             AND WkEXMP <> 'Y'
     C                   EVAL      WReport = 'Y'
     C                   EVAL      WActHldrTyp = 'CRS102'

     C                   WHEN      WkTYPE = 'P'
     C                             AND WkREPT = 'Y'
     C                             AND (WkHVAL = 'H' OR WkHVAL = 'M')
     C                             AND (WkINFO = 'Y' OR WkINFO = 'A')
     C                             AND WkEXMP <> 'Y'
     C                   EVAL      WReport = 'Y'
     C                   EVAL      WActHldrTyp = 'CRS102'

     C                   WHEN      WkTYPE = 'J'
     C                             AND WkREPT = 'Y'
     C                             AND (WkHVAL = 'H' OR WkHVAL = 'M')
     C                             AND (WkINFO = 'Y' OR WkINFO = 'A')
     C                             AND WkEXMP <> 'Y'
     C                   EVAL      WReport = 'Y'
     C                   EVAL      WActHldrTyp = 'CRS102'

     C                   WHEN      WkTYPE = 'O'
     C                             AND WkREPT = 'Y'
     C                             AND (WkHVAL = 'H' OR WkHVAL = 'M')
     C                             AND (WkINFO = 'Y' OR WkINFO = 'A')
     C                             AND WkEXMP <> 'Y'
     C                   EVAL      WReport = 'Y'
     C                   EVAL      WActHldrTyp = 'CRS102'

     C                   WHEN      WkTYPE = 'N'
     C                             AND WkSTYP = 'PA'
     C                             AND WkCONS = 'N'                                         MD055071
     C                             AND WkREPT = 'Y'
     C                             AND (WkHVAL = 'H' OR WkHVAL = 'M')
     C                             AND (WkINFO = 'Y' OR WkINFO = 'A')
     C                             AND WkEXMP <> 'Y'
     C                   EVAL      WReport = 'Y'
     C                   EVAL      WActHldrTyp = 'CRS103'

     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetDocTyp - Determine Document Type                         *
      *                                                               *
      *****************************************************************
     C     SRDetDocTyp   BEGSR
      *
     C                   IF        Pstat = 'LIVE'
     C                   SELECT
     C                   WHEN      PActn = 'N'
     C                             OR PActn = 'R'
     C                             OR PActn = 'I'
     C                   EVAL      WDocTyp= 'OECD1'
     C                   EVAL      WActn  = 'N'
     C                   WHEN      PActn = 'C'
     C                   EVAL      WDocTyp= 'OECD2'
     C                   EVAL      WActn  = 'C'
     C                   WHEN      PActn = 'O'
     C                             AND PRtype = 'DRAFT NEW'
     C                   EVAL      WDocTyp= 'OECD1'
     C                   EVAL      WActn  = 'O'
     C                   WHEN      PActn = 'O'
     C                             AND PRtype <> 'DRAFT NEW'
     C                   EVAL      WDocTyp= 'OECD3'
     C                   EVAL      WActn  = 'O'
     C                   ENDSL
     C                   ENDIF

     C                   IF        PStat = 'LIVE'
     C                             AND Pactn = 'X'
     C                   EVAL      WActn  = 'X'
     C                   ENDIF

     C                   IF        PStat = 'TEST'
     C                   SELECT
     C                   WHEN      PActn = 'N'
     C                             OR PActn = 'R'
     C                             OR PActn = 'I'
     C                   EVAL      WDocTyp = 'OECD11'
     C                   EVAL      WActn  = 'N'
     C                   WHEN      PActn = 'C'
     C                   EVAL      WDocTyp = 'OECD12'
     C                   EVAL      WActn  = 'C'
     C                   WHEN      PActn = 'O'
     C                             AND PRtype = 'DRAFT NEW'
     C                   EVAL      WDocTyp= 'OECD11'
     C                   EVAL      WActn  = 'O'
     C                   WHEN      PActn = 'O'
     C                             AND PRtype <> 'DRAFT NEW'
     C                   EVAL      WDocTyp= 'OECD13'
     C                   EVAL      WActn  = 'O'
     C                   ENDSL
     C                   ENDIF

     C                   IF        PStat = 'TEST'
     C                             AND Pactn = 'X'
     C                   EVAL      WActn  = 'X'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCustCheck - Customer Report Type Details                    *
      *                                                               *
      *****************************************************************
     C     SRCustCheck   BEGSR

     C                   EVAL      WCust = EXCUSD
     C                   EVAL      XCust = EXCUSD
     C                   EXSR      SRChkConPers
     C                   EVAL      WkCONS = WHasContPer
     C                   MOVEL     EXCUSD        DCUST
     C                   EVAL      WkTYPE = EXTYPE
     C                   EVAL      KDCty = EXCOLC
     C                   EXSR      SRChkSRepCus
     C                   EVAL      WkREPT = WCtryRprtng
     C                   EVAL      WReportInd = 'N'
     C                   EVAL      WReportJnt  = 'N'

     C                   EVAL      WkSTYP = EXSTYP
     C                   EVAL      WkINFO = EXINFO
     C                   EVAL      WkHVAL = EXHVAL
     C                   EVAL      WkEXMP = EXEXMP
     C                   EVAL      WkDRMT = EXDRMT

     C                   EXSR      SRAccType
     C                   EVAL      WReportInd = WReport

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRJaccCheck - Check joint account if for reporting            *
      *                                                               *
      *****************************************************************
     C     SRJaccCheck   BEGSR

     C                   EVAL      WReportInd = 'N'
     C                   EVAL      WReportJnt = 'N'
     C                   EVAL      KJano = EXJANO

     C     KJano         CHAIN     GLCRMXL2
     C                   IF        %FOUND(GLCRMXL2)
     C                             AND X2EXTYPE <> 'J'
     C                   EVAL      WReportJnt = 'N'
     C                   LEAVESR
     C                   ENDIF
     C                   EVAL      JCCUST = *BLANKS
     C                   EVAL      JCNAHO = *BLANKS
     C                   IF        EXACTY = 'CUST'
     C                   EVAL      JCCUST = EXCUSD
     C                   ELSE
     C                   EVAL      JCNAHO = EXCUSD
     C                   ENDIF

     C                   IF        JCCUST <> *BLANKS

     C                   EVAL      PCust = JCCUST

      ** Check first if the Customer has Exceptions
     C                   IF        PActn <> 'I'
     C     JCCUST        CHAIN     SDCRSHL2
     C                   IF        %FOUND(SDCRSHL2)
     C                   EVAL      WReportJnt = 'N'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      XCust = PCust
     C                   EXSR      SRChkConPers
     C                   EVAL      WkCONS = WHasContPer
     C                   EVAL      PCust = XCust                                            MD040873
     C                   EVAL      WCust = PCust
     C                   EXSR      SRAccCust

     C                   EVAL      FCust = PCust
     C                   EXSR      SRCRSHDet

     C                   EVAL      PAcus = PCust
     C                   EXSR      SRAccAcus

     C                   EVAL      DCust = PCust
     C                   EVAL      WkTYPE = CRTYPE
     C                   EVAL      KDCty = BBCOLC
     C                   EXSR      SRChkSRepCus
     C                   EVAL      WkREPT = WCtryRprtng
     C                   EVAL      SCust = PCust
     C                   EXSR      SRAccCUSX

     C                   EVAL      WReportJnt = 'N'

     C                   EVAL      WkSTYP = CRSTYP
     C                   EVAL      WkINFO = CRINFO
     C                   EVAL      WkHVAL = CRHVAL
     C                   EVAL      WkEXMP = CREXMP
     C                   EVAL      WkDRMT = XCDRMT

     C                   EXSR      SRAccType

     C                   ELSE

     C                   EVAL      KNAHO  = JCNAHO

     C                   IF        PActn <> 'I'
      ** Check first if the Customer has Exceptions
     C     KNAHO         CHAIN     SDCRNHL2
     C                   IF        %FOUND(SDCRNHL2)
     C                   EVAL      WReportJnt = 'N'
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF

     C                   EXSR      SRCRNHDet

     C                   EVAL      PNaho = JCNAHO
     C                   EXSR      SRAccNaho

     C                   EVAL      WCust = JCNAHO
     C                   EVAL      NCust = JCNAHO
     C                   EVAL      WkTYPE = NRTYPE
     C                   EVAL      KDCty = NHCOLC
     C                   EXSR      SRChkSRepNah
     C                   EVAL      WkREPT = WCtryRprtng

      ** Non-Account Holder has no controlling persons
     C                   EVAL      WkCONS = 'N'

     C                   EVAL      WReportJnt = 'N'

      ** Move fields to check if for reporting
     C                   EVAL      WkSTYP = NRSTYP
     C                   EVAL      WkINFO = NRINFO
     C                   EVAL      WkHVAL = NRHVAL
     C                   EVAL      WkEXMP = NREXMP
     C                   EVAL      WkDRMT = 'N'

     C                   EXSR      SRAccType
     C                   ENDIF

     C                   EVAL      WReportJnt = WReport

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetAgrTyp - Determin Agreement type if for Reporting        *
      *                                                               *
      *****************************************************************
     C     SRDetAgrTyp   BEGSR

     C                   EVAL      KCTRT = WBrIntCOLC
     C                   EVAL      WCtryCRSA = *BLANKS
     C                   EVAL      WCtryFRYR = 0
     C     KCttx         CHAIN     SDCTTXL0
     C                   IF        %FOUND(SDCTTXL0)
     C                   EVAL      WCtryCRSA = EWCRSA
     C                   MOVEL     EWFRYR        WCtryFRYR
     C                   ELSE
     C                   EVAL      KCTRR = *BLANKS
     C     KCttx         CHAIN     SDCTTXL0
     C                   IF        %FOUND(SDCTTXL0)
     C                   EVAL      WCtryCRSA = EWCRSA
     C                   MOVEL     EWFRYR        WCtryFRYR
     C                   ENDIF
     C                   ENDIF

     C                   IF        WCtryCRSA = 'Y'
     C                             AND WCtryFRYR <= WRepYear
     C                             AND WCtryFRYR <> 0
     C                   EVAL      WCttxRpt = 'Y'
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkSRepCus - Check Countries for Reporting                 *
      *                                                               *
      *****************************************************************
     C     SRChkSRepCus  BEGSR
      *
     C                   EVAL      WCtryRprtng = 'N'

      ** For Individual
      ** and for Organisation                                                               MD054986
     C**********         IF        WkTYPE = 'P'                                             MD054986
     C                   IF        WkTYPE <> *BLANKS                                        MD054986
     C     DCust         SETLL     SDCRSDL2
     C     DCust         READE     SDCRSDL2
     C                   DOW       NOT %EOF(SDCRSDL2)

      ** Check Country Tax Codes if Country is for Reporting
     C                   EVAL      KCTRR = CDCTRY
     C                   EVAL      WCttxRpt = 'N'
     C                   EXSR      SRDetAgrTyp

      ** Get Year number of Effective Date
     C                   IF        CDEFFD <> 0
     C                   EVAL      DateIn5 = CDEFFD
     C                   EXSR      SRCvtDate
     C                   MOVEL     DayOut8       WkEFFYr
     C                   ELSE
     C                   EVAL      WkEFFYr = 0
     C                   ENDIF

      ** Get Year number of Expiry Date
     C                   IF        CDEXPD <> 0
     C                   EVAL      DateIn5 = CDEXPD
     C                   EXSR      SRCvtDate
     C                   MOVEL     DayOut8       WkEXPYr
     C                   ELSE
     C                   EVAL      WkEXPYr = 0
     C                   ENDIF

     C                   IF        WCttxRpt = 'Y'
     C                             AND ((WkEFFYr <= WRepYear
     C                             AND WkEFFYr <> 0)
     C                             OR  WkEFFYr = 0)
     C                             AND ((WkEXPYr >= WRepYear
     C                             AND WkEXPYr <> 0)
     C                             OR  WkEXPYr = 0)
     C                             AND CDREPT = 'Y'
     C                   EVAL      WCtryRprtng = 'Y'
     C                   LEAVE
     C                   ENDIF

     C     DCust         READE     SDCRSDL2
     C                   ENDDO
     C                   ENDIF                                                              MD054986

     C**********         ELSE                                                               MD054986
      **********                                                                            MD054986
     C**********         IF        WkTYPE <> *BLANKS                                        MD054986
      ***For*Organisation                                                                   MD054986
      **********                                                                            MD054986
     C*****KCusCtry      CHAIN     SDCRSDL0                                                 MD054986
     C**********         IF        %FOUND(SDCRSDL0)                                         MD054986
      **********                                                                            MD054986
      ***Check*Country Tax Codes if Country is for Reporting                                MD054986
     C**********         EVAL      KDCus = DCust                                            MD054986
     C**********         EVAL      KCTRR = CDCTRY                                           MD054986
     C**********         EVAL      WCttxRpt = 'N'                                           MD054986
     C**********         EXSR      SRDetAgrTyp                                              MD054986
      **********                                                                            MD054986
      ***Get*Year number of Effective Date                                                  MD054986
     C**********         IF        CDEFFD <> 0                                              MD054986
     C**********         EVAL      DateIn5 = CDEFFD                                         MD054986
     C**********         EXSR      SRCvtDate                                                MD054986
     C**********         MOVEL     DayOut8       WkEFFYr                                    MD054986
     C**********         ELSE                                                               MD054986
     C**********         EVAL      WkEFFYr = 0                                              MD054986
     C**********         ENDIF                                                              MD054986
      **********                                                                            MD054986
      ***Get*Year number of Expiry Date                                                     MD054986
     C**********         IF        CDEXPD <> 0                                              MD054986
     C**********         EVAL      DateIn5 = CDEXPD                                         MD054986
     C**********         EXSR      SRCvtDate                                                MD054986
     C**********         MOVEL     DayOut8       WkEXPYr                                    MD054986
     C**********         ELSE                                                               MD054986
     C**********         EVAL      WkEXPYr = 0                                              MD054986
     C**********         ENDIF                                                              MD054986
      **********                                                                            MD054986
     C**********         IF        WCttxRpt = 'Y'                                           MD054986
     C**********                   AND ((WkEFFYr <= WRepYear                                MD054986
     C**********                   AND WkEFFYr <> 0)                                        MD054986
     C**********                   OR  WkEFFYr = 0)                                         MD054986
     C**********                   AND ((WkEXPYr >= WRepYear                                MD054986
     C**********                   AND WkEXPYr <> 0)                                        MD054986
     C**********                   OR  WkEXPYr = 0)                                         MD054986
     C**********                   AND CDREPT = 'Y'                                         MD054986
     C**********         EVAL      WCtryRprtng = 'Y'                                        MD054986
     C**********         ENDIF                                                              MD054986

     C**********         ENDIF                                                              MD054986

     C**********         ENDIF                                                              MD054986
     C**********         ENDIF                                                              MD054986

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkSRepNah - Check US Indicia for Non-Account Holder       *
      *                                                               *
      *****************************************************************
     C     SRChkSRepNah  BEGSR
      *
     C                   EVAL      WCtryRprtng = 'N'
      ** For Individual reporting
     C                   IF        WkTYPE = 'P'
     C     NCust         SETLL     SDCRSNL2
     C     NCust         READE     SDCRSNL2
     C                   DOW       NOT %EOF(SDCRSNL2)

      ** Check Country Tax Codes if Country is for Reporting
     C                   EVAL      KCTRR = CNCTRY
     C                   EVAL      WCttxRpt = 'N'
     C                   EXSR      SRDetAgrTyp

      ** Get Year number of Effective Date
     C                   IF        CNEFFD <> 0
     C                   EVAL      DateIn5 = CNEFFD
     C                   EXSR      SRCvtDate
     C                   MOVEL     DayOut8       WkEFFYr
     C                   ELSE
     C                   EVAL      WkEFFYr = 0
     C                   ENDIF

      ** Get Year number of Expiry Date
     C                   IF        CNEXPD <> 0
     C                   EVAL      DateIn5 = CNEXPD
     C                   EXSR      SRCvtDate
     C                   MOVEL     DayOut8       WkEXPYr
     C                   ELSE
     C                   EVAL      WkEXPYr = 0
     C                   ENDIF

     C                   IF        WCttxRpt = 'Y'
     C                             AND ((WkEFFYr <= WRepYear
     C                             AND WkEFFYr <> 0)
     C                             OR  WkEFFYr = 0)
     C                             AND ((WkEXPYr >= WRepYear
     C                             AND WkEXPYr <> 0)
     C                             OR  WkEXPYr = 0)
     C                             AND CNREPT = 'Y'
     C                   EVAL      WCtryRprtng = 'Y'
     C                   LEAVE
     C                   ENDIF

     C     NCust         READE     SDCRSNL2
     C                   ENDDO

     C                   ELSE
     C                   IF        WkTYPE <> *BLANKS
      ** For Organisation reporting
     C                   EVAL      KDNah = NCust
     C     KNahCtry      CHAIN     SDCRSNL0
     C                   IF        %FOUND(SDCRSNL0)

      ** Check Country Tax Codes if Country is for Reporting
     C                   EVAL      KCTRR = CNCTRY
      *
     C                   EVAL      WCttxRpt = 'N'
     C                   EXSR      SRDetAgrTyp

      ** Get Year number of Effective Date
     C                   IF        CNEFFD <> 0
     C                   EVAL      DateIn5 = CNEFFD
     C                   EXSR      SRCvtDate
     C                   MOVEL     DayOut8       WkEFFYr
     C                   ELSE
     C                   EVAL      WkEFFYr = 0
     C                   ENDIF

      ** Get Year number of Expiry Date
     C                   IF        CNEXPD <> 0
     C                   EVAL      DateIn5 = CNEXPD
     C                   EXSR      SRCvtDate
     C                   MOVEL     DayOut8       WkEXPYr
     C                   ELSE
     C                   EVAL      WkEXPYr = 0
     C                   ENDIF

     C                   IF        WCttxRpt = 'Y'
     C                             AND ((WkEFFYr <= WRepYear
     C                             AND WkEFFYr <> 0)
     C                             OR  WkEFFYr = 0)
     C                             AND ((WkEXPYr >= WRepYear
     C                             AND WkEXPYr <> 0)
     C                             OR  WkEXPYr = 0)
     C                             AND CNREPT = 'Y'
     C                   EVAL      WCtryRprtng = 'Y'
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccSval - Access System Values File                         *
      *                                                               *
      *****************************************************************
     C     SRAccSval     BEGSR

     C                   CALL      'GPAOSVALR0'
     C                   PARM      *BLANKS       PrtrnCode
     C                   PARM      SysVal1       SValK1
     C                   PARM                    SVal1
     C                   PARM      SysVal2       SValK2
     C                   PARM                    SVal2
     C                   PARM                    SValK3
     C                   PARM                    SVal3
     C                   PARM                    SValK4
     C                   PARM                    SVal4
     C                   PARM                    SValK5
     C                   PARM                    SVal5
     C                   PARM                    SValK6
     C                   PARM                    SVal6
     C                   PARM                    SValK7
     C                   PARM                    SVal7
     C                   PARM                    SValK8
     C                   PARM                    SVal8
     C                   PARM                    SValK9
     C                   PARM                    SVal9
     C                   PARM                    SValK0
     C                   PARM                    SVal10

     C                   IF        PrtrnCode <> *Blanks
     C                             AND PrtrnCode <> '*NRF   '
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = SValK1
     C                   EVAL      DBASE = 010
     C                   EVAL      DBPGM = 'GL000767'
     C                   EXSR      *PSSR
     C                   ELSE

     C                   EVAL      PCurr = SVal1
     C                   EXSR      SRAccCurr

     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13

      ** Retrieve high value currency rate
     C                   EVAL      PCurr = SVal1
     C                   EXSR      SRAccCurr
     C                   EVAL      ZRATE2 = A6SPRT
     C                   EVAL      ZMDI2 = A6MDIN
     C                   EVAL      ZCCYO = PCurr
     C                   EVAL      ZCDPO = A6NBDP

     C                   ENDIF
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccCurr - Access Currency Detail File                       *
      *                                                               *
      *****************************************************************
     C     SRAccCurr     BEGSR

      ** Retrieve currency information
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   IF        PRtrnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PCurr
     C                   EVAL      DBASE  = 009
     C                   EVAL      DBPGM = 'GL000767'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtDate - Convert Amount                                    *
      *                                                               *
      *****************************************************************
     C     SRCvtDate     BEGSR

      ** Convert Midas Run Day Number to YYYYMMDD format
     C                   CALLB     'ZDATE9'
     C                   PARM                    DateIn5
     C                   PARM                    DayOut8
     C                   PARM                    ErrorFlag

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialise field                                     *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR

     C                   EVAL      WPayTotCcy   = 0
     C                   EVAL      WHasContPer  = 'N'
     C                   EVAL      WCorrDocRef  = *BLANKS
     C                   MOVE      *BLANKS       ArCorrDet
     C                   EVAL      WDocRef1 = *BLANKS
     C                   EVAL      WDocRef2 = *BLANKS
     C                   EVAL      WDocRef3 = *BLANKS
     C                   EVAL      WDocRef4 = *BLANKS
     C                   EVAL      WDocRef5 = *BLANKS
     C                   EVAL      WDocRef6 = *BLANKS
     C                   EVAL      WPrevPAYT = *BLANKS
     C                   EVAL      WPrevCCY  = *BLANKS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Write record Report Management Data                 *
      *                                                               *
      *****************************************************************
     C     SRWrite       BEGSR

     C                   WRITE     GLCRMDD0

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccCust - Access Customer Details                           *
      *                                                               *
      *****************************************************************
     C     SRAccCust     BEGSR

      ** Access Customer

     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PrtrnCode
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCUST
     C                   PARM      *BLANKS       PCNST
     C     SDCUST        PARM      SDCUST        DSSDY

     C                   IF        PrtrnCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE  = 008
     C                   EVAL      DBKEY  = PCUST
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccNaho - Access Non-Account Holder Details                 *
      *                                                               *
      *****************************************************************
     C     SRAccNaho     BEGSR

      ** Access Customer

     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PrtrnCode
     C                   PARM      '*KEY   '     Poptn
     C                   PARM                    PNAHO
     C     SDNAHO        PARM      SDNAHO        DSLDY

     C                   IF        PrtrnCode <> *BLANKS
     C                   EVAL      DBFILE = 'SDNAHOPD'
     C                   EVAL      DBASE  = 007
     C                   EVAL      DBKEY  = PNAHO
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccACUS - Access Additional Customer Details                *
      *                                                               *
      *****************************************************************
     C     SRAccAcus     BEGSR

      ** Access Customer

     C                   CALL      'AOACUSR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PAcus
     C     SDACUS        PARM      SDACUS        DSLDY

     C                   IF        PRtrnCode <> *BLANKS
     C                             AND PRtrnCode <> '*NRF'
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDACUSPD'
     C                   EVAL      DBKEY = PAcus
     C                   EVAL      DBASE = 006
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        PRtrnCode = '*NRF'
     C                   CLEAR                   SDACUS
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccCUSX - Access Customer Details Ext C                     *
      *                                                               *
      *****************************************************************
     C     SRAccCUSX     BEGSR

      ** Access Customer Extension C details

     C     SCust         CHAIN     SDCUSXL0

     C                   IF        NOT %FOUND(SDCUSXL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCUSXPD'
     C                   EVAL      DBKEY = SCust
     C                   EVAL      DBASE = 11
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccBranch - Access Branch Code Details                      *
      *                                                               *
      *****************************************************************
     C     SRAccBranch   BEGSR

     C                   CALLB     'AOBRCHR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PBranch
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C                   IF        PRtrnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBranch
     C                   EVAL      DBASE = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WBRIntCust = B_A8BICN
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCRSHDet - Access CRS Header Details File                    *
      *                                                               *
      *****************************************************************
     C     SRCRSHDet     BEGSR
      *
     C     FCust         CHAIN     SDCRSHL0
      *
      ** If not found, this means that no records exists; DB error
      *
     C                   IF        NOT %FOUND(SDCRSHL0)
     C                   EVAL      SDCRSH = *BLANKS
     C                   EVAL      CRCUST = FCUST
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCRNHDet - Access CRS Naho Header Details File               *
      *                                                               *
      *****************************************************************
     C     SRCRNHDet     BEGSR

     C     KNAHO         CHAIN     SDCRNHL0

      ** If not found, this means that no records exists; DB error

     C                   IF        NOT %FOUND(SDCRNHL0)
     C                   EVAL      SDCRNH = *BLANKS
     C                   EVAL      NRNAHO = KNAHO
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkConPers - Check Controlling Persons                     *
      *                                                               *
      *****************************************************************
     C     SRChkConPers  BEGSR

     C                   EVAL      WHasContPer = 'N'
     C                   EVAL      WCuahFlg = ' '
     C     XCust         SETLL     SDJACCL0
     C     XCust         READE     SDJACCL0

     C                   DOW       NOT %EOF(SDJACCL0)

     C                   IF        JCCUST <> *BLANKS
     C                   EVAL      PSub10 = JCCUST
     C                   ELSE
     C                   EVAL      PSub10 = JCNAHO
     C                   ENDIF
     C                   EXSR      SRChkSubCat
     C                   IF        WHasContPer = 'Y'
     C                   LEAVESR
     C                   ENDIF

     C     XCust         READE     SDJACCL0
     C                   ENDDO

     C                   EVAL      JCCUST = *Blanks
     C                   EVAL      JCNAHO = *Blanks

     C     XCust         SETLL     SDCUAHL0
     C     XCust         READE     SDCUAHL0

     C                   DOW       NOT %EOF(SDCUAHL0)
     C                   IF        CAPCNT <> *Blanks
     C                   MOVE      CAPCNT        WNUM3                                      MD055078
     C                   ELSE                                                               MD055078
     C                   EVAL      WNUM3 = 0                                                MD055078
     C                   ENDIF                                                              MD055078
     C                   IF        WNUM3 <> *ZERO                                           MD055078
     C                             OR CACINT = 'Y'                                          MD055071
     C**********         MOVE      CAPCNT        WNUM3                                      MD055071
     C**********         IF        WNUM3 <> *ZERO                                           MD055071
     C                   EVAL      PCuah = CAAUTH
     C                   EVAL      WCuahFlg = ' '
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCuah
     C                   PARM      *BLANKS       PCNST
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      WCuahFlg = 'C'
     C                   ELSE
     C                   CALL      'AONAHOR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCuah
     C                   PARM      SDNAHO        DSLDY
      *
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      WCuahFlg = 'N'
     C                   ENDIF
     C                   ENDIF

     C                   EVAL      PSub10 = PCuah
     C                   EXSR      SRChkSubCat

     C                   IF        WHasContPer = 'Y'
     C                   LEAVESR
     C                   ENDIF

     C**********         ENDIF                                                              MD055071
     C                   ENDIF
     C     XCust         READE     SDCUAHL0
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkSubCat - Check Subowner category                        *
      *                                                               *
      *****************************************************************
     C     SRChkSubCat   BEGSR

     C                   IF        JCCUST <> *BLANKS
     C                             OR WCuahFlg = 'C'
     C                   EVAL      PCust = PSub10
     C                   EXSR      SRAccCust
     C                   EVAL      FCust = PSub10
     C                   EXSR      SRCRSHDet
     C                   EVAL      SCust = PSub10
     C                   EXSR      SRAccCUSX
     C                   EVAL      DCust = PSub10
     C                   EVAL      WkTYPE = CRTYPE
     C                   EVAL      KDCty = BBCOLC
     C                   EXSR      SRChkSRepCus
     C                   EVAL      WkREPT = WCtryRprtng
     C                   EVAL      WkSTYP = CRSTYP
     C                   EVAL      WkINFO = CRINFO
     C                   EVAL      WkHVAL = CRHVAL
     C                   EVAL      WkEXMP = CREXMP
     C                   EVAL      WkDRMT = XCDRMT

     C                   ELSE
     C                   EVAL      PNaho = PSub10
     C                   EXSR      SRAccNaho
     C                   EVAL      KNAHO  = PSub10
     C                   EXSR      SRCRNHDet
     C                   EVAL      NCust  = PSub10
     C                   EVAL      WkTYPE = NRTYPE
     C                   EVAL      KDCty = NHCOLC
     C                   EXSR      SRChkSRepNah
     C                   EVAL      WkREPT = WCtryRprtng
     C                   EVAL      WkTYPE = NRTYPE
     C                   EVAL      WkSTYP = NRSTYP
     C                   EVAL      WkINFO = NRINFO
     C                   EVAL      WkHVAL = NRHVAL
     C                   EVAL      WkEXMP = NREXMP
     C                   EVAL      WkDRMT = 'N'
     C                   ENDIF

      ** Controlling Persons should be CRS102
     C                   SELECT
     C                   WHEN      WkTYPE = 'N'
     C                             AND WkSTYP = 'AC'
     C                             AND WkREPT = 'Y'
     C                             AND (WkHVAL = 'H' OR WkHVAL = 'M')
     C                             AND (WkINFO = 'Y' OR WkINFO = 'A')
     C                             AND WkEXMP <> 'Y'
     C                   EVAL      WHasContPer = 'Y'

     C                   WHEN      WkTYPE = 'N'                                             MD055071
     C                             AND WkSTYP = 'PA'                                        MD055071
     C                             AND WkREPT = 'Y'                                         MD055071
     C                             AND (WkHVAL = 'H' OR WkHVAL = 'M')                       MD055071
     C                             AND (WkINFO = 'Y' OR WkINFO = 'A')                       MD055071
     C                             AND WkEXMP <> 'Y'                                        MD055071
     C                   EVAL      WHasContPer = 'Y'                                        MD055071

     C                   WHEN      WkTYPE = 'P'
     C                             AND WkREPT = 'Y'
     C                             AND (WkHVAL = 'H' OR WkHVAL = 'M')
     C                             AND (WkINFO = 'Y' OR WkINFO = 'A')
     C                             AND WkEXMP <> 'Y'
     C                   EVAL      WHasContPer = 'Y'

     C                   WHEN      WkTYPE = 'J'
     C                             AND WkREPT = 'Y'
     C                             AND (WkHVAL = 'H' OR WkHVAL = 'M')
     C                             AND (WkINFO = 'Y' OR WkINFO = 'A')
     C                             AND WkEXMP <> 'Y'
     C                   EVAL      WHasContPer = 'Y'

     C                   WHEN      WkTYPE = 'O'
     C                             AND WkREPT = 'Y'
     C                             AND (WkHVAL = 'H' OR WkHVAL = 'M')
     C                             AND (WkINFO = 'Y' OR WkINFO = 'A')
     C                             AND WkEXMP <> 'Y'

     C                   EVAL      WHasContPer = 'Y'
     C                   ENDSL

     C                   ENDSR
                                                                                              CGL185
      *****************************************************************                       CGL185
      /EJECT                                                                                  CGL185
      *****************************************************************                       CGL185
      *                                                               *                       CGL185
      * SRAcctClose - Subroutine to check if account will be          *                       CGL185
      *               reported as account closed                      *                       CGL185
      *                                                               *                       CGL185
      *****************************************************************                       CGL185
                                                                                              CGL185
     C     SRAcctClose   BEGSR                                                                CGL185
                                                                                              CGL185
     C                   EVAL      MGELMT = 'AccountClosed'                                   CGL185
     C                   EVAL      MGDATA = 'false'                                           CGL185
     C                   IF        EXTTYP = 'FDMAT'                                           CGL185
     C                             OR EXTTYP = 'FRMAT'                                        CGL185
     C                             OR EXTTYP = 'LEMAT'                                        CGL185
     C                             OR EXTTYP = 'MMMAT'                                        CGL185
     C                             OR EXTTYP = 'RECLD'                                        CGL185
     C                             OR EXTTYP = 'RFMAT'                                        CGL185
     C                             OR EXTTYP = 'RPMAT'                                        CGL185
     C                             OR EXTTYP = 'RSMAT'                                        CGL185
     C                             OR EXTTYP = 'RXMAT'                                        CGL185
     C                             OR EXTTYP = 'SEMVD'                                        CGL185
     C                   IF        EXBALN <> 0                                                CGL185
     C                   EVAL      MGDATA = 'true'                                            CGL185
     C                   ENDIF                                                                CGL185
     C                   ENDIF                                                                CGL185
     C                   EXSR      SRWrite                                                    CGL185
                                                                                              CGL185
     C                   ENDSR                                                                CGL185
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetGrpLevl  - Get group level number                        *
      *                                                               *
      *****************************************************************
     C     SRGetGrpLevl  BEGSR

     C     KGrpName      CHAIN     GLGXMLL1
     C                   IF        %FOUND(GLGXMLL1)
     C                   EVAL      MGLEVL = XMLEVL
     C                   ELSE
     C                   EVAL      MGLEVL = 0
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    PActn
     C                   PARM                    PMsId
     C                   PARM                    PYear
     C                   PARM                    PBrcd
     C                   PARM                    PCtry
     C                   PARM                    PStat
     C                   PARM                    PRType
     C                   PARM                    PWMsg
     C                   PARM                    PRpDocRef
     C                   PARM                    ArAcctNumbr
     C                   PARM                    ArExcCust
     C                   PARM                    ArIncCust

      ** Call Access Program for Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSSDY

     C                   IF        PRtrnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Get system timestamp

     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimeStamp

     C                   MOVEL     PTimeStamp    WDTmst

     C                   MOVEL     PYear         WRepYear
     C                   EVAL      PBranch = PBrcd
     C                   EXSR      SRAccBranch
      ** Key Field list

     C     KCtrMsId      KLIST
     C                   KFLD                    PCtry
     C                   KFLD                    KMsgNo

     C     KBrCust0      KLIST
     C                   KFLD                    PBrcd
     C                   KFLD                    KCust

     C     KBrAcno1      KLIST
     C                   KFLD                    PBrcd
     C                   KFLD                    KCust
     C                   KFLD                    KAcno

     C     KExclude      KLIST
     C                   KFLD                    KMsgNo
     C                   KFLD                    KECus

     C     KExclCtr      KLIST
     C                   KFLD                    KMsgNo
     C                   KFLD                    KEFlag
     C                   KFLD                    KERef

     C     KGrpName      KLIST
     C                   KFLD                    KGroupNm
     C                   KFLD                    KElemNm

     C     KWarn         KLIST
     C                   KFLD                    KMsgNo
     C                   KFLD                    KElemnam

     C     KRepFI        KLIST
     C                   KFLD                    KMsgNo
     C                   KFLD                    KTopMT

     C     KDelPR        KLIST
     C                   KFLD                    KMsgNo
     C                   KFLD                    KTopMT
     C                   KFLD                    KMsgSeq

     C     KCttx         KLIST
     C                   KFLD                    KCTRT
     C                   KFLD                    KCTRR

     C     KCusCtry      KLIST
     C                   KFLD                    KDCus
     C                   KFLD                    KDCty

     C     KNahCtry      KLIST
     C                   KFLD                    KDNah
     C                   KFLD                    KDCty

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
