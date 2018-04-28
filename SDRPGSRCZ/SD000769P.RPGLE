     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Annual Tax Deducted Statement')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000769P - Annual Tax Deducted Statement                    *
      *                                                               *
      *  Function:  This module generates Annual Tax Deducted         *
      *             statement.                                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 AR763011           Date 02Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26728B          Date 26Jan10               *
      *                 BUG26728A          Date 21Jan10               *
      *                 BUG26728           Date 20Nov09               *
      *                 BUG26431           Date 15Oct09               *
      *                 BUG25542           Date 19Aug09               *
      *                 BUG25075           Date 28Jul09               *
      *                 BUG24935           Date 17Jul09               *
      *                 BUG24767           Date 07Jul09               *
      *                 BUG24789           Date 10Jul09               *
      *                 BUG24443A          Date 06Jul09               *
      *                 BUG24280A          Date 19Jun09               *
      *                 BUG24379           Date 17Jun09               *
      *                 BUG24280           Date 10Jun09               *
      *                 BUG23732           Date 23Apr09               *
      *                 BUG24029           Date 20May09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23719           Date 27Apr09               *
      *                 BUG23518B          Date 22Apr09               *
      *                 BUG23789           Date 21Apr09               *
      *                 BUG23518           Date 30Mar09               *
      *                 BUG23514           Date 27Mar09               *
      *                 BUG23123           Date 09Mar09               *
      *                 BUG23408           Date 16Mar09               *
      *                 BUG22797           Date 05Mar09               *
      *                 BUG23147           Date 02Mar09               *
      *                 BUG22580           Date 02Feb09               *
      *                 CER048             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 237337             Date 03Oct06               *
      *                 CSD027A            Date 05May06               *
      *                 234291             Date 27Jun05               *
      *                 236129             Date 27Sep05               *
      *                 232543             Date 01Apr05               *
      *                 CGL035             Date 01Mar05               *
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  AR763011 - Annual Tax Deducted Statement showed incorrect    *
      *             totals.                                           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG26728B - Last customer process is repeated in member list *
      *  BUG26728A - In the Annual Tax Deducted Statement Report the  *
      *              threshold of one member is listed / included in  *
      *              the other member's details; duplicate information*
      *              in another member s details are shown            *
      *  BUG26728 - Duplicate information on  member details          *
      *  BUG26431 - Missing decimal value of Third tax in tax ccy     *
      *             in SD000769P1 Annual Tax Deducted                 *
      *  BUG25542 - Joint Members should be identified                *
      *  BUG25075 - Correct interest period printed on report         *
      *  BUG24935 - Limit Utilisation Report shows a minus            *
      *             figure/incorrect Threshold Excess                 *
      *  BUG24767 - Cannot request annual tax deducted statement      *
      *  BUG24789 - Church Tax Change Request 008.                    *
      *             Remove extraction of Interest Rate from           *
      *             Annual Tax Deducted Stmt. Reason as follows:      *
      *             For Retail, the problem is that for tiered or     *
      *             threshold, a single rate may not reflect the      *
      *             interest amount.                                  *
      *             NOTE : In the event that this removal become      *
      *             a concern for clients, do the following:          *
      *             (1) RPG/CG006110 - reinstate line "EXSR           *
      *                 SrIntRate"                                    *
      *             (2) RPG/SD000769P - reinstate line "EXSR          *
      *                 SrIntRate" and populate RINRT with WINRT.     *
      *             (3) PRTF/SD000769P1 - reinstate label "Interest   *
      *                 Rate" and associated print field RINRT.       *
      *  BUG24443A- Interest rate showing as zero due to DL           *
      *             transactions already historic. Need to cover      *
      *             historic Dealing files as well. Also replace      *
      *             fields to use for Interest Rate :                 *
      *             (1) replace RTSP with INTR (for dealing)          *
      *             (2) replace CCIR with CRIR (for retail)           *
      *             Move Interest Rate calculation to a separate      *
      *             subroutine (in prep for Change Request 008).      *
      *  BUG24280A - Value of Current Threshold is incorrect          *
      *  BUG24379 - Inconsitencies in decimal places for 3rd Tax and  *
      *             Totals in Annual Tax Deducted Stmt                *
      *  BUG24280 - Enquiries/Reports should be amended to get data if*
      *             start and end of tax year in same year            *
      *  BUG23732 - Joint Account threshold (Recompile)               *
      *  BUG24029 - COB Error RE3662 Database Error                   *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23719 - Annual Tax Deducted Statement shows incorrect     *
      *             amounts                                           *
      *  BUG23518B - Annual Tax Deducted Statement not produced       *
      *  BUG23789 - Pointer not set for location referenced           *
      *  BUG23518 - Produce Annual Tax Deducted Statement upon        *
      *             Customer Closure                                  *
      *  BUG23514 - Some fields did not follow the requirement in FS  *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  BUG23408 - Annual tax deducted statement needs adjustment    *
      *  BUG22797 - Added Prompt Fields and Refresh Function          *
      *  BUG23147 - DBASE error on component SDC000769                *
      *  BUG22580 - Fields incorrectly labeled and lengths (Recompile)*
      *  CER048 - German Features - Taxes                             *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  237337 - Avoid database error if customer deleted.           *
      *  CSD027A - Conversion Of Customer Number to Alpha (recompile) *
      *  234291 - Printer file overflow.  Check for overflow before   *
      *           writing detail line.                                *
      *  236129 - Dump if customer is closed                          *
      *  232543 - Fix to CGL031 (Recompile)                           *
      *  CGL035 - EUSD Upgrade to MidasPlus                           *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators.                                           *
      *    01         End of file SDCSINL2/SDCSINL3                   *
      *    02         Process SDCSINL2                                *
      *    03         Process SDCSINL3                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *  *PSSR  - Program exception error routine                     *
      *  SRProcess - Process Records                                  *
      *  SRStrFld - Store Report Fields                               *
      *  SRRefNum - Store Reference Number for Validatio              *
      *  SRPrint - Print Report                                       *
      *  SRPrtCcyTot - Print Total for Currency                       *
      *  SRPrtCusTot - Print Total for Customer                       *
      *  SRZSEditF - Convert numeric field                            *
      *  SREnd - Write Trailer in Report                              *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** SD Customer Income - Customer Number
     F***SDCSINL2  IF   E           K DISK    INFSR(*PSSR)                                  BUG25075
     F***SDCSINLI  IF   E           K DISK    INFSR(*PSSR)                        BUG25075 BUG26728A
     FSDCSINLK  IF   E           K DISK    INFSR(*PSSR)                                    BUG26728A
 
      ** SD Customer Income - Non A/c Holder Reference
     FSDCSINL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCSIND0:SDCSIND3)
 
      ** SD Joint Account Members Audit List - Detail
     FSD000769P1O    E             PRINTER INFDS(SPOOL1)
     F                                     USROPN
     F                                     INFSR(*PSSR)
 
      ** SD Joint Account Members Audit List - Audit
     FSD000769AUO    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
     F                                     INFSR(*PSSR)
      *                                                                                       CER048
      ** Midas Local Tax Office File Retrieve Index                                           CER048
      *                                                                                       CER048
     FSDLTOFL1  IF   E           K DISK                                                       CER048
      *                                                                                       CER048
      ** Midas Interest Payment History File Retrieve Index                                   CER048
      *                                                                                       CER048
     FSDINPHL1  IF   E           K DISK                                                       CER048
      *                                                                                     BUG25542
      ** Midas Interest Payment History File by Joint Customer                              BUG25542
      *                                                                                     BUG25542
     FSDINPHL3  IF   E           K DISK                                                     BUG25542
     F                                     RENAME(SDINPHD0:SDINPHD3)                        BUG25542
     F                                     PREFIX(J)                                        BUG25542
      *                                                                                       CER048
      ** Midas Exemption Threshold History File Retrieve Index                                CER048
      *                                                                                       CER048
     FSDTHRHL1  IF   E           K DISK                                                       CER048
      *                                                                                       CER048
      ***Midas*DL*Deals*File**************                                          CER048 BUG24443A
      *************                                                                 CER048 BUG24443A
     F***DEALS*****IF   E           K DISK                                          CER048 BUG24443A
      *************                                                                 CER048 BUG24443A
      ***Midas*GL*Account*Master*File*****                                          CER048 BUG24443A
      *************                                                                 CER048 BUG24443A
     F***ACCNT*****IF   E           K DISK                                          CER048 BUG24443A
      *                                                                                    BUG24443A
      ** Midas DL file (includes historic deals)                                           BUG24443A
      *                                                                                    BUG24443A
     FDEALSALL  IF   E           K DISK    IGNORE(MMDELDP0)                                BUG24443A
     F                                     IGNORE(MMDENBP0)                                BUG24443A
     F                                     IGNORE(MMDENSP0)                                BUG24443A
     F                                     IGNORE(FXDEALP0)                                BUG24443A
      *                                                                                    BUG24443A
      ** Retail History file                                                               BUG24443A
      *                                                                                    BUG24443A
     FREHISDL   IF   E           K DISK                                                    BUG24443A
      *                                                                                     BUG23518
      ** Midas SD Customer Details Retrieval Index                                          BUG23518
      *                                                                                     BUG23518
     FSDCUSTL1  IF   E           K DISK                                                     BUG23518
      *                                                                                     BUG26728
      ** Midas SD Joint Account Member Details                                              BUG26728
      *                                                                                     BUG26728
     FSDJACCL4  IF   E           K DISK                                                     BUG26728
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for Customer Number
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** Externally described DS for Non A/c Holder Reference
     D SDNAHO        E DS                  EXTNAME(SDNAHOPD)
 
      ** Externally described DS for SD Currency Codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for Location details                                       BUG24767
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                BUG24767
                                                                                            BUG24767
      ** Externally described DS for Country code details                                   BUG24767
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                                BUG24767
                                                                                            BUG24767
      ** DS for access objects - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access objects - long  data structure                                         236129
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     236129
      *                                                                                       CER048
      ** External DS for SAR Details                                                          CER048
      *                                                                                       CER048
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER048
      *                                                                                       CER048
      ** First DS for Access Programs, short Data Structure                                   CER048
      *                                                                                       CER048
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CER048
 
      ** File Information Data Structure for SD000763P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for SD000763AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Input DS
     D PData           DS           100
     D  PClose                 1      1                                                     BUG23789
     D  PTaxYr                 1      4
     D  PTaxYrF                5      8                                                     BUG22797
     D  PTaxYrT                9     12                                                     BUG22797
     D  PCust                 13     18                                                     BUG22797
     D  PCustF                19     24                                                     BUG22797
     D  PCustT                25     30                                                     BUG22797
     D  PYear                 31     32A                                                    BUG24935
 
      ** Interest Payt Date - variable for conversion
     D WIPDte          DS             8
     D  WIPYY                  3      4
     D  WIPMM                  5      6
     D  WIPDD                  7      8
 
      ** Interest Payt Date - 6A format
     D WIPDte6         DS             6
     D  WIPChr1                1      2
     D  WIPChr2                3      4
     D  WIPChr3                5      6
      *                                                                                       CER048
     D WInpe           DS             6                                                       CER048
     D**WInpy***               1      4                                              CER048 BUG23514
     D**WInpm***               5      6                                              CER048 BUG23514
     D  WInpd                  1      2                                                     BUG23514
     D  WInpm                  3      4                                                     BUG23514
     D  WInpy                  5      6                                                     BUG23514
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Parameters for access object programs
     D PRtcd           S              7
     D POptn           S              7
     D PKey            S              7
     D PSARd           S              6
     D PCustNo         S             10
     D PCcy            S              3
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for ZSEDITF
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PECode          S              1
     D PEChar          S              1
     D POut21          S             21
 
      ** Parameter list fields
     D PLev            S              1
     D*PClose***       S              1A                                           BUG23518 BUG23789
     D PEnty           S              3
     D PACT            S              1
     D PCMD            S              1
 
      ** Total for Currency
     D WTPAM           S             15  0
     D WTGIN           S             15  0
     D WTTXS           S             15  0
     D WTTXC           S             15  0
 
      ** Total for Customer
     D WCPAM           S             15  0
     D WCGIN           S             15  0
     D WCTXS           S             15  0
     D WCTXC           S             15  0
     D WPAMS           S                   LIKE(TSPAMS)                                     AR763011
     D WPAMB           S                   LIKE(TSPAMB)                                     AR763011
 
      ** Other fields used / Flags
     D WRun            S              1
     D WDecs           S              1  0
     D WNoRec          S              5S 0 INZ(0)
     D WDlLN           S              6
     D*WACod***        S              4                                                       CGL035
     D WACod           S             10                                                       CGL035
     D WAcSq           S              2
     D WCcy            S              3
     D WCcyEdt         S              3
     D WTaxCcy         S              3
     D WRefNo          S             10
     D WRefYr          S              4  0                                                  BUG22797
     D WChkNo          S             10
     D WTaxYr          S              4  0
     D WTaxYrF         S              4  0                                                  BUG22797
     D WTaxYrT         S              4  0                                                  BUG22797
     D WCust           S              6                                                     BUG22797
     D WCustF          S              6                                                     BUG22797
     D WCustT          S              6                                                     BUG22797
     D*WNCust***       S              6S 0                                         BUG26728A  CER059
     D*WNCustF**       S              6S 0                                         BUG26728A  CER059
     D*WNCustT**       S              6S 0                                         BUG26728A  CER059
     D WNCust          S              6                                                       CER059
     D WNCustF         S              6                                                       CER059
     D WNCustT         S              6                                                       CER059
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D WINRT           S             11S 7                                                  BUG24789
 
     D WCcyFlg         S              1
     D WFirst          S              1
     D WRecFnd         S              1
     D WLRecFnd        S              1                                                   BUG24280A
     D WRec            S              1                                                   BUG24280A
     D WYr             S              2A                                                    BUG24767
     D WYrP            S              2P 0                                                  BUG24767
     D WYrEnd          S              6A                                                    BUG24767
     D WYrEndP         S              5P 0                                                  BUG24767
     D PLoc            S              3A                                                    BUG24767
     D PCtry           S              2A                                                    BUG24767
      *                                                                                       CER048
      ** Declaration of variables for Taxes Details                                           CER048
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
     D PZDayNo         S              5P 0                                                    CER048
     D PZDate          S              6P 0                                                    CER048
     D PZDate1         S              8S 0                                                    CER048
     D PZADate         S              7A                                                      CER048
     D PZDatfm         S              1A                                                      CER048
     D*KFCust**********S              6S 0                                          CER048 BUG24443A
     D KyBrca          S              3A                                                   BUG24443A
     D*KyCust***       S              6S 0                                          BUG24443A CER059
     D KyCust          S              6A                                                   BUG24443A
     D KyCNUM          S              6A                                                   BUG26728A
     D*KyJOIN***       S              6S 0                                          BUG26728A CER059
     D KyJOIN          S              6A                                                      CER059
     D KyCcy           S              3A                                                   BUG24443A
     D KyAcod          S             10S 0                                                 BUG24443A
     D KyAcsq          S              2S 0                                                 BUG24443A
     D KyHisd          S              5P 0                                                 BUG24443A
     D KIJOIN          S              6A                                                   BUG26728A
     D KICUST          S              6A                                                   BUG26728A
     D PErrorFlag      S              1A                                                      CER048
     D CER054          S              1A                                                      CER054
     D WPrntCcTot      S              1A                                                   BUG23518B
     D WPrntCuTot      S              1A                                                   BUG23518B
     D*WJOIN****       S              6S 0                                          BUG26728A CER059
     D WJOIN           S              6A                                                      CER059
     D WCJOIN          S              6A                                                   BUG26728A
     D WCNUM           S              6A                                                   BUG26728A
      *                                                                                       CER048
     D WStaxYr         S              6P 0                                                  BUG24280
     D WStaxYrA        S              6A                                                    BUG24280
     D WDdMm           S              4A                                                    BUG24280
     D WEtaxYr         S              6P 0                                                  BUG24280
     D WSYear          S              5P 0                                                  BUG24280
     D WEYear          S              5P 0                                                  BUG24280
     D TYear           S              4P 0                                                  BUG24280
     D WYear           S              2P 0                                                  BUG24280
     D WJeyd           S              5P 0                                                  BUG24280
     D WSYeaRS         S              2P 0                                                  BUG24280
     D WEYeaRE         S              2P 0                                                  BUG24280
     D WwYr            S              2P 0                                                  BUG24280
      *                                                                                     BUG24280
     D PDateIn         S              6A                                                    BUG24280
     D PErr            S              1A                                                    BUG24280
      *                                                                                     BUG24280
     D XTSCUST         S              6A                                                    BUG25542
     D YTSCUST         S              6A                                                    BUG26728
      *                                                                                    BUG26728B
     D WTSJOIN         S              6A                                                   BUG26728B
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Store input parameter tax year.
 
     C                   MOVE      PTaxYR        WTaxYr
     C                   MOVE      PTaxYrF       WTaxYrF                                    BUG22797
     C                   MOVE      PTaxYrT       WTaxYrT                                    BUG22797
     C                   MOVE      PCust         WCust                                      BUG22797
     C                   MOVE      PCustF        WCustF                                     BUG22797
     C                   MOVE      PCustT        WCustT                                     BUG22797
     C                   MOVE      PCust         WNCust                                    BUG26728A
     C                   MOVE      PCustF        WNCustF                                   BUG26728A
     C                   MOVE      PCustT        WNCustT                                   BUG26728A
     C                   EVAL      WPrntCuTot = 'N'                                        BUG23518B
     C                   EVAL      WPrntCcTot = 'N'                                        BUG23518B
     C**********         EVAL      RTAXY = WTaxYr                                           BUG22797
 
      ** Process Details normally when not mandatory run                                    BUG23518
      *                                                                                     BUG23518
     C                   IF        PClose = 'Y'                                             BUG23518
      *                                                                                     BUG23518
     C                   EXSR      SRProcClos                                               BUG23518
      *                                                                                     BUG23518
     C                   ELSE                                                               BUG23518
      *                                                                                     BUG23518
      ** Process customer details.
 
     C                   EVAL      *IN02 = *ON
     C                   EXSR      SRProcess
 
      ** Process non a/c holder details.
 
     C                   EVAL      *IN02 = *OFF
     C                   EVAL      *IN03 = *ON
     C                   EXSR      SRProcess
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
 
      ** Print report trailer and audit report.
 
     C                   EXSR      SREnd
 
      ** Return.
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRProcess - Process Records                                  *
      *****************************************************************
     C     SRPRocess     BEGSR
 
     C                   EVAL      WRecFnd = 'N'
     C                   EVAL      WFirst = 'Y'
     C                   EVAL      WLRecFnd = 'N'                                          BUG24280A
     C                   EVAL      WRec = 'N'                                              BUG24280A
 
     C                   IF        *IN02 = *ON
     C******LOVAL        SETLL     SDCSINL2                                                 BUG25075
     C**********         READ      SDCSINL2                               01                BUG25075
     C******LOVAL        SETLL     SDCSINLI                                       BUG25075 BUG26728A
     C**********         READ      SDCSINLI                               01      BUG25075 BUG26728A
     C     *LOVAL        SETLL     SDCSINLK                                                BUG26728A
     C                   READ      SDCSINLK                               01               BUG26728A
     C                   ENDIF
 
     C                   IF        *IN03 = *ON
     C     *LOVAL        SETLL     SDCSINL3
     C                   READ      SDCSINL3                               01
     C                   ENDIF
 
     C                   EVAL      WCcyFlg = 'Y'
     C                   EVAL      WCcy = TSSCCY
 
     C                   EXSR      SRRefNum
      *                                                                                     BUG25075
     C                   MOVEL     *BLANKS       RefInst          34                        BUG25075
     C                   MOVEL     *BLANKS       RefModi           1                        BUG25075
     C                   Z-ADD     *ZEROS        RefAcod          10 0                      BUG25075
 
     C                   DOW       *IN01 = *OFF
 
     C                   EVAL      WCNUM  = TSCUST                                         BUG26728A
     C                   EVAL      WRecFnd = 'N'                                            BUG22797
                                                                                            BUG22797
      ** Select record with status = 'T' (Taxable)
      ** and Tax Year (file) = Tax Year (input parameter)
 
     C**********         IF        TSSTAT = 'T' AND                                         BUG22797
     C**********                   TSTAXY = WTaxYr                                          BUG22797
 
     C                   SELECT                                                             BUG22797
                                                                                            BUG22797
      ** When Input is a specific year                                                      BUG22797
     C                   WHEN      WTaxYr <> *ZEROS   AND                                   BUG22797
     C**********                   TSTAXY = WtaxYr AND                             BUG22797 BUG24280
     C                             TSRDNB >= WSYear AND                                     BUG24280
     C                             TSRDNB <= WEYear AND                                     BUG24280
     C                             TSSTAT = 'T'                                             BUG22797
     C                   EVAl      RTAXY = WtaxYr                                           BUG22797
     C                   EVAL      *IN52 = *OFF                                             BUG23514
     C**********         EVAL      WRecFnd = 'Y'                                            BUG22797
     C                   EXSR      SrValCust                                                BUG22797
 
      ** Check if there is a change on currency code
      ** If true, print total for currency
 
     C**********         IF        TSSCCY <> WCcy                                           BUG22797
     C**********                   AND WFirst <> 'Y'                                        BUG22797
     C**********         EVAL      WCcyFlg = 'Y'                                            BUG22797
     C**********         EXSR      SRPrtCcyTot                                              BUG22797
     C**********         ENDIF                                                              BUG22797
 
      ** Check if there is a change on customer no. / non a/c holder
      ** If true, print total for customer / non a/c holder
 
     C**********         IF        *IN02 = *ON                                              BUG22797
     C**********         EVAL      WChkNo = %TRIM(TSCUST)                                   BUG22797
     C**********         ELSE                                                               BUG22797
     C**********         EVAL      WChkNo = %TRIM(TSNAHO)                                   BUG22797
     C**********         ENDIF                                                              BUG22797
 
     C**********         IF        WChkNo <> WRefNo AND                                     BUG22797
     C**********                   WRefNo <> *BLANKS AND                                    BUG22797
     C**********                   WFirst <> 'Y'                                            BUG22797
 
      ** Print total for currency if there is a change on
      ** customer no. / non a/c holder but no change on ccy code
 
     C**********         IF        TSSCCY = WCcy                                            BUG22797
     C**********         EVAL      WCcyFlg = 'Y'                                            BUG22797
     C**********         EXSR      SRPrtCcyTot                                              BUG22797
     C**********         ENDIF                                                              BUG22797
 
     C**********         EXSR      SRPrtCusTot                                              BUG22797
     C**********         ENDIF                                                              BUG22797
 
     C**********         EXSR      SRStrFld                                                 BUG22797
     C**********         EVAL      WCcy = TSSCCY                                            BUG22797
     C**********         EXSR      SRRefNum                                                 BUG22797
 
      ** Compute number of total records printed.
 
     C**********         EVAL      WNoRec = WNoRec + 1                                      BUG22797
 
     C**********         ENDIF                                                              BUG22797
      ** When Input is a period                                                             BUG22797
     C**********         WHEN      WTaxYrF <= TSTAXY AND                           BUG22797 BUG24280
     C**********                   TSTAXY <= WTaxYrT AND                           BUG22797 BUG24280
     C                   WHEN      WTaxYrF <> *ZEROS AND                                    BUG24280
     C                             WTaxYrT <> *ZEROS AND                                    BUG24280
     C                             TSRDNB >= WSYear AND                                     BUG24280
     C                             TSRDNB <= WEYear AND                                     BUG24280
     C                             TSSTAT = 'T'                                             BUG22797
     C**********         EVAL      RTAXY = TSTAXY                                  BUG22797 BUG23514
     C                   EVAL      *IN52 = *ON                                              BUG23514
     C                   EVAL      RTAXY = WTaxYrF                                          BUG23514
     C                   EVAL      RXO = '-'                                                BUG23514
     C                   EVAL      RTAXY2 = WTaxYrT                                         BUG23514
     C                   EXSR      SRValCust                                                BUG22797
                                                                                            BUG22797
     C                   END                                                                BUG22797
 
     C                   IF        *IN02 = *ON
     C**********         READ      SDCSINL2                               01                BUG25075
     C**********         READ      SDCSINLI                               01      BUG25075 BUG26728A
     C                   READ      SDCSINLK                               01               BUG26728A
     C                   ENDIF
 
     C                   IF        *IN03 = *ON
     C                   READ      SDCSINL3                               01
     C                   ENDIF
 
     C                   IF        WCust <> *BLANKS AND                                     BUG22797
     C                             TSCUST > WCust                                           BUG22797
     C                   EVAL      *IN01 = *ON                                              BUG22797
     C                   ENDIF                                                              BUG22797
     C                   ENDDO
 
     C                   IF        WRecFnd = 'N' AND                                       BUG24280A
     C                             WLRecFnd = 'Y'                                          BUG24280A
     C                   EVAL      WRec = 'Y'                                              BUG24280A
     C                   ELSE                                                              BUG24280A
     C                   EVAL      WRec = 'N'                                              BUG24280A
     C                   ENDIF                                                             BUG24280A
      *                                                                                    BUG24280A
     C                   IF        WRecFnd = 'Y'
     C                             OR WRec = 'Y'                                           BUG24280A
     C                   EXSR      SRPrtCcyTot
     C                   EXSR      SRPrtCusTot
     C                   EVAL      WLRecFnd = 'N'                                          BUG24280A
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                BUG22797
      *****************************************************************                     BUG22797
      *  SRValCust - Validate Customer based on User Input            *                     BUG22797
      *****************************************************************                     BUG22797
     C     SRValCust     BEGSR                                                              BUG22797
                                                                                            BUG22797
     C                   SELECT                                                             BUG22797
                                                                                            BUG22797
      **  When User did not specify a customer                                              BUG22797
     C                   WHEN      WCust = *Blanks AND                                      BUG22797
     C                             WCustF = *Blanks  AND                                    BUG22797
     C                             WCustT = *Blanks                                         BUG22797
     C                   EVAL      WRecFnd = 'Y'                                            BUG22797
                                                                                            BUG22797
      **  When user specified a specific customer to report                                 BUG22797
     C                   WHEN      WCust <> *BLANKS AND                                     BUG22797
     C                             TSCUST = WCust                                           BUG22797
     C                             OR TSJOIN = WNCust                                      BUG26728A
     C                   EVAL      WRecFnd = 'Y'                                            BUG22797
                                                                                            BUG22797
                                                                                            BUG22797
      **  When user gave a range of customers                                               BUG22797
     C                   WHEN      WCust = *Blanks AND                                      BUG22797
     C**********                   WCustF <= TSCUST AND                           BUG22797 BUG26728A
     C                             (WCustF <= TSCUST AND                                   BUG26728A
     C                             TSCUST <= WCustT                                         BUG22797
     C                             OR  WNCustF <= TSJOIN                                   BUG26728A
     C                             AND TSJOIN  <= WNCustT)                                 BUG26728A
     C                   EVAL      WRecFnd = 'Y'                                            BUG22797
                                                                                            BUG22797
     C                   END                                                                BUG22797
                                                                                            BUG22797
     C                   IF        WRecFnd <> 'Y'                                           BUG22797
     C                   LEAVESR                                                            BUG22797
     C                   ENDIF                                                              BUG22797
      ** Check if there is a change on currency code                                        BUG22797
      ** If true, print total for currency                                                  BUG22797
                                                                                            BUG22797
     C                   IF        TSSCCY <> WCcy                                           BUG22797
     C                             AND WFirst <> 'Y'                                        BUG22797
     C                   EVAL      WCcyFlg = 'Y'                                            BUG22797
     C                   EXSR      SRPrtCcyTot                                              BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
      ** Check if there is a change on customer no. / non a/c holder                        BUG22797
      ** If true, print total for customer / non a/c holder                                 BUG22797
                                                                                            BUG22797
     C                   IF        *IN02 = *ON                                              BUG22797
     C                   EVAL      WChkNo = %TRIM(TSCUST)                                   BUG22797
     C                   ELSE                                                               BUG22797
     C                   EVAL      WChkNo = %TRIM(TSNAHO)                                   BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   IF        WChkNo <> WRefNo AND                                     BUG22797
     C                             WRefNo <> *BLANKS AND                                    BUG22797
     C                             WFirst <> 'Y'                                            BUG22797
                                                                                            BUG22797
      ** Print total for currency if there is a change on                                   BUG22797
      ** customer no. / non a/c holder but no change on ccy code                            BUG22797
                                                                                            BUG22797
     C                   IF        TSSCCY = WCcy                                            BUG22797
     C                   EVAL      WCcyFlg = 'Y'                                            BUG22797
     C                   EXSR      SRPrtCcyTot                                              BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   EXSR      SRPrtCusTot                                              BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   IF        WChkNo =  WRefNo AND                                     BUG22797
     C                             WRefNo <> *BLANKS AND                                    BUG22797
     C                             WFirst <> 'Y' AND                                        BUG22797
     C                             WRefYr <> RTAXY                                          BUG22797
                                                                                            BUG22797
      ** Print total for currency if there is a change on                                   BUG22797
      ** customer no. / non a/c holder but no change on ccy code                            BUG22797
                                                                                            BUG22797
     C                   IF        TSSCCY = WCcy                                            BUG22797
     C                   EVAL      WCcyFlg = 'Y'                                            BUG22797
     C                   EXSR      SRPrtCcyTot                                              BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   EXSR      SRPrtCusTot                                              BUG22797
     C                   ENDIF                                                              BUG22797
                                                                                            BUG22797
     C                   EXSR      SRStrFld                                                 BUG22797
     C                   EVAL      WCcy = TSSCCY                                            BUG22797
     C                   EXSR      SRRefNum                                                 BUG22797
                                                                                            BUG22797
      ** Compute number of total records printed.                                           BUG22797
                                                                                            BUG22797
     C                   EVAL      WNoRec = WNoRec + 1                                      BUG22797
                                                                                            BUG22797
     C                   ENDSR                                                              BUG22797
      *****************************************************************                     BUG22797
      /EJECT                                                                                BUG22797
      *****************************************************************                     BUG22797
      *  SRRefNum - Store Reference Number for Validation             *
      *****************************************************************
     C     SRRefNum      BEGSR
 
     C                   IF        *IN02 = *ON
     C                   EVAL      WRefNo = %TRIM(TSCUST)
     C                   ELSE
     C                   EVAL      WRefNo = %TRIM(TSNAHO)
     C                   ENDIF
     C                   EVAL      WJOIN  = TSJOIN                                         BUG26728A
 
     C                   EVAL      WRefYr = RTAXY                                           BUG22797
                                                                                            BUG22797
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRStrFld - Store Report Fields                               *
      *****************************************************************
     C     SRStrFld      BEGSR
 
      ** Beneficiary/Customer Number.
 
     C                   EVAL      WLRecFnd = 'Y'                                          BUG24280A
     C**********         IF        TSJOIN <> 0                                      BUG26728A CER059
     C                   IF        TSJOIN <> *Blanks                                          CER059
     C                   MOVEL     TSJOIN        RBENN                                     BUG26728A
     C                   MOVEL     TSJOIN        PCustNo                                   BUG26728A
     C                   ELSE                                                              BUG26728A
     C                   MOVEL     TSCUST        PCustNo                                   BUG26728A
     C                   EVAL      RBENN = WChkNo
     C                   ENDIF                                                             BUG26728A
 
      ** Customer Report Name and Report Town.
 
     C                   IF        *IN02 = *ON
     C**********         CALL      'AOCUSTR0'                                                 236129
     C                   CALL      'AOCUSTR1'                                                 236129
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C**********         PARM      TSCUST        PCustNo                                   BUG26728A
     C                   PARM                    PCustNo                                   BUG26728A
     C                   PARM      *BLANKS       PKey
     C*****SDCUST        PARM      SDCUST        DSSDY                                        236129
     C     SDCUST        PARM      SDCUST        DSLDY                                        236129
 
      ** Database error.
 
     C**********         IF        PRtcd <> *Blanks                                           236129
     C                   IF        PRtcd <> *Blanks and BBCLST <> 'Y'                         236129
     C                             and BBDTDL = 0                                             237337
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFile = 'SDCUSTL1'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RCRNM = BBCRNM
     C                   EVAL      RCRTN = BBCRTN
     C                   ENDIF
 
     C                   ENDIF
 
      ** Non A/c Holder Report Name and Report Town.
 
     C                   IF        *IN03 = *ON
     C                   CALL      'AONAHOR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      TSNAHO        PCustNo
     C*****SDNAHO        PARM      SDNAHO        DSSDY                                      BUG24029
     C     SDNAHO        PARM      SDNAHO        DSLDY                                      BUG24029
 
      ** Database error.
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = PCustNo
     C                   EVAL      DBFile = 'SDNAHOL1'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RCRNM = NHNARN
     C                   EVAL      RCRTN = NHNATW
     C                   ENDIF
     C                   ENDIF
 
      ** Currency Code/Name
 
     C                   EVAL      RSCCY = TSSCCY
 
     C                   EVAL      WCcyEdt = TSSCCY
     C                   EXSR      SRGetCcyF
     C                   EVAL      RCYNM = A6CYNM
 
      ** Interest Payment Date
 
     C                   EVAL      WIPDte = TSIPDT
     C                   IF        BJDFIN = 'D'
     C                   EVAL      WIPChr1 = WIPDD
     C                   EVAL      WIPChr2 = WIPMM
     C                   EVAL      WIPChr3 = WIPYY
     C                   ELSE
     C                   EVAL      WIPChr1 = WIPMM
     C                   EVAL      WIPChr2 = WIPDD
     C                   EVAL      WIPChr3 = WIPYY
     C                   ENDIF
 
     C                   EVAL      RIPDT = WIPDte6
 
      ** Module Id
 
     C                   EVAL      RMODI =  TSMODI
 
      ** Transaction Type
 
     C                   SELECT
     C                   WHEN      TSMODI = 'D'
     C                   MOVE      TSDLLN        WDlLN
     C                   EVAL      RTTYP = TSTRTP + ' ' + TSTRST +
     C                                     ' ' + WDlLN
 
     C**********         WHEN      TSMODI = 'R'                                            BUG26728A
     C                   WHEN      TSMODI = 'G'                                            BUG26728A
     C                   MOVE      TSACOD        WACod
     C                   MOVE      TSACSQ        WAcSq
     C                   EVAL      RTTYP =  WACod + ' ' + WAcSq
 
     C                   WHEN      TSMODI = 'S'
     C                   EVAL      RTTYP =  TSSESN + ' ' + TSETYP
     C                   ENDSL
 
      ** Principal Amount
 
     C                   EVAL      WCcyEdt = TSSCCY
     C                   IF        TSMODI  = 'G'                                            AR763011
     C                   EVAL      WPAMS  =  %ABS(TSPAMS)                                   AR763011
     C                   EVAL      WPAMB  =  %ABS(TSPAMB)                                   AR763011
     C                   ELSE                                                               AR763011
     C                   EVAL      WPAMS  =  TSPAMS                                         AR763011
     C                   EVAL      WPAMB  =  TSPAMB                                         AR763011
     C                   ENDIF                                                              AR763011
     C**********         EVAL      PFld15 =  TSPAMS                                         AR763011
     C                   EVAL      PFld15 =  WPAMS                                          AR763011
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RPAMS
 
     C**********         EVAL      WTPAM = WTPAM + TSPAMS                                   AR763011
     C                   EVAL      WTPAM = WTPAM + WPAMS                                    AR763011
     C**********         EVAL      WCPAM = WCPAM + TSPAMB                                   AR763011
     C                   EVAL      WCPAM = WCPAM + WPAMB                                    AR763011
 
      ** Gross Interest Amount
 
     C                   EVAL      WCcyEdt = TSSCCY
     C                   EVAL      PFLd15 =  TSGINS
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RGINS
 
     C**********         IF        TSPAMS < 0                                      BUG23719 AR763011
     C**********         Z-SUB     TSGINS        TSGINS                            BUG23719 AR763011
     C**********         Z-SUB     TSGINB        TSGINB                            BUG23719 AR763011
     C**********         ENDIF                                                     BUG23719 AR763011
     C                   EVAL      WTGIN = WTGIN + TSGINS
     C                   EVAL      WCGIN = WCGIN + TSGINB
 
      ** Tax Withheld at Source in Original Currency
 
     C                   EVAL      WCcyEdt = TSSCCY
     C                   EVAL      PFLd15 =  TSTXSR
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RTXSR
 
     C                   EVAL      WTTXS = WTTXS + TSTXSR
     C                   EVAL      WCTXS = WCTXS + TSTXSB
 
      ** Exchage Rate
 
     C                   EVAL      RXRST =  TSXRST
 
      ** Tax Withheld at Source in Tax Currency
 
     C                   EVAL      WTaxCcy = TSTXCY
     C                   EVAL      WCcyEdt = TSTXCY
     C                   EVAL      PFLd15 =  TSTXSC
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RTXSC
 
     C                   EVAL      WTTXC = WTTXC + TSTXSC
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EXSR      SRThdTDet                                                  CER054
     C                   EVAL      WTTXS = WTTXS + TSTTDO                                     CER054
     C                   EVAL      WCTXS = WCTXS + TSTTDB                                     CER054
     C                   EVAL      WTTXC = WTTXC + TSTTDT                                     CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER048
      ** To Store Report Fields                                                               CER048
      *                                                                                       CER048
     C                   IF        CER048 = 'Y'                                               CER048
     C                   EXSR      SRTaxDet                                                   CER048
     C                   EVAL      WTTXS = WTTXS + TSSTDO                                     CER048
     C                   EVAL      WCTXS = WCTXS + TSSTDB                                     CER048
     C                   EVAL      WTTXC = WTTXC + TSSTDT                                     CER048
     C                   ENDIF                                                                CER048
 
      ** Print report
 
     C                   EXSR      SRPrint
 
      ** Clear report fields
 
     C                   EVAL      RIPDT = *BLANKS
     C                   EVAL      RMODI = *BLANKS
     C                   EVAL      RTTYP = *BLANKS
     C                   EVAL      RPAMS = *BLANKS
     C                   EVAL      RGINS = *BLANKS
     C                   EVAL      RTXSR = *BLANKS
     C                   EVAL      RTXSC = *BLANKS
     C                   EVAL      RXRST =  *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPrint - Print Report                                       *
      *****************************************************************
     C     SRPrint       BEGSR
 
     C                   IF        NOT %OPEN(SD000769P1)
     C                   OPEN      SD000769P1
 
      ** Ensure Detail Spool File recorded by RCF
 
     C                   EVAL      ZSnum = SFNUM1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILE1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report.
 
     C                   IF        DifLn1 <= RqdLn1 OR
     C                             WFirst = 'Y'
     C                   WRITE     HEADP1
     C**********         EVAL      WFirst = 'N'                                             BUG25542
     C                   ENDIF
                                                                                            BUG25542
      ** If joint customer, the 1st entry on the report will be the                         BUG25542
      ** main joint customer                                                                BUG25542
                                                                                            BUG25542
     C                   IF        WFirst = 'Y'                                             BUG25542
      *                                                                                    BUG26728B
     C                   IF        *IN02                                                   BUG26728B
      *                                                                                    BUG26728B
     C                                                                                      BUG26728
     C                   MOVEL     TSCUST        YTSCUST                                    BUG26728
      *                                                                                     BUG26728
     C     YTSCUST       CHAIN     SDJACCL4                                                 BUG26728
     C                   IF        %FOUND(SDJACCL4)                                         BUG26728
     C**********                   AND TSJOIN <> 0                                  BUG26728A CER059
     C                             AND TSJOIN <> *Blanks                                      CER059
     C                   MOVE      JCJANO        XTSCUST                                    BUG26728
     C                   ELSE                                                               BUG26728
     C                   MOVE      TSCUST        XTSCUST                                    BUG26728
     C                   ENDIF                                                              BUG26728
                                                                                            BUG26728
     C**********         IF        TSJOIN > *ZERO                                  BUG25542 BUG26728
     C**********         MOVE      TSJOIN        XTSCUST                           BUG25542 BUG26728
     C**********         ELSE                                                      BUG25542 BUG26728
     C**********         MOVE      TSCUST        XTSCUST                           BUG25542 BUG26728
     C**********         ENDIF                                                     BUG25542 BUG26728
     C     XTSCUST       CHAIN     SDINPHL1                                                 BUG25542
     C                   IF        %FOUND(SDINPHL1)                                         BUG25542
      *                                                                                     BUG25542
     C                   EVAL      PFld15 = TIUTTH                                          BUG25542
     C                   EVAL      WCcyEdt = BJCYCD                                         BUG25542
     C                   EXSR      SRZSEditF                                                BUG25542
     C                   MOVE      POut21        RUTTH                                      BUG25542
     C                   EVAL      PECode = 'J'                                             BUG25542
     C                   EVAL      PEChar = *BLANKS                                         BUG25542
     C                   EVAL      POUT21 = *ZERO                                           BUG25542
                                                                                            BUG25542
     C                   CALLB     'ZSEDITF'                                                BUG25542
     C                   PARM      TICUTH        PFld15                                     BUG25542
     C                   PARM      0             PDecs                                      BUG25542
     C                   PARM                    PECode                                     BUG25542
     C                   PARM                    PEChar                                     BUG25542
     C                   PARM                    POut21                                     BUG25542
     C                   MOVE      POut21        RCUTH                                      BUG25542
                                                                                            BUG25542
      ** Customer No and Address Line 1                                                     BUG25542
                                                                                            BUG25542
     C                   CALL      'AOCUSTR1'                                               BUG25542
     C                   PARM      *Blanks       PRtcd                                      BUG25542
     C                   PARM      '*KEY   '     POptn                                      BUG25542
     C                   PARM      TICUST        PCustNo                                    BUG25542
     C                   PARM      *BLANKS       PKey                                       BUG25542
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG25542
     C                   IF        PRtcd <> *Blanks and BBCLST <> 'Y'                       BUG25542
     C                             and BBDTDL = 0                                           BUG25542
     C     *LOCK         IN        LDA                                                      BUG25542
     C                   EVAL      DBKey = PCustNo                                          BUG25542
     C                   EVAL      DBFile = 'SDCUSTL1'                                      BUG25542
     C                   EVAL      DBase = 002                                              BUG25542
     C                   OUT       LDA                                                      BUG25542
     C                   EXSR      *PSSR                                                    BUG25542
     C                   ELSE                                                               BUG25542
     C     BBCUST        CAT       BBCNA1:1      RCRTNM                                     BUG25542
     C                   ENDIF                                                              BUG25542
     C                   IF        TIJOIN <> *BLANKS                                        BUG25542
     C**********                   AND TSJOIN <> 0                                  BUG26728A CER059
     C                             AND TSJOIN <> *Blanks                                      CER059
     C     TIJOIN        CHAIN     SDINPHL3                                                 BUG25542
     C                   IF        %FOUND(SDINPHL3)                                         BUG25542
     C                   EVAL      *IN38 = *ON                                              BUG25542
     C                   WRITE     HEADP2                                                   BUG25542
     C                   EVAL      RqdLn1 = 1                                               BUG25542
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                 BUG25542
     C                   IF        DifLn1 <= RqdLn1                                         BUG25542
     C                   WRITE     HEADP1                                                   BUG25542
     C                   WRITE     HEADP2                                                   BUG25542
     C                   ENDIF                                                              BUG25542
     C                   WRITE     DTLMBR                                                   BUG25542
     C                   DOW       NOT %EOF(SDINPHL3)                                       BUG25542
     C                             AND JTICUST <= TSCUST                                   BUG26728A
     C                   IF        JTICUST <> JTIJOIN                                       BUG25542
                                                                                            BUG25542
      ** Customer No and Address Line 1                                                     BUG25542
                                                                                            BUG25542
     C                   CALL      'AOCUSTR1'                                               BUG25542
     C                   PARM      *Blanks       PRtcd                                      BUG25542
     C                   PARM      '*KEY   '     POptn                                      BUG25542
     C                   PARM      JTICUST       PCustNo                                    BUG25542
     C                   PARM      *BLANKS       PKey                                       BUG25542
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG25542
     C                   IF        PRtcd <> *Blanks and BBCLST <> 'Y'                       BUG25542
     C                             and BBDTDL = 0                                           BUG25542
     C     *LOCK         IN        LDA                                                      BUG25542
     C                   EVAL      DBKey = PCustNo                                          BUG25542
     C                   EVAL      DBFile = 'SDCUSTL1'                                      BUG25542
     C                   EVAL      DBase = 002                                              BUG25542
     C                   OUT       LDA                                                      BUG25542
     C                   EXSR      *PSSR                                                    BUG25542
     C                   ELSE                                                               BUG25542
     C     BBCUST        CAT       BBCNA1:1      RCRTNM                                     BUG25542
     C                   ENDIF                                                              BUG25542
                                                                                            BUG25542
      ** Threshold details                                                                  BUG25542
                                                                                            BUG25542
     C                   EVAL      PFld15 = JTIUTTH                                         BUG25542
     C                   EVAL      WCcyEdt = BJCYCD                                         BUG25542
     C                   EXSR      SRZSEditF                                                BUG25542
     C                   MOVE      POUT21        RUTTH                                      BUG25542
     C                   EVAL      POUT21 = *ZERO                                           BUG25542
     C                   CALLB     'ZSEDITF'                                                BUG25542
     C                   PARM      JTICUTH       PFld15                                     BUG25542
     C                   PARM      0             PDecs                                      BUG25542
     C                   PARM                    PECode                                     BUG25542
     C                   PARM                    PEChar                                     BUG25542
     C                   PARM                    POut21                                     BUG25542
     C                   MOVE      POUT21        RCUTH                                      BUG25542
      *                                                                                     BUG25542
     C                   EVAL      RqdLn1 = 1                                               BUG25542
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                 BUG25542
     C                   IF        DifLn1 <= RqdLn1                                         BUG25542
     C                   WRITE     HEADP1                                                   BUG25542
     C                   WRITE     HEADP2                                                   BUG25542
     C                   ENDIF                                                              BUG25542
     C                   WRITE     DTLMBR                                                   BUG25542
      *                                                                                     BUG25542
     C                   ENDIF                                                              BUG25542
     C*****TSCUST        READE     SDINPHL3                                       BUG25542 BUG26728A
     C     TIJOIN        READE     SDINPHL3                                                BUG26728A
      *                                                                                     BUG25542
     C                   ENDDO                                                              BUG25542
     C                   ENDIF                                                              BUG25542
      *                                                                                     BUG25542
     C                   ELSE                                                               BUG25542
      *                                                                                     BUG25542
     C                   EVAL      *IN38 = *OFF                                             BUG25542
     C                   WRITE     HEADP2                                                   BUG25542
     C                   EVAL      RqdLn1 = 1                                               BUG25542
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                 BUG25542
     C                   IF        DifLn1 <= RqdLn1                                         BUG25542
     C                   WRITE     HEADP1                                                   BUG25542
     C                   WRITE     HEADP2                                                   BUG25542
     C                   ENDIF                                                              BUG25542
     C                   WRITE     DTLMBR                                                   BUG25542
      *                                                                                     BUG25542
     C                   ENDIF                                                              BUG25542
      *                                                                                     BUG25542
     C                   ENDIF                                                              BUG25542
      *                                                                                    BUG26728B
      ** process Non-Account member detail (*IN03 = *ON)                                   BUG26728B
     C                   ELSE                                                              BUG26728B
      *                                                                                    BUG26728B
     C                   EVAL      *IN38 = *OFF                                            BUG26728B
     C                   EVAL      RCRTNM = %TRIM(TSNAHO)                                  BUG26728B
     C                   EVALR     RUTTH  = '0'                                            BUG26728B
     C                   EVALR     RCUTH  = '0'                                            BUG26728B
     C                   EVAL      RqdLn1 = 5                                              BUG26728B
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                BUG26728B
     C                   IF        DifLn1 <= RqdLn1                                        BUG26728B
     C                   WRITE     HEADP1                                                  BUG26728B
     C                   ENDIF                                                             BUG26728B
     C                   WRITE     HEADP2                                                  BUG26728B
     C                   WRITE     DTLMBR                                                  BUG26728B
      *                                                                                    BUG26728B
     C                   ENDIF                                                             BUG26728B
      *                                                                                     BUG25542
     C                   ENDIF                                                              BUG25542
      *                                                                                     BUG25542
     C                   IF        WFirst = 'Y'                                             BUG25542
     C                   EVAL      WCcyFlg = 'Y'                                           BUG26728A
     C                   EVAL      RqdLn1 = 3                                               BUG25542
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                 BUG25542
     C                   IF        DifLn1 <= RqdLn1                                         BUG25542
     C                   WRITE     HEADP1                                                   BUG25542
     C                   ENDIF                                                              BUG25542
     C                   WRITE     HEADP3                                                   BUG25542
     C                   ENDIF                                                              BUG25542
      *                                                                                     BUG25542
     C                   EVAL      WFirst = 'N'                                             BUG25542
      *                                                                                     BUG25542
      ** Print currency code and name
 
     C                   IF        WCcyFlg = 'Y'
     C                   EVAL      WCcyFlg = 'N'
     C                   EVAL      RqdLn1 = 3                                              BUG26728B
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                BUG26728B
     C                   IF        DifLn1 <= RqdLn1                                        BUG26728B
     C                   WRITE     HEADP1                                                  BUG26728B
     C                   WRITE     HEADP3                                                  BUG26728B
     C                   ENDIF                                                             BUG26728B
     C                   WRITE     CCYDET
     C                   ENDIF
      *                                                                                       234291
      ** Check for overflow again before write of detail line                                 234291
      ** If there is, write header first                                                      234291
      *                                                                                       234291
     C                   EVAL      RqdLn1 = 4                                                 234291
     C                   IF        CER048 = 'Y'                                             BUG23408
     C                   EVAl      RqdLn1 = 6                                               BUG23408
     C                   ENDIF                                                              BUG23408
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
     C                   EVAL      RqdLn1 = 8                                                 CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                   234291
      *                                                                                       234291
     C                   IF        DifLn1 <= RqdLn1                                           234291
     C                   WRITE     HEADP1                                                     234291
     C                   WRITE     HEADP3                                                   BUG25542
     C                   ENDIF                                                                234291
 
      ** Print report details
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *****************************************************************                    BUG26728A
      /EJECT                                                                               BUG26728A
      *****************************************************************                    BUG26728A
      *  SRPrtMBrTh - Print Customer threshold                        *                    BUG26728A
      *****************************************************************                    BUG26728A
     C     SRPrtMbrTh    BEGSR                                                             BUG26728A
      *                                                                                    BUG26728B
     C                   IF        *IN02                                                   BUG26728B
                                                                                           BUG26728A
      ** Customer No and Address Line 1                                                    BUG26728A
                                                                                           BUG26728A
     C                   CALL      'AOCUSTR1'                                              BUG26728A
     C                   PARM      *Blanks       PRtcd                                     BUG26728A
     C                   PARM      '*KEY   '     POptn                                     BUG26728A
     C                   PARM      JTICUST       PCustNo                                   BUG26728A
     C                   PARM      *BLANKS       PKey                                      BUG26728A
     C     SDCUST        PARM      SDCUST        DSLDY                                     BUG26728A
     C                   IF        PRtcd <> *Blanks and BBCLST <> 'Y'                      BUG26728A
     C                             and BBDTDL = 0                                          BUG26728A
     C     *LOCK         IN        LDA                                                     BUG26728A
     C                   EVAL      DBKey = PCustNo                                         BUG26728A
     C                   EVAL      DBFile = 'SDCUSTL1'                                     BUG26728A
     C                   EVAL      DBase = 002                                             BUG26728A
     C                   OUT       LDA                                                     BUG26728A
     C                   EXSR      *PSSR                                                   BUG26728A
     C                   ELSE                                                              BUG26728A
     C     BBCUST        CAT       BBCNA1:1      RCRTNM                                    BUG26728A
     C                   ENDIF                                                             BUG26728A
                                                                                           BUG26728A
      ** Threshold details                                                                 BUG26728A
                                                                                           BUG26728A
     C                   EVAL      PFld15 = JTIUTTH                                        BUG26728A
     C                   EVAL      WCcyEdt = BJCYCD                                        BUG26728A
     C                   EXSR      SRZSEditF                                               BUG26728A
     C                   MOVE      POUT21        RUTTH                                     BUG26728A
     C                   EVAL      POUT21 = *ZERO                                          BUG26728A
     C                   CALLB     'ZSEDITF'                                               BUG26728A
     C                   PARM      JTICUTH       PFld15                                    BUG26728A
     C                   PARM      0             PDecs                                     BUG26728A
     C                   PARM                    PECode                                    BUG26728A
     C                   PARM                    PEChar                                    BUG26728A
     C                   PARM                    POut21                                    BUG26728A
     C                   MOVE      POUT21        RCUTH                                     BUG26728A
      *                                                                                    BUG26728A
     C                   EVAL      RqdLn1 = 1                                              BUG26728A
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                BUG26728A
     C                   IF        DifLn1 <= RqdLn1                                        BUG26728A
     C                   WRITE     HEADP1                                                  BUG26728A
     C                   WRITE     HEADP2                                                  BUG26728A
     C                   ENDIF                                                             BUG26728A
     C                   WRITE     DTLMBR                                                  BUG26728A
      *                                                                                    BUG26728B
      ** process Non-Account member detail (*IN03 = *ON)                                   BUG26728B
     C                   ELSE                                                              BUG26728B
      *                                                                                    BUG26728B
     C                   EVAL      *IN38 = *OFF                                            BUG26728B
     C                   EVAL      RCRTNM = %TRIM(TSNAHO)                                  BUG26728B
     C                   EVALR     RUTTH  = '0'                                            BUG26728B
     C                   EVALR     RCUTH  = '0'                                            BUG26728B
     C                   EVAL      RqdLn1 = 5                                              BUG26728B
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1                                BUG26728B
     C                   IF        DifLn1 <= RqdLn1                                        BUG26728B
     C                   WRITE     HEADP1                                                  BUG26728B
     C                   ENDIF                                                             BUG26728B
     C                   WRITE     HEADP2                                                  BUG26728B
     C                   WRITE     DTLMBR                                                  BUG26728B
      *                                                                                    BUG26728B
     C                   ENDIF                                                             BUG26728B
                                                                                           BUG26728A
     C                   ENDSR                                                             BUG26728A
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPrtCcyTot - Print Total for Currency                       *
      *****************************************************************
     C     SRPrtCcyTot   BEGSR
 
     C                   EVAL      RTCCY = RSCCY
     C                   EVAL      WCcyEdt = RSCCY
 
      ** Convert total Principal Amount
 
     C                   EVAL      PFLd15 =  WTPAM
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RTPAM
 
      ** Convert total Gross Interest Amount
 
     C                   EVAL      PFLd15 =  WTGIN
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RTGIN
 
      ** Convert total Tax Withheld in Original Ccy
 
     C                   EVAL      PFLd15 =  WTTXS
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RTTXS
 
      ** Convert total Tax Withheld in Tax Ccy
 
     C                   EVAL      WCcyEdt = WTaxCcy
     C                   EVAL      PFLd15 =  WTTXC
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RTTXC
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** Print the Header of the report if overflow has occurred
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Print total for currency
 
     C                   WRITE     TOTCCY
 
      ** Clear totals
 
     C                   EVAL      RSCCY = *BLANKS
     C                   EVAL      WTPAM = *ZERO
     C                   EVAL      WTGIN = *ZERO
     C                   EVAL      WTTXS = *ZERO
     C                   EVAL      WTTXC = *ZERO
     C                   EVAL      WPrntCcTot = 'Y'                                        BUG23518B
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                     BUG23518
      *  SRProcClos - Process Closed Customer Details                 *                     BUG23518
      *                                                               *                     BUG23518
      *  Called By: MAIN Processing                                   *                     BUG23518
      *                                                               *                     BUG23518
      *  Calls: None                                                  *                     BUG23518
      *                                                               *                     BUG23518
      *****************************************************************                     BUG23518
     C     SRProcClos    BEGSR                                                              BUG23518
      *                                                                                     BUG23518
     C                   EVAL      WRecFnd = 'N'                                            BUG23518
     C                   EVAL      WFirst = 'Y'                                             BUG23518
     C                   EVAL      *IN37 = *ON                                              BUG23518
     C                   EVAL      *IN02 = *ON                                              BUG23518
      *                                                                                     BUG23518
     C     *LOVAL        SETLL     SDCUSTL1                                                 BUG23518
     C                   READ      SDCUSTL1                               70                BUG23518
      *                                                                                     BUG23518
     C                   DOW       *IN70 = *OFF                                             BUG23518
      *                                                                                     BUG23518
     C                   IF        BBCLDT = BJRDNB                                          BUG23518
      *                                                                                     BUG23518
     C*****BBCUST        SETLL     SDCSINL2                                        BUG23518 BUG25075
     C*****BBCUST        READE     SDCSINL2                               01       BUG23518 BUG25075
     C*****BBCUST        SETLL     SDCSINLI                                       BUG25075 BUG26728A
     C*****BBCUST        READE     SDCSINLI                               01      BUG25075 BUG26728A
     C**********         EVAL      KyJOIN = 0                                       BUG26728A CER059
     C                   EVAL      KyJOIN = *Blanks                                           CER059
     C                   EVAL      KyCNUM = BBCUST                                         BUG26728A
     C     KyCSIN        SETLL     SDCSINLK                                                BUG26728A
     C     KyCSIN        READE     SDCSINLK                               01               BUG26728A
      *                                                                                     BUG23518
     C                   DOW       *IN01 = *OFF                                             BUG23518
      *                                                                                     BUG23518
     C                   IF        TSSTAT = 'T'                                             BUG23518
     C                   EVAL      WCcy = TSSCCY                                            BUG23518
     C                   EVAl      RTAXY = TSTAXY                                           BUG23518
     C                   EVAl      WCcyFlg = 'Y'                                            BUG23518
     C                   EVAL      WRecFnd = 'Y'                                            BUG23518
     C                   EXSR      SrValCust                                                BUG23518
     C**********         EVAL      WNoRec = WNoRec + 1                            BUG23518 BUG23518B
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C*****BBCUST        READE     SDCSINL2                               01       BUG23518 BUG25075
     C*****BBCUST        READE     SDCSINLI                               01      BUG25075 BUG26728A
     C     KyCSIN        READE     SDCSINLK                               01               BUG26728A
      *                                                                                     BUG23518
     C                   ENDDO                                                              BUG23518
      *                                                                                     BUG23518
     C                   IF        WRecFnd = 'Y'                                            BUG23518
      *                                                                                    BUG23518B
     C                   IF        WPrntCcTot = 'N'                                        BUG23518B
     C                   EXSR      SRPrtCcyTot                                              BUG23518
     C                   ENDIF                                                             BUG23518B
      *                                                                                    BUG23518B
     C                   IF        WPrntCuTot = 'N'                                        BUG23518B
     C                   EXSR      SRPrtCusTot                                              BUG23518
     C                   ENDIF                                                             BUG23518B
      *                                                                                    BUG23518B
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   READ      SDCUSTL1                               70                BUG23518
      *                                                                                     BUG23518
     C                   ENDDO                                                              BUG23518
      *                                                                                     BUG23518
     C                   ENDSR                                                              BUG23518
      *****************************************************************                     BUG23518
      /EJECT                                                                                BUG23518
      *****************************************************************                     BUG23518
      *  SRPrtCusTot - Print Total for Customer                       *
      *****************************************************************
     C     SRPrtCusTot   BEGSR
 
     C                   EVAL      RCTCS = WRefNo
     C                   EVAL      PDecs = WDecs
 
      ** Convert total Principal Amount
 
     C                   EVAL      PFLd15 =  WCPAM
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RCPAM
 
      ** Convert total Gross Interest Amount
 
     C                   EVAL      PFLd15 =  WCGIN
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RCGIN
 
      ** Convert total Tax Withheld in Original Ccy
 
     C                   EVAL      PFLd15 =  WCTXS
     C                   EXSR      SRZSEditF
     C                   MOVE      POut21        RCTXS
 
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
      ** For initial print of details or overflow has occured, print the Header
      ** of the report
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write total for customer
 
     C                   WRITE     TOTCUS
 
      ** Clear totals
 
     C                   EVAL      WCPAM = *ZERO
     C                   EVAL      WCGIN = *ZERO
     C                   EVAL      WCTXS = *ZERO
     C                   EVAL      WCTXC = *ZERO
     C                   EVAL      WPrntCuTot = 'Y'                                        BUG23518B
 
     C                   IF        *IN02  = *ON                                            BUG26728A
                                                                                           BUG26728A
     C**********         IF        WJOIN  = 0                                       BUG26728A CER059
     C                   IF        WJOIN  = *Blanks                                           CER059
     C                   EVAL      WFirst = 'Y'
     C                   ELSE                                                              BUG26728A
                                                                                           BUG26728A
      ** Write next member threshold details                                               BUG26728A
                                                                                           BUG26728A
     C                   IF        TSJOIN = WJOIN                                          BUG26728A
     C                   MOVE      WJOIN         KIJOIN                                    BUG26728A
     C                   EVAL      KICUST = TSCUST                                         BUG26728A
     C     KyINPH3       CHAIN     SDINPHL3                                                BUG26728A
     C                   EXSR      SRPrtMbrTh                                              BUG26728A
     C                   ELSE                                                              BUG26728A
     C                   EVAL      WFirst = 'Y'                                            BUG26728A
     C                   MOVE      WJOIN         KIJOIN                                    BUG26728A
     C                   EVAL      KICUST = WRefNo                                         BUG26728A
     C     KyINPH3       SETGT     SDINPHL3                                                BUG26728A
     C     KIJOIN        READE     SDINPHL3                                                BUG26728A
     C                   DOW       NOT %EOF(SDINPHL3)                                      BUG26728A
     C                   IF        JTICUST <> JTIJOIN                                      BUG26728A
     C                   EXSR      SRPrtMbrTh                                              BUG26728A
     C                   ENDIF                                                             BUG26728A
     C     KIJOIN        READE     SDINPHL3                                                BUG26728A
     C                   ENDDO                                                             BUG26728A
     C                   ENDIF                                                             BUG26728A
     C                   ENDIF                                                             BUG26728A
     C                   ELSE                                                              BUG26728A
     C                   EVAL      WFirst = 'Y'                                            BUG26728A
     C                   ENDIF                                                             BUG26728A
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRZSEditF - Convert numeric field                            *
      *****************************************************************
     C     SRZSEditF     BEGSR
 
     C                   EXSR      SRGetCcyF
 
     C                   EVAL      PECode = 'J'
     C                   EVAL      PEChar = *BLANKS
     C                   EVAL      POUT21 = *ZERO
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM                    PECode
     C                   PARM                    PEChar
     C                   PARM                    POut21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRGetCcyF - Get Currency Format                              *
      *****************************************************************
     C     SRGetCcyF     BEGSR
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WCcyEdt       PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = WCcyEdt
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      PDecs = A6NBDP
     C                   ENDIF
     C                   ENDSR
      *****************************************************************                     BUG25075
      /EJECT                                                                                BUG25075
      *****************************************************************                     BUG25075
      *                                                               *                     BUG25075
      *  SRStrRef - Store values for reference                        *                     BUG25075
      *                                                               *                     BUG25075
      *  Called By: SrDetail                                          *                     BUG25075
      *                                                               *                     BUG25075
      *****************************************************************                     BUG25075
     C     SRStrRef      BEGSR                                                              BUG25075
                                                                                            BUG25075
     C                   MOVEL     TSINST        RefInst                                    BUG25075
     C                   MOVEL     TSMODI        RefModi                                    BUG25075
     C                   MOVEL     TSACOD        RefAcod                                    BUG25075
                                                                                            BUG25075
     C                   ENDSR                                                              BUG25075
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SREnd - Write Trailer in Report                              *
      *****************************************************************
     C     SREnd         BEGSR
 
      ** Print detail report only if there are records to print
 
     C                   IF        %OPEN(SD000769P1)
     C                   EVAL      RqdLn1 = 4
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
      ** Write out report trailer
 
     C                   WRITE     TRAILP1
     C                   ENDIF
 
      ** Write audit report
 
     C                   EXSR      SRAudit
 
      ** Close printer files
 
     C                   IF        %OPEN(SD000769AU)
     C                   CLOSE     SD000769AU
     C                   ENDIF
 
     C                   IF        %OPEN(SD000769P1)
     C                   CLOSE     SD000769P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAudit - Write audit report                                 *
      *****************************************************************
     C     SRAudit       BEGSR
 
     C                   IF        NOT %OPEN(SD000769AU)
     C                   OPEN      SD000769AU
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    SFILEU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
      ** Print audit report if there is a DB error or no details to print
 
     C                   IF        *INU7 = *ON OR WNoRec = 0
     C                   WRITE     HEADAU
 
      ** Output the DB Error Information.
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ENDIF
 
      ** No details to print.
 
     C                   IF        WNoRec = 0
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C**********         PARM                    PClose                            BUG23518 BUG23789
     C                   PARM                    PSeq
     C                   PARM                    PLev
     C                   PARM                    PEnty
     C                   PARM                    PData
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
      ** Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ** Database error
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve base currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BJCYCD        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database error.
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = BJCYCD
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      WDecs = A6NBDP
     C                   ENDIF
 
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
     C                   EVAL      DBase = 007                                              BUG24767
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
     C                   EVAL      DBase = 008                                              BUG24767
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
     C                   CALLB     'ZDATE1'                                                 BUG24767
     C                   PARM                    WYrEnd                                     BUG24767
     C                   PARM      *ZEROS        PZDAYNO                                    BUG24767
     C                   PARM                    BJDFIN                                     BUG24767
     C                   PARM      *BLANKS       PERR                                       BUG24767
     C                   Z-ADD     PZDAYNO       WYrEndP                                    BUG24767
     C                   IF        WYrEndP < BJRDNB                                         BUG24767
     C                   ADD       1             WYrP                                       BUG24767
     C                   MOVE      WYrP          WYrEnd                                     BUG24767
     C                   CALLB     'ZDATE1'                                                 BUG24767
     C                   PARM                    WYrEnd                                     BUG24767
     C                   PARM      *ZEROS        PZDAYNO                                    BUG24767
     C                   PARM                    BJDFIN                                     BUG24767
     C                   PARM      *BLANKS       PERR                                       BUG24767
     C                   Z-ADD     PZDAYNO       WYrEndP                                    BUG24767
     C                   ENDIF                                                              BUG24767
     C                   ENDIF                                                              BUG24767
     C                   ENDIF                                                              BUG24767
                                                                                            BUG24767
      ** Report Work fields
 
     C                   EVAL      RqdLn1 = 0
     C                   EVAL      DifLn1 = 0
     C                   EVAL      PRTLN1 = 0
      *                                                                                       CER048
      ** To check for CER048                                                                  CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   EVAL      *IN36 = *ON                                                CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   EVAL      *IN36 = *OFF                                               CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtcd <> *BLANKS AND                                       CER048
     C                             PRtcd <> '*NRF'                                            CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 006                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER054
      ** To check for CER054                                                                  CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtcd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'N'                                               CER054
     C**********         EVAL      *IN37 = *OFF                                     CER054 BUG26728B
     C                   EVAL      *IN39 = *OFF                                            BUG26728B
      *                                                                                       CER054
     C                   IF        PRtcd = *BLANKS                                            CER054
      *                                                                                       CER054
     C                   EVAL      CER054 = 'Y'                                               CER054
     C**********         EVAL      *IN37 = *ON                                      CER054 BUG26728B
     C                   EVAL      *IN39 = *ON                                             BUG26728B
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   IF        PRtcd <> *BLANKS AND                                       CER054
     C                             PRtcd <> '*NRF'                                            CER054
     C     *LOCK         IN        LDA                                                        CER054
     C                   EVAL      DBKEY = 'CER054'                                           CER054
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER054
     C                   EVAL      DBASE = 010                                                CER054
     C                   OUT       LDA                                                        CER054
     C                   EXSR      *PSSR                                                      CER054
     C                   ENDIF                                                                CER054
                                                                                           BUG26728A
      ** Key field for SDCSINLK file                                                       BUG26728A
                                                                                           BUG26728A
     C     KyCSIN        KLIST                                                             BUG26728A
     C                   KFLD                    KyJOIN                                    BUG26728A
     C                   KFLD                    KyCNUM                                    BUG26728A
                                                                                           BUG26728A
      ** Key field for SDINPHL3 file                                                       BUG26728A
                                                                                           BUG26728A
     C     KyINPH3       KLIST                                                             BUG26728A
     C                   KFLD                    KIJOIN                                    BUG26728A
     C                   KFLD                    KICUST                                    BUG26728A
      *                                                                                       CER048
     C*****KLAccKey      KLIST                                                      CER048 BUG24443A
     C**********         KFLD                    KFCust                             CER048 BUG24443A
     C**********         KFLD                    TSOCCY                             CER048 BUG24443A
     C**********         KFLD                    TSACOD                             CER048 BUG24443A
     C**********         KFLD                    TSACSQ                             CER048 BUG24443A
     C**********         KFLD                    TSBRCA                             CER048 BUG24443A
      *                                                                                    BUG24443A
      ** Key field for REHIS file                                                          BUG24443A
     C     KyRehis       KLIST                                                             BUG24443A
     C                   KFLD                    KyBrca                                    BUG24443A
     C                   KFLD                    KyCust                                    BUG24443A
     C                   KFLD                    KyCcy                                     BUG24443A
     C                   KFLD                    KyAcod                                    BUG24443A
     C                   KFLD                    KyAcsq                                    BUG24443A
     C                   KFLD                    KyHisd                                    BUG24443A
      *                                                                                       CER048
      ** Calculate "Start" and "End" Date of Year only when Year is                         BUG24280
      ** entered                                                                            BUG24280
      *                                                                                     BUG24280
     C**********         EVAL      PZDayNo = BJEYD                                 BUG24280 BUG24767
     C                   EVAL      PZDayNo = WYrEndP                                        BUG24767
     C                   EXSR      SRZDate                                                  BUG24280
     C                   MOVE      PZDate        WwYr                                       BUG24280
      *                                                                                     BUG24280
     C                   IF        PTaxYr <> *BLANKS                                        BUG24280
      *                                                                                     BUG24280
     C                   MOVE      PTaxYr        WSYeaRS                                    BUG24280
     C                   MOVE      PTaxYr        WEYeaRE                                    BUG24280
      *                                                                                     BUG24280
     C**********         ELSEIF    PTaxYrF <> *BLANKS AND                          BUG24280 BUG24935
     C**********                   PTaxYrT <> *BLANKS                              BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         MOVE      PTaxYrF       WSYeaRS                           BUG24280 BUG24935
     C**********         MOVE      PTaxYrT       WEYeaRE                           BUG24280 BUG24935
      *                                                                                     BUG24935
     C                   ELSE                                                               BUG24935
      *                                                                                     BUG24935
     C                   MOVE      BJMRDT        WSYeaRS                                    BUG24935
     C                   MOVE      BJMRDT        WEYeaRE                                    BUG24935
      *                                                                                     BUG24280
     C                   ENDIF                                                              BUG24280
      * Get End Of Year                                                                     BUG24935
     C                   MOVE      WEYeaRE       WYrEnd                                     BUG24935
     C                   MOVEL     A4ETXY        WYrEnd                                     BUG24935
      *                                                                                     BUG24280
     C**********         IF        WEYeaRE <> WwYr                                 BUG24280 BUG24935
      **********                                                                   BUG24280 BUG24935
     C**********         EVAL      WETaxYr = PZDate                                BUG24280 BUG24935
     C**********         MOVE      WEYeaRE       WETaxYr                           BUG24280 BUG24935
      *                                                                                     BUG24280
      ** Convert the End of Year Date No. to DDMMYY format                                  BUG24280
      *                                                                                     BUG24280
     C**********         MOVEL     WETaxYr       PDateIn                           BUG24280 BUG24935
     C                   MOVEL     WYrEnd        PDateIn                                    BUG24935
      *                                                                                     BUG24280
     C                   CALLB     'ZDATE1'                                                 BUG24280
     C                   PARM                    PDateIn                                    BUG24280
     C                   PARM      *ZEROS        PZDayNo                                    BUG24280
     C                   PARM                    BJDFIN                                     BUG24280
     C                   PARM      *BLANKS       PErr                                       BUG24280
      *                                                                                     BUG24280
     C                   EVAL      WEYear = PZDayNo                                         BUG24280
      *                                                                                     BUG24280
     C**********         ELSE                                                      BUG24280 BUG24935
      *                                                                                     BUG24280
     C**********         EVAL      WEYear = BJEYD                                  BUG24280 BUG24767
     C**********         EVAL      WEYear = WYrEndP                                BUG24767 BUG24935
     C**********         EVAL      WEYear = WYrEndP                                BUG24280 BUG24935
     C**********         ENDIF                                                     BUG24280 BUG24935
      *                                                                                     BUG24280
     C**********         EVAL      WJeyd = BJEYD + 1                               BUG24280 BUG24767
     C                   EVAL      WJeyd = WYrEndP + 1                                      BUG24767
      *                                                                                     BUG24280
      ** Convert the End of Year + 1 to DDMMYY format                                       BUG24280
      *                                                                                     BUG24280
     C                   EVAL      PZDayNo = WJeyd                                          BUG24280
     C                   EXSR      SRZDate                                                  BUG24280
     C                   EVAL      WStaxYr = PZDate                                         BUG24280
     C                   MOVEL     WStaxYr       WStaxYrA                                   BUG24280
     C                   EVAL      WDdMm = %SUBST(WStaxYrA:1:4)                             BUG24280
      *                                                                                     BUG24280
     C                   IF        WSYeaRS <= 39                                            BUG24280
     C                   MOVEL     20            TYear                                      BUG24280
     C                   ELSE                                                               BUG24280
     C                   MOVEL     19            TYear                                      BUG24280
     C                   ENDIF                                                              BUG24280
      *                                                                                     BUG24280
     C                   MOVE      WSYeaRS       TYear                                      BUG24280
      *                                                                                     BUG24280
     C**********         IF        WDdMm <> '0101'                                 BUG24280 BUG24935
     C                   IF        ((WDdMm <> '3112' AND BJDFIN = 'D')                      BUG24935
     C                             OR (WDdMm <> '1231' AND BJDFIN = 'M'))                   BUG24935
     C                             AND WYrEndP >= BJRDNB                                    BUG24935
     C                   EVAL      TYear = TYear - 1                                        BUG24280
     C                   ENDIF                                                              BUG24280
      *                                                                                     BUG24280
     C                   MOVE      TYear         WYear                                      BUG24280
     C                   MOVE      WYear         WSTaxYr                                    BUG24280
      *                                                                                     BUG24280
      ** Convert the Start of Year in DDYYMM format into Day No                             BUG24280
      *                                                                                     BUG24280
     C                   MOVEL     WSTaxYr       PDateIn                                    BUG24280
      *                                                                                     BUG24280
     C                   CALLB     'ZDATE1'                                                 BUG24280
     C                   PARM                    PDateIn                                    BUG24280
     C                   PARM      *ZEROS        PZDayNo                                    BUG24280
     C                   PARM                    BJDFIN                                     BUG24280
     C                   PARM      *BLANKS       PErr                                       BUG24280
      *                                                                                     BUG24280
     C                   EVAL      WSYear = PZDayNo                                         BUG24280
      *                                                                                     BUG24280
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                       CER048
      *  SRTaxDet - Subroutine to Print Taxes Details                 *                       CER048
      *                                                               *                       CER048
      *  Called by: SRStrFld                                          *                       CER048
      *                                                               *                       CER048
      *  Calls : SRZDate, SRZSEditF                                   *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRTaxDet      BEGSR                                                                CER048
      *                                                                                       CER048
      ** To Retrieve the Local Tax Office Details                                             CER048
      *                                                                                       CER048
     C     TSBRCA        CHAIN     SDLTOFL1                                                   CER048
      *                                                                                       CER048
     C                   IF        NOT %FOUND(SDLTOFL1)                                       CER048
      *                                                                                       CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBKEY = 'TSBRCA'                                           CER048
     C                   EVAL      DBFILE = 'SDLTOFPD'                                        CER048
     C                   EVAL      DBASE = 007                                                CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** To Print Local Tax Office Name and Number                                            CER048
      *                                                                                       CER048
     C                   EVAL      ROFNM = LTOFNM                                             CER048
     C                   EVAL      ROFNO = LTOFRN                                             CER048
      *                                                                                       CER048
      ** To Get Period (Current Year)                                                         CER048
      *                                                                                       CER048
     C                   EVAL      RPERIOD = %SUBST(TSIPDT:1:4)                             BUG23514
     C**********         CALLB     'ZDATE9'                                          CER048 BUG23514
     C**********         PARM      BJRDNB        PZDayNo                             CER048 BUG23514
     C**********         PARM      *ZEROS        PZDate1                             CER048 BUG23514
     C**********         PARM      *BLANKS       PErrorFlag                          CER048 BUG23514
      *                                                                                       CER048
     C**********         IF        PErrorFlag = '0'                                  CER048 BUG23514
     C**********         MOVEL     PZDate1       RPERIOD                             CER048 BUG23514
     C**********         ENDIF                                                       CER048 BUG23514
      *                                                                                       CER048
      ** Customer Details                                                                     CER048
      *                                                                                       CER048
     C                   EVAL      RBLCD = BBBLCD                                             CER048
      *                                                                                     BUG23518
     C                   IF        PClose= 'Y'                                              BUG23518
     C                   EVAL      PZDayNo = BBCLDT                                         BUG23518
     C                   ELSE                                                               BUG23518
     C                   EVAL      PZDayNo = BBDTDL                                           CER048
     C                   ENDIF                                                              BUG23518
      *                                                                                     BUG23518
     C                   EXSR      SRZDate                                                    CER048
     C                   MOVEL     PZADate       RDTDL                                        CER048
      *                                                                                       CER048
      ** Customer Income Details                                                              CER048
      *                                                                                       CER048
     C**********         MOVE      TSTAXY        WInpy                               CER048 BUG23514
     C**********         MOVE      TSTAXM        WInpm                               CER048 BUG23514
     C                   EVAL      WInpd = %SUBST(TSIPDT:7:2)                               BUG23514
     C                   EVAL      WInpm = %SUBST(TSIPDT:5:2)                               BUG23514
     C                   EVAL      WInpy = %SUBST(TSIPDT:3:2)                               BUG23514
     C**********         MOVE      WInpe         RINPE                               CER048 BUG23514
     C                   MOVE      WInpe         RINP2                                      BUG23514
      *                                                                                       CER048
     C                   MOVE      TSSTDO        PFld15                                       CER048
     C                   EVAL      WCcyEdt = TSSCCY                                           CER048
     C                   EXSR      SRZSEditF                                                  CER048
     C**********         EVAL      RSTDO = POut21                                    CER048 BUG23408
     C                   MOVE      POut21        RSTDO                                      BUG23408
      *                                                                                       CER048
     C                   EVAL      RTO = '-'                                                BUG23514
                                                                                            BUG23514
     C                   IF        TSMODI = RefModi and TSINST = RefInst                    BUG25075
     C                             and TSACOD = RefAcod                                     BUG25075
     C     TSSLID        ADD       1             PZDayNo                                    BUG25075
     C                   ELSE                                                               BUG25075
     C                   Z-ADD     TSSLID        PZDayNo                                    BUG23514
     C                   ENDIF                                                              BUG25075
      *                                                                                     BUG25075
     C                   EXSR      SRStrRef                                                 BUG25075
      *                                                                                     BUG25075
     C                   EXSR      SRZDate                                                  BUG23514
     C                   Z-ADD     PZDate        RINPE                                      BUG23514
                                                                                            BUG23514
     C                   EVAL      PFld15 = TSSTDT                                            CER048
     C                   EVAL      WCcyEdt = TSTXCY                                           CER048
     C                   EXSR      SRZSEditF                                                  CER048
     C**********         EVAL      RSTDT = POut21                                    CER048 BUG23408
     C                   MOVE      POut21        RSTDT                                      BUG23408
      **********                                                                     CER048 BUG25542
      ***Interest Payment History Details                                            CER048 BUG25542
      **********                                                                     CER048 BUG25542
     C*****TSCUST        CHAIN     SDINPHL1                                          CER048 BUG25542
     C**********         IF        NOT %FOUND(SDINPHL1)                              CER048 BUG25542
      **********                                                                     CER048 BUG25542
     C**********         MOVE      *BLANKS       RUTTH                             BUG23147 BUG25542
     C**********         MOVE      *BLANKS       RCUTH                             BUG23147 BUG25542
      **********                                                                   BUG23147 BUG25542
     C**********         ELSE                                                      BUG23147 BUG25542
     C**********                                                                            BUG25542
     C******LOCK         IN        LDA                                               CER048 BUG23147
     C**********         EVAL      DBKEY = 'TSCUST'                                  CER048 BUG23147
     C**********         EVAL      DBFILE = 'SDINPHPD'                               CER048 BUG23147
     C**********         EVAL      DBASE = 008                                       CER048 BUG23147
     C**********         OUT       LDA                                               CER048 BUG23147
     C**********         EXSR      *PSSR                                             CER048 BUG23147
      **********                                                                     CER048 BUG25542
     C**********         ENDIF                                                       CER048 BUG23147
      **********                                                                     CER048 BUG25542
     C**********         MOVE      TIUTTH        RUTTH                               CER048 BUG23408
     C**********         EVAL      PFld15 = TIUTTH                                 BUG23408 BUG25542
     C**********         EVAL      WCcyEdt = BJCYCD                                BUG23408 BUG25542
     C**********         EXSR      SRZSEditF                                       BUG23408 BUG25542
     C**********         MOVE      POut21        RUTTH                             BUG23408 BUG25542
      **********                                                                   BUG23408 BUG25542
     C**********         MOVE      TICUTH        RCUTH                               CER048 BUG23408
     C**********         EVAL      PECode = 'J'                                    BUG23408 BUG25542
     C**********         EVAL      PEChar = *BLANKS                                BUG23408 BUG25542
     C**********         EVAL      POUT21 = *ZERO                                  BUG23408 BUG25542
      **********                                                                   BUG23408 BUG25542
     C**********         CALLB     'ZSEDITF'                                       BUG23408 BUG25542
     C**********         PARM      TICUTH        PFld15                            BUG23408 BUG25542
     C**********         PARM      0             PDecs                             BUG23408 BUG25542
     C**********         PARM                    PECode                            BUG23408 BUG25542
     C**********         PARM                    PEChar                            BUG23408 BUG25542
     C**********         PARM                    POut21                            BUG23408 BUG25542
     C**********         MOVE      POut21        RCUTH                             BUG23408 BUG25542
      **********                                                                   BUG23147 BUG25542
     C**********         ENDIF                                                     BUG23147 BUG25542
      *                                                                                       CER048
      ** Exemption Threshold History                                                          CER048
      *                                                                                       CER048
     C     TSCUST        CHAIN     SDTHRHL1                                                   CER048
     C                   IF        NOT %FOUND(SDTHRHL1)                                       CER048
      *                                                                                       CER048
     C                   MOVE      *BLANKS       RTRVD                                      BUG23147
     C                   MOVE      *BLANKS       RTRMD                                      BUG23147
     C******LOCK         IN        LDA                                               CER048 BUG23147
     C**********         EVAL      DBKEY = 'TSCUST'                                  CER048 BUG23147
     C**********         EVAL      DBFILE = 'SDTHRHPD'                               CER048 BUG23147
     C**********         EVAL      DBASE = 009                                       CER048 BUG23147
     C**********         OUT       LDA                                               CER048 BUG23147
     C**********         EXSR      *PSSR                                             CER048 BUG23147
      *                                                                                       CER048
     C                   ELSE                                                               BUG23147
     C**********         ENDIF                                                       CER048 BUG23147
      *                                                                                       CER048
      ** To Print the Threshold Value Date                                                    CER048
      *                                                                                       CER048
     C                   EVAL      PZDayNo = TETRVD                                           CER048
     C                   EXSR      SRZDate                                                    CER048
     C                   MOVE      PZADate       RTRVD                                        CER048
      *                                                                                       CER048
      ** To Print the Threshold Maturity Date                                                 CER048
      *                                                                                       CER048
     C                   EVAL      PZDayNo = TETRMD                                           CER048
     C                   EXSR      SRZDate                                                    CER048
     C                   MOVE      PZADate       RTRMD                                        CER048
      *                                                                                     BUG23147
     C                   ENDIF                                                              BUG23147
      *                                                                                       CER048
      ** Get Interest Rate either from Deals or Retail Account                                CER048
      ** Remove Interest Rate calculation below and move to a subroutine (also use         BUG24443A
      ** historic DL files to correctly retrieve Int Rate of historic transactions)        BUG24443A
      *                                                                                       CER048
      ** Comment out Interest Rate calculation as required by Change Request 008            BUG24789
      ** -----------------------------------------------------------------------            BUG24789
      ** To reinstate, remove the commenting of call to subroutine SrIntRate below.         BUG24789
      ** Also ensure RINRT (after the call to subroutine) is populated by WINRT.            BUG24789
      ** This will trigger the extraction of Interest Rate and will print label and         BUG24789
      ** rate on the FormsMaster form SDTaxAnnualDeductedStatement.OM5 (these will          BUG24789
      ** be hidden while no Int Rate exists in the xml extract .DAT)                        BUG24789
      *                                                                                     BUG24789
     C***********        EXSR      SrIntRate                                      BUG24443A BUG24789
     C***********        EVAL      RINRT = WINRT                                            BUG24789
      *                                                                                       CER048
     C*****TSDLLN        CHAIN     DEALS                                            CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        IF        %FOUND (DEALS)                                   CER048 BUG24443A
     C**********         MOVE      RTSP          RINRT                               CER048 BUG23408
     C***********        EVAL      RINRT = RTSP                                     CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        ELSE                                                       CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        MOVE      TSCUST        KFCust                             CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C******LOVAL        SETLL     ACCNT                                            CER048 BUG24443A
     C*****KLAccKey      CHAIN     ACCNT                                            CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        IF        %FOUND (ACCNT)                                   CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        IF        ATYP = 'R'                                       CER048 BUG24443A
     C***********        MOVE      CCIR          RINRT                     CER048 BUG23408 BUG24443A
     C***********        EVAL      RINRT = CCIR                                   BUG23408 BUG24443A
     C***********        ELSE                                                       CER048 BUG24443A
     C***********        EVAL      RINRT = *ZEROS                                   CER048 BUG24443A
     C***********        ENDIF                                                      CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        ELSE                                                       CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        EVAL      RINRT = *ZEROS                                   CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        ENDIF                                                      CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        ENDIF                                                      CER048 BUG24443A
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /EJECT                                                                               BUG24443A
      *****************************************************************                    BUG24443A
      *                                                               *                    BUG24443A
      *  SrIntRate - subroutine to extract the Interest Rate.         *                    BUG24443A
      *                                                               *                    BUG24443A
      *  Called By : SRTaxDet                                         *                    BUG24443A
      *                                                               *                    BUG24443A
      *  Calls : None                                                 *                    BUG24443A
      *                                                               *                    BUG24443A
      *****************************************************************                    BUG24443A
     C     SrIntRate     BEGSR                                                             BUG24443A
      *                                                                                    BUG24443A
      ** Initialise Interest Rate.                                                         BUG24443A
     C**********         EVAL      RINRT = *ZEROS                                 BUG24443A BUG24789
     C                   EVAL      WINRT = *ZEROS                                           BUG24789
      *                                                                                    BUG24443A
      ** If Dealing, scan both live and historic deals files.                              BUG24443A
     C                   IF        TSMODI = 'D'                                            BUG24443A
      *                                                                                    BUG24443A
     C     TSDLLN        CHAIN     DEALSALL                                                BUG24443A
     C                   IF        %FOUND (DEALSALL)                                       BUG24443A
     C**********         EVAL      RINRT = INTR                                   BUG24443A BUG24789
     C                   EVAL      WINRT = INTR                                             BUG24789
     C                   ELSE                                                              BUG24443A
     C**********         EVAL      RINRT = *ZEROS                                 BUG24443A BUG24789
     C                   EVAL      WINRT = *ZEROS                                           BUG24789
     C                   ENDIF                                                             BUG24443A
      *                                                                                    BUG24443A
     C                   ENDIF                                                             BUG24443A
      *                                                                                    BUG24443A
      ** If retail, build key and scan the Retail History file.                            BUG24443A
      *                                                                                    BUG24443A
     C                   IF        TSMODI = 'G'                                            BUG24443A
     C                   EVAL      KyBrca = TSBRCA                                         BUG24443A
     C                   MOVE      TSCUST        KyCust                                    BUG24443A
     C                   EVAL      KyCcy  = TSOCCY                                         BUG24443A
     C                   EVAL      KyAcod = TSACOD                                         BUG24443A
     C                   EVAL      KyAcsq = TSACSQ                                         BUG24443A
     C                   EVAL      KyHisd = TSEDAT                                         BUG24443A
      *                                                                                    BUG24443A
      ** Retrieve interest rate (CRIR) from Retail History file                            BUG24443A
     C     KyRehis       SETGT     REHISDL                                                 BUG24443A
     C                   READP     REHISDL                                                 BUG24443A
     C                   IF        NOT %EOF                                                BUG24443A
     C**********         EVAL      RINRT = CRIR                                   BUG24443A BUG24789
     C                   EVAL      WINRT = CRIR                                             BUG24789
     C                   ELSE                                                              BUG24443A
     C**********         EVAL      RINRT = *ZEROS                                 BUG24443A BUG24789
     C                   EVAL      WINRT = *ZEROS                                           BUG24789
     C                   ENDIF                                                             BUG24443A
      *                                                                                    BUG24443A
     C                   ENDIF                                                             BUG24443A
      *                                                                                    BUG24443A
     C                   ENDSR                                                             BUG24443A
      *****************************************************************                    BUG24443A
      /EJECT                                                                                  CER048
      *****************************************************************                       CER048
      *                                                               *                       CER048
      *  SRZDate - Subroutine to convert day no to date               *                       CER048
      *                                                               *                       CER048
      *  Called By : SRTaxDet                                         *                       CER048
      *                                                               *                       CER048
      *  Calls : None                                                 *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     SRZDate       BEGSR                                                                CER048
      *                                                                                       CER048
     C                   CALLB     'ZDATE2'                                                   CER048
     C                   PARM                    PZDayNo                                      CER048
     C                   PARM      BJDFIN        PZDatfm                                      CER048
     C                   PARM                    PZDate                                       CER048
     C                   PARM                    PZADate                                      CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      /EJECT                                                                                  CER048
      *                                                               *                       CER054
      *  SRThdTDet - Subroutine to Populate Third Tax Fields          *                       CER054
      *                                                               *                       CER054
      *  Called By : SRStrFld                                         *                       CER054
      *                                                               *                       CER054
      *  Calls : None                                                 *                       CER054
      *                                                               *                       CER054
      *****************************************************************                       CER054
     C     SRThdTDet     BEGSR                                                                CER054
      *                                                                                       CER054
     C                   EVAL      PFld15  = TSTTDO                                           CER054
     C                   EVAL      WCcyEdt = TSSCCY                                           CER054
     C                   EXSR      SRZSEditF                                                  CER054
     C**********         EVAL      RSTTDO  = POut21                                  CER054 BUG24379
     C                   MOVE      POut21        RSTTDO                                     BUG24379
      *                                                                                       CER054
     C                   EVAL      PFld15  = TSTTDT                                           CER054
     C                   EVAL      WCcyEdt = TSTXCY                                           CER054
     C                   EXSR      SRZSEditF                                                  CER054
     C**********         EVAL      RSTTDT = POut21                                   CER054 BUG26431
     C                   MOVE(P)   POut21        RSTTDT                                     BUG26431
      *                                                                                       CER054
     C                   ENDSR                                                                CER054
      *****************************************************************                       CER048
** CPY@
(c) Misys International Banking Systems Ltd. 2004
