     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTP0715 - Midas FT Payment Routing                           *
      *                                                               *
      *  (C) Copyright Misys International Banking Systems 2004       *
      *                                                               *
      *  Last Amend No. MD31937            Date 13Jan15               *
      *  Last Amend No. AR856737           Date 15Jul2011             *
      *  Last Amend No. HVB003             Date 19Oct2011             *
      *                 CSW207             Date 21Dec2007             *
      *                 242561             Date 21Nov2006             *
      *                 MMFIX1             Date 21Jun2006             *
      *                 MM1705             Date 17May2006             *
      *                 PNL013             Date 27Feb2005             *
      *                 MM1402             Date 13FEB2006             *
      *                 MM0806             Date 08May2005             *
      *                 PNL015             Date 01Dec2005             *
      *                 PNL014             Date 08Dec2005             *
      *                 CRC002             Date 10Jun2005             *
      *                 MM0505             Date 04May2005             *
      *                 DjbR01             Date 15Apr2005             *
      *                 Djb005             Date 22Mar2005             *
      *                 ESL044             Date 18Jan2005             *
      *                 ESL038             Date 18Jan2005             *
      *                 EEE065 *Amend      Date 25Nov2004             *
      *                 EEE065             Date 09Apr2004             *
      * Midas Release 4 --------------- Base -------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD31937  - Upgrade STP enhancements to BF Midas 2.1          *
      *  HVB003 - Routing for Target Balance payments                 *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level.     *
      *             Renamed QQDFAC field in SDBRCHPD                  *
      *             Changed length of P@ACCD to 10                    *
      *             Renamed SDCUSTX0  -->  SDCUSTX5                   *
      *                     SDCUSTY0  -->  SDCUSTZ0                   *
      *                     SDCUSTY1  -->  SDCUSTZ1                   *
      *                     SDCUSTY2  -->  SDCUSTZ2                   *
      *                     SDCUSTY5  -->  SDCUSTZ5                   *
      *  CSW207 - Swift 2007. SDACUSL2 renamed to SDACUSL6.           *
      *  242561 - EURELIXIR membership being validated as active when *
      *           it has actually expired.                            *
      *  MMFIX1 - RouteReg should be set to Y in SrServices           *
      *           otherwise it doesn't check STP Requirements         *
      *  MM1705 - Extend PLN013 for Domestic Euro Elixir Payments     *
      *  PNL013 - Routing changes for PLN Elixir/PLN Sorbnet          *
      *  MM1402 - EuroSorbnet not included in Regulated Services      *
      *  MM0806 - Fix for not connected BIC and EuroElixir            *
      *  PNL015 - Redirection to head office BIC                      *
      *  PNL014 - Time Sensitive Payments                             *
      *           Generic Payment routes                              *
      *  CRC002 - Change to use BBEDEX instead of BBDEXP (SDCUSTY0)   *
      *         - Change to use BBEDST instead of BBDSTR    "         *
      *         - Change to use BBELMF instead of BBMFLG    "         *
      *         - Must also use zdate10 - change date from Char to Num*
      *  MM0505 - Add Value Date to Routing                           *
      *  DjbR01 - Allow Cover in services correct NonStdService Ind.  *
      *  Djb005 - Change re-route process to include BENEFs           *
      *  ESL044 - Local Clearing                                      *
      *  ESL038 - Conversion to use general routing for 54            *
      *  EEE065 - Allow Foreign BICs                                  *
      *  EEE065 - FT Payment Routing                                  *
      *                                                               *
      *****************************************************************
     FFTMSCCV1  IF   E           K DISK
     F                                     INFDS(INFDS1)
     F                                     INFSR(SRFILE)
      * RTV : FT SWIFT Correspondent STP
      *
     FFTMSCPV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : FT SWIFT Correspondent STP Pay Route
      *
     FFTMSCPV2  IF   E           K DISK                                                       PNL014
     F                                     INFSR(SRFILE)                                      PNL014
      * RTV : FT SWIFT Correspondent STP Pay Route                                            PNL014
                                                                                              PNL014
     FFTMSCRV2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : FT SWIFT Correspondent STP Re- Route
      *
     FMEBICDL2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : SWIFT BIC Details
      *
     FFTMSCYV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Midas FT Currency Country re-routes
      *
     FFTMSGRV1  IF   E           K DISK                                                       ESL038
     F                                     INFSR(SRFILE)                                      ESL038
      * RTV : Midas FT General Routes                                                         ESL038
                                                                                              ESL038
     FFTMSCSV1  IF   E           K DISK                                                       ESL044
     F                                     INFSR(SRFILE)                                      ESL044
      * RTV : Midas FT Customer Specific Routes                                               ESL044
                                                                                              ESL044
     FFTPICDV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Midas FT Payment Route ICD
      *
     FFTBSCHV1  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Midas FT BIC Plus Key Search By KEY
      *
     FFTBSCHV2  IF   E           K DISK
     F                                     INFSR(SRFILE)
      * RTV : Midas FT BIC Plus Key Search By Country National id.
      *                                                                                       ESL038
     C/COPY WNCPYSRC,FTP0715F01                                                               ESL038
     FSDLCSDL3  IF   E           K DISK    Rename(Sdlcsdd0:@lcsdl3)                           ESL038
     F                                     INFSR(SRFILE)                                      ESL038
      * RTV : Midas Clearing Systems Value Added code                                         ESL038
      *                                                                                       ESL038
     F*SDLCCDL0**IF   E           K DISK    Rename(Sdlccdd0:@lccdl0)                    ESL038ESL044
     FSDLCCDL1  IF   E           K DISK    Rename(Sdlccdd0:@lccdl1)                           ESL044
     F                                     INFSR(SRFILE)                                      ESL038
      **  Local clearing customer details                                                     ESL038
      *                                                                                       ESL038
     FSDCUSTL7  IF   E           K Disk    Rename(@custge:@custl7)                            ESL038
     F                                     INFSR(SRFILE)                                      ESL038
      **  SWIFT Customers                                                                     ESL038
      *                                                                                       ESL038
     FSDCUSTZ0  IF   E           K Disk    Rename(Sdcustd1:@custy0)                           ESL038
     F                                     INFSR(SRFILE)                                      ESL038
      **  Elixir members                                                                      ESL038
      *                                                                                       ESL038
     FSDCUSTZ5  IF   E           K Disk    Rename(Sdcustd1:@custy5)                           PNL013
     F                                     INFSR(SRFILE)                                      PNL013
      **  Elixir members by KIR reference                                                     PNL013
      *                                                                                       PNL013
     ** SDACUSL6  IF   E           K Disk                                         MM1705
     FSDACUSV1  IF   E           K Disk                                                       MM1705
     F                                     INFSR(SRFILE)                                      MM1705
      **  Alternative Customer Details by E5ALTN                                              MM1705
      *
     FFTCLRCV4  IF   E           K Disk                                                       ESL038
     F                                     INFSR(SRFILE)                                      ESL038
      **  Clearing BICS for ACH cover payments                                                ESL038
      *
     FFTPRCTV1  IF   E           K DISK                                                       ESL038
      * RTV : Midas FT Payment Regions                                                        ESL038
      *                                                                                       ESL038
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
      *  Array containing Copyright statement
     D/COPY MECPYSRC,SRERRD_ILE
      *
      *  Copysource for error processing
      *
      /EJECT
      * Data structures:
     D JBDTTM          DS
      * Job date/time
     D  ##JDT                  1      6  0
     D  ##JYY                  1      2  0
     D  ##JMM                  3      4  0
     D  ##JDD                  5      6  0
     D  ##JTMA                 7     12
     D  ##JTM                  7     12  0
     D  ##JHH                  7      8  0
     D  ##JNN                  9     10  0
     D  ##JSS                 11     12  0
     D INFDS1        E DS                  EXTNAME(Y2I1DSP)
      * File information data structure
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      * Get Rundate - Rundate  *
      *
     D MROTDS        E DS                  EXTNAME(FTMROTP0)
      *
      * Routing Information data structure
      *
     D DsSTPCorr     E DS                  EXTNAME(FTMSCCP0)
      *
      * STP Correspondent details
      *
     D DsTopSTPCorr  E DS                  EXTNAME(FTMSCCP0)
     D                                     Prefix(Lv1)
      *
      * Top Correspondent details
      *
     D DsRr1STPCorr  E DS                  EXTNAME(FTMSCCP0)
     D                                     Prefix(Rr1)
      *
      * Re-Route level 1 top information Correspondent details
      *
     D DsPayCorr     E DS                  EXTNAME(FTMSCPP0)
      *
      * Pay Correspondent details
      *
     D DsLv1PayCord  E DS                  EXTNAME(FTMSCCP0)
     D                                     Prefix(Lc1)
     D                                     Occurs(20)
     D DsLv1PayCorr  E DS                  EXTNAME(FTMSCPP0)
     D                                     Prefix(Lv1)
     D                                     Occurs(20)
     D DsLv1Route    E DS                  EXTNAME(FTMROTP0)
     D                                     Prefix(Lv1)
     D                                     Occurs(20)
      *
      * Level 2 Correspondent details
      *
     D DsLv2STPCorr  E DS                  EXTNAME(FTMSCCP0)
     D                                     Prefix(Lc2)
      *
      * Level 2 Correspondent details
      *
     D DsLv2PayCord  E DS                  EXTNAME(FTMSCCP0)
     D                                     Prefix(Lv2)
     D                                     Occurs(20)
     D DsLv2PayCorr  E DS                  EXTNAME(FTMSCPP0)
     D                                     Prefix(Lv2)
     D                                     Occurs(20)
     D DsLv2Route    E DS                  EXTNAME(FTMROTP0)
     D                                     Prefix(Lv2)
     D                                     Occurs(20)
     D DsNxtSTPCorr  E DS                  EXTNAME(FTMSCCP0)
     D                                     Prefix(Nxt)
      *
      * Next to Search Correspondent details
      *
     D DsLv3STPCorr  E DS                  EXTNAME(FTMSCCP0)
     D                                     Prefix(Lv3)
      *
      * Level 3 Correspondent details
      *
     D DsLv3PayCord  E DS                  EXTNAME(FTMSCCP0)
     D                                     Prefix(Lc3)
     D                                     Occurs(20)
     D DsLv3PayCorr  E DS                  EXTNAME(FTMSCPP0)
     D                                     Prefix(Lv3)
     D                                     Occurs(20)
     D DsLv3Route    E DS                  EXTNAME(FTMROTP0)
     D                                     Prefix(Lv3)
     D                                     Occurs(20)

     D DsStarLda       DS           256
     D  DataBit                1    256

     D DsChargeDet     DS           256
     D                                     Occurs(20)
     D C#SChargeCode                       Like(MPSCHC)
     D C#SChargeRate                       Like(MPSCHR)
     D C#SChargeMin                        Like(MPSCHL)
     D C#SChargeMax                        Like(MPSCHH)
     D C#SChargeAmt                        Like(MoPyam)
     D C#lChargeCode                       Like(MPSCHC)
     D C#lChargeRate                       Like(MPSCHR)
     D C#lChargeMin                        Like(MPSCHL)
     D C#lChargeMax                        Like(MPSCHH)
     D C#lChargeAmt                        Like(MoPyam)
      *
      * Receiver matching
     D DstRec          S             47    DIM(100)
     D DstRecBic       S                   LIKE(MoDstr)
     D DstRecRcA       S                   LIKE(MpRcAu)
     D DstRecRcQ       S                   LIKE(MpRcAc)
     D DstPrefer       S              1    DIM(100)                                           ESL038
     D SncRec          S             12    DIM(100)
     D SncRecBic       S                   LIKE(MoDstr)
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFA1        E                     EXTFLD(QQDFAC)                                   AR856737
      *
      *  Branch Details *
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      *  Customer Details *
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      *
      * Data Structures for Branch Details
      *
     D SDCTRY        E DS                  EXTNAME(SDCTRYPD)
      *
      * Data Structures for Country codes
      *
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      *  Counterparty Nostro Details *
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * Bank details Structure *
      *
      *
     D DsBICD        E DS                  EXTNAME(MEBICDPD)
      *
      * SWIFT Details          *
      *
     D DsTopBicD     E DS                  EXTNAME(MEBICDPD)
     D                                     Prefix(Lv1)
      *
      * SWIFT Details          *
      *
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB) PREFIX(AC)
     D  ##ACCT                 2     16
      *
      *  Accounts *
      *
     D DsAccounts      DS
     D  W0Account              1     34
     D  W0Brca                             Like(AcBrca)
     D  W0Cnum                             Like(AcCnum)
     D  W0Ccy                              Like(AcCcy )
     D  W0Acod                             Like(AcAcod)
     D  W0Acsq                             Like(AcAcsq)
     D  W0Acno                             Like(AcAcno)
     D  W0Bic                              Like(BBCsid)
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      *  Currency Details *
      *
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      *
      *  Funds Transfer details
      *
      * O : To FTP0715
     D P2PARM          DS           256
      * O : Program name
     D  P2PGM                  1     10
      * O : Preferential update
     D  P2PCOR                11     11
     D  P2Bicc                12     19
     D  P2Bicb                20     22
     D  P2Pccy                23     25
     D  P2Cbic                26     33
     D  P2Cbib                34     36
     D  P2PREG                37     37
     D  P2PLVP                38     38
     D  P2PLBen               39     39
     D  P2PLSha               40     40
     D  P2PLOur               41     41
      *
     D O2PARM          DS           256
      *
      *  Define data structure used to pass parameters
      *
      * Booking branch
     D  O2BRCA                 1      3
      * Information type  (S=SWIFT C=Customer)
     D  O2TYPE                 4      4
      * SWIFT BIC
     D  O2SBIC                 5     15
     D  O2SBICC                5     12
     D  O2SBICB               13     15
      * Customer
     D  O2CUST                16     21
                                                                                              PNL014
      * Routing details        *                                                              PNL014
     D TspP1Parm     E DS                  Extname(FTMROTP0)                                  PNL014
     D                                     Prefix(Tsp_)                                       PNL014
      *                                                                                       PNL014
      * Key parameters for correspondent details                                              PNL014
     D TspP2Parm       DS           256                                                       PNL014
     D TspK#MsccBicC                       Like(McBicc)                                       PNL014
     D TspK#MsccBicB                       Like(McBicB)                                       PNL014
     D TspK#MsccPCcy                       Like(McPCcy)                                       PNL014
      *                                                                                       PNL014
     D TspK#MsccStmt                       Like(McStmt)                                       PNL014
      *                                                                                       PNL014
      * Key parameters for correspondent payment routes details                               PNL014
     D TspP3Parm       DS           256                                                       PNL014
     D TspK#MscpBicC                       Like(MpBicc)                                       PNL014
     D TspK#MscpBicB                       Like(MpBicB)                                       PNL014
     D TspK#MscpPCcy                       Like(MpPCcy)                                       PNL014
     D TspK#MscpCBic                       Like(MpCBic)                                       PNL014
     D TspK#MscpCBiB                       Like(MpCBiB)                                       PNL014
      *                                                                                       PNL014
     D TspK#MscpStmt                       Like(MpStmt)                                       PNL014
      *                                                                                       PNL014
      * Output information                                                                    PNL014
     D TspP4Parm       DS           256                                                       PNL014
     D TspO#VDat                           Like(MoVDat)                                       PNL014
     D TspO#RTSQ                           Like(MpRTSQ)                                       PNL014
     D TspO#TSDO                           Like(MpTSDO)                                       PNL014
     D TspO#TSCT                           Like(MpTSCT)                                       PNL014
     D TspO#TSCD                           Like(MpTSCD)                                       PNL014
     D TspO#TSCK                           Like(MpTSCK)                                       PNL014
     D TspO#TSFC                           Like(MpTSFC)                                       PNL014
     D TspO#TSIS                           Like(MpTSIS)                                       PNL014
     D TspO#TSHC                           Like(MpTSHC)                                       PNL014
     D TspO#TSHL                           Like(MpTSHL)                                       PNL014
     D TspDateTime                         Like(W#DateTime)                                   PNL014
     D TspCheckDate                        Like(W#DateTime)                                   PNL014
      *                                                                                       PNL014
     D W#DateTime      S             12                                                       PNL014
      *
      * Top Level Information
      *
     D DsLevel1        DS           256
     D  LV1Swaut                           Like(O2Rtn)
     D  LV1RrtSwaut                        Like(O2Rtn)
     D  LV1Benb                            Like(MoBenb)
     D  LV1DirectSW                        Like(W#Valid)
     D  LV1HeadOffice                      Like(MoBenb)                                       PNL015
     D  LV1HeadSwaut                       Like(O2Rtn)                                        PNL015
      *
      * Level 2 Information
      *
     D DsLevel2        DS           256
     D  LV2Swaut                           Like(O2Rtn)
     D  LV2DirectSW                        Like(W#Valid)
      *
      * Level 3 Information
      *
     D DsLevel3        DS           256
     D  LV3Swaut                           Like(O2Rtn)
     D  LV3Benc                            Like(MoBenc)
     D  LV3DirectSW                        Like(W#Valid)
     D                 DS                                                                     CRC002
      **  Data structure for START DATE, to change format.                                    CRC002
     D  STRDAT                 1      8  0                                                    CRC002
     D  STRYR                  1      4  0                                                    CRC002
     D  STRMON                 5      6  0                                                    CRC002
     D  STRDAY                 7      8  0                                                    CRC002
     D                 DS                                                                     CRC002
      **  Data structure for EXPIRY DATE, to change format.                                   CRC002
     D  EXPDAT                 1      8  0                                                    CRC002
     D  EXPYR                  1      4  0                                                    CRC002
     D  EXPMON                 5      6  0                                                    CRC002
     D  EXPDAY                 7      8  0                                                    CRC002
     D                 DS                                                                     CRC002
      **  Data structure for date in, to change format.                                       CRC002
     D  DateIn                 1      8  0                                                    CRC002
     D  @@YY                   1      4  0                                                    CRC002
     D  @@MM                   5      6  0                                                    CRC002
     D  @@DD                   7      8  0                                                    CRC002
      *
      *  Work fields
      *
     D W#PerCent       S             11S 3
     D W#Lv1McPnbr     S                   Like(MCPNBR)
     D W#Lv2McPnbr     S                   Like(MCPNBR)
     D W#Lv3McPnbr     S                   Like(MCPNBR)
     D W#Lv1McPrnb     S                   Like(MCPNBR)
     D W#Lv2McPrnb     S                   Like(MCPNBR)
     D W#Lv3McPrnb     S                   Like(MCPNBR)
     D W#Lv1McPlnb     S                   Like(MCPNBR)
     D W#Lv2McPlnb     S                   Like(MCPNBR)
     D W#Lv3McPlnb     S                   Like(MCPNBR)
     D W#Select        S              1
     D W#Valid         S              1
     D W#Kird          S              8                                                       PNL013
      ** Fields from transaction

     D W#ChargeCode    S                   Like(MPSCHC)
     D W#ChargeRate    S                   Like(MPSCHR)
     D W#ChargeMin     S                   Like(MPSCHL)
     D W#ChargeMax     S                   Like(MPSCHH)

     D W#ChargeAmt     S                   Like(MoPyam)

     D PayAmt          S             13P 0
     D PayCcy          S              3A
     D SettAmt         S             13P 0
     D SettCcy         S              3A
     D ChgCcy          S              3A
     D ChgExch         S             13P 8
     D STP             S              1A
     D ChargesDR       S             12S 0
     D AddDeduct       S              1A

      * Types of Route to check
     D RouteReg        S              1A
     D RouteLVP        S              1A
     D RouteGen        S              1A
     D RouteOur        S              1A
     D RouteService    S              1A
     D RouteSet        S              1A
     D SaveReg         S              1A
     D SaveLVP         S              1A
     D SaveGen         S              1A
     D SaveOur         S              1A
     D SaveService     S              1A
     D SaveSet         S              1A
     D SingleService   S                   Like(McPvas)
     D NonStdService   S              1A                                                      ESL038
     D NonStdPvas      S                   Like(McPvas)                                       ESL038
     D W##StdService   S              1A                                                      ESL038
     D W##StdPvas      S                   Like(McPvas)                                       ESL038
     D CustomerFnd     S              1A                                                      ESL038
     D W#ClearPthr     S              1A                                                      ESL038
     D W#Convention    S              2A
     D W#CompConv      S                   Like(McQ71a)
     D W#DirectSW      S                   Like(W#Valid)
     D W#Ptr           S              5  0                                                    ESL044
     D W#Btbi          S                   Like(MoBtbi)                                       ESL044
     D W#BranchBic     S                   Like(MoBenb)                                       PNL015
     D W#HeadOffice    S                   Like(MoBenb)                                       PNL015
     D W#HeadSwaut     S                   Like(O2Rtn)                                        PNL015
     D W#Iterations    S                   Like(IcTsNi)                                       PNL014
     D W#IterNbr       S                   Like(IcTsNi)                                       PNL014
     D W#Check         S              1                                                       PNL014
     D W#ValueDate     S                   Like(MoVDat)                                       PNL014
     D ZMDay           S              5P 0                                                    PNL014
     D ZSDate          S              6                                                       PNL014
     D ZSDatc          S              8                                                       PNL014
     D ZErr            S              7                                                       PNL014
     D ZDate           S              6P 0                                                    PNL014
     D ZDateFmt        S              1                                                       PNL014
     D ZDayNbr         S              5P 0                                                    PNL014
     D W#Date          S              6                                                       PNL014
     D W#Days          S              1                                                       PNL014
     D W#DaysNbr       S              2P 0                                                    PNL014
      *                                                                                       PNL014
      *
     D MVDATE          S              5P 0                                                    MM0505

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D Digits          S             10    Inz('1234567890')                                  ESL044
     D LCase           S             26    Inz('abcdefghijklmnopqrstuvwxyz')                  ESL044
     D UCase           S             26    Inz('ABCDEFGHIJKLMNOPQRSTUVWXYZ')                  ESL044
      *
      **  Charge on each tier
     D TierCharge      S             13    DIM(11)

      **  Chargeable Amount on each tier
     D TierAmount      S             13    DIM(11)

      /EJECT
      *****************************************************************
      * Entry parameters
     C     *ENTRY        PLIST
     C                   PARM                    P0RTN             7
     C                   PARM                    P0Action          1
     C                   PARM                    P2Parm
     C                   PARM                    MROTDS
     C                   PARM                    MVDATE                                       MM0505
      *
      *  Set up primary reference
      *
     C                   Clear                   P0Rtn
     C                   Move      *Blanks       BCtry             2                          MM1705
     C                   MOVEL     'Status'      W0PREF
     C                   Exsr      SrInit
      *                                                                                       PNL013
      **  Reset work field                                                                    PNL013
     C                   Eval      ExBenBank = *Blanks                                        PNL013

      * level 1 information
     C                   Exsr      SrInfol1

                                                                                              ESL044
      * Test for Customer Specific Routes                                                     ESL044
     C                   If        P0Rtn  <> 'Route'                                          ESL044
     C                   Exsr      SrCustomRoute                                              ESL044
     C                   Endif                                                                ESL044
      * Manual routing exit                                                                   ESL044
     C                   If        P0Rtn  = 'CustMan'                                         ESL044
     C                   Goto      ExNoRoute                                                  ESL044
     C                   Endif                                                                ESL044
                                                                                              PNL014
      * Test iterative routing                                                                PNL014
     C                   Eval      W#Iterations = 1                                           PNL014
                                                                                              PNL014
     C                   If        IcTsRT = 'Y'                                               PNL014
                                                                                              PNL014
      * Check for number of iterations                                                        PNL014
     C                   Select                                                               PNL014
     C                   When      IcTsNi < 1                                                 PNL014
     C                   Eval      W#Iterations = 1                                           PNL014
     C                   When      IcTsNi > 10                                                PNL014
     C                   Eval      W#Iterations = 10                                          PNL014
     C                   Other                                                                PNL014
     C                   Eval      W#Iterations = IcTsNi                                      PNL014
     C                   Endsl                                                                PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C     1             Do        W#Iterations  W#IterNbr                                    PNL014
                                                                                              PNL014
      * Step on date for processing                                                           PNL014
     C                   Exsr      SrDateStep                                                 PNL014
                                                                                              PNL014
                                                                                              ESL044
      * Test for Regulated Services Route                                                     ESL044
     C                   If        P0Rtn  <> 'Route'                                          ESL044
     C                   Exsr      SrRegServices                                              ESL044

      * Test for Regulated Route
     C                   If        P0Rtn  <> 'Route'
     C                   Exsr      SrRegulated
     C                   If        P0Rtn  <> 'Route'
      * level 1 routing
     C                   Exsr      SrLevel1
     C                   Endif
     C                   Endif
     C                   Endif                                                                ESL044
                                                                                              PNL014
      * If route found exit                                                                   PNL014
                                                                                              PNL014
     C                   If        P0Rtn = 'Route'                                            PNL014
     C                   leave                                                                PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   Enddo                                                                PNL014
                                                                                              PNL014

      * If routed and no settlement method, then default is 08
     C                   If        P0Rtn  = 'Route' and MOSETT = *blanks
     C                   Eval      MoSett = '08'
     C                   Endif
      *                                                                                       PNL013
      * If routed and EC/PS settlement method, then default is account                        PNL013
     C                   If        P0Rtn  = 'Route' and MOSETT = 'EC'                         PNL013
     C                             And ExBenBank <> *blanks    or                             PNL013
     C                             P0Rtn  = 'Route' and MOSETT = 'PS'                         PNL013
     C                             And ExBenBank <> *blanks  or                               MM1705
     C                             P0Rtn  = 'Route' and MOSETT = 'EL'                         MM1705
     C                             And ExBenBank <> *blanks                                   MM1705
     C                   Movel     *Blanks       MoBenb                                  MM1705
     C                   Eval      MoDstr = ExBenBank                                         PNL013
     C                   Eval      MoBenb = ExBenBank                                         PNL013
      *                  Eval      MoAcbr = ExBenBank                                         MM1705
     C                   Endif                                                                PNL013

     C     ExNoRoute     Tag                                                                  ESL044
      * Set *Lda
     C                   In        DsStarLda
     C                   Eval      DataBit = P2Parm
     C                   Out       DsStarLda

      * Exit
     C                   Seton                                        Lr
     C                   Return
      *
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrInfoL1   : Information on Level 1                          *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrInfol1      BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrInfol1'    @STK(Q)

     C                   Eval      W#BTBI = MoBtbi
     C                   Clear                   MOBTBI

     C                   Clear                   P2PCOR
     C                   Clear                   P2Bicc
     C                   Clear                   P2Bicb
     C                   Clear                   P2Pccy
     C                   Clear                   P2Cbic
     C                   Clear                   P2Cbib
     C                   Clear                   RouteSet
     C                   Clear                   RouteGen
     C                   Clear                   RouteLVP
     C                   Clear                   RouteReg
      *
     C                   Clear                   DsTopBicD
     C                   Clear                   DsRr1STPCorr
     C                   Clear                   DsLevel1
     C                   Clear                   DsLevel2
     C                   Clear                   DsLv2STPCorr
     C                   Clear                   DsLevel3
     C                   Clear                   DsLv3STPCorr
      *
     C                   Eval      Lv1Benb = MoBenb
     C                   Eval      Lv1Swaut = '*None'
     C                   Eval      Lv2Swaut = '*None'
     C                   Eval      Lv3Swaut = '*None'
      *  What has been input, Pay Through? Beneficiary Bank
      *
      * Change paythru and ben bank to upper case                                             ESL044
     C*    LCase:UCase   Xlate     MoPthr        MoPthr                                       ESL044
     C*    LCase:UCase   Xlate     MoBenb        MoBenb                                       ESL044
      *                                                                                       ESL044
     C                   Select
     C                   When      MoPthr <> *blanks
      *
      *  Check for specific routing for Pay Through
     C                   Eval      BdBicc = %subst(MoPthr:1:8)
     C                   Eval      BdBicb = %subst(MoPthr:9:3)
      *
     C     KBicdL2       Chain     @BicdL2
     C                   If        %Found
     C                   Eval      DsTopBicD = DsBicd
     C                   Endif
      *
     C                   When      MoBenb <> *blanks
      *
      *  Check for specific routing for Pay Through
     C                   Eval      BdBicc = %subst(MoBenb:1:8)
     C                   Eval      BdBicb = %subst(MoBenb:9:3)
      *
     C     KBicdL2       Chain     @BicdL2
     C                   If        %Found
     C                   Eval      DsTopBicD = DsBicd
     C                   Endif
      *
     C                   Endsl
      *
      * Get SWIFT Authentication
     C                   Clear                   O2Parm

      * If branch is blank then set default

     C                   Select
     C                   When      O2Brca = *blanks  and IcDbrc = *blanks
     C                   Eval      O2Brca = 'MBB'
     C                   Other
     C                   Eval      O2Brca = ICDBrc
     C                   Endsl

     C                   Eval      O2type = 'S'
      *  What has been input, Pay Through? Beneficiary Bank
      *
     C                   Select
     C                   When      MoPthr <> *blanks
      *
      *  Check for specific routing for Pay Through
     C                   Eval      O2SBicc = %subst(MoPthr:1:8)
     C                   Eval      O2SBicb = %subst(MoPthr:9:3)
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat
      *
     C                   Eval      Lv1Swaut = O2Rtn
                                                                                              PNL015
      * Get head Office Information                                                           PNL015
     C                   Eval      W#BranchBic   = MoPthr                                     PNL015
     C                   Exsr      SrGetHeadOff                                               PNL015
     C                   Eval      Lv1HeadOffice = W#HeadOffice                               PNL015
     C                   Eval      Lv1HeadSwaut  = W#HeadSwaut                                PNL015
      *
     C                   When      MoBenb <> *blanks
      *
      *  Check for specific routing for Pay Through
     C                   Eval      O2SBicc = %subst(MoBenb:1:8)
     C                   Eval      O2SBicb = %subst(MoBenb:9:3)
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2Rtn             7
     C                   Parm                    O2Parm
      *
     C                   Eval      Lv1Swaut = O2Rtn
                                                                                              PNL015
      * Get head Office Information                                                           PNL015
     C                   Eval      W#BranchBic   = MoBenb                                     PNL015
     C                   Exsr      SrGetHeadOff                                               PNL015
     C                   Eval      Lv1HeadOffice = W#HeadOffice                               PNL015
     C                   Eval      Lv1HeadSwaut  = W#HeadSwaut                                PNL015
      * If BIC is not connected search for country XXX BIC
      * Only if pre check for re-route
      *
     C                   If        ICRrOv = 'Y' or
     C                             Lv1Swaut <> *blanks
     C                             and %subst(MoBenb:8:1) = '1'
     C                   Exsr      SrNCont1
     C                   Endif
      *
      * If BIC Plus Key
      *
     C                   If        %subst(MoBenb:1:8) <> *blanks And
     C                             %subst(MoBenb:9:3) = *blanks
      *
     C                   Eval      BsKey = MoBenb
      * Get BIC Plus Key
      *
     C     KBSchV1       Chain     @BschV1
     C                   If        %Found
     C                   Exsr      SrBicPlus
     C                   Endif
     C                   Endif
      *
     C                   Endsl
      *
      *  Unwind subroutine stack name
      *
     C     ExInfol1      TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
                                                                                              ESL044
     C/EJECT                                                                                  ESL044
      *****************************************************************                       ESL044
      *                                                               *                       ESL044
      *  SrCustomRoute: Customer Specific Route                       *                       ESL044
      *                                                               *                       ESL044
      *  CALLED BY: Main processing                                   *                       ESL044
      *                                                               *                       ESL044
      *****************************************************************                       ESL044
     CSR   SrCustomRoute BEGSR                                                                ESL044
      *                                                                                       ESL044
      *  Set up subroutine stack name                                                         ESL044
      *                                                                                       ESL044
     C                   ADD       1             Q                 5 0                        ESL044
     C                   MOVEL     'SrCustomR'   @STK(Q)                                      ESL044
      *                                                                                       ESL044
      *  Check Ordering Customer for IBAN                                                     ESL044
      *                                                                                       ESL044
     C     KMsCsV1       Klist                                                                ESL044
     C                   KFld                    CsIdks                                       ESL044
     C                   KFld                    CsIban                                       ESL044
     C                   KFld                    CsPccy                                       ESL044
     C                   KFld                    CsRef1                                       ESL044
     C                   KFld                    CsRef2                                       ESL044
      *                                                                                       ESL044
     C                   Clear                   Csref1                                       ESL044
     C                   Clear                   Csref2                                       ESL044
      *                                                                                       ESL044
     C                   If        W#Btbi <> *blanks                                          ESL044
     C                   Eval      W#Ptr = 1                                                  ESL044
     C     '/CSPRT/'     Scan      W#Btbi:W#Ptr                                               ESL044
      *                                                                                       ESL044
     C                   If        W#Ptr > 0                                                  ESL044
     C                   Eval      Csref1 = %Subst(W#Btbi:W#Ptr+7:11)                         ESL044
     C                   Eval      Csref2 = %Subst(W#Btbi:W#Ptr+18:12)                        ESL044
     C                   Endif                                                                ESL044
      *                                                                                       ESL044
     C                   Endif                                                                ESL044
      *                                                                                       ESL044
     C                   If        %Subst(MoOrdc:1:3) = '/PL' or                              ESL044
     C                             CsRef1 <> *blanks                                          ESL044
      *                                                                                       ESL044
     C                   Clear                   CsIdks                                       ESL044
     C                   Eval      CsIban = MoOrdc                                            ESL044
     C                   Eval      CsPccy = MoPccy                                            ESL044
      *                                                                                       ESL044
     C                   If        CsRef1 = *blanks                                           ESL044
     C                   Eval      CsRef1 = MoBenb                                            ESL044
     C                   Clear                   CsRef2                                       ESL044
     C                   Endif                                                                ESL044
      *                                                                                       ESL044
     C     KMsCsV1       Chain     @MsCsV1                            90                      ESL044
                                                                                              ESL044
      * Get generic route for customer                                                        ESL044
     C                   If        Not %Found                                                 ESL044
     C                   Eval      CsRef1 = '???????????'                                     ESL044
     C     KMsCsV1       Chain     @MsCsV1                            90                      ESL044
     C                   Endif                                                                ESL044
      *                                                                                       ESL044
     C                   If        %Found                                                     ESL044
     C                   Exsr      SrPayDat1c                                                 ESL044
      *                                                                                       ESL044
     C                   If        W#Valid = 'Y'                                              ESL044
     C                   Exsr      SrPayCoptc                                                 ESL044
     C                   Endif                                                                ESL044
                                                                                              ESL044
      * Format Route as Ok                                                                    ESL044
     C                   Select                                                               ESL044
     C                   When      W#Valid = 'Y' and                                          ESL044
     C                             CsRef1 <> '???????????'                                    ESL044
      *                                                                                       ESL044
      *  Return information                                                                   ESL044
     C                   Clear                   MoDmac                                       ESL044
     C                   Clear                   MoSncr                                       ESL044
     C                   Clear                   MoSett                                       ESL044
     C                   Clear                   MoIntr                                       ESL044
      *                                                                                       ESL044
     C                   Eval      P0Rtn  = 'Route'                                           ESL044
      *                                                                                       ESL044
     C                   Eval      MoRccr = csC54c + csC54b                                   ESL044
     C                   Eval      MoDstr = csCbic + csCbib                                   ESL044
     C                   Eval      MoDmac = CsCdst                                            ESL044
     C                   Eval      MoIntr = csC56c + csC56b                                   ESL044
     C                   Eval      MoAcbr = MoBenb                                            ESL044
     C                   Eval      MoCvrr = csC53r                                            ESL044
     C                   Eval      MoCthr = csC53a                                            ESL044
     C                   Eval      MoSett = csStmt                                            ESL044
     C                   Eval      MoBtbi = csc721 + csc722 + csc723 +                        ESL044
     C                                      csc724 + csc725 + csc726                          ESL044
     C                   Eval      Mor910 = csr910                                            ESL044
      *                                                                                       ESL044
      *  Extract account information                                                          ESL044
     C                   Clear                   MoSncr                                       ESL044
     C                   If        MoCthr <> *blanks                                          ESL044
     C                   Eval      W0Account = MoCthr                                         ESL044
     C                   Exsr      SrAccount                                                  ESL044
     C                   Eval      MpC53C = %subst(BBCSID:1:8)                  FI            ESL044
     C                   Eval      MpC53B = %subst(BBCSID:9:3)                  FI            ESL044
                                                                                              ESL044
      * If blank set to XXX                                                                   ESL044
     C                   If        MpC53B = *blanks and MpC53c <> *blanks                     ESL044
     C                   Eval      MpC53B = 'XXX'                                             ESL044
     C                   Endif                                                                ESL044
     C                   Eval      MoSncr = MpC53c + MpC53b                                   ESL044
     C                   Endif                                                                ESL044
      *                                                                                       ESL044
     C                   Other                                                                ESL044
                                                                                              ESL044
      * If Manual Route on failure then note                                                  ESL044
     C                   If        CsMrof = 'M'                                               ESL044
     C                   Eval      P0Rtn  = 'CustMan'                                         ESL044
     C                   Endif                                                                ESL044
     C                   Endsl                                                                ESL044
                                                                                              ESL044
     C                   Endif                                                                ESL044
                                                                                              ESL044
     C                   Endif                                                                ESL044
      *                                                                                       ESL044
      *  Unwind subroutine stack name                                                         ESL044
      *                                                                                       ESL044
     C     ExCustomR     TAG                                                                  ESL044
     C                   MOVEA     *BLANKS       @STK(Q)                                      ESL044
     C                   SUB       1             Q                                            ESL044
      *                                                                                       ESL044
     CSR                 ENDSR                                                                ESL044
      *****************************************************************                       ESL044
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrBicPlus: Non Connected BIC as receiver                     *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrBicPlus     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrBicPlus'   @STK(Q)
      *
      * If BIC Plus Key
      *
     C                   If        %subst(MoBenb:1:8) <> *blanks And
     C                             %subst(MoBenb:9:3) = *blanks
      *

     C     KBSchV1       Klist
     C                   KFld                    BsKey

     C     KBSchV2p      Klist
     C                   KFld                    BsCntc
     C                   KFld                    BsNati

     C     KBSchV2r      Klist
     C                   KFld                    BsCntc
      *
     C                   Eval      BsKey = MoBenb
      * Get BIC Plus Key
      *
     C     KBSchV1       Chain     @BschV1
     C                   If        %Found
      *
      * If BIC Replace
     C                   Select
     C                   When      BsBic <> *blanks
     C                   Eval      MoBenb = BsBic
     C                   When      BsCntC = 'PL'
      *
      * If Not BIC Replace search for connected BIC
     C                   Movel     BsNati        ##003A            3
     C                   Movel(p)  ##003A        BsNati
      *
     C     KBSchV2p      Setll     @BschV2
     C     KBSchV2r      Reade     @BschV2                                90
     C                   If        *In90 = *Off
     C                   DoU       *In90 = *On
      *
      * If First 3 do not match exit
     C                   If        %SubSt(BsNati:1:3) = ##003A
     C                             And %Subst(BsBic:1:8) <> *blanks
     C                             And %Subst(BsBic:9:3) = 'XXX'
     C                   Eval      MoPthr = BsBIc
     C                   Leave
     C                   Endif
      *
      * If First 3 do not match exit
     C                   If        %SubSt(BsNati:1:3) <> ##003A
     C                   Leave
     C                   Endif
     C     KBSchV2r      Reade     @BschV2                                90
     C                   Enddo
     C                   Endif
     C                   Endsl
     C                   Endif

     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExBicPlus     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrNCont1 : Non Connected BIC as receiver                     *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrNCont1      BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrNCont1'    @STK(Q)
      *
      * Check for re-direction
      *
     C                   If        ICRrOv = 'Y'
     C                   Eval      MrrBic = %subst(MoBenb:1:8)
     C                   Eval      MrrBib = %subst(MoBenb:9:3)
     C                   Eval      MrPccy = MoPccy
      *
     C     KMscrV2       Setll     @MscrV2
     C     KMscrV2       Reade     @MscrV2                                90
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On
      *
      * Check dates
     C                   Exsr      SrRrtDat1
     C                   If        W#Valid = 'Y'
      * Check convention and amounts
     C                   Exsr      SrRrtCopt
     C                   Endif
     C                   If        W#Valid = 'Y'
      *
      *  Look for re-routes for this BIC
     C                   Exsr      SrLkRrtMap1
      *
     C                   Goto      ExNCont1
     C                   Endif

     C     KMscrV2       Reade     @MscrV2                                90
     C                   Enddo
     C                   Endif
     C                   Endif
      *
      * If connected then exit
      *    only if SWIFT keys exchanged and not 'XXX'                                         Djb005
     C                   If        ICRrOv = 'Y'
     C                             and %subst(MoBenb:8:1) <> '1'
     C                             and Lv1Swaut = *blanks                                     Djb005
     C                             and %subst(MoBenb:9:3) = 'XXX'                             Djb005
     C                   Goto      ExNCont1
     C                   Endif
      *
      * Now try a generic re-route
     C                   If        P0Rtn  <> 'Route'
     C                   Eval      MrrBic = %subst(MoBenb:1:8)
     C                   Eval      MrrBib = '???'
     C                   Eval      MrPccy = MoPccy
      *
     C     KMscrV2       Setll     @MscrV2
     C     KMscrV2       Reade     @MscrV2                                90
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On
      *
      * Check dates
     C                   Exsr      SrRrtDat1
     C                   If        W#Valid = 'Y'
      * Check convention and amounts
     C                   Exsr      SrRrtCopt
     C                   Endif
     C                   If        W#Valid = 'Y'
      *
      * If Receiver is to be replaced
      *
     C                   If        MrRplc = 'Y'
     C                   Eval      MoBenb = MrBicc + Mrbicb
     C                   Else
     C                   Eval      MoPthr = MrBicc + Mrbicb
     C                   Endif
      *
     C                   Eval      BdBicc = MrBicc
     C                   Eval      BdBicb = MrBicb
      *
     C     KBicdL2       Chain     @BicdL2
     C                   If        %Found
      *
     C                   Eval      DsTopBicD = DsBicd
      *
      *  Check for specific routing for Pay Through
     C                   Eval      O2SBicc = %subst(MoPthr:1:8)
     C                   Eval      O2SBicb = %subst(MoPthr:9:3)
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat
      *
     C                   Eval      Lv1Swaut = O2Rtn
      *
     C                   Goto      ExNCont1
     C                   Endif
     C                   Endif

     C     KMscrV2       Reade     @MscrV2                                90
     C                   Enddo
     C                   Endif
     C                   Endif
      *
      * Now try a generic re-route for bic/country
     C                   If        P0Rtn  <> 'Route'
     C                   Eval      MrrBic = %subst(MoBenb:1:8)
     C                   Eval      %Subst(MrrBic:8:1) = '?'
     C                   Eval      MrrBib = '???'
     C                   Eval      MrPccy = MoPccy
      *
     C     KMscrV2       Setll     @MscrV2
     C     KMscrV2       Reade     @MscrV2                                90
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On
      *
      * Check dates
     C                   Exsr      SrRrtDat1
     C                   If        W#Valid = 'Y'
      * Check convention and amounts
     C                   Exsr      SrRrtCopt
     C                   Endif
     C                   If        W#Valid = 'Y'
      *
      * If Receiver is to be replaced
      *
     C                   If        MrRplc = 'Y'
     C                   Eval      MoBenb = MrBicc + Mrbicb
     C                   Else
     C                   Eval      MoPthr = MrBicc + Mrbicb
     C                   Endif
      *
     C                   Eval      BdBicc = MrBicc
     C                   Eval      BdBicb = MrBicb
      *
     C     KBicdL2       Chain     @BicdL2
     C                   If        %Found
      *
     C                   Eval      DsTopBicD = DsBicd
      *
      *  Check for specific routing for Pay Through
     C                   Eval      O2SBicc = %subst(MoPthr:1:8)
     C                   Eval      O2SBicb = %subst(MoPthr:9:3)
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat
      *
     C                   Eval      Lv1Swaut = O2Rtn
      *
     C                   Goto      ExNCont1
     C                   Endif
     C                   Endif

     C     KMscrV2       Reade     @MscrV2                                90
     C                   Enddo
     C                   Endif
     C                   Endif
      *
      * If BIC is not connected search for country XXX BIC
      *
      *                                                                                       Djb005
      * If connected then exit                                                                Djb005
      *    only if SWIFT keys exchanged and not 'XXX'                                         Djb005
     C                   If        %subst(MoBenb:8:1) <> '1'                                  Djb005
     C                   Goto      ExNCont1                                                   Djb005
     C                   Endif                                                                Djb005
      *
      * Try to find connected XXX with nearest match
      *
     C                   Eval      BdBicc = %subst(MoBenb:1:6)
     C                   Eval      BdBicb = *blanks
      *
     C     KBicdL2       Setll     @BicdL2
     C                   Read      @BicdL2                                90
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On
      *
     C                   If        %subst(BdBicc:1:6) <> %subst(MoBenb:1:6)
     C                   Leave
     C                   Endif
      *
     C                   If        %subst(BdBicc:1:7) = %subst(MoBenb:1:7)
     C                             and %subst(BdBicc:8:1) <> '1'
     C                             and BdBicb = 'XXX'
     C                   Eval      MoPthr = BdBicc + BdBicb
     C                   Eval      DsTopBicD = DsBicd
      *
      *  Check for specific routing for Pay Through
     C                   Eval      O2SBicc = %subst(MoPthr:1:8)
     C                   Eval      O2SBicb = %subst(MoPthr:9:3)
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat
      *
     C                   Eval      Lv1Swaut = O2Rtn
     C                   Leave
     C                   Endif
      *
     C                   If        %subst(BdBicc:1:6) = %subst(MoBenb:1:6)
     C                             and %subst(BdBicc:1:8) <> '1'
     C                             and BdBicb = 'XXX'
      *
     C                   Eval      MoPthr = BdBicc + BdBicb
     C                   Eval      DsTopBicD = DsBicd
      *
      *  Check for specific routing for Pay Through
     C                   Eval      O2SBicc = %subst(MoPthr:1:8)
     C                   Eval      O2SBicb = %subst(MoPthr:9:3)
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat
      *
     C                   Eval      Lv1Swaut = O2Rtn
     C                   Endif
      * Read next record
     C                   Read      @BicdL2                                90
     C                   Enddo
     C                   Endif
      *
      *
      *  Unwind subroutine stack name
      *
     C     ExNCont1      TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  Srlevel1 : level 1 routing                                   *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrLevel1      BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrLevel1'    @STK(Q)
      *
     C                   Clear                   DsTopSTPCorr
      *  What has been input, Pay Through? Beneficiary Bank or Country
      *
     C                   Select
     C                   When      MoPthr <> *blanks
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = %subst(MoPthr:1:8)
     C                   Eval      McBicb = %subst(MoPthr:9:3)
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

      * Check correspondent for payment
     C                   Exsr      SrCorDate
                                                                                              PNL014
      * Check correspondent time related information                                          PNL014
     C                   If        W#Valid = 'Y'                                              PNL014
     C                   Exsr      SrCorTime                                                  PNL014
     C                   Endif                                                                PNL014

     C                   If        W#Valid = 'Y'

     C                   Exsr      SrCorCheck

      * Check for direct send
     C                   If        W#Valid = 'Y' and Lv1SwAut = *blanks
     C                   Eval      O2SBicc = %subst(MoPthr:1:8)
     C                   Exsr      SrCheckSWAUT
      * Direct send allowed, continue
     C                   If        W#DirectSW = 'Y'
     C                   Eval      Lv1DirectSW = W#DirectSW
     C                   Else
     C                   Eval      Lv1DirectSW = W#DirectSW
     C                   Eval      W#Valid = 'N'
     C                   Endif
     C                   Endif

     C                   Endif

     C                   If        W#Valid = 'Y'
     C                   Eval      DsTopSTPCorr = DsSTPCorr

      * Analyse routing
     C                   Exsr      SrAnalyse1
     C                   Else

      * Not found Analyse routing
     C                   Exsr      SrNotFound1
     C                   Endif
      *
     C                   When      MoBenb <> *blanks
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = %subst(MoBenb:1:8)
     C                   Eval      McBicb = %subst(MoBenb:9:3)
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1


      * Check correspondent for payment
     C                   Exsr      SrCorDate

     C                   If        W#Valid = 'Y'

     C                   Exsr      SrCorCheck
                                                                                              PNL014
      * Check correspondent time related information                                          PNL014
     C                   If        W#Valid = 'Y'                                              PNL014
     C                   Exsr      SrCorTime                                                  PNL014
     C                   Endif                                                                PNL014

      * Check for direct send
     C                   If        W#Valid = 'Y' and Lv1SwAut = *blanks
     C                   Eval      O2SBicc = %subst(MoBenb:1:8)
     C                   Exsr      SrCheckSWAUT
      * Direct send allowed, continue
     C                   If        W#DirectSW = 'Y'
     C                   Eval      Lv1DirectSW = W#DirectSW
     C                   Else
     C                   Eval      Lv1DirectSW = W#DirectSW
     C                   Eval      W#Valid = 'N'
     C                   Endif
     C                   Endif

     C                   Endif

     C                   If        W#Valid = 'Y'
     C                   Eval      DsTopSTPCorr = DsSTPCorr

      * Analyse routing
     C                   Exsr      SrAnalyse1
     C                   Else

      * Not found Analyse routing
     C                   Exsr      SrNotFound1
     C                   Endif
      *
     C                   When      MoBenc <> *blanks
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = '????' + MoBenc + '??'
     C                   Eval      McBicb = '???'
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

     C                   Exsr      SrCorDate
     C                   If        W#Valid = 'Y'

      * Set Preferential indicator
     C                   Eval      Lv1McPcor = McPcor
     C                   Eval      Lv1McPnbr = McPnbr

      * Analyse routing
     C                   Exsr      SrReDirect2
     C                   Else

      * Not found Analyse routing
     C                   Exsr      SrNotFound1
     C                   Endif
     C                   Endsl
      *
      *  If no route then go to second level
      *
     C                   If        P0Rtn  <> 'Route'
      *
      *  Look for re-routes for this BIC
     C                   Exsr      SrLevel2
      *
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExLevel1      TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrCorCheck: Check for correspondent details                  *
      *                                                               *
      *  CALLED BY: Many                                              *
      *                                                               *
      *****************************************************************
     CSR   SrCorCheck    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrCorCheck'  @STK(Q)

      * Check dates
     C                   Exsr      SrCorDate

      * Test for convention
     C                   Clear                   W#Convention
     C                   If        W#Valid = 'Y'
     C                   Clear                   W#CompConv

      * Set up convention to check
     C                   Eval      W#CompConv = McS71a

     C                   Exsr      SrConvention
     C                   Endif

      * Test for Direct Payment
     C                   If        W#Valid = 'Y'
     C                   Exsr      SrCorDirect
     C                   Endif

      * Test for Payment Range
     C                   If        W#Valid = 'Y'
     C                   Exsr      SrCorRange
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExCorCheck    TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrCorDate : Check for correspondent active                   *
      *                                                               *
      *  CALLED BY: Many                                              *
      *                                                               *
      *****************************************************************
     CSR   SrCorDate     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrCorDate'   @STK(Q)
      *
      *  Check for inclusion, default is not included
     C                   Eval      W#Valid = 'N'
      *
      * Active and no date range
     C                   If        %Found and McStat = 'A'
     C                             and McStdt = 0 and McEndt = 0
     C                             or
      * Active and start date passed and no end date
     C                             %Found and McStat = 'A'
     C                             and McStdt > 0 and McStdt <= WuRdnb
     C                             and McEndt = 0
     C                             or
      * Active and start date passed and end date not passed
     C                             %Found and McStat = 'A'
     C                             and McStdt > 0 and McStdt < WuRdnb
     C                             and McEndt > 0 and McEndt >= WuRdnb
     C                             or
      * Active and no start date and end date not passed
     C                             %Found and McStat = 'A'
     C                             and McStdt = 0
     C                             and McEndt > 0 and McEndt >= WuRdnb
     C                             or
      * Suspended but start date not passed
     C                             %Found and McStat = 'S'
     C                             and McStdt > 0 and McStdt > WuRdnb
     C                             or
      * Suspended but end date passed
     C                             %Found and McStat = 'S'
     C                             and McEndt > 0 and McEndt < WuRdnb
     C                   Eval      W#Valid = 'Y'
     C                   Endif

      *
      *  Unwind subroutine stack name
      *
     C     ExCorDate     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
                                                                                              PNL014
     C/EJECT                                                                                  PNL014
      *****************************************************************                       PNL014
      *                                                               *                       PNL014
      *  SrDateStep: Step on date for iteration processing            *                       PNL014
      *                                                               *                       PNL014
      *  CALLED BY: Many                                              *                       PNL014
      *                                                               *                       PNL014
      *****************************************************************                       PNL014
     CSR   SrDateStep    BEGSR                                                                PNL014
      *                                                                                       PNL014
      *  Set up subroutine stack name                                                         PNL014
      *                                                                                       PNL014
     C                   ADD       1             Q                 5 0                        PNL014
     C                   MOVEL     'SrDateStep'  @STK(Q)                                      PNL014
                                                                                              PNL014
      * Calculate W#Days forward in pay currency                                              PNL014
     C                   Eval      W#Days = %Subst(IcTsDi:W#IterNbr:1)                        PNL014
     C                   Move      W#Days        W#DaysNbr                                    PNL014
      *                                                                                       PNL014
     C                   Select                                                               PNL014
     C                   When      W#IterNbr = 1                                              PNL014
     C                   Goto      ExDateStep                                                 PNL014
     C                   When      W#Days = '0'                                               PNL014
     C                   Eval      MoCDat = W#ValueDate                                       PNL014
     C                   Goto      ExDateStep                                                 PNL014
     C                   Other                                                                PNL014
     C                   Endsl                                                                PNL014
                                                                                              PNL014
      * Calculate new date                                                                    PNL014
     C                   Eval      W#Date = %SubSt(W#ValueDate:7:2)                           PNL014
     C                                    + %SubSt(W#ValueDate:5:2)                           PNL014
     C                                    + %SubSt(W#ValueDate:3:2)                           PNL014
                                                                                              PNL014
     C                   Movel     W#Date        ZDate                                        PNL014
                                                                                              PNL014
     C                   Call      'ZDATE1'                                                   PNL014
     C                   Parm      *blanks       ZErr                                         PNL014
     C                   Parm                    ZDate                                        PNL014
     C                   Parm      'D'           ZDateFmt                                     PNL014
     C                   Parm                    ZDayNbr                                      PNL014
                                                                                              PNL014
      * Loop forward number of days                                                           PNL014
     C     1             Do        W#DaysNbr                                                  PNL014
                                                                                              PNL014
      * Loop until working day                                                                PNL014
     C                   DoU       Z0HolInd = 'W' or Z0HolInd = ' '                           PNL014
                                                                                              PNL014
     C                   Eval      ZDayNbr = ZDayNbr + 1                                      PNL014
                                                                                              PNL014
     C                   Call      'FT0305'                                                   PNL014
     C                   Parm      *blanks       Zerr                                         PNL014
     C                   Parm      ZDayNbr       Z0RDNB            5 0                        PNL014
     C                   Parm      MoPccy        Z0CCY             3                          PNL014
     C                   Parm      *blanks       Z0Loc             3                          PNL014
     C                   Parm      *blanks       Z0HolInd          1                          PNL014
                                                                                              PNL014
     C                   Enddo                                                                PNL014
                                                                                              PNL014
     C                   Enddo                                                                PNL014
                                                                                              PNL014
      * Get Midas date as CcYyMmDd                                                            PNL014
     C                   Call      'ZM0065'                                                   PNL014
     C                   Parm      ZDayNbr       ZMDay                                        PNL014
     C                   Parm      *blanks       ZSDate                                       PNL014
     C                   Parm      *blanks       ZSDatc                                       PNL014
      *                                                                                       PNL014
     C                   Eval      MoCDat = ZSDatc                                            PNL014
      *                                                                                       PNL014
      *  Unwind subroutine stack name                                                         PNL014
      *                                                                                       PNL014
     C     ExDateStep    TAG                                                                  PNL014
     C                   MOVEA     *BLANKS       @STK(Q)                                      PNL014
     C                   SUB       1             Q                                            PNL014
      *                                                                                       PNL014
     CSR                 ENDSR                                                                PNL014
      *****************************************************************                       PNL014
                                                                                              PNL014
     C/EJECT                                                                                  PNL014
      *****************************************************************                       PNL014
      *                                                               *                       PNL014
      *  SrCorTime : Check for correspondent time sensitive inform    *                       PNL014
      *                                                               *                       PNL014
      *  CALLED BY: Many                                              *                       PNL014
      *                                                               *                       PNL014
      *****************************************************************                       PNL014
     CSR   SrCorTime     BEGSR                                                                PNL014
      *                                                                                       PNL014
      *  Set up subroutine stack name                                                         PNL014
      *                                                                                       PNL014
     C                   ADD       1             Q                 5 0                        PNL014
     C                   MOVEL     'SrCorTime'   @STK(Q)                                      PNL014
                                                                                              PNL014
      * Check if valid for iteration                                                          PNL014
     C                   If        McTsIs = *blanks                                           PNL014
     C                   Eval      McTsIs = IcTsDs                                            PNL014
     C                   Endif                                                                PNL014
     C                   Eval      W#Check = %Subst(McTsIs:W#IterNbr:1)                       PNL014
     C                   If        W#Check = 'N' and IcTsRt = 'Y' or                          PNL014
     C                             W#Check = *blanks and W#IterNbr > 1                        PNL014
     C                   Eval      W#Valid = 'N'                                              PNL014
     C                   Goto      ExCorTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   If        McTsCk = *blanks or ICTSRT <> 'Y'                          PNL014
     C                   Goto      ExCorTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
      *  Check for inclusion, default is not included                                         PNL014
     C                   Eval      W#Valid = 'N'                                              PNL014
                                                                                              PNL014
      * Call Time Sensitive check program                                                     PNL014
     C                   Eval      TspP0RTN    = *blanks                                      PNL014
                                                                                              PNL014
     C                   Eval      TspP0Action = '*CorRoute'                                  PNL014
     C                   Eval      TspP1Parm   = MrotDs                                       PNL014
                                                                                              PNL014
     C                   Clear                   TspP2Parm                                    PNL014
     C                   Eval      TspK#MsccBicC = McBicC                                     PNL014
     C                   Eval      TspK#MsccBicB = McBicB                                     PNL014
     C                   Eval      TspK#MsccPCcy = McPCcy                                     PNL014
                                                                                              PNL014
     C                   Eval      TspK#MsccStmt = McStmt                                     PNL014
                                                                                              PNL014
     C                   Clear                   TspP3Parm                                    PNL014
     C                   Clear                   TspP4Parm                                    PNL014
                                                                                              PNL014
     C                   Call      'FTP0719'                                                  PNL014
     C                   Parm                    TspP0RTN          7                          PNL014
     C                   Parm                    TspP0Action      10                          PNL014
     C                   Parm                    TspP1Parm                                    PNL014
     C                   Parm                    TspP2Parm                                    PNL014
     C                   Parm                    TspP3Parm                                    PNL014
     C                   Parm                    TspP4Parm                                    PNL014
                                                                                              PNL014
     C                   If        TspP0Rtn = '*Ok'                                           PNL014
     C                   Eval      W#Valid = 'Y'                                              PNL014
     C                   Endif                                                                PNL014
      *                                                                                       PNL014
      *  Unwind subroutine stack name                                                         PNL014
      *                                                                                       PNL014
     C     ExCorTime     TAG                                                                  PNL014
     C                   MOVEA     *BLANKS       @STK(Q)                                      PNL014
     C                   SUB       1             Q                                            PNL014
      *                                                                                       PNL014
     CSR                 ENDSR                                                                PNL014
      *****************************************************************                       PNL014
                                                                                              PNL014
     C/EJECT                                                                                  PNL014
      *****************************************************************                       PNL014
      *                                                               *                       PNL014
      *  SrPayTime : Check for corr. Pay Rte time sensitive inform    *                       PNL014
      *                                                               *                       PNL014
      *  CALLED BY: Many                                              *                       PNL014
      *                                                               *                       PNL014
      *****************************************************************                       PNL014
     CSR   SrPayTime     BEGSR                                                                PNL014
      *                                                                                       PNL014
      *  Set up subroutine stack name                                                         PNL014
      *                                                                                       PNL014
     C                   ADD       1             Q                 5 0                        PNL014
     C                   MOVEL     'SrPayTime'   @STK(Q)                                      PNL014
                                                                                              PNL014
      * Check if valid for iteration                                                          PNL014
     C                   If        MpTsIs = *blanks                                           PNL014
     C                   Eval      MpTsIs = IcTsDs                                            PNL014
     C                   Endif                                                                PNL014
     C                   Eval      W#Check = %Subst(MpTsIs:W#IterNbr:1)                       PNL014
     C                   If        W#Check = 'N' and IcTsRt = 'Y' or                          PNL014
     C                             W#Check = *blanks and W#IterNbr > 1                        PNL014
     C                   Eval      W#Valid = 'N'                                              PNL014
     C                   Goto      ExPayTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   If        MpTsCk = *blanks or ICTSRT <> 'Y'                          PNL014
     C                   Goto      ExPayTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
      *  Check for inclusion, default is not included                                         PNL014
     C                   Eval      W#Valid = 'N'                                              PNL014
                                                                                              PNL014
      * Call Time Sensitive check program                                                     PNL014
     C                   Eval      TspP0RTN    = *blanks                                      PNL014
                                                                                              PNL014
     C                   Eval      TspP0Action = '*PayRoute'                                  PNL014
     C                   Eval      TspP1Parm   = MrotDs                                       PNL014
                                                                                              PNL014
     C                   Clear                   TspP2Parm                                    PNL014
     C                   Clear                   TspP3Parm                                    PNL014
     C                   Eval      TspK#MscpBicC = MpBicC                                     PNL014
     C                   Eval      TspK#MscpBicB = MpBicB                                     PNL014
     C                   Eval      TspK#MscpPCcy = MpPCcy                                     PNL014
     C                   Eval      TspK#MscpCBic = MpCBic                                     PNL014
     C                   Eval      TspK#MscpCBiB = MpCBiB                                     PNL014
                                                                                              PNL014
     C                   Eval      TspK#MscpStmt = MpStmt                                     PNL014
                                                                                              PNL014
     C                   Clear                   TspP4Parm                                    PNL014
                                                                                              PNL014
     C                   Call      'FTP0719'                                                  PNL014
     C                   Parm                    TspP0RTN          7                          PNL014
     C                   Parm                    TspP0Action      10                          PNL014
     C                   Parm                    TspP1Parm                                    PNL014
     C                   Parm                    TspP2Parm                                    PNL014
     C                   Parm                    TspP3Parm                                    PNL014
     C                   Parm                    TspP4Parm                                    PNL014
                                                                                              PNL014
     C                   If        TspP0Rtn = '*Ok'                                           PNL014
     C                   Eval      W#Valid = 'Y'                                              PNL014
     C                   Endif                                                                PNL014
      *                                                                                       PNL014
      *  Unwind subroutine stack name                                                         PNL014
      *                                                                                       PNL014
     C     ExPayTime     TAG                                                                  PNL014
     C                   MOVEA     *BLANKS       @STK(Q)                                      PNL014
     C                   SUB       1             Q                                            PNL014
      *                                                                                       PNL014
     CSR                 ENDSR                                                                PNL014
      *****************************************************************                       PNL014
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrCorDirect : Check if correspondent may be paid direct      *
      *                                                               *
      *  CALLED BY: Many                                              *
      *                                                               *
      *****************************************************************
     CSR   SrCorDirect   BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrCorDirect' @STK(Q)
      *
     C                   Select
     C                   When      MoDtch = 'SHA' and McIdaS = 'Y'
     C                             Or
     C                             MoDtch = *blanks and McIdaS = 'Y'
     C                   Eval      W#Valid = 'N'
     C                   When      MoDtch = 'BEN' and McIdaB = 'Y'
     C                   Eval      W#Valid = 'N'
     C                   When      MoDtch = 'OUR' and McIdaO = 'Y'
     C                   Eval      W#Valid = 'N'
     C                   Endsl
      *
     C     ExCorDirect   TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrCorRange  : Check if correspondent amount is within range  *
      *                                                               *
      *  CALLED BY: Many                                              *
      *                                                               *
      *****************************************************************
     CSR   SrCorRange    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrCorRange'  @STK(Q)

      *  Look at amounts against convention

     C                   Select
     C                   When      MoDtch = 'SHA' or MoDtch = *blanks
      * Is amount within range
     C                   Select
     C                   When      McSpal = 0 and McSpah = 0
     C                             Or
     C                             MoPyam >= McSpaL and McSpaH = 0
     C                             Or
     C                             MoPyam >= McSpaL and MoPyam <= McSpaH
     C                   Other
     C                   Eval      W#Valid = 'N'
     C                   Endsl
     C                   When      MoDtch = 'BEN'
      * Is amount within range
     C                   Select
     C                   When      McBpal = 0 and McBpah = 0
     C                             Or
     C                             MoPyam >= McBpaL and McBpaH = 0
     C                             Or
     C                             MoPyam >= McBpaL and MoPyam <= McBpaH
     C                   Other
     C                   Eval      W#Valid = 'N'
     C                   Endsl
     C                   When      MoDtch = 'OUR'
      * Is amount within range
     C                   Select
     C                   When      McOpal = 0 and McOpah = 0
     C                             Or
     C                             MoPyam >= McOpaL and McOpaH = 0
     C                             Or
     C                             MoPyam >= McOpaL and MoPyam <= McOpaH
     C                   Other
     C                   Eval      W#Valid = 'N'
     C                   Endsl
      *
     C                   Endsl
      *
     C     ExCorRange    TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrPayDate : Check for pay route active                       *
      *                                                               *
      *  CALLED BY: Many                                              *
      *                                                               *
      *****************************************************************
     CSR   SrPayDate     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrPayDate'   @STK(Q)
      *
      *  Check for inclusion, default is not included
     C                   Eval      W#Valid = 'N'
      *
      * Active and no date range
     C                   If        %Found and MpStat = 'A'
     C                             and MpStdt = 0 and MpEndt = 0
     C                             or
      * Active and start date passed and no end date
     C                             %Found and MpStat = 'A'
     C                             and MpStdt > 0 and MpStdt <= WuRdnb
     C                             and MpEndt = 0
     C                             or
      * Active and start date passed and end date not passed
     C                             %Found and MpStat = 'A'
     C                             and MpStdt > 0 and MpStdt < WuRdnb
     C                             and MpEndt > 0 and MpEndt >= WuRdnb
     C                             or
      * Active and no start date and end date not passed
     C                             %Found and MpStat = 'A'
     C                             and MpStdt = 0
     C                             and MpEndt > 0 and MpEndt >= WuRdnb
     C                             or
      * Suspended but start date not passed
     C                             %Found and MpStat = 'S'
     C                             and MpStdt > 0 and MpStdt > WuRdnb
     C                             or
      * Suspended but end date passed
     C                             %Found and MpStat = 'S'
     C                             and MpEndt > 0 and MpEndt < WuRdnb
     C                   Eval      W#Valid = 'Y'
     C                   Endif

      *
      *  Unwind subroutine stack name
      *
     C     ExPayDate     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrPayDat1 : Check for pay route active                       *
      *                                                               *
      *  CALLED BY: Many                                              *
      *                                                               *
      *****************************************************************
     CSR   SrPayDat1     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrPayDat1'   @STK(Q)
      *
      *  Check for inclusion, default is not included
     C                   Eval      W#Valid = 'N'
      *
      * Active and no date range
     C                   If        *In90 = *Off and MpStat = 'A'
     C                             and MpStdt = 0 and MpEndt = 0
     C                             or
      * Active and start date passed and no end date
     C                             *In90 = *Off and MpStat = 'A'
     C                             and MpStdt > 0 and MpStdt <= WuRdnb
     C                             and MpEndt = 0
     C                             or
      * Active and start date passed and end date not passed
     C                             *In90 = *Off and MpStat = 'A'
     C                             and MpStdt > 0 and MpStdt < WuRdnb
     C                             and MpEndt > 0 and MpEndt >= WuRdnb
     C                             or
      * Active and no start date and end date not passed
     C                             *In90 = *Off and MpStat = 'A'
     C                             and MpStdt = 0
     C                             and MpEndt > 0 and MpEndt >= WuRdnb
     C                             or
      * Suspended but start date not passed
     C                             *In90 = *Off and MpStat = 'S'
     C                             and MpStdt > 0 and MpStdt > WuRdnb
     C                             or
      * Suspended but end date passed
     C                             *In90 = *Off and MpStat = 'S'
     C                             and MpEndt > 0 and MpEndt < WuRdnb
     C                   Eval      W#Valid = 'Y'
     C                   Endif

      *
      *  Unwind subroutine stack name
      *
     C     ExPayDat1     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
                                                                                              ESL044
     C/EJECT                                                                                  ESL044
      *****************************************************************                       ESL044
      *                                                               *                       ESL044
      *  SrPayDat1c: Check for pay route active Gustomer Specific     *                       ESL044
      *                                                               *                       ESL044
      *  CALLED BY: Many                                              *                       ESL044
      *                                                               *                       ESL044
      *****************************************************************                       ESL044
     CSR   SrPayDat1c    BEGSR                                                                ESL044
      *                                                                                       ESL044
      *  Set up subroutine stack name                                                         ESL044
      *                                                                                       ESL044
     C                   ADD       1             Q                 5 0                        ESL044
     C                   MOVEL     'SrPayDat1c'  @STK(Q)                                      ESL044
      *                                                                                       ESL044
      *  Check for inclusion, default is not included                                         ESL044
     C                   Eval      W#Valid = 'N'                                              ESL044
      *                                                                                       ESL044
      * Active and no date range                                                              ESL044
     C                   If        *In90 = *Off and csStat = 'A'                              ESL044
     C                             and csStdt = 0 and csEndt = 0                              ESL044
     C                             or                                                         ESL044
      * Active and start date passed and no end date                                          ESL044
     C                             *In90 = *Off and csStat = 'A'                              ESL044
     C                             and csStdt > 0 and csStdt <= WuRdnb                        ESL044
     C                             and csEndt = 0                                             ESL044
     C                             or                                                         ESL044
      * Active and start date passed and end date not passed                                  ESL044
     C                             *In90 = *Off and csStat = 'A'                              ESL044
     C                             and csStdt > 0 and csStdt < WuRdnb                         ESL044
     C                             and csEndt > 0 and csEndt >= WuRdnb                        ESL044
     C                             or                                                         ESL044
      * Active and no start date and end date not passed                                      ESL044
     C                             *In90 = *Off and csStat = 'A'                              ESL044
     C                             and csStdt = 0                                             ESL044
     C                             and csEndt > 0 and csEndt >= WuRdnb                        ESL044
      * Suspended but start date not passed                                                   ESL044
     C                             or                                                         ESL044
     C                             *In90 = *Off and csStat = 'S'                              ESL044
     C                             and csStdt > 0 and csStdt > WuRdnb                         ESL044
     C                             or                                                         ESL044
      * Suspended but end date passed                                                         ESL044
     C                             *In90 = *Off and csStat = 'S'                              ESL044
     C                             and csEndt > 0 and csEndt < WuRdnb                         ESL044
     C                   Eval      W#Valid = 'Y'                                              ESL044
     C                   Endif                                                                ESL044
                                                                                              ESL044
      *                                                                                       ESL044
      *  Unwind subroutine stack name                                                         ESL044
      *                                                                                       ESL044
     C     ExPayDat1c    TAG                                                                  ESL044
     C                   MOVEA     *BLANKS       @STK(Q)                                      ESL044
     C                   SUB       1             Q                                            ESL044
      *                                                                                       ESL044
     CSR                 ENDSR                                                                ESL044
      *****************************************************************                       ESL044
                                                                                              ESL044
     C/EJECT                                                                                  ESL038
      *****************************************************************                       ESL038
      *                                                               *                       ESL038
      *  SrPayDat1g: Check for pay route active General Route         *                       ESL038
      *                                                               *                       ESL038
      *  CALLED BY: Many                                              *                       ESL038
      *                                                               *                       ESL038
      *****************************************************************                       ESL038
     CSR   SrPayDat1g    BEGSR                                                                ESL038
      *                                                                                       ESL038
      *  Set up subroutine stack name                                                         ESL038
      *                                                                                       ESL038
     C                   ADD       1             Q                 5 0                        ESL038
     C                   MOVEL     'SrPayDat1g'  @STK(Q)                                      ESL038
      *                                                                                       ESL038
      *  Check for inclusion, default is not included                                         ESL038
     C                   Eval      W#Valid = 'N'                                              ESL038
      *                                                                                       ESL038
      * Active and no date range                                                              ESL038
     C                   If        *In90 = *Off and MgStat = 'A'                              ESL038
     C                             and MgStdt = 0 and MgEndt = 0                              ESL038
     C                             or                                                         ESL038
      * Active and start date passed and no end date                                          ESL038
     C                             *In90 = *Off and MgStat = 'A'                              ESL038
     C                             and MgStdt > 0 and MgStdt <= WuRdnb                        ESL038
     C                             and MgEndt = 0                                             ESL038
     C                             or                                                         ESL038
      * Active and start date passed and end date not passed                                  ESL038
     C                             *In90 = *Off and MgStat = 'A'                              ESL038
     C                             and MgStdt > 0 and MgStdt < WuRdnb                         ESL038
     C                             and MgEndt > 0 and MgEndt >= WuRdnb                        ESL038
     C                             or                                                         ESL038
      * Active and no start date and end date not passed                                      ESL038
     C                             *In90 = *Off and MgStat = 'A'                              ESL038
     C                             and MgStdt = 0                                             ESL038
     C                             and MgEndt > 0 and MgEndt >= WuRdnb                        ESL038
     C                             or                                                         ESL038
      * Suspended but start date not passed                                                   ESL038
     C                             *In90 = *Off and MgStat = 'S'                              ESL038
     C                             and MgStdt > 0 and MgStdt > WuRdnb                         ESL038
     C                             or                                                         ESL038
      * Suspended but end date passed                                                         ESL038
     C                             *In90 = *Off and MgStat = 'S'                              ESL038
     C                             and MgEndt > 0 and MgEndt < WuRdnb                         ESL038
     C                   Eval      W#Valid = 'Y'                                              ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
      *                                                                                       ESL038
      *  Unwind subroutine stack name                                                         ESL038
      *                                                                                       ESL038
     C     ExPayDat1g    TAG                                                                  ESL038
     C                   MOVEA     *BLANKS       @STK(Q)                                      ESL038
     C                   SUB       1             Q                                            ESL038
      *                                                                                       ESL038
     CSR                 ENDSR                                                                ESL038
      *****************************************************************                       ESL038
                                                                                              ESL038
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrRrtCopt : Check for re-route charge option                 *
      *                                                               *
      *  CALLED BY: Many                                              *
      *                                                               *
      *****************************************************************
     CSR   SrRrtCopt     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrRrtCopt'   @STK(Q)
      *
      *  Check for inclusion, default is not included
     C                   Eval      W#Valid = 'N'
      *
     C                   Select
      * If SHA or blanks
     C                   When      MoDtch = 'SHA' and MrShaR = 'Y'
     C                             Or
     C                             MoDtch = *blanks and MrShaR = 'Y'
      *
      * If amount within range
     C                   Select
     C                   When      MrShaL = 0 and MrShaH = 0
     C                             Or
     C                             MoPyam >= MrShaL and MrShaH = 0
     C                             Or
     C                             MoPyam >= MrShaL and MoPyam <= MrShaH
     C                   Eval      W#Valid = 'Y'
     C                   Endsl
      * If OUR
     C                   When      MoDtch = 'OUR' and MrOurR = 'Y'
      *
      * If amount within range
     C                   Select
     C                   When      MrOurL = 0 and MrOurH = 0
     C                             Or
     C                             MoPyam >= MrOurL and MrOurH = 0
     C                             Or
     C                             MoPyam >= MrOurL and MoPyam <= MrOurH
     C                   Eval      W#Valid = 'Y'
     C                   Endsl
      * If BEN
     C                   When      MoDtch = 'BEN' and MrBenR = 'Y'
      *
      * If amount within range
     C                   Select
     C                   When      MrBenL = 0 and MrBenH = 0
     C                             Or
     C                             MoPyam >= MrBenL and MrBenH = 0
     C                             Or
     C                             MoPyam >= MrBenL and MoPyam <= MrBenH
     C                   Eval      W#Valid = 'Y'
     C                   Endsl
     C                   Endsl

      *
      *  Unwind subroutine stack name
      *
     C     ExRrtCopt     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrPayCopt : Check for Pay charge option                      *
      *                                                               *
      *  CALLED BY: Many                                              *
      *                                                               *
      *****************************************************************
     CSR   SrPayCopt     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrPayCort'   @STK(Q)
      *
      *  Check for inclusion, default is not included
     C                   Eval      W#Valid = 'N'
      *
     C                   Select
      * If SHA or blanks
     C                   When      MoDtch = 'SHA' and MpShaR = 'Y'
     C                             Or
     C                             MoDtch = *blanks and MpShaR = 'Y'
      *
      * If amount within range
     C                   Select
     C                   When      MpShaL = 0 and MpShaH = 0
     C                             Or
     C                             MoPyam >= MpShaL and MpShaH = 0
     C                             Or
     C                             MoPyam >= MpShaL and MoPyam <= MpShaH
     C                   Eval      W#Valid = 'Y'
     C                   Endsl
      * If OUR
     C                   When      MoDtch = 'OUR' and MpOurR = 'Y'
      *
      * If amount within range
     C                   Select
      * Correct check                                                                         ESL038
     C*****              When      MrOurL = 0 and MpOurH = 0
     C                   When      MpOurL = 0 and MpOurH = 0                                  ESL038
     C                             Or
     C                             MoPyam >= MpOurL and MpOurH = 0
     C                             Or
     C                             MoPyam >= MpOurL and MoPyam <= MpOurH
     C                   Eval      W#Valid = 'Y'
     C                   Endsl
      * If BEN
     C                   When      MoDtch = 'BEN' and MpBenR = 'Y'
      *
      * If amount within range
     C                   Select
     C                   When      MpBenL = 0 and MpBenH = 0
     C                             Or
     C                             MoPyam >= MpBenL and MpBenH = 0
     C                             Or
     C                             MoPyam >= MpBenL and MoPyam <= MpBenH
     C                   Eval      W#Valid = 'Y'
     C                   Endsl
     C                   Endsl

      *
      *  Unwind subroutine stack name
      *
     C     ExPayCopt     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
                                                                                              ESL044
     C/EJECT                                                                                  ESL044
      *****************************************************************                       ESL044
      *                                                               *                       ESL044
      *  SrPayCoptc: Check for Pay charge option  Customer Specific   *                       ESL044
      *                                                               *                       ESL044
      *  CALLED BY: Many                                              *                       ESL044
      *                                                               *                       ESL044
      *****************************************************************                       ESL044
     CSR   SrPayCoptc    BEGSR                                                                ESL044
      *                                                                                       ESL044
      *  Set up subroutine stack name                                                         ESL044
      *                                                                                       ESL044
     C                   ADD       1             Q                 5 0                        ESL044
     C                   MOVEL     'SrPayCortg'  @STK(Q)                                      ESL044
      *                                                                                       ESL044
      *  Check for inclusion, default is not included                                         ESL044
     C                   Eval      W#Valid = 'N'                                              ESL044
      *                                                                                       ESL044
     C                   Select                                                               ESL044
      * If SHA or blanks                                                                      ESL044
     C                   When      MoDtch = 'SHA' and csShaR = 'Y'                            ESL044
     C                             Or                                                         ESL044
     C                             MoDtch = *blanks and csShaR = 'Y'                          ESL044
      *                                                                                       ESL044
      * If amount within range                                                                ESL044
     C                   Select                                                               ESL044
     C                   When      csShaL = 0 and csShaH = 0                                  ESL044
     C                             Or                                                         ESL044
     C                             MoPyam >= csShaL and csShaH = 0                            ESL044
     C                             Or                                                         ESL044
     C                             MoPyam >= csShaL and MoPyam <= csShaH                      ESL044
     C                   Eval      W#Valid = 'Y'                                              ESL044
     C                   Endsl                                                                ESL044
      * If OUR                                                                                ESL044
     C                   When      MoDtch = 'OUR' and CsOurR = 'Y'                            ESL044
      *                                                                                       ESL044
      * If amount within range                                                                ESL044
     C                   Select                                                               ESL044
     C                   When      csOurL = 0 and csOurH = 0                                  ESL044
     C                             Or                                                         ESL044
     C                             MoPyam >= csOurL and csOurH = 0                            ESL044
     C                             Or                                                         ESL044
     C                             MoPyam >= csOurL and MoPyam <= csOurH                      ESL044
     C                   Eval      W#Valid = 'Y'                                              ESL044
     C                   Endsl                                                                ESL044
      * If BEN                                                                                ESL044
     C                   When      MoDtch = 'BEN' and csBenR = 'Y'                            ESL044
      *                                                                                       ESL044
      * If amount within range                                                                ESL044
     C                   Select                                                               ESL044
     C                   When      csBenL = 0 and csBenH = 0                                  ESL044
     C                             Or                                                         ESL044
     C                             MoPyam >= csBenL and csBenH = 0                            ESL044
     C                             Or                                                         ESL044
     C                             MoPyam >= csBenL and MoPyam <= csBenH                      ESL044
     C                   Eval      W#Valid = 'Y'                                              ESL044
     C                   Endsl                                                                ESL044
     C                   Endsl                                                                ESL044
                                                                                              ESL044
      *                                                                                       ESL044
      *  Unwind subroutine stack name                                                         ESL044
      *                                                                                       ESL044
     C     ExPayCoptc    TAG                                                                  ESL044
     C                   MOVEA     *BLANKS       @STK(Q)                                      ESL044
     C                   SUB       1             Q                                            ESL044
      *                                                                                       ESL044
     CSR                 ENDSR                                                                ESL044
      *****************************************************************                       ESL044
                                                                                              ESL044
                                                                                              ESL038
     C/EJECT                                                                                  ESL038
      *****************************************************************                       ESL038
      *                                                               *                       ESL038
      *  SrPayCoptg: Check for Pay charge option  General Routes      *                       ESL038
      *                                                               *                       ESL038
      *  CALLED BY: Many                                              *                       ESL038
      *                                                               *                       ESL038
      *****************************************************************                       ESL038
     CSR   SrPayCoptg    BEGSR                                                                ESL038
      *                                                                                       ESL038
      *  Set up subroutine stack name                                                         ESL038
      *                                                                                       ESL038
     C                   ADD       1             Q                 5 0                        ESL038
     C                   MOVEL     'SrPayCortg'  @STK(Q)                                      ESL038
      *                                                                                       ESL038
      *  Check for inclusion, default is not included                                         ESL038
     C                   Eval      W#Valid = 'N'                                              ESL038
      *                                                                                       ESL038
     C                   Select                                                               ESL038
      * If SHA or blanks                                                                      ESL038
     C                   When      MoDtch = 'SHA' and MgShaR = 'Y'                            ESL038
     C                             Or                                                         ESL038
     C                             MoDtch = *blanks and MgShaR = 'Y'                          ESL038
      *                                                                                       ESL038
      * If amount within range                                                                ESL038
     C                   Select                                                               ESL038
     C                   When      MgShaL = 0 and MgShaH = 0                                  ESL038
     C                             Or                                                         ESL038
     C                             MoPyam >= MgShaL and MgShaH = 0                            ESL038
     C                             Or                                                         ESL038
     C                             MoPyam >= MgShaL and MoPyam <= MgShaH                      ESL038
     C                   Eval      W#Valid = 'Y'                                              ESL038
     C                   Endsl                                                                ESL038
      * If OUR                                                                                ESL038
     C                   When      MoDtch = 'OUR' and MgOurR = 'Y'                            ESL038
      *                                                                                       ESL038
      * If amount within range                                                                ESL038
     C                   Select                                                               ESL038
     C                   When      MgOurL = 0 and MgOurH = 0                                  ESL038
     C                             Or                                                         ESL038
     C                             MoPyam >= MgOurL and MgOurH = 0                            ESL038
     C                             Or                                                         ESL038
     C                             MoPyam >= MgOurL and MoPyam <= MgOurH                      ESL038
     C                   Eval      W#Valid = 'Y'                                              ESL038
     C                   Endsl                                                                ESL038
      * If BEN                                                                                ESL038
     C                   When      MoDtch = 'BEN' and MgBenR = 'Y'                            ESL038
      *                                                                                       ESL038
      * If amount within range                                                                ESL038
     C                   Select                                                               ESL038
     C                   When      MgBenL = 0 and MgBenH = 0                                  ESL038
     C                             Or                                                         ESL038
     C                             MoPyam >= MgBenL and MgBenH = 0                            ESL038
     C                             Or                                                         ESL038
     C                             MoPyam >= MgBenL and MoPyam <= MgBenH                      ESL038
     C                   Eval      W#Valid = 'Y'                                              ESL038
     C                   Endsl                                                                ESL038
     C                   Endsl                                                                ESL038
                                                                                              ESL038
      *                                                                                       ESL038
      *  Unwind subroutine stack name                                                         ESL038
      *                                                                                       ESL038
     C     ExPayCoptg    TAG                                                                  ESL038
     C                   MOVEA     *BLANKS       @STK(Q)                                      ESL038
     C                   SUB       1             Q                                            ESL038
      *                                                                                       ESL038
     CSR                 ENDSR                                                                ESL038
      *****************************************************************                       ESL038
                                                                                              ESL038
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrRrtDate : Check for pay route active                       *
      *                                                               *
      *  CALLED BY: Many                                              *
      *                                                               *
      *****************************************************************
     CSR   SrRrtDate     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrRrtDate'   @STK(Q)
      *
      *  Check for inclusion, default is not included
     C                   Eval      W#Valid = 'N'
      *
      * Active and no date range
     C                   If        %Found and MrStat = 'A'
     C                             and MrStdt = 0 and MrEndt = 0
     C                             or
      * Active and start date passed and no end date
     C                             %Found and MrStat = 'A'
     C                             and MrStdt > 0 and MrStdt <= WuRdnb
     C                             and MrEndt = 0
     C                             or
      * Active and start date passed and end date not passed
     C                             %Found and MrStat = 'A'
     C                             and MrStdt > 0 and MrStdt < WuRdnb
     C                             and MrEndt > 0 and MrEndt >= WuRdnb
     C                             or
      * Active and no start date and end date not passed
     C                             %Found and MrStat = 'A'
     C                             and MrStdt = 0
     C                             and MrEndt > 0 and MrEndt >= WuRdnb
     C                             or
      * Suspended but start date not passed
     C                             %Found and MrStat = 'S'
     C                             and MrStdt > 0 and MrStdt > WuRdnb
     C                             or
      * Suspended but end date passed
     C                             %Found and MrStat = 'S'
     C                             and MrEndt > 0 and MrEndt < WuRdnb
     C                   Eval      W#Valid = 'Y'
     C                   Endif

      *
      *  Unwind subroutine stack name
      *
     C     ExRrtDate     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrRrtDat1 : Check for pay route active                       *
      *                                                               *
      *  CALLED BY: Many                                              *
      *                                                               *
      *****************************************************************
     CSR   SrRrtDat1     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrRrtDat1'   @STK(Q)
      *
      *  Check for inclusion, default is not included
     C                   Eval      W#Valid = 'N'
      *
      * Active and no date range
     C                   If        *In90 = *Off and MrStat = 'A'
     C                             and MrStdt = 0 and MrEndt = 0
     C                             or
      * Active and start date passed and no end date
     C                             *In90 = *Off and MrStat = 'A'
     C                             and MrStdt > 0 and MrStdt <= WuRdnb
     C                             and MrEndt = 0
     C                             or
      * Active and start date passed and end date not passed
     C                             *In90 = *Off and MrStat = 'A'
     C                             and MrStdt > 0 and MrStdt < WuRdnb
     C                             and MrEndt > 0 and MrEndt >= WuRdnb
     C                             or
      * Active and no start date and end date not passed
     C                             *In90 = *Off and MrStat = 'A'
     C                             and MrStdt = 0
     C                             and MrEndt > 0 and MrEndt >= WuRdnb
     C                             or
      * Suspended but start date not passed
     C                             *In90 = *Off and MrStat = 'S'
     C                             and MrStdt > 0 and MrStdt > WuRdnb
     C                             or
      * Suspended but end date passed
     C                             *In90 = *Off and MrStat = 'S'
     C                             and MrEndt > 0 and MrEndt < WuRdnb
     C                   Eval      W#Valid = 'Y'
     C                   Endif

      *
      *  Unwind subroutine stack name
      *
     C     ExRrtDat1     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrRecCorr : Select Receiver's Correspondent                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrRecCorr     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrRecCorr'   @STK(Q)
      *
     C                   Clear                   MoRccr
      *                                                                                       ESL038
      *  Check for ACX Clearing                                                               ESL038
      *                                                                                       ESL038
     C                   If        MoPvas = 'ACX'                                             ESL038
     C                             Or MoPvas = 'ACL'                                          ESL038
                                                                                              ESL038
     C                   If        MoPthr <> *blanks                                          ESL038
     C                   Eval      ClBbbc = %Subst(MoPthr:1:8)                                ESL038
     C                   Eval      ClBbcb = %Subst(MoPthr:9:3)                                ESL038
     C                   Else                                                                 ESL038
     C                   Eval      ClBbbc = %Subst(MoBenb:1:8)                                ESL038
     C                   Eval      ClBbcb = %Subst(MoBenb:9:3)                                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
      * Check clearing file for match                                                         ESL038
     C     KClRcV4       Chain     @ClRcV4                                                    ESL038
     C                   If        Not %Found                                                 ESL038
     C                   Eval      ClBbcb = '???'                                             ESL038
     C     KClRcV4       Chain     @ClRcV4                                                    ESL038
     C                   If        Not %Found                                                 PNL015
     C                   Eval      %Subst(ClBbbc:7:2) = '??'                                  PNL015
     C     KClRcV4       Chain     @ClRcV4                                                    PNL015
     C                   Endif                                                                PNL015
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   If        %Found                                                     ESL038
     C                   Eval      MoRccr = ClBicc + ClBicb                                   ESL038
     C                   Eval      MoRccd = ClQute                                            ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   Goto      ExRecCorr                                                  ESL038
                                                                                              ESL038
     C                   Endif                                                                ESL038
      *                                                                                       ESL038
      *  Only valid if 53 Sender's Correspondent has been set up and not the same
      *  receiver in country
      *
     C                   If        MoSncr <> *blanks and MoRccr = *blanks
     C                             and %subst(MoSncr:1:6) <> %subst(MoDstr:1:6)
      *
      * Clear arrays
     C     1             Do        100           ####T             5 0
     C                   Movel     *blanks       DstRec(####T)
     C                   Movel     *blanks       SncRec(####T)
     C                   Eval      DstPrefer(####T) = *blanks
     C                   Enddo
      *
      *  Get receiver correspondents of destination and match against those of the
      *  cover
      *
      *  Save reciver information
     C*****              Eval      MpBicc = %subst(Modstr:1:8)                                ESL038
     C*****              Eval      MpBicb = %subst(Modstr:9:3)                                ESL038
     C*****              Eval      MpPccy = MoPccy                                            ESL038
     C                   Eval      MgBicc = %subst(Modstr:1:8)                                ESL038
     C                   Eval      MgBicb = %subst(Modstr:9:3)                                ESL038
     C                   Eval      MgPccy = MoPccy                                            ESL038
                                                                                              ESL038
      *
     C                   Eval      ####T = 0
      *                                                                                       PNL015
      * Loop 5 times to pick up generics                                                      PNL015
     C     1             Do        5             ####Ptr           5 0                        PNL015
                                                                                              PNL015
      * Depending on loop check for correspondents                                            PNL015
     C                   Select                                                               PNL015
      * Specific BIC                                                                          PNL015
     C                   When      ####Ptr = 1                                                PNL015
      * All branches for BIC                                                                  PNL015
     C                   When      ####Ptr = 2                                                PNL015
     C                   Eval      MgBicc = %subst(Modstr:1:8)                                PNL015
     C                   Eval      MgBicb = '???'                                             PNL015
      * All branches for BIC in country                                                       PNL015
     C                   When      ####Ptr = 3                                                PNL015
     C                   Eval      MgBicc = %subst(Modstr:1:6) + '??'                         PNL015
     C                   Eval      MgBicb = '???'                                             PNL015
      * All bank worldwide                                                                    PNL015
     C                   When      ####Ptr = 4                                                PNL015
     C                   Eval      MgBicc = %subst(Modstr:1:4) + '????'                       PNL015
     C                   Eval      MgBicb = '???'                                             PNL015
      * Generic receiver for country                                                          PNL015
     C                   When      ####Ptr = 5                                                PNL015
     C                   Eval      MgBicc = '????' + %subst(Modstr:5:2) + '??'                PNL015
     C                   Eval      MgBicb = '???'                                             PNL015
     C                   Endsl                                                                PNL015
      *
     C**** KMscpV1p      Setll     @MscpV1                                                    ESL038
     C**** KMscpV1p      Reade     @MscpV1                                90                  ESL038
     C     KMsgrV1p      Setll     @MsgrV1                                                    ESL038
     C     KMsgrV1p      Reade     @MsgrV1                                90                  ESL038
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On

     C***                Exsr      SrPayDat1                                                  ESL038
     C                   Exsr      SrPayDat1g                                                 ESL038
                                                                                              ESL038
     C***                If        W#Valid = 'Y'                                              ESL038
     C***                Exsr      SrPayCopt                                                  ESL038
     C***                Endif                                                                ESL038
                                                                                              ESL038
     C                   If        W#Valid = 'Y'                                              ESL038
     C                   Exsr      SrPayCoptg                                                 ESL038
     C                   Endif                                                                ESL038
                                                                                              PNL015
      * If exclude from 54 then set as not valid                                              PNL015
                                                                                              PNL015
     C                   If        W#Valid = 'Y' and                                          PNL015
     C                             MgEx54  = 'Y'                                              PNL015
     C                   Eval      W#Valid = 'N'                                              PNL015
     C                   Endif                                                                PNL015
                                                                                              ESL038
      *
      * Only save if BICs are different
     C****               If        W#Valid = 'Y' and                                          ESL038
     C****                         MpBicc <> MpCbic                                           ESL038
     C****                         or                                                         ESL038
     C****                         W#Valid = 'Y' and                                          ESL038
     C****                         MpBicb <> MpCbib                                           ESL038
                                                                                              ESL038
     C                   If        W#Valid = 'Y' and                                          ESL038
     C                             MgBicc <> MgCbic                                           ESL038
     C                             or                                                         ESL038
     C                             W#Valid = 'Y' and                                          ESL038
     C                             MgBicb <> MgCbib                                           ESL038
                                                                                              ESL038
      * Save Receiver's
     C                   Eval      ####T = ####T + 1
     C***                Eval      DstRec(####T) = MpCbic + MpCbib + MpRcau                   ESL038
     C***                                          + MpRcAc                                   ESL038
                                                                                              ESL038
     C                   Eval      DstRec(####T) = MgCbic + MgCbib + MgRcau                   ESL038
     C                                             + MgRcAc                                   ESL038
     C                   Eval      DstPrefer(####T) = MgProt                                  ESL038
     C                   Endif

     C**** KMscpV1p      Reade     @MscpV1                                90                  ESL038
     C     KMsgrV1p      Reade     @MsgrV1                                90                  ESL038
     C                   Enddo
     C                   Endif
      *                                                                                       PNL015
     C                   Enddo                                                                PNL015
                                                                                              PNL015
      *
      *  Check for matching receiver
     C                   If        ####T <> 0
     C****               Eval      MpBicc = %subst(MoSncr:1:8)                                ESL038
     C****               Eval      MpBicb = %subst(MoSncr:9:3)                                ESL038
                                                                                              ESL038
     C                   Eval      MgBicc = %subst(MoSncr:1:8)
     C                   Eval      MgBicb = %subst(MoSncr:9:3)
                                                                                              ESL038
     C***                If        MpBicb = *blanks                                           ESL038
     C***                Eval      MpBicb = 'XXX'                                             ESL038
     C***                Endif                                                                ESL038
                                                                                              ESL038
     C                   If        MgBicb = *blanks
     C                   Eval      MgBicb = 'XXX'
     C                   Endif
                                                                                              ESL038
     C                   Eval      MpPccy = MoPccy
      *
     C**** KMscpV1p      Setll     @MscpV1                                                    ESL038
     C**** KMscpV1p      Reade     @MscpV1                                90                  ESL038
     C     KMsgrV1p      Setll     @MsgrV1                                                    ESL038
     C     KMsgrV1p      Reade     @MsgrV1                                90                  ESL038
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On

     C***                Exsr      SrPayDat1                                                  ESL038
     C                   Exsr      SrPayDat1g                                                 ESL038
                                                                                              ESL038
     C***                If        W#Valid = 'Y'                                              ESL038
     C***                Exsr      SrPayCopt                                                  ESL038
     C***                Endif                                                                ESL038
                                                                                              ESL038
     C                   If        W#Valid = 'Y'                                              ESL038
     C                   Exsr      SrPayCoptg                                                 ESL038
     C                   Endif                                                                ESL038
                                                                                              PNL015
      * If exclude from 54 then set as not valid                                              PNL015
                                                                                              PNL015
     C                   If        W#Valid = 'Y' and                                          PNL015
     C                             MgEx54  = 'Y'                                              PNL015
     C                   Eval      W#Valid = 'N'                                              PNL015
     C                   Endif                                                                PNL015
                                                                                              ESL038
      *                                                                                       ESL038
     C                   If        W#Valid = 'Y'
      *
      * Select Receiver's
     C     1             Do        ####T         ####S
                                                                                              ESL038
     C***                Eval      SncRecBic = MpCbic + MpCBib                                ESL038
     C                   Eval      SncRecBic = MgCbic + MgCBib                                ESL038
                                                                                              ESL038
     C                   Eval      DstRecBic = DstRec(####S)
     C                   Eval      DstRecRcA = %subst(DstRec(####S):12:1)
     C                   Eval      DstRecRcQ = %subst(DstRec(####S):13:35)
     C                   If        DstRecBic = SncRecBic and DstRecRcA <> 'N'
     C                   Eval      MoRccr = DstRecBic
     C                   If        DstRecRcA = 'Y' and DstRecRcQ <> *blanks
     C                   Eval      MoRccd = DstRecRcQ
     C                   Endif
     C                   Leave
     C                   Endif
     C                   Enddo

     C                   If        MoRccr <> *blanks
     C                   Leave
     C                   Endif
     C                   Endif

     C**** KMscpV1p      Reade     @MscpV1                                90                  ESL038
     C     KMsgrV1p      Reade     @MsgrV1                                90                  ESL038
     C                   Enddo
     C                   Endif
     C                   Endif

      * If not receiver then select one
     C                   If        MoRccr = *blanks and ####T <> 0
      *
      * Select Receiver's
     C     1             Do        ####T         ####S
     C                   Eval      DstRecBic = DstRec(####S)
     C                   Eval      DstRecRcA = %subst(DstRec(####S):12:1)
      *
      * Select Receiver's
     C******             If        DstRecRcA = ' ' and MoRccr = *blanks                       ESL038
     C                   If        MoRccr = *blanks                                           ESL038
     C                   Eval      MoRccr = DstRecBic
     C                   If        DstRecRcA = 'Y'                                            ESL038
     C                   Eval      MoRccd = DstRecRcQ                                         ESL038
     C                   Endif                                                                ESL038
     C                   Endif
                                                                                              ESL038
      *
      * Overwrite Receiver's
      * If prefered route                                                                     ESL038
     C******             If        DstRecRcA = 'Y'                                            ESL038
     C                   If        DstPrefer(####S) = 'Y'                                     ESL038
     C                   Eval      MoRccr = DstRecBic
     C                   If        DstRecRcA = 'Y'                                            ESL038
     C                   Eval      MoRccd = DstRecRcQ
     C                   Else                                                                 ESL038
     C                   Eval      MoRccd = *blanks                                           ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   Leave
                                                                                              ESL038
     C                   Endif
     C                   Enddo
     C                   Endif
      *
     C                   Endif
      *
      *
      *  Unwind subroutine stack name
      *
     C     ExRecCorr     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrAnalyse1: Analyse Correspondent Record                     *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrAnalyse1    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrAnalyse1'  @STK(Q)
      *
      *  See what is the next action
      *
     C                   Select
      *
      *  If correspondent has is type BENEF
     C                   When      McCtyp = 'SWIFTKEY' and Lv1Swaut = *blanks
      *
      *  Check to see if routing for SWIFTKEY with Account Type
     C                   Exsr      SrLkUpAcct1
      *
      *  No Accounting Found Try for Generic routing
      *
     C                   If        P0Rtn  <> 'Route'
      *
      *  Generic routing for BIC bank
     C                   Exsr      SrLkGenBic1
      *
     C                   Endif
      *
      *  If correspondent has is type BENEF
     C                   When      McCtyp = 'BENEF' or
     C                             McCtyp = 'SWIFTKEY' and Lv1Swaut <> *blanks
      *
      *  Check to see if routing for BENEF with Account Type
     C                   Exsr      SrLkUpAcct1
      *
      *  No Accounting Found Try for Generic routing
      *
     C                   If        P0Rtn  <> 'Route'
     C                             and Lv1McBicB <> '???'
      *
      *  Generic routing for BIC bank
     C                   Exsr      SrLkGenBic1
      *
     C                   Endif
      *
      *  If correspondent has is type ACCOUNT
     C                   When      McCtyp = 'ACCOUNT'
      *
      *  Check to see if routing for ACCOUNT Bic
     C                   Eval      MpBicc = McBicc
     C                   Eval      MpBicb = McBicb
     C                   Eval      MpPccy = MoPccy
     C                   Eval      MpCbic = MpBicc
     C                   Eval      MpCbib = MpBicb
      *
     C     KMscpV1       Chain     @MscpV1

     C                   Exsr      SrPayDate
     C                   If        W#Valid = 'Y'
     C                   Exsr      SrPayCopt
     C                   Endif
     C                   Select
     C                   When      W#Valid = 'Y'
      *
      *
      *  Return information
     C                   Clear                   MoDmac
     C                   Clear                   MoSncr
     C                   Clear                   MoSett
     C                   Clear                   MoIntr
     C                   Eval      MoRccr = MpC54c + MpC54b
     C                   Eval      MoDstr = MpCbic + MpCbib
                                                                                              PNL015
      * If send via head office and identified then swap                                      PNL015
     C                   If        MpRhob = 'Y' and Lv1HeadOffice <> *blanks                  PNL015
     C                             and Lv1HeadSwaut = *blanks                                 PNL015
     C                   Eval      MoDstr = Lv1HeadOffice                                     PNL015
     C                   Endif                                                                PNL015
                                                                                              PNL015
     C                   Eval      MoIntr = MpC56c + MpC56b
     C                   Eval      MoAcbr = MoBenb
     C                   Eval      MoCvrr = MpC53r
     C                   Eval      MoCthr = MpC53a
     C                   Eval      MoSett = MpStmt
     C                   Eval      Mor910 = Mpr910
      *
      *  Extract account information
     C                   Clear                   MoSncr
     C                   If        MoCthr <> *blanks
     C                   Eval      W0Account = MoCthr
     C                   Exsr      SrAccount
     C                   Eval      MpC53C = %subst(BBCSID:1:8)                  FI
     C                   Eval      MpC53B = %subst(BBCSID:9:3)                  FI

      * If blank set to XXX
     C                   If        MpC53B = *blanks and MpC53c <> *blanks
     C                   Eval      MpC53B = 'XXX'
     C                   Endif
     C                   Eval      MoSncr = MpC53c + MpC53b
     C                   Else
     C                   Eval      W0Account = McDacr
     C                   Exsr      SrAccount
     C                   Eval      MoDmac    = McDacr
     C                   Endif

      * Check Payment convention and Amounts
     C                   Exsr      SrCheckPay1

      * Only proceed if Ok
     C                   If        W#Valid = 'Y'

     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'Y'
     C                   Eval      RouteLVP = 'N'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'

      * Calculate charge for route
     C                   If        MpSchc <> *blanks or MpSchr <> 0
     C                   Eval      W#ChargeCode = MpSchc
     C                   Eval      W#ChargeRate = MpSchr
     C                   Eval      W#ChargeMin  = MpSchh
     C                   Eval      W#ChargeMax  = MpSchl
     C                   Else
     C                   Eval      W#ChargeCode = McSchc
     C                   Eval      W#ChargeRate = McSchr
     C                   Eval      W#ChargeMin  = McSchh
     C                   Eval      W#ChargeMax  = McSchl
     C                   Endif
     C                   Exsr      SrCharge
     C                   Eval      C#SChargeCode = W#ChargeCode
     C                   Eval      C#SChargeRate = W#ChargeRate
     C                   Eval      C#SChargeMin  = W#ChargeMin
     C                   Eval      C#SChargeMax  = W#ChargeMax
     C                   Eval      C#SChargeAmt  = W#ChargeAmt

     C                   Eval      W#ChargeCode = Mclchc
     C                   Eval      W#ChargeRate = Mclchr
     C                   Eval      W#ChargeMin  = Mclchh
     C                   Eval      W#ChargeMax  = Mclchl
     C                   Exsr      SrCharge
     C                   Eval      C#lChargeCode = W#ChargeCode
     C                   Eval      C#lChargeRate = W#ChargeRate
     C                   Eval      C#lChargeMin  = W#ChargeMin
     C                   Eval      C#lChargeMax  = W#ChargeMax
     C                   Eval      C#lChargeAmt  = W#ChargeAmt

      * Fill routing information on charge
     C                   Eval      MoStdc = C#SChargeCode
     C                   Eval      MoStda = C#SChargeAmt
     C                   Eval      MoLvpc = C#lChargeCode
     C                   Eval      MoLvpa = C#lChargeAmt

      * If Account with bank same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoAcbr
     C                   Clear                   MoIntr
     C                   Endif

      * If Destination same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoDstr
     C                   Clear                   MoIntr
     C                   Endif

     C                   Exsr      SrSTProute

     C                   Eval      P0Rtn  = 'Route'
     C                   Endif

     C                   When      W#Valid <> 'Y'
      *
      *  Return information
     C                   Clear                   MoDmac
     C                   Clear                   MoSncr
     C                   Clear                   MoIntr
     C                   Eval      MoRccr = *blanks
     C                   Eval      MoDstr = McBicc + McBicb
     C                   Eval      MoIntr = *blanks
     C                   Eval      MoAcbr = MoBenb
     C                   Eval      MoCvrr = 'N'
     C                   Eval      MoCthr = *blanks
     C                   Eval      MoSett = McStmt
      *
      *  Extract account information
     C                   Clear                   MoSncr
     C                   Eval      W0Account = McDacr
     C                   Exsr      SrAccount
     C                   Eval      MoDmac    = McDacr

      * Check Payment convention and Amounts
     C                   Exsr      SrCheckPay1

      * Only proceed if Ok
     C                   If        W#Valid = 'Y'

     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'Y'
     C                   Eval      RouteLVP = 'N'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'

      * Calculate charge for route
     C                   Eval      W#ChargeCode = McSchc
     C                   Eval      W#ChargeRate = McSchr
     C                   Eval      W#ChargeMin  = McSchh
     C                   Eval      W#ChargeMax  = McSchl
     C                   Exsr      SrCharge
     C                   Eval      C#SChargeCode = W#ChargeCode
     C                   Eval      C#SChargeRate = W#ChargeRate
     C                   Eval      C#SChargeMin  = W#ChargeMin
     C                   Eval      C#SChargeMax  = W#ChargeMax
     C                   Eval      C#SChargeAmt  = W#ChargeAmt

     C                   Eval      W#ChargeCode = Mclchc
     C                   Eval      W#ChargeRate = Mclchr
     C                   Eval      W#ChargeMin  = Mclchh
     C                   Eval      W#ChargeMax  = Mclchl
     C                   Exsr      SrCharge
     C                   Eval      C#lChargeCode = W#ChargeCode
     C                   Eval      C#lChargeRate = W#ChargeRate
     C                   Eval      C#lChargeMin  = W#ChargeMin
     C                   Eval      C#lChargeMax  = W#ChargeMax
     C                   Eval      C#lChargeAmt  = W#ChargeAmt

      * Fill routing information on charge
     C                   Eval      MoStdc = C#SChargeCode
     C                   Eval      MoStda = C#SChargeAmt
     C                   Eval      MoLvpc = C#lChargeCode
     C                   Eval      MoLvpa = C#lChargeAmt

      * If Account with bank same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoAcbr
     C                   Clear                   MoIntr
     C                   Endif

      * If Destination same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoDstr
     C                   Clear                   MoIntr
     C                   Endif
      * Test for STP and LVP Route
     C                   EXsr      SrSTProute


     C                   Eval      P0Rtn  = 'Route'
     C                   Endif


     C                   Endsl
      *
     C                   Endsl
      *
      *  Unwind subroutine stack name
      *
     C     ExAnalyse1    TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrNotFound1: Analyse Correspondent Record                    *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrNotfound1   BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrNotFound1' @STK(Q)
      *
     C                   Clear                   DsTopSTPCorr
      *  What has been input, Pay Through? Beneficiary Bank or Country
      *
     C                   Select
     C                   When      MoPthr <> *blanks
      *
      *  Check for specific routing for Pay Through
     C                   Eval      Lv1McBicc = %subst(MoPthr:1:8)
     C                   Eval      Lv1McBicb = %subst(MoPthr:9:3)
     C                   Eval      Lv1McPccy = MoPccy

      * Check for direct send
     C                   If        Lv1SwAut = *blanks
     C                   Eval      O2SBicc = %subst(MoPthr:1:8)
     C                   Exsr      SrCheckSWAUTN
      * Direct send allowed, continue
     C                   If        W#DirectSW = 'Y'
     C                   Eval      Lv1DirectSW = W#DirectSW
     C                   Else
     C                   Eval      Lv1DirectSW = W#DirectSW
     C                   Eval      Lv1Swaut = '*Indir'
     C                   Endif
     C                   Endif

      *
     C                   If        Lv1Swaut = *blanks
     C                   Eval      Lv1McCtyp = 'SWIFTKEY'
     C                   Else
     C                   Eval      Lv1McCtyp = 'BENEF'
     C                   Endif
      *
     C                   Eval      DsSTPCorr = DsTopSTPCorr
      *
      *  Generic routing for BIC bank
     C                   Exsr      SrLkGenBic1
      *
      *
     C                   When      MoBenb <> *blanks
      *
      *  Check for specific routing for Pay Through
     C                   Eval      Lv1McBicc = %subst(MoBenb:1:8)
     C                   Eval      Lv1McBicb = %subst(MoBenb:9:3)
     C                   Eval      Lv1McPccy = MoPccy

      * Check for direct send
     C                   If        Lv1SwAut = *blanks
     C                   Eval      O2SBicc = %subst(MoPthr:1:8)
     C                   Exsr      SrCheckSWAUTN
      * Direct send allowed, continue
     C                   If        W#DirectSW = 'Y'
     C                   Eval      Lv1DirectSW = W#DirectSW
     C                   Else
     C                   Eval      Lv1DirectSW = W#DirectSW
     C                   Eval      Lv1Swaut = '*Indir'
     C                   Endif
     C                   Endif

      * Change type depending on Authentication
     C                   If        Lv1Swaut = *blanks
     C                   Eval      Lv1McCtyp = 'SWIFTKEY'
     C                   Else
     C                   Eval      Lv1McCtyp = 'BENEF'
     C                   Endif
      *
     C                   Eval      DsSTPCorr = DsTopSTPCorr
      *
      *  Generic routing for BIC bank
     C                   Exsr      SrLkGenBic1
      *
      *
     C                   When      MoBenc <> *blanks
      *
     C                   Endsl
      *
      *  Try Re-Routes
      *
     C                   If        P0Rtn  <> 'Route'
      *
      *  Look for re-routes for this BIC
     C                   Exsr      SrLkRrtBic1
      *
     C                   Endif
      *
      *
      *  Unwind subroutine stack name
      *
     C     ExNotFound1   TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrLkUpAcct1: Look Up Account 1                               *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrLkUpAcct1   BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrLkUpAcct1' @STK(Q)
      *
      *  Clear data occurs if correspondent data
     C     1             Do        20            ####P             5 0
     C     ####P         Occur     DsLv1PayCorr
     C                   Clear                   DsLv1PayCorr
     C     ####P         Occur     DsLv1PayCord
     C                   Clear                   DsLv1PayCord
     C     ####P         Occur     DsLv1Route
     C                   Clear                   DsLv1Route
     C     ####P         Occur     DsChargeDet
     C                   Clear                   DsChargeDet
     C                   Enddo
      *
      *  Check to see if routing for BENEF with Account Type
     C                   Eval      MpBicc = McBicc
     C                   Eval      MpBicb = McBicb
     C                   Eval      MpPccy = MoPccy
      * Reset pointer
     C                   Clear                   ####P
      *
     C**** KMscpV1p      Setll     @MscpV1                                                    PNL014
     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
                                                                                              PNL014
      * Position with route sequence then read equal without                                  PNL014
     C                   Clear                   MpRtSq                                       PNL014
     C     KMscpV2p      Setll     @MscpV2                                                    PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On

                                                                                              PNL014
      * Check correspondent time related information                                          PNL014
     C                   If        W#Valid = 'Y'                                              PNL014
     C                   Exsr      SrPayTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   Exsr      SrPayDat1
     C                   If        W#Valid = 'Y'
     C                   Exsr      SrPayCopt
     C                   Endif
     C                   If        W#Valid <> 'Y'
     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   Iter
     C                   Endif
      *
      *  Check Correspondent Type, if Account do Routing
     C                   Eval      McBicc = MpCbic
     C                   Eval      McBicb = MpCbib
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

      * Check for Swift key
     C                   Eval      O2SBicc = MpCbic
     C                   Eval      O2SBicb = MpCbib
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat

     C                   Exsr      SrCorDate

     C                   If        W#Valid = 'Y' and McCtyp = 'ACCOUNT'
     C                             or
     C                             O2Rtn = *blanks and MpC53a <> *blanks
      *
      *
     C                   Eval      ####P = ####P + 1
     C     ####P         Occur     DsLv1PayCorr
     C     ####P         Occur     DsLv1PayCord
     C     ####P         Occur     DsLv1Route
     C     ####P         Occur     DsChargeDet
      *
      *  Return information
     C                   Clear                   MoDmac
     C                   Clear                   MoSncr
     C                   Clear                   MoCthr
     C                   Clear                   MoSett
     C                   Clear                   MoIntr
     C                   Eval      MoRccr = MpC54c + MpC54b
     C                   Eval      MoDstr = MpCbic + MpCbib

     C                   Select
      * If correspondent with special routing
     C                   When      W#Valid = 'N' and O2Rtn = *blanks
     C                   Eval      MoDstr = MpCBic + MpCbib
     C                   Eval      MoSett = MpStmt
      * If LVP and serial then leave
     C                   When      McLVPa = 'Y' and McLVPt > MoPYAM
     C                             and MpSLvp = 'Y' and W#Valid = 'Y'
     C                   Eval      MoSett = McStmt
      * If SWIFT Authentication then send to bank with cover
     C                   When      Lv1Swaut = *blanks and MpSerp <> 'Y'
     C                   Eval      MoDstr = Lv1McBicc + Lv1McBicb
                                                                                              PNL015
      * If send via head office and identified then swap                                      PNL015
     C                   If        MpRhob = 'Y' and Lv1HeadOffice <> *blanks                  PNL015
     C                             and Lv1HeadSwaut = *blanks                                 PNL015
     C                   Eval      MoDstr = Lv1HeadOffice                                     PNL015
     C                   Endif                                                                PNL015
                                                                                              PNL015
     C                   Eval      MoSett = MpStmt

      * If correspondent with special routing
     C                   When      W#Valid = 'Y' and O2Rtn = *blanks
     C                   Eval      MoDstr = MpCBic + MpCbib
     C                   Eval      MoSett = MpStmt

      * Default to account settlement method
     C                   If        McCtyp = 'ACCOUNT' and W#Valid = 'Y'
     C                             and MoSett = *blanks
     C                   Eval      MoSett = McStmt
     C                   Endif
     C                   Endsl

     C                   Eval      MoIntr = MpC56c + MpC56b
     C                   Eval      MoAcbr = MoBenb
     C                   Eval      Mor910 = Mpr910
     C                   Eval      MoCvrr = MpC53r
     C                   Eval      MoCthr = MpC53a
      *
      *  Extract account information
     C                   Clear                   MoSncr
     C                   If        MoCthr <> *blanks
     C                   Eval      W0Account = MoCthr
     C                   Exsr      SrAccount
     C                   Eval      MpC53C = %subst(BBCSID:1:8)                  FI
     C                   Eval      MpC53B = %subst(BBCSID:9:3)                  FI

      * If blank set to XXX
     C                   If        MpC53B = *blanks and MpC53c <> *blanks
     C                   Eval      MpC53B = 'XXX'
     C                   Endif
     C                   Eval      MoSncr = MpC53c + MpC53b
     C                   Else
      * Cover required ?
     C                   Eval      W0Account = McDacr
     C                   Eval      MoCthr = McDacr
     C                   Exsr      SrAccount

      * Same bank same country
     C                   If        %subst(MoDstr:1:6) = %subst(BBCsid:1:6)
     C                             or Lv1Swaut <> *blanks
     C                   Eval      MoDmac    = McDacr
     C                   Eval      MoDstr = MpCbic + MpCbib
     C                   Eval      MoDmac    = McDacr
     C                   Eval      MoCthr    = *blanks
     C                   Eval      Mor910 = 'N'
     C                   Eval      MoCvrr = 'N'
     C                   Eval      MoSncr = *blanks
     C                   Else

      * Different

     C                   Eval      MpC53C = %subst(BBCSID:1:8)                  FI
     C                   Eval      MpC53B = %subst(BBCSID:9:3)                  FI

      * If blank set to XXX
     C                   If        MpC53B = *blanks and MpC53c <> *blanks
     C                   Eval      MpC53B = 'XXX'
     C                   Endif
     C                   Eval      MoSncr = MpC53c + MpC53b

     C                   Eval      MoRccr = '?'

      * If routed then identify receiver's correspondent
     C                   If        MoRccr = '?'
     C                   Exsr      SrRecCorr
     C                   Endif

     C                   If        Mcr910 <> 'Y'
     C                   Eval      Mor910 = 'N'
     C                   Eval      MoCvrr = 'Y'
     C                   Else
     C                   Eval      Mor910 = 'Y'
     C                   Eval      MoCvrr = 'N'
     C                   Endif

     C                   Endif
     C                   Endif

      * Increment preferential figures
     C                   If        Lv1McPcor = 'Y' and MpPcor ='Y'
     C******             Eval      MpPnbr = MpPnbr + 1
     C                   Endif

      * Calculate charge for route
     C                   If        MpSchc <> *blanks or MpSchr <> 0
     C                   Eval      W#ChargeCode = MpSchc
     C                   Eval      W#ChargeRate = MpSchr
     C                   Eval      W#ChargeMin  = MpSchh
     C                   Eval      W#ChargeMax  = MpSchl
     C                   Else
     C                   Eval      W#ChargeCode = McSchc
     C                   Eval      W#ChargeRate = McSchr
     C                   Eval      W#ChargeMin  = McSchh
     C                   Eval      W#ChargeMax  = McSchl
     C                   Endif
     C                   Exsr      SrCharge
     C                   Eval      C#SChargeCode = W#ChargeCode
     C                   Eval      C#SChargeRate = W#ChargeRate
     C                   Eval      C#SChargeMin  = W#ChargeMin
     C                   Eval      C#SChargeMax  = W#ChargeMax
     C                   Eval      C#SChargeAmt  = W#ChargeAmt

     C                   Eval      W#ChargeCode = Mclchc
     C                   Eval      W#ChargeRate = Mclchr
     C                   Eval      W#ChargeMin  = Mclchh
     C                   Eval      W#ChargeMax  = Mclchl
     C                   Exsr      SrCharge
     C                   Eval      C#lChargeCode = W#ChargeCode
     C                   Eval      C#lChargeRate = W#ChargeRate
     C                   Eval      C#lChargeMin  = W#ChargeMin
     C                   Eval      C#lChargeMax  = W#ChargeMax
     C                   Eval      C#lChargeAmt  = W#ChargeAmt

      * Fill routing information on charge
     C                   Eval      MoStdc = C#SChargeCode
     C                   Eval      MoStda = C#SChargeAmt
     C                   Eval      MoLvpc = C#lChargeCode
     C                   Eval      MoLvpa = C#lChargeAmt

     C                   Select
      * If LVP Check
     C                   When      McLVPa = 'Y' and McLVPt > MoPYAM
     C                             and MpSLvp = 'Y'

      * Test for convention
     C                   Clear                   W#Convention
     C                   If        W#Valid = 'Y'
     C                   Clear                   W#CompConv

      * Set up convention to check
     C                   Eval      W#CompConv = McQ71a

     C                   Exsr      SrConvention
     C                   Endif

      * Set flags
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'N'
     C                   Eval      RouteLVP = 'Y'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'

      * If Account with bank same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoAcbr
     C                   Clear                   MoIntr
     C                   Endif

      * If Destination same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoDstr
     C                   Clear                   MoIntr
     C                   Endif

     C                   Exsr      SrSTProute

      * IF not LVP switch off and loop
     C                   If        MoLVPF <> 'Y' or W#Valid = 'N'
     C                             and McLVPA = 'Y'
     C                             Or W#Convention <> 'Ok'
     C                   Eval      McLVPa = 'N'
     C     ####P         Occur     DsLv1PayCorr
     C                   Clear                   DsLv1PayCorr
     C     ####P         Occur     DsLv1PayCord
     C                   Clear                   DsLv1PayCord
     C     ####P         Occur     DsLv1Route
     C                   Clear                   DsLv1Route
     C     ####P         Occur     DsChargeDet
     C                   Clear                   DsChargeDet
     C                   Eval      ####P = ####P - 1
     C                   Iter
     C                   Endif
     C                   Other

      * Test for STP
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'Y'
     C                   Eval      RouteLVP = 'N'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'

      * If Account with bank same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoAcbr
     C                   Clear                   MoIntr
     C                   Endif

      * If Destination same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoDstr
     C                   Clear                   MoIntr
     C                   Endif
     C                   Exsr      SrSTProute
     C                   Endsl

      * Check Payment convention and Amounts if not LVP
     C                   If        MoLVPF <> 'Y' and McLVPa = 'Y'
     C                             Or W#Valid = 'N' and McLVPA <> 'Y'
     C                   Exsr      SrCheckPay1
     C                   Endif

      * Only proceed if Ok
     C                   If        W#Valid = 'Y'

     C                   Eval      P0Rtn  = 'Route'
     C                   Eval      DsLv1PayCorr = DsPayCorr
     C                   Eval      DsLv1PayCord = DsSTPCorr
     C                   Eval      DsLv1Route = MROTDS

     C                   Else
     C     ####P         Occur     DsLv1PayCorr
     C                   Clear                   DsLv1PayCorr
     C     ####P         Occur     DsLv1PayCord
     C                   Clear                   DsLv1PayCord
     C     ####P         Occur     DsLv1Route
     C                   Clear                   DsLv1Route
     C     ####P         Occur     DsChargeDet
     C                   Clear                   DsChargeDet
     C                   Eval      ####P = ####P - 1
     C                   Endif

     C                   Endif

     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   Enddo
     C                   Endif
      *
      * If not route exit
     C                   If        P0Rtn  <> 'Route'
     C                   Goto      ExLkUpAcct1
     C                   Endif
      *
     C                   Eval      W#Select = 'N'

      * Set to first route found
     C     1             Occur     DsLv1PayCorr
     C     1             Occur     DsLv1PayCord
     C     1             Occur     DsLv1Route
     C     1             Occur     DsChargeDet
     C                   Eval      DsPayCorr    = DsLv1PayCorr
     C                   Eval      DsSTPCorr    = DsLv1PayCord
     C                   Eval      MROTDS       = DsLv1Route
      *
      *  Check for LVP Agreement and preferential routing
      *
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv1PayCorr
     C     ####S         Occur     DsLv1PayCord
     C     ####S         Occur     DsLv1Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lc1McLVPa = 'Y' and Lc1McLVPt > MoPYAM
     C                             and Lv1McPcor = 'Y'  and Lv1MpPcor = 'Y'
      *
     C                   Eval      W#Lv1McPnbr =   Lv1McPnbr

      * Set to 1 if 0
     C                   If        W#Lv1McPnbr = 0
     C                   Eval      W#Lv1McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv1MpPnbr / W#Lv1McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv1MpPpct + 1)
     C                   Eval      DsPayCorr   =   DsLv1PayCorr
     C                   Eval      MROTDS      =   DsLv1Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PCOR = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Eval      P2PLvp = 'Y'
     C                   Leave
     C                   Endif
     C                   Endif

     C                   Enddo
      *
      *  Check for LVP Agreement routing
      *
     C                   If        W#Select <> 'Y'
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv1PayCorr
     C     ####S         Occur     DsLv1PayCord
     C     ####S         Occur     DsLv1Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lc1McLVPa = 'Y' and Lc1McLVPt > MoPYAM
      *
     C                   Eval      DsPayCorr   =   DsLv1PayCorr
     C                   Eval      MROTDS      =   DsLv1Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PCOR = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif

     C                   Enddo
     C                   Endif
      *
      *  If route found and Low preferential correspondent then select route
      *
     C                   If        W#Select <> 'Y' and
     C                             Lv1McSpCr = 'Y' and
     C                             Lv1McSpTh >= MoPYAM
      * Set selected to N
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv1PayCorr
     C     ####S         Occur     DsLv1PayCord
     C     ####S         Occur     DsLv1Route
     C     ####S         Occur     DsChargeDet

      * BEN Payments
     C                   If        Lv1MpPbCr = 'Y'
      *                  Calculate percentage, if less leave
     C                   Eval      W#Lv1McPnbr =   Lv1McSpBn

      * Set to 1 if 0
     C                   If        W#Lv1McPnbr = 0
     C                   Eval      W#Lv1McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv1MpPbnb / W#Lv1McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv1MpPbPt + 1)
     C                             Or Lv1MpPbPt = 0
     C                   Eval      DsPayCorr   =   DsLv1PayCorr
     C                   Eval      MROTDS      =   DsLv1Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PLBen = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif
     C                   Endif

      * SHA Payments
     C                   If        Lv1MpPsCr = 'Y'
      *                  Calculate percentage, if less leave
     C                   Eval      W#Lv1McPnbr =   Lv1McSpSn

      * Set to 1 if 0
     C                   If        W#Lv1McPnbr = 0
     C                   Eval      W#Lv1McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv1MpPSnb / W#Lv1McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv1MpPsPt + 1)
     C                             Or Lv1MpPsPt = 0
     C                   Eval      DsPayCorr   =   DsLv1PayCorr
     C                   Eval      MROTDS      =   DsLv1Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PLSha = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif
     C                   Endif

      * OUR Payments
     C                   If        Lv1MpPoCr = 'Y'
      *                  Calculate percentage, if less leave
     C                   Eval      W#Lv1McPnbr =   Lv1McSpOn

      * Set to 1 if 0
     C                   If        W#Lv1McPnbr = 0
     C                   Eval      W#Lv1McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv1MpPOnb / W#Lv1McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv1MpPoPt + 1)
     C                             Or Lv1MpPoPt = 0
     C                   Eval      DsPayCorr   =   DsLv1PayCorr
     C                   Eval      MROTDS      =   DsLv1Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PLOur = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif
     C                   Endif

     C                   Enddo
     C                   Endif
      *
      *  If route found and preferential correspondent then select route
      *
     C                   If        Lv1McPcor = 'Y' and W#Select <> 'Y'
      * Set selected to N
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv1PayCorr
     C     ####S         Occur     DsLv1PayCord
     C     ####S         Occur     DsLv1Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lv1MpPcor = 'Y'
      * Calculate percentage, if less leave
     C                   Eval      W#Lv1McPnbr =   Lv1McPnbr

      * Set to 1 if 0
     C                   If        W#Lv1McPnbr = 0
     C                   Eval      W#Lv1McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv1MpPnbr / W#Lv1McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv1MpPpct + 1)
     C                   Eval      DsPayCorr   =   DsLv1PayCorr
     C                   Eval      MROTDS      =   DsLv1Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PCOR = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif
     C                   Endif

     C                   Enddo

      * If not selected then
     C                   If        W#Select <> 'Y'
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv1PayCorr
     C     ####S         Occur     DsLv1PayCord
     C     ####S         Occur     DsLv1Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lv1MpPcor <> 'Y'
     C                   Eval      DsPayCorr   =   DsLv1PayCorr
     C                   Eval      MROTDS      =   DsLv1Route
     C                   Eval      W#Select = 'Y'
     C                   Leave
     C                   Endif
     C                   Enddo

     C                   Endif

     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExLkUpAcct1   TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrLkGenBic1 :Look Up Generic Routing                         *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrLkGenBic1   BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrLkGenBic1' @STK(Q)
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = Lv1McBicc
     C                   Eval      McPccy = MoPccy
      *
      *  Check generics
      *
     C     1             DO        3             W#loop            4 0
      *
      * Select search criteria
     C                   Select
     C                   When      W#loop = 1
      *
      * Now try a generic branch
     C                   Eval      McBicb = '???'
     C     KMsccV1       Chain     @MsccV1
      *
      * Now try a generic location / branch
     C                   When      W#loop = 2
     C                   Eval      %subst(McBicc:7:2) = '??'
     C     KMsccV1       Chain     @MsccV1
      *
      * Now try a generic country / location / branch
     C                   When      W#loop = 3
     C                   Eval      %subst(McBicc:5:2) = '??'
     C     KMsccV1       Chain     @MsccV1
     C                   Endsl

     C                   If        %Found
     C                   Exsr      SrCorDate
                                                                                              PNL014
      * Check correspondent time related information                                          PNL014
     C                   If        W#Valid = 'Y'                                              PNL014
     C                   Exsr      SrCorTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014

     C                   If        W#Valid = 'Y'

      * Check for Account Routing
     C                   Exsr      SrLkUpAcct1
     C                   Endif
      *
     C                   If        P0Rtn  = 'Route'
     C                   Leave
     C                   Endif
      *
     C                   Endif
     C                   Enddo
      *
      *  Unwind subroutine stack name
      *
     C     ExLkGenBic1   TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrLkRrtBic1 :Look Up Re-Route BICs                           *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrLkRrtBic1   BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrLkRrtBic1' @STK(Q)
      *
      *  Check what type of beneficiary's attached to beneficiary
      *
     C     1             DO        5             W#loop            4 0
      *
      * Select search criteria
     C                   Select
      *
      *  Specific BIC
      *
     C                   When      W#loop = 1
     C                   Eval      MrrBic = Lv1McBicc
     C                   Eval      MrrBib = Lv1McBicb
     C                   Eval      MrPccy = MoPccy
      *
      * Now try a generic re-route
     C                   When      W#loop = 2
     C                   Eval      MrrBic = Lv1McBicc
     C                   Eval      MrrBib = '???'
     C                   Eval      MrPccy = MoPccy
      *
      * Now try a generic re-route for bic/country
     C                   When      W#loop = 3
     C                   Eval      MrrBic = Lv1McBicc
     C                   Eval      %Subst(MrrBic:7:2) = '??'
     C                   Eval      MrrBib = '???'
     C                   Eval      MrPccy = MoPccy
      *
      * Now try a generic re-route for Bic bank only
     C                   When      W#loop = 4
     C                   Eval      MrrBic = Lv1McBicc
     C                   Eval      %Subst(MrrBic:5:4) = '????'
     C                   Eval      MrrBib = '???'
     C                   Eval      MrPccy = MoPccy
      *
      * Now try a generic re-route for country only
     C                   When      W#loop = 5
     C                   Eval      MrrBic = Lv1McBicc
     C                   Eval      %Subst(MrrBic:7:2) = '??'
     C                   Eval      %Subst(MrrBic:1:4) = '????'
     C                   Eval      MrrBib = '???'
     C                   Eval      MrPccy = MoPccy
      *
     C                   Endsl
      *
     C     KMscrV2       Setll     @MscrV2
     C     KMscrV2       Reade     @MscrV2                                90
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On
      *
      * Check dates
     C                   Exsr      SrRrtDat1
     C                   If        W#Valid = 'Y'
      * Check convention and amounts
     C                   Exsr      SrRrtCopt
     C                   Endif
     C                   If        W#Valid = 'Y'
      *
      *  Look for re-routes for this BIC
     C                   Exsr      SrLkRrtMap1
      *
     C                   If        P0Rtn  = 'Route'
     C                   Leave
     C                   Endif
     C                   Endif

     C     KMscrV2       Reade     @MscrV2                                90
     C                   Enddo
     C                   Endif
      *
      * Leave if Route found
     C                   If        P0Rtn  = 'Route'
     C                   Leave
     C                   Endif
      *
     C                   Enddo
      *
      *  Unwind subroutine stack name
      *
     C     ExLkRrtBic1   TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrLkRrtMap1 :Maps Up Re-Route BICs                           *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrLkRrtMap1   BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrLkRrtMap1' @STK(Q)
      *
      * Save top information
     C                   Eval      DsRr1STPCorr = DsTopSTPCorr
      *
     C                   Eval      Lv1RrtSwaut = *blanks
      *
      *  Check Correspondent Type, if Account do Routing
     C                   Eval      McBicc = MrBicc
     C                   Eval      McBicb = MrBicb
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

      *  Check for Authentication

     C                   Exsr      SrCorDate
                                                                                              PNL014
      * Check correspondent time related information                                          PNL014
     C                   If        W#Valid = 'Y'                                              PNL014
     C                   Exsr      SrCorTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   If        W#Valid = 'Y'

     C                   Exsr      SrCorCheck
     C                   Endif

     C                   If        W#Valid = 'Y'
      *
      *Reset top information
     C                   Eval      DsTopSTPCorr = DsSTPCorr
     C                   Eval      O2SBicc = McBicc
     C                   Eval      O2SBicb = McBicb
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat
      *
     C                   Eval      Lv1RrtSwaut = O2Rtn

      *  Routing depending on Account Type
     C                   Select
     C                   When      %Found and McCtyp = 'ACCOUNT'
      *
      *  Return information
      *
      * No Receiver yet
     C                   Clear                   MoDmac
     C                   Clear                   MoSncr
     C                   Clear                   MoCthr
     C                   Clear                   MoSett
     C                   Clear                   MoIntr
     C                   Eval      MoRccr = *blanks
      *
     C                   Select
      * If cover and Receiver has authentication
     C                   When      MrCovr = 'Y' and Lv1Swaut = *blanks
     C                   Eval      MoDstr = Rr1Mcbicc + Rr1MCbicb
      * If No cover and Account does not accept convention  EXIT
     C                   When      W#Convention <> 'Ok'
     C                   Goto      ExLkRrtMapX
      * If No cover and Account Ok then forward
     C                   Other
     C                   Eval      MoDstr = MrBicc + Mrbicb
     C                   Endsl
      *
      * If Receiver has No authentication
     C                   If        Lv1Swaut <> *blanks
     C                   Eval      MoIntr = Lv1Mcbicc + Lv1MCbicb
     C                   Endif
     C                   Eval      MoAcbr = MoBenb
      *
      * If Receiver is to be replaced
     C                   If        MrRplc = 'Y'
     C                   Eval      MoAcbr = MrBicc + Mrbicb
     C                   Endif
      *
      * If Receiver and Internediary the same, clear Intermediary
     C                   If        MoIntr = MoAcBr
     C                   Clear                   MoIntr
     C                   Endif
      *
      * If cover and Receiver has authentication
     C                   If        MrCovr = 'Y' and Lv1Swaut = *blanks
     C                   If        MrCflg <> 'N'
     C                   Eval      MoCvrr = 'Y'
     C                   Else
     C                   Eval      MoCvrr = 'N'
     C                   Eval      Mor910 = Mcr910
     C                   Endif
     C                   Eval      MoCthr = McDacr
      * Different
     C                   Eval      MoRccr = '?'
     C                   Else
     C                   Eval      MoCvrr = 'N'
     C                   Eval      MoSett = McStmt
     C                   Endif
      *
      *  Extract account information
     C                   Clear                   MoSncr
     C                   If        MoCthr <> *blanks
     C                   Eval      W0Account = MoCthr
     C                   Exsr      SrAccount
     C                   Eval      MpC53C = %subst(BBCSID:1:8)                  FI
     C                   Eval      MpC53B = %subst(BBCSID:9:3)                  FI

      * If blank set to XXX
     C                   If        MpC53B = *blanks and MpC53c <> *blanks
     C                   Eval      MpC53B = 'XXX'
     C                   Endif
     C                   Eval      MoSncr = MpC53c + MpC53b

      * Same bank same country
      ******
     C******             If        %subst(MoDstr:1:6) = %subst(BBCsid:1:6)
     C******             Eval      MoDmac    = McDacr
     C******             Eval      MoDstr = Lv1Mcbicc + Lv1MCbicb
     C******             Eval      MoDmac    = McDacr
     C******             Eval      MoSncr = *blanks
     C******             Eval      MoCthr    = *blanks
     C******             Eval      MoCvrr = 'N'
     C******             Endif

     C                   Else
     C                   Eval      W0Account = McDacr
     C                   Exsr      SrAccount
     C                   Eval      MoDmac    = McDacr
     C                   Endif

      * If routed then identify receiver's correspondent
     C                   If        MoRccr = '?'
     C                   Exsr      SrRecCorr
     C                   Endif

      * Set up route allowed
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'N'
     C                   Eval      RouteLVP = 'Y'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'
      * Check Payment convention and Amounts - LVP
     C                   Exsr      SrCheckPay3

      * Test for STP and LVP Route
     C                   If        W#Valid = 'Y'

      * If Account with bank same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoAcbr
     C                   Clear                   MoIntr
     C                   Endif

      * If Destination same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoDstr
     C                   Clear                   MoIntr
     C                   Endif
     C                   Exsr      SrSTProute
     C                   Endif

     C                   Select
     C                   When      W#Valid = 'Y' and MoLVPF <> 'Y'
     C                             Or
     C                             W#Valid = 'N'
      * Set up route allowed
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'Y'
     C                   Eval      RouteLVP = 'N'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'
      * Check Payment convention and Amounts - LVP
     C                   Exsr      SrCheckPay3
     C                   If        W#Valid = 'Y'
     C                   Eval      MoLVPF = 'N'
     C                   Eval      P0Rtn  = 'Route'
     C                   Endif
     C                   When      W#Valid = 'Y' and MoLVPF = 'Y'
      * LVP route

     C                   Eval      P0Rtn  = 'Route'
     C                   Endsl

      * SWIFTKey rounting
     C                   When      %Found and McCtyp <> 'ACCOUNT'
     C                             and Lv1RrtSwaut = *blanks

      * If replace BIC then overwrite beneficiary bank
     C                   If        MrRplc = 'Y'
     C                   Eval      Mobenb = MrBicc + MrBicb
     C                   Endif

     C                   Exsr      SrAnalyse1
      * Benef rounting
     C                   When      %Found and McCtyp <> 'ACCOUNT'
     C                             and Lv1RrtSwaut <> *blanks

      * If replace BIC then overwrite beneficiary bank
     C                   If        MrRplc = 'Y'
     C                   Eval      Mobenb = MrBicc + MrBicb
     C                   Endif

     C                   Exsr      SrAnalyse1
     C                   Endsl
     C                   Endif
      *
     C     ExLkRrtMapX   TAG
      *
      * Restore top information
     C                   Eval      Mobenb = Lv1Benb
     C                   Eval      DsTopSTPCorr = DsRr1STPCorr
     C                   Clear                   DsRr1STPCorr
      *
      *  Unwind subroutine stack name
      *
     C     ExLkRrtMap1   TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrLevel2 :  :Maps Up Re-Route BICs                           *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrLevel2      BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrLevel2   ' @STK(Q)
      *
      *  Check what type of beneficiary's attached to beneficiary
      *
     C     1             DO        3             W#loop            4 0
      *
     C                   Clear                   DsNxtStpCorr
      *
      * Select search criteria
     C                   Select
     C                   When      W#loop = 1
      *
      *  Check Correspondent Type, if Account do Routing
     C                   Eval      NxtMcBicc = Lv1McBicc
     C                   Eval      NxtMcBicb = Lv1McBicb
     C                   Eval      NxtMcPccy = Lv1McPccy
      *
     C                   When      W#loop = 2
      *
      *  Check Correspondent Type, if Account do Routing
     C                   Eval      NxtMcBicc = Lv1McBicc
     C                   Eval      NxtMcBicb = '???'
     C                   Eval      NxtMcPccy = Lv1McPccy
      *
     C                   When      W#loop = 3
      *
      *  Check Correspondent Type, if Account do Routing
     C                   Eval      NxtMcBicc = Lv1McBicc
     C                   Eval      %subst(NxtMcBicc:7:2) = '??'
     C                   Eval      NxtMcBicb = '???'
     C                   Eval      NxtMcPccy = Lv1McPccy
      *
     C                   When      W#loop = 4
      *
      *  Check Correspondent Type, if Account do Routing
     C                   Eval      NxtMcBicc = Lv1McBicc
     C                   Eval      %subst(NxtMcBicc:7:2) = '??'
     C                   Eval      %subst(NxtMcBicc:1:4) = '????'
     C                   Eval      NxtMcBicb = '???'
     C                   Eval      NxtMcPccy = Lv1McPccy
      *
     C                   Endsl
      *
      * Check for routing
     C                   Exsr      SrAnalyse2
      *
      * Leave if Route found
     C                   If        P0Rtn  = 'Route'
     C                   Leave
     C                   Endif
      *
     C                   Enddo

      * Still no routing so now check for LVP Routing
     C                   If        P0Rtn  <> 'Route'
     C                   Exsr      SrLVP

      * Still no routing so now check for currency country re-route
     C                   If        P0Rtn  <> 'Route'
      *
      * Get currency country re-direction
     C                   Exsr      SrReDirect2

     C                   Endif
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExLevel2      TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrAnalyse2: Analyse Correspondent Record                     *
      *                                                               *
      *  CALLED BY: SrLevel2                                          *
      *                                                               *
      *****************************************************************
     CSR   SrAnalyse2    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrAnalyse2'  @STK(Q)
      *
      * See if Correspondent exists
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = NxtMcBicc
     C                   Eval      McBicb = NxtMcBicb
     C                   Eval      McPccy = NxtMcPccy
      *
     C     KMsccV1       Chain     @MsccV1

     C                   Exsr      SrCorDate
                                                                                              PNL014
      * Check correspondent time related information                                          PNL014
     C                   If        W#Valid = 'Y'                                              PNL014
     C                   Exsr      SrCorTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014

     C                   If        W#Valid = 'Y'

     C                   Exsr      SrCorCheck

      * Check for direct send
     C                   If        W#Valid = 'Y' and Lv1SwAut = *blanks
     C                   Eval      O2SBicc = %subst(McBicc:1:8)
     C                   Exsr      SrCheckSWAUT
      * Direct send allowed, continue
     C                   If        W#DirectSW = 'Y'
     C                   Eval      Lv2DirectSW = W#DirectSW
     C                   Else
     C                   Eval      Lv2DirectSW = W#DirectSW
     C                   Eval      W#Valid = 'N'
     C                   Endif
     C                   Endif

     C                   Endif

     C                   If        W#Valid = 'Y'
     C                   Eval      DsNxtSTPCorr = DsSTPCorr
      *
      * Check for beneficiary customer in currency
     C                   Exsr      SrPayThru2
      *
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExAnalyse2    TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrPayThru2: Look Through correspondents                      *
      *                                                               *
      *  CALLED BY: SrAnalyse2                                        *
      *                                                               *
      *****************************************************************
     CSR   SrPayThru2    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrPayThru2'  @STK(Q)
      *
      *  Read through correspondents and test for SWIFT Key
      *
      *
      *  Check to see if routing for BENEF with Account Type
     C                   Eval      MpBicc = NxtMcBicc
     C                   Eval      MpBicb = NxtMcBicb
     C                   Eval      MpPccy = NxtMcPccy
      *
     C**** KMscpV1p      Setll     @MscpV1                                                    PNL014
     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
                                                                                              PNL014
      * Position with route sequence then read equal without                                  PNL014
     C                   Clear                   MpRtSq                                       PNL014
     C     KMscpV2p      Setll     @MscpV2                                                    PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On
      *
     C                   Exsr      SrPayDat1
                                                                                              PNL014
      * Check correspondent time related information                                          PNL014
     C                   If        W#Valid = 'Y'                                              PNL014
     C                   Exsr      SrPayTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   If        W#Valid = 'Y'
     C                   Exsr      SrPayCopt
     C                   Endif
     C                   If        W#Valid <> 'Y'
     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   Iter
     C                   Endif

      * Check for authentication key
     C                   Clear                   DsLevel2
     C                   Clear                   DsLv2STPCorr
      *
      *  Check for specific routing for Pay Through
     C                   Eval      O2SBicc = MpCBic
     C                   Eval      O2SBicb = MpCBib
      *
     C                   Call      'FTP0700'
     C                   Parm                    O2RTN             7
     C                   Parm                    O2Parm                         Incoming dat
      *
     C                   Eval      Lv2Swaut = O2Rtn

      *
      * SWIFT Authentication found try routing
     C                   If        Lv2SwAut = *blanks
      *
      * Get Correspondent details
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = MpCBic
     C                   Eval      McBicb = MpCBib
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

     C                   Exsr      SrCorDate
                                                                                              PNL014
      * Check correspondent time related information                                          PNL014
     C                   If        W#Valid = 'Y'                                              PNL014
     C                   Exsr      SrCorTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   If        W#Valid = 'Y'

     C                   Exsr      SrCorCheck

      * Check for direct send
     C                   If        W#Valid = 'Y' and Lv1SwAut = *blanks
     C                   Eval      O2SBicc = %subst(McBicc:1:8)
     C                   Exsr      SrCheckSWAUT
      * Direct send allowed, continue
     C                   If        W#DirectSW = 'Y'
     C                   Eval      Lv2DirectSW = W#DirectSW
     C                   Else
     C                   Eval      Lv2DirectSW = W#DirectSW
     C                   Eval      W#Valid = 'N'
     C                   Endif
     C                   Endif

     C                   If        W#Valid = 'Y'
     C                   Eval      DsLv2STPCorr = DsSTPCorr
     C                   Else
     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   Iter
     C                   Endif

     C                   Else

      * Check for direct send
     C                   Eval      O2SBicc = %subst(MpCBic:1:8)
     C                   Exsr      SrCheckSWAUTN
      * Direct send allowed, continue
     C                   If        W#DirectSW = 'Y'
     C                   Eval      Lv2DirectSW = W#DirectSW
     C                   Else

      * Inhibited routing, read next
     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   Iter
     C                   Endif


      * Not found Set basic details
     C                   Eval      Lv2McBicc = MpCBic
     C                   Eval      Lv2McBicb = MpCBib
     C                   Eval      Lv2McPccy = MoPccy
     C                   Endif
      *
      * Check for payment routing
     C                   Exsr      SrRoute2
     C                   Endif

     C                   If        P0Rtn  = 'Route'
     C                   Eval      P0Rtn  = 'Route'
     C                   Leave

     C                   Endif

     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   Enddo
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExPayThru2    TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrRoute2  : Create routing for Correspondent BIC             *
      *                                                               *
      *  CALLED BY: SrAnalyse2                                        *
      *                                                               *
      *****************************************************************
     CSR   SrRoute2      BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrRoute2  '  @STK(Q)
      *
      *  Check to see if routing for ACCOUNT Bic
     C                   Eval      MpBicc = Lv2McBicc
     C                   Eval      MpBicb = Lv2McBicb
     C                   Eval      MpPccy = Lv2McPccy
     C                   Eval      MpCbic = Lv2McBicc
     C                   Eval      MpCbib = Lv2McBicb
      *
     C     KMscpV1       Chain     @MscpV1

     C                   Exsr      SrPayDate
                                                                                              PNL014
      * Check correspondent time related information                                          PNL014
     C                   If        W#Valid = 'Y'                                              PNL014
     C                   Exsr      SrPayTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   If        W#Valid = 'Y'
     C                   Exsr      SrPayCopt
     C                   Endif
     C                   If        W#Valid = 'Y'
      *
      *  Return information
     C                   Clear                   MoDmac
     C                   Clear                   MoSncr
     C                   Clear                   MoSett
     C                   Clear                   MoIntr
     C                   Eval      MoRccr = MpC54c + MpC54b
     C                   Eval      MoDstr = MpCbic + MpCbib
     C                   Eval      MoIntr = MpC56c + MpC56b
     C                   Eval      MoAcbr = MoBenb
     C                   Eval      MoCvrr = MpC53r
     C                   Eval      MoCthr = MpC53a
      *
      *  Extract account information
     C                   Clear                   MoSncr
     C                   If        MoCthr <> *blanks
     C                   Eval      W0Account = MoCthr
     C                   Exsr      SrAccount
     C                   Eval      MpC53C = %subst(BBCSID:1:8)                  FI
     C                   Eval      MpC53B = %subst(BBCSID:9:3)                  FI

      * If blank set to XXX
     C                   If        MpC53B = *blanks and MpC53c <> *blanks
     C                   Eval      MpC53B = 'XXX'
     C                   Endif
     C                   Eval      MoSncr = MpC53c + MpC53b
     C                   Else
     C                   Eval      W0Account = McDacr
     C                   Exsr      SrAccount
     C                   Eval      MoDmac    = McDacr
     C                   Endif

      * Set up route allowed
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'N'
     C                   Eval      RouteLVP = 'Y'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'
      * Check Payment convention and Amounts - LVP
     C                   Exsr      SrCheckPay3

      * Test for STP and LVP Route
     C                   If        W#Valid = 'Y'

      * If Account with bank same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoAcbr
     C                   Clear                   MoIntr
     C                   Endif

      * If Destination same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoDstr
     C                   Clear                   MoIntr
     C                   Endif
     C                   Exsr      SrSTProute
     C                   Endif

     C                   Select
     C                   When      W#Valid = 'Y' and MoLVPF <> 'Y'
     C                             Or
     C                             W#Valid = 'N'
      * Set up route allowed
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'Y'
     C                   Eval      RouteLVP = 'N'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'

      * Check Payment convention and Amounts - not LVP
     C                   Exsr      SrCheckPay3
     C                   If        W#Valid = 'Y'
     C                   Eval      MoLVPF = 'N'
     C                   Eval      P0Rtn  = 'Route'
     C                   Goto      ExRoute2
     C                   Endif
     C                   When      W#Valid = 'Y' and MoLVPF = 'Y'
      * LVP route

     C                   Eval      P0Rtn  = 'Route'
     C                   Goto      ExRoute2
     C                   Endsl

     C                   Endif
      *
      *  Clear data occurs if correspondent data
     C     1             Do        20            ####P             5 0
     C     ####P         Occur     DsLv2PayCorr
     C                   Clear                   DsLv2PayCorr
     C     ####P         Occur     DsLv2PayCord
     C                   Clear                   DsLv2PayCord
     C     ####P         Occur     DsLv2Route
     C                   Clear                   DsLv2Route
     C     ####P         Occur     DsChargeDet
     C                   Clear                   DsChargeDet
     C                   Enddo
      *
      *  Check to see if routing for BENEF with Account Type
     C                   Eval      MpBicc = Lv2McBicc
     C                   Eval      MpBicb = Lv2McBicb
     C                   Eval      MpPccy = Lv2McPccy
      * Reset pointer
     C                   Clear                   ####P
      *
     C**** KMscpV1p      Setll     @MscpV1                                                    PNL014
     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
                                                                                              PNL014
      * Position with route sequence then read equal without                                  PNL014
     C                   Clear                   MpRtSq                                       PNL014
     C     KMscpV2p      Setll     @MscpV2                                                    PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On
      *
     C                   Exsr      SrPayDat1
     C                   If        W#Valid = 'Y'
     C                   Exsr      SrPayCopt
     C                   Endif
     C                   If        W#Valid <> 'Y'
     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   Iter
     C                   Endif
      *
      *  Check Correspondent Type, if Account do Routing
     C                   Eval      McBicc = MpCbic
     C                   Eval      McBicb = MpCbib
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

     C                   Exsr      SrCorDate
     C                   If        W#Valid = 'Y' and McCtyp = 'ACCOUNT'
      *
     C                   Eval      ####P = ####P + 1
     C     ####P         Occur     DsLv2PayCorr
     C     ####P         Occur     DsLv2PayCord
     C     ####P         Occur     DsLv2Route
     C     ####P         Occur     DsChargeDet
      *
      *  Return information
     C                   Clear                   MoDmac
     C                   Clear                   MoSncr
     C                   Clear                   MoSett
     C                   Clear                   MoIntr
     C                   Eval      MoRccr = MpC54c + MpC54b

     C                   Select
      * If LVP and serial then leave
     C                   When      McLVPa = 'Y' and McLVPt > MoPYAM
     C                             and MpSLvp = 'Y'
      * If SWIFT Authentication then send to bank with cover
     C                   When      Lv1Swaut = *blanks and MpSerp <> 'Y'
     C                   Eval      MoDstr = Lv2McBicc + Lv2McBicb
     C                   Endsl

     C                   Eval      MoIntr = MpC56c + MpC56b
     C                   Eval      MoAcbr = MoBenb
     C                   Eval      MoCvrr = MpC53r
     C                   Eval      MoCthr = MpC53a
      *
      *  Extract account information
     C                   Clear                   MoSncr
     C                   If        MoCthr <> *blanks
     C                   Eval      W0Account = MoCthr
     C                   Exsr      SrAccount
     C                   Eval      MpC53C = %subst(BBCSID:1:8)                  FI
     C                   Eval      MpC53B = %subst(BBCSID:9:3)                  FI

      * If blank set to XXX
     C                   If        MpC53B = *blanks and MpC53c <> *blanks
     C                   Eval      MpC53B = 'XXX'
     C                   Endif
     C                   Eval      MoSncr = MpC53c + MpC53b
     C                   Else

      * Cover required ?
     C                   Eval      W0Account = McDacr
     C                   Eval      MoCthr = McDacr
     C                   Exsr      SrAccount

      * Same bank same country
     C                   If        %subst(MoDstr:1:6) = %subst(BBCsid:1:6)
     C                             or Lv1Swaut <> *blanks
     C                   Eval      MoDmac    = McDacr
     C                   Eval      MoDstr = MpCbic + MpCbib
     C                   Eval      MoCthr    = *blanks
     C                   Eval      MoCvrr = 'N'
     C                   Eval      MoSncr = *blanks
     C                   Else

      * Different

     C                   Eval      MpC53C = %subst(BBCSID:1:8)                  FI
     C                   Eval      MpC53B = %subst(BBCSID:9:3)                  FI

      * If blank set to XXX
     C                   If        MpC53B = *blanks and MpC53c <> *blanks
     C                   Eval      MpC53B = 'XXX'
     C                   Endif
     C                   Eval      MoSncr = MpC53c + MpC53b

     C                   Eval      MoRccr = '?'

      * If routed then identify receiver's correspondent
     C                   If        MoRccr = '?'
     C                   Exsr      SrRecCorr
     C                   Endif

     C                   Eval      MoCvrr = 'Y'
     C                   Endif
     C                   Endif

      * Increment preferential figures
     C                   If        Lv2McPcor = 'Y' and MpPcor ='Y'
     C*****              Eval      MpPnbr = MpPnbr + 1
     C                   Endif

      * Calculate charge for route
     C                   If        MpSchc <> *blanks or MpSchr <> 0
     C                   Eval      W#ChargeCode = MpSchc
     C                   Eval      W#ChargeRate = MpSchr
     C                   Eval      W#ChargeMin  = MpSchh
     C                   Eval      W#ChargeMax  = MpSchl
     C                   Else
     C                   Eval      W#ChargeCode = McSchc
     C                   Eval      W#ChargeRate = McSchr
     C                   Eval      W#ChargeMin  = McSchh
     C                   Eval      W#ChargeMax  = McSchl
     C                   Endif
     C                   Exsr      SrCharge
     C                   Eval      C#SChargeCode = W#ChargeCode
     C                   Eval      C#SChargeRate = W#ChargeRate
     C                   Eval      C#SChargeMin  = W#ChargeMin
     C                   Eval      C#SChargeMax  = W#ChargeMax
     C                   Eval      C#SChargeAmt  = W#ChargeAmt

     C                   Eval      W#ChargeCode = Mclchc
     C                   Eval      W#ChargeRate = Mclchr
     C                   Eval      W#ChargeMin  = Mclchh
     C                   Eval      W#ChargeMax  = Mclchl
     C                   Exsr      SrCharge
     C                   Eval      C#lChargeCode = W#ChargeCode
     C                   Eval      C#lChargeRate = W#ChargeRate
     C                   Eval      C#lChargeMin  = W#ChargeMin
     C                   Eval      C#lChargeMax  = W#ChargeMax
     C                   Eval      C#lChargeAmt  = W#ChargeAmt

      * Fill routing information on charge
     C                   Eval      MoStdc = C#SChargeCode
     C                   Eval      MoStda = C#SChargeAmt
     C                   Eval      MoLvpc = C#lChargeCode
     C                   Eval      MoLvpa = C#lChargeAmt

     C                   Select
      * If LVP Check
     C                   When      McLVPa = 'Y' and McLVPt > MoPYAM
     C                             and MpSLvp = 'Y'
      * Set up route allowed
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'N'
     C                   Eval      RouteLVP = 'Y'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'
      * Check Payment convention and Amounts - LVP
     C                   Exsr      SrCheckPay3

      * IF not LVP switch off and loop
     C                   If        MoLVPF <> 'Y'
     C                             and McLVPA = 'Y'
     C                   Eval      McLVPa = 'N'
     C                   Iter
     C                   Endif
     C                   Other
      * Test for STP Route
      * Set up route allowed
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'Y'
     C                   Eval      RouteLVP = 'N'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'

      * If Account with bank same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoAcbr
     C                   Clear                   MoIntr
     C                   Endif

      * If Destination same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoDstr
     C                   Clear                   MoIntr
     C                   Endif
     C                   Exsr      SrSTProute
     C                   Endsl

     C                   Eval      P0Rtn  = 'Route'
     C                   Eval      DsLv2PayCorr = DsPayCorr
     C                   Eval      DsLv2PayCord = DsSTPCorr
     C                   Eval      DsLv2Route = MROTDS

     C                   Endif

     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   Enddo
     C                   Endif
      *
      * If not route exit
     C                   If        P0Rtn  <> 'Route'
     C                   Goto      ExRoute2
     C                   Endif
      *
     C                   Eval      W#Select = 'N'

      * Set to first route found
     C     1             Occur     DsLv2PayCorr
     C     1             Occur     DsLv2PayCord
     C     1             Occur     DsLv2Route
     C                   Eval      DsPayCorr    = DsLv2PayCorr
     C                   Eval      DsSTPCorr    = DsLv2PayCord
     C                   Eval      MROTDS       = DsLv2Route
      *
      *  Check for LVP Agreement and preferential routing
      *
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv2PayCorr
     C     ####S         Occur     DsLv2PayCord
     C     ####S         Occur     DsLv2Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lc2McLVPa = 'Y' and Lc2McLVPt > MoPYAM
     C                             and Lv2McPcor = 'Y'  and Lv2MpPcor = 'Y'
      *
     C                   Eval      W#Lv2McPnbr =   Lv2McPnbr

      * Set to 1 if 0
     C                   If        W#Lv2McPnbr = 0
     C                   Eval      W#Lv2McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv2MpPnbr / W#Lv2McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv2MpPpct + 1)
     C                   Eval      DsPayCorr   =   DsLv2PayCorr
     C                   Eval      MROTDS      =   DsLv2Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PCOR = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Eval      P2PLvp = 'Y'
     C                   Leave
     C                   Endif
     C                   Endif

     C                   Enddo
      *
      *  Check for LVP Agreement routing
      *
     C                   If        W#Select <> 'Y'
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv2PayCorr
     C     ####S         Occur     DsLv2PayCord
     C     ####S         Occur     DsLv2Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lc2McLVPa = 'Y' and Lc2McLVPt > MoPYAM
      *
     C                   Eval      DsPayCorr   =   DsLv2PayCorr
     C                   Eval      MROTDS      =   DsLv2Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PCOR = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif

     C                   Enddo
     C                   Endif
      *
      *  If route found and Low preferential correspondent then select route
      *
     C                   If        W#Select <> 'Y' and
     C                             Lv2McSpCr = 'Y' and
     C                             Lv2McSpTh >= MoPYAM
      * Set selected to N
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv2PayCorr
     C     ####S         Occur     DsLv2PayCord
     C     ####S         Occur     DsLv2Route
     C     ####S         Occur     DsChargeDet

      * BEN Payments
     C                   If        Lv2MpPbCr = 'Y'
      *                  Calculate percentage, if less leave
     C                   Eval      W#Lv2McPnbr =   Lv2McSpBn

      * Set to 1 if 0
     C                   If        W#Lv2McPnbr = 0
     C                   Eval      W#Lv2McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv2MpPbnb / W#Lv2McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv2MpPbPt + 1)
     C                             Or Lv2MpPbPt = 0
     C                   Eval      DsPayCorr   =   DsLv2PayCorr
     C                   Eval      MROTDS      =   DsLv2Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PLBen = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif
     C                   Endif

      * SHA Payments
     C                   If        Lv2MpPsCr = 'Y'
      *                  Calculate percentage, if less leave
     C                   Eval      W#Lv2McPnbr =   Lv2McSpSn

      * Set to 1 if 0
     C                   If        W#Lv2McPnbr = 0
     C                   Eval      W#Lv2McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv2MpPSnb / W#Lv2McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv2MpPsPt + 1)
     C                             Or Lv2MpPsPt = 0
     C                   Eval      DsPayCorr   =   DsLv2PayCorr
     C                   Eval      MROTDS      =   DsLv2Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PLSha = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif
     C                   Endif

      * OUR Payments
     C                   If        Lv2MpPoCr = 'Y'
      *                  Calculate percentage, if less leave
     C                   Eval      W#Lv2McPnbr =   Lv2McSpOn

      * Set to 1 if 0
     C                   If        W#Lv2McPnbr = 0
     C                   Eval      W#Lv2McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv2MpPOnb / W#Lv2McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv2MpPoPt + 1)
     C                             Or Lv2MpPoPt = 0
     C                   Eval      DsPayCorr   =   DsLv2PayCorr
     C                   Eval      MROTDS      =   DsLv2Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PLOur = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif
     C                   Endif

     C                   Enddo
     C                   Endif
      *
      *  If route found and preferential correspondent then select route
      *
     C                   If        Lv2McPcor = 'Y' and W#Select <> 'Y'
      * Set selected to N
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv2PayCorr
     C     ####S         Occur     DsLv2PayCord
     C     ####S         Occur     DsLv2Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lv2MpPcor = 'Y'
      *                  Calculate percentage, if less leave
     C                   Eval      W#Lv2McPnbr =   Lv2McPnbr

      * Set to 1 if 0
     C                   If        W#Lv2McPnbr = 0
     C                   Eval      W#Lv2McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv2MpPnbr / W#Lv2McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv2MpPpct + 1)
     C                   Eval      DsPayCorr   =   DsLv2PayCorr
     C                   Eval      MROTDS      =   DsLv2Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PCOR = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif
     C                   Endif

     C                   Enddo

      * If not selected then
     C                   If        W#Select <> 'Y'
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv2PayCorr
     C     ####S         Occur     DsLv2PayCord
     C     ####S         Occur     DsLv2Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lv2MpPcor <> 'Y'
     C                   Eval      DsPayCorr   =   DsLv2PayCorr
     C                   Eval      MROTDS      =   DsLv2Route
     C                   Eval      W#Select = 'Y'
     C                   Leave
     C                   Endif
     C                   Enddo

     C                   Endif

     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExRoute2      TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrReDirect2 : Get currency country general                   *
      *                                                               *
      *  CALLED BY: SrAnalyse2                                        *
      *                                                               *
      *****************************************************************
     CSR   SrReDirect2   BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrReDirect2' @STK(Q)
      * Set up route allowed
     C                   If        RouteLvp <> 'Y'
     C                             and RouteReg <> 'Y'
     C                             and RouteOur <> 'Y'
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'Y'
     C                   Eval      RouteLVP = 'N'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'
     C                   Endif
      * Set up key
     C                   Eval      MdPccy = MoPccy
      *
     C                   Select
     C                   When      MoPthr <> *blanks
     C                   Eval      Lv3Benc = %subst(MoPthr:5:2)
     C                   When      BCtry  <> *blanks
     C                   Eval      Lv3Benc = BCtry                                            MM1705
     C                   When      MoBenb <> *blanks                                          MM1705
     C                   Eval      Lv3Benc = %subst(MoBenb:5:2)
     C                   Other
     C                   Eval      Lv3Benc = MoBenc
     C                   Endsl
      *
      *  Check for Generic routing for country currency
      *
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = '????' + Lv3Benc + '??'
     C                   Eval      McBicb = '???'
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

     C                   Exsr      SrCorDate
                                                                                              PNL014
      * Check correspondent time related information                                          PNL014
     C                   If        W#Valid = 'Y'                                              PNL014
     C                   Exsr      SrCorTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   If        W#Valid = 'Y'
     C                   Eval      DsLv3STPCorr = DsSTPCorr

      * Analyse routing
     C                   Exsr      SrAnalyse3
     C                   Endif

      * Still no routing so now check for currency country re-route
     C                   If        P0Rtn  <> 'Route'
      *
      * Get currency country re-direction
     C                   Exsr      SrReDirect3

     C                   Endif
      * Clear routing allowed
     C                   If        RouteLvp <> 'Y'
     C                             and RouteReg <> 'Y'
     C                             and RouteOur <> 'Y'
     C                   Clear                   RouteSet
     C                   Clear                   RouteGen
     C                   Clear                   RouteLVP
     C                   Clear                   RouteReg
     C                   Clear                   RouteOur
     C                   Clear                   RouteService
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExReDirect2   TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrReDirect3 : Get currency country redirection               *
      *                                                               *
      *  CALLED BY: SrAnalyse2                                        *
      *                                                               *
      *****************************************************************
     CSR   SrReDirect3   BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrReDirect3' @STK(Q)
      * Set up route allowed
     C                   If        RouteLvp <> 'Y'
     C                             and RouteReg <> 'Y'
     C                             and RouteOur <> 'Y'
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'Y'
     C                   Eval      RouteLVP = 'N'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'
     C                   Endif
      * Set up key
     C                   Eval      MdPccy = MoPccy
      *
     C                   Select
     C                   When      MoPthr <> *blanks
     C                   Eval      MDCtry = %subst(MoPthr:5:2)
     C                   When      BCtry  <> *blanks                                          MM1705
     C                   Eval      MDCtry = BCtry                                             MM1705
     C                   When      MoBenb <> *blanks
     C                   Eval      MDCtry = %subst(MoBenb:5:2)
     C                   Other
     C                   Eval      MDCtry = MoBenc
     C                   Endsl
      * Get details
     C     KMscyV1       Chain     @MSCYV1
     C                   If        Not %Found
     C                   Eval      MdPccy = '???'
     C     KMscyV1       Chain     @MSCYV1
     C                   Endif
     C                   If        Not %Found
     C                   Eval      MdPccy = MoPccy
     C                   Eval      MDCtry = '??'
     C     KMscyV1       Chain     @MSCYV1
     C                   Endif
     C                   If        Not %Found
     C                   Goto      ExReDirect3
     C                   Else
     C                   Eval      Lv3Benc = MdRDCT
     C                   Endif
      *
      *  Check for Generic routing only
      *
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = '????' + Lv3Benc + '??'
     C                   Eval      McBicb = '???'
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

     C                   Exsr      SrCorDate
                                                                                              PNL014
      * Check correspondent time related information                                          PNL014
     C                   If        W#Valid = 'Y'                                              PNL014
     C                   Exsr      SrCorTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   If        W#Valid = 'Y'
     C                   Eval      DsLv3STPCorr = DsSTPCorr

      * Analyse routing
     C                   Exsr      SrAnalyse3
     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExReDirect3   TAG
      * Clear routing allowed
     C                   If        RouteLvp <> 'Y'
     C                             and RouteReg <> 'Y'
     C                             and RouteOur <> 'Y'
     C                   Clear                   RouteSet
     C                   Clear                   RouteGen
     C                   Clear                   RouteLVP
     C                   Clear                   RouteReg
     C                   Clear                   RouteOur
     C                   Clear                   RouteService
     C                   Endif
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrAnalyse3  : General routing for country re-direction       *
      *                                                               *
      *  CALLED BY: SrReDirect2                                       *
      *             SrReDirect3                                       *
      *                                                               *
      *****************************************************************
     CSR   SrAnalyse3    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrAnalyse3 ' @STK(Q)
      *
      *  Clear data occurs if correspondent data
     C     1             Do        20            ####P             5 0
     C     ####P         Occur     DsLv3PayCorr
     C                   Clear                   DsLv3PayCorr
     C     ####P         Occur     DsLv3PayCord
     C                   Clear                   DsLv3PayCord
     C     ####P         Occur     DsLv3Route
     C                   Clear                   DsLv3Route
     C     ####P         Occur     DsChargeDet
     C                   Clear                   DsChargeDet
     C                   Enddo
      *
      *  Check to see if routing for BENEF with Account Type
     C                   Eval      MpBicc = McBicc
     C                   Eval      MpBicb = McBicb
     C                   Eval      MpPccy = MoPccy
      * Reset pointer
     C                   Clear                   ####P
      *
     C**** KMscpV1p      Setll     @MscpV1                                                    PNL014
     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
                                                                                              PNL014
      * Position with route sequence then read equal without                                  PNL014
     C                   Clear                   MpRtSq                                       PNL014
     C     KMscpV2p      Setll     @MscpV2                                                    PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   If        *In90 = *Off
     C                   Dou       *In90 = *On
      *
     C                   Exsr      SrPayDat1
                                                                                              PNL014
      * Check correspondent time related information                                          PNL014
     C                   If        W#Valid = 'Y'                                              PNL014
     C                   Exsr      SrPayTime                                                  PNL014
     C                   Endif                                                                PNL014
                                                                                              PNL014
     C                   If        W#Valid = 'Y'
     C                   Select
     C                   When      RouteSet = 'Y' and MpSLvp = 'Y'
     C                             And RouteLvp = 'Y'
     C                   When      RouteSet = 'Y' and MpSreg = 'Y'
     C                             And RouteReg = 'Y'
     C                   When      RouteSet = 'Y' and RouteService = 'Y'
     C                             And RouteReg = 'Y'
     C                   Other
     C                   Exsr      SrPayCopt
     C                   Endsl
     C                   Endif
                                                                                              EEE065
      * Check Foreign BIC Requirement                                                         EEE065
     C                   If        W#Valid = 'Y' and MpFBic = 'N'                             EEE065
                                                                                              ESL044
      *  Check Correspondent Type, if Account do Routing                                      ESL044
     C                   Eval      McBicc = MpCbic                                            ESL044
     C                   Eval      McBicb = MpCbib                                            ESL044
     C                   Eval      McPccy = MoPccy                                            ESL044
      *                                                                                       ESL044
     C     KMsccV1       Chain     @MsccV1                                                    ESL044
      *                                                                                       ESL044
     C                   Select                                                               EEE065
      * Ok
     C                   When      Mopthr <> *blanks and RouteService = 'Y'                   EEE065
     C                             and %Subst(Mopthr:5:2) = MCCtry                            EEE065
      * Ok
     C                   When      BCtry  <> *blanks and RouteService = 'Y'                   MM1705
     C                             and BCtry = MCCtry                                         MM1705
     C                   When      Mobenb <> *blanks and RouteService = 'Y'                   EEE065
     C                             and %Subst(Mobenb:5:2) = MCCtry                            EEE065
      * No tok
     C                   When      Mopthr <> *blanks and RouteService = 'Y'                   EEE065
     C                             and %Subst(Mopthr:5:2) <> MCCtry                           EEE065
     C                   Eval      W#Valid = 'N'                                              EEE065
     C                   When      Mobenb <> *blanks and RouteService = 'Y'                   EEE065
     C                             and %Subst(Mobenb:5:2) <> MCCtry                           EEE065
     C                   Eval      W#Valid = 'N'                                              EEE065
     C                   When      Mopthr <> *blanks and                                      EEE065
     C                             %Subst(Mopthr:5:2) <> %Subst(MpBicc:5:2)                   EEE065
     C                   Eval      W#Valid = 'N'                                              EEE065
     C                   When      MoBenc <> *blanks and                                      EEE065
     C                             MoBenc <> %Subst(MpBicc:5:2)                               EEE065
     C                   Eval      W#Valid = 'N'                                              EEE065
     C                   When      MoBenb <> *blanks and                                      EEE065
     C                             %Subst(MoBenb:5:2) <> %Subst(MpBicc:5:2)                   EEE065
     C                   Eval      W#Valid = 'N'                                              EEE065
     C                   Endsl                                                                EEE065
     C                   Endif                                                                EEE065
      * Check Service code match
     C                   If        W#Valid = 'Y' and RouteService = 'Y'
     C                   Exsr      SrCheckService
     C                   Endif
     C                   If        W#Valid <> 'Y'
     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   Iter
     C                   Endif
      *
      *  Check Correspondent Type, if Account do Routing
     C                   Eval      McBicc = MpCbic
     C                   Eval      McBicb = MpCbib
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

     C                   Exsr      SrCorDate

     C                   Select
      * If not valid then next
     C                   When      W#Valid = 'N'
      * If not account then next
     C                   When      W#Valid = 'Y' and McCtyp <> 'ACCOUNT'
      * Account found and active
     C                   When      W#Valid = 'Y' and McCtyp = 'ACCOUNT'
     C                             Or
     C                             RouteService = 'Y' and MpC53a <> *blanks
      *
     C                   Eval      ####P = ####P + 1
     C     ####P         Occur     DsLv3PayCorr
     C     ####P         Occur     DsLv3PayCord
     C     ####P         Occur     DsLv3Route
     C     ####P         Occur     DsChargeDet
      *
      *  Return information
     C                   Clear                   MoDmac
     C                   Clear                   MoSncr
     C                   Clear                   MoCthr
     C                   Clear                   MoSett
     C                   Clear                   MoIntr
     C                   Eval      MoRccr = MpC54c + MpC54b
     C                   Eval      MoDstr = MpCbic + MpCbib

      * Save service
     C                   If        RouteService = 'Y'
     C                   Eval      MoPvas = MpCbib
     C                   Endif

      * If SWIFT Authentication then send to bank with cover
     C                   Select
      * Service routing
     C                   When      MpSerp <> 'Y' and RouteService = 'Y'
     C                   Eval      MoDstr = Lv1BdBicc + Lv1BdBicb
                                                                                              PNL015
      * If send via head office and identified then swap                                      PNL015
     C                   If        MpRhob = 'Y' and Lv1HeadOffice <> *blanks                  PNL015
     C                   Eval      MoDstr = Lv1HeadOffice                                     PNL015
     C                   Endif                                                                PNL015
                                                                                              PNL015
     C                   Eval      MoSett = MpStmt
      * If Reg and serial then leave
     C                   When      RouteSet = 'Y' and MpSreg = 'Y'
     C                             And RouteReg = 'Y' and McRegP = 'Y'
     C                   Eval      MoSett = MpStmt
      * If Lvp and serial then leave
     C                   When      RouteSet = 'Y' and MpSLvp = 'Y'
     C                             And RouteLvp = 'Y' and McLvpA = 'Y'
     C                   Eval      MoSett = MpStmt
      * If Our and serial then leave
     C                   When      RouteSet = 'Y' and MpSOur = 'Y'
     C                             And RouteOur = 'Y'
     C                   Eval      MoSett = MpStmt
      * If LVP and serial then leave
     C                   When      McLVPa = 'Y' and McLVPt >= MoPYAM
     C                             and MpSLvp = 'Y' and RouteGen = 'Y'
     C                   Eval      MoSett = MpStmt
      * If OUR and serial then leave
     C                   When      RouteGen = 'Y' and MoDtch = 'OUR'
     C                             and MpSOUR = 'Y'
     C                   Eval      MoSett = MpStmt
      * Keys exchanged and not serial
     C                   When      Lv1Swaut = *blanks and MpSerp <> 'Y'
     C                   Eval      MoDstr = Lv1McBicc + Lv1McBicb
                                                                                              PNL015
      * If send via head office and identified then swap                                      PNL015
     C                   If        MpRhob = 'Y' and Lv1HeadOffice <> *blanks                  PNL015
     C                             and Lv1HeadSwaut = *blanks                                 PNL015
     C                   Eval      MoDstr = Lv1HeadOffice                                     PNL015
     C                   Endif                                                                PNL015
                                                                                              PNL015
     C                   Eval      MoSett = McStmt
     C                   Endsl

     C                   Eval      MoIntr = MpC56c + MpC56b
     C                   If        MoIntr = *blanks and MoPthr <> *blanks
     C                             and MoPthr <> MoDstr
     C                   Eval      MoIntr = MoPthr
     C                   Endif

     C                   Eval      MoAcbr = MoBenb
     C                   Eval      MoCvrr = MpC53r
     C                   Eval      Mor910 = Mpr910
     C                   Eval      MoCthr = MpC53a
      *
      *  Extract account information
     C                   Clear                   MoSncr
     C                   If        MoCthr <> *blanks
     C                   Eval      W0Account = MoCthr
     C                   Exsr      SrAccount
     C                   Eval      MpC53C = %subst(BBCSID:1:8)                  FI
     C                   Eval      MpC53B = %subst(BBCSID:9:3)                  FI

      * If blank set to XXX
     C                   If        MpC53B = *blanks and MpC53c <> *blanks
     C                   Eval      MpC53B = 'XXX'
     C                   Endif
     C                   Eval      MoSncr = MpC53c + MpC53b
     C                   Else

      * Cover required ?
     C                   Eval      W0Account = McDacr
     C                   Eval      MoCthr = McDacr
     C                   Exsr      SrAccount

      * Same bank same country
     C                   If        %subst(MoDstr:1:6) = %subst(BBCsid:1:6)
     C                             or Lv1Swaut <> *blanks
     C                   Eval      MoDmac    = McDacr
     C                   Eval      MoDstr = MpCbic + MpCbib
     C                   Eval      MoCthr    = *blanks
     C                   Eval      MoCvrr = 'N'
     C                   Eval      Mor910 = 'N'
     C                   Eval      MoSncr = *blanks
     C                   Else

      * Different

     C                   Eval      MpC53C = %subst(BBCSID:1:8)                  FI
     C                   Eval      MpC53B = %subst(BBCSID:9:3)                  FI

      * If blank set to XXX
     C                   If        MpC53B = *blanks and MpC53c <> *blanks
     C                   Eval      MpC53B = 'XXX'
     C                   Endif
     C                   Eval      MoSncr = MpC53c + MpC53b

     C                   Eval      MoRccr = '?'

      * If routed then identify receiver's correspondent
     C                   If        MoRccr = '?'
     C                   Exsr      SrRecCorr
     C                   Endif

     C                   If        Mcr910 <> 'Y'
     C                   Eval      Mor910 = 'N'
     C                   Eval      MoCvrr = 'Y'
     C                   Else
     C                   Eval      Mor910 = 'Y'
     C                   Eval      MoCvrr = 'N'
     C                   Endif

     C                   Endif
     C                   Endif

      * Check Payment convention and Amounts
     C                   Exsr      SrCheckPay3

      * Only proceed if Ok
     C                   If        W#Valid = 'Y'

      * Calculate charge for route
     C                   If        MpSchc <> *blanks or MpSchr <> 0
     C                   Eval      W#ChargeCode = MpSchc
     C                   Eval      W#ChargeRate = MpSchr
     C                   Eval      W#ChargeMin  = MpSchh
     C                   Eval      W#ChargeMax  = MpSchl
     C                   Else
     C                   Eval      W#ChargeCode = McSchc
     C                   Eval      W#ChargeRate = McSchr
     C                   Eval      W#ChargeMin  = McSchh
     C                   Eval      W#ChargeMax  = McSchl
     C                   Endif
     C                   Exsr      SrCharge
     C                   Eval      C#SChargeCode = W#ChargeCode
     C                   Eval      C#SChargeRate = W#ChargeRate
     C                   Eval      C#SChargeMin  = W#ChargeMin
     C                   Eval      C#SChargeMax  = W#ChargeMax
     C                   Eval      C#SChargeAmt  = W#ChargeAmt

     C                   Eval      W#ChargeCode = Mclchc
     C                   Eval      W#ChargeRate = Mclchr
     C                   Eval      W#ChargeMin  = Mclchh
     C                   Eval      W#ChargeMax  = Mclchl
     C                   Exsr      SrCharge
     C                   Eval      C#lChargeCode = W#ChargeCode
     C                   Eval      C#lChargeRate = W#ChargeRate
     C                   Eval      C#lChargeMin  = W#ChargeMin
     C                   Eval      C#lChargeMax  = W#ChargeMax
     C                   Eval      C#lChargeAmt  = W#ChargeAmt

      * Fill routing information on charge
     C                   Eval      MoStdc = C#SChargeCode
     C                   Eval      MoStda = C#SChargeAmt
     C                   Eval      MoLvpc = C#lChargeCode
     C                   Eval      MoLvpa = C#lChargeAmt

      * If Account with bank same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoAcbr
     C                   Clear                   MoIntr
     C                   Endif

      * If Destination same as Intermediary then clear
     C                   If        MoIntr <> *blanks and
     C                             MoIntr = MoDstr
     C                   Clear                   MoIntr
     C                   Endif

      * Test for STP and LVP Route
     C                   EXsr      SrSTProute

      * Set up route information if valid
     C                   If        RouteReg = 'Y' and MoRegF = 'Y'
     C                             Or
     C                             RouteLVP = 'Y' and MoLVPF = 'Y'
     C                             Or
     C                             RouteLVP <> 'Y' and RouteREG <> 'Y'

     C                   Eval      P0Rtn  = 'Route'
     C                   Eval      DsLv3PayCorr = DsPayCorr
     C                   Eval      DsLv3PayCord = DsSTPCorr
     C                   Eval      DsLv3Route = MROTDS
     C                   Else
      *  Clear results
     C     ####P         Occur     DsLv3PayCorr
     C                   Clear                   DsLv3PayCorr
     C     ####P         Occur     DsLv3PayCord
     C                   Clear                   DsLv3PayCord
     C     ####P         Occur     DsLv3Route
     C                   Clear                   DsLv3Route
     C     ####P         Occur     DsChargeDet
     C                   Clear                   DsChargeDet
     C                   Eval      ####P = ####P - 1
     C                   Endif
     C                   Else
      *  Clear results
     C     ####P         Occur     DsLv3PayCorr
     C                   Clear                   DsLv3PayCorr
     C     ####P         Occur     DsLv3PayCord
     C                   Clear                   DsLv3PayCord
     C     ####P         Occur     DsLv3Route
     C                   Clear                   DsLv3Route
     C     ####P         Occur     DsChargeDet
     C                   Clear                   DsChargeDet
     C                   Eval      ####P = ####P - 1
     C                   Endif

     C                   Endsl

     C**** KMscpV1p      Reade     @MscpV1                                90                  PNL014
     C     KMscpV2r      Reade     @MscpV2                                90                  PNL014
     C                   Enddo
     C                   Endif
      *
      * If not route exit
     C                   If        P0Rtn  <> 'Route'
     C                   Goto      ExAnalyse3
     C                   Endif
      *
     C                   Eval      W#Select = 'N'

      * Set to first route found
     C     1             Occur     DsLv3PayCorr
     C     1             Occur     DsLv3PayCord
     C     1             Occur     DsLv3Route
     C                   Eval      DsPayCorr    = DsLv3PayCorr
     C                   Eval      DsSTPCorr    = DsLv3PayCord
     C                   Eval      MROTDS       = DsLv3Route
      *
      *  Check for Regulated and preferential routing
     C                   If        RouteReg = 'Y'
      *
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv3PayCorr
     C     ####S         Occur     DsLv3PayCord
     C     ####S         Occur     DsLv3Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lc3McRegP = 'Y' and Lc3McRegT >= MoPYAM
     C                             and Lv3McPcor = 'Y'  and Lv3MpPreg = 'Y'
      *
     C                   Eval      W#Lv3McPrnb =   Lv3McPrnb

      * Set to 1 if 0
     C                   If        W#Lv3McPrnb = 0
     C                   Eval      W#Lv3McPrnb = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv3MpPrnb / W#Lv3McPrnb)
     C                             * 100
     C                   If        W#PerCent   <   (Lv3MpPrpc + 1)
     C                   Eval      DsPayCorr   =   DsLv3PayCorr
     C                   Eval      MROTDS      =   DsLv3Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PCOR = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Eval      P2PReg = 'Y'
     C                   Leave
     C                   Endif
     C                   Endif

     C                   Enddo

     C                   Endif
      *
      *  Regulated route no preferential
     C                   If        RouteReg = 'Y' and W#Select <> 'Y'
     C                   Eval      W#Select = 'Y'

      * Set to first route found
     C     1             Occur     DsLv3PayCorr
     C     1             Occur     DsLv3PayCord
     C     1             Occur     DsLv3Route
     C                   Eval      DsPayCorr    = DsLv3PayCorr
     C                   Eval      DsSTPCorr    = DsLv3PayCord
     C                   Eval      MROTDS       = DsLv3Route
     C                   Endif
      *
      *  Check for LVP and preferential routing
      *
     C                   If        RouteLVP = 'Y'
      *  Check for direct route first                                                         ESL044
                                                                                              ESL044
      *  Check for LVP Agreement and preferential routing                                     ESL044
      *                                                                                       ESL044
     C                   If        W#Select <> 'Y'                                            ESL044
     C     1             Do        ####P         ####S             5 0                        ESL044
     C     ####S         Occur     DsLv3PayCorr                                               ESL044
     C     ####S         Occur     DsLv3PayCord                                               ESL044
     C     ####S         Occur     DsLv3Route                                                 ESL044
     C     ####S         Occur     DsChargeDet                                                ESL044
                                                                                              ESL044
      * ---- Beneficiary equal to destination takes precedence with LVP                       ESL044
     C                   If        Lc3McLVPa = 'Y' and Lc3McLVPt >= MoPYAM                    ESL044
     C                             And %subst(Lv3MoDstr:1:6)                                  ESL044
     C                                       = %subst(Lv3MoAcbr:1:6)                          ESL044
     C                             And Lv3MoIntr = *blanks                                    ESL044
     C                             Or                                                         ESL044
     C                             Lc3McLVPa = 'Y' and Lc3McLVPt >= MoPYAM                    ESL044
     C                             And Lv3MoDstr = Lv3MoIntr                                  ESL044
     C                             And %subst(Lv3MoDstr:1:6)                                  ESL044
     C                                       = %subst(Lv3MoIntr:1:6)                          ESL044
     C                             And Lv3MoIntr <> *blanks                                   ESL044
      *                                                                                       ESL044
     C                   Eval      DsPayCorr   =   DsLv3PayCorr                               ESL044
     C                   Eval      MROTDS      =   DsLv3Route                                 ESL044
     C                   Eval      W#Select = 'Y'                                             ESL044
     C                   Eval      P2PCOR = 'Y'                                               ESL044
     C                   Eval      P2Bicc = MpBicc                                            ESL044
     C                   Eval      P2Bicb = MpBicb                                            ESL044
     C                   Eval      P2Pccy = MpPccy                                            ESL044
     C                   Eval      P2Cbic = MpCbic                                            ESL044
     C                   Eval      P2Cbib = MpCbib                                            ESL044
     C                   Eval      P2PLvp = 'Y'                                               ESL044
     C                   Leave                                                                ESL044
     C                   Endif                                                                ESL044
                                                                                              ESL044
     C                   Enddo                                                                ESL044
     C                   Endif                                                                ESL044
      *                                                                                       ESL044
      *  Check for LVP Agreement and preferential routing
      *
     C                   If        W#Select <> 'Y'
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv3PayCorr
     C     ####S         Occur     DsLv3PayCord
     C     ####S         Occur     DsLv3Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lc3McLVPa = 'Y' and Lc3McLVPt >= MoPYAM
     C                             and Lv3McPcor = 'Y'  and Lv3MpPlvp = 'Y'
      *
     C                   Eval      W#Lv3McPlnb =   Lv3McPlnb

      * Set to 1 if 0
     C                   If        W#Lv3McPlnb = 0
     C                   Eval      W#Lv3McPlnb = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv3MpPlnb / W#Lv3McPlnb)
     C                             * 100
     C                   If        W#PerCent   <   (Lv3MpPlpc + 1)
     C                   Eval      DsPayCorr   =   DsLv3PayCorr
     C                   Eval      MROTDS      =   DsLv3Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PCOR = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Eval      P2PLvp = 'Y'
     C                   Leave
     C                   Endif
     C                   Endif

     C                   Enddo
     C                   Endif
      *
      *  Check for LVP Agreement routing
      *
     C                   If        W#Select <> 'Y'
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv3PayCorr
     C     ####S         Occur     DsLv3PayCord
     C     ####S         Occur     DsLv3Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lc3McLVPa = 'Y' and Lc3McLVPt >= MoPYAM
      *
     C                   Eval      DsPayCorr   =   DsLv3PayCorr
     C                   Eval      MROTDS      =   DsLv3Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PCOR = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif

     C                   Enddo
     C                   Endif
     C                   Endif
      *
      *  If route found and Low preferential correspondent then select route
      *
     C                   If        W#Select <> 'Y' and
     C                             Lv3McSpCr = 'Y' and
     C                             Lv3McSpTh >= MoPYAM
      * Set selected to N
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv3PayCorr
     C     ####S         Occur     DsLv3PayCord
     C     ####S         Occur     DsLv3Route
     C     ####S         Occur     DsChargeDet

      * BEN Payments
     C                   If        Lv3MpPbCr = 'Y'
      *                  Calculate percentage, if less leave
     C                   Eval      W#Lv3McPnbr =   Lv3McSpBn

      * Set to 1 if 0
     C                   If        W#Lv3McPnbr = 0
     C                   Eval      W#Lv3McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv3MpPbnb / W#Lv3McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv3MpPbPt + 1)
     C                             Or Lv3MpPbPt = 0
     C                   Eval      DsPayCorr   =   DsLv3PayCorr
     C                   Eval      MROTDS      =   DsLv3Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PLBen = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif
     C                   Endif

      * SHA Payments
     C                   If        Lv3MpPsCr = 'Y'
      *                  Calculate percentage, if less leave
     C                   Eval      W#Lv3McPnbr =   Lv3McSpSn

      * Set to 1 if 0
     C                   If        W#Lv3McPnbr = 0
     C                   Eval      W#Lv3McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv3MpPSnb / W#Lv3McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv3MpPsPt + 1)
     C                             Or Lv3MpPsPt = 0
     C                   Eval      DsPayCorr   =   DsLv3PayCorr
     C                   Eval      MROTDS      =   DsLv3Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PLSha = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif
     C                   Endif

      * OUR Payments
     C                   If        Lv3MpPoCr = 'Y'
      *                  Calculate percentage, if less leave
     C                   Eval      W#Lv3McPnbr =   Lv3McSpOn

      * Set to 1 if 0
     C                   If        W#Lv3McPnbr = 0
     C                   Eval      W#Lv3McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv3MpPOnb / W#Lv3McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv3MpPoPt + 1)
     C                             Or Lv3MpPoPt = 0
     C                   Eval      DsPayCorr   =   DsLv3PayCorr
     C                   Eval      MROTDS      =   DsLv3Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PLOur = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif
     C                   Endif

     C                   Enddo
     C                   Endif
      *
      *  If route found and preferential correspondent then select route
      *
     C                   If        Lv3McPcor = 'Y' and W#Select <> 'Y'
      * Set selected to N
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv3PayCorr
     C     ####S         Occur     DsLv3PayCord
     C     ####S         Occur     DsLv3Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lv3MpPcor = 'Y'
      *                  Calculate percentage, if less leave
     C                   Eval      W#Lv3McPnbr =   Lv3McPnbr

      * Set to 1 if 0
     C                   If        W#Lv3McPnbr = 0
     C                   Eval      W#Lv3McPnbr = 1
     C                   Endif
     C                   Eval      W#PerCent   =   (Lv3MpPnbr / W#Lv3McPnbr)
     C                             * 100
     C                   If        W#PerCent   <   (Lv3MpPpct + 1)
     C                   Eval      DsPayCorr   =   DsLv3PayCorr
     C                   Eval      MROTDS      =   DsLv3Route
     C                   Eval      W#Select = 'Y'
     C                   Eval      P2PCOR = 'Y'
     C                   Eval      P2Bicc = MpBicc
     C                   Eval      P2Bicb = MpBicb
     C                   Eval      P2Pccy = MpPccy
     C                   Eval      P2Cbic = MpCbic
     C                   Eval      P2Cbib = MpCbib
     C                   Leave
     C                   Endif
     C                   Endif

     C                   Enddo

      * If not selected then
     C                   If        W#Select <> 'Y'
     C     1             Do        ####P         ####S             5 0
     C     ####S         Occur     DsLv3PayCorr
     C     ####S         Occur     DsLv3PayCord
     C     ####S         Occur     DsLv3Route
     C     ####S         Occur     DsChargeDet

     C                   If        Lv3MpPcor <> 'Y'
     C                   Eval      DsPayCorr   =   DsLv3PayCorr
     C                   Eval      MROTDS      =   DsLv3Route
     C                   Eval      W#Select = 'Y'
     C                   Leave
     C                   Endif
     C                   Enddo

     C                   Endif

     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExAnalyse3    TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
                                                                                              PNL015
     C/EJECT                                                                                  PNL015
      *================================================================                       PNL015
      *                                                               *                       PNL015
      *  SRGetHeadOff Get Head Office BIC for redirect                *                       PNL015
      *                                                               *                       PNL015
      *================================================================                       PNL015
     CSR   SrGetHeadOff  BEGSR                                                                PNL015
      *                                                                                       PNL015
      *  Set up subroutine stack name                                                         PNL015
      *                                                                                       PNL015
     C                   ADD       1             Q                                            PNL015
     C                   MOVEL     'SrGetHeadOff'@STK(Q)                                      PNL015
                                                                                              PNL015
     C                   Eval      MgPccy = MoPccy                                            PNL015
     C                   Eval      W#HeadOffice = *blanks                                     PNL015
     C                   Eval      W#HeadSwaut  = '*None'                                     PNL015
      *                                                                                       PNL015
      * Loop 5 times to pick up generics                                                      PNL015
     C     1             Do        5             ####Ptr           5 0                        PNL015
                                                                                              PNL015
      * Depending on loop check for correspondents                                            PNL015
     C                   Select                                                               PNL015
      * Specific BIC                                                                          PNL015
     C                   When      ####Ptr = 1                                                PNL015
     C                   Eval      MgBicc = %subst(W#BranchBic:1:8)                           PNL015
     C                   Eval      MgBicb = %subst(W#BranchBic:9:3)                           PNL015
     C                   If        %subst(W#BranchBic:9:3) = *blanks                          PNL015
     C                   Eval      MgBicb = 'XXX'                                             PNL015
     C                   Endif                                                                PNL015
      * All branches for BIC                                                                  PNL015
     C                   When      ####Ptr = 2                                                PNL015
     C                   Eval      MgBicc = %subst(W#BranchBic:1:8)                           PNL015
     C                   Eval      MgBicb = '???'                                             PNL015
      * All branches for BIC in country                                                       PNL015
     C                   When      ####Ptr = 3                                                PNL015
     C                   Eval      MgBicc = %subst(W#BranchBic:1:6) + '??'                    PNL015
     C                   Eval      MgBicb = '???'                                             PNL015
      * All bank worldwide                                                                    PNL015
     C                   When      ####Ptr = 4                                                PNL015
     C                   Eval      MgBicc = %subst(W#BranchBic:1:4) + '????'                  PNL015
     C                   Eval      MgBicb = '???'                                             PNL015
      * Generic receiver for country                                                          PNL015
     C                   When      ####Ptr = 5                                                PNL015
     C                   Eval      MgBicc = '????' + %subst(W#BranchBic:5:2)                  PNL015
     C                                      + '??'                                            PNL015
     C                   Eval      MgBicb = '???'                                             PNL015
     C                   Endsl                                                                PNL015
      *                                                                                       PNL015
     C     KMsgrV1p      Setll     @MsgrV1                                                    PNL015
     C     KMsgrV1p      Reade     @MsgrV1                                90                  PNL015
     C                   If        *In90 = *Off                                               PNL015
     C                   Dou       *In90 = *On                                                PNL015
                                                                                              PNL015
     C                   Exsr      SrPayDat1g                                                 PNL015
                                                                                              PNL015
                                                                                              PNL015
     C                   If        W#Valid = 'Y'                                              PNL015
     C                   Exsr      SrPayCoptg                                                 PNL015
     C                   Endif                                                                PNL015
                                                                                              PNL015
      * If head office then save and exit                                                     PNL015
                                                                                              PNL015
     C                   If        W#Valid = 'Y' and                                          PNL015
     C                             MgHoBc  = 'Y'                                              PNL015
     C                   Eval      W#HeadOffice = MgCbic + MgCbib                             PNL015
      *                                                                                       PNL015
      * Get SWIFT Authentication                                                              PNL015
     C                   Clear                   O2Parm                                       PNL015
                                                                                              PNL015
      * If branch is blank then set default                                                   PNL015
                                                                                              PNL015
     C                   Select                                                               PNL015
     C                   When      O2Brca = *blanks  and IcDbrc = *blanks                     PNL015
     C                   Eval      O2Brca = 'MBB'                                             PNL015
     C                   Other                                                                PNL015
     C                   Eval      O2Brca = ICDBrc                                            PNL015
     C                   Endsl                                                                PNL015
                                                                                              PNL015
     C                   Eval      O2type = 'S'                                               PNL015
      *                                                                                       PNL015
      *  keys exchanged                                                                       PNL015
     C                   Eval      O2SBicc = MgCbic                                           PNL015
     C                   Eval      O2SBicb = MgCbib                                           PNL015
      *                                                                                       PNL015
     C                   Call      'FTP0700'                                                  PNL015
     C                   Parm                    O2RTN             7                          PNL015
     C                   Parm                    O2Parm                         Incoming dat  PNL015
      *                                                                                       PNL015
     C                   Eval      W#HeadSwaut = O2Rtn                                        PNL015
     C                   Leave                                                                PNL015
     C                   Endif                                                                PNL015
                                                                                              PNL015
     C     KMsgrV1p      Reade     @MsgrV1                                90                  PNL015
     C                   Enddo                                                                PNL015
     C                   Endif                                                                PNL015
      *                                                                                       PNL015
      *  If head office filled then leave                                                     PNL015
     C                   If        W#HeadOffice <> *blanks                                    PNL015
     C                   Leave                                                                PNL015
     C                   Endif                                                                PNL015
      *                                                                                       PNL015
     C                   Enddo                                                                PNL015
                                                                                              PNL015
      *                                                                                       PNL015
      *  Unwind subroutine stack name                                                         PNL015
      *                                                                                       PNL015
     C     ExGetHeadOff  TAG                                                                  PNL015
     C                   MOVEA     *BLANKS       @STK(Q)                                      PNL015
     C                   SUB       1             Q                                            PNL015
      *                                                                                       PNL015
     CSR                 ENDSR                                                                PNL015
      *****************************************************************                       PNL015
     C/EJECT
      *================================================================
      *                                                               *
      *  SRCheckService Check Service code matches                    *
      *                                                               *
      *================================================================
     CSR   SRCheckServiceBEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrCheckServ' @STK(Q)

     C                   Eval      W#Valid = 'N'

     C                   Eval      ####S = 1
     C     1             Do        4
     C                   If        MpCbib = %Subst(SingleService:####S:3)
     C                   Eval      W#Valid = 'Y'
     C                   Goto      ExCheckService
     C                   Endif
     C                   Add       3             ####S
     C                   Enddo

     C                   Eval      ####S = 1
     C     1             Do        4
     C                   If        MpCbib = %Subst(Lv1BdAdds:####S:3)
     C                   Eval      W#Valid = 'Y'
     C                   Goto      ExCheckService
     C                   Endif
     C                   Add       3             ####S
     C                   Enddo
      *
      *  Unwind subroutine stack name
      *
     C     ExCheckServiceTAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *================================================================
      *                                                               *
      *  SRCheckPay1  : Check for Convention, Amounts etc             *
      *                                                               *
      *================================================================
     CSR   SRCheckPay1   BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SrCheckPay1' @STK(Q)

      * Test for convention
     C                   Clear                   W#Convention
     C                   Clear                   W#CompConv
     C                   Eval      W#Valid = 'Y'

      * Set up convention to check
     C                   Eval      W#CompConv = McS71a

     C                   Exsr      SrConvention

     C                   Select
      * Convention not Ok
     C                   When      W#Convention <> 'Ok'
     C                   Eval      W#Valid = 'N'
     C                   Endsl
      *
      * If a normal payment then check is within boundary
      *
     C                   If        W#Valid = 'Y'

     C                   Select
     C                   When      MoDtch = 'SHA' or MoDtch = *blanks
      * Is amount within range
     C                   Select
     C                   When      McSpal = 0 and McSpah = 0
     C                             Or
     C                             MoPyam >= McSpaL and McSpaH = 0
     C                             Or
     C                             MoPyam >= McSpaL and MoPyam <= McSpaH
     C                   Other
     C                   Eval      W#Valid = 'N'
     C                   Endsl
     C                   When      MoDtch = 'BEN'
      * Is amount within range
     C                   Select
     C                   When      McBpal = 0 and McBpah = 0
     C                             Or
     C                             MoPyam >= McBpaL and McBpaH = 0
     C                             Or
     C                             MoPyam >= McBpaL and MoPyam <= McBpaH
     C                   Other
     C                   Eval      W#Valid = 'N'
     C                   Endsl
     C                   When      MoDtch = 'OUR'
      * Is amount within range
     C                   Select
     C                   When      McOpal = 0 and McOpah = 0
     C                             Or
     C                             MoPyam >= McOpaL and McOpaH = 0
     C                             Or
     C                             MoPyam >= McOpaL and MoPyam <= McOpaH
     C                   Other
     C                   Eval      W#Valid = 'N'
     C                   Endsl
      * Ok
     C                   Other
     C                   Endsl
     C                   Endif
      *
     C     ExCheckPay1   TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *================================================================
      *                                                               *
      *  SRCheckSWAUT : Check for SWIFT, Correspondent and Currency   *
      *                                                               *
      *================================================================
     CSR   SRCheckSWAUTN BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCheckSWATN'@STK(Q)

     C                   Eval      W#DirectSW = 'N'

      * Check if null connected BICs are allowed for currency country
     C                   Eval      MdPccy = MoPccy
     C                   Eval      MDCtry = %subst(O2SBicc:5:2)
     C     KMscyV1       Chain     @MSCYV1
     C                   If        Not %Found
     C                   Eval      MDCtry = '??'
     C     KMscyV1       Chain     @MSCYV1
     C                   If        Not %Found
     C                   Eval      MdPccy = '???'
     C     KMscyV1       Chain     @MSCYV1
     C                   Endif
     C                   Endif

      * If Found,are they allowed?
      *    Regulated Payments and LVPs must be defined
     C                   If        %Found
     C                   If        MoDtch = 'SHA' and MDPDNS <> 'Y'
     C                             Or
     C                             MoDtch = *blanks and MDPDNS <> 'Y'
     C                             Or
     C                             MoDtch = 'BEN' and MDPDNB <> 'Y'
     C                             Or
     C                             MoDtch = 'OUR' and MDPDNO <> 'Y'
     C                   Eval      W#DirectSW = 'Y'
     C                   Endif
     C                   Else

      * Default is Ok
     C                   Eval      W#DirectSW = 'Y'
     C                   Endif
      *
     C     ExCheckSWAUTN TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *================================================================
      *                                                               *
      *  SRCheckSWAUT : Check for SWIFT, Correspondent and Currency   *
      *                                                               *
      *================================================================
     CSR   SRCheckSWAUT  BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCheckSWAUT'@STK(Q)

     C                   Eval      W#DirectSW = 'N'

      * Check if null connected BICs are allowed for currency country
     C                   Eval      MdPccy = MoPccy
     C                   Eval      MDCtry = %subst(O2SBicc:5:2)
     C     KMscyV1       Chain     @MSCYV1
     C                   If        Not %Found
     C                   Eval      MDCtry = '??'
     C     KMscyV1       Chain     @MSCYV1
     C                   If        Not %Found
     C                   Eval      MdPccy = '???'
     C     KMscyV1       Chain     @MSCYV1
     C                   Endif
     C                   Endif

      * If Found,are they allowed?
      *    Regulated Payments and LVPs must be defined
     C                   If        %Found
     C                   If        MoDtch = 'SHA' and MDPDSS <> 'Y'
     C                             Or
     C                             MoDtch = *blanks and MDPDSS <> 'Y'
     C                             Or
     C                             MoDtch = 'BEN' and MDPDSB <> 'Y'
     C                             Or
     C                             MoDtch = 'OUR' and MDPDSO <> 'Y'
     C                   Eval      W#DirectSW = 'Y'
     C                   Endif
     C                   Else

      * Default is Ok
     C                   Eval      W#DirectSW = 'Y'
     C                   Endif
      *
     C     ExCheckSWAUT  TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *================================================================
      *                                                               *
      *  SRCheckPay3  : Check for Convention, Amounts etc             *
      *                                                               *
      *================================================================
     CSR   SRCheckPay3   BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCheckPay3' @STK(Q)
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = %subst(MoDstr:1:8)
     C                   Eval      McBicb = %subst(MoDstr:9:3)
                                                                                              ESL044
      * If regulated service then check this                                                  ESL044
     C                   If        RouteService = 'Y' and                                     ESL044
     C                             RouteReg = 'Y'                                             ESL044
     C                   Eval      McBicc = MpCbic                                            ESL044
     C                   Eval      McBicb = MpCbib                                            ESL044
     C                   Endif                                                                ESL044
                                                                                              ESL044
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

     C                   Exsr      SrCorDate

     C                   If        W#Valid = 'N'

     C                   Clear                   DsSTPCorr
     C                   Eval      McS71a  = 'ALL'
     C                   Eval      McBicc = %subst(MoDstr:1:8)
     C                   Eval      McBicb = %subst(MoDstr:9:3)
     C                   Eval      W#Valid = 'Y'

     C                   Endif

      * Test for convention
     C                   Clear                   W#Convention
     C                   Clear                   W#CompConv

      * Set up convention to check
     C                   Select
     C                   When      RouteLvp = 'Y'
     C                   Eval      W#CompConv = McQ71a
     C                   When      RouteOur = 'Y'
     C                   Eval      W#CompConv = McS71a
     C                   When      RouteReg = 'Y'
     C                   Eval      W#CompConv = McR71a
     C                   Other
     C                   Eval      W#CompConv = McS71a
     C                   Endsl

     C                   Exsr      SrConvention

     C                   Select
      * Convention not Ok
     C                   When      W#Convention <> 'Ok'
     C                   Eval      W#Valid = 'N'
      * Regulated payment search but payment not valid
     C                   When      W#Valid = 'Y' and RouteSet = 'Y'
     C                             And RouteReg = 'Y' and McRegP <> 'Y'
     C                             Or
     C                             W#Valid = 'Y' and RouteSet = 'Y'
     C                             And RouteReg = 'Y' and McRegP = 'Y'
     C                             And McRegt < MoPyam
     C                   Eval      W#Valid = 'N'
      * LVP Payment search but payment not valid
     C                   When      W#Valid = 'Y' and RouteSet = 'Y'
     C                             And RouteLvp = 'Y' and McLVPA <> 'Y'
     C                             Or
     C                             W#Valid = 'Y' and RouteSet = 'Y'
     C                             And RouteLvp = 'Y' and McLvpA = 'Y'
     C                             And McLvpt < MoPyam
     C                   Eval      W#Valid = 'N'
      * Our Payment search but payment not valid
     C                   When      W#Valid = 'Y' and RouteSet = 'Y'
     C                             And RouteOur = 'Y' And MoDtch <> 'OUR'
     C                   Eval      W#Valid = 'N'
      * Ok
     C                   Other
     C                   Endsl
      *
      * If a normal payment then check is within boundary
      *
     C                   If        W#Valid = 'Y' and RouteOur = 'Y'
     C                             Or
     C                             W#Valid = 'Y' and RouteGen = 'Y'

     C                   Select
     C                   When      MoDtch = 'SHA' or MoDtch = *blanks
      * Is amount within range
     C                   Select
     C                   When      McSpal = 0 and McSpah = 0
     C                             Or
     C                             MoPyam >= McSpaL and McSpaH = 0
     C                             Or
     C                             MoPyam >= McSpaL and MoPyam <= McSpaH
     C                   Other
     C                   Eval      W#Valid = 'N'
     C                   Endsl
     C                   When      MoDtch = 'BEN'
      * Is amount within range
     C                   Select
     C                   When      McBpal = 0 and McBpah = 0
     C                             Or
     C                             MoPyam >= McBpaL and McBpaH = 0
     C                             Or
     C                             MoPyam >= McBpaL and MoPyam <= McBpaH
     C                   Other
     C                   Eval      W#Valid = 'N'
     C                   Endsl
     C                   When      MoDtch = 'OUR'
      * Is amount within range
     C                   Select
     C                   When      McOpal = 0 and McOpah = 0
     C                             Or
     C                             MoPyam >= McOpaL and McOpaH = 0
     C                             Or
     C                             MoPyam >= McOpaL and MoPyam <= McOpaH
     C                   Other
     C                   Eval      W#Valid = 'N'
     C                   Endsl
      * Ok
     C                   Other
     C                   Endsl
     C                   Endif
      *
     C     ExCheckPay3   TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *================================================================
      *                                                               *
      *  SRRegulated: Test for Regulated Route                        *
      *                                                               *
      *================================================================
     CSR   SRRegulated   BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRRegulated' @STK(Q)
      * Set up route allowed
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'N'
     C                   Eval      RouteLVP = 'N'
     C                   Eval      RouteReg = 'Y'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'
      * Set up key
     C                   Eval      MdPccy = MoPccy
      *
     C                   Select
     C                   When      MoPthr <> *blanks
     C                   Eval      Lv3Benc = %subst(MoPthr:5:2)
     C                   When      BCtry  <> *blanks                                          MM1705
     C                   Eval      Lv3Benc = BCtry                                            MM1705
     C                   When      MoBenb <> *blanks
     C                   Eval      Lv3Benc = %subst(MoBenb:5:2)
     C                   Other
     C                   Eval      Lv3Benc = MoBenc
     C                   Endsl
      *
      *  Check for Generic routing for country currency
      *
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = '????' + Lv3Benc + '??'
     C                   Eval      McBicb = '???'
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

     C                   Exsr      SrCorDate
     C                   If        W#Valid = 'Y'
     C                   Eval      DsLv3STPCorr = DsSTPCorr

      * Analyse routing
     C                   Exsr      SrAnalyse3
     C                   Endif

      * Still no routing so now check for currency country re-route
     C                   If        P0Rtn  <> 'Route'
      *
      * Get currency country re-direction
     C                   Exsr      SrReDirect3

     C                   Endif
      * Clear routing allowed
     C                   Clear                   RouteSet
     C                   Clear                   RouteGen
     C                   Clear                   RouteLVP
     C                   Clear                   RouteReg
     C                   Clear                   RouteOur
     C                   Clear                   RouteService

      * If no route then try value added services
     C                   If        P0Rtn  <> 'Route'
      *
      * Process generic routing for Value Added Services
     C                   Exsr      SrServices

     C                   Endif

      * If no route and Our direct then do Our processing
     C                   If        P0Rtn  <> 'Route' and IcOurD = 'L'                         ESL038
     C                   Exsr      SrLVP                                                      ESL044
     C                   Endif                                                                ESL044
                                                                                              ESL044
     C                   If        P0Rtn  <> 'Route' and IcOurD = 'B'                         ESL044
     C                   Exsr      SrLVP                                                      ESL044
     C                   Endif                                                                ESL044
                                                                                              ESL044
     C                   If        P0Rtn  <> 'Route' and IcOurD = 'Y'
      *
      * Process generic routing for OUR
     C                   Exsr      SrOur

     C                   Endif
      *
      *  Unwind subroutine stack name
      *
     C     ExRegulated   TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *================================================================
      *                                                               *
      *  SRLVP      : Test for LVP Route                              *
      *                                                               *
      *================================================================
     CSR   SRLVP         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRLvp'       @STK(Q)
      * Set up route allowed
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'N'
     C                   Eval      RouteLVP = 'Y'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'N'
      * Set up key
     C                   Eval      MdPccy = MoPccy
      *
     C                   Select
     C                   When      MoPthr <> *blanks
     C                   Eval      Lv3Benc = %subst(MoPthr:5:2)
     C                   When      BCtry  <> *blanks                                      MM1705
     C                   Eval      Lv3Benc = BCtry                                        MM1705
     C                   When      MoBenb <> *blanks
     C                   Eval      Lv3Benc = %subst(MoBenb:5:2)
     C                   Other
     C                   Eval      Lv3Benc = MoBenc
     C                   Endsl
      *
      *  Check for Generic routing for country currency
      *
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = '????' + Lv3Benc + '??'
     C                   Eval      McBicb = '???'
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

     C                   Exsr      SrCorDate
     C                   If        W#Valid = 'Y'
     C                   Eval      DsLv3STPCorr = DsSTPCorr

      * Analyse routing
     C                   Exsr      SrAnalyse3
     C                   Endif

      * Still no routing so now check for currency country re-route
     C                   If        P0Rtn  <> 'Route'
      *
      * Get currency country re-direction
     C                   Exsr      SrReDirect3

     C                   Endif
      * Clear routing allowed
     C                   Clear                   RouteSet
     C                   Clear                   RouteGen
     C                   Clear                   RouteLVP
     C                   Clear                   RouteReg
     C                   Clear                   RouteOur
     C                   Clear                   RouteService
      *
      *  Unwind subroutine stack name
      *
     C     ExLVP         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *================================================================
      *                                                               *
      *  SROUR      : Test for OUR Route                              *
      *                                                               *
      *================================================================
     CSR   SROur         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SROur      ' @STK(Q)
      * Set up route allowed
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'N'
     C                   Eval      RouteLVP = 'N'
     C                   Eval      RouteReg = 'N'
     C                   Eval      RouteOur = 'Y'
     C                   Eval      RouteService = 'N'
      * Set up key
     C                   Eval      MdPccy = MoPccy
      *
     C                   Select
     C                   When      MoPthr <> *blanks
     C                   Eval      Lv3Benc = %subst(MoPthr:5:2)
     C                   When      BCtry  <> *blanks                                      MM1705
     C                   Eval      Lv3Benc = BCtry                                        MM1705
     C                   When      MoBenb <> *blanks
     C                   Eval      Lv3Benc = %subst(MoBenb:5:2)
     C                   Other
     C                   Eval      Lv3Benc = MoBenc
     C                   Endsl
      *
      *  Check for Generic routing for country currency
      *
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = '????' + Lv3Benc + '??'
     C                   Eval      McBicb = '???'
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

     C                   Exsr      SrCorDate
     C                   If        W#Valid = 'Y'
     C                   Eval      DsLv3STPCorr = DsSTPCorr

      * Analyse routing
     C                   Exsr      SrAnalyse3
     C                   Endif

      * Still no routing so now check for currency country re-route
     C                   If        P0Rtn  <> 'Route'
      *
      * Get currency country re-direction
     C                   Exsr      SrReDirect3

     C                   Endif
      * Clear routing allowed
     C                   Clear                   RouteSet
     C                   Clear                   RouteGen
     C                   Clear                   RouteLVP
     C                   Clear                   RouteReg
     C                   Clear                   RouteOur
     C                   Clear                   RouteService
      *
      *  Unwind subroutine stack name
      *
     C     ExOur         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
                                                                                              ESL044
     C/EJECT                                                                                  ESL044
      *================================================================                       ESL044
      *                                                               *                       ESL044
      *  SRRegServices : Test for Value Added Services                *                       ESL044
      *                                                               *                       ESL044
      *================================================================                       ESL044
     CSR   SRRegServices BEGSR                                                                ESL044
      *                                                                                       ESL044
      *  Set up subroutine stack name                                                         ESL044
      *                                                                                       ESL044
     C                   ADD       1             Q                                            ESL044
     C                   MOVEL     'SRRegServic' @STK(Q)                                      ESL044
      * Set up route allowed                                                                  ESL044
     C                   Clear                   SingleService                                ESL044
     C                   Eval      RouteSet = 'Y'                                             ESL044
     C                   Eval      RouteGen = 'Y'                                             ESL044
     C                   Eval      RouteLVP = 'N'                                             ESL044
     C                   Eval      RouteReg = 'Y'                                             ESL044
     C                   Eval      RouteOur = 'N'                                             ESL044
     C                   Eval      RouteService = 'Y'                                         ESL044
      * Set up key                                                                            ESL044
     C                   Eval      MdPccy = MoPccy                                            ESL044
      *                                                                                       ESL044
     C                   Select                                                               ESL044
     C                   When      MoPthr <> *blanks                                          ESL044
     C                   Eval      Lv3Benc = %subst(MoPthr:5:2)                               ESL044
     C                   Eval      McBicc = %subst(MoPthr:1:8)                                ESL044
     C                   Eval      McBicb = %subst(MoPthr:9:3)                                ESL044
     C                   When      MoBenb <> *blanks                                          ESL044
     C                   Eval      McBicc = %subst(MoBenb:1:8)                                ESL044
     C                   Eval      McBicb = %subst(MoBenb:9:3)                                ESL044
     C                   Eval      Lv3Benc = %subst(MoBenb:5:2)                               ESL044
     C                   When      MoBenb = *blanks  and MoPccy = 'PLN'                       PNL013
     C                   When      MoBenb = *blanks  and MoPccy = 'EUR'                       MM1705
     C                   Other                                                                ESL044
     C                   Goto      ExRegServices                                              ESL044
     C                   Endsl                                                                ESL044
      *                                                                                       ESL044
      *  Get Services data from BIC Directory                                                 ESL044
      *                                                                                       ESL044
     C                   Eval      McPccy = MoPccy                                            ESL044
      *                                                                                       ESL044
     C/COPY WNCPYSRC,FTP0715C11                                                               ESL044
                                                                                              ESL044
     C                   Clear                   NonStdService                                ESL044
     C                   Clear                   CustomerFnd                                  ESL044
     C                   Clear                   W#ClearPthr                                  ESL044
                                                                                              ESL044
      * Get customer id if SWIFT                                                              ESL044
                                                                                              ESL044
     ***************     Eval      BBcsid = MoBenb                                            MM0806
     C                   Eval      BBcsid = McBicc + McBicb                                   MM0806
     C     Kcustl7       Chain     @Custl7                                                    ESL044
     C                   If        Not %Found and %Subst(BBcsid:9:3) = 'XXX'                  ESL044
     C                   Eval      %Subst(BBcsid:9:3) = '   '                                 ESL044
     C     Kcustl7       Chain     @Custl7                                                    ESL044
     C                   Endif                                                                ESL044
     C                   If        %Found                                                     ESL044
     C                   Eval      CustomerFnd = 'Y'                                          ESL044
     C                   Endif                                                                ESL044
                                                                                              ESL044
     C                   If        MoPthr = *blanks                                           ESL044
     C                             and MoBenc <> *blanks                                      ESL044
     C                             and %Subst(Mobenb:7:5) = *blanks                           ESL044
     C                             and %Subst(Mobenb:1:6) <> *blanks                          ESL044
     C                             Or                                                         ESL044
     C                             CustomerFnd = 'Y'                                          ESL044
     C                             Or                                                         PNL013
     C                             MoBenb = *blanks  and MoPccy = 'PLN'                       PNL013
     C                             Or                                                         MM1705
     C                             MoBenb = *blanks  and MoPccy = 'EUR'                       MM1705
                                                                                              ESL038
     C                   Eval      W##StdPvas = 'EEX'                                         ESL038
     C                   Exsr      SrChkSrvMbrShp
      * If service found add                                                                  ESL038
     C                   If        W##StdService = 'Y'                                        ESL038
     C                   Eval      NonStdService = 'Y'                                        ESL038
     C                   Eval      NonStdPvas = W##StdPvas                                    ESL038
     C                   Else                                                                 ESL038
     C                   Eval      NonStdService = 'N'                                        ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   Eval      W##StdPvas = 'ACH'                                         ESL038
     C                   Exsr      SrChkSrvMbrShp
      * If service found add                                                                  ESL038
     C                   If        W##StdService = 'Y'                                        ESL038
     C                   Eval      NonStdService = 'Y'                                        ESL038
     C     NonStdPvas    Cat       W##StdPvas:0  NonStdPvas                                   ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   Eval      W##StdPvas = 'EES'                                         MM1402
     C                   Exsr      SrChkSrvMbrShp                                             MM1402
      * If service found add                                                                  MM1402
     C                   If        W##StdService = 'Y'                                        MM1402
     C                   Eval      NonStdService = 'Y'                                        MM1402
     C     NonStdPvas    Cat       W##StdPvas:0  NonStdPvas                                   MM1402
     C                   Endif                                                                MM1402
                                                                                              MM1402
     C                   Eval      W##StdPvas = 'ACE'                                         ESL038
     C                   Exsr      SrChkSrvMbrShp
      * If service found add                                                                  ESL038
     C                   If        W##StdService = 'Y'                                        ESL038
     C                   Eval      NonStdService = 'Y'                                        ESL038
     C     NonStdPvas    Cat       W##StdPvas:0  NonStdPvas                                   ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL044
     C                   Endif                                                                ESL044
                                                                                              HVB003
     C                   Eval      W##StdPvas = 'TBL'                                         HVB003
     C                   Exsr      SrChkSrvMbrShp                                             HVB003
     C                   If        W##StdService = 'Y'                                        HVB003
     C                   Eval      NonStdService = 'Y'                                        HVB003
     C     NonStdPvas    Cat       W##StdPvas:0  NonStdPvas                                   HVB003
     C                   Endif                                                                HVB003
                                                                                              ESL038
      * Check for cover abroad                                                                ESL038
     C                   If        NonStdService = 'N' or                                     ESL038
     C                             NonStdService = *blanks                                    ESL038
                                                                                              ESL038
     C                   Eval      LCCYCD = MoPccy                                            ESL038
     C                   Eval      LCSVAC = 'ES2'                                             ESL038
                                                                                              ESL038
     C     KLcsdL3       Chain     @LcSdL3                                                    ESL038
     C                   If        %Found                                                     ESL038
      * Must be SWIFT connected, +  Step 2 countries                                          ESL038
                                                                                              ESL038
      *                                                                                       ESL038
     C     KPrCtV1       Klist                                                                ESL038
     C                   Kfld                    PRCREG                                       ESL038
     C                   Kfld                    PRCTRY                                       ESL038
      *                                                                                       ESL038
     C                   Eval      PRCREG = 'ES2'                                             ESL038
     C                   Eval      PRCTRY = %SUBST(MoBenb:5:2)                                ESL038
      *                                                                                       ESL038
     C     KPrCtV1       Chain     @PrCtV1                                                    ESL038
     C                   If        %Found and %Subst(MoBenb:8:1) <> '1'                       ESL038
     C                             and MoPthr = *blanks                                       MM0806
     C                             Or                                                         MM0806
     C                             %Found and %Subst(MoPthr:8:1) <> '1'                       MM0806
     C                             And MoPthr <> *blanks                                      MM0806
     C                   Eval      NonStdService = 'Y'                                        ESL038
     C                   Eval      NonStdPvas = 'ES2'                                         ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   Endif                                                                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL044
     C     KMsccV1       Chain     @MsccV1                                                    ESL044
     C                   Select                                                               ESL044
     C/COPY WNCPYSRC,FTP0715C12                                                               ESL044
     C                   When      Not %Found and NonStdService = 'Y'                         ESL044
                                                                                              ESL044
     C                   Eval      SingleService = NonStdPvas                                 ESL044
                                                                                              ESL044
     C                   When      %Found                                                     ESL044
     C                   Exsr      SrCorDate                                                  ESL044
     C                   If        W#Valid <> 'Y'                                             ESL044
      *****
     C*****                        Or                                                         ESL044
     C*****                        W#Valid = 'Y' And McPvas = *blanks                         ESL044
     C*****                        and Lv1BdAdds = *blanks                                    ESL044
     C*****                        and NonStdService <> 'Y'                                   ESL044
     C*****                        Or                                                         ESL044
     C*****                        W#Valid = 'Y' And McPvas = *blanks                         ESL044
     C*****                        and Lv1BdAdds <> *blanks                                   ESL044
     C*****                        and Lv1SwAut <> *blanks                                    ESL044
     C*****                        and NonStdService <> 'Y'                                   ESL044
     C/COPY WNCPYSRC,FTP0715C13                                                               ESL044
      *  Not Active                                                                           ESL044
     C                   Goto      ExRegServices                                              ESL044
     C                   Endif                                                                ESL044
      *  Set single service values                                                            ESL044
     C*****              Eval      SingleService = McPvas                                     ESL044
     C                   Eval      SingleService = NonStdPvas                                 ESL044
     C/COPY WNCPYSRC,FTP0715C15                                                               ESL044
      *  No record                                                                            ESL044
     C                   Other                                                                ESL044
     C/COPY WNCPYSRC,FTP0715C16                                                               ESL044
      *  Not Added Services                                                                   ESL044
     C                   If        Lv1BdAdds = *blanks                                        ESL044
     C/COPY WNCPYSRC,FTP0715C17                                                               ESL044
     C                   Goto      ExRegServices                                              ESL044
     C                   Endif                                                                ESL044
     C                   Endsl                                                                ESL044
     C/COPY WNCPYSRC,FTP0715C18                                                               ESL044
      *                                                                                       ESL044
      *  Check for specific routing for Pay Through                                           ESL044
     C                   Eval      McBicc = 'SERVICES'                                        ESL044
     C                   Eval      McBicb = '???'                                             ESL044
     C                   Eval      McPccy = MoPccy                                            ESL044
      *                                                                                       ESL044
     C     KMsccV1       Chain     @MsccV1                                                    ESL044
                                                                                              ESL044
     C                   Exsr      SrCorDate                                                  ESL044
     C                   If        W#Valid = 'Y'                                              ESL044
     C                   Eval      DsLv3STPCorr = DsSTPCorr                                   ESL044
                                                                                              ESL044
      * Analyse routing                                                                       ESL044
     C                   Exsr      SrAnalyse3                                                 ESL044
     C                   Endif                                                                ESL044
     C                   If        P0Rtn  <> 'Route'                                          ESL044
     C                   Clear                   MoPvas                                       ESL044
     C                   If        W#ClearPthr = 'Y'                                          ESL044
     C                   Clear                   MoPthr                                       ESL044
     C                   Endif                                                                ESL044
     C                   Endif                                                                ESL044
      *                                                                                       ESL044
      *  Unwind subroutine stack name                                                         ESL044
      *                                                                                       ESL044
     C     ExRegServices TAG                                                                  ESL044
      * Clear routing allowed                                                                 ESL044
     C                   Clear                   RouteSet                                     ESL044
     C                   Clear                   RouteGen                                     ESL044
     C                   Clear                   RouteLVP                                     ESL044
     C                   Clear                   RouteReg                                     ESL044
     C                   Clear                   RouteOur                                     ESL044
     C                   Clear                   RouteService                                 ESL044
     C                   Clear                   SingleService                                ESL044
      *                                                                                       ESL044
     C                   MOVEA     *BLANKS       @STK(Q)                                      ESL044
     C                   SUB       1             Q                                            ESL044
      *                                                                                       ESL044
     CSR                 ENDSR                                                                ESL044
      *****************************************************************                       ESL044
     C/EJECT
      *================================================================
      *                                                               *
      *  SRServices : Test for Value Added Services                   *
      *                                                               *
      *================================================================
     CSR   SRServices    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRServices ' @STK(Q)
      * Set up route allowed
     C                   Clear                   SingleService
     C                   Eval      RouteSet = 'Y'
     C                   Eval      RouteGen = 'Y'
     C                   Eval      RouteLVP = 'N'
     ***                 Eval      RouteReg = 'N'                                         MMFIX1
     C                   Eval      RouteReg = 'Y'                                         MMFIX1
     C                   Eval      RouteOur = 'N'
     C                   Eval      RouteService = 'Y'
      * Set up key
     C                   Eval      MdPccy = MoPccy
      *
     C                   Select
     C                   When      MoPthr <> *blanks
     C                   Eval      Lv3Benc = %subst(MoPthr:5:2)
     C                   Eval      McBicc = %subst(MoPthr:1:8)
     C                   Eval      McBicb = %subst(MoPthr:9:3)
     C                   When      MoBenb <> *blanks
     C                   Eval      McBicc = %subst(MoBenb:1:8)
     C                   Eval      McBicb = %subst(MoBenb:9:3)
     C                   Eval      Lv3Benc = %subst(MoBenb:5:2)
     C                   Other
     C                   Goto      ExServices
     C                   Endsl
      *
      *  Get Services data from BIC Directory
      *
     C                   Eval      McPccy = MoPccy
      *
     C/COPY WNCPYSRC,FTP0715C01
                                                                                              ESL038
     C                   Clear                   NonStdService                                ESL038
     C                   Clear                   CustomerFnd                                  ESL038
                                                                                              ESL038
      * Get customer id if SWIFT                                                              ESL038
     C     Kcustl7       Klist                                                                ESL038
     C                   Kfld                    BBcsid                                       ESL038
                                                                                              ESL038
     C                   Eval      BBcsid = MoBenb                                            ESL038
     C     Kcustl7       Chain     @Custl7                                                    ESL038
     C                   If        Not %Found and %Subst(BBcsid:9:3) = 'XXX'                  ESL044
     C                   Eval      %Subst(BBcsid:9:3) = '   '                                 ESL044
     C     Kcustl7       Chain     @Custl7                                                    ESL044
     C                   Endif                                                                ESL044
     C                   If        %Found                                                     ESL038
     C                   Eval      CustomerFnd = 'Y'                                          ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   If        MoPthr = *blanks                                           ESL038
     C                             and MoBenc <> *blanks                                      ESL038
     C                             and %Subst(Mobenb:7:5) = *blanks                           ESL038
     C                             and %Subst(Mobenb:1:6) <> *blanks                          ESL038
     C                             Or                                                         ESL038
     C                             CustomerFnd = 'Y'                                          ESL038
                                                                                              ESL038
     C                   Eval      W##StdPvas = 'ACH'                                         ESL038
     C                   Exsr      SrChkSrvMbrShp
      * If service found add                                                                  ESL038
     C                   If        W##StdService = 'Y'                                        ESL038
     C                   Eval      NonStdService = 'Y'                                        ESL038
     C                   Eval      NonStdPvas = W##StdPvas                                    ESL038
     C                   Else                                                                 ESL038
     C                   Eval      NonStdService = 'N'                                        ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   Eval      W##StdPvas = 'ACE'                                         ESL038
     C                   Exsr      SrChkSrvMbrShp
      * If service found add                                                                  ESL038
     C                   If        W##StdService = 'Y'                                        ESL038
     C                   Eval      NonStdService = 'Y'                                        ESL038
     C     NonStdPvas    Cat       W##StdPvas:0  NonStdPvas                                   ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
      * Check for cover abroad                                                                ESL038
     C                   If        NonStdService = 'N'                                        ESL038
     C                             and Lv1SwAut = *blanks                                     DjbR01
     C                             Or NonStdService = *blanks                                 DjbR01
     C                             and Lv1SwAut = *blanks                                     DjbR01
                                                                                              ESL038
     C                   Eval      LCCYCD = MoPccy                                            ESL038
     C                   Eval      LCSVAC = 'ACX'                                             ESL038
                                                                                              ESL038
     C     KLcsdL3       Chain     @LcSdL3                                                    ESL038
     C                   If        %Found                                                     ESL038
      *                                                                                       ESL038
     C     KClRcV4       Klist                                                                ESL038
     C                   KFld                    ClBbbc                                       ESL038
     C                   KFld                    ClBbcb                                       ESL038
                                                                                              ESL038
     C                   If        MoPthr <> *blanks                                          ESL038
     C                   Eval      ClBbbc = %Subst(MoPthr:1:8)                                ESL038
     C                   Eval      ClBbcb = %Subst(MoPthr:9:3)                                ESL038
     C                   Else                                                                 ESL038
     C                   Eval      ClBbbc = %Subst(MoBenb:1:8)                                ESL038
     C                   Eval      ClBbcb = %Subst(MoBenb:9:3)                                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
      * Check clearing file for match                                                         ESL038
     C     KClRcV4       Chain     @ClRcV4                                                    ESL038
     C                   If        Not %Found                                                 ESL038
     C                   Eval      ClBbcb = '???'                                             ESL038
     C     KClRcV4       Chain     @ClRcV4                                                    ESL038
     C                   If        Not %Found                                                 PNL015
     C                   Eval      %Subst(ClBbbc:7:2) = '??'                                  PNL015
     C     KClRcV4       Chain     @ClRcV4                                                    PNL015
     C                   Endif                                                                PNL015
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   If        %Found                                                     ESL038
     C                   Eval      NonStdService = 'Y'                                        ESL038
     C                   Eval      NonStdPvas = 'ACXACL'                                      ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
     C                   Endif                                                                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
                                                                                              ESL038
     C     KMsccV1       Chain     @MsccV1
     C                   Select
     C/COPY WNCPYSRC,FTP0715C02
     C                   When      Not %Found and NonStdService = 'Y'                         ESL038
                                                                                              ESL038
     C                   Eval      SingleService = NonStdPvas                                 ESL038
                                                                                              ESL038
     C                   When      %Found
     C                   Exsr      SrCorDate
     C                   If        W#Valid <> 'Y'
     C                             Or
     C                             W#Valid = 'Y' And McPvas = *blanks
     C                             and Lv1BdAdds = *blanks
     C                             and NonStdService <> 'Y'                                   ESL044
     C                             Or
     C                             W#Valid = 'Y' And McPvas = *blanks
     C                             and Lv1BdAdds <> *blanks
     C                             and Lv1SwAut <> *blanks
     C                             and NonStdService <> 'Y'                                   ESL044
     C/COPY WNCPYSRC,FTP0715C03
      *  Not Active
     C                   Goto      ExServices
     C                   Endif
      *  Set single service values
     C                   Eval      SingleService = McPvas
     C/COPY WNCPYSRC,FTP0715C05
      *  No record
     C                   Other
     C/COPY WNCPYSRC,FTP0715C06
      *  Not Added Services
     C                   If        Lv1BdAdds = *blanks
     C/COPY WNCPYSRC,FTP0715C07
     C                   Goto      ExServices
     C                   Endif
     C                   Endsl
     C/COPY WNCPYSRC,FTP0715C08
      *
      *  Check for specific routing for Pay Through
     C                   Eval      McBicc = 'SERVICES'
     C                   Eval      McBicb = '???'
     C                   Eval      McPccy = MoPccy
      *
     C     KMsccV1       Chain     @MsccV1

     C                   Exsr      SrCorDate
     C                   If        W#Valid = 'Y'
     C                   Eval      DsLv3STPCorr = DsSTPCorr

      * Analyse routing
     C                   Exsr      SrAnalyse3
     C                   Endif
     C                   If        P0Rtn  <> 'Route'                                          ESL044
     C                   Clear                   MoPvas                                       ESL044
     C                   Endif                                                                ESL044
      *
      *  Unwind subroutine stack name
      *
     C     ExServices    TAG
      * Clear routing allowed
     C                   Clear                   RouteSet
     C                   Clear                   RouteGen
     C                   Clear                   RouteLVP
     C                   Clear                   RouteReg
     C                   Clear                   RouteOur
     C                   Clear                   RouteService
     C                   Clear                   SingleService
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *================================================================
      *                                                               *
      *  SRChkService: Check for Services                             *
      *                                                               *
      *================================================================
     CSR   SRChkSrvMbrShpBEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRChkSrvMbrS'@STK(Q)

     C                   Eval      W##StdService = 'N'                                        ESL038
                                                                                              ESL038
     C     KLcsdL3       Klist                                                                ESL038
     C                   Kfld                    LCCYCD                                       ESL038
     C                   Kfld                    LCSVAC                                       ESL038
                                                                                              ESL038
     C     KLccdL1       Klist                                                                ESL044
     C                   Kfld                    CLCLID                                       ESL038
     C                   Kfld                    CLCUST                                       ESL038
                                                                                              ESL038
     C                   Eval      LCCYCD = MoPccy                                            ESL038
     C                   Eval      LCSVAC = W##StdPvas                                        ESL038
                                                                                              ESL038
     C     KLcsdL3       Chain     @LcSdL3                                                    ESL038
     C                   If        %Found                                                     ESL038
      *                                                                                       PNL013
      ** If payment is PLN Elixir or PLN Sorbnet                                              PNL013
     C                   If        LCCLID = 'PLNELIXIR'  or                                   PNL013
     C                             LCCLID = 'PLNSORBNET'                                      PNL013
      *                                                                                       PNL013
      ** Check for IBAN in beneficiary field                                                  PNL013
     C                   Movel     MoBenf        AcLine            1                          PNL013
     C                   If        AcLine  = '/'                                              PNL013
      *                                                                                       PNL013
      ** Get IBAN reference                                                                   PNL013
     C                   Eval      PIBAN = %subst(MoBenf:2:34)                                PNL013
      *                                                                                       PNL013
      ** Format IBAN                                                                          PNL013
     C                   CALL      'AOIBANR3'                                                 PNL013
     C                   PARM                    @Rcode            7                          PNL013
     C                   PARM                    PIBAN            47                          PNL013
     C                   PARM                    POWith           47                          PNL013
     C     P@IBAN        PARM                    PONobl           34                          PNL013
      *                                                                                       PNL013
      ** Check for IBAN in beneficiary field                                                  PNL013
     C                   CALL      'AOIBANR5'                                                 PNL013
     C                   PARM                    @Rcode            7                          PNL013
     C                   PARM                    P@IBAN           34                          PNL013
      *                                                                                       PNL013
      ** If IBAN not valid then check with country code PL at front                           PNL013
     C                   If        @Rcode  <> *Blanks                                         PNL013
     C     'PL'          Cat       P@Iban        P#Iban           34                          PNL013
     C                   Eval      P@Iban = P#Iban                                            PNL013
     C                   Call      'AOIBANR5'                                                 PNL013
     C                   Parm                    @Rcode            7                          PNL013
     C                   Parm                    P@IBAN           34                          PNL013
     C                   Endif                                                                PNL013
      *                                                                                       PNL013
      ** If IBAN in beneficiary field                                                         PNL013
     C                   If        @Rcode  = *Blanks                                          PNL013
      *                                                                                       PNL013
      ** Set up KIR reference from incoming IBAN reference                                    PNL013
     C                   Eval      W#Kird = %subst(P@Iban:5:8)                                PNL013
      *                                                                                       PNL013
      **  Get associated customer no. if it exists                                            PNL013
     C     W#KIRD        Chain     SDCUSTZ5                                                   PNL013
      *                                                                                       PNL013
      **  If customer found set beneficiary to customer                                       PNL013
     C                   If        %Found                                                     PNL013
      *                  Eval      MoBenb = *Blanks                                           PNL013
      *                  Eval      %subst(MoBenb:5:2) = 'PL'                                  PNL013
     C                   Eval      BCtry = 'PL'                                               MM1705
     C                   Movel(p)  BBCNUM        ExBenBank         6                          PNL013
     C                   Endif                                                                PNL013
      *                                                                                       PNL013
     C                   Endif                                                                PNL013
      *                                                                                       PNL013
     C                   Endif                                                                PNL013
      *                                                                                       PNL013
     C                   Endif                                                                PNL013
                                                                                              ESL038
      *                                                                                       MM1705
      ** If payment is EURELIXIR                                                              MM1705
     C                   If        LCCLID = 'EURELIXIR'                                       MM1705
      *                                                                                       MM1705
      ** Check for IBAN in beneficiary field                                                  MM1705
     C                   Movel     MoBenf        AcLine            1                          MM1705
     C                   If        AcLine  = '/'                                              MM1705
      *                                                                                       MM1705
      ** Get IBAN reference                                                                   MM1705
     C                   Eval      PIBAN = %subst(MoBenf:2:34)                                MM1705
     C                   ELSE                                                                 MM1705
     C                   Eval      PIBAN = %subst(MoBenf:1:34)                                MM1705
     C                   ENDIF                                                                MM1705
      *                                                                                       MM1705
      ** Format IBAN                                                                          MM1705
     C                   CALL      'AOIBANR3'                                                 MM1705
     C                   PARM                    @Rcode            7                          MM1705
     C                   PARM                    PIBAN            47                          MM1705
     C                   PARM                    POWith           47                          MM1705
     C     P@IBAN        PARM                    PONobl           34                          MM1705
      *                                                                                       MM1705
      ** Check for IBAN in beneficiary field                                                  MM1705
     C                   CALL      'AOIBANR5'                                                 MM1705
     C                   PARM                    @Rcode            7                          MM1705
     C                   PARM                    P@IBAN           34                          MM1705
      *                                                                                       MM1705
      ** If IBAN not valid then check with country code PL at front                           MM1705
     C                   If        @Rcode  <> *Blanks                                         MM1705
     C     'PL'          Cat       P@Iban        P#Iban           34                          MM1705
     C                   Eval      P@Iban = P#Iban                                            MM1705
     C                   Call      'AOIBANR5'                                                 MM1705
     C                   Parm                    @Rcode            7                          MM1705
     C                   Parm                    P@IBAN           34                          MM1705
     C                   Endif                                                                MM1705
      *                                                                                       MM1705
      ** If IBAN in beneficiary field                                                         MM1705
     C                   MOVE      *BLANKS       @@CTRY            2                          MM1705
     C                   Eval      @@CTRY = %subst(P@IBAN:1:2)                                MM1705
                                                                                              MM1705
     C                   If        @Rcode  = *Blanks                                          MM1705
      *                            and @@CTRY = 'PL'                                          MM1705
                                                                                              MM1705
      ** Set up KIR reference from incoming IBAN reference                                    MM1705
     C                   Eval      W#Kird = %subst(P@Iban:5:8)                                MM1705
      *                                                                                       MM1705
      **  Get associated customer no. if it exists                                            MM1705
     C                   MOVEL     *BLANKS       @@CUST           12                          MM1705
     C                   MOVEL     W#KIRD        @@CUST                                       MM1705
     C     @@CUST        Chain     SDACUSD0                                                   MM1705
      *                                                                                       MM1705
      **  If customer found set beneficiary to customer                                       MM1705
     C                   If        %Found                                                     MM1705
      *                  Eval      MoBenb = *Blanks                                           MM1705
     C                   Eval      BCtry = 'PL'                                               MM1705
     C                   Movel(p)  E5CUST        ExBenBank         6                          MM1705
     C                   Endif                                                                MM1705
      *                                                                                       MM1705
     C                   Endif                                                                MM1705
      *                                                                                       MM1705
     C                   Endif                                                                MM1705
      *                                                                                       MM1705
                                                                                              ESL038
     C                   Eval      CLCLID = LCCLID                                            ESL038
     C                   If        CustomerFnd = 'Y'                                          ESL038
     C                   Eval      CLCUST = BBCust                                            ESL038
     C                   Else                                                                 ESL038
     C                   Eval      CLCUST = %subst(MoBenb:1:6)                                ESL038
     C                   Endif                                                                ESL038
     C                   If        ExBenBank <> *Blanks                                       PNL013
     C                   Eval      CLCUST = ExBenBank                                         PNL013
     C                   Endif                                                                PNL013
                                                                                              ESL038
     C**** KLccdL0       Chain     @LcCdL0                                              ESL038ESL044
     C     KLccdL1       Chain     @LcCdL1                                                    ESL044
      *                                                                                       ESL038
      **  If PLNELIXIR then look at Elixir membership                                         ESL038
     C                   Select                                                               ESL038
     C                   When      Not %Found and LCCLID = 'PLNELIXIR'                        ESL038
     C                             and W##StdPvas = 'ACH'                                     ESL038
     C                             Or                                                         ESL038
     C                             Not %Found and LCCLID = 'PLNSORBNET'                       ESL038
     C                             and W##StdPvas = 'ACE'                                     ESL038
                                                                                              ESL038
     C     KCustY0       Klist                                                                ESL038
     C                   Kfld                    BBcnum                                       ESL038
                                                                                              ESL038
     C                   Eval      BBcnum = Clcust                                            ESL038
     C     KCustY0       Chain     @CustY0                                                    ESL038
                                                                                              ESL038
      * If found but not active                                                               ESL038
     C                   If        %Found                                                     ESL038
                                                                                              ESL038
     C                   Eval      W##StdService = 'Y'                                        ESL038
                                                                                              ESL038
     C****               If        BBMFLG = 'Y'                                        CRC002 ESL038
     C****                         and WuRdnb < BBDSTR                                 CRC002 ESL038
     C****                         Or                                                  CRC002 ESL038
     C****                         %Found and BBMFLG = 'Y'                             CRC002 ESL038
     C****                         and WuRdnb > BBDEXP                                 CRC002 ESL038
      * Convert START Date to a Midas Day Number                                       CRC002
      *                                                                                CRC002
     C                   MOVE      BBEDST        STRDAT                                CRC002
     C                   Z-ADD     STRYR         @@YY                                  CRC002
     C                   Z-ADD     STRMON        @@MM                                  CRC002
     C                   Z-ADD     STRDAY        @@DD                                  CRC002
     C                   CALLB     'ZDATE10'                                           CRC002
     C                   PARM                    DateIn                                CRC002
     C                   PARM                    ZZMDNO            5 0                 CRC002
     C                   MOVE      ZZMDNO        BBSTR             5 0                 CRC002
     C**                                                                               CRC002
      * Convert START Date to a Midas Day Number                                       CRC002
      *                                                                                CRC002
     C                   MOVE      BBEDEX        EXPDAT                                CRC002
     C                   Z-ADD     EXPYR         @@YY                                  CRC002
     C                   Z-ADD     EXPMON        @@MM                                  CRC002
     C                   Z-ADD     EXPDAY        @@DD                                  CRC002
     C                   CALLB     'ZDATE10'                                           CRC002
     C                   PARM                    DateIn                                CRC002
     C                   PARM                    ZZMDNO            5 0                 CRC002
     C                   MOVE      ZZMDNO        BBEXP             5 0                 CRC002
     C**                                                                               CRC002
     C                   If        BBELMF = 'Y'                                        CRC002 ESL038
     C                             and WuRdnb < BBSTR                                  CRC002 ESL038
     C                             Or                                                  CRC002 ESL038
     C                             %Found and BBELMF = 'Y'                             CRC002 ESL038
     C                             and WuRdnb > BBEXP                                  CRC002 ESL038
     C                   Eval      W##StdService = 'N'                                        ESL038
     C                   Endif                                                                ESL038
     C                   Endif                                                                ESL038
                                                                                              ESL038
      * If found but not a member                                                             ESL038
     C***                If        %Found and BBMFLG <> 'Y'                            CRC002 ESL038
     C***                Eval      W##StdService = 'N'                                 CRC002 ESL038
     C***                Endif                                                         CRC002 ESL038
     C                   If        %Found and BBELMF <> 'Y'                            CRC002 ESL038
     C                   Eval      W##StdService = 'N'                                 CRC002 ESL038
     C                   Endif                                                         CRC002 ESL038
      *                                                                                       ESL038
      **  Customer does not exist as a clearing customer                                      ESL038
     C                   If        Not %Found                                                 ESL038
     C                   Eval      W##StdService = 'N'                                        ESL038
     C                   Endif                                                                ESL038
      *                                                                                       ESL038
      *                                                                                       ESL038
      **  Customer does not exist as a clearing customer                                      ESL038
     C                   When      Not %Found                                                 ESL038
     C                   Eval      W##StdService = 'N'                                        ESL038
      *                                                                                       ESL044
     C/COPY WNCPYSRC,FTP0715C19                                                               ESL044
      *                                                                                       ESL038
      **  Customer does  exist as a clearing customer                                         ESL038
     C                   When      %Found                                                     ESL038
                                                                                              ESL038
     C                   Eval      W##StdService = 'Y'                                        ESL038
                                                                                              ESL038
      * Not active                                                                            ESL038
     C***********        If        *in90 = *off and                                     ESL038242561
     C***********                  WuRdnb < CLSDAT and                                  ESL038242561
     C***********                  CLSDAT <> 0                                          ESL038242561
     C***********                  Or                                                   ESL038242561
     C***********                  *in90 = *off and                                     ESL038242561
     C***********                  WuRdnb > CLEDAT and                                  ESL038242561
     C***********                  CLEDAT <> 0                                          ESL038242561
     C                   If        WuRdnb < CLSDAT and                                        242561
     C                             CLSDAT <> 0                                                242561
     C                             Or                                                         242561
     C                             WuRdnb > CLEDAT and                                        242561
     C                             CLEDAT <> 0                                                242561
     C                   Eval      W##StdService = 'N'                                        ESL038
     C                   Endif                                                                ESL038
     C                   Endsl                                                                ESL038
                                                                                              ESL038
     C                   If        W##StdPvas = 'TBL'                                         HVB003
     C                   Eval      W##StdService = 'Y'                                        HVB003
     C                   Endif                                                                HVB003

     C                   Endif                                                                ESL038
      *
      *  Unwind subroutine stack name
      *
     C     ExChkSrvMbrShpTAG
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *================================================================
      *                                                               *
      *  SRSTPRoute : Test for STP Route                              *
      *                                                               *
      *================================================================
     CSR   SRSTProute    BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRSTPRoute'  @STK(Q)

     C                   Select
     C                   When      RouteSet = 'Y' and RouteReg = 'Y'                          ESL044
     C                             and RouteService = 'Y'                                     ESL044
     C                   Eval      O5Action = 'SRG'
     C                   When      RouteSet = 'Y' and RouteReg = 'Y'
     C                   Eval      O5Action = 'REG'
     C                   When      RouteSet = 'Y' and RouteLvp = 'Y'
     C                   Eval      O5Action = 'LVP'
     C                   Other
     C                   Eval      O5Action = 'STP'
     C                   Endsl
      * Call route validator
     C                   Call      'FTP0718'
     C                   PARM      *blanks       O5RTN             7
     C                   PARM                    O5Action          3
     C                   PARM                    MROTDS
     C                   PARM                    MVDATE                                       MM0505
      *
      *  Unwind subroutine stack name
      *
     C     ExSTPRoute    TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *================================================================
      *                                                               *
      *  SRConvention Test for Convention                             *
      *                                                               *
      *================================================================
     CSR   SRConvention  BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRConvention'@STK(Q)
      *
     C                   Clear                   W#Convention
      *
     C                   Select
      * Blank
     C                   When      MoDtch = *blanks
     C                   Select
     C                   When      W#CompConv = 'ALL'
     C                             or W#CompConv = 'SHA'
     C                             or W#CompConv = 'BENSHA'
     C                   Eval      W#Convention = 'Ok'
     C                   Endsl
      * BEN payment
     C                   When      MoDtch = 'BEN'
     C                   Select
     C                   When      W#CompConv = 'ALL'
     C                             or W#CompConv = 'BEN'
     C                             or W#CompConv = 'OURBEN'
     C                             or W#CompConv = 'BENSHA'
     C                   Eval      W#Convention = 'Ok'
     C                   Endsl
      * SHA payment
     C                   When      MoDtch = 'SHA'
     C                   Select
     C                   When      W#CompConv = 'ALL'
     C                             or W#CompConv = 'SHA'
     C                             or W#CompConv = 'OURSHA'
     C                             or W#CompConv = 'BENSHA'
     C                   Eval      W#Convention = 'Ok'
     C                   Endsl
      * OUR payment
     C                   When      MoDtch = 'OUR'
     C                   Select
     C                   When      W#CompConv = 'ALL'
     C                             or W#CompConv = 'OUR'
     C                             or W#CompConv = 'OURSHA'
     C                             or W#CompConv = 'OURBEN'
     C                   Eval      W#Convention = 'Ok'
     C                   Endsl
     C                   Endsl
      *
      *  Unwind subroutine stack name
      *
     C     ExConvention  TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
      *****************************************************************
     C/EJECT
      *================================================================
      *                                                               *
      *  SRAccount: Validate Account                                  *
      *                                                               *
      *================================================================
     CSR   SRAccount     BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRAccount'   @STK(Q)
      *
      * Check for IBAN account
      *
     C                   Eval      P@OPTN = '*KEY'
      *
     C                   Call      'AOIBANR4'
     C                   PARM      *blanks       P@RTCD            7            B:Return code
     C                   PARM                    P@OPTN            7            I:Option
     C                   PARM      W0Account     P@IBAN           34            I:Retail key
     C     ACCNT         PARM                    DSSDY                          O:OUTPUT
      *
     C                   If        P@RTCD = *blanks and ACRECI = 'D'
      *
     C                   Eval      W0Brca = ACBrca
     C                   Eval      W0Cnum = ACCnum
     C                   Eval      W0Ccy  = ACCcy
     C                   Eval      W0Acod = ACAcod
     C                   Eval      W0Acsq = ACAcsq
     C                   Eval      W0Acno = ACAcno
      *
     C                   Else
      *
     C     29            SUBST     W0Account:6   ##0029a          29
      *
     C     24            SUBST     W0Account:11  ##0024a          24
      *
     C**** 16            SUBST     W0Account:19  ##0016a          16                        AR856737
     C     10            SUBST     W0Account:25  ##0010a          10                        AR856737
      * Setup key
     C                   select
     C                   When      ##0029a = *blanks
      *
     C     3             Subst     W0Account:1   P@CYCD
     C     2             Subst     W0Account:4   P@NONB
      *
     C                   Call      'AONOSTR0'
     C                   PARM      *Blanks       P@RTCD            7            B:Return code
     C                   PARM      '*KEY'        P@OPTN            7            I:Option
     C                   PARM      *blanks       P@CUST            6            I:Customer No
     C                   PARM                    P@CYCD            3            I:Currency
     C*****              PARM      *blanks       P@ACCD            4            I:A/c Code  AR856737
     C                   PARM      *blanks       P@ACCD           10            I:A/c Code  AR856737
     C                   PARM      *blanks       P@ACSN            2            I:A/c Seq
     C                   PARM                    P@NONB            2            I:Nostro No
     C                   PARM      *blanks       P@BRCD            3            I:Branch Code
     C                   PARM      *blanks       P@CSSN           10            I:Cust ShortN
     C                   PARM      *blanks       P@PNOI            1            I:Prime Nost In
     C     SDNOST        PARM                    DSSDY                          O:Format
      *
     C                   If        P@RTCD = *blanks
     C                   Movel     A7Cust        P@CNUM
     C                   Movel     A7cycd        P@CUCD
     C                   Movel     A7Accd        P@ACCD
     C                   Movel     A7Acsn        P@ACSQ
     C                   Movel     A7Brcd        P@BRCA
      *
      *  Call to access pgm for Accounts
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      *blanks       P@RETL           10            I:Retail key
     C                   PARM                    P@CNUM            6            I:Key field 1
     C                   PARM                    P@CUCD            3            I:Key field 2
     C*****              PARM                    P@ACCD            4          I:Key field 3 AR856737
     C                   PARM                    P@ACCD                         I:Key field AR856737
     C                   PARM                    P@ACSQ            2            I:Key field 4
     C                   PARM                    P@BRCA            3            I:Key field 5  S0111
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C     ACReci        Andeq     'D'
      *
     C                   Eval      W0Brca = ACBrca
     C                   Eval      W0Cnum = ACCnum
     C                   Eval      W0Ccy  = ACCcy
     C                   Eval      W0Acod = ACAcod
     C                   Eval      W0Acsq = ACAcsq
     C                   Eval      W0Acno = ACAcno
      *
     C                   Else
     C                   Endif
     C                   Else
     C                   Endif
      *
     C                   When      ##0024a = *blanks
     C     10            SUBST     W0Account:1   P@Retl
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM                    P@RETL           10            I:Retail key
     C                   PARM      *blanks       P@CNUM            6            I:Key field 1
     C                   PARM      *blanks       P@CUCD            3            I:Key field 2
     C*****              PARM      *blanks       P@ACCD            4         I:Key field 3  AR856737
     C                   PARM      *blanks       P@ACCD                         I:Key field AR856737
     C                   PARM      *blanks       P@ACSQ            2            I:Key field 4
     C                   PARM      *blanks       P@BRCA            3            I:Key field 5  S0111
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C     ACReci        Andeq     'D'
      *
     C                   Eval      W0Brca = ACBrca
     C                   Eval      W0Cnum = ACCnum
     C                   Eval      W0Ccy  = ACCcy
     C                   Eval      W0Acod = ACAcod
     C                   Eval      W0Acsq = ACAcsq
     C                   Eval      W0Acno = ACAcno
      *
     C                   Else
     C                   Endif
     C*****              When      ##0016a = *blanks                                        AR856737
     C                   When      ##0010a = *blanks                                        AR856737
     C     6             SUBST     W0Account:1   P@CNUM
     C     3             SUBST     W0Account:7   P@CUCD
     C*****4             SUBST     W0Account:10  P@ACCD                                     AR856737
     C*****2             SUBST     W0Account:14  P@ACSQ                                     AR856737
     C*****3             SUBST     W0Account:16  P@BRCA                                     AR856737
     C     10            SUBST     W0Account:10  P@ACCD                                     AR856737
     C     2             SUBST     W0Account:20  P@ACSQ                                     AR856737
     C     3             SUBST     W0Account:22  P@BRCA                                     AR856737
      *
      *  Call to access pgm for Accounts
      *
     C                   CALL      'AOACCTR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*KEY   '     P@OPTN            7
     C                   PARM      *blanks       P@RETL           10            I:Retail key
     C                   PARM                    P@CNUM            6            I:Key field 1
     C                   PARM                    P@CUCD            3            I:Key field 2
     C*****              PARM                    P@ACCD            4          I:Key field 3 AR856737
     C                   PARM                    P@ACCD                         I:Key field AR856737
     C                   PARM                    P@ACSQ            2            I:Key field 4
     C                   PARM                    P@BRCA            3            I:Key field 5  S0111
     C     ACCNT         PARM      *BLANKS       DSSDY
      *
     C     P@RTCD        IFEQ      *BLANKS
     C     ACReci        Andeq     'D'
      *
     C                   Eval      W0Brca = ACBrca
     C                   Eval      W0Cnum = ACCnum
     C                   Eval      W0Ccy  = ACCcy
     C                   Eval      W0Acod = ACAcod
     C                   Eval      W0Acsq = ACAcsq
     C                   Eval      W0Acno = ACAcno
      *
     C                   Else
     C                   Endif
     C                   Other
     C                   Endsl

     C                   Endif

      * Account currency must equal payment currency
     C                   If        W0Ccy <> MoPCCY
     C                   Endif
      *
      *  If account them get customer SWIFT Address
      *
     C                   If        MoCthr <> *blanks

     C                   Movel(p)  W0Cnum        P@Key1

     C                   Call      'AOCUSTR0'
     C                   PARM      *blanks       P@RTCD            7            B:Return code
     C                   PARM      '*KEY'        P@OPTN            7            I:Option
     C                   PARM                    P@KEY1           10            I:Key field
     C                   PARM                    P@KYST            7            O:Key status
     C     SDCUST        PARM                    DSSDY                          O:Format
      *
     C                   Eval      W0Bic  = *blanks
     C                   If        P@Rtcd = *blanks                                        e
     C                   Eval      W0Bic  = BBCSID
     C                   Endif                                                  FI
     C                   Endif                                                  FI
      *================================================================
      *
      *  Unwind subroutine stack name
      *
     C     EXAccount     TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR

     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrCharge : Calculate charge to be levied                     *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrCharge      BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SrCharge'    @STK(Q)
      *================================================================
      *
      *  If charge code blanks
     C                   Select
     C                   When      W#ChargeCode = *blanks
     C                   Eval      W#ChargeAmt = MoPyam * W#ChargeRate
      *
      *  Test for Min Max
     C                   Select
     C                   When      W#ChargeMin = 0
     C                             and W#ChargeMax = 0
     C                   When      W#ChargeAmt < W#ChargeMin
     C                             and W#ChargeMin <> 0
     C                   Eval      W#ChargeAmt = W#ChargeMin
     C                   When      W#ChargeAmt > W#ChargeMax
     C                             and W#ChargeMax <> 0
     C                   Eval      W#ChargeAmt = W#ChargeMax
     C                   Endsl
      *================================================================
     C                   Other
      *
      *  Call FT Charge calculation program

      * Always send transaction rate to charge calculation.
     C                   If        CHTRCY = 'Y'
     C                   Eval      ChgExch   =  MoRate
     C                   Endif

     C                   Eval      ChargeCde = W#ChargeCode
     C                   Eval      SettAmt = MoSmam
     C                   If        SettAmt = 0
     C                   Eval      SettAmt = MoPyam
     C                   Endif
     C                   Eval      SettCcy = MoSmcy
     C                   Eval      PayAmt  = MoPyam
     C                   Eval      PayCcy  = MoPccy
     C                   Eval      ChgCcy  = MoPccy
     C                   Eval      STP     = 'N'
     C                   Eval      AddDeduct = 'A'

      * If charges in transaction currency flag = 'Y'

     C                   CALLB     'FT000981'
     C                   PARM      *Blanks       RetCodeOut        7
     C                   PARM                    PayAmt
     C                   PARM                    PayCcy
     C                   PARM                    SettCcy
     C                   PARM                    ChgCcy
     C                   PARM                    ChgExch
     C                   PARM                    STP
     C                   PARM                    ChargeCde         5
     C                   PARM                    SettAmt
     C                   PARM                    ChargesDR
     C                   PARM                    AddDeduct
     C                   PARM                    TotInChgCcy      13 0
     C                   PARM                    ChgableAmt       13 0
     C                   PARM                    TierCharge
     C                   PARM                    TierAmount

      *================================================================
      * Process return
     C                   If        RetCodeOut = *blanks
     C                   Eval      W#ChargeAmt = TotInChgCcy
     C                   Endif
      *================================================================
     C                   Endsl
      *
      *  Unwind subroutine stack name
      *
     C     EXCharge      TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SrInit   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *****************************************************************
     CSR   SrInit        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      * *LDA Definition
      *
     C     *DTAARA       DEFINE    *LDA          DsStarLda
      *
      * Get Rundate - Rundate  *
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Setup job date/time
      *
     C                   Z-ADD     UDATE         ##JDT
     C                   TIME                    ##JTM
      *
      * Get ICD data
     C                   Clear                   IcKey
     C     KPicdV1       Setll     @PicdV1
     C                   Read      @PicdV1
                                                                                              PNL014
      * Date processing for Time Sensitive processing                                         PNL014
                                                                                              PNL014
      * Get Midas date as CcYyMmDd                                                            PNL014
     C                   Call      'ZM0065'                                                   PNL014
     C                   Parm      WuRdNb        ZMDay                                        PNL014
     C                   Parm      *blanks       ZSDate                                       PNL014
     C                   Parm      *blanks       ZSDatc                                       PNL014
                                                                                              PNL014
      * If basis is today then Midas date else passed date                                    PNL014
     C                   Select                                                               PNL014
      * If date back valued set to today                                                      PNL014
     C                   When      ICTsBs = 'C' and MoVDat <> *blanks                         PNL014
     C                             and MoVDat < ZsDatc                                        PNL014
     C                   Eval      W#ValueDate = ZSDatc                                       PNL014
     C                   Eval      MoCDat = ZSDatc                                            PNL014
     C                   When      ICTsBs = 'C' and MoVDat <> *blanks                         PNL014
     C                   Eval      W#ValueDate = MoVDat                                       PNL014
     C                   Eval      MoCDat = MoVDat                                            PNL014
     C                   Other                                                                PNL014
     C                   Eval      W#ValueDate = ZSDatc                                       PNL014
     C                   Eval      MoCDat = ZSDatc                                            PNL014
     C                   Endsl                                                                PNL014

      **?Get Funds Transfer ICD

     C                   CALL      'AOFTFRR0'
     C                   PARM      *Blanks       P@RTCD
     C                   PARM      '*FIRST '     P@OPTN
     C     SDFTFR        PARM      SDFTFR        DSSDY
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      * Define keys
     C     KMsccV1       KLIST
     C                   KFLD                    MCBICC
     C                   KFLD                    MCBICB
     C                   KFLD                    MCPCCY
      * Full key
     C     KMscpV1       KLIST
     C                   KFLD                    MPBICC
     C                   KFLD                    MPBICB
     C                   KFLD                    MPPCCY
     C                   KFLD                    MPCBIC
     C                   KFLD                    MPCBIB
      * Partial key
     C     KMscpV1p      KLIST
     C                   KFLD                    MPBICC
     C                   KFLD                    MPBICB
     C                   KFLD                    MPPCCY
                                                                                              PNL014
      * Position with routing sequence                                                        PNL014
      * Partial key                                                                           PNL014
     C     KMscpV2p      KLIST                                                                PNL014
     C                   KFLD                    MPBICC                                       PNL014
     C                   KFLD                    MPBICB                                       PNL014
     C                   KFLD                    MPPCCY                                       PNL014
     C                   KFLD                    MPRTSQ                                       PNL014
      * Restriction key                                                                       PNL014
     C     KMscpV2r      KLIST                                                                PNL014
     C                   KFLD                    MPBICC                                       PNL014
     C                   KFLD                    MPBICB                                       PNL014
     C                   KFLD                    MPPCCY                                       PNL014
                                                                                              PNL014
                                                                                              ESL038
      * General Routes                                                                        ESL038
     C     KMsgrV1p      KLIST                                                                ESL038
     C                   KFLD                    MgBICC                                       ESL038
     C                   KFLD                    MgBICB                                       ESL038
     C                   KFLD                    MgPCCY                                       ESL038
                                                                                              ESL038
      * Bic Directory key
     C     KBicDL2       KLIST
     C                   KFLD                    BdBICC
     C                   KFLD                    BdBICB
      * Re-route key
     C     KMscrV2       KLIST
     C                   KFLD                    MrrBic
     C                   KFLD                    MrRBib
     C                   KFLD                    MrPCCY
      * Currency re-routes
     C     KMscyV1       KLIST
     C                   KFLD                    MdPccy
     C                   KFLD                    MDCtry
      *
      * Get ICD Data
     C     KPicdV1       KLIST
     C                   KFLD                    IcKey
      *
     CSR                 ENDSR
      *****************************************************************
      /EJECT
      *================================================================
      *
      * File and Program Error Processing
      *
     C/COPY MECPYSRC,SRERRC_ILE
**  CPY@
(c) Misys International Banking Systems Ltd. 2004
