     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas CG Annual Tax Deducted Statement')               *
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG006110 - Midas CG Annual Tax Deducted Statement            *
      *                                                               *
      *  Function:  This program produces the Annual Tax Deducted     *
      *             Statement onto the UDC extract files.             *
      *                                                               *
      *  Called By: CG006100 - Midas CG Annual Tax Deducted           *
      *                        Statement Driver                       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 AR750273B          Date 09Jun11               *
      *                 AR763011           Date 02Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25542           Date 19Aug09               *
      *                 BUG25008           Date 16Jul09               *
      *                 BUG25075           Date 28Jul09               *
      *                 BUG24767           Date 07Jul09               *
      *                 BUG24789           Date 10Jul09               *
      *                 BUG24790           Date 08Jul09               *
      *                 BUG24443A          Date 06Jul09               *
      *                 BUG24487           Date 23Jun09               *
      *                 BUG24280           Date 10Jun09               *
      *                 BUG24244           Date 08Jun09               *
      *                 BUG23732           Date 23Apr09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23970           Date 14May09               *
      *                 BUG23971           Date 12May09               *
      *                 BUG23719           Date 27Apr09               *
      *                 BUG23514A          Date 23Apr09               *
      *                 BUG23514           Date 20Mar09               *
      *                 BUG23123           Date 09Mar09               *
      *                 BUG23408           Date 16Mar09               *
      *                 BUG23313           Date 10Mar09               *
      *                 BUG23147           Date 03Mar09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027A            Date 05May06               *
      *                 236193             Date 25Aug05               *
      *                 236129             Date 27Sep05               *
      *                 234897             Date 12Aug05               *
      *                 234502             Date 20Jul05               *
      *                 232543             Date 11Mar05               *
      * Midas Release 4.04 -------------------------------------------*
      *                 CGL031  *CREATE    Date 05Jul04               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR750273B - Components failed due to closed customer         *
      *              (Child: AR750274)                                *
      *  AR763011 - Annual Tax Deducted Statement showed incorrect    *
      *             totals.                                           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25542 - In case the customer is a Joint Account cust,     *
      *             the statement will include the identity of        *
      *             all joint members.                                *
      *  BUG25008 - Incorrect Church Tax Rate (extracted as           *
      *             0.90000 instead of 9.0000 as per SDCSINPD)        *
      *             Replace ZZFCHRT with edit code L4 instead         *
      *             of L5.                                            *
      *  BUG25075 - Correct interest period printed on report         *
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
      *  BUG24790 - Label "Tax Currency" on the form is printing      *
      *             the Settlement Ccy instead of Tax Currency.       *
      *             Also ensure currency desciption is retrieved      *
      *             from A6CYNM instead of A6MACD (as A6MACD is       *
      *             not populated in SDCURRPD).                       *
      *  BUG24443A- Interest rate showing as zero due to DL           *
      *             transactions already historic. Need to cover      *
      *             historic Dealing files as well. Also replace      *
      *             fields to use for Interest Rate :                 *
      *             (1) replace RTSP with INTR (for dealing)          *
      *             (2) replace CCIR with CRIR (for retail)           *
      *             Move Interest Rate calculation to a separate      *
      *             subroutine (in prep for Change Request 008).      *
      *  BUG24487 - Annual Tax Deducted statements report and Confo   *
      *             extract should have the same output               *
      *  BUG24280 - Enquiries/Reports should be amended to get data if*
      *             start and end of tax year in same year            *
      *  BUG24244 - Customer Closed field is not populated on Annual  *
      *             Tax Deduct Statement                              *
      *  BUG23732 - Joint Account threshold (Recompile)               *
      *  CER054 - German Features - Church Tax                        *
      *  BUG23970 - Re-Format Utilisation Up To Amount (CGUXMLPD)     *
      *  BUG23971 - Cannot run SD000769 Annual Tax Deducted Statement *
      *  BUG23719 - Annual Tax Deducted Statement shows incorrect     *
      *             amounts                                           *
      *  BUG23514A- Incorrect format of Interest Payment Date Field   *
      *  BUG23514 - Some fields did not follow the requirement in FS  *
      *  BUG23123 - Report: Does not show Retail Account Number       *
      *                     Date is not Midas Standard Date           *
      *                     Period should be actual int. calc. period *
      *                     Secondary Tax amount is not printed       *
      *                     Added field TSSLID                        *
      *                     (Recompile)                               *
      *  BUG23408 - Annual tax deducted statement needs adjustment    *
      *  BUG23313 - Populate Threshold Maturity, Value date and Int.  *
      *             Payment date in YYYYMMDD format                   *
      *  BUG23147 - Program dump in component SDC000769               *
      *  CER048 - German Features - Taxes                             *
      *  CSD027A- Conversion of cust. no. to alpha (post 103 build)   *
      *  236193 - Correct date format.                                *
      *           Review repeating data extract.                      *
      *  236129 - Issue RETURN if CG9010 returns a code of CGD1270    *
      *  234897 - Extract correct Correspondent                       *
      *  234502 - Use branch from SDCUSTPD instead of hardcoded "DOM" *
      *  232543 - Fix to CGL031                                       *
      *  CGL031 - Taxation of Savings Income                          *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Customer Income by Cust#, Curr, Pymnt date, Modid, Instr ref
     F***SDCSINL2  IF   E           K DISK    INFSR(*PSSR)                                  BUG25075
     FSDCSINLI  IF   E           K DISK    INFSR(*PSSR)                                     BUG25075
 
      ** Customer Income by non-account holder#, Curr, Pymnt date
     FSDCSINL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDCSIND0:SDCSIND3)
 
      *                                                                                       CER048
      ** Midas Local Tax Office File Retrieve Index                                           CER048
      *                                                                                       CER048
     FSDLTOFL1  IF   E           K DISK                                                       CER048
      *                                                                                       CER048
      ** Midas Interest Payment History File Retrieve Index                                   CER048
      *                                                                                       CER048
     FSDINPHL1  IF   E           K DISK                                                       CER048
      *                                                                                       CER048
      ** Midas Exemption Threshold History File Retrieve Index                                CER048
      *                                                                                       CER048
     FSDTHRHL1  IF   E           K DISK                                                       CER048
      *                                                                                       CER048
      ***Midas*DL*Deals*File                                                        CER048 BUG24443A
      *************                                                                 CER048 BUG24443A
     F***DEALS*****IF   E           K DISK                                          CER048 BUG24443A
      *************                                                                 CER048 BUG24443A
      ***Midas*GL*Account*Master File                                               CER048 BUG24443A
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
      *                                                                                    BUG24443A
      ** Midas SD Interest Payment Hist File by Cust/Branch - Retrieval                     BUG25542
      *                                                                                     BUG25542
     FSDINPHL3  IF   E           K DISK    RENAME(SDINPHD0:SDINPHD3)                        BUG25542
     F                                     PREFIX(J_)                                       BUG25542
      *                                                                                     BUG25542
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** Print Item Type
     D WCPrtItmTyp     C                   CONST('STATEMENT')
 
      ** Print Item Sub-Type
     D WCPrtItmSubTyp  C                   CONST('TAX_ANNDCT')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Data strucutre for access objects, short DS
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Data structure for access objects, long DS
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       CER048
      ** Data structure for access objects, Very long DS                                      CER048
      *                                                                                       CER048
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     CER048
 
      ** Data structure for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
                                                                                            BUG24767
      ** Externally described DS for Location details                                       BUG24767
     D SDLOCN        E DS                  EXTNAME(SDLOCNPD)                                BUG24767
                                                                                            BUG24767
      ** Externally described DS for Country code details                                   BUG24767
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)                                BUG24767
 
      ** Data structure for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Data structure for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *                                                                                       CER048
      ** Data structure for Customer details                                                  CER048
      *                                                                                       CER048
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CER048
 
      ** Data structure for UDC data reference file
     D PEDsCGUDCRPD  E DS                  EXTNAME(CGUDCRPD)
 
      ** Data structure for UDC extracted data file
     D PEDsCGUDTAPD  E DS                  EXTNAME(CGUDTAPD)
 
      ** Data Structure of Parameters Passed from CG006100
     D DSPARM          DS
     D  PTaxYear               1      4  0
     D  PRef                   5     14
     D  PRefInd               15     15
     D  PRepName              16     35
     D  PRepTown              36     45
     D  PBranch               46     48                                                       234502
     D  PAcus                 49     49                                                     BUG23971
     D  PTaxYrF               50     53                                                     BUG24487
     D  PTaxYrT               54     57                                                     BUG24487
 
      ** Multi-occurence data structure to store subroutine specific data
     D WMDsSRDT        DS                  OCCURS(20)
     D  WMDsPrevBnd            1      5  0
     D  WMDsThisBnd            6     10  0
     D  WMDsPathGrp           11     80
 
      ** General data structure to define fields that need to share data
     D                 DS
     D WGrp10                  1     10
     D  WGrpNme                1      6
     D  WGrpSeq                7     10S 0
     D  WAr20                 21     40    DIM(20)
     D  WNum20                21     40  0
     D  WAr29                 51     79    DIM(29)
 
     D  ##SDS          DS          5120
 
      ** Compile-time array to contain RDE definitions
     D*WTbGrp***       S             10    DIM(22) CTDATA PERRCD(1)                           232543
     D*WTbRDE***       S             22    DIM(22) ALT(WTbGrp)                                232543
     D*WTbGrp***       S             10    DIM(23) CTDATA PERRCD(1)                    232543 CER048
     D*WTbRDE***       S             22    DIM(23) ALT(WTbGrp)                         232543 CER048
     D*WTbGrp***       S             10    DIM(36) CTDATA PERRCD(1)                  CER048 BUG23514
     D*WTbRDE***       S             22    DIM(36) ALT(WTbGrp)                       CER048 BUG23514
     D*WTbGrp***       S             10    DIM(39) CTDATA PERRCD(1)                  BUG23514 CER054
     D*WTbRDE***       S             22    DIM(39) ALT(WTbGrp)                       BUG23514 CER054
     D*WTbGrp***       S             10    DIM(42) CTDATA PERRCD(1)                  CER054 BUG24244
     D*WTbRDE***       S             22    DIM(42) ALT(WTbGrp)                       CER054 BUG24244
     D*WTbGrp***       S             10    DIM(43) CTDATA PERRCD(1)                BUG24244 BUG24790
     D*WTbRDE***       S             22    DIM(43) ALT(WTbGrp)                     BUG24244 BUG24790
     D*WTbGrp***       S             10    DIM(45) CTDATA PERRCD(1)                BUG24790 BUG25542
     D*WTbRDE***       S             22    DIM(45) ALT(WTbGrp)                     BUG24790 BUG25542
     D WTbGrp          S             10    DIM(49) CTDATA PERRCD(1)                         BUG25542
     D WTbRDE          S             22    DIM(49) ALT(WTbGrp)                              BUG25542
 
      *                                                                                       CER048
      ** Copy books for ZDATE9                                                                CER048
      *                                                                                       CER048
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CER048
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CER048
      *                                                                                       CER048
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** String that contains the concatenated path
     D W0PATH          S            256A
 
      ** Confirmation Text code
     D ##ITEM          S              8  0
 
      ** General purpose variables
     D Wx1             S              3P 0
     D Wx2             S              3P 0
     D Wx3             S              3P 0
     D Colon           S             11A
 
      ** Parameter fields
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A
     D PCurrency       S              3A
     D PAction8        S              8A
     D PCustNumChr6    S              6A
     D PItmRef         S              8A
     D PMode           S             10A
     D PRtnCode        S              7A
     D W0CMT           S              3A
     D WProduce        S              1A
     D WAUTO           S              1A
     D W0SPAT          S             70A
     D PCnum           S             10A                                                    BUG25542
     D PCnst           S              7A                                                    BUG25542
 
      ** Work Variables
     D CCG015          S              1A
     D WCurrency       S              3A
     D WDlln           S              6A
     D WAcod           S              4A
     D WAcsq           S              2A
     D WTType          S             13A
     D WDateDD         S              2A
     D WDateMM         S              2A
     D WDateYY         S              2A
     D WIpdt           S              6A
     D WTPAMS          S             18  0
     D WTGINS          S                   LIKE(TSGINS)
     D WTTXSR          S                   LIKE(TSTXSR)
     D WTTXSC          S                   LIKE(TSTXSC)
     D WTPAMB          S                   LIKE(TSPAMB)
     D WTGINB          S                   LIKE(TSGINB)
     D WTTXSB          S                   LIKE(TSTXSB)
     D WBCcyPl         S                   Like(A6NBDP)
     D WSCcyPl         S                   Like(A6NBDP)
     D WOCcyPl         S                   Like(A6NBDP)
     D WTCcyPl         S                   Like(A6NBDP)
     D WCust           S                   Like(TSCUST)                                       CER048
     D WCustTH         S                   Like(TECUST)                                       CER048
     D WTAMT           S             15  8                                                    CER048
     D WVDAT           S              4A                                                      CER048
     D WTTTDO          S             15P 0                                                    CER054
     D WTTTDT          S             15P 0                                                    CER054
     D @@DAYN          S              5  0                                                  BUG23514
     D W0VDT           S              4                                                     BUG23514
     D WDatPYr         S              4                                                     BUG23514
     D WStaxYr         S              6P 0                                                  BUG24280
     D WStaxYrA        S              6A                                                    BUG24280
     D WDdMm           S              4A                                                    BUG24280
     D WEtaxYr         S              6P 0                                                  BUG24280
     D WSYear          S              5P 0                                                  BUG24280
     D WEYear          S              5P 0                                                  BUG24280
     D TYear           S              4P 0                                                  BUG24280
     D WYear           S              2P 0                                                  BUG24280
     D WJeyd           S              5P 0                                                  BUG24280
     D WWYeaR          S              2P 0                                                  BUG24280
     D WWYeaRS         S              2P 0                                                  BUG24487
     D WwYr            S              2P 0                                                  BUG24280
     D WPAMS           S                   LIKE(TSPAMS)                                     AR763011
     D WPAMB           S                   LIKE(TSPAMB)                                     AR763011
     D PZADate         S              7A                                                    BUG24280
     D PZDate          S              6P 0                                                  BUG24280
     D PZDatfm         S              1A                                                    BUG24280
     D PZDayNo         S              5P 0                                                  BUG24280
     D PTaxYR          S              4A                                                    BUG24280
      *                                                                                     BUG24280
     D PDateIn         S              6P 0                                                  BUG24280
     D PErr            S              1A                                                    BUG24280
     D PFlag           S              1A                                                    BUG24280
     D WCnum           S              6A                                                    BUG25542
     D WYr             S              2A                                                    BUG24767
     D WYrP            S              2P 0                                                  BUG24767
     D WYrEnd          S              6P 0                                                  BUG24767
     D WYrEndP         S              5P 0                                                  BUG24767
     D PLoc            S              3A                                                    BUG24767
     D PCtry           S              2A                                                    BUG24767
 
      *                                                                                       CER048
      ***Key*Fields*for*KLIST*-*KACNTKY*                                            CER048 BUG24443A
      *  Key Fields for KLIST - KyRehis                                                    BUG24443A
      *                                                                                       CER048
     D*KCNUM****       S              6  0                                             CER048 CER059
     D KCNUM           S              6A                                                      CER059
     D KCCY            S              3A                                                      CER048
     D KACOD           S             10S 0                                                    CER048
     D KACSQ           S              2S 0                                                    CER048
     D KBRCA           S              3A                                                      CER048
     D KHISD           S              5P 0                                                 BUG24443A
      *                                                                                       CER048
     D ##PNAM          S              7A
     D ##RFMT          S              1A
     D WPathStr        S            256A
     D ZDAYNO          S              5P 0                                                    236193
     D ErrorFlag       S              7A                                                      236193
     D PClosure        S              1A                                                    BUG24244
 
     D/COPY CGCPYSRC,CGPACKDLE
      ** Data pack arrays and data structures
 
     D/COPY CGCPYSRC,SRERRDLE
      ** Fields, data structures, arrays definition for
      ** CG error processing
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'MAIN      '  @STK(Q)
 
      ** Initialisation Processing
 
     C                   EXSR      SRInit
 
      ** Tax Main Processing - top level group set
 
     C                   EXSR      SrTaxMain
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
      ** Termination
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTaxMain - Top Level Group Set                              *
      *                                                               *
      *****************************************************************
     C     SrTaxMain     BEGSR
 
      ** Set up subroutine stack name.
 
     C                   ADD       1             Q
     C                   MOVEL     'SrTaxMain '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     1             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\TAXMAN'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Generate reference number by writing to PF/CGUDCRPD.
 
     C                   EXSR      SrGenRef
 
     C                   If        WProduce = 'Y'                                             236193
                                                                                              236193
     C                   EXSR      PSHGRS
 
      ** Header (Simple)
 
     C                   EXSR      SrHdrDet
     C     1             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
                                                                                            BUG25542
      ** Access and extract all members if account is Joint.                                BUG25542
                                                                                            BUG25542
      ** Move PRef (10-long) to WCnum (6-long); Customer key field for                      BUG25542
      ** SDINPHL3 is only 6-long alpha.                                                     BUG25542
                                                                                            BUG25542
     C                   MOVEL     PRef          WCnum                                      BUG25542
                                                                                            BUG25542
     C     WCnum         SETLL     SDINPHL3                                                 BUG25542
     C     WCnum         READE     SDINPHL3                                                 BUG25542
     C                   DOW       NOT%EOF(SDINPHL3)                                        BUG25542
                                                                                            BUG25542
      ** Only process if Customer Number (TICUST) is different from                         BUG25542
      ** Joint Account Customer Number (TIJOIN). Note fields in SDINPHL3                    BUG25542
      ** has been renamed / suffixed by "J_" to avoid confusion with SDINPHL1.              BUG25542
                                                                                            BUG25542
     C                   IF        J_TICUST <> J_TIJOIN                                     BUG25542
                                                                                            BUG25542
      ** Generate Joint Account Members group (Complex)                                     BUG25542
                                                                                            BUG25542
     C                   EXSR      SrJtMbr1                                                 BUG25542
     C     1             OCCUR     WMDsSRDT                                                 BUG25542
     C                   MOVEL     WMDsPathGrp   WPathStr                                   BUG25542
     C                   Z-ADD     WMDsPrevBnd   S#PBIN                                     BUG25542
     C                   Z-ADD     WMDsThisBnd   S#TBIN                                     BUG25542
                                                                                            BUG25542
     C                   ENDIF                                                              BUG25542
                                                                                            BUG25542
     C     WCnum         READE     SDINPHL3                                                 BUG25542
     C                   ENDDO                                                              BUG25542
 
      ** Tax Details (complex)
 
     C                   EXSR      SRTaxDet
     C     1             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
 
      ** Reference Totals (simple)
 
     C                   IF        WCurrency <> *BLANK
 
     C                   EXSR      SrRefTot
     C     3             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
 
     C                   ENDIF
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
                                                                                              236193
     C                   Endif                                                                236193
                                                                                              236193
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrHdrDet - Header Details.                                   *
      *                                                               *
      *****************************************************************
     C     SrHdrDet      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrHdrDet  '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     2             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\TAXHDR'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Retrieve RDE info
 
     C                   MOVEL     'TAXHDR'      WGrpNme
     C                   EXSR      SrRtvRDE
 
      ** Rundate
 
     C**********         MOVEL     BJMRDT        ##D(1)                                       236193
     C                   MOVEL     BJRDNB        ##D(1)                                       236193
 
      ** Tax Year
 
     C                   MOVEL     PTaxYear      ##D(2)
 
      ** Customer Reference
 
     C                   MOVEL     PRef          ##D(3)
 
      ** Retrieve 4th element below (after call to AOCUSTR1), use ADDRESS LINE 1            BUG25542
      ** instead of CUSTOMER REPORTNAME as this may not be actual cust name.                BUG25542
      *                                                                                     BUG25542
      ***Report*Name                                                                        BUG25542
      **********                                                                            BUG25542
     C**********         MOVEL     PRepName      ##D(4)                                     BUG25542
 
      ** Report Town
 
     C                   MOVEL     PRepTown      ##D(5)
 
      ** Report Title                                                                         232543
                                                                                              232543
     C                   MOVEL     BJURPT        ##D(6)                                       232543
                                                                                              232543
      *                                                                                       CER048
      ** If CER048 is Installed                                                               CER048
      *                                                                                       CER048
     C     CER048        IFEQ      'Y'                                                        CER048
     C     PAcus         ANDEQ     'Y'                                                      BUG23971
      *                                                                                       CER048
      ** Access Customer Details                                                              CER048
      *                                                                                       CER048
     C                   MOVEL     PRef          PCust                                        CER048
      *                                                                                       CER048
     C**********         CALL      'AOCUSTR1'                                       CER048 AR750273B
     C                   CALL      'AOCUSTR0'                                              AR750273B
     C                   PARM      *BLANKS       PRtcd             7                          CER048
     C                   PARM      '*KEY   '     Poptn             7                          CER048
     C                   PARM                    Pcust            10                          CER048
     C                   PARM      *BLANKS       Pkey              7                          CER048
     C*****SDCUST        PARM      SDCUST        DSLDY                              CER048 AR750273B
     C     SDCUST        PARM      SDCUST        DSSDY                                     AR750273B
      *                                                                                       CER048
     C                   IF        PRtcd <> *BLANKS                                           CER048
     C                             AND PRtcd <> '*CUSCLS'                                  AR750273B
     C                             AND PRtcd <> '*CUSDEL'                                  AR750273B
     C**********                   AND PRtcd <> '*CUSCLO'                           CER048 AR750273B
     C                   MOVEL     'SDCUSTPD'    W0FILE                                       CER048
     C                   MOVEL     Pcust         W0KEY                                        CER048
     C                   Z-ADD     08            W0ERNB                                       CER048
     C                   MOVEL     'MEM5004'     W0MsgD                                       CER048
     C                   MOVEL     'MIDAS  '     W0MsgF                                       CER048
     C                   EXSR      SRERR                                                      CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                     BUG25542
      ** Customer Address Line 1                                                            BUG25542
      *                                                                                     BUG25542
     C                   MOVEL     BBCNA1        ##D(4)                                     BUG25542
      *                                                                                     BUG24244
      ** Set the Customer status flag                                                       BUG24244
      *                                                                                     BUG24244
     C                   MOVEL     *ZEROS        PDAYN                                      BUG24244
     C                   SELECT                                                             BUG24244
      *                                                                                     BUG24244
     C                   WHEN      BBCLST  ='Y'                                             BUG24244
     C                   MOVEL     BBCLDT        PDAYN                                      BUG24244
     C                   MOVEL     'C'           PClosure                                   BUG24244
      *                                                                                     BUG24244
     C                   WHEN      BBTYLC  ='D'                                             BUG24244
     C                   MOVEL     BBDTDL        PDAYN                                      BUG24244
     C                   MOVEL     'D'           PClosure                                   BUG24244
      *                                                                                     BUG24244
     C                   OTHER                                                              BUG24244
     C                   MOVEL     *ZEROS        PDAYN                                      BUG24244
     C                   MOVEL     'A'           PClosure                                   BUG24244
      *                                                                                     BUG24244
     C                   ENDSL                                                              BUG24244
      *                                                                                       CER048
      ** Customer Bankleitzahl                                                                CER048
      *                                                                                       CER048
     C                   MOVEL     BBBLCD        ##D(7)                                       CER048
      *                                                                                       CER048
      ***Date*Customer*Deleted                                                       CER048 BUG24244
      ** Date Customer Closed/Deleated/ Active                                              BUG24244
      *                                                                                       CER048
     C**********         MOVEL     BBDTDL        PDAYN                               CER048 BUG24244
     C**********         EXSR      ZDATE2                                            CER048 BUG24244
      *                                                                                       CER048
     C**********         MOVEL     PDAT7         ##D(8)                              CER048 BUG24244
     C                   MOVEL     PDAYN         ##D(8)                                     BUG24244
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Threshold Amount & Utilisation                                                       CER048
      *                                                                                       CER048
     C                   MOVEL     PRef          WCust                                        CER048
      *                                                                                       CER048
     C     WCust         CHAIN     SDINPHL1                                                   CER048
      *                                                                                       CER048
     C                   IF        %FOUND(SDINPHL1)                                           CER048
      *                                                                                       CER048
      ** Utilisation Upto Threshold                                                           CER048
      *                                                                                       CER048
      * Format Utilisation Up To Amount                                                     BUG23970
      *                                                                                     BUG23970
     C                   EVAL      PCurrency = BJCYCD                                       BUG23970
     C                   EXSR      SRAOCurr                                                 BUG23970
      *                                                                                     BUG23970
      ** Save Number of Decimal Places                                                      BUG23970
      *                                                                                     BUG23970
     C                   EVAL      WBCcyPl = A6NBDP                                         BUG23970
      *                                                                                     BUG23970
     C                   MOVEL     TIUTTH        ##D(9)                                       CER048
     C                   MOVE      WBCcyPl       ##D(9)                                     BUG23408
      *                                                                                       CER048
      ** Current Threshold                                                                    CER048
      *                                                                                       CER048
     C                   MOVEL     TICUTH        ##D(10)                                      CER048
     C                   MOVE      0             ##D(10)                                    BUG23408
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C**********         MOVEL     'SDINPHPD'    W0File                              CER048 BUG23147
     C**********         MOVEL     WCust         W0Key                               CER048 BUG23147
     C**********         Z-ADD     09            W0ERNB                              CER048 BUG23147
     C**********         MOVEL     'MEM5003'     W0MsgD                              CER048 BUG23147
     C**********         MOVEL     'MIDAS     '  W0MsgF                              CER048 BUG23147
     C**********         EXSR      SRERR                                             CER048 BUG23147
     C                   MOVE      *BLANKS       ##D(9)                                     BUG23147
     C                   MOVE      *BLANKS       ##D(10)                                    BUG23147
     C
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Threshold Value & Maturity Date                                                      CER048
      *                                                                                       CER048
     C                   MOVEL     PRef          WCustTH                                      CER048
      *                                                                                       CER048
     C     WCustTH       CHAIN     SDTHRHL1                                                   CER048
      *                                                                                       CER048
     C                   IF        %FOUND(SDTHRHL1)                                           CER048
      *                                                                                       CER048
      ** Threshold Value Date                                                                 CER048
      *                                                                                       CER048
     C                   MOVEL     TETRVD        PDAYN             5 0                        CER048
      *                                                                                       CER048
     C**********         EXSR      ZDATE2                                            CER048 BUG23313
      *                                                                                       CER048
     C**********         MOVEL     PDAT7         ##D(11)                             CER048 BUG23313
     C                   MOVEL     TETRVD        ##D(11)                                    BUG23313
      *                                                                                       CER048
      ** Threshold Maturity date                                                              CER048
      *                                                                                       CER048
     C**********         MOVEL     TETRMD        PDAYN                               CER048 BUG23313
      *                                                                                       CER048
     C**********         EXSR      ZDATE2                                            CER048 BUG23313
      *                                                                                       CER048
     C**********         MOVEL     PDAT7         ##D(12)                             CER048 BUG23313
     C                   MOVEL     TETRMD        ##D(12)                                    BUG23313
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
     C**********         MOVEL     'SDTHRHPD'    W0File                              CER048 BUG23147
     C**********         MOVEL     WCustTH       W0Key                               CER048 BUG23147
     C**********         Z-ADD     10            W0ERNB                              CER048 BUG23147
     C**********         MOVEL     'MEM5003'     W0MsgD                              CER048 BUG23147
     C**********         MOVEL     'MIDAS     '  W0MsgF                              CER048 BUG23147
     C**********         EXSR      SRERR                                             CER048 BUG23147
     C                   MOVE      *BLANKS       ##D(11)                                    BUG23147
     C                   MOVE      *BLANKS       ##D(12)                                    BUG23147
      *                                                                                     BUG23147
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C     PBranch       CHAIN     SDLTOFL1                                                   CER048
      *                                                                                       CER048
     C                   IF        NOT %FOUND(SDLTOFL1)                                       CER048
      *                                                                                       CER048
     C                   MOVEL     'SDLTOFPD'    W0File                                       CER048
     C                   MOVEL     PBranch       W0Key                                        CER048
     C                   Z-ADD     07            W0ERNB                                       CER048
     C                   MOVEL     'MEM5003'     W0MsgD                                       CER048
     C                   MOVEL     'MIDAS     '  W0MsgF                                       CER048
     C                   EXSR      SRERR                                                      CER048
      *                                                                                       CER048
     C                   ELSE                                                                 CER048
      *                                                                                       CER048
      ** Local Tax Office Name                                                                CER048
      *                                                                                       CER048
     C                   MOVEL     LTOFNM        ##D(13)                                      CER048
      *                                                                                       CER048
      ** Local Tax Office Number                                                              CER048
      *                                                                                       CER048
     C                   MOVEL     LTOFRN        ##D(14)                                      CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ** Customer Closed/Dealeted Flag                                                      BUG24244
      *                                                                                     BUG24244
     C                   MOVEL     PClosure      ##D(15)                                    BUG24244
      ** Setup First/Subsequent/Last Indicator
 
     C                   MOVE      'FR'          ##FSLI
 
      ** Accumulate RDEs and associated data and output to CGUDTAPD
 
     C                   EXSR      SrADTA
     C                   EXSR      SrODTA
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                BUG25542
      *****************************************************************                     BUG25542
      *                                                               *                     BUG25542
      *  SrJtMbr1 - Joint Account Members (complex)                   *                     BUG25542
      *                                                               *                     BUG25542
      *****************************************************************                     BUG25542
     C     SrJtMbr1      BEGSR                                                              BUG25542
                                                                                            BUG25542
      ** Set up subroutine stack name                                                       BUG25542
                                                                                            BUG25542
     C                   ADD       1             Q                                          BUG25542
     C                   MOVEL     'SrJtMbr1  '  @STK(Q)                                    BUG25542
                                                                                            BUG25542
      ** Retrieve subroutine specific data.                                                 BUG25542
                                                                                            BUG25542
     C     9             OCCUR     WMDsSRDT                                                 BUG25542
                                                                                            BUG25542
      ** Set up path.                                                                       BUG25542
                                                                                            BUG25542
     C                   MOVEL     '\JTMBR1'     ##PNAM                                     BUG25542
     C     WPathStr      CAT       ##PNAM:0      WPathStr                                   BUG25542
     C                   EXSR      PSHGRS                                                   BUG25542
     C                   MOVEL     WPathStr      WMDsPathGrp                                BUG25542
                                                                                            BUG25542
      ** Set up Binds from passed in values.                                                BUG25542
                                                                                            BUG25542
     C                   Z-ADD     S#PBIN        WMDsPrevBnd                                BUG25542
     C                   Z-ADD     S#TBIN        WMDsThisBnd                                BUG25542
                                                                                            BUG25542
      ** Initialise the First/Last/Subsequent Flag.                                         BUG25542
                                                                                            BUG25542
     C                   MOVE      'FR'          ##FSLI                                     BUG25542
                                                                                            BUG25542
      ** If data has been formatted but not written, process it.                            BUG25542
      ** (Note that this will not execute on first pass through SR and                      BUG25542
      ** that data relates to previous record to be extracted read.)                        BUG25542
                                                                                            BUG25542
     C                   IF        ##RFMT = 'Y'                                             BUG25542
                                                                                            BUG25542
      ** Output the Data.                                                                   BUG25542
                                                                                            BUG25542
     C                   EXSR      SRODTA                                                   BUG25542
                                                                                            BUG25542
      ** Set the First/Last/Subsequent Flag for Subsequent runs.                            BUG25542
                                                                                            BUG25542
     C                   MOVE      'SU'          ##FSLI                                     BUG25542
                                                                                            BUG25542
     C                   ENDIF                                                              BUG25542
                                                                                            BUG25542
      ** Increment Bind Levels.                                                             BUG25542
                                                                                            BUG25542
     C                   Z-ADD     S#TBINB       S#PBIN                                     BUG25542
     C                   ADD       1             ##BNDB                                     BUG25542
     C                   Z-ADD     ##BNDB        S#TBIN                                     BUG25542
                                                                                            BUG25542
      ** Joint Account Members (simple)                                                     BUG25542
                                                                                            BUG25542
     C                   EXSR      SrJtMbr2                                                 BUG25542
     C     9             OCCUR     WMDsSRDT                                                 BUG25542
     C                   MOVEL     WMDsPathGrp   WPathStr                                   BUG25542
     C                   Z-ADD     WMDsPrevBnd   S#PBIN                                     BUG25542
     C                   Z-ADD     WMDsThisBnd   S#TBIN                                     BUG25542
                                                                                            BUG25542
      ** Unwind subroutine stack name                                                       BUG25542
                                                                                            BUG25542
     C                   EXSR      POPGRS                                                   BUG25542
     C                   MOVEA     *BLANKS       @STK(Q)                                    BUG25542
     C                   SUB       1             Q                                          BUG25542
                                                                                            BUG25542
     C                   ENDSR                                                              BUG25542
      *****************************************************************                     BUG25542
      /EJECT                                                                                BUG25542
      *****************************************************************                     BUG25542
      *                                                               *                     BUG25542
      *  SrJtMbr2 - Joint Account Members (simple)                    *                     BUG25542
      *                                                               *                     BUG25542
      *****************************************************************                     BUG25542
     C     SrJtMbr2      BEGSR                                                              BUG25542
                                                                                            BUG25542
      ** Set up subroutine stack name                                                       BUG25542
                                                                                            BUG25542
     C                   ADD       1             Q                                          BUG25542
     C                   MOVEL     'SrJtMbr2 '   @STK(Q)                                    BUG25542
                                                                                            BUG25542
      ** Retrieve subroutine specific data.                                                 BUG25542
                                                                                            BUG25542
     C     10            OCCUR     WMDsSRDT                                                 BUG25542
                                                                                            BUG25542
      ** Set up path.                                                                       BUG25542
                                                                                            BUG25542
     C                   MOVEL     '\JTMBR2'     ##PNAM                                     BUG25542
     C     WPathStr      CAT       ##PNAM:0      WPathStr                                   BUG25542
     C                   EXSR      PSHGRS                                                   BUG25542
     C                   MOVEL     WPathStr      WMDsPathGrp                                BUG25542
                                                                                            BUG25542
      ** Set up Binds from passed in values.                                                BUG25542
                                                                                            BUG25542
     C                   Z-ADD     S#PBIN        WMDsPrevBnd                                BUG25542
     C                   Z-ADD     S#TBIN        WMDsThisBnd                                BUG25542
                                                                                            BUG25542
      ** Retrieve RDE info                                                                  BUG25542
                                                                                            BUG25542
     C                   MOVEL     'JTMBR2'      WGrpNme                                    BUG25542
     C                   EXSR      SrRtvRDE                                                 BUG25542
                                                                                            BUG25542
      ** Joint Customer Number                                                              BUG25542
      ** ---------------------                                                              BUG25542
     C                   MOVEL     J_TICUST      ##D(1)                                     BUG25542
                                                                                            BUG25542
      ** Joint Customer Report Name                                                         BUG25542
      ** --------------------------                                                         BUG25542
     C                   CALL      'AOCUSTR0'                                               BUG25542
     C                   PARM      *BLANKS       PRtcd                                      BUG25542
     C                   PARM      '*KEY   '     POptn                                      BUG25542
     C                   PARM      J_TICUST      PCnum                                      BUG25542
     C                   PARM                    PCnst                                      BUG25542
     C     SDCUST        PARM      SDCUST        DSLDY                                      BUG25542
                                                                                            BUG25542
     C                   MOVEL     BBCNA1        ##D(2)                                     BUG25542
                                                                                            BUG25542
      ** Utilisation Up To Threshold                                                        BUG25542
      ** ---------------------------                                                        BUG25542
      *                                                                                     BUG25542
     C                   MOVEL     J_TIUTTH      ##D(3)                                     BUG25542
     C                   MOVE      WBCcyPl       ##D(3)                                     BUG25542
                                                                                            BUG25542
      ** Current Threshold                                                                  BUG25542
      ** -----------------                                                                  BUG25542
     C                   MOVEL     J_TICUTH      ##D(4)                                     BUG25542
     C                   MOVE      0             ##D(4)                                     BUG25542
                                                                                            BUG25542
      ** Accumulate RDEs and associated data and output to CGUXMLPD                         BUG25542
                                                                                            BUG25542
     C                   EXSR      SrADTA                                                   BUG25542
                                                                                            BUG25542
      ** Unwind subroutine stack name                                                       BUG25542
                                                                                            BUG25542
     C                   EXSR      POPGRS                                                   BUG25542
     C                   MOVEA     *BLANKS       @STK(Q)                                    BUG25542
     C                   SUB       1             Q                                          BUG25542
                                                                                            BUG25542
     C                   ENDSR                                                              BUG25542
      *****************************************************************                     BUG25542
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTaxDet - Tax Details (complex)                             *
      *                                                               *
      *****************************************************************
     C     SrTaxDet      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrTaxDet  '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     3             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\TAXDET'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Access Customer Income File
 
     C                   SELECT
     C                   WHEN      PRefInd = 'C'
     C******LOVAL        SETLL     SDCSINL2                                                   234897
     C**********         READ      SDCSINL2                               15                  234897
      ** Read only relevant records for this customer.                                        234897
     C*****PCustNumChr6  SETLL     SDCSINL2                                          234897 BUG25075
     C*****PCustNumChr6  READE     SDCSINL2                               15         234897 BUG25075
     C     PCustNumChr6  SETLL     SDCSINLI                                                 BUG25075
     C     PCustNumChr6  READE     SDCSINLI                               15                BUG25075
     C                   WHEN      PRefInd = 'N'
     C******LOVAL        SETLL     SDCSINL3                                                   234897
     C**********         READ      SDCSINL3                               15                  234897
      ** Read only relevant records for this non-a/c holder.                                  234897
     C     PRef          SETLL     SDCSINL3                                                   234897
     C     PRef          READE     SDCSINL3                               15                  234897
     C                   ENDSL
     C                   MOVEL     'N'           FIRST             1                          236193
      *                                                                                     BUG25075
     C                   MOVEL     *BLANKS       RefInst          34                        BUG25075
     C                   MOVEL     *BLANKS       RefModi           1                        BUG25075
     C                   Z-ADD     *ZEROS        RefAcod          10 0                      BUG25075
 
     C                   DOW       *IN15 = *OFF
 
      ** Set Tax Year when extract is for Closed Customer                                   BUG24244
      *                                                                                     BUG24244
     C                   IF        PTaxYear = *ZEROS                                        BUG24244
     C                   MOVEL     TSTAXY        PTaxYear                                   BUG24244
     C                   ENDIF                                                              BUG24244
      *                                                                                     BUG24244
     C**********         IF        TSTAXY = PTaxYear AND                                    BUG24280
     C**********                   TSSTAT = 'S'                                               232543
     C                   IF        TSRDNB >= WSYear AND                                     BUG24280
     C                             TSRDNB <= WEYear AND                                     BUG24280
     C                             TSSTAT = 'T'                                               232543
 
     C                   IF        PRefInd = 'C' AND
     C                             TSCUST = PRef OR
     C                             PRefInd = 'N' AND
     C                             TSNAHO = PRef
 
      ** Ccy Total Details (simple)
 
     C                   IF        TSSCCY <> WCurrency AND
     C                             WCurrency <> *BLANKS
 
      ** The last record for the currency has been processed,
      ** set the First/Last/Subsequent flags accordingly then
      ** process the record.
 
     C                   IF        ##RFMT = 'Y'
     C                   MOVE      'LA'          DEFSLI
     C                   EXSR      SRODTA
     C                   ENDIF
 
     C                   Z-ADD     S#PBINB       S#PBIN
     C                   Z-ADD     S#TBINB       S#TBIN
     C                   EXSR      SrCcyTot
     C     3             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
 
     C                   ENDIF
 
     C                   EXSR      POPGRS                                                     236193
     C                   EXSR      PSHGRS                                                     236193
     C                   MOVEL     'Y'           FIRST                                        236193
                                                                                              236193
      ** Currency Details (simple)
 
     C                   IF        TSSCCY <> WCurrency
 
      ** Increment Bind Levels.
 
     C                   Z-ADD     WMDsThisBnd   S#PBIN
     C                   Z-ADD     S#PBIN        S#PBINB
     C                   ADD       1             ##BNDA
     C                   Z-ADD     ##BNDA        S#TBIN
     C                   Z-ADD     S#TBIN        S#TBINB
 
     C                   EXSR      SrCcyDet
     C     3             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
     C                   EVAL      WCurrency = TSSCCY
 
     C                   ENDIF
 
      ** Transaction Details 1 (complex)
 
     C                   EXSR      SRTrnDt1
     C     3             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
      *                                                                                       CER048
      ** Additional Tax Information                                                           CER048
      *                                                                                       CER048
     C**********         IF        CER048 = 'Y'                                               CER048
     C**********         EXSR      CGATAX                                                     CER048
     C**********         ENDIF                                                                CER048
      *                                                                                       CER048
     C                   ENDIF
     C                   ENDIF
 
      ** Read Next Record
 
     C                   SELECT
     C                   WHEN      PRefInd = 'C'
     C**********         READ      SDCSINL2                               15                  234897
     C*****PCustNumChr6  READE     SDCSINL2                               15         234897 BUG25075
     C     PCustNumChr6  READE     SDCSINLI                               15                BUG25075
     C                   WHEN      PRefInd = 'N'
     C**********         READ      SDCSINL3                               15                  234897
     C     PRef          READE     SDCSINL3                               15                  234897
     C                   ENDSL
 
     C                   ENDDO
 
     C                   IF        WCurrency <> *BLANKS
 
      ** Process last transaction and Last Currency Totals.
 
     C                   IF        ##RFMT = 'Y'
     C                   MOVE      'LA'          DEFSLI
     C                   EXSR      SRODTA
     C                   ENDIF
 
     C                   Z-ADD     S#PBINB       S#PBIN
     C                   Z-ADD     S#TBINB       S#TBIN
     C                   EXSR      SrCcyTot
     C     3             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
 
     C                   ENDIF
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCcyDet - Currency Details (simple)                         *
      *                                                               *
      *****************************************************************
     C     SrCcyDet      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrCcyDet  '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     4             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\TAXCCY'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Retrieve RDE info
 
     C                   MOVEL     'TAXCCY'      WGrpNme
     C                   EXSR      SrRtvRDE
 
      ** Retrieve Settlement Currency Details
 
     C                   EVAL      PCurrency = TSSCCY
     C                   EXSR      SRAOCurr
 
      ** Save Number of Decimal Places
 
     C                   EVAL      WSCcyPl = A6NBDP
 
      ** Currency Code
 
     C                   MOVEL     A6CYCD        ##D(1)
 
      ** Currency Description
 
     C*********          MOVEL     A6MACD        ##D(2)                                     BUG24790
     C                   MOVEL     A6CYNM        ##D(2)                                     BUG24790
                                                                                            BUG24790
      ** Retrieve Tax Currency Details                                                      BUG24790
                                                                                            BUG24790
     C                   EVAL      PCurrency = TSTXCY                                       BUG24790
     C                   EXSR      SRAOCurr                                                 BUG24790
                                                                                            BUG24790
      ** Tax Currency Code                                                                  BUG24790
                                                                                            BUG24790
     C                   MOVEL     A6CYCD        ##D(3)                                     BUG24790
                                                                                            BUG24790
      ** Tax Currency Description                                                           BUG24790
                                                                                            BUG24790
     C                   MOVEL     A6CYNM        ##D(4)                                     BUG24790
 
      ** Setup First/Subsequent/Last Indicator
 
     C                   MOVE      'FR'          ##FSLI
 
      ** Accumulate RDEs and associated data and output to CGUDTAPD
 
     C                   EXSR      SrADTA
     C                   EXSR      SrODTA
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTrnDt1 - Transaction Details (complex)                     *
      *                                                               *
      *****************************************************************
     C     SrTrnDt1      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrTrnDt1  '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     5             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\TRNDT1'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Initialise the First/Last/Subsequent Flag.
 
     C                   MOVE      'FR'          ##FSLI
 
      ** If data has been formatted but not written, process it.
      ** (Note that this will not execute on first pass through SR and
      ** that data relates to previous record to be extracted read.)
 
     C                   IF        ##RFMT = 'Y'
 
      ** Output the Data.
 
     C                   EXSR      SRODTA
 
      ** Set the First/Last/Subsequent Flag for Subsequent runs.
 
     C                   MOVE      'SU'          ##FSLI
 
     C                   ENDIF
 
      ** Increment Bind Levels.
 
     C                   Z-ADD     S#TBINB       S#PBIN
     C                   ADD       1             ##BNDB
     C                   Z-ADD     ##BNDB        S#TBIN
 
      ** Transaction Details (simple)
 
     C                   EXSR      SrTrnDt2
     C     5             OCCUR     WMDsSRDT
     C                   MOVEL     WMDsPathGrp   WPathStr
     C                   Z-ADD     WMDsPrevBnd   S#PBIN
     C                   Z-ADD     WMDsThisBnd   S#TBIN
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTrnDt2 - Transaction Details (simple)                      *
      *                                                               *
      *****************************************************************
     C     SrTrnDt2      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrTrnDt2 '   @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     6             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\TRNDT2'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Retrieve RDE info
 
     C                   MOVEL     'TRNDT2'      WGrpNme
     C                   EXSR      SrRtvRDE
 
      ** Interest Payment Date
 
     C                   EVAL      WDateDD = %SubSt(TSIPDT:7:2)
     C                   EVAL      WDateMM = %SubSt(TSIPDT:5:2)
     C                   EVAL      WDateYY = %SubSt(TSIPDT:3:2)
 
     C                   SELECT
     C                   WHEN      BJDFIN = 'M'
     C                   EVAL      WIPDT  = WDateMM + WDateDD + WDateYY
     C                   WHEN      BJDFIN = 'D'
     C                   EVAL      WIPDT  = WDateDD + WDateMM + WDateYY
     C                   WHEN      BJDFIN = 'Y'
     C                   EVAL      WIPDT  = WDateYY + WDateMM + WDateDD
     C                   ENDSL
     C                   MOVEL     WIPDT         ZDATE                                        236193
                                                                                              236193
     C                   TESTN                   WIPDT                9798                    236193
     C     *IN97         IFEQ      '1'                                                        236193
     C     *IN98         OREQ      '1'                                                        236193
     C                   CALL      'ZDATE1'                                                   236193
     C                   PARM                    ErrorFlag                                    236193
     C                   PARM                    ZDATE             6 0                        236193
     C                   PARM                    BJDFIN                                       236193
     C                   PARM      *ZEROS        ZDAYNO                                       236193
     C                   ENDIF                                                                236193
 
     C**********         MOVEL     WIPDT         ##D(1)                                       236193
     C                   MOVEL     ZDAYNO        ##D(1)                                       236193
     C**********         MOVEL     ZDAYNO        ##D(16)                          BUG23514A BUG25075
     C                   MOVEL     ZDAYNO        ##D(19)                                    BUG25075
 
      ** Module ID
 
     C                   MOVEL     TSMODI        ##D(2)
 
      ** Transaction Type
 
     C                   EVAL      WTType = *Blanks
 
     C                   SELECT
     C                   WHEN      TSMODI = 'D'
     C                   MOVE      TSDLLN        WDlln
     C                   EVAL      WTType = WDlln + '-' +
     C                                      TSTRTP + '/' + TSTRST
 
     C**********         WHEN      TSMODI = 'R'                                             AR763011
     C                   WHEN      TSMODI = 'G'                                             AR763011
     C                   MOVE      TSACOD        WAcod
     C                   MOVE      TSACSQ        WAcsq
     C                   EVAL      WTType = WAcod + ' - ' +
     C                                      WAcsq
 
     C                   WHEN      TSMODI = 'S'
     C                   EVAL      WTType = TSSESN + TSETYP
 
     C                   ENDSL
 
     C                   MOVEL     WTType        ##D(3)
 
      ** Principal Amount
 
     C**********         MOVEL     TSPAMS        ##D(4)                                     AR763011
     C                   IF        TSMODI = 'G'                                             AR763011
     C                   EVAL      WPAMS  = %ABS(TSPAMS)                                    AR763011
     C                   EVAL      WPAMB  = %ABS(TSPAMB)                                    AR763011
     C                   ELSE                                                               AR763011
     C                   EVAL      WPAMS  = TSPAMS                                          AR763011
     C                   EVAL      WPAMB  = TSPAMB                                          AR763011
     C                   ENDIF                                                              AR763011
     C                   MOVE      WSCcyPl       ##D(4)
 
     C                   MOVEL     WPAMS         ##D(4)                                     AR763011
     C**********         ADD       TSPAMS        WTPAMS                                     AR763011
     C**********         ADD       TSPAMB        WTPAMB                                     AR763011
     C                   ADD       WPAMS         WTPAMS                                     AR763011
     C                   ADD       WPAMB         WTPAMB                                     AR763011
 
      ** Gross Interest Amount
 
     C                   MOVEL     TSGINS        ##D(5)
     C                   MOVE      WSCcyPl       ##D(5)
 
     C**********         IF        TSPAMS < 0                                      BUG23719 AR763011
     C**********         Z-SUB     TSGINS        TSGINS                            BUG23719 AR763011
     C**********         Z-SUB     TSGINB        TSGINB                            BUG23719 AR763011
     C**********         ENDIF                                                     BUG23719 AR763011
     C                   ADD       TSGINS        WTGINS
     C                   ADD       TSGINB        WTGINB
 
      ** Tax Withheld in Original Currency
 
     C                   EVAL      PCurrency = TSOCCY
     C                   EXSR      SRAOCurr
 
     C                   EVAL      WOCcyPl = A6NBDP
 
     C                   MOVEL     TSTXSR        ##D(6)
     C                   MOVE      WOCcyPl       ##D(6)
 
     C                   ADD       TSTXSR        WTTXSR
     C                   ADD       TSTXSB        WTTXSB
 
      ** Exchange Rate
 
     C                   MOVEL     TSXRST        ##D(7)
     C                   MOVE      8             ##D(7)
 
      ** Tax Withheld in Tax Currency
 
     C                   EVAL      PCurrency = TSTXCY
     C                   EXSR      SRAOCurr
 
     C                   EVAL      WTCcyPl = A6NBDP
 
     C                   MOVEL     TSTXSC        ##D(8)
     C                   MOVE      WTCcyPl       ##D(8)
 
     C                   ADD       TSTXSC        WTTXSC
 
      *                                                                                       CER048
      ** If CER048 is Installed                                                               CER048
      *                                                                                       CER048
     C     CER048        IFEQ      'Y'                                                        CER048
      *                                                                                       CER048
      ** Period (Year or "from...to..." dates)                                                CER048
      *                                                                                       CER048
     C**********         Z-ADD     BJRDNB        @@DAYN            5 0               CER048 BUG23514
     C**********         Z-ADD     0             @@VDT             8 0               CER048 BUG23514
     C                   Z-ADD     BJRDNB        @@DAYN                                     BUG23514
     C                   Z-ADD     0             @@VDT                                      BUG23514
      *                                                                                       CER048
     C                   EXSR      ZDATE9                                                     CER048
      *                                                                                       CER048
     C**********         MOVEL     @@VDT         W0VDT             4                 CER048 BUG23514
     C                   MOVEL     @@VDT         W0VDT                                      BUG23514
      *                                                                                       CER048
     C                   MOVEL     W0VDT         ##D(9)                                       CER048
      *                                                                                       CER048
      ** Interest Period                                                                    BUG23514
     C                   IF        TSMODI = RefModi and TSINST = RefInst                    BUG25075
     C                             and TSACOD = RefAcod                                     BUG25075
     C     TSSLID        ADD       1             XTSLID            5 0                      BUG25075
     C                   MOVEL     XTSLID        ##D(17)                                    BUG25075
     C                   ELSE                                                               BUG25075
     C**********         MOVEL     TSSLID        ##D(14)                           BUG23514 BUG25075
     C                   MOVEL     TSSLID        ##D(17)                                    BUG25075
     C                   ENDIF                                                              BUG25075
     C**********         MOVEL     '-'           ##D(15)                           BUG23514 BUG25705
     C                   MOVEL     '-'           ##D(18)                                    BUG25705
      *                                                                                     BUG25075
     C                   EXSR      SRStrRef                                                 BUG25075
      *                                                                                     BUG25075
     C**********         MOVEL     TSIPDT        ##D(16)                          BUG23514 BUG23514A
                                                                                            BUG23514
      ** Interest Rate                                                                        CER048
      *                                                                                       CER048
      ** Remove Interest Rate calculation below and move to a subroutine (also use         BUG24443A
      ** historic DL files to correctly retrieve Int Rate of historic transactions)        BUG24443A
      *                                                                                    BUG24443A
      ** Comment out Interest Rate calculation as required by Change Request 008            BUG24789
      ** -----------------------------------------------------------------------            BUG24789
      ** To reinstate, remove the commenting of call to subroutine SrIntRate below.         BUG24789
      ** This will trigger the extraction of Interest Rate and will print label and         BUG24789
      ** rate on the FormsMaster form SDTaxAnnualDeductedStatement.OM5 (these will          BUG24789
      ** be hidden while no Int Rate exists in the xml extract .DAT)                        BUG24789
      *                                                                                     BUG24789
     C***********        EXSR      SrIntRate                                      BUG24443A BUG24789
      *                                                                                    BUG24443A
     C***********        IF        TSMODI = 'D'                                     CER048 BUG24443A
     C*****TSDLLN        CHAIN     DEALS                                            CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        IF        %FOUND(DEALS)                                    CER048 BUG24443A
     C***********        MOVEL     RTSP          ##D(10)                            CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        ELSE                                                       CER048 BUG24443A
     C***********        MOVEL     *ZERO         ##D(10)                            CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        ENDIF                                                      CER048 BUG24443A
     C***********        ENDIF                                                      CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        IF        TSMODI = 'G'                                     CER048 BUG24443A
     C***********        MOVEL     TSCUST        KCNUM                              CER048 BUG24443A
     C***********        MOVEL     TSOCCY        KCCY                               CER048 BUG24443A
     C***********        MOVEL     TSACOD        KACOD                              CER048 BUG24443A
     C***********        MOVEL     TSACSQ        KACSQ                              CER048 BUG24443A
     C***********        MOVEL     TSBRCA        KBRCA                              CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C*****KACNTKY       CHAIN     ACCNT                                            CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        IF        %FOUND(ACCNT) AND ATYP = 'R'                     CER048 BUG24443A
     C***********        MOVEL     CCIR          ##D(10)                            CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        ELSE                                                       CER048 BUG24443A
     C***********        MOVEL     *ZERO         ##D(10)                            CER048 BUG24443A
      ***********                                                                   CER048 BUG24443A
     C***********        ENDIF                                                      CER048 BUG24443A
     C***********        ENDIF                                                      CER048 BUG24443A
      *                                                                                       CER048
      ** Interest Period                                                                      CER048
      *                                                                                       CER048
     C                   MOVEL     PTaxYear      ##D(11)                                      CER048
      *                                                                                       CER048
      ** Secondary Tax amount deducted - Original Ccy                                         CER048
      *                                                                                       CER048
     C                   MOVEL     TSSTDO        ##D(12)                                      CER048
     C                   MOVE      WOCcyPl       ##D(12)                                      CER048
      *                                                                                       CER048
      ** Secondary Tax amount deducted - Tax Ccy                                              CER048
      *                                                                                       CER048
     C                   MOVEL     TSSTDT        ##D(13)                                      CER048
     C                   MOVE      WTCcyPl       ##D(13)                                      CER048
      *                                                                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        CER054 = 'Y'                                               CER054
      *                                                                                       CER054
     C                   MOVEL     TSTTDO        ##D(14)                                      CER054
     C                   MOVE      WOCcyPl       ##D(14)                                      CER054
      *                                                                                       CER054
     C                   MOVEL     TSTTDT        ##D(15)                                      CER054
     C                   MOVE      WTCcyPl       ##D(15)                                      CER054
      *                                                                                       CER054
     C                   MOVEL     TSTTRA        ##D(16)                                      CER054
      *                                                                                       CER054
     C                   ADD       TSTTDO        WTTTDO                                       CER054
     C                   ADD       TSTTDT        WTTTDT                                       CER054
      *                                                                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Accumulate RDEs and associated data and output to CGUDTAPD
 
     C                   EXSR      SrADTA
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                               BUG24443A
      *****************************************************************                    BUG24443A
      *                                                               *                    BUG24443A
      *  SrIntRate - Extract Interest Rate                            *                    BUG24443A
      *                                                               *                    BUG24443A
      *****************************************************************                    BUG24443A
     C     SrIntRate     BEGSR                                                             BUG24443A
      *                                                                                    BUG24443A
      ** Dealing transaction (module ID is 'D')                                            BUG24443A
      *                                                                                    BUG24443A
     C                   IF        TSMODI = 'D'                                            BUG24443A
      *                                                                                    BUG24443A
      ** Scan both live and historic deals files                                           BUG24443A
      *                                                                                    BUG24443A
     C     TSDLLN        CHAIN     DEALSALL                                                BUG24443A
      *                                                                                    BUG24443A
     C                   IF        %FOUND (DEALSALL)                                       BUG24443A
     C                   MOVEL     INTR          ##D(10)                                   BUG24443A
     C                   ELSE                                                              BUG24443A
     C                   MOVEL     *ZERO         ##D(10)                                   BUG24443A
     C                   ENDIF                                                             BUG24443A
      *                                                                                    BUG24443A
     C                   ENDIF                                                             BUG24443A
      *                                                                                    BUG24443A
      * ----------------------------------------------------                               BUG24443A
      ** Retail Capitalisation (module ID is 'G')                                          BUG24443A
      *                                                                                    BUG24443A
     C                   IF        TSMODI = 'G'                                            BUG24443A
      *                                                                                    BUG24443A
     C                   MOVEL     TSCUST        KCNUM                                     BUG24443A
     C                   MOVEL     TSOCCY        KCCY                                      BUG24443A
     C                   MOVEL     TSACOD        KACOD                                     BUG24443A
     C                   MOVEL     TSACSQ        KACSQ                                     BUG24443A
     C                   MOVEL     TSBRCA        KBRCA                                     BUG24443A
     C                   EVAL      KHISD = TSEDAT                                          BUG24443A
      *                                                                                    BUG24443A
      ** Position pointer past the account + tax calc date then                            BUG24443A
      ** read previous record to obtain the rate on or before tax calc date.               BUG24443A
      *                                                                                    BUG24443A
     C     KyRehis       SETGT     REHISDL                                                 BUG24443A
     C                   READP     REHISDL                                                 BUG24443A
      *                                                                                    BUG24443A
     C                   IF        NOT %EOF                                                BUG24443A
     C                   MOVEL     CRIR          ##D(10)                                   BUG24443A
     C                   ELSE                                                              BUG24443A
     C                   MOVEL     *ZERO         ##D(10)                                   BUG24443A
     C                   ENDIF                                                             BUG24443A
      *                                                                                    BUG24443A
     C                   ENDIF                                                             BUG24443A
      *                                                                                    BUG24443A
     C                   ENDSR                                                             BUG24443A
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
      *                                                               *
      *  SrCcyTot - Currency Total Details (simple)                   *
      *                                                               *
      *****************************************************************
     C     SrCcyTot      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrCcyTot  '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     7             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\CCYTOT'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Retrieve RDE info
 
     C                   MOVEL     'CCYTOT'      WGrpNme
     C                   EXSR      SrRtvRDE
 
      ** Currency Total of Principal Amount
 
     C                   MOVEL     WTPAMS        ##D(1)
     C                   MOVE      WSCcyPl       ##D(1)
 
      ** Currency Total of Gross Interest Amount
 
     C                   MOVEL     WTGINS        ##D(2)
     C                   MOVE      WSCcyPl       ##D(2)
 
      ** Currency Total of Tax Withheld in Original Currency
 
     C                   MOVEL     WTTXSR        ##D(3)
     C                   MOVE      WOCcyPl       ##D(3)
 
      ** Currency Total of Tax Withheld in Tax Currency
 
     C                   MOVEL     WTTXSC        ##D(4)
     C                   MOVE      WTCcyPl       ##D(4)
      *                                                                                       CER054
     C                   IF        CER054 = 'Y'                                               CER054
                                                                                              CER054
     C                   MOVEL     WTTTDO        ##D(5)                                       CER054
     C                   MOVE      WOCcyPl       ##D(5)                                       CER054
                                                                                              CER054
     C                   MOVEL     WTTTDT        ##D(6)                                       CER054
     C                   MOVE      WTCcyPl       ##D(6)                                       CER054
                                                                                              CER054
     C                   ENDIF                                                                CER054
 
      ** Setup First/Subsequent/Last Indicator
 
     C                   MOVE      'LA'          ##FSLI
 
      ** Accumulate RDEs and associated data and output to CGUDTAPD
 
     C                   EXSR      SrADTA
     C                   EXSR      SrODTA
 
      ** Reset Currency Total Amount Fields
 
     C                   EVAL      WTPAMS = *ZERO
     C                   EVAL      WTGINS = *ZERO
     C                   EVAL      WTTXSR = *ZERO
     C                   EVAL      WTTXSC = *ZERO
     C                   EVAL      WTTTDO = *ZERO                                             CER054
     C                   EVAL      WTTTDT = *ZERO                                             CER054
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRefTot - Reference Totals Details.                         *
      *                                                               *
      *****************************************************************
     C     SrRefTot      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrRefTot  '  @STK(Q)
 
      ** Retrieve subroutine specific data.
 
     C     8             OCCUR     WMDsSRDT
 
      ** Set up path.
 
     C                   MOVEL     '\REFTOT'     ##PNAM
     C     WPathStr      CAT       ##PNAM:0      WPathStr
     C                   EXSR      PSHGRS
     C                   MOVEL     WPathStr      WMDsPathGrp
 
      ** Set up Binds from passed in values.
 
     C                   Z-ADD     S#PBIN        WMDsPrevBnd
     C                   Z-ADD     S#TBIN        WMDsThisBnd
 
      ** Retrieve RDE info
 
     C                   MOVEL     'REFTOT'      WGrpNme
     C                   EXSR      SrRtvRDE
 
      ** Retrieve Base Currency Details
 
     C                   EVAL      PCurrency = BJCYCD
     C                   EXSR      SRAOCurr
 
      ** Save Number of Decimal Places
 
     C                   EVAL      WBCcyPl = A6NBDP
 
      ** Reference Total of Principal Amount
 
     C                   MOVEL     WTPAMB        ##D(1)
     C                   MOVE      WBCcyPl       ##D(1)
 
      ** Reference Total of Gross Interest Amount
 
     C                   MOVEL     WTGINB        ##D(2)
     C                   MOVE      WBCcyPl       ##D(2)
 
      ** Reference Total of Tax Withheld in Original Currency
 
     C                   MOVEL     WTTXSB        ##D(3)
     C                   MOVE      WBCcyPl       ##D(3)
 
      ** Setup First/Subsequent/Last Indicator
 
     C                   MOVE      'FR'          ##FSLI
 
      ** Accumulate RDEs and associated data and output to CGUDTAPD
 
     C                   EXSR      SrADTA
     C                   EXSR      SrODTA
 
      ** Reset Reference Total Amount Fields
 
     C                   EVAL      WTPAMB = *ZERO
     C                   EVAL      WTGINB = *ZERO
     C                   EVAL      WTTXSB = *ZERO
 
      ** Unwind subroutine stack name
 
     C                   EXSR      POPGRS
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGenRef - Generate reference number and write to CGUDCRPD.  *
      *                                                               *
      *****************************************************************
     C     SrGenRef      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrGenRef  '  @STK(Q)
 
      ** Reset the flag that indicates wether a correspondence is to be
      ** produced or not.
 
     C                   MOVEL     'N'           WProduce
 
      ** Set up fields of parameter PEDsCGUDCRPD to be passed to CG9010
 
     C                   CLEAR                   PEDsCGUDCRPD
 
      ** Booking/Main branch (mandatory)
 
     C******             MOVEL     'DOM'         DRBRCA                                       234502
     C                   MOVEL     PBranch       DRBRCA                                       234502
 
      ** Module ID (mandatory)
 
     C                   MOVEL     'SD'          DRMODI
 
      ** Customer Reference and Country of Tax
 
     C                   EVAL      DRMTRN = 'TS_' + PRef
 
      ** Print Item Type
 
     C                   MOVEL     WCPrtItmTyp   DRPTYP
 
      ** Print Item Subtype
 
     C                   MOVEL     WCPrtItmSubTypDRPSTP
 
      ** Auto Transmission indicator
 
     C                   MOVEL     'N'           DRATRM
 
      ***Customer******************************************************                       234897
      ** Customer (received as part of *ENTRY-parm from CG006100)                             234897
 
     C                   MOVE      *BLANKS       PCustNumChr6
     C**********         MOVE      TSCUST        PCustNumChr6                                 234897
     C                   MOVEL     PRef          PCustNumChr6                                 234897
 
      ** Output to CGUDCRPD
 
     C                   CALL      'CG9010'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM      '*GEN'        PMode
     C                   PARM                    W0CMT
     C                   PARM                    PCustNumChr6
     C                   PARM                    PEDsCGUDCRPD
     C                   PARM      *BLANKS       PItmRef
 
     C                   SELECT
 
      ** No error, generate correspondence
 
     C                   WHEN      PRtnCode = *BLANKS
     C                   MOVEL     'Y'           WProduce
     C                   MOVE      PItmRef       ##ITEM
     C     DRPTYP        CAT       ':':0         COLON
     C     COLON         CAT       DRPSTP:0      ##REFR
     C                   EXSR      WRAPRF
 
      ** No error, suppress output
 
     C                   WHEN      PRtnCode = 'CGD1270'
     C                   MOVEL     'N'           WProduce                                     236129
     C                   MOVE      *ON           *INLR                                        236129
     C                   RETURN                                                               236129
 
      ** Error.
 
     C                   OTHER
     C                   MOVEL     'CG9010'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     01            W0ERNB
     C                   MOVEL     'CGD1286'     W0MsgD
     C                   MOVEL     'CGUSRMSG'    W0MsgF
     C                   EXSR      SRERR
 
     C                   ENDSL
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRtvRDE - Retrieve 20 RDE's from the compile-time array and *
      *             store it in ##R.                                  *
      *                                                               *
      *****************************************************************
     C     SrRtvRDE      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrRtvRDE  '  @STK(Q)
 
      ** Reset primary arrays
 
     C                   CLEAR                   ##R
     C                   CLEAR                   ##D
     C                   CLEAR                   ##S
 
      ** Get info from compile time array of the 20 RDEs in group set
 
     C                   Z-ADD     1             Wx1
     C                   Z-ADD     1             WGrpSeq
     C                   DOU       *IN61 = *OFF
     C                             OR (Wx1 > 20)
     C                   Z-ADD     1             Wx2
     C     WGrp10        LOOKUP    WTbGrp(Wx2)                            61
     C                   IF        *IN61 = *ON
     C                   MOVEL     WTbRDE(Wx2)   ##R(Wx1)
     C                   ADD       1             Wx1
     C                   ADD       1             WGrpSeq
     C                   ENDIF
     C                   ENDDO
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrFmtDta - Reformat data before packing it.                   *
      *                                                               *
      *****************************************************************
     C     SrFmtDta      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrFmtDta  '  @STK(Q)
 
      ** Loop through RDE's and data
 
     C                   Z-ADD     0             Wx1
 
     C     Wx1           DOUEQ     20
 
      ** Move RDE's and its data to their templates
 
     C                   ADD       1             Wx1
     C                   MOVEL     ##R(Wx1)      R#DEFN
     C                   MOVEL     ##D(Wx1)      R#DATA
 
      ** Reformat only if data is present and RDE is edited
 
     C                   IF        R#DATA <> *BLANK AND
     C                             ##RDEC <> *BLANK
 
      ** Right-align amount
 
     C                   MOVEA     ##NUMA        WAr29
     C                   Z-ADD     1             Wx2
     C     *BLANK        LOOKUP    WAr29(Wx2)                             61
     C                   Z-ADD     20            Wx3
     C                   Z-ADD     0             WNum20
 
     C                   DOW       Wx2 > 1 AND
     C                             Wx2 <= 20 AND
     C                             Wx3 > 1
     C                   SUB       1             Wx2
     C                   MOVEL     WAr29(Wx2)    WAr20(Wx3)
     C                   SUB       1             Wx3
     C                   ENDDO
 
      ** Sign
 
     C                   IF        ##SIGN = '-'
     C                   Z-SUB     WNum20        ##NUMB
     C                   ELSE
     C                   Z-ADD     WNum20        ##NUMB
     C                   ENDIF
 
      ** Edit type
 
     C                   IF        ##EDTT = *BLANK
     C                   MOVEL     ##RDET        ##EDTT
     C                   ENDIF
 
      ** Default decimal places
 
     C                   IF        ##DCPA = *BLANK
     C                   MOVEL     ##RDED        ##DCPA
     C                   ENDIF
 
      ** New RDE data
 
     C                   MOVEL     R#DATA        ##D(Wx1)
 
     C                   ENDIF
 
     C                   ENDDO
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrADTA - Accumulate RDEs and associated data for output.     *
      *                                                               *
      *****************************************************************
     C     SrADTA        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrADTA    '  @STK(Q)
 
      ** Reformat RDE data
 
     C                   EXSR      SrFmtDta
 
      ** Pack RDEs and associated data into data string
 
     C                   CLEAR                   ##SDS
 
     C                   IF        CCG015 = 'Y'
     C                   MOVEL     '*NEWARR '    PAction8
     C                   MOVEL     WPathStr      W0SPAT
     C                   ELSE
     C                   MOVEL     '*PACK   '    PAction8
     C                   MOVEL     *BLANKS       W0SPAT
     C                   ENDIF
 
     C                   CALL      'CG3999'
     C                   PARM      *BLANKS       PRtnCode
     C                   PARM                    PAction8
     C                   PARM                    ##R
     C                   PARM                    ##D
     C                   PARM                    ##S
     C                   PARM                    W0SPAT
     C                   PARM                    ##RN
     C                   PARM                    ##DN
     C                   PARM                    ##FM
 
     C                   IF        PRtnCode <> *BLANKS
     C                   MOVEL     'CG3999'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     02            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
 
      ** Write XML record for RDE
 
     C                   EXSR      WRTRDE
 
      ** Initialise write format parameter
 
     C                   CLEAR                   PEDsCGUDTAPD
 
      ** Setup Control Information.
 
     C                   Z-ADD     ##ITEM        DEITEM
     C                   ADD       1             ##OSEQ
     C                   Z-ADD     ##OSEQ        DEOSEQ
     C                   Z-ADD     WMDsPrevBnd   DEPBIN
     C                   Z-ADD     WMDsThisBnd   DETBIN
     C                   MOVE      ##FSLI        DEFSLI
     C                   MOVE      *BLANKS       W0PATH
     C                   MOVEL     WPathStr      W0PATH
 
      ** Append Data from pack routine.
 
     C                   MOVEA     ##S           ##SDS
 
     C     PEDsCGUDTAPD  CAT       ##SDS:0       PEDsCGUDTAPD
 
      ** Set Flag to show record formatted.
 
     C                   MOVE      'Y'           ##RFMT
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrODTA - Output Accumulated data to PF/CGUDTAPD              *
      *                                                               *
      *****************************************************************
     C     SrODTA        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrODTA    '  @STK(Q)
 
      ** Output PF/CGUDTAPD Record.
 
     C                   IF        CCG015 = 'N'
 
     C                   CALL      'CG9020'
     C                   PARM      *BLANK        PRtnCode
     C                   PARM      '*WRITE'      PAction8
     C                   PARM                    W0PATH
     C                   PARM                    PEDsCGUDTAPD
     C                   PARM      *BLANK        W0TITL            7
     C                   PARM      *BLANK        W0ULIN            7
     C                   PARM                    W0CMT
 
     C                   IF        PRtnCode <> *BLANK
 
     C                   MOVEL     'CG9020'      W0File
     C                   MOVEL     PRtnCode      W0Key
     C                   Z-ADD     03            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
 
     C                   ENDIF
     C                   ENDIF
 
      **  Reset Flag to show formatted data output.
 
     C                   MOVE      *BLANKS       ##RFMT
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAOCurr - Retrieve Currency Details                         *
      *                                                               *
      *****************************************************************
     C     SrAOCurr      BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrAOCurr  '  @STK(Q)
 
      ** Retrieve Currency Details
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCurrency
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
 
      ** Handle Database Error if any occur.
 
     C                   MOVEL     'SDCURRPD'    W0File
     C                   MOVEL     PCurrency     W0Key
     C                   Z-ADD     04            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS  '     W0MsgF
     C                   EXSR      SRERR
 
     C                   ENDIF
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation Processing                           *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
 
      ** Set up subroutine stack name
 
     C                   ADD       1             Q
     C                   MOVEL     'SrInit    '  @STK(Q)
 
      ** Initialise work variables
 
     C                   EVAL      WCurrency = *BLANK
     C                   EVAL      WTPAMS = *ZERO
     C                   EVAL      WTPAMB = *ZERO
     C                   EVAL      WTGINS = *ZERO
     C                   EVAL      WTGINB = *ZERO
     C                   EVAL      WTTXSR = *ZERO
     C                   EVAL      WTTXSB = *ZERO
     C                   EVAL      WTTXSC = *ZERO
     C                   EVAL      WTTTDO = *ZERO                                             CER054
     C                   EVAL      WTTTDT = *ZERO                                             CER054
     C                   EVAL      ##OSEQ = *ZERO
     C                   MOVE      *BLANKS       WMDsPathGrp
 
      ** Iniitialise Binds.
 
     C                   Z-ADD     1             S#PBIN
     C                   Z-ADD     1             S#TBIN
     C                   Z-ADD     1             ##BNDA
     C                   Z-ADD     2             ##BNDB
 
      ** Initialise XML increment.
 
     C                   EXSR      INIXML
 
      ** Unwind subroutine stack name
 
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Initialization routine                               *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN
     C                   PARM                    W0CMT
     C                   PARM                    WProduce
     C                   PARM                    WAUTO
     C                   PARM                    DSPARM
 
      ** Define Fields
 
     C     *LIKE         DEFINE    DEFSLI        ##FSLI
     C     *LIKE         DEFINE    DEPBIN        ##BNDA
     C     *LIKE         DEFINE    DEPBIN        ##BNDB
     C     *LIKE         DEFINE    DEPBIN        S#PBIN
     C     *LIKE         DEFINE    DEPBIN        S#PBINB
     C     *LIKE         DEFINE    DETBIN        S#TBIN
     C     *LIKE         DEFINE    DETBIN        S#TBINB
     C     *LIKE         DEFINE    DEOSEQ        ##OSEQ
 
      ** Access Bank Details.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error if any occur.
 
     C                   IF        PRtCd <> *Blanks
     C                   EVAL      W0FILE = 'SDBANKPD'
     C                   MOVEL     POptn         W0Key
     C                   Z-ADD     05            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS     '  W0MsgF
     C                   EXSR      SRERR
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
     C                   EVAL      W0FILE = 'SDLOCNPD'                                      BUG24767
     C                   MOVEL     POptn         W0Key                                      BUG24767
     C                   Z-ADD     12            W0ERNB                                     BUG24767
     C                   MOVEL     'MEM5003'     W0MsgD                                     BUG24767
     C                   MOVEL     'MIDAS     '  W0MsgF                                     BUG24767
     C                   EXSR      SRERR                                                    BUG24767
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
     C                   EVAL      W0FILE = 'SDBANKPD'                                      BUG24767
     C                   MOVEL     POptn         W0Key                                      BUG24767
     C                   Z-ADD     13            W0ERNB                                     BUG24767
     C                   MOVEL     'MEM5003'     W0MsgD                                     BUG24767
     C                   MOVEL     'MIDAS     '  W0MsgF                                     BUG24767
     C                   EXSR      SRERR                                                    BUG24767
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
 
      ** Access SAR details file to determine if CCG015 is on.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CCG015'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
      ** Handle Database Error if any occur.
 
     C                   IF        PRtcd <> *Blanks and
     C                             PRtcd <> '*NRF   '
     C                   EVAL      W0FILE = 'SCSARDPD'
     C                   MOVEL     'CCG015'      W0Key
     C                   Z-ADD     06            W0ERNB
     C                   MOVEL     'MEM5003'     W0MsgD
     C                   MOVEL     'MIDAS     '  W0MsgF
     C                   EXSR      SRERR
     C                   ENDIF
 
     C                   IF        PRtcd = *Blanks
     C                   EVAL      CCG015 = 'Y'
     C                   ELSE
     C                   EVAL      CCG015 = 'N'
     C                   ENDIF
 
      *                                                                                       CER048
      ** Access SAR details file to determine if CER048 is on.                                CER048
      *                                                                                       CER048
     C                   CALL      'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRtcd                                        CER048
     C                   PARM      '*VERIFY'     POptn                                        CER048
     C                   PARM      'CER048'      PSard                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRtcd <> *Blanks and                                       CER048
     C                             PRtcd <> '*NRF   '                                         CER048
     C                   EVAL      W0FILE = 'SCSARDPD'                                        CER048
     C                   MOVEL     'CER048'      W0Key                                        CER048
     C                   Z-ADD     11            W0ERNB                                       CER048
     C                   MOVEL     'MEM5003'     W0MsgD                                       CER048
     C                   MOVEL     'MIDAS     '  W0MsgF                                       CER048
     C                   EXSR      SRERR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRtcd = *BLANKS                                            CER048
     C                   MOVEL     'Y'           CER048            1                          CER048
     C                   ELSE                                                                 CER048
     C                   MOVEL     'N'           CER048                                       CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
      ***Keylist*for*ACCNT*file                                                     CER048 BUG24443A
      ************                                                                  CER048 BUG24443A
     C*****KACNTKY       KLIST                                                      CER048 BUG24443A
     C************       KFLD                    KCNUM                              CER048 BUG24443A
     C************       KFLD                    KCCY                               CER048 BUG24443A
     C************       KFLD                    KACOD                              CER048 BUG24443A
     C************       KFLD                    KACSQ                              CER048 BUG24443A
     C************       KFLD                    KBRCA                              CER048 BUG24443A
      *                                                                                    BUG24443A
      ** Key field for Retail History file                                                 BUG24443A
     C     KyRehis       KLIST                                                             BUG24443A
     C                   KFLD                    KBRCA                                     BUG24443A
     C                   KFLD                    KCNUM                                     BUG24443A
     C                   KFLD                    KCCY                                      BUG24443A
     C                   KFLD                    KACOD                                     BUG24443A
     C                   KFLD                    KACSQ                                     BUG24443A
     C                   KFLD                    KHISD                                     BUG24443A
      *                                                                                       CER048
      ** Access SAR details file to determine if CER054 is on.                                CER054
      *                                                                                       CER054
     C                   CALL      'AOSARDR0'                                                 CER054
     C                   PARM      *BLANKS       PRtcd                                        CER054
     C                   PARM      '*VERIFY'     POptn                                        CER054
     C                   PARM      'CER054'      PSard                                        CER054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER054
      *                                                                                       CER054
     C                   IF        PRtcd <> *BLANKS                                           CER054
     C                             AND PRtcd <> '*NRF   '                                     CER054
     C                   EVAL      W0FILE = 'SCSARDPD'                                        CER054
     C                   MOVEL     'CER054'      W0Key                                        CER054
     C                   Z-ADD     12            W0ERNB                                       CER054
     C                   MOVEL     'MEM5003'     W0MsgD                                       CER054
     C                   MOVEL     'MIDAS     '  W0MsgF                                       CER054
     C                   EXSR      SRERR                                                      CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
     C                   MOVEL     'N'           CER054            1                          CER054
      *                                                                                       CER054
     C                   IF        PRtcd = *BLANKS                                            CER054
     C                   MOVEL     'Y'           CER054                                       CER054
     C                   ENDIF                                                                CER054
      *                                                                                       CER054
      ** Calculate "Start" and "End" Date of Year only when Year is                         BUG24280
      ** entered                                                                            BUG24280
      *                                                                                     BUG24280
     C                   MOVEL     PTaxYear      PTaxYr                                     BUG24280
      *                                                                                     BUG24280
     C                   IF        PTaxYr <> *BLANKS                                        BUG24280
     C                             AND PTaxYr <> '0000'                                     BUG24487
     C                             OR (PTaxYrF <> *BLANKS AND                               BUG24487
     C                             PTaxYrT <> *BLANKS)                                      BUG24487
      *                                                                                     BUG24280
     C                   IF        PTaxYr <> *BLANKS AND                                    BUG24487
     C                             PTaxYr <> '0000'                                         BUG24487
     C                   MOVE      PTaxYear      WWYeaR                                     BUG24280
     C                   MOVE      PTaxYear      WWYeaRS                                    BUG24487
     C                   ELSE                                                               BUG24487
     C                   IF        PTaxYrF <> *BLANKS AND                                   BUG24487
     C                             PTaxYrT <> *BLANKS                                       BUG24487
     C                   MOVE      PTaxYrT       WWYeaR                                     BUG24487
     C                   MOVE      PTaxYrF       WWYeaRS                                    BUG24487
     C                   ENDIF                                                              BUG24487
     C                   ENDIF                                                              BUG24487
      *                                                                                     BUG24280
     C**********         EVAL      PZDayNo = BJEYD                                 BUG24280 BUG24767
     C                   EVAL      PZDayNo = WYrEndP                                        BUG24767
     C                   EXSR      SRZDate                                                  BUG24280
     C                   MOVE      PZDate        WwYr                                       BUG24280
      *                                                                                     BUG24280
     C                   IF        WWYeaR <> WwYr                                           BUG24280
      *                                                                                     BUG24280
     C                   EVAL      WETaxYr = PZDate                                         BUG24280
     C                   MOVE      WWYeaR        WETaxYr                                    BUG24280
      *                                                                                     BUG24280
      ** Convert the End of Year Date No. to DDMMYY format                                  BUG24280
      *                                                                                     BUG24280
     C                   MOVEL     WETaxYr       PDateIn                                    BUG24280
      *                                                                                     BUG24280
     C                   CALL      'ZDATE1'                                                 BUG24280
     C                   PARM      *BLANKS       PErr                                       BUG24280
     C                   PARM                    PDateIn                                    BUG24280
     C                   PARM                    BJDFIN                                     BUG24280
     C                   PARM      *ZEROS        PZDayNo                                    BUG24280
      *                                                                                     BUG24280
     C                   EVAL      WEYear = PZDayNo                                         BUG24280
      *                                                                                     BUG24280
     C                   ELSE                                                               BUG24280
      *                                                                                     BUG24280
     C**********         EVAL      WEYear = BJEYD                                  BUG24280 BUG24767
     C                   EVAL      WEYear = WYrEndP                                         BUG24767
      *                                                                                     BUG24280
     C                   ENDIF                                                              BUG24280
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
     C**********         IF        WWYeaR <= 39                                    BUG24280 BUG24487
     C                   IF        WWYeaRS <= 39                                            BUG24487
     C                   MOVEL     20            TYear                                      BUG24280
     C                   ELSE                                                               BUG24280
     C                   MOVEL     19            TYear                                      BUG24280
     C                   ENDIF                                                              BUG24280
      *                                                                                     BUG24280
     C**********         MOVE      WWYeaR        TYear                             BUG24280 BUG24487
     C                   MOVE      WWYeaRS       TYear                                      BUG24487
      *                                                                                     BUG24280
     C                   IF        WDdMm <> '0101'                                          BUG24280
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
     C                   CALL      'ZDATE1'                                                 BUG24280
     C                   PARM      *BLANKS       PErr                                       BUG24280
     C                   PARM                    PDateIn                                    BUG24280
     C                   PARM                    BJDFIN                                     BUG24280
     C                   PARM      *ZEROS        PZDayNo                                    BUG24280
      *                                                                                     BUG24280
     C                   EVAL      WSYear = PZDayNo                                         BUG24280
      *                                                                                     BUG24280
     C                   ENDIF                                                              BUG24280
      *                                                                                     BUG24280
     C                   MOVE      *BLANKS       WPathStr
 
     C                   ENDSR
      *****************************************************************                     BUG24280
      /EJECT                                                                                BUG24280
      *****************************************************************                     BUG24280
      *                                                               *                     BUG24280
      *  SRZDate - Subroutine to convert day no to date               *                     BUG24280
      *                                                               *                     BUG24280
      *  Called By :                                                  *                     BUG24280
      *                                                               *                     BUG24280
      *  Calls : None                                                 *                     BUG24280
      *                                                               *                     BUG24280
      *****************************************************************                     BUG24280
     C     SRZDate       BEGSR                                                              BUG24280
      *                                                                                     BUG24280
     C                   CALL      'ZDATE2'                                                 BUG24280
     C                   PARM                    PZDayNo                                    BUG24280
     C                   PARM      BJDFIN        PZDatfm                                    BUG24280
     C                   PARM                    PZDate                                     BUG24280
     C                   PARM                    PZADate                                    BUG24280
      *                                                                                     BUG24280
     C                   ENDSR                                                              BUG24280
      *****************************************************************
      *                                                               *                       CER048
      *  CGATAX - Additional Tax Information                          *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C*****CGATAX        BEGSR                                                                CER048
      *                                                                                       CER048
      ** Set up subroutine stack name                                                         CER048
      *                                                                                       CER048
     C**********         ADD       1             Q                                            CER048
     C**********         MOVEL     'CGATAX    '  @STK(Q)                                      CER048
      *                                                                                       CER048
      ** Retrieve subroutine specific data.                                                   CER048
      *                                                                                       CER048
     C*****9****         OCCUR     WMDsSRDT                                                   CER048
      *                                                                                       CER048
      ** Set up path.                                                                         CER048
      *                                                                                       CER048
     C**********         MOVEL     '\CGATAX'     ##PNAM                                       CER048
     C*****WPathStr      CAT       ##PNAM:0      WPathStr                                     CER048
     C**********         EXSR      PSHGRS                                                     CER048
     C**********         MOVEL     WPathStr      WMDsPathGrp                                  CER048
      *                                                                                       CER048
      ** Set up Binds from passed in values.                                                  CER048
      *                                                                                       CER048
     C**********         Z-ADD     S#PBIN        WMDsPrevBnd                                  CER048
     C**********         Z-ADD     S#TBIN        WMDsThisBnd                                  CER048
      *                                                                                       CER048
      ** Retrieve RDE info                                                                    CER048
      *                                                                                       CER048
     C**********         MOVEL     'CGATAX '     WGrpNme                                      CER048
     C**********         EXSR      SrRtvRDE                                                   CER048
      *                                                                                       CER048
     C*****TSBRCA        CHAIN     SDLTOFL1                                                   CER048
      *                                                                                       CER048
     C**********         IF        NOT %FOUND(SDLTOFL1)                                       CER048
      *                                                                                       CER048
     C**********         MOVEL     'SDLTOFPD'    W0File                                       CER048
     C**********         MOVEL     TSBRCA        W0Key                                        CER048
     C**********         Z-ADD     07            W0ERNB                                       CER048
     C**********         MOVEL     'MEM5003'     W0MsgD                                       CER048
     C**********         MOVEL     'MIDAS     '  W0MsgF                                       CER048
     C**********         EXSR      SRERR                                                      CER048
      *                                                                                       CER048
     C**********         ELSE                                                                 CER048
      *                                                                                       CER048
      ** Local Tax Office Name                                                                CER048
      *                                                                                       CER048
     C**********         MOVEL     LTOFNM        ##D(1)                                       CER048
      *                                                                                       CER048
      ** Local Tax Office Number                                                              CER048
      *                                                                                       CER048
     C**********         MOVEL     LTOFRN        ##D(2)                                       CER048
      *                                                                                       CER048
     C**********         ENDIF                                                                CER048
      *                                                                                       CER048
      ** Period (Year or "from...to..." dates)                                                CER048
      *                                                                                       CER048
     C**********         Z-ADD     BJRDNB        @@DAYN            5 0                        CER048
     C**********         Z-ADD     0             @@VDT             8 0                        CER048
      *                                                                                       CER048
     C**********         EXSR      ZDATE9
      *                                                                                       CER048
     C**********         MOVEL     @@VDT         W0VDT             4                          CER048
      *                                                                                       CER048
     C**********         MOVEL     W0VDT         ##D(3)                                       CER048
      *                                                                                       CER048
      ** Customer Bankleitzhal                                                                CER048
      *                                                                                       CER048
     C**********         MOVEL     TSCUST        PCust                                        CER048
      *                                                                                       CER048
     C**********         CALL      'AOCUSTR1'                                                 CER048
     C**********         PARM      *BLANKS       PRtcd             7                          CER048
     C**********         PARM      '*KEY   '     Poptn             7                          CER048
     C**********         PARM                    Pcust            10                          CER048
     C**********         PARM      *BLANKS       Pkey              7                          CER048
     C*****SDCUST        PARM      SDCUST        DSLDY                                        CER048
      *                                                                                       CER048
     C**********         IF        PRtcd <> *BLANKS                                           CER048
     C**********                   AND PRtcd <> '*CUSCLO'                                     CER048
     C**********         MOVEL     'SDCUSTPD'    W0FILE                                       CER048
     C**********         MOVEL     Pcust         W0KEY                                        CER048
     C**********         Z-ADD     08            W0ERNB                                       CER048
     C**********         MOVEL     'MEM5004'     W0MsgD                                       CER048
     C**********         MOVEL     'MIDAS  '     W0MsgF                                       CER048
     C**********         EXSR      SRERR                                                      CER048
      *                                                                                       CER048
     C**********         ELSE                                                                 CER048
     C**********         MOVEL     BBBLCD        ##D(4)                                       CER048
     C**********         ENDIF                                                                CER048
      *                                                                                       CER048
      ** Interest Rate                                                                        CER048
      *                                                                                       CER048
     C**********         IF        TSMODI = 'D'                                               CER048
     C*****TSDLLN        CHAIN     DEALS                                                      CER048
      *                                                                                       CER048
     C**********         IF        %FOUND(DEALS)                                              CER048
     C**********         MOVEL     RTSP          ##D(5)                                       CER048
      *                                                                                       CER048
     C**********         ELSE                                                                 CER048
     C**********         MOVEL     *ZERO         ##D(5)                                       CER048
      *                                                                                       CER048
     C**********         ENDIF                                                                CER048
     C**********         ENDIF                                                                CER048
      *                                                                                       CER048
     C**********         IF        TSMODI = 'G'                                               CER048
     C**********         MOVEL     TSCUST        KCNUM                                        CER048
     C**********         MOVEL     TSOCCY        KCCY                                         CER048
     C**********         MOVEL     TSACOD        KACOD                                        CER048
     C**********         MOVEL     TSACSQ        KACSQ                                        CER048
     C**********         MOVEL     TSBRCA        KBRCA                                        CER048
      *                                                                                       CER048
     C*****KACNTKY       CHAIN     ACCNT                                                      CER048
      *                                                                                       CER048
     C**********         IF        %FOUND(ACCNT) AND ATYP = 'R'                               CER048
     C**********         MOVEL     CCIR          ##D(5)                                       CER048
      *                                                                                       CER048
     C**********         ELSE                                                                 CER048
     C**********         MOVEL     *ZERO         ##D(5)                                       CER048
      *                                                                                       CER048
     C**********         ENDIF                                                                CER048
     C**********         ENDIF                                                                CER048
      *                                                                                       CER048
      ** Interest Period                                                                      CER048
      *                                                                                       CER048
     C**********         MOVEL     PTaxYear      ##D(6)                                       CER048
      *                                                                                       CER048
      ** Exchange Rate - Original Ccy to Tax Ccy                                              CER048
      *                                                                                       CER048
     C**********         IF        TSPAMT <> *ZERO                                            CER048
      *                                                                                       CER048
     C**********         EVAL      WTAMT = TSPAMC/TSPAMT                                      CER048
     C**********         MOVEL     WTAMT         ##D(7)                                       CER048
      *                                                                                       CER048
     C**********         ELSE                                                                 CER048
     C**********         MOVEL     *ZERO         ##D(7)                                       CER048
      *                                                                                       CER048
     C**********         ENDIF                                                                CER048
      *                                                                                       CER048
     C**********         MOVEL     *ZERO         WTAMT                                        CER048
      *                                                                                       CER048
      ** Secondary Tax amount deducted - Original Ccy                                         CER048
      *                                                                                       CER048
     C**********         MOVEL     TSSTDO        ##D(8)                                       CER048
     C**********         MOVE      WOCcyPl       ##D(8)                                       CER048
      *                                                                                       CER048
      ** Secondary Tax amount deducted - Tax Ccy                                              CER048
      *                                                                                       CER048
     C**********         MOVEL     TSSTDT        ##D(9)                                       CER048
     C**********         MOVE      WTCcyPl       ##D(9)                                       CER048
      *                                                                                       CER048
      ** Threshold Amount & Utilisation                                                       CER048
      *                                                                                       CER048
     C*****TSCUST        CHAIN     SDINPHL1                                                   CER048
      *                                                                                       CER048
     C**********         IF        %FOUND(SDINPHL1)                                           CER048
      *                                                                                       CER048
      ** Utilization Upto Threshold                                                           CER048
      *                                                                                       CER048
     C**********         MOVEL     TIUTTH        ##D(10)                                      CER048
      *                                                                                       CER048
      ** Current Threshold                                                                    CER048
      *                                                                                       CER048
     C**********         MOVEL     TICUTH        ##D(11)                                      CER048
      *                                                                                       CER048
     C**********         ELSE                                                                 CER048
      *                                                                                       CER048
     C**********         MOVEL     'SDINPHPD'    W0File                                       CER048
     C**********         MOVEL     TSCUST        W0Key                                        CER048
     C**********         Z-ADD     09            W0ERNB                                       CER048
     C**********         MOVEL     'MEM5003'     W0MsgD                                       CER048
     C**********         MOVEL     'MIDAS     '  W0MsgF                                       CER048
     C**********         EXSR      SRERR                                                      CER048
     C**********         ENDIF                                                                CER048
      *                                                                                       CER048
      ** Threshold Value & Maturity Date                                                      CER048
      *                                                                                       CER048
     C*****TSCUST        CHAIN     SDTHRHL1                                                   CER048
      *                                                                                       CER048
     C**********         IF        %FOUND(SDTHRHL1)                                           CER048
      *                                                                                       CER048
      ** Threshold Value Date                                                                 CER048
      *                                                                                       CER048
     C**********         MOVEL     TETRVD        PDAYN             5 0                        CER048
      *                                                                                       CER048
     C**********         EXSR      ZDATE2                                                     CER048
      *                                                                                       CER048
     C**********         MOVEL     PDAT7         ##D(12)                                      CER048
      *                                                                                       CER048
      ** Threshold Maturity date                                                              CER048
      *                                                                                       CER048
     C**********         MOVEL     TETRMD        PDAYN                                        CER048
      *                                                                                       CER048
     C**********         EXSR      ZDATE2                                                     CER048
      *                                                                                       CER048
     C**********         MOVEL     PDAT7         ##D(13)                                      CER048
      *                                                                                       CER048
     C**********         ELSE                                                                 CER048
      *                                                                                       CER048
     C**********         MOVEL     'SDTHRHPD'    W0File                                       CER048
     C**********         MOVEL     TSCUST        W0Key                                        CER048
     C**********         Z-ADD     10            W0ERNB                                       CER048
     C**********         MOVEL     'MEM5003'     W0MsgD                                       CER048
     C**********         MOVEL     'MIDAS     '  W0MsgF                                       CER048
     C**********         EXSR      SRERR                                                      CER048
     C**********         ENDIF                                                                CER048
      *                                                                                       CER048
      ** Date Customer Deleted                                                                CER048
      *                                                                                       CER048
     C**********         MOVEL     BBDTDL        PDAYN                                        CER048
      *                                                                                       CER048
     C**********         EXSR      ZDATE2                                                     CER048
      *                                                                                       CER048
     C**********         MOVEL     PDAT7         ##D(14)                                      CER048
      *                                                                                       CER048
      ** Setup First/Subsequent/Last Indicator                                                CER048
      *                                                                                       CER048
     C**********         MOVE      'FR'          ##FSLI                                       CER048
      *                                                                                       CER048
      ** Accumulate RDEs and associated data and output to CGUDTAPD                           CER048
      *                                                                                       CER048
     C**********         EXSR      SrADTA                                                     CER048
     C**********         EXSR      SrODTA                                                     CER048
      *                                                                                       CER048
      ** Unwind subroutine stack name                                                         CER048
      *                                                                                       CER048
     C**********         EXSR      POPGRS                                                     CER048
     C**********         MOVEA     *BLANKS       @STK(Q)                                      CER048
     C**********         SUB       1             Q                                            CER048
      *                                                                                       CER048
     C**********         ENDSR                                                                CER048
      *****************************************************************                       CER048
      /EJECT                                                                                  CER048
      *****************************************************************                       CER048
      *                                                               *                       CER048
      *  ZDATE2 - Midas ZS CVT Midas Day Number to DDMMYY Module      *                       CER048
      *                                                               *                       CER048
      *****************************************************************                       CER048
     C     ZDATE2        BEGSR                                                                CER048
      *                                                                                       CER048
     C                   CALL      'ZDATE2'                                                   CER048
     C                   PARM                    PDAYN                                        CER048
     C                   PARM      BJDFIN        PDTFM             1                          CER048
     C                   PARM      *ZEROS        PDATE             6 0                        CER048
     C                   PARM      *BLANKS       PDAT7             7                          CER048
      *                                                                                       CER048
     C                   ENDSR                                                                CER048
      *****************************************************************                       CER048
      *                                                                                       CER048
      ** Copy Book for ZDATE9                                                                 CER048
      *                                                                                       CER048
     C/EJECT                                                                                  CER048
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CER048
      *                                                                                       CER048
      /EJECT
     C/COPY CGCPYSRC,SRERRCLE
      /EJECT
     C/COPY CGCPYSRC,SRERRPSSRL
      /EJECT
     C/COPY CGCPYSRC,CGNWEXILE
      /EJECT
      *****************************************************************
      *                                                                                     BUG23313
      ** The following Array elements have been changed.                                    BUG23313
      ** TAXHDR0011 THRVALD                                                                 BUG23313
      ** TAXHDR0012 THRMDAT                                                                 BUG23313
      ** TRNDT20001 INT_PAYD                                                                BUG23313
      *                                                                                     BUG23313
      ** TRNDT20014 INT_PRDFR                                                               BUG25075
      ** TRNDT20015 INT_PRDCR                                                               BUG25075
      ** TRNDT20016 INT_PRDTO                                                               BUG25075
      *                                                                                     BUG25075
** WTbGrp/WTbRDE
TAXHDR0001 RUNDATE    Date               Rundate                                            BUG24244
TAXHDR0002 TAX YEAR                      Tax Year
TAXHDR0003 REFERENCE                     Customer Reference
TAXHDR0004 COR_ADDR_1                    Customer Address Line 1 (35-Long)                  BUG25542
TAXHDR0005 REP_TOWN                      Report Town
TAXHDR0006 REP_TITLE                     Report Title                                         232543
TAXHDR0007 ZZBLCD                        Bankleitzahl                                         CER048
TAXHDR0008 ZZBBDTDL1  Date               date Customer deleted                       CER048 BUG24244
TAXHDR0009 ZZUUTHR    AmountL            Utilisation up to threshold                 CER048 BUG23514
TAXHDR0010 ZZCTHR     AmountL            Current Threshold                           CER048 BUG23514
TAXHDR0011 THRVALD    Date               Threshold value date                        CER048 BUG23313
TAXHDR0012 THRMDAT    Date               Threshold Maturity date                     CER048 BUG23313
TAXHDR0013 ZZTONA                        Local Tax Office Name                                CER048
TAXHDR0014 ZZTONO                        Local Tax Office Number                              CER048
TAXHDR0015 CLOS_DELT                     Date Customer Closed                               BUG24244
TAXCCY0001 SETTL CCY                     Settlement Ccy Code
TAXCCY0002 CCY_DESC                      Currency Description
TAXCCY0003 EQUIV_CCY                     Tax Currency Code                                  BUG24790
TAXCCY0004 EQUIV_CCYD                    Tax Currency Desciption                            BUG24790
TRNDT20001 INT_PAYD   Date               Interest Payment Date                              BUG23313
TRNDT20002 MODULE_ID                     Module ID
TRNDT20003 TRN_TYPE                      Transaction Type
TRNDT20004 PRINCIPAL  AmountL            Principal Amt
TRNDT20005 GRS INTRST AmountL            Gross Int Amt
TRNDT20006 TAX_ORGCCY AmountL            Tax Withheld in Original Ccy
TRNDT20007 TAXRATE    AmountL            Exchange Rate
TRNDT20008 TAX_TAXCCY AmountL            Tax Withheld in Tax Ccy
TRNDT20009 TXPERIOD                      Tax Period                                           CER048
TRNDT20010 INT RATE   Rate  L7           Interest Rate                                        CER048
TRNDT20011 ZZSELY                        Tax Year                                             CER048
TRNDT20012 ZZFSCNB    AmountL            Secondary Tax(Soli.) - Ori. ccy                      CER048
TRNDT20013 ZZFSCNC    AmountL            Secondary Tax(Soli.) - Tax ccy                       CER048
TRNDT20014 ZZFCHTC    AmountL            Third Tax - Deal Ccy                                 CER054
TRNDT20015 ZZFCHTB    AmountL            Third Tax - Tax Ccy                                  CER054
TRNDT20016 ZZFCHRT    Rate  L4           Third Tax Rate                              CER054 BUG25008
TRNDT20017 INT_PRDFR  Date               Interest Period From                      BUG23514 BUG25075
TRNDT20018 INT_PRDCR                     Interest Period Connector                 BUG23514 BUG25075
TRNDT20019 INT_PRDTO  Date               Interest Period To                        BUG23514 BUG25075
CCYTOT0001 CCY_TOTPAM AmountL            Ccy Totals of Principal Amt
CCYTOT0002 CCY_TOTGIN AmountL            Ccy Totals of Gross Int Amt
CCYTOT0003 CCY_TOTOTX AmountL            Ccy Totals of Tax Withheld in Original Ccy
CCYTOT0004 CCY_TOTTTX AmountL            Ccy Totals of Tax Withheld in Tax Ccy
REFTOT0001 REF_TOTPAM AmountL            Ref Totals of Principal Amt
REFTOT0002 REF_TOTGIN AmountL            Ref Totals of Gross Int Amt
REFTOT0003 REF_TOTOTX AmountL            Ref Totals of Tax Withheld in Original Ccy
     20001 CUSTOMER                      Joint Customer Number                              BUG25542
     20002 COR_ADDR_1                    Joint Customer Address Line 1 (35-long)            BUG25542
     20003 ZZUUTHR    AmountL            Joint Cust Util Up To Thresh                       BUG25542
     20004 ZZCTHR     AmountL            Joint Cust Current Threshold                       BUG25542
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN                        CER048
00366007310109601461                                                                          CER048
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                           CER048
00000000310005900090001200015100181002120024300273003040033400365                             CER048
