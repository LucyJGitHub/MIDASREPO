     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2014')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Report Management Details')                   *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL000667 - Midas GL Report Management Processing             *
      *                                                               *
      *  Function: This is to generate Report Management Data         *
      *        for XML Input File                                     *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2014                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD044368           Date 28Feb17               *
      *                 MD044000           Date 06Feb17               *
      *                 MD043973           Date 03Feb17               *
      *                 MD043144           Date 19Dec16               *
      *                 MD043187           Date 19Dec16               *
      *                 CGL154  *CREATE    Date 13Oct14               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044368 - Certain Joint Account Members are not reporting   *
      *             Joint Account Assets                              *
      *  MD044000 - Database Error occurred upon requesting a New     *
      *             Draft Report                                      *
      *  MD043973 - FATCA Account closed file entries are not         *
      *             transferred to FATCA EOY archive file (Recompile) *
      *  MD043144 - Passive NFE reportable customer with authority    *
      *             holder as substantial US owner is not reported    *
      *  MD043187 - First or last set of account holders doesn't      *
      *             appear in generated reports when voided/corrected *
      *  CGL154 - FATCA Reporting                                     *
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
      *  SRRepAmend    - Main Processing for Amend Report             *
      *  SRRepIncld    - Main Processing for Include Report           *
      *  SRCustCheck   - Check Customer Report Type                   *
      *  SRRepHeader   - Message Header Details                       *
      *  SRCsActRepHdr - Write Account Report to File                 *
      *  SRWrIndvRept  - Reporting Individual Account                 *
      *  SRAccBalance  - Report Account Balance                       *
      *  SRGenMsgID    - Generate Message Ref ID                      *
      *  SRCompPool    - Compute details for Pool report              *
      *  SRReportPool  - Report Pool Details                          *
      *  SRSubOwner    - Report Substantial Owners for the Acct Holder*
      *  SRAccSval     - Access System Values File                    *
      *  SRDetDocTyp   - Determine Document Type                      *
      *  SRAccCurr     - Access Currency Detail File                  *
      *  SRCvtAmt      - Convert Amount                               *
      *  SRInit        - Initialise field                             *
      *  SRCompPaymt   - Compute Payment Details for Reporting        *
      *  SRListExcptn  - List all Customers or Non-acct Holder Excptn *
      *  SRWrite       - Write record Report Management Data          *
      *  SRAccCust     - Access Customer Details                      *
      *  SRAccNaho     - Access Non-Account Holder Details            *
      *  SRAccAcus     - Access Additional Customer Details           *
      *  SRAccBranch   - Access Branch Code Details                   *
      *  SRChkAgrType  - Check Agreement Type for Reporting           *
      *  SRNonIGA      - Check if for Reporting if No Agreement       *
      *  SRModel1      - Check if for Reporting if Agreement is Model1*
      *  SRModel2      - Check if for Reporting if Agreement is Model2*
      *  SRFTCSDet     - Access FATCA Details File                    *
      *  SRFTNHDet     - Access FATCA Naho Details File               *
      *  SRAccCountry  - Access Country Codes File                    *
      *  SRChkTINs     - Check US Tins                                *
      *  SRChkIndCust  - Check US Indicia for Customer                *
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
     FGLRMEXL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Report Management Extract Files
     FGLRMEXL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMEXD0:GLRMEXD1)
      ** Midas GL Report Management Extract Files
     FGLRMEXL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMEXD0:GLRMEXD2)
     F                                     PREFIX(X2)
      ** Midas SD FATCA Customer Details File
     FSDFTCSL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD FATCA Non-Account Holder Details File
     FSDFTNHL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD FATCA Customer Details File
     FSDFTCSL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTCSD0:SDFTCSD6)
     F                                     PREFIX(S_)
 
      ** Midas SD Customer Details Ext C
     FSDCUSXL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD FATCA Customer Details File
     FSDFTNHL6  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDFTNHD0:SDFTNHD6)
     F                                     PREFIX(N_)
      ** Midas GL FATCA XML Schema
     FGLFXMLL1  IF   E           K DISK    INFSR(*PSSR)
                                                                                            MD043144
      ** Midas SD Customer Authority Holder File                                            MD043144
     FSDCUAHL0  IF   E           K DISK    INFSR(*PSSR)                                     MD043144
                                                                                            MD043144
      ** Midas SD Customer Authority Holder File                                            MD043144
     FSDCUAHL1  IF   E           K DISK    INFSR(*PSSR)                                     MD043144
     F                                     RENAME(SDCUAHD0:SDCUAHD1)                        MD043144
     F                                     PREFIX(L1_)                                      MD043144
 
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
     FGLRMIEL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMIED0:GLRMIED1)
     F                                     PREFIX(IE_)
 
      ** Midas GL Report Management Main File
     FGLRPMGL0  UF A E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Report Management Main File
     FGLRPMGL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRPMGD0:GLRPMGD1)
     F                                     PREFIX(R1_)
 
      ** Midas GL Report Management Data File
     FGLRMDTL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDTD1)
     F                                     PREFIX(D1_)
 
      ** Midas GL Report Management Data File
     FGLRMDTLA  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDTP1)
     F                                     PREFIX(P1_)
 
      ** Midas GL Report Management Data File
     FGLRMDTL4  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDTD4)
     F                                     PREFIX(D4_)
 
     FGLRMDTL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(GLRMDTD0:GLRMDTD5)
     F                                     PREFIX(D5_)
 
      ** Midas SD FATCA Customer Details File
     FGLRMDTPD  O    E           K DISK    INFSR(*PSSR)
 
      ** Midas GL Report Management Includes Excludes
     FGLRMIEPD  UF A E           K DISK    INFSR(*PSSR)
 
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
 
     D SysVal1         C                   'FATCAHighValueCcy'
     D SysVal2         C                   'FATCAReportVersion'
     D SysVal3         C                   'FATCALowValDepAcc'
     D WsSysVal1       C                   'FATCACountryofTax'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for Switchable Features Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Country Codes
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
 
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
     D GLRMDT        E DS                  EXTNAME(GLRMDTPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Second DS for access programs, long data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
     D CustIndOverDS   DS
     D  EXHMOV
     D  EXMCOV
     D  EXRPOV
     D  EXCIOV
     D  EXCBOV
     D  EXCDOV
     D  EXGCOV
     D  EXIDOV
     D  EXJAOV
     D  EXTEOV
     D  EXTXOV
 
     D CustIndSValDS   DS
     D  EXHMSV
     D  EXMCSV
     D  EXRPSV
     D  EXCISV
     D  EXCBSV
     D  EXCDSV
     D  EXGCSV
     D  EXIDSV
     D  EXJASV
     D  EXTESV
     D  EXTXSV
 
     D FTCSIndOverDS   DS
     D  FAHMOV
     D  FAMCOV
     D  FARPOV
     D  FACIOV
     D  FACBOV
     D  FACDOV
     D  FAGCOV
     D  FAIDOV
     D  FAJAOV
     D  FATEOV
     D  FATXOV
 
     D FTCSIndSValDS   DS
     D  FAHMSV
     D  FAMCSV
     D  FARPSV
     D  FACISV
     D  FACBSV
     D  FACDSV
     D  FAGCSV
     D  FAIDSV
     D  FAJASV
     D  FATESV
     D  FATXSV
 
     D FTNHIndOverDS   DS
     D  FNHMOV
     D  FNMCOV
     D  FNRPOV
     D  FNCIOV
     D  FNCBOV
     D  FNCDOV
     D  FNGCOV
     D  FNIDOV
     D  FNJAOV
     D  FNTEOV
     D  FNTXOV
 
     D FTNHIndSValDS   DS
     D  FNHMSV
     D  FNMCSV
     D  FNRPSV
     D  FNCISV
     D  FNCBSV
     D  FNCDSV
     D  FNGCSV
     D  FNIDSV
     D  FNJASV
     D  FNTESV
     D  FNTXSV
 
     D WDTMST          DS
     D  WTMST                  1     26
     D  WWY1                   1      2
     D  WWY2                   3      4
     D  WWMM                   6      7
     D  WWDD                   9     10
 
      ** YYYYXXXZZ99999.001x format
     D WMsgId          DS
     D  WMDate                 1      9
     D  WMsgNo                10     14
     D  WMsgDot               15     15    INZ('.')
     D  WMsgAcSq              16     18
     D  WMsgDtyp              19     19
     D  WMsgActn              20     21
 
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
     D ArAcctDet                     83A   DIM(50)
     D  AAcctCust                    10A   OVERLAY(ArAcctDet:1)
     D  AAcctNum                     26A   OVERLAY(ArAcctDet:11)
     D  AAcDocRf                     33A   OVERLAY(ArAcctDet:37)
     D  AAcctMem                     10A   OVERLAY(ArAcctDet:70)
     D  AAcctTyp                      4A   OVERLAY(ArAcctDet:80)
 
     D ArPoolDet                     41A   DIM(50)
     D  APoolTypD                     8A   OVERLAY(ArPoolDet:1)
     D  APoolDocRf                   33A   OVERLAY(ArPoolDet:9)
 
     D ArExPlDet                    266A   DIM(50)
     D  AExPlCus                     10A   OVERLAY(ArExPlDet:1)
     D  AExPlRmr                    256A   OVERLAY(ArExPlDet:11)
 
     D ArExclDet                    280A   DIM(50)
     D  AExcCust                     10A   OVERLAY(ArExclDet:1)
     D  AExcRmrk                    256A   OVERLAY(ArExclDet:11)
     D  AExcMemb                     10A   OVERLAY(ArExclDet:267)
     D  AExcMTyp                      4A   OVERLAY(ArExclDet:277)
 
     D ArInclDet                    267A   DIM(50)
     D  AInclFlg                      1A   OVERLAY(ArInclDet:1)
     D  AInclCust                    10A   OVERLAY(ArInclDet:2)
     D  AInclMIR                    256A   OVERLAY(ArInclDet:12)
     D  AInclude                     11A   OVERLAY(ArInclDet:1)
 
     D ArPoolDet1                    26A   DIM(7)
     D  APoolCust1                   10A   OVERLAY(ArPoolDet1:1)
     D  APoolIndc1                    1A   OVERLAY(ArPoolDet1:11)
     D  APoolAmt1                    15A   OVERLAY(ArPoolDet1:12)
 
     D ArPoolDet2                    26A   DIM(7)
     D  APoolCust2                   10A   OVERLAY(ArPoolDet2:1)
     D  APoolIndc2                    1A   OVERLAY(ArPoolDet2:11)
     D  APoolAmt2                    15A   OVERLAY(ArPoolDet2:12)
 
     D ArPoolDet3                    26A   DIM(7)
     D  APoolCust3                   10A   OVERLAY(ArPoolDet3:1)
     D  APoolIndc3                    1A   OVERLAY(ArPoolDet3:11)
     D  APoolAmt3                    15A   OVERLAY(ArPoolDet3:12)
 
     D ArPoolDet4                    26A   DIM(7)
     D  APoolCust4                   10A   OVERLAY(ArPoolDet4:1)
     D  APoolIndc4                    1A   OVERLAY(ArPoolDet4:11)
     D  APoolAmt4                    15A   OVERLAY(ArPoolDet4:12)
 
     D ArPoolDet5                    26A   DIM(7)
     D  APoolCust5                   10A   OVERLAY(ArPoolDet5:1)
     D  APoolIndc5                    1A   OVERLAY(ArPoolDet5:11)
     D  APoolAmt5                    15A   OVERLAY(ArPoolDet5:12)
 
     D ArPoolDet6                    26A   DIM(7)
     D  APoolCust6                   10A   OVERLAY(ArPoolDet6:1)
     D  APoolIndc6                    1A   OVERLAY(ArPoolDet6:11)
     D  APoolAmt6                    15A   OVERLAY(ArPoolDet6:12)
 
      ** Array of Fields for List of Customer/Non-Acct Holders
     D ArListCust      S              7A   DIM(28)
     D ArListNaho      S             11A   DIM(18)
     D ArAcctNumbr     S             83A   DIM(50)
     D ArPoolType      S             41A   DIM(50)
     D ArExcCust       S            280A   DIM(50)
     D ArExPlCust      S            266A   DIM(50)
     D ArIncCust       S            267A   DIM(50)
 
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
 
      **Parameter variables for AOSVALR0 string
     D WsSValK1        S             20
     D WsSVal1         S            200
     D WsSValK2        S             20
     D WsSVal2         S            200
     D WsSValK3        S             20
     D WsSVal3         S            200
     D WsSValK4        S             20
     D WsSVal4         S            200
     D WsSValK5        S             20
     D WsSVal5         S            200
     D WsSValK6        S             20
     D WsSVal6         S            200
     D WsSValK7        S             20
     D WsSVal7         S            200
     D WsSValK8        S             20
     D WsSVal8         S            200
     D WsSValK9        S             20
     D WsSVal9         S            200
     D WsSValK0        S             20
     D WsSVal10        S            200
 
     D PRtcd           S              7
     D PrtrnCode       S              7
     D PActn           S              1
     D PMsId           S                   LIKE(MGMSID)
     D PMsgId          S                   LIKE(MGMSID)
     D PMesgID         S                   LIKE(MGMSID)
     D W1AMID          S                   LIKE(MGMSID)
     D W2AMID          S                   LIKE(MGMSID)
     D W3AMID          S                   LIKE(MGMSID)
     D KElemnam        S             30
     D WActn           S              1
     D POptn           S              7
     D PYear           S              4
     D PBrcd           S              3
     D PCtry           S              2
     D PCode           S              2
     D PStat           S              4
     D PWMsg           S             50
     D KCust           S             10
     D FCust           S              6
     D KECus           S             10
     D KAcno           S             26
     D KAcho           S             10
     D KMTyp           S              4
     D KTpElt          S                   LIKE(MGTPMT)
     D KTopMT          S                   LIKE(MGTPMT)
     D KMsgSeq         S              5S 0
     D PCUST           S             10
     D PCuah           S             10                                                     MD043144
     D PSub10          S             10                                                     MD043144
     D PSub6           S              6                                                     MD043144
     D WCuahFlg        S              1                                                     MD043144
     D WCuahFl2        S              1                                                     MD043144
     D PRType          S                   LIKE(GGRTYP)
     D PAcus           S              6
     D KNAHO           S             10
     D PNAHO           S             10
     D PCNST           S              7
     D PCurr           S                   LIKE(EXCCY)
     D WRUN            S              1
     D WBALN           S                   LIKE(EXBALN)
     D WCust           S                   LIKE(EXCUSD)
     D WPoolCust       S                   LIKE(EXCUSD)
     D WPoolCust1      S                   LIKE(EXCUSD)
     D WPoolCust2      S                   LIKE(EXCUSD)
     D WPoolCust3      S                   LIKE(EXCUSD)
     D WPoolCust4      S                   LIKE(EXCUSD)
     D WPoolCust5      S                   LIKE(EXCUSD)
     D WPoolCust6      S                   LIKE(EXCUSD)
     D WIndAcc         S                   LIKE(EXACNO)
     D WIndCus         S                   LIKE(EXCUSD)
     D WRType          S                   LIKE(GGRTYP)
     D WDLType         S              2A   INZ(*BLANKS)
     D WPoolIndc       S              1A
     D WPoolEltTyp     S             15A
     D WModel          S              6
     D WDocTyp         S             10A
     D WCorrDocRef     S             33A
     D WPoolDocRef     S             33A
     D WPoolCorDrf     S             33A
     D WDocRef1        S             33A
     D WDocRef2        S             33A
     D WDocRef3        S             33A
     D WDocRef4        S             33A
     D WDocRef5        S             33A
     D WDocRef6        S             33A
     D WCount          S              3S 0 INZ(0)
     D WCount1         S              3S 0 INZ(0)
     D WCount2         S              3S 0 INZ(0)
     D WCount3         S              3S 0 INZ(0)
     D WCount4         S              3S 0 INZ(0)
     D WCount5         S              3S 0 INZ(0)
     D WCount6         S              3S 0 INZ(0)
     D KMsgNo          S                   LIKE(MGMSID)
     D WVoidMsId       S                   LIKE(MGMSID)
     D WAprvMsId       S                   LIKE(MGMSID)
     D WMsgSeq         S              5S 0
     D PRMsgSeq        S              5S 0
     D PBranch         S              3A
     D WField          S             11A
     D WBRIntCust      S              6A
     D WReportInd      S              1A
     D WReportJnt      S              1A
     D WReportPool     S              1A
     D WLowDepAcc      S              1A   INZ('N')
     D WRepTypPool     S              8A
     D WPrRTypPool     S              8A
     D WActHldrTyp     S              8A
     D WSysOff         S              2S 0
     D WOvrOff         S              2S 0
     D WIndCnt         C                   CONST(11)
     D WArrCnt         S              2S 0
     D Ix              S              2S 0 INZ(0)
     D Iy              S              2S 0 INZ(0)
     D Iz              S              2S 0 INZ(0)
     D WHasIndicia     S              1A
     D WJHasIndicia    S              1A
     D WJHasSubOwnr    S              1A
     D WHasTINs        S              1A
     D WJHasTINs       S              1A
     D WVoid           S              1A   INZ('N')
     D WDocRefPl       S              3S 0 INZ(0)
     D WSEQ            S              3A   INZ(*BLANKS)
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
 
     D WPoolDet        S            200A
     D WPoolRepTupe    S             50A
     D WPoolActCnt     S              5S 0 INZ(0)
     D WPoolBal        S                   LIKE(EXPSTA)
     D WPoolCusBal     S                   LIKE(EXPSTA)
     D WPoolActCt1     S              5S 0 INZ(0)
     D WPoolBal1       S                   LIKE(EXPSTA)
     D WPoolCusBal1    S                   LIKE(EXPSTA)
     D WPoolActCt2     S              5S 0 INZ(0)
     D WPoolBal2       S                   LIKE(EXPSTA)
     D WPoolCusBal2    S                   LIKE(EXPSTA)
     D WPoolActCt3     S              5S 0 INZ(0)
     D WPoolBal3       S                   LIKE(EXPSTA)
     D WPoolCusBal3    S                   LIKE(EXPSTA)
     D WPoolActCt4     S              5S 0 INZ(0)
     D WPoolBal4       S                   LIKE(EXPSTA)
     D WPoolCusBal4    S                   LIKE(EXPSTA)
     D WPoolActCt5     S              5S 0 INZ(0)
     D WPoolBal5       S                   LIKE(EXPSTA)
     D WPoolCusBal5    S                   LIKE(EXPSTA)
     D WPoolActCt6     S              5S 0 INZ(0)
     D WPoolBal6       S                   LIKE(EXPSTA)
     D WPoolCusBal6    S                   LIKE(EXPSTA)
     D WPoolCcy        S                   LIKE(EXCCY)
     D WHighValAmt     S             15S 0 INZ(0)
     D WSValLowDep     S             13S 0 INZ(0)
     D KGroupNm        S                   LIKE(XMTPMT)
     D KElemNm         S                   LIKE(XMELMT)
     D IdxA            S                   LIKE(MGSEQU) INZ(0)
     D IdxB            S                   LIKE(MGSEQU) INZ(0)
     D IdxC            S                   LIKE(MGSEQU) INZ(0)
     D WsCountryTax    S              2
     D IxSubOwn        S                   LIKE(MGSEQU) INZ(0)
     D IxAccBal        S                   LIKE(MGSEQU) INZ(0)
     D IxPayment       S                   LIKE(MGSEQU) INZ(0)
     D IxPoolRep       S                   LIKE(MGSEQU) INZ(0)
     D SVTPMT          S                   LIKE(MGTPMT)
 
     D WkCSTY          S                   LIKE(EXCSTY)
     D WkCSST          S                   LIKE(EXCSST)
     D WkINFC          S                   LIKE(EXINFC)
     D WkRPTT          S                   LIKE(EXRPTT)
     D WkHVAC          S                   LIKE(EXHVAC)
     D WkEXEM          S                   LIKE(EXEXEM)
     D WkREPT          S                   LIKE(EXREPT)
     D WkDRMT          S                   LIKE(EXDRMT)
     D WJReportInd     S              1A
     D WJReportPl      S              1A
     D WkAmend         S              1A
     D KJano           S             10A
     D XCust           S              6A
     D SCust           S              6A
 
     D PKEY1           S             10A
     D WNUM3           S              3S 0                                                  MD043144
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
 
      ** Main Program
 
     C                   EXSR      SRAccSval
     C                   EVAL      PMesgID = PMsId
     C                   CLEAR                   GLRMDT
 
      ** Check Action to be taken
 
     C                   SELECT
     C                   WHEN      PActn = 'D'
     C                   MOVEL     PMsId         KMsgNo
     C                   EXSR      SRDelReport
     C                   IF        WVoidMsId <> *BLANKS
     C                   EVAL      KMsgNo = WVoidMsId
     C                   EXSR      SRDelReport
     C                   ENDIF
 
     C                   WHEN      PActn = 'N'
     C                             OR PActn = 'R'
 
      ** Processing reporting to write to Report Management Data File
 
     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId
 
     C                   EXSR      SRRepHeader
     C                   EXSR      SRReportFI
 
     C                   EXSR      SRRepNew
     C                   EXSR      SRListExcptn
     C                   EVAL      GGAMID = *BLANKS
     C                   EVAL      GGVMID = *BLANKS
     C                   EXSR      SRWriteMain
 
     C                   IF        PMSID <> *BLANKS
     C                             AND PActn = 'R'
     C                   EVAL      KMsgNo = PMSID
     C                   EXSR      SRDelReport
     C                   ENDIF
 
      ** For Amend and Corrected Reports
 
     C                   WHEN      PActn = 'A'
     C                             OR PActn = 'C'
 
     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId
 
     C                   EXSR      SRRepHeader
     C                   EXSR      SRReportFI
 
     C                   EXSR      SRRepAmend
     C                   EVAL      GGAMID = *BLANKS
     C                   EVAL      GGVMID = *BLANKS
     C                   EXSR      SRWriteMain
     C                   EXSR      SRListExcptn
 
      ** For Include action from a 'DRAFT NEW' report
     C                   WHEN      PActn = 'I'
     C                             AND PRtype = 'DRAFT NEW'
 
      ** Processing reporting to write to Report Management Data File
 
     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId
 
     C                   EVAL      kMsgNo = PMsID
     C                   EXSR      SRAppReport
     C                   EXSR      SRRepIncld
     C                   EVAL      GGAMID = *BLANKS
     C                   EVAL      GGVMID = *BLANKS
     C                   EXSR      SRWriteMain
 
     C                   EXSR      SRListExcptn
 
     C                   IF        PMSID <> *BLANKS
     C                   EVAL      KMsgNo = PMSID
     C                   EXSR      SRDelReport
     C                   ENDIF
 
     C                   WHEN      PActn = 'I'
     C                             AND PRtype <> 'DRAFT NEW'
 
      ** Processing reporting to write to Report Management Data File
 
     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId
 
     C                   EXSR      SRRepHeader
     C                   EXSR      SRReportFI
 
     C                   EXSR      SRRepIncld
     C                   EVAL      GGAMID = *BLANKS
     C                   EVAL      GGVMID = *BLANKS
     C                   EXSR      SRWriteMain
 
     C                   EXSR      SRListExcptn
 
      ** For Omit/Exclude action from a 'DRAFT NEW' report
     C                   WHEN      PActn = 'O'
     C                             AND PRtype = 'DRAFT NEW'
 
     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId
 
     C                   EVAL      kMsgNo = PMsID
     C                   EXSR      SRAppReport
     C                   EXSR      SRRepExclude2
     C                   EXSR      SRRepExcPool2
 
     C                   EVAL      GGAMID = *BLANKS
     C                   EVAL      GGVMID = *BLANKS
     C                   EXSR      SRWriteMain
 
     C                   EXSR      SRListExcptn
 
     C                   IF        PMSID <> *BLANKS
     C                   EVAL      KMsgNo = PMSID
     C                   EXSR      SRDelReport
     C                   ENDIF
 
     C                   WHEN      PActn = 'O'
     C                             AND PRtype <> 'DRAFT NEW'
 
     C                   EXSR      SRRepExclude
 
      ** Generate Pool where customer has been excluded
 
     C                   EXSR      SRRepExcPool
 
     C                   WHEN      PActn = 'V'
 
      ** Generate Void
     C                   EVAL      WRtype = 'DRAFT VOID'
     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId
 
     C                   EXSR      SRRepHeader
     C                   EXSR      SRReportFI
     C                   EXSR      SRRepVoid
     C                   EVAL      GGAMID = *BLANKS
     C                   EXSR      SRWriteMain
     C                   EXSR      SRListExcptn
      ** Generate Void New
     C                   EVAL      WRtype = 'DRAFT VOID NEW'
     C                   EXSR      SRGenMsgID
     C                   EVAL      GGVMID = MGMSID
     C                   EVAL      MGMSID = WMsgId
 
     C                   EXSR      SRRepHeader
     C                   EXSR      SRReportFI
     C                   EXSR      SRRepAmend
     C                   EXSR      SRWriteMain
      ** save Void Message ID from VOID message
     C                   EVAL      KMsgNo = GGVMID
     C     KMsgNo        CHAIN     GLRPMGL0
     C                   IF        %FOUND(GLRPMGL0)
     C                   EVAL      GGVMID = WMsgId
     C                   UPDATE    GLRPMGD0
     C                   ENDIF
     C                   EXSR      SRListExcptn
 
     C                   WHEN      PActn = 'X'
     C                   MOVEL     PMsId         WMsgId
     C                   EXSR      SRGenMsgID
     C                   EVAL      kMsgNo = PMsID
     C                   EXSR      SRAppReport
 
     C                   EVAL      GGAMID = PMsId
     C                   EVAL      W1AMID = GGAMID
     C                   EVAL      GGVMID = *BLANKS
     C                   EVAL      WRType = PRtype
     C                   EXSR      SRWriteMain
     C                   EVAL      W3AMID = GGMSID
     C                   EXSR      SRListExcptn
     C                   EXSR      SRCallXML
 
     C                   IF        W1AMID <> *BLANKS
     C                   EVAL      KMsgNo = W1AMID
     C                   EXSR      SRDelReport
     C                   ENDIF
 
     C                   IF        WVoidMsId <> *BLANKS
     C                   EVAL      WAprvMsId = GGMSID
     C                   MOVEL     WVoidMsId     WMsgId
     C                   EXSR      SRGenMsgID
     C                   EVAL      kMsgNo = WVoidMsId
     C                   EXSR      SRAppReport
     C                   EVAL      GGAMID = GGMSID
     C                   EVAL      GGVMID = W3AMID
     C                   EXSR      SRWriteMain
     C                   EVAL      W2AMID = GGAMID
      ** update Approved message Id of the draft
     C                   EVAL      KMsgNo = W3AMID
     C     KMsgNo        CHAIN     GLRPMGL0
     C                   IF        %FOUND(GLRPMGL0)
     C                   EVAL      GGVMID = WMsgId
     C                   UPDATE    GLRPMGD0
     C                   ENDIF
     C                   EVAL      PMSID = W3AMID
     C                   EXSR      SRListExcptn
     C                   EXSR      SRCallXML
 
     C                   IF        W2AMID <> *BLANKS
     C                   EVAL      KMsgNo = W2AMID
     C                   EXSR      SRDelReport
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReportFI - Reporting FI                                     *
      *                                                               *
      *****************************************************************
     C     SRReportFI    BEGSR
 
     C                   IF        PRpDocRef <> *BLANKS
     C                             AND (PActn = 'C'
     C                             OR PActn = 'A')
     C                             OR PRpDocRef <> *BLANKS
     C                             AND WRtype = 'DRAFT VOID NEW'
     C                             AND PActn = 'V'
     C                             OR PActn = 'N'
     C                             OR PActn = 'R'
     C                   EVAL      MGTPMT = 'ReportingFI'
     C                   EVAL      MGCUST = *BLANKS
     C                   EVAL      MGACNO = *BLANKS
     C                   EVAL      KGroupNm = 'FATCA'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl
 
     C                   EVAL      MGELMT = 'TIN'
     C                   EVAL      MGDATA = FAGIIN
     C                   EVAL      MGDAT2 = *BLANKS
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'ResCountryCode'
     C                   EVAL      MGDATA = BBCOLC
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'Name'
     C                   EVAL      PAcus = WBRIntCust
     C                   EXSR      SRAccAcus
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
     C                   EVAL      MGDATA = %TRIM(WBRIntCust)
     C                                      + '.' + WMsgAcSq + WMsgDtyp
     C                                      + WMsgActn
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'CorrDocRefId'
     C                   EVAL      MGDATA = PRpDocRef
     C                   EXSR      SRWrite
 
     C                   ELSE
     C                   EVAL      KMsgNo = PMsId
     C                   EVAL      KTopMT = 'ReportingFI'
     C     KRepFI        SETLL     GLRMDTL0
     C     KRepFI        READE     GLRMDTL0
 
     C                   DOW       NOT %EOF(GLRMDTL0)
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
     C                   WHEN      MGELMT = 'DocTypeIndic'
     C                             AND WRtype = 'DRAFT VOID'
     C                             AND PActn = 'V'
     C                             AND PRpDocRef <> *BLANKS
     C                   EVAL      MGDATA = WDoctyp
     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      Iz = %SCAN('.':MGDATA) + 1
     C                   EVAL      %SUBST(MGDATA:Iz:6) = WMsgAcSq + WMsgDtyp
     C                                                   + WMsgActn
     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                             AND WRtype = 'DRAFT VOID'
     C                             AND PActn = 'V'
     C                             AND PRpDocRef <> *BLANKS
     C                   EVAL      MGDATA = PRpDocRef
     C                   ENDSL
 
     C                   EXSR      SRWrite
     C     KRepFI        READE     GLRMDTL0
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
 
     C     PBrcd         SETLL     GLRMEXL0
     C     PBrcd         READE     GLRMEXL0
 
      ** Record found
     C                   DOW       NOT %EOF(GLRMEXL0)
 
     C                   IF        EXJANO = *BLANKS
 
     C                   IF        EXFILE = 'FCAB'
     C                             OR EXFILE = 'CSBA'
     C                   EVAL      WLowDepAcc = 'N'
     C                   EXSR      SRChkLowDep
     C                   IF        WLowDepAcc = 'Y'
     C                   EVAL      KCust = EXCUSD
     C                   EVAL      KAcno = EXACNO
     C     KBrAcno1      SETGT     GLRMEXL0
     C     PBrcd         READE     GLRMEXL0
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
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
     C                             OR
     C                             WIndCus <> EXCUSD
     C                   EVAL      WIndCUS = EXCUSD
     C                   EVAL      WIndAcc = EXACNO
     C                   EXSR      SRCsActRepHdr
     C                   EXSR      SRWrIndvRept
     C                   IF        WActHldrTyp <> 'FATCA103'
     C                             AND WActHldrTyp <> 'FATCA104'
     C                   IF        WActHldrTyp = 'FATCA101'
     C                             OR WActHldrTyp = 'FATCA102'
     C                   EXSR      SRSubOwner
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
     C                   ENDIF
 
     C                   WHEN      WReportPool = 'Y'
     C                   EXSR      SRCompPool
     C                   EXSR      SRPoolTotal
 
     C                   OTHER
 
      ** Read next customer Record to be reported
 
     C**********         EVAL      KCust = EXCUSD                                           MD044368
     C*****KBrCust0      SETGT     GLRMEXL0                                                 MD044368
 
     C                   ENDSL
 
 
     C                   EVAL      IdxC = 0
     C                   IF        EXACNO <> WPrevAcno
     C                   EVAL      IxPayment = 3000
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      WPrevRepIn = 'Y'
     C                   EXSR      SRCompPaymt
     C                   WHEN      WPrevRepJn = 'Y'
     C                   EXSR      SRComPayJac
     C                   WHEN      WReportInd = 'Y'
     C                             OR WReportJnt = 'Y'
     C                   EXSR      SRCompPaymt
     C                   ENDSL
 
     C     PBrcd         READE     GLRMEXL0
 
     C                   ENDDO
 
     C                   EVAL      IdxC = 0
     C                   EVAL      EXCUSD = *BLANKS
     C                   EVAL      EXACNO = *BLANKS
     C                   IF        EXACNO <> WPrevAcno
     C                   EVAL      IxPayment = 3000
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      WPrevRepIn = 'Y'
     C                   EXSR      SRCompPaymt
     C                   WHEN      WPrevRepJn = 'Y'
     C                   EXSR      SRComPayJac
     C                   ENDSL
 
     C                   EVAL      EXCUSD = *BLANKS
     C                   EXSR      SRCompPool
     C                   EXSR      SRReportPool
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepAmend - Amend Report for selected Customers              *
      *                                                               *
      *****************************************************************
     C     SRRepAmend    BEGSR
 
     C                   EXSR      SRInit
 
     C                   EVAL      Ix = 1
     C                   EVAL      ArAcctDet = *BLANKS
     C                   MOVEA     ArAcctNumbr   ArAcctDet
 
      ** Report Account Holder selected for Amended
 
     C                   DOW       AAcctCust(Ix) <> *BLANKS
     C                             AND Ix < 50
 
     C                   EVAL      WIndAcc = *BLANKS
     C                   EVAL      KCust = AAcctCust(Ix)
     C                   EVAL      KAcno = AAcctNum(Ix)
     C                   EVAL      WCorrDocRef  = AAcDocRf(Ix)
 
     C     KBrAcno1      SETLL     GLRMEXL0
     C     KBrAcno1      READE     GLRMEXL0
 
     C                   DOW       NOT %EOF(GLRMEXL0)
 
     C                   IF        EXJANO = *BLANKS
 
     C                   IF        EXFILE = 'FCAB'
     C                             OR EXFILE = 'CSBA'
     C                   EVAL      WLowDepAcc = 'N'
     C                   EXSR      SRChkLowDep
     C                   IF        WLowDepAcc = 'Y'
     C                   EVAL      KCust = EXCUSD
     C                   EVAL      KAcno = EXACNO
     C     KBrAcno1      SETGT     GLRMEXL0
     C     KBrAcno1      READE     GLRMEXL0
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRCustCheck
 
     C                   ELSE
 
     C                   EXSR      SRJaccCheck
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      WReportInd = 'Y'
      ** Report Header and Individual/Organization Details for the
      ** Account Holder
 
     C                   IF        WIndAcc <> EXACNO
     C                             OR
     C                             WIndCus <> EXCUSD
     C                   EVAL      WIndCUS = EXCUSD
     C                   EVAL      WIndAcc = EXACNO
     C                   EXSR      SRCsActRepHdr
     C                   EXSR      SRWrIndvRept
     C                   IF        WActHldrTyp <> 'FATCA103'
     C                             AND WActHldrTyp <> 'FATCA104'
     C                   IF        WActHldrTyp = 'FATCA101'
     C                             OR WActHldrTyp = 'FATCA102'
     C                   EXSR      SRSubOwner
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
     C                   ENDIF
     C                   ENDSL
 
     C                   EVAL      IdxC = 0
     C                   IF        EXACNO <> WPrevAcno
     C                   EVAL      IxPayment = 3000
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      WPrevRepIn = 'Y'
     C                   EXSR      SRCompPaymt
     C                   WHEN      WPrevRepJn = 'Y'
     C                   EXSR      SRComPayJac
     C                   WHEN      WReportInd = 'Y'
     C                             OR WReportJnt = 'Y'
     C                   EXSR      SRCompPaymt
     C                   ENDSL
 
     C     KBrAcno1      READE     GLRMEXL0
     C                   ENDDO
 
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
 
      ** Report last payment from Account Array
     C                   EVAL      EXCUSD = *BLANKS
     C                   EVAL      EXACNO = *BLANKS
     C                   EVAL      IdxC = 0
     C                   IF        EXACNO <> WPrevAcno
     C                   EVAL      IxPayment = 3000
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      WPrevRepIn = 'Y'
     C                   EXSR      SRCompPaymt
     C                   WHEN      WPrevRepJn = 'Y'
     C                   EXSR      SRComPayJac
     C                   ENDSL
 
      ** Amending Pool Report
     C                   IF        ArPoolType(1) <> *BLANKS
     C                   EVAL      ArPoolDet = *BLANKS
     C                   MOVEA     ArPoolType    ArPoolDet
     C                   EVAL      Ix = 1
 
     C                   DOW       APoolTypD(Ix) <> *BLANKS
     C                             AND Ix < 50
     C                   SELECT
     C                   WHEN      APoolTypD(Ix) = 'FATCA201'
     C                   EVAL      WDocRef1 = APoolDocRf(Ix)
     C                   WHEN      APoolTypD(Ix) = 'FATCA202'
     C                   EVAL      WDocRef2 = APoolDocRf(Ix)
     C                   WHEN      APoolTypD(Ix) = 'FATCA203'
     C                   EVAL      WDocRef3 = APoolDocRf(Ix)
     C                   WHEN      APoolTypD(Ix) = 'FATCA204'
     C                   EVAL      WDocRef4 = APoolDocRf(Ix)
     C                   WHEN      APoolTypD(Ix) = 'FATCA205'
     C                   EVAL      WDocRef5 = APoolDocRf(Ix)
     C                   WHEN      APoolTypD(Ix) = 'FATCA206'
     C                   EVAL      WDocRef6 = APoolDocRf(Ix)
     C                   ENDSL
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
 
      ** Report Account Holder selected for Amended
 
     C     PBrcd         SETLL     GLRMEXL0
     C     PBrcd         READE     GLRMEXL0
 
     C                   DOW       NOT %EOF(GLRMEXL0)
 
     C                   IF        EXJANO = *BLANKS
     C                   IF        EXFILE = 'FCAB'
     C                             OR EXFILE = 'CSBA'
     C                   EVAL      WLowDepAcc = 'N'
     C                   EXSR      SRChkLowDep
     C                   IF        WLowDepAcc = 'Y'
     C                   EVAL      KCust = EXCUSD
     C                   EVAL      KAcno = EXACNO
     C     KBrAcno1      SETGT     GLRMEXL0
     C     PBrcd         READE     GLRMEXL0
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRCustCheck
     C                   ELSE
 
     C                   EXSR      SRJaccCheck
     C                   ENDIF
 
     C                   IF        %LOOKUP(WRepTypPool:APoolTypD) <> 0
     C                             AND WReportPool = 'Y'
     C                   EXSR      SRCompPool
     C                   EXSR      SRPoolTotal
     C                   ENDIF
 
     C     PBrcd         READE     GLRMEXL0
     C                   ENDDO
 
     C                   EVAL      EXCUSD = *BLANKS
     C                   EXSR      SRCompPool
     C                   EXSR      SRReportPool
     C                   ENDIF
 
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
 
     C                   EVAL      Ix = 1
     C                   EVAL      ArInclDet = *BLANKS
     C                   MOVEA     ArIncCust     ArInclDet
 
      ** Report Account Holder selected
 
     C                   DOW       AInclCust(Ix) <> *BLANKS
     C                             AND Ix < 50
      ** For Customers
     C                   EVAL      KCust = AInclCust(Ix)
 
     C     KBrCust0      SETLL     GLRMEXL0
     C     KBrCust0      READE     GLRMEXL0
 
     C                   DOW       NOT %EOF(GLRMEXL0)
 
     C                   IF        EXJANO = *BLANKS
 
     C                   IF        EXFILE = 'FCAB'
     C                             OR EXFILE = 'CSBA'
     C                   EVAL      WLowDepAcc = 'N'
     C                   EXSR      SRChkLowDep
     C                   IF        WLowDepAcc = 'Y'
     C                   EVAL      KCust = EXCUSD
     C                   EVAL      KAcno = EXACNO
     C     KBrAcno1      SETGT     GLRMEXL0
     C     KBrCust0      READE     GLRMEXL0
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRCustCheck
 
     C                   ELSE
 
     C                   EXSR      SRJaccCheck
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      WReportInd = 'Y'
      ** Report Header and Individual/Organization Details for the
      ** Account Holder
 
     C                   IF        WIndAcc <> EXACNO
     C                             OR
     C                             WIndCus <> EXCUSD
     C                   EVAL      WIndCUS = EXCUSD
     C                   EVAL      WIndAcc = EXACNO
     C                   EXSR      SRCsActRepHdr
     C                   EXSR      SRWrIndvRept
     C                   IF        WActHldrTyp <> 'FATCA103'
     C                             AND WActHldrTyp <> 'FATCA104'
     C                   IF        WActHldrTyp = 'FATCA101'
     C                             OR WActHldrTyp = 'FATCA102'
     C                   EXSR      SRSubOwner
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
     C                   ENDIF
 
     C                   WHEN      WReportPool = 'Y'
      ** Save pool Type in array
     C                   EVAL      Iy = Iy + 1
     C                   EVAL      APoolTypD (Iy) = WRepTypPool
 
     C                   OTHER
 
     C                   ENDSL
 
     C                   EVAL      IdxC = 0
     C                   IF        EXACNO <> WPrevAcno
     C                   EVAL      IxPayment = 3000
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      WPrevRepIn = 'Y'
     C                   EXSR      SRCompPaymt
     C                   WHEN      WPrevRepJn = 'Y'
     C                   EXSR      SRComPayJac
     C                   WHEN      WReportInd = 'Y'
     C                             OR WReportJnt = 'Y'
     C                   EXSR      SRCompPaymt
     C                   ENDSL
 
     C     KBrCust0      READE     GLRMEXL0
     C                   ENDDO
 
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
 
      ** Report last payment from Account Array
     C                   EVAL      EXCUSD = *BLANKS
     C                   EVAL      EXACNO = *BLANKS
     C                   EVAL      IdxC = 0
     C                   IF        EXACNO <> WPrevAcno
     C                   EVAL      IxPayment = 3000
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      WPrevRepIn = 'Y'
     C                   EXSR      SRCompPaymt
     C                   WHEN      WPrevRepJn = 'Y'
     C                   EXSR      SRComPayJac
     C                   ENDSL
 
      ** Report Pool where the customer is included
     C                   IF        APoolTypD (1) <> *BLANKS
     C     PBrcd         SETLL     GLRMEXL0
     C     PBrcd         READE     GLRMEXL0
 
     C                   DOW       NOT %EOF(GLRMEXL0)
 
     C                   IF        EXJANO = *BLANKS
     C                   IF        EXFILE = 'FCAB'
     C                             OR EXFILE = 'CSBA'
     C                   EVAL      WLowDepAcc = 'N'
     C                   EXSR      SRChkLowDep
     C                   IF        WLowDepAcc = 'Y'
     C                   EVAL      KCust = EXCUSD
     C                   EVAL      KAcno = EXACNO
     C     KBrAcno1      SETGT     GLRMEXL0
     C     PBrcd         READE     GLRMEXL0
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRCustCheck
     C                   ELSE
 
     C                   EXSR      SRJaccCheck
     C                   ENDIF
     C                   IF        %LOOKUP(WRepTypPool:APoolTypD) <> 0
     C                             AND WReportPool = 'Y'
     C                   EXSR      SRCompPool
     C                   EXSR      SRPoolTotal
     C                   ELSE
     C                   EVAL      KCust = EXCUSD
     C     KBrCust0      SETGT     GLRMEXL0
     C                   ENDIF
 
     C     PBrcd         READE     GLRMEXL0
     C                   ENDDO
 
     C                   EVAL      EXCUSD = *BLANKS
     C                   EXSR      SRCompPool
     C                   IF        PActn = 'I'
     C                             AND PRtype = 'DRAFT NEW'
     C                   SELECT
     C                   WHEN      WPrRTypPool = 'FATCA201'
     C                   EVAL      PRMsgSeq = 1
     C                   EXSR      SRDelPoolRep
     C                   WHEN      WPrRTypPool = 'FATCA202'
     C                   EVAL      PRMsgSeq = 2
     C                   EXSR      SRDelPoolRep
     C                   WHEN      WPrRTypPool = 'FATCA203'
     C                   EVAL      PRMsgSeq = 3
     C                   EXSR      SRDelPoolRep
     C                   WHEN      WPrRTypPool = 'FATCA204'
     C                   EVAL      PRMsgSeq = 4
     C                   EXSR      SRDelPoolRep
     C                   WHEN      WPrRTypPool = 'FATCA205'
     C                   EVAL      PRMsgSeq = 5
     C                   EXSR      SRDelPoolRep
     C                   WHEN      WPrRTypPool = 'FATCA206'
     C                   EVAL      PRMsgSeq = 6
     C                   EXSR      SRDelPoolRep
     C                   ENDSL
     C                   ENDIF
     C                   EXSR      SRReportPool
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepHeader - Report Header Details                           *
      *                                                               *
      *****************************************************************
     C     SRRepHeader   BEGSR
 
 
     C                   EVAL      MGSEQU = 1
     C                   EVAL      MGELMT = 'FATCA_OECD'
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
 
     C                   EVAL      KGroupNm = 'FATCA_OECD'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl
 
     C                   EVAL      PBranch = PBrcd
     C                   EXSR      SRAccBranch
     C                   EVAL      FCust = WBRIntCust
     C                   EXSR      SRFTCSDet
     C                   EVAL      PCust = WBRIntCust
     C                   EXSR      SRAccCust
     C                   EVAL      WBrIntCOLC = BBCOLC
 
     C                   IF        PActn = 'N'
     C                             OR PActn = 'R'
     C                   EVAL      MGELMT = 'SendingCompanyIN'
     C                   EVAL      MGDATA = FAGIIN
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'TransmittingCountry'
     C                   EVAL      MGDATA = BBCOLC
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'ReceivingCountry'
     C                   IF        A4FAAT = 'M1R'
     C                             OR A4FAAT = 'M1N'
     C                   EVAL      MGDATA = BBCOLC
     C                   ENDIF
     C                   EVAL      PCode = BBCOLC
     C                   EXSR      SRAccCountry
     C                   IF        A4FAAT = 'M2R'
     C                             OR A4FAAT = 'M2N'
     C                             OR A4FAAT = 'NOA'
     C                   EVAL      MGDATA = 'US'
     C                   ENDIF
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'MessageType'
     C                   EVAL      MGDATA = 'FATCA'
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'Warning'
     C                   EVAL      KMsgNo = PMesgID
     C                   EVAL      KElemnam = MGELMT
     C                   IF        PWMsg = *Blanks
     C     KWarn         CHAIN     GLRMDTL5
     C                   IF        %FOUND(GLRMDTL5)
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
     C                   EVAL      MGELMT = 'CorrMessageRefId'
     C                   IF        PActn = 'A'
     C                             OR PActn = 'C'
     C                             OR PActn = 'V'
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
 
     C                   EVAL      MGELMT = 'FATCA'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      KGroupNm = 'FATCA_OECD'
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'ReportingGroup'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      KGroupNm = 'FATCA'
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EXSR      SRWrite
 
     C                   ELSE
     C                   EVAL      KMsgNo = PMsId
     C                   EVAL      KTopMT = 'MessageSpec'
     C     KRepFI        SETLL     GLRMDTL0
     C     KRepFI        READE     GLRMDTL0
 
     C                   DOW       NOT %EOF(GLRMDTL0)
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
     C                   WHEN      MGELMT = 'CorrMessageRefId'
     C                   IF        PActn = 'A'
     C                             OR PActn = 'C'
     C                             OR PActn = 'V'
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
     C     KRepFI        READE     GLRMDTL0
     C                   ENDDO
     C                   ENDIF
     C
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
 
     C                   EVAL      MGCUST = EXCUSD
     C                   EVAL      MGACHO = EXCUSD
     C                   EVAL      MGMTYP = 'CUST'
     C                   EVAL      MGACNO = EXACNO
     C                   EVAL      MGTPMT = 'AccountReport'
     C                   EVAL      MGELMT = 'DocTypeIndic'
     C                   EVAL      MGDATA = WDocTyp
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'DocRefId'
     C                   EVAL      MGDATA = %TRIM(EXACNO)
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
 
     C                   EVAL      MGELMT = 'AcctHolder'
     C                   EVAL      MGDATA = EXCUSD
     C                   EVAL      MGDAT2 = 'CUST'
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EVAL      MGELMT = 'AcctHolderType'
     C                   EVAL      MGDATA =  WActHldrTyp
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
 
     C                   IF        EXCSTY <> 'P'
     C                   EVAL      MGTPMT = 'AccountHolder'
     C                   EVAL      MGELMT = 'AcctHolderType'
     C                   EVAL      MGDATA = WActHldrTyp
     C                   EXSR      SRWrite
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrJaccRept  - Reporting Joint Account Members               *
      *                                                               *
      *****************************************************************
     C     SRWrJaccRept  BEGSR
 
     C                   EVAL      MGSEQU = 0
     C                   EVAL      IdxA = 0
 
      ** Check if the member is selected for Amend
     C                   IF        PActn = 'V'
     C                             OR PActn = 'A'
     C                             OR PActn = 'C'
     C                   IF        AAcctMem(Ix) <> EXCUSD
     C                             AND AAcctTyp(Ix) = EXACTY
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      IdxA = IdxA + 1
     C                   EVAL      MGSEQU = IdxA
     C                   EVAL      MGCUST = EXCUSD
     C                   EVAL      MGACNO = EXACNO
     C                   EVAL      MGACHO = EXCUSD
     C                   EVAL      MGMTYP = EXACTY
 
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
 
     C                   EVAL      MGTPMT = 'AccountReport'
 
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'DocSpec'
     C                   EXSR      SRGetGrpLevl
 
     C                   EVAL      MGELMT = 'DocTypeIndic'
     C                   EVAL      MGDATA = WDocTyp
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'DocRefId'
     C                   EVAL      MGDATA = %TRIM(EXACNO)
     C                                      + '.' + WMsgAcSq + WMsgDtyp
     C                                      + WMsgActn
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'CorrDocRefId'
     C                   EVAL      MGDATA = WCorrDocRef
     C                   EXSR      SRWrite
 
     C                   EVAL      KGroupNm = 'ReportingGroup'
     C                   EVAL      KElemNm  = 'AccountReport'
     C                   EXSR      SRGetGrpLevl
 
     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      MGDATA = EXACNO
     C                   EXSR      SRWrite
 
     C                   IF        EXACTY = 'CUST'
 
      ** Get Customer Details of the Joint Account Member
 
     C                   EVAL      FCust = EXCUSD
     C                   EXSR      SRFTCSDet
 
     C                   EVAL      PAcus = EXCUSD
     C                   EXSR      SRAccAcus
 
     C                   EVAL      PCust = EXCUSD
     C                   EXSR      SRAccCust
 
 
     C                   EVAL      MGELMT = 'AcctHolder'
     C                   EVAL      MGDATA = EXCUSD
     C                   EVAL      MGDAT2 = EXACTY
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EVAL      MGELMT = 'AcctHolderType'
     C                   EVAL      MGDATA = WActHldrTyp
 
     C                   EXSR      SRWrite
 
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'AccountHolder'
     C                   EXSR      SRGetGrpLevl
 
     C                   IF        FACSTY <> 'P'
     C                   EVAL      MGTPMT = 'AccountHolder'
     C                   EXSR      SRWrite
     C                   ENDIF
 
     C                   IF        FACSTY = 'P'
     C                   EVAL      MGTPMT = 'Individual'
     C                   ELSE
     C                   EVAL      MGTPMT = 'Organisation'
     C                   ENDIF
 
     C                   EVAL      MGELMT = 'AcctHolder'
     C                   EVAL      MGDATA = EXCUSD
     C                   EVAL      MGDAT2 = EXACTY
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EVAL      MGLEVL = 0
     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      MGDATA = EXACNO
     C                   EXSR      SRWrite
 
     C                   EVAL      KGroupNm = 'AccountHolder'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl
 
     C                   EXSR      SRWrCusDetail
 
     C                   IF        FACSTY = 'P'
 
     C                   EVAL      KGroupNm = 'Individual'
     C                   EVAL      KElemNm  = 'BirthInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'Individual'
 
     C                   EVAL      MGELMT = 'BirthDate'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      MGDATA = E5DBTH
     C                   EXSR      SRWrite
     C                   ENDIF
 
     C                   ELSE
 
      ** Get Non-Account Holder Details of the Joint Account Member
 
     C                   EVAL      KNAHO  = EXCUSD
     C                   EXSR      SRFTNHDet
 
     C                   EVAL      PNaho = EXCUSD
     C                   EXSR      SRAccNaho
 
     C                   EVAL      MGELMT = 'AcctHolder'
     C                   EVAL      MGDATA = EXCUSD
     C                   EVAL      MGDAT2 = 'NAHO'
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   IF        FNNHTY = 'P'
     C                   EVAL      MGLEVL = 0
     C                   ELSE
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'AccountHolder'
     C                   EXSR      SRGetGrpLevl
     C                   ENDIF
     C                   EVAL      MGELMT = 'AcctHolderType'
     C                   EVAL      MGDATA =  WActHldrTyp
     C                   EXSR      SRWrite
 
     C                   IF        FNNHTY = 'P'
     C                   EVAL      MGTPMT = 'Individual'
     C                   ELSE
     C                   EVAL      MGTPMT = 'Organisation'
     C                   ENDIF
 
     C                   EVAL      MGELMT = 'AcctHolder'
     C                   EVAL      MGDATA = EXCUSD
     C                   EVAL      MGDAT2 = 'NAHO'
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EVAL      MGLEVL = 0
     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      MGDATA = EXACNO
     C                   EXSR      SRWrite
 
     C                   EVAL      KGroupNm = 'AccountHolder'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl
 
     C                   EXSR      SRWrNahDetail
 
     C                   IF        FNNHTY = 'P'
 
     C                   EVAL      KGroupNm = 'Individual'
     C                   EVAL      KElemNm  = 'BirthInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'Individual'
 
     C                   EVAL      MGELMT = 'BirthDate'
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVEL     NHDBTH        MGDATA
     C                   EXSR      SRWrite
     C                   ENDIF
 
     C                   ENDIF
 
      ** Report Account Balance of the Account Holder
     C                   EXSR      SRAccBalance
 
      ** Read next Joint Account member
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrCusDetail - Reporting Individual Account                  *
      *                                                               *
      *****************************************************************
     C     SRWrCusDetail BEGSR
 
     C                   EVAL      SVTPMT = MGTPMT
     C                   EVAL      WTINS  = *BLANKS
     C                   EVAL      WISCT  = *BLANKS
     C                   EVAL      WCTIN1 = FAUTIN
 
     C                   EVAL      MGELMT = 'TIN'
     C                   EVAL      MGDATA = WTINS
     C                   EVAL      MGDAT2 = WISCT
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EVAL      MGELMT = 'ResCountryCode'
     C                   EVAL      MGDATA = BBCOLC
     C                   EXSR      SRWrite
 
     C                   IF        FACSTY = 'P'
     C                   EVAL      KGroupNm = KElemNm
     C                   EVAL      KElemNm  = 'Name'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGELMT = 'FirstName'
     C                   EVAL      MGDATA = E5CNA2
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'LastName'
     C                   EVAL      MGDATA = E5CNA1
     C                   EXSR      SRWrite
     C                   ELSE
     C                   EVAL      MGELMT = 'Name'
     C                   EVAL      MGDATA = BBCNA1
     C                   EXSR      SRWrite
     C                   ENDIF
 
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
     C                   EVAL      WTINS  = *BLANKS
     C                   EVAL      WISCT  = *BLANKS
     C                   EVAL      WCTIN1 = FNUTIN
 
     C                   EVAL      MGELMT = 'TIN'
     C                   EVAL      MGDATA = WTINS
     C                   EVAL      MGDAT2 = WISCT
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EVAL      MGELMT = 'ResCountryCode'
     C                   EVAL      MGDATA = NHCOLC
     C                   EXSR      SRWrite
 
     C                   IF        FNNHTY = 'P'
     C                   EVAL      KGroupNm = KElemNm
     C                   EVAL      KElemNm  = 'Name'
     C                   EXSR      SRGetGrpLevl
 
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
 
     C                   IF        EXCSTY = 'P'
     C                   EVAL      MGTPMT = 'Individual'
     C                   ELSE
     C                   EVAL      MGTPMT = 'Organisation'
     C                   ENDIF
     C                   EVAL      SVTPMT = MGTPMT
 
     C                   EVAL      MGELMT = 'AcctHolder'
     C                   EVAL      MGDATA = EXCUSD
     C                   EVAL      MGDAT2 = 'CUST'
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EVAL      MGLEVL = 0
     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      MGDATA = EXACNO
     C                   EXSR      SRWrite
 
     C                   EVAL      WTINS  = *BLANKS
     C                   EVAL      WISCT  = *BLANKS
     C                   EVAL      FCust  = EXCUSD
     C                   EXSR      SRFTCSDet
     C                   EVAL      WCTIN1 = FAUTIN
 
     C                   EVAL      KGroupNm = 'AccountHolder'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl
 
     C                   EVAL      MGELMT = 'TIN'
     C                   EVAL      MGDATA = WTINS
     C                   EVAL      MGDAT2 = WISCT
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EVAL      MGELMT = 'ResCountryCode'
     C                   EVAL      MGDATA = EXCOLC
     C                   EXSR      SRWrite
 
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = 'Name'
     C                   EXSR      SRGetGrpLevl
 
     C                   IF        EXCSTY = 'P'
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
 
     C                   IF        EXCSTY = 'P'
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
 
      ** Delete Header File
     C     KMsgNo        SETLL     GLRPMGL0
     C     KMsgNo        READE     GLRPMGL0
     C                   DOW       NOT %EOF(GLRPMGL0)
     C                   EVAL      WVoidMsId = GGVMID
     C                   DELETE    GLRPMGL0
     C     KMsgNo        READE     GLRPMGL0
     C                   ENDDO
 
      ** Delete detail File
     C     KMsgNo        SETLL     GLRMDTL0
     C     KMsgNo        READE     GLRMDTL0
 
     C                   DOW       NOT %EOF(GLRMDTL0)
     C                   DELETE    GLRMDTL0
     C     KMsgNo        READE     GLRMDTL0
     C                   ENDDO
 
      ** Delete also Exception List
 
     C     KMsgNo        SETLL     GLRMIEL0
     C     KMsgNo        READE     GLRMIEL0
     C                   DOW       NOT %EOF(GLRMIEL0)
     C                   DELETE    GLRMIEL0
     C     KMsgNo        READE     GLRMIEL0
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepExclude - Exclude Detail from the Report                 *
      *                                                               *
      *****************************************************************
     C     SRRepExclude  BEGSR
 
     C                   IF        ArExcCust(1) <> *BLANKS
     C                   EVAL      WRtype = 'DRAFT VOID'
     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId
     C                   EXSR      SRRepHeader
     C                   EXSR      SRReportFI
 
     C                   EVAL      ArExclDet = *BLANKS
     C                   MOVEA     ArExcCust     ArExclDet
     C                   EVAL      Ix = 1
 
     C                   DOW       AExcCust(Ix) <> *BLANKS
     C                             AND Ix < 50
 
     C                   EVAL      kMsgNo   = *BLANKS
     C                   EVAL      kMsgNo   = PMsId
     C                   EVAL      KEcus    = AExcCust(Ix)
 
     C     KExclude      SETLL     GLRMDTL4
     C     KExclude      READE     GLRMDTL4
 
     C                   DOW       NOT %EOF(GLRMDTL4)
     C                   IF        D4_MGACHO = AExcMemb(Ix)
     C                             AND D4_MGMTYP = AExcMTyp(Ix)
 
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
 
     C                   ENDIF
     C     KExclude      READE     GLRMDTL4
     C                   ENDDO
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
 
     C                   EXSR      SRWriteMain
     C                   EXSR      SRListExcptn
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepExclude2 - Exclude Detail from the Report for DRAFT NEW  *
      *                                                               *
      *****************************************************************
     C     SRRepExclude2 BEGSR
 
     C                   IF        ArExcCust(1) <> *BLANKS
     C                   EVAL      WRtype = 'DRAFT NEW'
 
     C                   EVAL      ArExclDet = *BLANKS
     C                   MOVEA     ArExcCust     ArExclDet
     C                   EVAL      Ix = 1
 
     C                   DOW       AExcCust(Ix) <> *BLANKS
     C                             AND Ix < 50
 
     C                   EVAL      kMsgNo   = *BLANKS
     C                   EVAL      kMsgNo   = WMSGID
     C                   EVAL      KEcus    = AExcCust(Ix)
 
     C     KExclude      SETLL     GLRMDTL4
     C     KExclude      READE     GLRMDTL4
 
     C                   DOW       NOT %EOF(GLRMDTL4)
     C                   IF        D4_MGACHO = AExcMemb(Ix)
     C                             AND D4_MGMTYP = AExcMTyp(Ix)
 
      ** Delete the Report Detail for the Excluded records
     C                   DELETE    GLRMDTL4
 
     C                   ENDIF
     C     KExclude      READE     GLRMDTL4
     C                   ENDDO
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepExcPool - Report Pool with Excluded Customers            *
      *                                                               *
      *****************************************************************
     C     SRRepExcPool  BEGSR
 
     C                   IF        ArPoolType(1) <> *BLANKS
     C                   EVAL      WRtype = 'DRAFT AMEND'
     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId
     C                   EXSR      SRRepHeader
     C                   EXSR      SRReportFI
 
     C                   EVAL      ArExPlDet = *BLANKS
     C                   MOVEA     ArExPlCust    ArExPlDet
     C                   EVAL      ArPoolDet = *BLANKS
     C                   MOVEA     ArPoolType    ArPoolDet
     C                   EVAL      Ix = 1
 
     C                   DOW       APoolTypD(Ix) <> *BLANKS
     C                             AND Ix < 50
     C                   SELECT
     C                   WHEN      APoolTypD(Ix) = 'FATCA201'
     C                   EVAL      WDocRef1 = APoolDocRf(Ix)
     C                   WHEN      APoolTypD(Ix) = 'FATCA202'
     C                   EVAL      WDocRef2 = APoolDocRf(Ix)
     C                   WHEN      APoolTypD(Ix) = 'FATCA203'
     C                   EVAL      WDocRef3 = APoolDocRf(Ix)
     C                   WHEN      APoolTypD(Ix) = 'FATCA204'
     C                   EVAL      WDocRef4 = APoolDocRf(Ix)
     C                   WHEN      APoolTypD(Ix) = 'FATCA205'
     C                   EVAL      WDocRef5 = APoolDocRf(Ix)
     C                   WHEN      APoolTypD(Ix) = 'FATCA206'
     C                   EVAL      WDocRef6 = APoolDocRf(Ix)
     C                   ENDSL
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
 
      ** Report Account Holder selected for Amended
 
     C     PBrcd         SETLL     GLRMEXL0
     C     PBrcd         READE     GLRMEXL0
 
     C                   DOW       NOT %EOF(GLRMEXL0)
 
     C                   IF        EXFILE = 'FCAB'
     C                             OR EXFILE = 'CSBA'
     C                   EVAL      WLowDepAcc = 'N'
     C                   EXSR      SRChkLowDep
     C                   IF        WLowDepAcc = 'Y'
     C                   EVAL      KCust = EXCUSD
     C                   EVAL      KAcno = EXACNO
     C     KBrAcno1      SETGT     GLRMEXL0
     C     PBrcd         READE     GLRMEXL0
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** Check if customer is in the Exclude list
     C                   IF        %LOOKUP(EXCUSD:AExPlCus) = 0
 
     C                   IF        EXJANO = *BLANKS
     C                   EXSR      SRCustCheck
     C                   ELSE
 
     C                   EXSR      SRJaccCheck
     C                   ENDIF
     C                   IF        %LOOKUP(WRepTypPool:APoolTypD) <> 0
     C                             AND WRepTypPool <> *BLANKS
     C                             AND WReportPool = 'Y'
     C                   EXSR      SRCompPool
     C                   EXSR      SRPoolTotal
     C                   ENDIF
     C                   ELSE
     C                   EVAL      KCust = EXCUSD
     C     KBrCust0      SETGT     GLRMEXL0
     C                   ENDIF
 
     C     PBrcd         READE     GLRMEXL0
     C                   ENDDO
 
     C                   EVAL      EXCUSD = *BLANKS
     C                   IF        %LOOKUP(WPrRTypPool:APoolTypD) <> 0
     C                             AND %LOOKUP(WPoolCust:AExPlCus) = 0
     C                             AND WPrRTypPool <> *BLANKS
     C                             AND WPoolCust <> *BLANKS
     C                   EXSR      SRCompPool
     C                   ENDIF
     C                   EXSR      SRReportPool
 
     C                   IF        WPoolActCt1 = 0
     C                             AND WPoolActCt2 = 0
     C                             AND WPoolActCt3 = 0
     C                             AND WPoolActCt4 = 0
     C                             AND WPoolActCt5 = 0
     C                             AND WPoolActCt6 = 0
     C                   MOVEL     WMsgId        KMsgNo
     C                   EXSR      SRDelReport
     C                   ELSE
     C                   EXSR      SRWriteMain
     C                   EXSR      SRListExcptn
     C                   ENDIF
 
     C                   EVAL      Ix = 0
     C                   EVAL      ArPoolType = *BLANKS
     C                   IF        WPoolActCt1 = 0
     C                             AND WDocRef1 <> *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArPoolType(Ix) = 'FATCA201'
     C                                            + WDocRef1
     C                   ENDIF
     C                   IF        WPoolActCt2 = 0
     C                             AND WDocRef2 <> *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArPoolType(Ix) = 'FATCA202'
     C                                            + WDocRef2
     C                   ENDIF
     C                   IF        WPoolActCt3 = 0
     C                             AND WDocRef3 <> *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArPoolType(Ix) = 'FATCA203'
     C                                            + WDocRef3
     C                   ENDIF
     C                   IF        WPoolActCt4 = 0
     C                             AND WDocRef4 <> *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArPoolType(Ix) = 'FATCA204'
     C                                            + WDocRef4
     C                   ENDIF
     C                   IF        WPoolActCt5 = 0
     C                             AND WDocRef5 <> *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArPoolType(Ix) = 'FATCA205'
     C                                            + WDocRef5
     C                   ENDIF
     C                   IF        WPoolActCt6 = 0
     C                             AND WDocRef6 <> *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArPoolType(Ix) = 'FATCA206'
     C                                            + WDocRef6
     C                   ENDIF
     C                   EXSR      SRVoidPool
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepExcPool2 - Report Pool with Excluded Customers           *
      *                                                               *
      *****************************************************************
     C     SRRepExcPool2 BEGSR
 
     C                   IF        ArPoolType(1) <> *BLANKS
 
     C                   EVAL      ArExPlDet = *BLANKS
     C                   MOVEA     ArExPlCust    ArExPlDet
     C                   EVAL      ArPoolDet = *BLANKS
     C                   MOVEA     ArPoolType    ArPoolDet
     C                   EVAL      Ix = 1
 
     C                   DOW       APoolTypD(Ix) <> *BLANKS
     C                             AND Ix < 50
     C                   EVAL      WDocRef1 = *BLANKS
     C                   EVAL      WDocRef2 = *BLANKS
     C                   EVAL      WDocRef3 = *BLANKS
     C                   EVAL      WDocRef4 = *BLANKS
     C                   EVAL      WDocRef5 = *BLANKS
     C                   EVAL      WDocRef6 = *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
 
      ** Report Account Holder selected for Amended
 
     C     PBrcd         SETLL     GLRMEXL0
     C     PBrcd         READE     GLRMEXL0
 
     C                   DOW       NOT %EOF(GLRMEXL0)
 
     C                   IF        EXFILE = 'FCAB'
     C                             OR EXFILE = 'CSBA'
     C                   EVAL      WLowDepAcc = 'N'
     C                   EXSR      SRChkLowDep
     C                   IF        WLowDepAcc = 'Y'
     C                   EVAL      KCust = EXCUSD
     C                   EVAL      KAcno = EXACNO
     C     KBrAcno1      SETGT     GLRMEXL0
     C     PBrcd         READE     GLRMEXL0
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** Check if customer is in the Exclude list
     C                   IF        %LOOKUP(EXCUSD:AExPlCus) = 0
 
     C                   IF        EXJANO = *BLANKS
     C                   EXSR      SRCustCheck
     C                   ELSE
 
     C                   EXSR      SRJaccCheck
     C                   ENDIF
     C                   IF        %LOOKUP(WRepTypPool:APoolTypD) <> 0
     C                             AND WRepTypPool <> *BLANKS
     C                             AND WReportPool = 'Y'
     C                   EXSR      SRCompPool
     C                   EXSR      SRPoolTotal
     C                   ENDIF
     C                   ELSE
     C                   EVAL      KCust = EXCUSD
     C     KBrCust0      SETGT     GLRMEXL0
     C                   ENDIF
 
     C     PBrcd         READE     GLRMEXL0
     C                   ENDDO
 
     C                   EVAL      EXCUSD = *BLANKS
     C                   IF        %LOOKUP(WPrRTypPool:APoolTypD) <> 0
     C                             AND %LOOKUP(WPoolCust:AExPlCus) = 0
     C                             AND WPrRTypPool <> *BLANKS
     C                             AND WPoolCust <> *BLANKS
     C                   EXSR      SRCompPool
 
     C                   SELECT
     C                   WHEN      WPrRTypPool = 'FATCA201'
     C                   EXSR      SRChkPoolSeq
     C                   EXSR      SRDelPoolRep
     C                   WHEN      WPrRTypPool = 'FATCA202'
     C                   EXSR      SRChkPoolSeq
     C                   EXSR      SRDelPoolRep
     C                   WHEN      WPrRTypPool = 'FATCA203'
     C                   EXSR      SRChkPoolSeq
     C                   EXSR      SRDelPoolRep
     C                   WHEN      WPrRTypPool = 'FATCA204'
     C                   EXSR      SRChkPoolSeq
     C                   EXSR      SRDelPoolRep
     C                   WHEN      WPrRTypPool = 'FATCA205'
     C                   EXSR      SRChkPoolSeq
     C                   EXSR      SRDelPoolRep
     C                   WHEN      WPrRTypPool = 'FATCA206'
     C                   EXSR      SRChkPoolSeq
     C                   EXSR      SRDelPoolRep
     C                   ENDSL
     C                   ENDIF
 
     C                   EXSR      SRReportPool
 
     C                   EVAL      Ix = 0
     C                   EVAL      ArPoolType = *BLANKS
     C                   IF        WPoolActCt1 = 0
     C                             AND WDocRef1 <> *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArPoolType(Ix) = 'FATCA201'
     C                                            + WDocRef1
     C                   ENDIF
     C                   IF        WPoolActCt2 = 0
     C                             AND WDocRef2 <> *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArPoolType(Ix) = 'FATCA202'
     C                                            + WDocRef2
     C                   ENDIF
     C                   IF        WPoolActCt3 = 0
     C                             AND WDocRef3 <> *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArPoolType(Ix) = 'FATCA203'
     C                                            + WDocRef3
     C                   ENDIF
     C                   IF        WPoolActCt4 = 0
     C                             AND WDocRef4 <> *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArPoolType(Ix) = 'FATCA204'
     C                                            + WDocRef4
     C                   ENDIF
     C                   IF        WPoolActCt5 = 0
     C                             AND WDocRef5 <> *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArPoolType(Ix) = 'FATCA205'
     C                                            + WDocRef5
     C                   ENDIF
     C                   IF        WPoolActCt6 = 0
     C                             AND WDocRef6 <> *BLANKS
     C                   EVAL      Ix = Ix + 1
     C                   EVAL      ArPoolType(Ix) = 'FATCA206'
     C                                            + WDocRef6
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelPoolRep - Delete the Pool Report Type to be Updated      *
      *                                                               *
      *****************************************************************
     C     SRDelPoolRep  BEGSR
 
     C                   EVAL      KMsgNo = WMsgId
     C                   EVAL      KTopMT = 'PoolReport'
     C                   EVAL      KMsgSeq = PRMsgSeq
 
      ** Delete detail File
     C     KDelPR        SETLL     GLRMDTLA
     C     KDelPR        READE     GLRMDTLA
 
     C                   DOW       NOT %EOF(GLRMDTLA)
     C                   DELETE    GLRMDTLA
     C     KDelPR        READE     GLRMDTLA
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkPoolSeq - Check the Sequence of the Pool Type            *
      *                                                               *
      *****************************************************************
     C     SRChkPoolSeq  BEGSR
 
     C                   EVAL      PRMsgSeq = *ZERO
     C                   EVAL      kMsgNo   = *BLANKS
     C                   EVAL      kMsgNo   = WMSGID
     C                   EVAL      KElemnam = 'PoolReport'
 
     C     KWarn         SETLL     GLRMDTL5
     C     KWarn         READE     GLRMDTL5
 
     C                   DOW       NOT %EOF(GLRMDTL5)
     C                   IF        D5_MGDATA = WPrRTypPool
     C                   EVAL      PRMsgSeq = D5_MGSEQU
     C                   ENDIF
     C     KWarn         READE     GLRMDTL5
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRepVoid - Report Draft Void report                          *
      *                                                               *
      *****************************************************************
     C     SRRepVoid     BEGSR
 
     C                   EVAL      ArAcctDet = *BLANKS
     C                   MOVEA     ArAcctNumbr   ArAcctDet
     C                   EVAL      Ix = 1
 
     C                   DOW       AAcctCust(Ix) <> *BLANKS
     C                             AND Ix < 50
 
     C                   EVAL      kMsgNo   = *BLANKS
     C                   EVAL      kMsgNo   = PMsId
     C                   EVAL      KEcus    = AAcctCust(Ix)
     C                   EVAL      KAcno    = AAcctNum(Ix)
     C                   EVAL      KAcho    = AAcctMem(Ix)
     C                   EVAL      KMTyp    = AAcctTyp(Ix)
 
     C     KVoid         SETLL     GLRMDTL4
     C     KVoid         READE     GLRMDTL4
 
     C                   DOW       NOT %EOF(GLRMDTL4)
 
     C                   EVAL      MGELMT = D4_MGELMT
     C                   SELECT
     C                   WHEN      MGELMT = 'DocTypeIndic'
     C                   EVAL      MGDATA = WDoctyp
     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      MGDATA = D4_MGDATA
     C                   EVAL      Iz = %SCAN('.':MGDATA) + 1
     C                   EVAL      %SUBST(MGDATA:Iz:6) = WMsgAcSq + WMsgDtyp
     C                                                   + WMsgActn
     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                   EVAL      MGDATA = AAcDocRf(Ix)
     C                   OTHER
     C                   EVAL      MGDATA = D4_MGDATA
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
 
     C     KVoid         READE     GLRMDTL4
     C                   ENDDO
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVoidPool - Process to report Void Pool                      *
      *                                                               *
      *****************************************************************
     C     SRVoidPool    BEGSR
 
      ** Void Pool Report
     C                   IF        ArPoolType(1) <> *BLANKS
     C                   EVAL      WRtype = 'DRAFT VOID'
     C                   EXSR      SRGenMsgID
     C                   EVAL      MGMSID = WMsgId
     C                   EXSR      SRRepHeader
     C                   EXSR      SRReportFI
     C                   EVAL      ArPoolDet = *BLANKS
     C                   MOVEA     ArPoolType    ArPoolDet
 
     C                   EVAL      kMsgNo   = *BLANKS
     C                   EVAL      kMsgNo   = PMsId
     C                   EVAL      KTpElt   = 'PoolReport'
 
     C     KVPool        SETLL     GLRMDTL0
     C     KVPool        READE     GLRMDTL0
 
     C                   DOW       NOT %EOF(GLRMDTL0)
 
      ** Check if element of the pool should be reported as VOID
 
     C                   SELECT
     C                   WHEN      D1_MGELMT = 'PoolListCust1'
     C                             AND %LOOKUP('FATCA201':APoolTypD) <> 0
     C                   EVAL      WVoid = 'Y'
     C                   WHEN      D1_MGELMT = 'PoolListCust1'
     C                             AND %LOOKUP('FATCA201':APoolTypD) = 0
     C                   EVAL      WVoid = 'N'
     C                   WHEN      D1_MGELMT = 'PoolListCust2'
     C                             AND %LOOKUP('FATCA202':APoolTypD) <> 0
     C                   EVAL      WVoid = 'Y'
     C                   WHEN      D1_MGELMT = 'PoolListCust2'
     C                             AND %LOOKUP('FATCA202':APoolTypD) = 0
     C                   EVAL      WVoid = 'N'
     C                   WHEN      D1_MGELMT = 'PoolListCust3'
     C                             AND %LOOKUP('FATCA203':APoolTypD) <> 0
     C                   EVAL      WVoid = 'Y'
     C                   WHEN      D1_MGELMT = 'PoolListCust3'
     C                             AND %LOOKUP('FATCA203':APoolTypD) = 0
     C                   EVAL      WVoid = 'N'
     C                   WHEN      D1_MGELMT = 'PoolListCust4'
     C                             AND %LOOKUP('FATCA204':APoolTypD) <> 0
     C                   EVAL      WVoid = 'Y'
     C                   WHEN      D1_MGELMT = 'PoolListCust4'
     C                             AND %LOOKUP('FATCA204':APoolTypD) = 0
     C                   EVAL      WVoid = 'N'
     C                   WHEN      D1_MGELMT = 'PoolListCust5'
     C                             AND %LOOKUP('FATCA205':APoolTypD) <> 0
     C                   EVAL      WVoid = 'Y'
     C                   WHEN      D1_MGELMT = 'PoolListCust5'
     C                             AND %LOOKUP('FATCA205':APoolTypD) = 0
     C                   EVAL      WVoid = 'N'
     C                   WHEN      D1_MGELMT = 'PoolListCust6'
     C                             AND %LOOKUP('FATCA206':APoolTypD) <> 0
     C                   EVAL      WVoid = 'Y'
     C                   WHEN      D1_MGELMT = 'PoolListCust6'
     C                             AND %LOOKUP('FATCA206':APoolTypD) = 0
     C                   EVAL      WVoid = 'N'
     C                   WHEN      D1_MGELMT = 'PoolReport'
     C                             AND %LOOKUP(D1_MGDATA:APoolTypD) = 0
     C                   EVAL      WVoid = 'N'
     C                   WHEN      D1_MGELMT = 'PoolReport'
     C                             AND %LOOKUP(D1_MGDATA:APoolTypD) <> 0
     C                   EVAL      WVoid = 'Y'
     C                   EVAL      Iy = %LOOKUP(D1_MGDATA:APoolTypD)
     C                   ENDSL
 
     C                   IF        WVoid = 'Y'
     C                   EVAL      MGELMT = D1_MGELMT
     C                   EVAL      MGDATA = D1_MGDATA
     C                   SELECT
     C                   WHEN      MGELMT = 'DocTypeIndic'
     C                   EVAL      MGDATA = WDoctyp
     C                   WHEN      MGELMT = 'DocRefId'
     C                   EVAL      Iz = %SCAN('.':MGDATA) + 1
     C                   EVAL      %SUBST(MGDATA:Iz:6) = WMsgAcSq + WMsgDtyp
     C                                                   + WMsgActn
     C                   WHEN      MGELMT = 'CorrDocRefId'
     C                   EVAL      MGDATA = APoolDocRf(Iy)
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
 
     C     KVPool        READE     GLRMDTL0
     C                   ENDDO
     C                   EXSR      SRWriteMain
     C                   EXSR      SRListExcptn
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
 
     C                   EVAL      MGCUST = EXCUSD
     C                   EVAL      MGACNO = EXACNO
     C                   EVAL      WBALN  = 0
 
     C                   EVAL      KGroupNm = 'ReportingGroup'
     C                   EVAL      KElemNm  = 'AccountReport'
     C                   EXSR      SRGetGrpLevl
 
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
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGenMsgID - Generate Message Ref ID                          *
      *                                                               *
      *****************************************************************
     C     SRGenMsgID    BEGSR
 
      ** Determine Document Type and Action
     C                   EXSR      SRDetDocTyp
 
     C                   SELECT
     C                   WHEN      PActn = 'N'
 
     C                   EVAL      WMDate   = WWY1 + WWY2 + PBrcd + PCtry
     C                   EVAL      KMsgNo   = *BLANKS
     C                   EVAL      KMsgNo   = WMDate + '99999' + '.'
 
     C     KMsgNo        SETGT     GLRPMGL1
     C                   READP     GLRPMGL1
 
     C                   IF        %EOF(GLRPMGL1)
     C                             OR WMDate <> %SUBST(R1_GGMSID:1:9)
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
     C                             OR PActn = 'A'
     C                             OR PActn = 'C'
     C                             OR PActn = 'I'
     C                             OR PActn = 'X'
     C                             OR PActn = 'V'
     C                             OR PActn = 'O'
 
     C                   IF        PActn <> 'X'
     C                   MOVEL     PMsId         WMsgId
     C                   ENDIF
     C                   EVAL      KMsgNo = %SUBST(WMSgId:1:15) + '999ZZZ'
 
     C     KMsgNo        SETGT     GLRPMGL1
     C                   READP     GLRPMGL1
 
     C                   IF        %EOF(GLRPMGL1)
     C                             OR WMDate <> %SUBST(R1_GGMSID:1:9)
     C                             OR WMsgNo <> %SUBST(R1_GGMSID:10:5)
     C                   EVAL      WMsgSeq = 1
     C                   ELSE
     C                   EVAL      WMsgAcSq = %SUBST(R1_GGMSID:16:3)
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
     C                   WHEN      PActn = 'A'
     C                             OR PActn = 'O'
     C                             AND WRtype = 'DRAFT AMEND'
     C                   EVAL      WMsgActn = 'A '
     C                   WHEN      PActn = 'V'
     C                             AND WRtype = 'DRAFT VOID'
     C                             OR PActn = 'O'
     C                             AND WRtype = 'DRAFT VOID'
     C                   EVAL      WMsgActn = 'V '
     C                   WHEN      PActn = 'V'
     C                             AND WRtype = 'DRAFT VOID NEW'
     C                   EVAL      WMsgActn = 'VN'
     C                   ENDSL
 
     C                   OTHER
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCompPool - Compute details for Pool report                  *
      *                                                               *
      *****************************************************************
     C     SRCompPool    BEGSR
 
     C                   SELECT
     C                   WHEN      WPrRTypPool = 'FATCA201'
     C                             AND WPoolCust <> EXCUSD
     C                             AND WPoolCust <> *BLANKS
     C                   EVAL      WPoolActCt1 = WPoolActCt1 + 1
     C                   EVAL      WCount1 = WCount1 + 1
 
      ** Generate list if customer in the Pool once Value is filled up
     C                   EVAL      APoolCust1(WCount1) = WPoolCust
     C                   EVAL      APoolIndc1(WCount1) = WPoolIndc
     C                   EVAL      APoolAmt1(WCount1) = %CHAR(WPoolCusBal1)
     C                   EVAL      WPoolCusBal1 = 0
     C                   IF        WCount1 >= 7
     C                   EVAL      MGTPMT = 'PoolReport'
     C                   EVAL      MGCUST = *BLANKS
     C                   EVAL      MGACHO = *BLANKS
     C                   EVAL      MGMTYP = *BLANKS
     C                   EVAL      MGACNO = *BLANKS
     C                   EVAL      MGELMT = 'PoolListCust1'
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVEA     ArPoolDet1    MGDATA
     C                   EXSR      SRWrite
     C                   EVAL      WCount1 = 0
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVE      *BLANKS       ArPoolDet1
     C                   ENDIF
 
     C                   WHEN      WPrRTypPool = 'FATCA202'
     C                             AND WPoolCust <> EXCUSD
     C                             AND WPoolCust <> *BLANKS
     C                   EVAL      WPoolActCt2 = WPoolActCt2 + 1
     C                   EVAL      WCount2 = WCount2 + 1
 
      ** Generate list if customer in the Pool once Value is filled up
     C                   EVAL      APoolCust2(WCount2) = WPoolCust
     C                   EVAL      APoolIndc2(WCount2) = WPoolIndc
     C                   EVAL      APoolAmt2(WCount2) = %CHAR(WPoolCusBal2)
     C                   EVAL      WPoolCusBal2 = 0
     C                   IF        WCount2 >= 7
     C                   EVAL      MGTPMT = 'PoolReport'
     C                   EVAL      MGCUST = *BLANKS
     C                   EVAL      MGACNO = *BLANKS
     C                   EVAL      MGELMT = 'PoolListCust2'
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVEA     ArPoolDet2    MGDATA
     C                   EXSR      SRWrite
     C                   EVAL      WCount2 = 0
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVE      *BLANKS       ArPoolDet2
     C                   ENDIF
 
     C                   WHEN      WPrRTypPool = 'FATCA203'
     C                             AND WPoolCust <> EXCUSD
     C                             AND WPoolCust <> *BLANKS
     C                   EVAL      WPoolActCt3 = WPoolActCt3 + 1
     C                   EVAL      WCount3 = WCount3 + 1
 
      ** Generate list if customer in the Pool once Value is filled up
     C                   EVAL      APoolCust3(WCount3) = WPoolCust
     C                   EVAL      APoolIndc3(WCount3) = WPoolIndc
     C                   EVAL      APoolAmt3(WCount3) = %CHAR(WPoolCusBal3)
     C                   EVAL      WPoolCusBal3 = 0
     C                   IF        WCount3 >= 7
     C                   EVAL      MGTPMT = 'PoolReport'
     C                   EVAL      MGCUST = *BLANKS
     C                   EVAL      MGACNO = *BLANKS
     C                   EVAL      MGELMT = 'PoolListCust3'
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVEA     ArPoolDet3    MGDATA
     C                   EXSR      SRWrite
     C                   EVAL      WCount3 = 0
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVE      *BLANKS       ArPoolDet3
     C                   ENDIF
 
     C                   WHEN      WPrRTypPool = 'FATCA204'
     C                             AND WPoolCust <> EXCUSD
     C                             AND WPoolCust <> *BLANKS
     C                   EVAL      WPoolActCt4 = WPoolActCt4 + 1
     C                   EVAL      WCount4 = WCount4 + 1
 
      ** Generate list if customer in the Pool once Value is filled up
     C                   EVAL      APoolCust4(WCount4) = WPoolCust
     C                   EVAL      APoolIndc4(WCount4) = WPoolIndc
     C                   EVAL      APoolAmt4(WCount4) = %CHAR(WPoolCusBal4)
     C                   EVAL      WPoolCusBal4 = 0
     C                   IF        WCount4 >= 7
     C                   EVAL      MGTPMT = 'PoolReport'
     C                   EVAL      MGCUST = *BLANKS
     C                   EVAL      MGACNO = *BLANKS
     C                   EVAL      MGELMT = 'PoolListCust4'
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVEA     ArPoolDet4    MGDATA
     C                   EXSR      SRWrite
     C                   EVAL      WCount4 = 0
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVE      *BLANKS       ArPoolDet4
     C                   ENDIF
     C                   WHEN      WPrRTypPool = 'FATCA205'
     C                             AND WPoolCust <> EXCUSD
     C                             AND WPoolCust <> *BLANKS
     C                   EVAL      WPoolActCt5 = WPoolActCt5 + 1
     C                   EVAL      WCount5 = WCount5 + 1
 
      ** Generate list if customer in the Pool once Value is filled up
     C                   EVAL      APoolCust5(WCount5) = WPoolCust
     C                   EVAL      APoolIndc5(WCount5) = WPoolIndc
     C                   EVAL      APoolAmt5(WCount5) = %CHAR(WPoolCusBal5)
     C                   EVAL      WPoolCusBal5 = 0
     C                   IF        WCount5 >= 7
     C                   EVAL      MGTPMT = 'PoolReport'
     C                   EVAL      MGCUST = *BLANKS
     C                   EVAL      MGACNO = *BLANKS
     C                   EVAL      MGELMT = 'PoolListCust5'
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVEA     ArPoolDet5    MGDATA
     C                   EXSR      SRWrite
     C                   EVAL      WCount5 = 0
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVE      *BLANKS       ArPoolDet5
     C                   ENDIF
     C                   WHEN      WPrRTypPool = 'FATCA206'
     C                             AND WPoolCust <> EXCUSD
     C                             AND WPoolCust <> *BLANKS
     C                   EVAL      WPoolActCt6 = WPoolActCt6 + 1
     C                   EVAL      WCount6 = WCount6 + 1
 
      ** Generate list if customer in the Pool once Value is filled up
     C                   EVAL      APoolCust6(WCount6) = WPoolCust
     C                   EVAL      APoolIndc6(WCount6) = WPoolIndc
     C                   EVAL      APoolAmt6(WCount6) = %CHAR(WPoolCusBal6)
     C                   EVAL      WPoolCusBal6 = 0
     C                   IF        WCount5 >= 7
     C                   EVAL      MGTPMT = 'PoolReport'
     C                   EVAL      MGCUST = *BLANKS
     C                   EVAL      MGACNO = *BLANKS
     C                   EVAL      MGELMT = 'PoolListCust6'
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVEA     ArPoolDet6    MGDATA
     C                   EXSR      SRWrite
     C                   EVAL      WCount6 = 0
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVE      *BLANKS       ArPoolDet6
     C                   ENDIF
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPoolTotal- Compute details for Pool report                  *
      *                                                               *
      *****************************************************************
     C     SRPoolTotal   BEGSR
 
      ** Convert currency if currency is different from High Value Currency
      ** and Account Balance is not zero
 
     C                   IF        WRepTypPool = 'FATCA204'
     C                   IF        ZCCYO <> EXCCY
     C                             AND EXPSTA <> *ZERO
     C                   EVAL      Pcurr = EXCCY
     C                   EXSR      SRAccCurr
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZCCYI = EXCCY
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZAMTCI = EXPSTA
     C                   EXSR      SRCvtAmt
     C                   EVAL      WHighValAmt = ZAMTCO
     C                   ELSE
     C                   EVAL      WHighValAmt = EXPSTA
     C                   ENDIF
     C                   ELSE
     C                   IF        ZCCYO <> EXCCY
     C                             AND EXBALN <> *ZERO
     C                   EVAL      Pcurr = EXCCY
     C                   EXSR      SRAccCurr
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZCCYI = EXCCY
     C                   EVAL      ZCDPI = A6NBDP
     C                   IF        EXACSQ = 0
     C                   EVAL      ZAMTCI = EXBALN
     C                   ELSE
     C                   EVAL      ZAMTCI = EXBALN * -1
     C                   ENDIF
     C                   EXSR      SRCvtAmt
     C                   EVAL      WHighValAmt = ZAMTCO
     c                   ELSE
     C                   IF        EXACSQ = 0
     C                   EVAL      WHighValAmt = EXBALN
     C                   ELSE
     C                   EVAL      WHighValAmt = EXBALN * -1
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WPoolCcy = SVal1
     C                   EVAL      WPoolCust = EXCUSD
     C                   EVAL      WPoolIndc = %SUBST(EXACTY:1:1)
     C                   EVAL      WPrRTypPool  = WRepTypPool
 
      ** Accumulate Pool Balance for Pool reporting
     C                   SELECT
     C                   WHEN      WRepTypPool = 'FATCA201'
     C                   EVAL      WPoolCusBal1 = WPoolCusBal1 + WHighValAmt
     C                   EVAL      WPoolBal1 = WPoolBal1 + WHighValAmt
     C                   WHEN      WRepTypPool = 'FATCA202'
     C                   EVAL      WPoolCusBal2 = WPoolCusBal2 + WHighValAmt
     C                   EVAL      WPoolBal2 = WPoolBal2 + WHighValAmt
     C                   WHEN      WRepTypPool = 'FATCA203'
     C                   EVAL      WPoolCusBal3 = WPoolCusBal3 + WHighValAmt
     C                   EVAL      WPoolBal3 = WPoolBal3 + WHighValAmt
     C                   WHEN      WRepTypPool = 'FATCA204'
     C                   EVAL      WPoolCusBal4 = WPoolCusBal4 + WHighValAmt
     C                   EVAL      WPoolBal4 = WPoolBal4 + WHighValAmt
     C                   WHEN      WRepTypPool = 'FATCA205'
     C                   EVAL      WPoolCusBal5 = WPoolCusBal5 + WHighValAmt
     C                   EVAL      WPoolBal5 = WPoolBal5 + WHighValAmt
     C                   WHEN      WRepTypPool = 'FATCA206'
     C                   EVAL      WPoolCusBal6 = WPoolCusBal6 + WHighValAmt
     C                   EVAL      WPoolBal6 = WPoolBal6 + WHighValAmt
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReportPool- Report Pool Details                             *
      *                                                               *
      *****************************************************************
     C     SRReportPool  BEGSR
 
     C                   EVAL      MGSEQU = 0
     C                   IF        WPoolActCt1 > 0
     C                   EVAL      WPoolBal = WPoolBal1
     C                   MOVEA     ArPoolDet1    WPoolDet
     C                   EVAL      WPoolActCnt = WPoolActCt1
     C                   EVAL      WRepTypPool = 'FATCA201'
     C                   EVAL      WPoolEltTyp = 'PoolListCust1'
     C                   EVAL      WCount = WCount1
     C                   EVAL      WPoolCorDrf = WDocRef1
     C                   EXSR      SRWrRepPool
     C                   ENDIF
 
     C                   IF        WPoolActCt2 > 0
     C                   IF        PActn = 'O'
     C                             AND PRtype = 'DRAFT NEW'
     C                   EVAL      MGSEQU = PRMsgSeq
     C                   ENDIF
     C                   EVAL      WPoolBal = WPoolBal2
     C                   MOVEA     ArPoolDet2    WPoolDet
     C                   EVAL      WPoolActCnt = WPoolActCt2
     C                   EVAL      WRepTypPool = 'FATCA202'
     C                   EVAL      WPoolEltTyp = 'PoolListCust2'
     C                   EVAL      WCount = WCount2
     C                   EVAL      WPoolCorDrf = WDocRef2
     C                   EXSR      SRWrRepPool
     C                   ENDIF
 
     C                   IF        WPoolActCt3 > 0
     C                   IF        PActn = 'O'
     C                             AND PRtype = 'DRAFT NEW'
     C                   EVAL      MGSEQU = PRMsgSeq
     C                   ENDIF
     C                   EVAL      WPoolBal = WPoolBal3
     C                   MOVEA     ArPoolDet3    WPoolDet
     C                   EVAL      WPoolActCnt = WPoolActCt3
     C                   EVAL      WRepTypPool = 'FATCA203'
     C                   EVAL      WPoolEltTyp = 'PoolListCust3'
     C                   EVAL      WCount = WCount3
     C                   EVAL      WPoolCorDrf = WDocRef3
     C                   EXSR      SRWrRepPool
     C                   ENDIF
 
     C                   IF        WPoolActCt4 > 0
     C                   IF        PActn = 'O'
     C                             AND PRtype = 'DRAFT NEW'
     C                   EVAL      MGSEQU = PRMsgSeq
     C                   ENDIF
     C                   EVAL      WPoolBal = WPoolBal4
     C                   MOVEA     ArPoolDet4    WPoolDet
     C                   EVAL      WPoolActCnt = WPoolActCt4
     C                   EVAL      WRepTypPool = 'FATCA204'
     C                   EVAL      WPoolEltTyp = 'PoolListCust4'
     C                   EVAL      WCount = WCount4
     C                   EVAL      WPoolCorDrf = WDocRef4
     C                   EXSR      SRWrRepPool
     C                   ENDIF
 
     C                   IF        WPoolActCt5 > 0
     C                   IF        PActn = 'O'
     C                             AND PRtype = 'DRAFT NEW'
     C                   EVAL      MGSEQU = PRMsgSeq
     C                   ENDIF
     C                   EVAL      WPoolBal = WPoolBal5
     C                   MOVEA     ArPoolDet5    WPoolDet
     C                   EVAL      WPoolActCnt = WPoolActCt5
     C                   EVAL      WRepTypPool = 'FATCA205'
     C                   EVAL      WPoolEltTyp = 'PoolListCust5'
     C                   EVAL      WCount = WCount5
     C                   EVAL      WPoolCorDrf = WDocRef5
     C                   EXSR      SRWrRepPool
     C                   ENDIF
 
     C                   IF        WPoolActCt6 > 0
     C                   IF        PActn = 'O'
     C                             AND PRtype = 'DRAFT NEW'
     C                   EVAL      MGSEQU = PRMsgSeq
     C                   ENDIF
     C                   EVAL      WPoolBal = WPoolBal6
     C                   MOVEA     ArPoolDet6    WPoolDet
     C                   EVAL      WPoolActCnt = WPoolActCt6
     C                   EVAL      WRepTypPool = 'FATCA206'
     C                   EVAL      WPoolEltTyp = 'PoolListCust6'
     C                   EVAL      WCount = WCount6
     C                   EVAL      WPoolCorDrf = WDocRef6
     C                   EXSR      SRWrRepPool
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrRepPool - Report Pool Details                             *
      *                                                               *
      *****************************************************************
     C     SRWrRepPool   BEGSR
 
     C                   EVAL      MGSEQU = MGSEQU + 1
     C                   EVAL      MGSEQ2 = 1
 
     C                   EVAL      MGCUST = *BLANKS
     C                   EVAL      MGACHO = *BLANKS
     C                   EVAL      MGMTYP = *BLANKS
     C                   EVAL      MGACNO = '999999999999999'
     C                   EVAL      MGTPMT = 'PoolReport'
     C                   EVAL      KGroupNm = 'ReportingGroup'
     C                   EVAL      KElemNm  = MGTPMT
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGELMT = 'PoolReport'
     C                   EVAL      MGDATA = WRepTypPool
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'AccountPoolReportType'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      MGDATA = WRepTypPool
     C                   EVAL      WPoolDocRef = MGDATA
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'AccountCount'
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVEL     WPoolActCnt   MGDATA
     C                   EXSR      SRWrite
 
     C                   IF        WCount > 0
     C                   EVAL      MGELMT = WPoolEltTyp
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      MGDATA = WPoolDet
     C                   EXSR      SRWrite
     C                   ENDIF
 
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      MGELMT = 'PoolBalance'
     C                   EVAL      MGDATA = %CHAR(WPoolBal)
     C                   EVAL      MGDAT2 = WPoolCcy
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
      ** If non account reported for Pool, do not generate Ref ID
 
     C                   IF        WPoolActCnt > 0
     C                   EVAL      MGTPMT = 'PoolReport'
     C                   EVAL      KGroupNm = MGTPMT
     C                   EVAL      KElemNm  = 'DocSpec'
     C                   EXSR      SRGetGrpLevl
 
     C                   EVAL      MGELMT = 'DocTypeIndic'
     C                   EVAL      MGDATA = WDoctyp
     C                   EXSR      SRWrite
 
     C                   EVAL      WDocRefPl = WDocRefPl + 1
     C                   MOVEL     WDocRefPl     WSEQ
     C                   EVAL      MGELMT = 'DocRefId'
     C                   EVAL      MGDATA = %TRIM(WPoolDocRef)
     C                                      + '.' + WMsgAcSq + WMsgDtyp
     C                                      + WMsgActn
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'CorrDocRefId'
     C                   EVAL      MGDATA = WPoolCorDrf
     C                   EXSR      SRWrite
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSubOwner - Report Substantial Owners for the Account Holder *
      *                                                               *
      *****************************************************************
     C     SRSubOwner    BEGSR
 
     C                   EVAL      IdxB = 0
     C                   EVAL      IxSubOwn = 1000
     C                   IF        EXJANO = *BLANKS
     C                   EVAL      XCust = EXCUSD
     C     XCust         SETLL     SDJACCL0
     C     XCust         READE     SDJACCL0
 
     C                   DOW       NOT %EOF(SDJACCL0)
 
     C                   IF        JCCUST <> *BLANKS                                        MD043144
     C                   EVAL      PSub10 = JCCUST                                          MD043144
     C                   ELSE                                                               MD043144
     C                   EVAL      PSub10 = JCNAHO                                          MD043144
     C                   ENDIF                                                              MD043144
     C                   EVAL      WJHasSubOwnr = 'N'
     C                   EVAL      WCuahFlg = ' '                                           MD043144
     C                   EXSR      SRChkSubCat
     C                   IF        WJHasSubOwnr <> 'Y'
     C     XCust         READE     SDJACCL0
     C                   ITER
     C                   ENDIF
 
     C                   EVAL      IxSubOwn =IxSubOwn + 1
     C                   EVAL      MGSEQU =  IxSubOwn
     C
     C                   EVAL      MGCUST = EXCUSD
     C                   EVAL      MGACHO = EXCUSD
     C                   EVAL      MGMTYP = 'CUST'
     C                   EVAL      MGACNO = EXACNO
 
     C                   EVAL      MGELMT = 'SubstantialOwner'
     C                   EVAL      MGDATA = *BLANKS
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = MGELMT
     C                   EXSR      SRGetGrpLevl
     C                   EXSR      SRWrite
 
     C                   EVAL      MGTPMT = 'SubstantialOwner'
 
     C                   EVAL      MGLEVL = 0
 
     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      MGDATA = EXACNO
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'SubstantialUSOwner'
     C                   IF        JCCUST <> *BLANK
     C                   EVAL      MGDATA = JCCUST
     C                   EXSR      SRWrite
 
     C                   EVAL      PCUST  = JCCUST
     C                   EXSR      SRAccCust
     C                   EVAL      PAcus  = JCCUST
     C                   EXSR      SRAccAcus
 
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'SubstantialOwner'
     C                   EXSR      SRGetGrpLevl
 
     C                   EVAL      FCust  = JCCUST
     C                   EXSR      SRFTCSDet
     C                   EXSR      SRWrCusDetail
 
     C                   EVAL      KGroupNm = 'SubstantialOwner'
     C                   EVAL      KElemNm  = 'BirthInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'SubstantialOwner'
 
     C                   EVAL      MGELMT = 'BirthDate'
     C                   EVAL      MGDATA = E5DBTH
     C                   EXSR      SRWrite
 
     C                   ELSE
 
     C                   EVAL      MGDATA = JCNAHO
     C                   EXSR      SRWrite
 
      ** Get Non-Account Holder Details of the Joint Account Member
 
     C                   EVAL      PNAHO  = JCNAHO
     C                   EXSR      SRAccNaho
 
      ** Get FATCA Non-Account Holder Details of the Joint Account Member
 
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'SubstantialOwner'
     C                   EXSR      SRGetGrpLevl
 
     C                   EVAL      KNAHO  = JCNAHO
     C                   EXSR      SRFTNHDet
     C                   EXSR      SRWrNahDetail
 
     C                   EVAL      KGroupNm = 'SubstantialOwner'
     C                   EVAL      KElemNm  = 'BirthInfo'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'SubstantialOwner'
 
     C                   EVAL      MGELMT = 'BirthDate'
     C                   EVAL      MGDATA = *BLANKS
     C                   MOVEL     NHDBTH        MGDATA
     C                   EXSR      SRWrite
     C                   ENDIF
 
     C     XCust         READE     SDJACCL0
     C                   ENDDO
 
     C                   ENDIF
     C                   EVAL      MGSEQ2 = 0
 
     C                   IF        EXJANO = *BLANKS                                         MD043144
     C                   EVAL      XCust = EXCUSD                                           MD043144
                                                                                            MD043144
      ** Authority Holders                                                                  MD043144
     C     XCust         SETLL     SDCUAHL0                                                 MD043144
     C     XCust         READE     SDCUAHL0                                                 MD043144
                                                                                            MD043144
     C                   DOW       NOT %EOF(SDCUAHL0)                                       MD043144
                                                                                            MD043144
     C                   IF        CAPCNT <> *Blanks                                        MD043144
     C                   MOVE      CAPCNT        WNUM3                                      MD043144
     C                   IF        WNUM3 <> *ZERO                                           MD043144
     C                   EVAL      IxSubOwn =IxSubOwn + 1                                   MD043144
     C                   EVAL      MGSEQU =  IxSubOwn                                       MD043144
     C                                                                                      MD043144
     C                   EVAL      MGCUST = EXCUSD                                          MD043144
     C                   EVAL      MGACHO = EXCUSD                                          MD043144
     C                   EVAL      MGMTYP = 'CUST'                                          MD043144
     C                   EVAL      MGACNO = EXACNO                                          MD043144
                                                                                            MD043144
     C                   EVAL      MGELMT = 'SubstantialOwner'                              MD043144
     C                   EVAL      MGDATA = *BLANKS                                         MD043144
     C                   EVAL      MGTPMT = *BLANKS                                         MD043144
     C                   EVAL      KGroupNm = 'AccountReport'                               MD043144
     C                   EVAL      KElemNm  = MGELMT                                        MD043144
     C                   EXSR      SRGetGrpLevl                                             MD043144
     C                   EXSR      SRWrite                                                  MD043144
                                                                                            MD043144
     C                   EVAL      MGTPMT = 'SubstantialOwner'                              MD043144
     C                   EVAL      MGLEVL = 0                                               MD043144
                                                                                            MD043144
     C                   EVAL      MGELMT = 'AccountNumber'                                 MD043144
     C                   EVAL      MGDATA = EXACNO                                          MD043144
     C                   EXSR      SRWrite                                                  MD043144
                                                                                            MD043144
     C                   EVAL      MGELMT = 'SubstantialUSOwner'                            MD043144
                                                                                            MD043144
     C                   EVAL      PCuah  = CAAUTH                                          MD043144
     C                   CALL      'AOCUSTR0'                                               MD043144
     C                   PARM      *BLANKS       PRtCd                                      MD043144
     C                   PARM      '*KEY'        POptn                                      MD043144
     C                   PARM                    PCuah                                      MD043144
     C                   PARM      *BLANKS       PCNST                                      MD043144
     C     SDCUST        PARM      SDCUST        DSSDY                                      MD043144
      *                                                                                     MD043144
     C                   IF        PRtCd = *BLANKS                                          MD043144
     C                   EVAL      PAcus  = PCuah                                           MD043144
     C                   EXSR      SRAccAcus                                                MD043144
                                                                                            MD043144
     C                   EVAL      KGroupNm = 'AccountReport'                               MD043144
     C                   EVAL      KElemNm  = 'SubstantialOwner'                            MD043144
     C                   EXSR      SRGetGrpLevl                                             MD043144
                                                                                            MD043144
     C                   EVAL      FCust  = PCuah                                           MD043144
     C                   EXSR      SRFTCSDet                                                MD043144
     C                   EXSR      SRWrCusDetail                                            MD043144
                                                                                            MD043144
     C                   EVAL      KGroupNm = 'SubstantialOwner'                            MD043144
     C                   EVAL      KElemNm  = 'BirthInfo'                                   MD043144
     C                   EXSR      SRGetGrpLevl                                             MD043144
     C                   EVAL      MGTPMT = *BLANKS                                         MD043144
     C                   EVAL      MGELMT = KElemNm                                         MD043144
     C                   EVAL      MGDATA = *BLANKS                                         MD043144
     C                   EXSR      SRWrite                                                  MD043144
     C                   EVAL      MGTPMT = 'SubstantialOwner'                              MD043144
                                                                                            MD043144
     C                   EVAL      MGELMT = 'BirthDate'                                     MD043144
     C                   EVAL      MGDATA = E5DBTH                                          MD043144
     C                   EXSR      SRWrite                                                  MD043144
                                                                                            MD043144
     C                   ELSE                                                               MD043144
      *                                                                                     MD043144
      ** Check if it is a valid Non - Account Holder                                        MD043144
      *                                                                                     MD043144
     C                   CALL      'AONAHOR0'                                               MD043144
     C                   PARM      *BLANKS       PRtCd                                      MD043144
     C                   PARM      '*KEY'        POptn                                      MD043144
     C                   PARM                    PCuah                                      MD043144
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      MD043144
      *                                                                                     MD043144
     C                   IF        PRtCd = *BLANKS                                          MD043144
     C                   EVAL      MGDATA = PCuah                                           MD043144
     C                   EXSR      SRWrite                                                  MD043144
                                                                                            MD043144
     C                   EVAL      KGroupNm = 'AccountReport'                               MD043144
     C                   EVAL      KElemNm  = 'SubstantialOwner'                            MD043144
     C                   EXSR      SRGetGrpLevl                                             MD043144
                                                                                            MD043144
     C                   EVAL      KNAHO  = PCuah                                           MD043144
     C                   EXSR      SRFTNHDet                                                MD043144
     C                   EXSR      SRWrNahDetail                                            MD043144
                                                                                            MD043144
     C                   EVAL      KGroupNm = 'SubstantialOwner'                            MD043144
     C                   EVAL      KElemNm  = 'BirthInfo'                                   MD043144
     C                   EXSR      SRGetGrpLevl                                             MD043144
     C                   EVAL      MGTPMT = *BLANKS                                         MD043144
     C                   EVAL      MGELMT = KElemNm                                         MD043144
     C                   EVAL      MGDATA = *BLANKS                                         MD043144
     C                   EXSR      SRWrite                                                  MD043144
     C                   EVAL      MGTPMT = 'SubstantialOwner'                              MD043144
                                                                                            MD043144
     C                   EVAL      MGELMT = 'BirthDate'                                     MD043144
     C                   EVAL      MGDATA = *BLANKS                                         MD043144
     C                   MOVEL     NHDBTH        MGDATA                                     MD043144
     C                   EXSR      SRWrite                                                  MD043144
     C                   ENDIF                                                              MD043144
                                                                                            MD043144
     C                   ENDIF                                                              MD043144
                                                                                            MD043144
     C                   ENDIF                                                              MD043144
     C                   ENDIF                                                              MD043144
     C     XCust         READE     SDCUAHL0                                                 MD043144
     C                   ENDDO                                                              MD043144
                                                                                            MD043144
     C                   EVAL      MGSEQ2 = 0                                               MD043144
     C                   ENDIF                                                              MD043144
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCompPaymt - Compute Payment DEtails for Reporting           *
      *                                                               *
      *****************************************************************
     C     SRCompPaymt   BEGSR
 
      ** Check if Currency has change or Payment Type changed, write to report
      ** Check if payments for the Account in FCAB and CSBA
 
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'Payment'
     C                   EXSR      SRGetGrpLevl
     C                   EVAL      IdxC = IdxC + 1
     C                   EVAL      MGSEQ2 = IdxC
 
     C                   IF        EXACNO = WPrevAcno
 
      ** Aggregate by Payment Type and Currency
 
     C                   IF        EXPAYT <> WPrevPAYT
     C                             AND WPrevPAYT <> *BLANKS
     C                             OR  EXCCY <> WPrevCCY
     C                             AND WPrevCCY <> *BLANKS
     C                             OR  EXACNO <> WPrevACNO
     C                             AND WPrevACNO <> *BLANKS
     C                   IF        WPayTotCcy <> 0
     C                   EVAL      IxPayment = IxPayment + 1
 
     C                   EVAL      MGCUST = WPrevCUSD
     C                   EVAL      MGACHO = WPrevCUSD
     C                   EVAL      MGMTYP = WPrevACTY
     C                   EVAL      MGACNO = WPrevACNO
     C                   EVAL      MGTPMT = 'Payment'
 
     C                   EVAL      MGELMT = 'AcctHolder'
     C                   EVAL      MGDATA = WPrevCUSD
     C                   EVAL      MGDAT2 = WPrevACTY
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EXSR      SRWrPaytDet
 
      ** Initialise work field for next record processing
     C                   EVAL      WPayTotCcy = 0
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
     C                   IF        WPrevPAYT <> *BLANKS
     C                             AND WPayTotCcy <> 0
     C                             AND (WPrevRepIn = 'Y'
     C                             OR WPrevRepJn = 'Y')
     C                   EVAL      IxPayment = IxPayment + 1
     C                   EVAL      MGCUST = WPrevCUSD
     C                   EVAL      MGACHO = WPrevCUSD
     C                   EVAL      MGMTYP = WPrevACTY
     C                   EVAL      MGACNO = WPrevACNO
     C                   EVAL      MGTPMT = 'Payment'
 
     C                   EVAL      MGELMT = 'AcctHolder'
     C                   EVAL      MGDATA = WPrevCUSD
     C                   EVAL      MGDAT2 = WPrevACTY
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EXSR      SRWrPaytDet
 
     C                   ENDIF
     C                   EVAL      WPayTotCcy = 0
     C                   ENDIF
 
     C                   EVAL      WPayTotCcy = WPayTotCcy + EXPSTA
 
      ** Save previous details
     C                   EVAL      WPrevCUSD = EXCUSD
     C                   EVAL      WPrevACNO = EXACNO
     C                   EVAL      WPrevPAYT = EXPAYT
     C                   EVAL      WPrevCCY = EXCCY
     C                   EVAL      WPrevACTY = EXACTY
     C                   EVAL      WPrevRepIn = WReportInd
     C                   EVAL      WPrevRepJn = WReportJnt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrPaytDet - Write Payment Details                           *
      *                                                               *
      *****************************************************************
     C     SRWrPaytDet   BEGSR
 
     C                   EVAL      MGSEQU = IxPayment
     C                   EVAL      MGTPMT = *BLANKS
     C                   EVAL      MGELMT = KElemNm
     C                   EVAL      MGDATA = *BLANKS
     C                   EXSR      SRWrite
     C                   EVAL      MGTPMT = 'Payment'
     C                   EVAL      MGELMT = 'Type'
     C                   SELECT
     C                   WHEN      WPrevPAYT = 'D'
     C                   EVAL      MGDATA = 'FATCA501'
     C                   WHEN      WPrevPAYT = 'I'
     C                   EVAL      MGDATA = 'FATCA502'
     C                   WHEN      WPrevPAYT = 'G'
     C                   EVAL      MGDATA = 'FATCA503'
     C                   OTHER
     C                   EVAL      MGDATA = 'FATCA504'
     C                   ENDSL
     C                   EXSR      SRWrite
 
     C                   EVAL      MGELMT = 'PaymentAmnt'
     C                   EVAL      MGDATA = %CHAR(WPayTotCcy)
     C                   EVAL      MGDAT2 = WPrevCCY
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EVAL      MGELMT = 'AccountNumber'
     C                   EVAL      MGDATA = WPrevACNO
     C                   EXSR      SRWrite
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRComPayJac - Report Payments for Joint Account members       *
      *                                                               *
      *****************************************************************
     C     SRComPayJac   BEGSR
 
     C                   EVAL      KGroupNm = 'AccountReport'
     C                   EVAL      KElemNm  = 'Payment'
     C                   EXSR      SRGetGrpLevl
 
     C                   IF        EXACNO = WPrevAcno
 
      ** Aggregate by Payment Type and Currency
 
     C                   IF        EXPAYT <> WPrevPAYT
     C                             AND WPrevPAYT <> *BLANKS
     C                             OR  EXCCY <> WPrevCCY
     C                             AND WPrevCCY <> *BLANKS
     C                             OR  EXACNO <> WPrevACNO
     C                             AND WPrevACNO <> *BLANKS
     C                   IF        WPayTotCcy <> 0
     C                   EVAL      IxPayment = IxPayment + 1
 
      ** Check if Joint account member should be reported
     C                   IF        WJReportInd = 'N'
     C                   ENDIF
 
     C                   EVAL      MGCUST = WPrevCUSD
     C                   EVAL      MGACNO = WPrevACNO
     C                   EVAL      MGTPMT = 'Payment'
     C                   EVAL      MGACHO = WPrevCUSD
     C                   EVAL      MGMTYP = WPrevACTY
     C                   EVAL      MGDATA = WPrevCUSD
     C                   EVAL      MGDAT2 = WPrevACTY
     C                   EVAL      IdxC = IdxC + 1
     C                   EVAL      MGSEQ2 = IdxC
     C                   EVAL      MGELMT = 'AcctHolder'
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EXSR      SRWrPaytDet
 
     C                   EVAL      WPayTotCcy = 0
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
 
     C                   IF        WPrevPAYT <> *BLANKS
     C                             AND WPayTotCcy <> 0
     C                             AND (WPrevRepIn = 'Y'
     C                             OR WPrevRepJn = 'Y')
     C                   EVAL      IxPayment = IxPayment + 1
     C                   IF        WJReportInd = 'N'
     C                   ENDIF
 
     C                   EVAL      MGCUST = WPrevCUSD
     C                   EVAL      MGACNO = WPrevACNO
     C                   EVAL      MGTPMT = 'Payment'
 
     C                   EVAL      MGACHO = WPrevCUSD
     C                   EVAL      MGMTYP = WPrevACTY
     C                   EVAL      MGDATA = WPrevCUSD
     C                   EVAL      MGDAT2 = WPrevACTY
     C                   EVAL      IdxC = IdxC + 1
     C                   EVAL      MGSEQ2 = IdxC
     C                   EVAL      MGELMT = 'AcctHolder'
     C                   EXSR      SRWrite
     C                   EVAL      MGDAT2 = *BLANKS
 
     C                   EXSR      SRWrPaytDet
 
     C                   ENDIF
     C                   EVAL      WPayTotCcy = 0
     C                   ENDIF
 
     C                   EVAL      WPayTotCcy = WPayTotCcy + EXPSTA
 
     C                   EVAL      WPrevCUSD = EXCUSD
     C                   EVAL      WPrevACNO = EXACNO
     C                   EVAL      WPrevPAYT = EXPAYT
     C                   EVAL      WPrevCCY = EXCCY
     C                   EVAL      WPrevACTY = EXACTY
     C                   EVAL      WPrevRepIn = WReportInd
     C                   EVAL      WPrevRepJn = WReportJnt
 
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
 
     C     *LOVAL        SETLL     SDFTCSL6
     C                   READ      SDFTCSL6
     C                   DOW       NOT %EOF(SDFTCSL6)
     C                   EVAL      WReportInd = 'N'
     C                   EVAL      WReportPool = 'N'
     C                   EVAL      WReportJnt  = 'N'
 
     C                   EVAL      KCust  = S_FACUST
     C     KBrCust0      CHAIN     GLRMEXL1
     C                   IF        %FOUND(GLRMEXL1)
     C                   EVAL      WCust  = *BLANKS
     C                   EXSR      SRCustCheck
     C                   ENDIF
     C                   IF        WReportInd = 'Y'
     C                             OR WReportPool = 'Y'
     C                             OR WReportJnt  = 'Y'
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = S_FACUST
     C                   EVAL      IEINEX = *BLANKS
     C                   EVAL      IECNFL = 'C'
     C                   EVAL      IERMRK = *BLANKS
     C                   EVAL      IEUSER = *BLANKS
     C                   EVAL      IETMST = *BLANKS
 
     C                   WRITE     GLRMIED0
     C                   ENDIF
 
     C                   READ      SDFTCSL6
     C                   ENDDO
 
     C     *LOVAL        SETLL     SDFTNHL6
     C                   READ      SDFTNHL6
 
     C                   DOW       NOT %EOF(SDFTNHL6)
 
     C                   EVAL      PKEY1 = N_FNNAHO
     C                   IF        PKEY1 <> *BLANKS
     C                   CALL      'AONAHOR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PKEY1
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      MD044368
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      MD044368
 
     C                   IF        PRTCD = '*NRF'
     C                             OR NHCHTP = 'D'
     C                   READ      SDFTNHL6
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WReportJnt  = 'N'
     C                   EVAL      WJReportInd = 'N'
     C                   EVAL      WJReportPl = 'N'
 
     C     N_FNNAHO      SETLL     SDJACCL7
     C     N_FNNAHO      READE     SDJACCL7
     C                   DOW       NOT %EOF(SDJACCL7)
      ** Check NAHO member if also for reporting
     C     J_JCJANO      CHAIN     SDFTCSL0
     C                   IF        %FOUND(SDFTCSL0)
     C                   IF        FACSTY = 'J'
     C                             AND (FAINFC = 'Y' OR FAINFC = 'A')
     C                             AND FAREPT = 'Y'
     C                             AND FAEXEM <> 'Y'
     C                             AND (FAHVAC = 'H' OR FAHVAC = 'M')
     C                   EVAL      WReportJnt  = 'Y'
     C                   ENDIF
     C                   ENDIF
     C                   IF        WReportJnt  = 'Y'
     C                   EVAL      KNAHO  = J_JCNAHO
     C                   EXSR      SRFTNHDet
     C                   EVAL      PNaho = J_JCNAHO
     C                   EXSR      SRAccNaho
     C                   EVAL      WCust = J_JCNAHO
     C                   EXSR      SRChkIndFTNH
     C                   EXSR      SRChkTINNH
     C                   EVAL      WJReportInd = 'N'
     C                   EVAL      WJReportPl = 'N'
     C                   EVAL      WkCSTY = FNNHTY
     C                   EVAL      WkCSST = FNNHST
     C                   EVAL      WkINFC = FNINFC
     C                   EVAL      WkRPTT = FNRPTT
     C                   EVAL      WkHVAC = FNHVAC
     C                   EVAL      WkEXEM = FNEXEM
     C                   EVAL      WkREPT = FNREPT
 
      ** Check Member if to report based on Agreement Type
     C                   EVAL      PCode = NHCOLC
     C                   EXSR      SRAccCountry
     C                   EXSR      SRChkAgrType
 
     C     WModel        CASEQ     'Model1'      SrJModel1
     C     WModel        CASEQ     'Model2'      SrJModel2
     C     WModel        CASEQ     'NONIGA'      SrJNONIGA
     C                   ENDCS
     C                   IF        WJReportInd = 'Y'
     C                             OR WJReportPl = 'Y'
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C     N_FNNAHO      READE     SDJACCL7
     C                   ENDDO
     C                   IF        WReportJnt  = 'Y'
     C                             AND WJReportInd = 'Y'
     C                             OR WReportJnt  = 'Y'
     C                             AND WJReportPl = 'Y'
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = N_FNNAHO
     C                   EVAL      IEINEX = *BLANKS
     C                   EVAL      IECNFL = 'N'
     C                   EVAL      IERMRK = *BLANKS
     C                   EVAL      IEUSER = *BLANKS
     C                   EVAL      IETMST = *BLANKS
 
     C                   WRITE     GLRMIED0
     C                   ENDIF
 
     C                   READ      SDFTNHL6
     C                   ENDDO
 
     C                   WHEN      PActn = 'I'
 
     C     PMSID         SETLL     GLRMIEL0
     C     PMSID         READE     GLRMIEL0
 
     C                   DOW       NOT %EOF(GLRMIEL0)
     C                   EVAL      WField = IE_IECNFL+IE_IECREF
     C                   IF        %LOOKUP(WField:AInclude) = 0
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = IE_IECREF
     C                   EVAL      IEINEX = IE_IEINEX
     C                   EVAL      IECNFL = IE_IECNFL
     C                   EVAL      IERMRK = IE_IERMRK
     C                   EVAL      IEUSER = IE_IEUSER
     C                   EVAL      IETMST = IE_IETMST
 
     C                   WRITE     GLRMIED0
     C                   ELSE
     C                   EVAL      Iz = %LOOKUP(WField:AInclude)
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = IE_IECREF
     C                   EVAL      IEINEX = 'I'
     C                   EVAL      IECNFL = IE_IECNFL
     C                   EVAL      IERMRK = AInclMIR(Iz)
     C                   EVAL      IEUSER = PSUSER
     C                   EVAL      IETMST = WTMST
 
     C                   WRITE     GLRMIED0
     C                   ENDIF
 
     C     PMSID         READE     GLRMIEL0
     C                   ENDDO
 
     C                   WHEN      PActn = 'O'
     C     PMSID         SETLL     GLRMIEL0
     C     PMSID         READE     GLRMIEL0
     C                   DOW       NOT %EOF(GLRMIEL0)
     C                   IF        %LOOKUP(IE_IECREF:AExcMemb) = 0
     C                             AND %LOOKUP(IE_IECREF:AExPlCus) = 0
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = IE_IECREF
     C                   EVAL      IEINEX = IE_IEINEX
     C                   EVAL      IECNFL = IE_IECNFL
     C                   EVAL      IERMRK = IE_IERMRK
     C                   EVAL      IEUSER = IE_IEUSER
     C                   EVAL      IETMST = IE_IETMST
 
     C                   WRITE     GLRMIED0
     C                   ENDIF
 
     C     PMSID         READE     GLRMIEL0
     C                   ENDDO
 
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
 
     C                   WRITE     GLRMIED0
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
 
      ** Customer excluded from Pool
     C                   EVAL      Ix = 1
     C                   DOW       AExPlCus(Ix) <> *BLANKS
     C                             AND Ix < 50
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = AExPlCus(Ix)
     C                   EVAL      IEINEX = 'O'
     C                   EVAL      IECNFL = 'C'
     C                   EVAL      IERMRK = AExPlRmr(Ix)
     C                   EVAL      IEUSER = PSUSER
     C                   EVAL      IETMST = WTMST
 
     C                   WRITE     GLRMIED0
     C                   EVAL      Ix = Ix + 1
     C                   ENDDO
     C                   WHEN      PActn = 'A'
     C                             OR PActn = 'C'
     C                             OR PActn = 'X'
     C                             OR PActn = 'V'
 
     C     PMSID         SETLL     GLRMIEL0
     C     PMSID         READE     GLRMIEL0
     C                   DOW       NOT %EOF(GLRMIEL0)
     C                   EVAL      IEMSID = MGMSID
     C                   EVAL      IECREF = IE_IECREF
     C                   EVAL      IEINEX = IE_IEINEX
     C                   EVAL      IECNFL = IE_IECNFL
     C                   EVAL      IERMRK = IE_IERMRK
     C                   EVAL      IEUSER = IE_IEUSER
     C                   EVAL      IETMST = IE_IETMST
     C                   WRITE     GLRMIED0
     C     PMSID         READE     GLRMIEL0
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
 
     C                   SELECT
     C                   WHEN      PActn = 'N'
     C                             OR PActn = 'I'
     C                             OR PActn = 'R'
     C                   EVAL      WRType = 'DRAFT NEW'
 
     C                   WHEN      PActn = 'A'
     C                             AND PRType = 'APPROVED NEW'
     C                   EVAL      WRType = 'DRAFT AMEND'
 
     C                   WHEN      PActn = 'C'
     C                             AND PRType = 'APPROVED NEW'
     C                   EVAL      WRType = 'DRAFT CORRECTED'
 
     C                   WHEN      PActn = 'X'
     C                             AND PRType = 'DRAFT NEW'
     C                   EVAL      WRType = 'APPROVED NEW'
 
     C                   WHEN      PActn = 'X'
     C                             AND PRType = 'DRAFT AMEND'
     C                   EVAL      WRType = 'APPROVED AMEND'
 
     C                   WHEN      PActn = 'X'
     C                             AND PRType = 'DRAFT CORRECTED'
     C                   EVAL      WRType = 'APPROVED CORRECTED'
 
     C                   WHEN      PActn = 'X'
     C                             AND WRType = 'DRAFT VOID        '
     C                   EVAL      WRType = 'APPROVED VOID'
 
     C                   WHEN      PActn = 'X'
     C                             AND WRType = 'DRAFT VOID NEW    '
     C                   EVAL      WRType = 'APPROVED VOID NEW'
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAppReport - Approve Report                                  *
      *                                                               *
      *****************************************************************
     C     SRAppReport   BEGSR
 
 
     C     KMsgNo        SETLL     GLRMDTL0
     C     KMsgNo        READE     GLRMDTL0
 
     C                   DOW       NOT %EOF(GLRMDTL0)
 
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
 
     C     KMsgNo        READE     GLRMDTL0
     C                   ENDDO
 
     C     KMsgNo        CHAIN     GLRPMGL0
     C                   IF        %FOUND(GLRPMGL0)
     C                   EVAL      WVoidMsId  = GGVMID
     C                   EVAL      WRType     = GGRTYP
     C                   EVAL      GGAMID = WMsgId
     C                   UPDATE    GLRPMGD0
     C                   ENDIF
 
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
 
     C                   WRITE     GLRPMGD0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCallXML - Call XML Generation                               *
      *                                                               *
      *****************************************************************
     C     SRCallXML     BEGSR
 
     C                   CALL      'GLC000669'
     C                   PARM      WMsgId        PMsgId
     C                   PARM      *BLANKS       Prtcd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNonIGA - Check if for Reporting if Agreement is Non-IGA     *
      *                                                               *
      *****************************************************************
     C     SRNonIGA      BEGSR
 
     C                   EVAL      WModel = 'NONIGA'
 
     C                   SELECT
     C                   WHEN      EXCSTY = 'P'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND (WHasIndicia = 'Y'
     C                             OR  EXREPT = 'Y')
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'J'
     C                             AND EXREPT = 'Y'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXEXEM <> 'Y'
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'NP'
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA103'
 
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'OW'
     C                             AND WJHasSubOwnr = 'Y'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA101'
 
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'OW'
     C                             AND WJHasSubOwnr = 'N'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (WHasIndicia = 'Y'
     C                             OR  EXREPT = 'Y')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'N'
     C                             AND EXCSST = 'PA'
     C                             AND WJHasSubOwnr = 'Y'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA102'
 
     C                   WHEN      EXCSTY = 'N'
     C                             AND EXCSST = 'PA'
     C                             AND WJHasSubOwnr = 'N'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (WHasIndicia = 'Y'
     C                             OR  EXREPT = 'Y')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'N'
     C                             AND EXCSST = 'AC'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (WHasIndicia = 'Y'
     C                             OR  EXREPT = 'Y')
     C                             AND (EXRPTT = 'C' or EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
 
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'O'
     C                             AND (EXRPTT = 'C' or EXRPTT = 'N')
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND EXREPT = 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
     C                   ENDSL
 
      ** Check if for Pool Report
     C                   SELECT
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'OW'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND WHasIndicia = 'Y'
     C                             OR EXCSTY = 'N'
     C                             AND EXCSST = 'AC'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND WHasIndicia = 'Y'
     C                             OR EXCSTY = 'O'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXREPT = 'Y'
     C                             AND WHasIndicia = 'Y'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'J'
     C                             AND WHasIndicia = 'Y'
     C                             AND EXREPT = 'Y'
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA201'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      EXCSTY = 'P'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND EXREPT = 'Y'
     C                             AND WHasIndicia <> 'Y'
     C                             OR EXCSTY = 'F'
     C                             AND EXCSST = 'OW'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WHasIndicia <> 'Y'
     C                             AND EXREPT = 'Y'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'N'
     C                             AND EXCSST = 'AC'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WHasIndicia <> 'Y'
     C                             AND EXREPT = 'Y'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'O'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXREPT = 'Y'
     C                             AND WHasIndicia = 'N'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'J'
     C                             AND WHasIndicia = 'N'
     C                             AND EXREPT = 'Y'
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA202'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'NP'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA204'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      EXCSTY = 'P'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND WHasIndicia = 'Y'
     C                   EVAL      WRepTypPool = 'FATCA205'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      EXCSTY = 'N'
     C                             AND EXCSST = 'PA'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND WHasIndicia = 'Y'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'N'
     C                             AND EXCSST = 'PA'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND WHasIndicia = 'N'
     C                             AND WJHasSubOwnr = 'N'
     C                             AND EXEXEM <> 'Y'
     C                             AND EXREPT = 'Y'
 
     C                   EVAL      WRepTypPool = 'FATCA206'
     C                   EVAL      WReportPool = 'Y'
     C
     C                   WHEN      EXDRMT = 'Y'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' or EXRPTT = 'N')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA203'
     C                   EVAL      WReportPool = 'Y'
     C                   EVAL      WActHldrTyp = ' '
     C                   EVAL      WReportInd = 'N'
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRModel1 - Check if for Reporting if Agreement is Model 1     *
      *                                                               *
      *****************************************************************
     C     SRModel1      BEGSR
 
     C                   SELECT
     C                   WHEN      EXCSTY = 'P'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND (WHasIndicia = 'Y'
     C                             OR  EXREPT = 'Y')
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'J'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXREPT = 'Y'
     C                             AND EXEXEM <> 'Y'
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'NP'
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA103'
 
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'OW'
     C                             AND WJHasSubOwnr = 'Y'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA101'
 
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'OW'
     C                             AND WJHasSubOwnr = 'N'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (WHasIndicia = 'Y'
     C                             OR  EXREPT = 'Y')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'N'
     C                             AND EXCSST = 'PA'
     C                             AND WJHasSubOwnr = 'Y'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA102'
 
     C                   WHEN      EXCSTY = 'N'
     C                             AND EXCSST = 'PA'
     C                             AND WJHasSubOwnr = 'N'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (WHasIndicia = 'Y'
     C                             OR  EXREPT = 'Y')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'N'
     C                             AND EXCSST = 'AC'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' or EXRPTT = 'N')
     C                             AND (WHasIndicia = 'Y'
     C                             OR  EXREPT = 'Y')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
     C                   EVAL      WReportInd = 'Y'
     C
     C                   WHEN      EXCSTY = 'O'
     C                             AND (EXRPTT = 'C' or EXRPTT = 'N')
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND EXREPT = 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   ENDSL
 
      ** Check if for Pool Report
     C                   SELECT
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'OW'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND WHasIndicia = 'Y'
     C                             OR EXCSTY = 'N'
     C                             AND EXCSST = 'AC'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND WHasIndicia = 'Y'
     C                             OR EXCSTY = 'O'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXREPT = 'Y'
     C                             AND WHasIndicia = 'Y'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'J'
     C                             AND WHasIndicia = 'Y'
     C                             AND EXREPT = 'Y'
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA201'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      EXCSTY = 'P'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND EXREPT = 'Y'
     C                             AND WHasIndicia <> 'Y'
     C                             OR EXCSTY = 'F'
     C                             AND EXCSST = 'OW'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WHasIndicia <> 'Y'
     C                             AND EXREPT = 'Y'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'N'
     C                             AND EXCSST = 'AC'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WHasIndicia <> 'Y'
     C                             AND EXREPT = 'Y'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'O'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXREPT = 'Y'
     C                             AND WHasIndicia = 'N'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'J'
     C                             AND WHasIndicia = 'N'
     C                             AND EXREPT = 'Y'
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA202'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'NP'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA204'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      EXCSTY = 'P'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND WHasIndicia = 'Y'
     C                   EVAL      WRepTypPool = 'FATCA205'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      EXCSTY = 'N'
     C                             AND EXCSST = 'PA'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND WHasIndicia = 'Y'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'N'
     C                             AND EXCSST = 'PA'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND WHasIndicia = 'N'
     C                             AND WJHasSubOwnr = 'N'
     C                             AND EXEXEM <> 'Y'
     C                             AND EXREPT = 'Y'
     C                   EVAL      WRepTypPool = 'FATCA206'
     C                   EVAL      WReportPool = 'Y'
     C
 
     C                   WHEN      EXDRMT = 'Y'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' or EXRPTT = 'N')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA203'
     C                   EVAL      WReportPool = 'Y'
     C                   EVAL      WActHldrTyp = ' '
     C                   EVAL      WReportInd = 'N'
 
     C                   ENDSL
 
      ** Report under the Joint Account Members
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRModel2 - Check if for Reporting if Agreement is Model 2     *
      *                                                               *
      *****************************************************************
     C     SRModel2      BEGSR
 
     C                   SELECT
     C                   WHEN      EXCSTY = 'P'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND (WHasIndicia = 'Y'
     C                             OR  EXREPT = 'Y')
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'J'
     C                             AND EXREPT = 'Y'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXEXEM <> 'Y'
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'NP'
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA103'
 
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'OW'
     C                             AND WJHasSubOwnr = 'Y'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA101'
 
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'OW'
     C                             AND WJHasSubOwnr = 'N'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (WHasIndicia = 'Y'
     C                             OR  EXREPT = 'Y')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
     C
     C                   WHEN      EXCSTY = 'N'
     C                             AND EXCSST = 'PA'
     C                             AND WJHasSubOwnr = 'Y'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA102'
 
     C                   WHEN      EXCSTY = 'N'
     C                             AND EXCSST = 'PA'
     C                             AND WJHasSubOwnr = 'N'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (WHasIndicia = 'Y'
     C                             OR  EXREPT = 'Y')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'N'
     C                             AND EXCSST = 'AC'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (WHasIndicia = 'Y'
     C                             OR EXREPT = 'Y')
     C                             AND (EXRPTT = 'C' OR EXRPTT = 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
 
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      EXCSTY = 'O'
     C                             AND (EXRPTT = 'C' or EXRPTT = 'N')
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND EXREPT = 'Y'
     C                   EVAL      WReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
     C                   ENDSL
 
      ** Check if for Pool Report
     C                   SELECT
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'OW'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND WHasIndicia = 'Y'
     C                             OR EXCSTY = 'N'
     C                             AND EXCSST = 'AC'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND WHasIndicia = 'Y'
     C                             OR EXCSTY = 'O'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXREPT = 'Y'
     C                             AND WHasIndicia = 'Y'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'J'
     C                             AND WHasIndicia = 'Y'
     C                             AND EXREPT = 'Y'
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXEXEM <> 'Y'
 
     C                   EVAL      WRepTypPool = 'FATCA201'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      EXCSTY = 'P'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND EXREPT = 'Y'
     C                             AND WHasIndicia <> 'Y'
     C                             OR EXCSTY = 'F'
     C                             AND EXCSST = 'OW'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WHasIndicia <> 'Y'
     C                             AND EXREPT = 'Y'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'N'
     C                             AND EXCSST = 'AC'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WHasIndicia <> 'Y'
     C                             AND EXREPT = 'Y'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'O'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXREPT = 'Y'
     C                             AND WHasIndicia = 'N'
     C                             AND EXEXEM <> 'Y'
     C                             OR EXCSTY = 'J'
     C                             AND WHasIndicia = 'N'
     C                             AND EXREPT = 'Y'
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA202'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      EXCSTY = 'F'
     C                             AND EXCSST = 'NP'
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA204'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      EXCSTY = 'P'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND EXEXEM <> 'Y'
     C                             AND WHasIndicia = 'Y'
     C                   EVAL      WRepTypPool = 'FATCA205'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      EXCSTY = 'N'
     C                             AND EXCSST = 'PA'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND EXEXEM <> 'Y'
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND WHasIndicia = 'Y'
     C                             OR EXCSTY = 'N'
     C                             AND EXCSST = 'PA'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT <> 'C' AND EXRPTT <> 'N')
     C                             AND (EXHVAC = 'H' OR EXHVAC = 'M')
     C                             AND WHasIndicia = 'N'
     C                             AND WJHasSubOwnr = 'N'
     C                             AND EXEXEM <> 'Y'
     C                             AND EXREPT = 'Y'
     C                   EVAL      WRepTypPool = 'FATCA206'
     C                   EVAL      WReportPool = 'Y'
     C
     C                   WHEN      EXDRMT = 'Y'
     C                             AND (EXINFC = 'Y' OR EXINFC = 'A')
     C                             AND (EXRPTT = 'C' or EXRPTT = 'N')
     C                             AND EXEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA203'
     C                   EVAL      WReportPool = 'Y'
     C                   EVAL      WActHldrTyp = ' '
     C                   EVAL      WReportInd = 'N'
     C                   ENDSL
 
      ** Report under the Joint Account Members
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRJNONIGA - Check Joint Acct Member if for reporting NON-IGA  *
      *                                                               *
      *****************************************************************
     C     SRJNONIGA     BEGSR
 
     C                   SELECT
     C                   WHEN      WkCSTY = 'P'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND (WJHasIndicia = 'Y'
     C                             OR  WkREPT = 'Y')
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      WkCSTY = 'J'
     C                             AND WkREPT = 'Y'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'NP'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA103'
 
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND WJHasSubOwnr = 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND WkREPT = 'Y'
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA101'
 
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND (WJHasIndicia = 'Y'  OR
     C                                  WkREPT = 'Y')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND WJHasSubOwnr = 'Y'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA102'
 
     C                   WHEN      WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND (WJHasIndicia = 'Y'  OR
     C                                  WkREPT = 'Y')
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
 
     C                   WHEN      WkCSTY = 'N'
     C                             AND WkCSST = 'AC'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WJHasIndicia = 'Y'  OR
     C                                  WkREPT = 'Y')
     C                             AND (WkRPTT = 'C' or WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
 
     C                   EVAL      WActHldrTyp = 'FATCA104'
     C                   EVAL      WJReportInd = 'Y'
 
     C                   WHEN      WkCSTY = 'O'
     C                             AND  WkREPT = 'Y'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   ENDSL
 
     C                   SELECT
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'AC'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                             OR WkCSTY = 'O'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkREPT = 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'J'
     C                             AND WJHasIndicia = 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA201'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkCSTY = 'P'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND WJHasIndicia <> 'Y'
     C                             OR WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WJHasIndicia <> 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'AC'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WJHasIndicia <> 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'O'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkREPT = 'Y'
     C                             AND WJHasIndicia = 'N'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'J'
     C                             AND WJHasIndicia = 'N'
     C                             AND WkREPT = 'Y'
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA202'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'NP'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA204'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkCSTY = 'P'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                   EVAL      WRepTypPool = 'FATCA205'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WJHasIndicia = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WJHasIndicia = 'N'
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WkEXEM <> 'Y'
     C                             AND WkREPT = 'Y'
     C                   EVAL      WRepTypPool = 'FATCA206'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkDRMT = 'Y'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA203'
     C                   EVAL      WReportPool = 'Y'
     C                   EVAL      WActHldrTyp = ' '
     C                   EVAL      WReportInd = 'N'
     C                   EVAL      WJReportInd = 'N'
 
     C                   ENDSL
 
     C                   EVAL      WJReportPl = WReportPool
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRJModel1 - Check if for Reporting if Agreement is Model 1   *
      *                                                               *
      *****************************************************************
     C     SRJModel1     BEGSR
 
     C                   SELECT
     C                   WHEN      WkCSTY = 'P'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND (WJHasIndicia = 'Y'
     C                             OR  WkREPT = 'Y')
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      WkCSTY = 'J'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkREPT = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'NP'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA103'
 
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND WJHasSubOwnr = 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA101'
 
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND (WJHasIndicia = 'Y'  OR
     C                                  WkREPT = 'Y')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND WJHasSubOwnr = 'Y'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA102'
 
     C                   WHEN      WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND (WJHasIndicia = 'Y'  OR
     C                                  WkREPT = 'Y')
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      WkCSTY = 'N'
     C                             AND WkCSST = 'AC'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WJHasIndicia = 'Y'  OR
     C                                  WkREPT = 'Y')
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
 
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      WkCSTY = 'O'
     C                             AND  WkREPT = 'Y'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
     C                   ENDSL
 
      ** Check if for Pool Report
     C                   SELECT
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'AC'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                             OR WkCSTY = 'O'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkREPT = 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'J'
     C                             AND WJHasIndicia = 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA201'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkCSTY = 'P'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND WJHasIndicia <> 'Y'
     C                             OR WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WJHasIndicia <> 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'AC'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WJHasIndicia <> 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'O'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkREPT = 'Y'
     C                             AND WJHasIndicia = 'N'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'J'
     C                             AND WJHasIndicia = 'N'
     C                             AND WkREPT = 'Y'
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA202'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'NP'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA204'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkCSTY = 'P'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                   EVAL      WRepTypPool = 'FATCA205'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WJHasIndicia = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WJHasIndicia = 'N'
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WkEXEM <> 'Y'
     C                             AND WkREPT = 'Y'
     C                   EVAL      WRepTypPool = 'FATCA206'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkDRMT = 'Y'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT = 'C' or WkRPTT = 'N')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA203'
     C                   EVAL      WReportPool = 'Y'
     C                   EVAL      WActHldrTyp = ' '
     C                   EVAL      WReportInd = 'N'
     C                   EVAL      WJReportInd = 'N'
 
     C                   ENDSL
 
     C                   EVAL      WJReportPl = WReportPool
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRJModel2 - Check if for Reporting if Agreement is Model 2    *
      *                                                               *
      *****************************************************************
     C     SRJModel2     BEGSR
 
     C                   SELECT
     C                   WHEN      WkCSTY = 'P'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND (WJHasIndicia = 'Y'
     C                             OR  WkREPT = 'Y')
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      WkCSTY = 'J'
     C                             AND WkREPT = 'Y'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'NP'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA103'
 
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND WJHasSubOwnr = 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA101'
 
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND (WJHasIndicia = 'Y'  OR
     C                                  WkREPT = 'Y')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
 
     C                   WHEN      WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND WJHasSubOwnr = 'Y'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA102'
 
     C                   WHEN      WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND (WJHasIndicia = 'Y'  OR
     C                                  WkREPT = 'Y')
     C                   EVAL      WJReportInd = 'Y'
     C                   EVAL      WActHldrTyp = 'FATCA104'
     C                   WHEN      WkCSTY = 'N'
     C                             AND WkCSST = 'AC'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WJHasIndicia = 'Y'
     C                             OR WkREPT = 'Y')
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
 
     C                   EVAL      WActHldrTyp = 'FATCA104'
     C                   EVAL      WJReportInd = 'Y'
     C                   ENDSL
 
     C                   SELECT
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'AC'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                             OR WkCSTY = 'O'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkREPT = 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'J'
     C                             AND WJHasIndicia = 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA201'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkCSTY = 'P'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND WJHasIndicia <> 'Y'
     C                             OR WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WJHasIndicia <> 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'AC'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WJHasIndicia <> 'Y'
     C                             AND WkREPT = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'O'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkREPT = 'Y'
     C                             AND WJHasIndicia = 'N'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'J'
     C                             AND WJHasIndicia = 'N'
     C                             AND WkREPT = 'Y'
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA202'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkCSTY = 'F'
     C                             AND WkCSST = 'NP'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA204'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkCSTY = 'P'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WJHasIndicia = 'Y'
     C                   EVAL      WRepTypPool = 'FATCA205'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WJHasIndicia = 'Y'
     C                             AND WkEXEM <> 'Y'
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT <> 'C' AND WkRPTT <> 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WJHasIndicia = 'N'
     C                             AND WJHasSubOwnr = 'N'
     C                             AND WkEXEM <> 'Y'
     C                             AND WkREPT = 'Y'
     C                   EVAL      WRepTypPool = 'FATCA206'
     C                   EVAL      WReportPool = 'Y'
 
     C                   WHEN      WkDRMT = 'Y'
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT = 'C' or WkRPTT = 'N')
     C                             AND WkEXEM <> 'Y'
     C                   EVAL      WRepTypPool = 'FATCA203'
     C                   EVAL      WReportPool = 'Y'
     C                   EVAL      WActHldrTyp = ' '
     C                   EVAL      WReportInd = 'N'
     C                   EVAL      WJReportInd = 'N'
 
     C                   ENDSL
 
     C                   EVAL      WJReportPl = WReportPool
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkLowDep - Determine Document Type                         *
      *                                                               *
      *****************************************************************
     C     SRChkLowDep   BEGSR
 
      ** Check if MM Deals transactions or Retail Account
     C                   MOVEL     EXTTYP        WDLType
     C                   IF        WDLType = 'TD'
     C                             OR WDLType = 'CD'
     C                             OR WDLType = 'TD'
     C                             OR WDLType = 'CI'
     C                             OR WDLType = 'IT'
     C                             OR WDLType = 'DT'
     C                             OR WDLType = 'FT'
     C                             OR WDLType = 'LT'
     C                             OR EXACSQ <> 0
 
     C                   IF        ZCCYO <> EXCCY
     C                             AND EXBALN <> *ZERO
     C                   EVAL      Pcurr = EXCCY
     C                   EXSR      SRAccCurr
     C                   EVAL      ZRATE1 = A6SPRT
     C                   EVAL      ZMDI1 = A6MDIN
     C                   EVAL      ZCCYI = EXCCY
     C                   EVAL      ZCDPI = A6NBDP
     C                   EVAL      ZAMTCI = EXBALN
     C                   EXSR      SRCvtAmt
     C                   IF        EXACSQ = 0
     C                   EVAL      WHighValAmt = ZAMTCO
     C                   ELSE
     C                   EVAL      WHighValAmt = ZAMTCO * -1
     C                   ENDIF
     c                   ELSE
     C                   IF        EXACSQ = 0
     C                   EVAL      WHighValAmt = EXBALN
     C                   ELSE
     C                   EVAL      WHighValAmt = EXBALN * -1
     C                   ENDIF
     C                   ENDIF
 
      ** Retail accts and MM transaction should be excluded from the report
 
     C                   IF        WHighValAmt <= WSValLowDep
     C                   EVAL      WLowDepAcc = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetDocTyp - Determine Document Type                         *
      *                                                               *
      *****************************************************************
     C     SRDetDocTyp   BEGSR
 
     C                   IF        Pstat = 'LIVE'
     C                   SELECT
     C                   WHEN      PActn = 'N'
     C                             OR PActn = 'R'
     C                             OR PActn = 'I'
     C                   EVAL      WDocTyp= 'FATCA1'
     C                   EVAL      WActn  = 'N'
     C                   WHEN      PActn = 'C'
     C                   EVAL      WDocTyp= 'FATCA2'
     C                   EVAL      WActn  = 'C'
     C                   WHEN      PActn = 'V'
     C                             AND WRtype = 'DRAFT VOID'
     C                             OR PActn = 'O'
     C                             AND WRtype = 'DRAFT VOID'
     C                   EVAL      WDocTyp= 'FATCA3'
     C                   EVAL      WActn  = 'V'
     C                   WHEN      PActn = 'V'
     C                             AND WRtype = 'DRAFT VOID NEW'
     C                   EVAL      WDocTyp= 'FATCA1'
     C                   EVAL      WActn  = 'V'
     C                   WHEN      PActn = 'A'
     C                             OR PActn = 'O'
     C                             AND WRtype = 'DRAFT AMEND'
     C                   EVAL      WDocTyp= 'FATCA4'
     C                   EVAL      WActn  = 'A'
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
     C                   EVAL      WDocTyp = 'FATCA11'
     C                   EVAL      WActn  = 'N'
     C                   WHEN      PActn = 'C'
     C                   EVAL      WDocTyp = 'FATCA12'
     C                   EVAL      WActn  = 'C'
     C                   WHEN      PActn = 'V'
     C                             AND WRtype = 'DRAFT VOID'
     C                             OR PActn = 'O'
     C                             AND WRtype = 'DRAFT VOID'
     C                   EVAL      WDocTyp = 'FATCA13'
     C                   EVAL      WActn  = 'V'
     C                   WHEN      PActn = 'V'
     C                             AND WRtype = 'DRAFT VOID NEW'
     C                   EVAL      WDocTyp= 'FATCA11'
     C                   EVAL      WActn  = 'V'
     C                   WHEN      PActn = 'A'
     C                             OR PActn = 'O'
     C                             AND WRtype = 'DRAFT AMEND'
     C                   EVAL      WDocTyp = 'FATCA14'
     C                   EVAL      WActn  = 'A'
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
 
     C**********         IF        WCust <> EXCUSD                                          MD044368
 
     C                   EVAL      WCust = EXCUSD
     C                   EXSR      SRChkIndCust
     C                   EXSR      SRChkTINs
     C                   EXSR      SRChkSubw
 
     C                   EVAL      WReportInd = 'N'
     C                   EVAL      WReportPool = 'N'
     C                   EVAL      WReportJnt  = 'N'
     C                   EVAL      WRepTypPool = *BLANKS
 
      ** Check customer if to report based on Agreement Type
 
     C                   EVAL      PCode = EXCOLC
     C                   EXSR      SRAccCountry
     C                   EXSR      SRChkAgrType
 
     C     WModel        CASEQ     'Model1'      SrModel1
     C     WModel        CASEQ     'Model2'      SrModel2
     C     WModel        CASEQ     'NONIGA'      SrNonIGA
     C                   ENDCS
     C**********         ENDIF                                                              MD044368
 
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
     C                   EVAL      WReportPool = 'N'
     C                   EVAL      WJReportInd = 'N'
     C                   EVAL      WJReportPl = 'N'
     C                   EVAL      KJano = EXJANO
 
     C     KJano         CHAIN     GLRMEXL2
     C                   IF        %FOUND(GLRMEXL2)
     C                             AND X2EXCSTY <> 'J'
     C                   EVAL      WJReportInd = 'N'
     C                   EVAL      WReportJnt = WJReportInd                                 MD044368
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
     C     JCCUST        CHAIN     SDFTCSL6
     C                   IF        %FOUND(SDFTCSL6)
     C                   EVAL      WJReportInd = 'N'
     C                   EVAL      WReportJnt = WJReportInd
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      WCust = JCCUST
     C                   EXSR      SRChkSubw
     C                   EXSR      SRAccCust
 
     C**********         EVAL      FCust = JCCUST                                           MD044000
     C                   EVAL      FCust = PCust                                            MD044000
     C                   EXSR      SRFTCSDet
 
     C**********         EVAL      PAcus = JCCUST                                           MD044000
     C                   EVAL      PAcus = PCust                                            MD044000
     C                   EXSR      SRAccAcus
 
     C**********         EVAL      WCust = JCCUST                                           MD044000
     C                   EVAL      WCust = PCust                                            MD044000
     C                   EXSR      SRChkIndFTCS
     C                   EXSR      SRChkTINCS
     C**********         EVAL      SCust = JCCUST                                           MD044000
     C                   EVAL      SCust = PCust                                            MD044000
     C                   EXSR      SRAccCUSX
 
     C                   EVAL      WJReportInd = 'N'
     C                   EVAL      WJReportPl = 'N'
 
     C                   EVAL      WkCSTY = FACSTY
     C                   EVAL      WkCSST = FACSST
     C                   EVAL      WkINFC = FAINFC
     C                   EVAL      WkRPTT = FARPTT
     C                   EVAL      WkHVAC = FAHVAC
     C                   EVAL      WkEXEM = FAEXEM
     C                   EVAL      WkREPT = FAREPT
     C                   EVAL      WkDRMT = XCDRMT
 
      ** Check Member if to report based on Agreement Type
     C                   EVAL      PCode = BBCOLC
     C                   EXSR      SRAccCountry
     C                   EXSR      SRChkAgrType
 
     C     WModel        CASEQ     'Model1'      SrJModel1
     C     WModel        CASEQ     'Model2'      SrJModel2
     C     WModel        CASEQ     'NONIGA'      SrJNONIGA
     C                   ENDCS
 
     C                   ELSE
 
     C                   EVAL      KNAHO  = JCNAHO
 
     C                   IF        PActn <> 'I'
      ** Check first if the Customer has Exceptions
     C     KNAHO         CHAIN     SDFTNHL6
     C                   IF        %FOUND(SDFTNHL6)
     C                   EVAL      WJReportInd = 'N'
     C                   EVAL      WReportJnt = WJReportInd
     C                   LEAVESR
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRFTNHDet
 
     C                   EVAL      PNaho = JCNAHO
     C                   EXSR      SRAccNaho
 
     C                   EVAL      WCust = JCNAHO
     C                   EXSR      SRChkIndFTNH
     C                   EXSR      SRChkTINNH
      ** Non-Account Holder has no substantial owners
     C                   EVAL      WJHasSubOwnr = 'N'
 
     C                   EVAL      WJReportInd = 'N'
     C                   EVAL      WJReportPl = 'N'
 
      ** Move fields to check if for reporting
     C                   EVAL      WkCSTY = FNNHTY
     C                   EVAL      WkCSST = FNNHST
     C                   EVAL      WkINFC = FNINFC
     C                   EVAL      WkRPTT = FNRPTT
     C                   EVAL      WkHVAC = FNHVAC
     C                   EVAL      WkEXEM = FNEXEM
     C                   EVAL      WkREPT = FNREPT
     C                   EVAL      WkDRMT = 'N'
 
      ** Check Member if to report based on Agreement Type
     C                   EVAL      PCode = NHCOLC
     C                   EXSR      SRAccCountry
     C                   EXSR      SRChkAgrType
 
     C     WModel        CASEQ     'Model1'      SrJModel1
     C     WModel        CASEQ     'Model2'      SrJModel2
     C     WModel        CASEQ     'NONIGA'      SrJNONIGA
     C                   ENDCS
     C                   ENDIF
 
     C                   EVAL      WReportJnt = WJReportInd
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkAgrType - Check Agreement Type for Reporting             *
      *                                                               *
      *****************************************************************
     C     SRChkAgrType  BEGSR
 
     C                   EVAL      WModel = *BLANKS                                         MD043187
      ** Process according to Agreement Type
     C                   SELECT
     C                   WHEN      A4FAAT = 'M1R'
     C                             OR A4FAAT = 'M1N'
     C                   EVAL      WModel = 'Model1'
 
     C                   WHEN      A4FAAT = 'M2R'
     C                             OR A4FAAT = 'M2N'
     C                   EVAL      WModel = 'Model2'
 
     C                   WHEN      A4FAAT = 'NOA'
     C                   EVAL      WModel = 'NONIGA'
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkIndCust - Check US Indicia for Customer                 *
      *                                                               *
      *****************************************************************
     C     SRChkIndCust  BEGSR
 
     C                   EVAL      WOvrOff = 1
     C                   EVAL      WSysOff = 0
     C                   EVAL      WHasIndicia = 'N'
 
      ** Check if any override flag has been set on
      ** If any has been set, this needs to get flagged as having indicia
 
     C                   IF        %SCAN('Y':CustIndOverDS) = 0
 
     C                   DOU       WOvrOff = 0 OR WOvrOff > WIndCnt
     C                             OR WHasIndicia = 'Y'
 
      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':CustIndSvalDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0
     C                   EVAL      WSysOff =
     C                               %SCAN('N':CustIndOverDS:WSysOff)
     C                   ENDIF
 
      ** If offsets match, system value has been overriden
     C                   IF        WSysOff <> WOvrOff
     C                             AND WOvrOff <> 0
     C                   EVAL      WHasIndicia = 'Y'
     C                   ENDIF
     C                   IF        WOvrOff <> 0
     C                   EVAL      WOvrOff = WOvrOff + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ELSE
     C                   EVAL      WHasIndicia = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkIndFTCS - Check US Indicia for Customer                 *
      *                                                               *
      *****************************************************************
     C     SRChkIndFTCS  BEGSR
 
     C                   EVAL      WOvrOff = 1
     C                   EVAL      WSysOff = 0
     C                   EVAL      WJHasIndicia = 'N'
 
      ** Check if any override flag has been set on
      ** If any has been set, this needs to get flagged as having indicia
 
     C                   IF        %SCAN('Y':FTCSIndOverDS) = 0
 
     C                   DOU       WOvrOff = 0 OR WOvrOff > WIndCnt
     C                             OR WJHasIndicia = 'Y'
 
      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':FTCSIndSValDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0
     C                   EVAL      WSysOff =
     C                               %SCAN('N':FTCSIndOverDS:WSysOff)
     C                   ENDIF
 
      ** If offsets match, system value has been overriden
     C                   IF        WSysOff <> WOvrOff
     C                             AND WOvrOff <> 0
     C                   EVAL      WJHasIndicia = 'Y'
     C                   ENDIF
     C                   IF        WOvrOff <> 0
     C                   EVAL      WOvrOff = WOvrOff + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ELSE
     C                   EVAL      WJHasIndicia = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkIndFTNH - Check US Indicia for Non-Account Holders      *
      *                                                               *
      *****************************************************************
     C     SRChkIndFTNH  BEGSR
 
     C                   EVAL      WOvrOff = 1
     C                   EVAL      WSysOff = 0
     C                   EVAL      WJHasIndicia = 'N'
 
      ** Check if any override flag has been set on
      ** If any has been set, this needs to get flagged as having indicia
 
     C                   IF        %SCAN('Y':FTNHIndOverDS) = 0
 
     C                   DOU       WOvrOff = 0 OR WOvrOff > WIndCnt
     C                             OR WJHasIndicia = 'Y'
 
      ** Check any override as 'N' possibly invalidating
      ** system value Indicia
     C                   EVAL      WOvrOff =
     C                               %SCAN('Y':FTNHIndSValDS:WOvrOff)
     C                   EVAL      WSysOff = WOvrOff
     C                   IF        WOvrOff <> 0
     C                   EVAL      WSysOff =
     C                               %SCAN('N':FTNHIndOverDS:WSysOff)
     C                   ENDIF
 
      ** If offsets match, system value has been overriden
     C                   IF        WSysOff <> WOvrOff
     C                             AND WOvrOff <> 0
     C                   EVAL      WJHasIndicia = 'Y'
     C                   ENDIF
     C                   IF        WOvrOff <> 0
     C                   EVAL      WOvrOff = WOvrOff + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ELSE
     C                   EVAL      WJHasIndicia = 'Y'
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
     C                   PARM      SysVal3       SValK3
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
     C                   EVAL      DBPGM = 'GL000667'
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   EVAL      PCurr = SVal1
     C                   EXSR      SRAccCurr
 
     C                   EVAL      Zadec = A6NBDP
     C                   EVAL      Zadig = 13
 
     C                   EVAL      Zfield = %TRIM(SVal3)
     C                   EXSR      SRAlgAmount
     C                   MOVE      Zfield        WSValLowDep
      ** Retrieve high value currency rate
     C                   EVAL      PCurr = SVal1
     C                   EXSR      SRAccCurr
     C                   EVAL      ZRATE2 = A6SPRT
     C                   EVAL      ZMDI2 = A6MDIN
     C                   EVAL      ZCCYO = PCurr
     C                   EVAL      ZCDPO = A6NBDP
 
     C                   ENDIF
     C
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PrtrnCode
     C                   PARM      WsSysVal1     WsSValK1
     C                   PARM                    WsSVal1
     C                   PARM                    WsSValK2
     C                   PARM                    WsSVal2
     C                   PARM                    WsSValK3
     C                   PARM                    WsSVal3
     C                   PARM                    WsSValK4
     C                   PARM                    WsSVal4
     C                   PARM                    WsSValK5
     C                   PARM                    WsSVal5
     C                   PARM                    WsSValK6
     C                   PARM                    WsSVal6
     C                   PARM                    WsSValK7
     C                   PARM                    WsSVal7
     C                   PARM                    WsSValK8
     C                   PARM                    WsSVal8
     C                   PARM                    WsSValK9
     C                   PARM                    WsSVal9
     C                   PARM                    WsSValK0
     C                   PARM                    WsSVal10
 
     C                   IF        PrtrnCode <> *Blanks
     C                             AND PrtrnCode <> '*NRF   '
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = WsSValK1
     C                   EVAL      DBASE = 011
     C                   EVAL      DBPGM = 'GL000667'
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   EVAL      WsCountryTax = WsSVal1
     C                   ENDIF
 
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
     C                   EVAL      DBPGM = 'GL000667'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtAmt - Convert Amount                                     *
      *                                                               *
      *****************************************************************
     C     SRCvtAmt      BEGSR
 
      ** Calculate cross exchange rate
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM      *ZEROS        ZRATEX
     C                   PARM      *BLANKS       ZMDIX
 
      * Convert amount
     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM      ZRATEX        ZEXCH
     C                   PARM      ZMDIX         ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM      *ZEROS        ZAMTCO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAlgAmount - Align amount                                   *
      *                                                               *
      *****************************************************************
     C     SRAlgAmount   BEGSR
 
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK
     C                   PARM                    Zfield
     C                   PARM                    Zadec
     C                   PARM                    Zadig
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialise field                                     *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   EVAL      WCount       = 0
     C                   EVAL      WCount1      = 0
     C                   EVAL      WCount2      = 0
     C                   EVAL      WCount3      = 0
     C                   EVAL      WCount4      = 0
     C                   EVAL      WCount5      = 0
     C                   EVAL      WCount6      = 0
     C                   EVAL      WPoolBal     = 0
     C                   EVAL      WPayTotCcy   = 0
     C                   EVAL      WHasIndicia  = 'N'
     C                   EVAL      WJHasIndicia = 'N'
     C                   EVAL      WHasTINs     = 'N'
     C                   EVAL      WJHasTINs    = 'N'
     C                   EVAL      WCorrDocRef  = *BLANKS
     C                   EVAL      WPoolCorDrf  = *BLANKS
     C                   MOVE      *BLANKS       ArAcctDet
     C                   MOVE      *BLANKS       ArPoolDet1
     C                   MOVE      *BLANKS       ArPoolDet2
     C                   MOVE      *BLANKS       ArPoolDet3
     C                   MOVE      *BLANKS       ArPoolDet4
     C                   MOVE      *BLANKS       ArPoolDet5
     C                   MOVE      *BLANKS       ArPoolDet6
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
 
     C                   WRITE     GLRMDTD0
 
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
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      MD044368
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      MD044368
 
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
      ***a*************************************************************
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
      * SRFTCSDet - Access FATCA Details File                         *
      *                                                               *
      *****************************************************************
     C     SRFTCSDet     BEGSR
 
     C     FCust         CHAIN     SDFTCSL0
 
      ** If not found, this means that no records exists; DB error
 
     C                   IF        NOT %FOUND(SDFTCSL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 004
     C                   EVAL      DBFile = 'SDFTCSPD'
     C                   EVAL      DBKEY = KCust
     C                   EVAL      DBPGM = 'GL000667'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFTNHDet - Access FATCA Naho Details File                    *
      *                                                               *
      *****************************************************************
     C     SRFTNHDet     BEGSR
 
     C     KNAHO         CHAIN     SDFTNHL0
 
      ** If not found, this means that no records exists; DB error
 
     C                   IF        NOT %FOUND(SDFTNHL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 003
     C                   EVAL      DBFile = 'SDFTNHPD'
     C                   EVAL      DBKEY = KNAHO
     C                   EVAL      DBPGM = 'GL000667'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAccCountry - Access Country Codes File                      *
      *                                                               *
      *****************************************************************
     C     SRAccCountry  BEGSR
 
     C                   CALL      'AOCTRYR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PCode
     C     SDCTRY        PARM      SDCTRY        DSFDY
 
     C                   IF        PRtrnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCTRYPD'
     C                   EVAL      DBKEY = PCode
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkSubw - Check Substantial Owners                         *
      *                                                               *
      *****************************************************************
     C     SRChkSubw     BEGSR
 
     C                   EVAL      WJHasSubOwnr = 'N'
     C                   EVAL      WCuahFlg = ' '                                           MD043144
     C                   EVAL      XCust = Wcust
     C     XCust         SETLL     SDJACCL0
     C     XCust         READE     SDJACCL0
 
     C                   DOW       NOT %EOF(SDJACCL0)
 
     C                   IF        JCCUST <> *BLANKS                                        MD043144
     C                   EVAL      PSub10 = JCCUST                                          MD043144
     C                   ELSE                                                               MD043144
     C                   EVAL      PSub10 = JCNAHO                                          MD043144
     C                   ENDIF                                                              MD043144
     C                   EXSR      SRChkSubCat
     C                   IF        WJHasSubOwnr = 'Y'
     C                   LEAVESR
     C                   ENDIF
 
     C     XCust         READE     SDJACCL0
     C                   ENDDO
 
     C                   EVAL      JCCUST = *Blanks                                         MD043144
     C                   EVAL      JCNAHO = *Blanks                                         MD043144
                                                                                            MD043144
     C     XCust         SETLL     SDCUAHL0                                                 MD043144
     C     XCust         READE     SDCUAHL0                                                 MD043144
                                                                                            MD043144
     C                   DOW       NOT %EOF(SDCUAHL0)                                       MD043144
     C                   IF        CAPCNT <> *Blanks                                        MD043144
     C                   MOVE      CAPCNT        WNUM3                                      MD043144
     C                   IF        WNUM3 <> *ZERO                                           MD043144
     C                   EVAL      PCuah = CAAUTH                                           MD043144
     C                   EVAL      WCuahFlg = ' '                                           MD043144
     C                   CALL      'AOCUSTR0'                                               MD043144
     C                   PARM      *BLANKS       PRtCd                                      MD043144
     C                   PARM      '*KEY'        POptn                                      MD043144
     C                   PARM                    PCuah                                      MD043144
     C                   PARM      *BLANKS       PCNST                                      MD043144
     C     SDCUST        PARM      SDCUST        DSSDY                                      MD043144
      *                                                                                     MD043144
     C                   IF        PRtCd = *BLANKS                                          MD043144
     C                   EVAL      WCuahFlg = 'C'                                           MD043144
     C                   ELSE                                                               MD043144
     C                   CALL      'AONAHOR0'                                               MD043144
     C                   PARM      *BLANKS       PRtCd                                      MD043144
     C                   PARM      '*KEY'        POptn                                      MD043144
     C                   PARM                    PCuah                                      MD043144
     C                   PARM      SDNAHO        DSLDY                                      MD043144
      *                                                                                     MD043144
     C                   IF        PRtCd = *BLANKS                                          MD043144
     C                   EVAL      WCuahFlg = 'N'                                           MD043144
     C                   ENDIF                                                              MD043144
     C                   ENDIF                                                              MD043144
                                                                                            MD043144
     C                   EVAL      PSub10 = PCuah                                           MD043144
     C                   EXSR      SRChkSubCat                                              MD043144
                                                                                            MD043144
     C                   IF        WJHasSubOwnr = 'Y'                                       MD043144
     C                   LEAVESR                                                            MD043144
     C                   ENDIF                                                              MD043144
                                                                                            MD043144
     C                   ENDIF                                                              MD043144
     C                   ENDIF                                                              MD043144
     C     XCust         READE     SDCUAHL0                                                 MD043144
     C                   ENDDO                                                              MD043144
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
     C                             OR WCuahFlg = 'C'                                        MD043144
     C**********         EVAL      FCust = JCCUST                                           MD043144
     C                   EVAL      FCust = PSub10                                           MD043144
     C                   EXSR      SRFTCSDet
     C**********         EVAL      SCust = JCCUST                                           MD043144
     C                   EVAL      SCust = PSub10                                           MD043144
     C                   EXSR      SRAccCUSX
     C                   EXSR      SRChkIndFTCS
     C                   EVAL      WkCSTY = FACSTY
     C                   EVAL      WkCSST = FACSST
     C                   EVAL      WkINFC = FAINFC
     C                   EVAL      WkRPTT = FARPTT
     C                   EVAL      WkHVAC = FAHVAC
     C                   EVAL      WkEXEM = FAEXEM
     C                   EVAL      WkREPT = FAREPT
     C                   EVAL      WkDRMT = XCDRMT
 
     C                   ELSE
     C**********         EVAL      KNAHO  = JCNAHO                                          MD043144
     C                   EVAL      KNAHO  = PSub10                                          MD043144
     C                   EXSR      SRFTNHDet
     C                   EXSR      SRChkIndFTNH
     C                   EVAL      WkCSTY = FNNHTY
     C                   EVAL      WkCSST = FNNHST
     C                   EVAL      WkINFC = FNINFC
     C                   EVAL      WkRPTT = FNRPTT
     C                   EVAL      WkHVAC = FNHVAC
     C                   EVAL      WkEXEM = FNEXEM
     C                   EVAL      WkREPT = FNREPT
     C                   EVAL      WkDRMT = 'N'
     C                   ENDIF
 
      ** Determin if Subowners are specified US owners (FATCA104)
 
     C                   IF        (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WkDRMT <> 'Y'
     C                   IF        WkCSTY = 'P'
     C                             AND (WJHasIndicia = 'Y'
     C                             OR  WkREPT = 'Y')
     C                             OR  WkCSTY = 'J'
     C                             AND WkREPT = 'Y'
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'AC'
     C                             AND (WJHasIndicia = 'Y'
     C                             OR  WkREPT = 'Y')
     C                             OR WkCSTY = 'O'
     C                             AND  WkREPT = 'Y'
 
     C                   EVAL      WJHasSubOwnr = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND (WJHasIndicia = 'Y'
     C                             OR  WkREPT = 'Y')
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND (WJHasIndicia = 'Y'
     C                             OR  WkREPT = 'Y')
     C                   IF        JCCUST <> *BLANKS                                        MD043144
     C                             OR WCuahFlg = 'C'                                        MD043144
     C                   EVAL      PSub6 = PSub10                                           MD043144
     C*****JCCUST        SETLL     SDJACCL1                                                 MD043144
     C*****JCCUST        READE     SDJACCL1                                                 MD043144
     C     PSub6         SETLL     SDJACCL1                                                 MD043144
     C     PSub6         READE     SDJACCL1                                                 MD043144
     C                   DOW       NOT %EOF(SDJACCL1)
 
     C                   IF        M_JCCUST <> *BLANKS
     C                   EVAL      FCust = M_JCCUST
     C                   EXSR      SRFTCSDet
     C                   EVAL      SCust = M_JCCUST
     C                   EXSR      SRAccCUSX
     C                   EXSR      SRChkIndFTCS
     C                   EVAL      WkCSTY = FACSTY
     C                   EVAL      WkCSST = FACSST
     C                   EVAL      WkINFC = FAINFC
     C                   EVAL      WkRPTT = FARPTT
     C                   EVAL      WkHVAC = FAHVAC
     C                   EVAL      WkEXEM = FAEXEM
     C                   EVAL      WkREPT = FAREPT
     C                   EVAL      WkDRMT = XCDRMT
 
     C                   ELSE
     C                   EVAL      KNAHO  = M_JCNAHO
     C                   EXSR      SRFTNHDet
     C                   EXSR      SRChkIndFTNH
     C                   EVAL      WkCSTY = FNNHTY
     C                   EVAL      WkCSST = FNNHST
     C                   EVAL      WkINFC = FNINFC
     C                   EVAL      WkRPTT = FNRPTT
     C                   EVAL      WkHVAC = FNHVAC
     C                   EVAL      WkEXEM = FNEXEM
     C                   EVAL      WkREPT = FNREPT
     C                   EVAL      WkDRMT = 'N'
     C                   ENDIF
     C                   IF        (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')
     C                             AND WkEXEM <> 'Y'
     C                             AND WkDRMT <> 'Y'
     C                   IF        WkCSTY = 'P'
     C                             AND (WJHasIndicia = 'Y'
     C                             OR  WkREPT = 'Y')
     C                             OR  WkCSTY = 'J'
     C                             AND WkREPT = 'Y'
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'AC'
     C                             AND (WJHasIndicia = 'Y'
     C                             OR  WkREPT = 'Y')
     C                             OR WkCSTY = 'O'
     C                             AND  WkREPT = 'Y'
     C                             OR WkCSTY = 'F'
     C                             AND WkCSST = 'OW'
     C                             AND (WJHasIndicia = 'Y'
     C                             OR  WkREPT = 'Y')
     C                             OR WkCSTY = 'N'
     C                             AND WkCSST = 'PA'
     C                             AND (WJHasIndicia = 'Y'
     C                             OR  WkREPT = 'Y')
 
     C                   EVAL      WJHasSubOwnr = 'Y'
     C                   ENDIF
     C                   ENDIF
     C*****JCCUST        READE     SDJACCL1                                                 MD043144
     C     PSub6         READE     SDJACCL1                                                 MD043144
     C                   ENDDO
                                                                                            MD043144
     C     PSub6         SETLL     SDCUAHL1                                                 MD043144
     C     PSub6         READE     SDCUAHL1                                                 MD043144
     C                   DOW       NOT %EOF(SDCUAHL1)                                       MD043144
                                                                                            MD043144
     C                   IF        L1_CAPCNT <> *Blanks                                     MD043144
     C                   MOVE      L1_CAPCNT     WNUM3                                      MD043144
     C                   IF        WNUM3 <> *ZERO                                           MD043144
     C                   EVAL      PCuah = L1_CAAUTH                                        MD043144
     C                   EVAL      WCuahFl2 = ' '                                           MD043144
     C                   CALL      'AOCUSTR0'                                               MD043144
     C                   PARM      *BLANKS       PRtCd                                      MD043144
     C                   PARM      '*KEY'        POptn                                      MD043144
     C                   PARM                    L1_CAAUTH                                  MD043144
     C                   PARM      *BLANKS       PCNST                                      MD043144
     C     SDCUST        PARM      SDCUST        DSSDY                                      MD043144
      *                                                                                     MD043144
     C                   IF        PRtCd = *BLANKS                                          MD043144
     C                   EVAL      WCuahFl2 = 'C'                                           MD043144
     C                   ELSE                                                               MD043144
     C                   CALL      'AONAHOR0'                                               MD043144
     C                   PARM      *BLANKS       PRtCd                                      MD043144
     C                   PARM      '*KEY'        POptn                                      MD043144
     C                   PARM                    L1_CAAUTH                                  MD043144
     C                   PARM      SDNAHO        DSLDY                                      MD043144
      *                                                                                     MD043144
     C                   IF        PRtCd = *BLANKS                                          MD043144
     C                   EVAL      WCuahFl2 = 'N'                                           MD043144
     C                   ENDIF                                                              MD043144
     C                   ENDIF                                                              MD043144
                                                                                            MD043144
     C                   IF        WCuahFl2 = 'C'                                           MD043144
     C                   EVAL      FCust = PCuah                                            MD043144
     C                   EXSR      SRFTCSDet                                                MD043144
     C                   EVAL      SCust = PCuah                                            MD043144
     C                   EXSR      SRAccCUSX                                                MD043144
     C                   EXSR      SRChkIndFTCS                                             MD043144
     C                   EVAL      WkCSTY = FACSTY                                          MD043144
     C                   EVAL      WkCSST = FACSST                                          MD043144
     C                   EVAL      WkINFC = FAINFC                                          MD043144
     C                   EVAL      WkRPTT = FARPTT                                          MD043144
     C                   EVAL      WkHVAC = FAHVAC                                          MD043144
     C                   EVAL      WkEXEM = FAEXEM                                          MD043144
     C                   EVAL      WkREPT = FAREPT                                          MD043144
     C                   EVAL      WkDRMT = XCDRMT                                          MD043144
                                                                                            MD043144
     C                   ELSE                                                               MD043144
     C                   EVAL      KNAHO  = PCuah                                           MD043144
     C                   EXSR      SRFTNHDet                                                MD043144
     C                   EXSR      SRChkIndFTNH                                             MD043144
     C                   EVAL      WkCSTY = FNNHTY                                          MD043144
     C                   EVAL      WkCSST = FNNHST                                          MD043144
     C                   EVAL      WkINFC = FNINFC                                          MD043144
     C                   EVAL      WkRPTT = FNRPTT                                          MD043144
     C                   EVAL      WkHVAC = FNHVAC                                          MD043144
     C                   EVAL      WkEXEM = FNEXEM                                          MD043144
     C                   EVAL      WkREPT = FNREPT                                          MD043144
     C                   EVAL      WkDRMT = 'N'                                             MD043144
     C                   ENDIF                                                              MD043144
     C                   IF        (WkRPTT = 'C' OR WkRPTT = 'N')                           MD043144
     C                             AND (WkINFC = 'Y' OR WkINFC = 'A')                       MD043144
     C                             AND (WkRPTT = 'C' OR WkRPTT = 'N')                       MD043144
     C                             AND (WkHVAC = 'H' OR WkHVAC = 'M')                       MD043144
     C                             AND WkEXEM <> 'Y'                                        MD043144
     C                             AND WkDRMT <> 'Y'                                        MD043144
     C                   IF        WkCSTY = 'P'                                             MD043144
     C                             AND (WJHasIndicia = 'Y'                                  MD043144
     C                             OR  WkREPT = 'Y')                                        MD043144
     C                             OR  WkCSTY = 'J'                                         MD043144
     C                             AND WkREPT = 'Y'                                         MD043144
     C                             OR WkCSTY = 'N'                                          MD043144
     C                             AND WkCSST = 'AC'                                        MD043144
     C                             AND (WJHasIndicia = 'Y'                                  MD043144
     C                             OR  WkREPT = 'Y')                                        MD043144
     C                             OR WkCSTY = 'O'                                          MD043144
     C                             AND  WkREPT = 'Y'                                        MD043144
     C                             OR WkCSTY = 'F'                                          MD043144
     C                             AND WkCSST = 'OW'                                        MD043144
     C                             AND (WJHasIndicia = 'Y'                                  MD043144
     C                             OR  WkREPT = 'Y')                                        MD043144
     C                             OR WkCSTY = 'N'                                          MD043144
     C                             AND WkCSST = 'PA'                                        MD043144
     C                             AND (WJHasIndicia = 'Y'                                  MD043144
     C                             OR  WkREPT = 'Y')                                        MD043144
                                                                                            MD043144
     C                   EVAL      WJHasSubOwnr = 'Y'                                       MD043144
     C                   ENDIF                                                              MD043144
     C                   ENDIF                                                              MD043144
     C                   ENDIF                                                              MD043144
     C                   ENDIF                                                              MD043144
     C     PSub6         READE     SDCUAHL1                                                 MD043144
     C                   ENDDO                                                              MD043144
     C                   ENDIF                                                              MD043144
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkTINs - Check US Tins                                    *
      *                                                               *
      *****************************************************************
     C     SRChkTINs     BEGSR
 
     C                   IF        EXISCT = PCtry
     C                             OR EXTNC2 = PCtry
     C                             OR EXTNC3 = PCtry
     C                             OR EXTNC4 = PCtry
     C                             OR EXTNC5 = PCtry
 
     C                   EVAL      WHasTINs = 'Y'
     C                   ELSE
     C                   EVAL      WHasTINs = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkTINCS - Check US TINS for Customer                      *
      *                                                               *
      *****************************************************************
     C     SRChkTINCS    BEGSR
 
     C                   IF        E5ISCT = PCtry
     C                             OR E5TNC2 = PCtry
     C                             OR E5TNC3 = PCtry
     C                             OR E5TNC4 = PCtry
     C                             OR E5TNC5 = PCtry
 
     C                   EVAL      WJHasTINs = 'Y'
     C                   ELSE
     C                   EVAL      WJHasTINs = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkTINNH - Check US Tins for Non Account Holders           *
      *                                                               *
      *****************************************************************
     C     SRChkTINNH    BEGSR
 
     C                   IF        NHISCT = PCtry
     C                             OR NHCTN2 = PCtry
     C                             OR NHCTN3 = PCtry
     C                             OR NHCTN4 = PCtry
     C                             OR NHCTN5 = PCtry
 
     C                   EVAL      WJHasTINs = 'Y'
     C                   ELSE
     C                   EVAL      WJHasTINs = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRGetGrpLevl  - Get group level number                        *
      *                                                               *
      *****************************************************************
     C     SRGetGrpLevl  BEGSR
 
     C     KGrpName      CHAIN     GLFXMLL1
     C                   IF        %FOUND(GLFXMLL1)
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
     C                   PARM                    ArPoolType
     C                   PARM                    ArExcCust
     C                   PARM                    ArIncCust
     C                   PARM                    ArExPlCust
 
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
 
      ** Key Field list
 
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
 
     C     KVoid         KLIST
     C                   KFLD                    KMsgNo
     C                   KFLD                    KECus
     C                   KFLD                    KAcno
     C                   KFLD                    KAcho
     C                   KFLD                    KMtyp
 
     C     KVPool        KLIST
     C                   KFLD                    KMsgNo
     C                   KFLD                    KTpElt
 
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
