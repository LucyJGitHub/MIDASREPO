     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
     H FTRANS                                                                   184509
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Customer credit tfr SWIFT msg generation')    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT0658 - Customer Credit Transfer Swift Message Generation   *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD035623           Date 27Aug15               *
      *                 MD035625           Date 27Aug15               *
      *                 MD034842           Date 30Jun15               *
      *                 MD034390           Date 14May15               *
      *                 CSW215             Date 06Apr15               *
      *                 MD023793           Date 25Nov13               *
      *                 MD022546           Date 30Sep13               *
      *                 MD021993A          Date 18Sep13               *
      *                 MD022347           Date 13Sep13               *
      *                 CSW213             Date 03Jun13               *
      *                 AR972805           Date 27Feb13               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25937           Date 09Sep09               *
      *                 BUG24516           Date 29Jun09               *
      *                 BUG25158           Date 24Jul09               *
      *                 BUG24542A          Date 30Jun09               *
      *                 BUG24553           Date 26Jun09               *
      *                 BUG24865           Date 13Jul09               *
      *                 BUG24884           Date 13Jul09               *
      *                 BUG24808           Date 09Jul09               *
      *                 BUG24748           Date 09Jul09               *
      *                 BUG24811           Date 09Jul09               *
      *                 BUG24805           Date 08Jul09               *
      *                 BUG24800           Date 08Jul09               *
      *                 BUG24806           Date 08Jul09               *
      *                 BUG24804           Date 08Jul09               *
      *                 BUG24735           Date 02Jul09               *
      *                 CSW209             Date 01Apr09               *
      *                 BUG19322           Date 23Jun08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG21193           Date 24Sep08               *
      *                 256564             Date 17Sep08               *
      *                 BUG17013           Date 17Mar08               *
      *                 BUG15250           Date 09Nov07               *
      *                 BUG15274           Date 09Nov07               *
      *                 BUG15010A          Date 25Oct07               *
      *                 BUG15090           Date 24Oct07               *
      *                 BUG15065           Date 20Oct07               *
      *                 BUG15010           Date 14Oct07               *
      *                 BUG14862           Date 14Sep07               *
      *                 BUG14755           Date 31Aug07               *
      *                 CSW207A            Date 26Jul07               *
      *                 CSW207             Date 08Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 BUG13217           Date 04Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222385             Date 23Oct03               *
      *                 221145             Date 08Sep03               *
      *                 219242             Date 01Jul03               *
      *                 219241             Date 01Jul03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSW025             Date 26Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 197639             Date 06Sep01               *
      *                 196129             Date 25Jul01               *
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190200             Date 20Feb01               *
      *                 189511             Date 04Feb00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187213             Date 21Nov00               *
      *                 185107             Date 17Oct00               *
      *                 184509             Date 03Oct00               *
      *                 184175             Date 02Oct00               *
      *                 184188             Date 02Oct00               *
      *                 184260             Date 26Sep00               *
      *                 184060             Date 22Sep00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177668             Date 10Apr00               *
      *                 CFT006  *Create    Date 30Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD035623 - Generated main and cover MT202 for MT102 have     *
      *             different network                                 *
      *  MD035625 - Field Tag 57A first line of MT102 is blank        *
      *  MD034842 - 59F is not generated when Ordering Institution    *
      *             field is a valid retail account and 59F is based  *
      *             from ACUD details                                 *
      *  MD034390 - CCTD and RFTD do not validate input for fields    *
      *             generating 52a, 56a, 57a when Clearing codes is   *
      *             supplied in transaction screen does affecting the *
      *             reports output                                    *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  MD023793 - MT102+ is generated when IBAN is invalid          *
      *  MD022546 - No MT102 generated                                *
      *  MD021993A - No STP string output for MT102                   *
      *  MD022347 - FTC0690 failed in COB                             *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  AR972805 - Remove equate translation as done externally.     *
      *             Recompile over FTCPYSRC,FTSWIFTRAN.               *
      *             (Child: AR972806)                                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG25937 - In MT202COV and MT102 field tag 52A value should  *
      *             not include the account line                      *
      *  BUG24516 - Mandatory Field 58A has no value                  *
      *  BUG25158 - MT202 Classic TRNO must be equal to field         *
      *  BUG24542A - Incorrect Message Type for MT202 COV             *
      *  BUG24553 - After message generation field Validation         *
      *             flag (cover) should have value set to COV         *
      *  BUG24865 - Incorrect amount posted in tag :32A: in MT202COV  *
      *  BUG24884 - Wrong value of tag :20: in MT202COV               *
      *  BUG24808 - Wrong value of Sender to Receiver field in MT102  *
      *  BUG24748 - Wrong country of location for senders field       *
      *  BUG24811 - All fields are in sequence B                      *
      *  BUG24805 - Only 1 MT202 COV generated for 2 Beneficiaries.   *
      *  BUG24800 - Destination is blank in MT202 and MT202COV        *
      *  BUG24806 - :57A: should not appear on sequence B of MT202COV *
      *  BUG24804 - Wrong value of tag :20: and :21: in MT202COV      *
      *  BUG24735 - 50F is missing in MT202 COV                       *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  BUG19322 - Extended Customer Details not reflected on the    *
      *             field 50F of MT101 and MT102                      *
      *  BUG21193 - Applied Fix BUG19611                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG19611 - MT102 generated is not in 50F format              *
      *  BUG17013 - CCT ID C050429000044 is missing in the MGOREFPD   *
      *  BUG15250 - Incorrect :50: format in MT102                    *
      *  BUG15274 - Wrong :59: in MT102                               *
      *  BUG15010A - Fix CFT032/CSW207 errors -Reopen                 *
      *  BUG15090 - Incomplete MT101 details if ordering customer     *
      *             came from the details.                            *
      *  BUG15065 - Error for SOSE identification type                *
      *  BUG15010 - Fix CFT032/CSW207 errors                          *
      *  BUG14862 - MT 101 generated is 50H for RFTD on Ordering      *
      *             Customer field instead of 50F                     *
      *  BUG14755 - MT 101 generated is 50H for retail number under   *
      *             ordering customer                                 *
      *  CSW207A - Swift 2007 Standard Changes                        *
      *  CSW207 - SWIFT 2007 Changes                                  *
      *  BUG13217 - Outward Payments are not being sent to MMM        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222385 - SWIFT msgs are Watch List checked regardless of     *
      *           configuration file setting                          *
      *  221145 - Compliance Watch WLC: Move compliance check to      *
      *           after COMIT to MGOMSGPD                             *
      *  219242 - Not possible to create MT103+ payment msg from      *
      *           non-FT transaction (Recompile)                      *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value (Recompile)                            *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  CSW025 - Midas Message Manager                               *
      *           - Pass original change type                         *
      *  197639 - Initialise @Type before format of :50a              *
      *  196129 - Check message priority and delivery notification    *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  190200 - Extend 189511                                       *
      *  189511 - MT102 Messages are not being produced when dealing  *
      *           with a large number of payments                     *
      *  187213 - Support block 3 processing for TI Interface         *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184509 - Foreign accent marks not allowed in SWIFT msgs      *
      *  184175 - Write destination nostro field for destination      *
      *           by nostro enquiry                                   *
      *  184188 - Field :53A: not formatted correctly if BIC          *
      *  184260 - Incorrect MT202 field :58A:.  Sould be destination  *
      *  184060 - No transaction type code in detail screen -Recompile*
      *  CDL008 - Continuous Linked Settlement (Recompiled MGOREFPD)  *
      *  177668 - Destination on MT102 not retrieved correctly.       *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
     FFT102HL6  IF   E           K DISK    INFSR(*PSSR)
     FFT102HL8  UF   E           K DISK    INFSR(*PSSR) RENAME(FT102HD0:CCT8)
     FFT102HL3  UF   E           K DISK    INFSR(*PSSR) RENAME(FT102HD0:CCT3)               BUG24553
     FFT102DL1  IF   E           K DISK    INFSR(*PSSR)
     FMGOEXTPD  O    E           K DISK    COMMIT                                           BUG19322
     FMGOREFPD  O    E           K DISK    COMMIT
     FMGOMSGPD  O    E           K DISK    COMMIT
     F***SDBRCHL5  IF   E           K DISK                                                  BUG13217
     FSDBRCHL1  IF   E           K DISK                                                     BUG13217
     FACNUMA    IF   E           K DISK
     FACCNTL6   IF   E           K DISK    RENAME(ACCNTABF:ACCNTL6F)
     FTABFP     IF   E           K DISK    IGNORE(TABTB20F:TABTG20F)
     F                                     IGNORE(TABLETHF:TABLETPF)
     F                                     IGNORE(TABLET5F:TABTE10F)
      *                                                                                       CSW201
      ** Midas ME SWIFT ISO country codes retrieval                                           CSW201
      *                                                                                       CSW201
     FMEISOCL1  IF   E           K DISK    INFSR(*PSSR)                                       CSW201
      *
     FFT0658AU  O    E             PRINTER INFDS(SPOOLU)
     F*                                                                                       147933
     FFT0658P1  O    E             PRINTER INFDS(SPOOL1)                                      147933
     F/EJECT
     F****************************************************************
     F* ID F  C  H  L    FUNCTION OF INDICATORS                      *
     F****************************************************************
     F****************************************************************
     F*
     F/EJECT
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
     D*
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      **
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D @WRK            S              1    DIM(50)                              work array       S01
     D @HLD            S              1    DIM(16)                              Set up fld 20.   S01
      *                                                                                       CSW201
      ** Senders Charges Array                                                                CSW201
     D WArSndChg       S             13P 0 DIM(5)                                             CSW201
      *                                                                                       CSW201
      ** Senders Charges in Transfer Currency Array                                           CSW201
     D WArSndChgT      S             13P 0 DIM(5)                                             CSW201
      *                                                                                       CSW201
      ** Sender Charges Currency Array                                                        CSW201
     D WArSndCcy       S              3    DIM(5)                                             CSW201
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022

     D RUNDAT          DS            13
     D* DATA STRUCTURE TO RETRIEVE MULTIBRANCH INDICATOR
     D  MBIN                  13     13
      *                                                                                     BUG19322
      ** Multiple occurrence data structure for extension file                              BUG19322
      *                                                                                     BUG19322
     D EXTN            DS                  OCCURS(45)                                       BUG19322
     D  MPSN                   1      2  0                                                  BUG19322
     D  MTG                    3      7                                                     BUG19322
     D  MCSI                   8     15                                                     BUG19322
      *                                                                                     BUG19322
      **  Field tag data structure                                                          BUG19322
      *                                                                                     BUG19322
     D                 DS                                                                   BUG19322
     D  @MTG                   1      5                                                     BUG19322
     D  FLDTYP                 2      2                                                     BUG19322
     D  FLDTAG                 4      4                                                     BUG19322
                                                                                              CSW209
     D  #NUMC          S              1    DIM(10) CTDATA PERRCD(10)                          CSW209
     D  #ALPH          S              1A   DIM(26) CTDATA PERRCD(26)                          CSW209
     D*
      ***************************************************************
      *  NOTE:                                                      *
      *  The following data structures were originally used as the  *
      *  method of writing out the swift message to PF/MSMSOPF.     *
      *  As this method of output has been replaced by a multiple   *
      *  occurence data structure only the definitions of the       *
      *  relevant fields has been retained.                         *
      *  The multiple occurence data structure is used to store up  *
      *  the records that make up the SWIFT message before writing  *
      *  the whole message to file.                                 *
      *  To store the records of the message , you must first       *
      *  access an OCUR record, then obtain the Message Tag and     *
      *  Message Field data values for this OCUR record. Continue   *
      *  this process until the SWIFT message is complete.          *
      ***************************************************************
     D                 DS
     D**
     D**********************************************
     D*       DATA STRUCTURE TO SAVE FIELDS FROM   *
     D*        INSTALLATION CONTROL DATA AREA.     *
     D**********************************************
     D*
     D****************************************1   30SDFBR
     D  SCSID                  4     15
     D  CSID9                 12     12
     D  CSID10                13     13
     D  CSID11                14     14
     D  CSID12                15     15
     D*
     D*********************************************
     D*       DATA STRUCTURE TO PROVIDE TEXT      *
     D*            ON COMIT ENTRY IN JOURNAL.     *
     D*********************************************
      *
     D FLD23           DS            35
     D  INSTCD                 1      4
     D  INSTAI                 5     35

     D FLD32A          DS            24
     D  VDAT32A                1      6
     D  CCY32A                 7      9
     D  AMNT32A               10     24
      *
     D FLD32           DS            18
     D  CCY32                  1      3
     D  AMNT32                 4     18
     D*
     D FLD33           DS            18
     D  CCY33                  1      3
     D  AMNT33                 4     18

     D FLD71           DS            18
     D  CCY71                  1      3
     D  AMNT71                 4     18

     D FLD71F          DS            18
     D  CCY71F                 1      3
     D  AMNT71F                4     18

     D FLD71G          DS            18
     D  CCY71G                 1      3
     D  AMNT71G                4     18

     D*MULT****        DS                  OCCURS(95)                                189511
     D MULT            DS                  OCCURS(5000)                              189511
     D  MTAG                   1      5
     D  MFLD                   6     55
     D  CTRC                  56     57                                         187213
     D  MSEQ                  58     60                                                     BUG24811
      **  Multiple occurrence data structure for message
      *
     D @MTAG           DS                  OCCURS(5)
     D  COLON1                 1      1
     D  FLDNO                  2      3
     D  TAG                    4      4
     D  COLON2                 5      5
     D**  Data structure to split the full nostro number
     D*
      *
     D DST1            DS            35
     D  NOSTN                  4      5
      *
      * Field :72: data structure - Original Currency & Amount
     D OCMT            DS            35
     D  O#CDWD                 1      6    INZ('/OCMT/')
     D  O#CCY                  7      9
     D  O#AMNT                10     24
     D  O#OCMT                 1     24
      *
      * Field :72: data structure - Charges
     D CHGS            DS            35
     D  C#CDWD                 1      6    INZ('/CHGS/')
     D  C#CCY                  7      9
     D  C#AMNT                10     24
     D  C#CHGS                 1     24
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D SPOOL1          DS                                                                     147933
     D  SFILE1                83     92                                                       147933
     D  SFNUM1               123    124B 0                                                    147933
      *                                                                                       147933
     D W8FT            DS           128
      *
      * Address data strutture
      *
      * Currency
     D  W8CCY                  1      3
      * Settlement Type
     D  W8STMT                 4      5
      * Mandatory Text - convert BIC identifiers
     D  W8MTXT                 6      6
      * Message Tag
     D  W8MTAG                 7     11
      * Construct of data in field
     D  W8TYPE                12     12
      * Number of Lines available
     D  W8NLIN                13     14  0
      * Network and Message Type
     D  W8NWRK                15     20
     D  W8MTPY                21     23
      * Calling Program
     D  W8CPGM                24     33
      * Action *PRINT/*ENQ/*MSG GEN
     D  W8ACT                 34     41
      * Critical reporting - Database error if 'Y'
      * If no BIC directory and BIC entered no error
     D  W8CRIT                42     42
      * Force Midas Address - where possible
     D  W8MADD                43     43
      * If Retail get first address from account
     D  W8RTAD                44     44
      * Alternative Address
     D  W8ALTN                45     45
      * Address type selected in W0MSG
     D  W8ADTP                46     46
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      **  External Data structure for customer details.
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      **  External Data structure for modules files.
      *
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)
      **  Data structure for MESSAGE MANAGEMENT file
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      **  Data structure for CURRENCIES file
      *
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      *  Calling parameter data structure for ME1400
      *
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
      *  Calling parameter data structure for ME1400
      *
     D MEBEIS        E DS                  EXTNAME(MEBEISPD)                                  CSW202
      ** Data Structure for BEI Files                                                         CSW202
      *                                                                                       CSW202
     D P@ACC         E DS                  EXTNAME(ACCNT)
      *
      /EJECT
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structure for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access programs
      *
      * External data structure - SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
      ** Externally described DS for Nostro details                                           CSW201
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSW201
                                                                                              CSW201
     D WLTDS         E DS                  EXTNAME(SDWLTDPD)                                  CSD015
      ** Midas Watch List Transaction Details File                                            CSD015
                                                                                              CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  222385
      ** Watch list checking details                                                          222385
                                                                                              222385
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
     D SDACCNT       E DS                  EXTNAME(ACCNTAB)                                 BUG14755
     D                                     PREFIX(SWF07)                                    BUG14755
      *                                                                                    BUG15010A
     D A_DSSDY       E DS                  EXTNAME(DSSDY)                                  BUG15010A
     D                                     PREFIX(A_)                                      BUG15010A
     D N_SDNOST      E DS                  EXTNAME(SDNOSTPD)                               BUG15010A
     D                                     PREFIX(N_)                                      BUG15010A
     D C_SDCUST      E DS                  EXTNAME(SDCUSTPD)                               BUG15010A
     D                                     PREFIX(C_)                                      BUG15010A
     D AMT             S             15
     D WAMNT           S             15  0
     D TOTTRN          S             15  0 INZ(0)
     D TOTRCV          S             15  0 INZ(0)
     D TOTSND          S             15  0 INZ(0)
     D WDSTN           S              1
     D IVTAG1          S              1
     D IVTAG2          S              1
     D IVTAG3          S              1
     D ISPTP           S              1
     D ISPTY1A         S             11
     D ISPTY1          S             35
     D ISPTY2          S             35
     D ISPTY3          S             35
     D ISPTY4          S             35
     D ISPTY5          S             35
     D OFSPT1          S             35
     D OFSPT2          S             35
     D OFSPT3          S             35
     D OFSPT4          S             35
     D OFSPT5          S             35
     D CNA1            S             35
     D CNA2            S             35
     D CNA3            S             35
     D CNA4            S             35
     D ISCCY           S              3
     D*CUSTNO***       S              6  0                                                    CSD027
     D CUSTNO          S              6A                                                      CSD027
     D CUSTNOT         S              6
     D WIBAN           S             34
     D CFT004          S              1    INZ(' ')
     D SAVSUMAMT       S                   Like(CCTAMT)
     D ShowRSum        S              1    INZ(' ')
     D Fld72On         S              1    INZ(' ')
     D WMTAG           S                   LIKE(MTAG)
     D SAVMTG          S              5                                                     BUG19322
     D Char18          S             18                                                       CSW213
     D CSW213          S              1                                                       CSW213
     D***SVORDITP        S              1                                          MD022546 MD023793
      *
      * MT202 data
     DSavSndBic        S              4
     DSavSndBicF       S             20
     DSavDstBic        S              4
     DSavDstBicF       S             20                                          184260
     DSav32A           S                   Like(MFLD)
      *
     DSav52A1          S                   Like(MFLD)
     DSav52A2          S                   Like(MFLD)
     DSav52AType       S              1
      *
     DSav54AType       S              1
     DSav54A1          S                   Like(MFLD)
     DSav54A2          S                   Like(MFLD)
      *
     D LigCus          DS
     D  LigCus1                      35
     D  LigCus2                      35
     D  LigCus3                      35
     D  LigCus4                      35
      *
     D CharNost        S              2                                          184175
      *
      ** Work Variables for CSW201                                                            CSW201
     D CSW201          S              1                                                       CSW201
     D WSwiftID        S             11                                                       CSW201
     D WChgInd         S              1                                                       CSW201
     D WDCnCd          S              2                                                       CSW201
     D WSCnCd          S              2                                                       CSW201
     D WDCnCdFn        S              1                                                       CSW201
     D WSCnCdFn        S              1                                                       CSW201
     D Output33B       S              1                                                       CSW201
     D WDest           S             12                                                       CSW201
     D Wc              S              2  0                                                    CSW201
     D Wl              S              2  0                                                    CSW201
     D Wx              S              2  0                                                    CSW201
     D Wy              S              2  0                                                    CSW201
     D Wz              S              2  0                                                    CSW201
     DSav54A3          S                   Like(MFLD)                                         CSW201
     DSav54A4          S                   Like(MFLD)                                         CSW201
     DSav54A5          S                   Like(MFLD)                                         CSW201
      *                                                                                       CSW201
      ** Parameters for AONOSTR0                                                              CSW201
      *                                                                                       CSW201
     D PNOSD           S              5                                                       CSW201
     D PCUST           S              6                                                       CSW201
     D PCYCD           S              3                                                       CSW201
     D***PACCD**         S              4                                              CSW201 CSW201
     D PACCD           S             10                                                       CGL029
     D PACSN           S              2                                                       CSW201
     D PNONB           S              2                                                       CSW201
     D PBRCD           S              3                                                       CSW201
     D PCSSN           S             10                                                       CSW201
     D PPNOI           S              1                                                       CSW201
      *                                                                                       CSW201
      ** Paramaters for AOIBANR4                                                              CSW201
      *                                                                                       CSW201
     D PIBAN           S             34                                                       CSW201
      *                                                                                       CSW201
      ** Paramaters for ME1400                                                                CSW201
      *                                                                                       CSW201
     D PMBICC          S              8                                                       CSW201
     D PMBICB          S              3                                                       CSW201
     D PMCUST          S              1                                                       CSW201
     D PMCNST          S              1                                                       CSW201
     D PMBICD          S              1                                                       CSW201
                                                                                              CSW201
      ** Work Variables for CSW202                                                            CSW202
     D CSW202          S              1                                                       CSW202
     D PRetCode        S              7                                                       CSW202
     D POption         S              7                                                       CSW202
     D PBICD           S              4                                                       CSW202
                                                                                              CSW202
      ** Variables for CSD015 Enhancement                                                     CSD015
                                                                                              CSD015
     D CSD015          S              1A                                                      CSD015
     D CSW025          S              1A                                                      CSD015
     D PARLS           S              1A                                                      CSD015
     D PInCcy          S              3A                                                      CSD015
     D PInput1         S             35A                                                      CSD015
     D PInput2         S             35A                                                      CSD015
     D PInput3         S             35A                                                      CSD015
     D PInput4         S             35A                                                      CSD015
     D PInput5         S             35A                                                      CSD015
     D PInput6         S             35A                                                      CSD015
     D POutput         S            216A                                                      CSD015
     D PCOutput        S              6A                                                      CSD015
     D PInDate         S              5A                                                      CSD015
     D POutDate        S             10A                                                      CSD015
     D PAMDate         S               D                                                      CSD015
     D PRtnCode        S              7A                                                      CSD015
     D PSard           S              6A                                                      CSD015
     D PString         S          30000A                                                      CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
                                                                                              CSD015
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      *                                                                                       CSW209
      ** Parameters for AOBAGRV0                                                              CSW209
      *                                                                                       CSW209
     D PRTCD           S              7A                                                      CSW209
     D PBAGR           S             10A                                                      CSW209
     D PBRCA           S              3A                                                      CSW209
     D PNWRK           S              6A                                                      CSW209
     D PMTYP           S              3A                                                      CSW209
     D PSCUR           S              3A                                                      CSW209
     D PPCUR           S              3A                                                      CSW209
     D PSSWID          S             11A                                                      CSW209
     D PRSWID          S             11A                                                      CSW209
     D PVALF           S              8A                                                      CSW209
     D PORBNK          S            256A                                                      CSW209
     D PS2RINFO        S            256A                                                      CSW209
     D PSNDCOR         S            256A                                                      CSW209
     D PRCVCOR         S            256A                                                      CSW209
                                                                                              CSW209
     D Sav52AC         S            256A                                                      CSW209
     D ADNLIC          S            256A                                                      CSW209
     D WACCI           S             11A                                                      CSW209
     D WAccInFn        S              1A                                                      CSW209
     D WAccIn          S              2A                                                      CSW209
     D WTRD1           S              1A                                                      CSW209
     D WTRD2           S              1A                                                      CSW209
     D WTRD3           S              1A                                                      CSW209
     D WTRD4           S              1A                                                      CSW209
     D TAG202          S              5A                                                      CSW209
     D TAG202B         S              5A                                                      CSW209
     D FLDCOV1         S             50A                                                      CSW209
     D FLDCOV2         S             50A                                                      CSW209
     D FLDCOV3         S             50A                                                      CSW209
     D FLDCOV4         S             50A                                                      CSW209
     D FLDCOV5         S             50A                                                      CSW209
     D FLDCOVB1        S             50A                                                      CSW209
     D FLDCOVB2        S             50A                                                      CSW209
     D FLDCOVB3        S             50A                                                      CSW209
     D FLDCOVB4        S             50A                                                      CSW209
     D FLDCOVB5        S             50A                                                      CSW209
     D W23             S              1A                                                      CSW209
     D W52A            S              1A                                                      CSW209
     D W57A            S              1A                                                      CSW209
     D W59A            S              1A                                                      CSW209
     D W72             S              1A                                                      CSW209
     DSav57aType       S              1                                                     BUG24806
     DSav57a           S                   Like(MFLD)                                       BUG24806
     D CSW215          S              1A                                                      CSW215
     D PErrTyp         S              1A                                                      CSW215
     D WRK59F          S              1A                                                      CSW215
     D WNETWK          S              6A                                                    MD035623
                                                                                              CSW209
     D WBranch         S              3A   INZ(*BLANKS)                                     BUG13217
      **                                                                                      CSC022
     C                   Z-Add     0             AUNO1
     C                   Z-Add     0             DBASE
     C                   Read      FT102HL6                               90
     C                   MOVEL     CHTP          @CHG              1                          CSW025
                                                                                              CSW025
     C                   Dow       Not *IN90

     C                   Movel     *Blanks       HOCDone           1
     C                   Movel     *Blanks       ShowRSum
     C                   Movel     *Blanks       Fld72On
     C                   MOVE      ORDITP        HORDITP           1                        MD022347

     C                   Exsr      SRCLRF
     C                   Exsr      SRBRCH
      *
      * Address data structure
      *
      *
      * Keep tally of number of records read from LF/FT102HL6
      *
     C                   Eval      AUNO1 = AUNO1 + 1
     C                   Eval      SAVSUMAMT = CCTAMT
     C                   Exsr      SRMPGI
      *
      * Output Entry to the SWIFT Message Report PRTF/FT0657P1 HEADER
      *
     C                   MOVE      'H'           PRTYPE            1
     C                   Exsr      SRH1
      *
      * Read all Transaction Details
      *
     C                   Movel     CCTID         WCCTID           15
     C     WCCTID        Setll     FT102DL1
     C     WCCTID        ReadE     FT102DL1                               90
     C                   Dow       Not *IN90
     C**********         MOVE      'D'           PRTYPE            1                          CSW201
     C**********         Exsr      SRH1                                                       CSW201
     C                   Exsr      SRMPTD
     C                   MOVE      'D'           PRTYPE            1                          CSW201
     C                   Exsr      SRH1                                                       CSW201
     C     WCCTID        ReadE     FT102DL1                               90
     C                   Enddo
      *
     C                   Exsr      SRMPST
     C                   Exsr      OMSG
      *
      * Update file
      *
     C     CCTID         CHAIN     FT102HL8                           97
     C                   Eval      GEN102 = 'Y'
     C                   Update    CCT8

      * Check if MT202 message needs to be generated.
     C                   Exsr      SRCLRF
      *                                                                                       CSW209
      ** If CSW209 is installed, call AOBAGRV0 to determine if MT202 COV                      CSW209
      ** must be generated                                                                    CSW209
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
                                                                                            BUG24805
     C     WCCTID        SETLL     FT102DL1                                                 BUG24805
     C     WCCTID        READE     FT102DL1                               90                BUG24805
     C                   DOW       NOT *IN90                                                BUG24805
                                                                                            BUG24805
     C                   EXSR      SRMPTD                                                   BUG24805
     C                   EVAL      ADNLIC = ADNLI1 + ADNLI2 +                                 CSW209
     C                             ADNLI3 + ADNLI4 + ADNLI5 + ADNLI6                          CSW209
     C                   EVAL      SAV52AC = Sav52A1 + Sav52A2                                CSW209
     C                   EVAL      PSSWID = %SUBST(STID:1:8) +                                CSW209
     C                             %SUBST(STID:10:3)                                          CSW209
                                                                                              CSW209
     C                   CALL      'AOBAGRV0'                                                 CSW209
     C                   PARM      *BLANKS       PRTCD                                        CSW209
     C                   PARM      'CCT_C202'    PBAGR                                        CSW209
     C                   PARM      BRCAA         PBRCA                                        CSW209
     C                   PARM      'SWIFT'       PNWRK                                        CSW209
     C                   PARM      '102'         PMTYP                                        CSW209
     C                   PARM                    PSCUR                                        CSW209
     C                   PARM      CCTCCY        PPCUR                                        CSW209
     C                   PARM                    PSSWID                                       CSW209
     C                   PARM      SavDstBicF    PRSWID                                       CSW209
     C                   PARM      *BLANKS       PVALF                                        CSW209
     C                   PARM      Sav52AC       PORBNK                                       CSW209
     C                   PARM      ADNLIC        PS2RINFO                                     CSW209
     C                   PARM      SNDCOR        PSNDCOR                                      CSW209
     C                   PARM      RCVCOR        PRCVCOR                                      CSW209
                                                                                              CSW209
     C                   IF        PRTCD = '*CRTCOV'                                          CSW209
     C                   EXSR      MT202COV                                                   CSW209
     C     WCCTID        READE     FT102DL1                               90                BUG24805
     C                   ELSE                                                                 CSW209
     C                   Exsr      MT202
     C                   MOVE      *ON           *IN90                                      BUG24805
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   ENDDO                                                              BUG24805
                                                                                            BUG24805
     C                   ELSE                                                                 CSW209
     C                   EXSR      MT202                                                      CSW209
     C                   ENDIF                                                                CSW209

      *
      * Comit or Rollback Changes
      *
     C                   If        Not *IN41
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   Commit
     C                   EndIf                                                                CSC022
      *                                                                         221145
      **  Call Compliance Watch:Watch List Checking                             221145
     C                   IF        CSD015 = 'Y' and CSW025 = 'N'                221145
     C                             AND W1EWLC = 'Y'                                           222385
     C                   EXSR      WLCDQ                                        221145
     C                   ENDIF                                                  221145
      *                                                                         221145
     C                   Move      'Y'           OPPARM
     C                   Else
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                   Rolbk
     C                   Else                                                                 CSC022
     C                   If        WSkpComtRolbk = 'N'                                        CSC022
     C                   RolBk                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Endif

      * Read next record
     C                   Read      FT102HL6                               90
     C                   MOVEL     CHTP          @CHG              1                          CSW025
     C                   Enddo
     C                   Exsr      SRAU
     C                   Eval      *INLR = *ON
     C/EJECT
      *****************************************************************              CSW213 MD023793
      **STPTAG*-*Check*if*STP*will*be*output*in*tag*:119***************              CSW213 MD023793
      *****************************************************************              CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C*****STPTAG        BEGSR                                                       CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         EVAL      WDCnCdFn = 'N'                                    CSW213 MD023793
     C**********         EVAL      WSCnCdFn = 'N'                                    CSW213 MD023793
      **********                                                                     CSW213 MD023793
      ***Check*if*destination*is*a*BIC*********************************              CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         EVAL      Char18 = CCTDST                                   CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         CALLB     'AOBICDV0'                                        CSW213 MD023793
     C**********         PARM      *BLANKS       RetCodeIn                           CSW213 MD023793
     C**********         PARM                    Char18                              CSW213 MD023793
     C**********         PARM                    @Type                               CSW213 MD023793
     C**********         PARM                    DSSDY                               CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         IF        @Type = '*BIC'                                    CSW213 MD023793
     C**********         EVAL      WDEST = CCTDST                                    CSW213 MD023793
     C**********         ELSE                                                        CSW213 MD023793
      **********                                                                     CSW213 MD023793
      ***Check*for*account*type****************************************              CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         CALLB     'AOACCTV1'                                        CSW213 MD023793
     C**********         PARM      *BLANKS       @RTCD                               CSW213 MD023793
     C**********         PARM      *BLANKS       @Type                               CSW213 MD023793
     C**********         PARM                    CCTDST                              CSW213 MD023793
     C**********         PARM                    DSSDY                               CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         SELECT                                                      CSW213 MD023793
     C**********         WHEN      @Type = 'IBAN'                                    CSW213 MD023793
     C**********         EVAL      ISPTP = 'I'                                       CSW213 MD023793
     C**********         WHEN      @Type = '*LEDGER'                                 CSW213 MD023793
     C**********         EVAL      ISPTP = 'G'                                       CSW213 MD023793
     C**********         WHEN      @Type = '*NOSTRO'                                 CSW213 MD023793
     C**********         EVAL      ISPTP = 'F'                                       CSW213 MD023793
     C**********         WHEN      @Type = '*RETAIL'                                 CSW213 MD023793
     C**********         EVAL      ISPTP = 'R'                                       CSW213 MD023793
     C**********         OTHER                                                       CSW213 MD023793
     C**********         EVAL      ISPTP = *BLANKS                                   CSW213 MD023793
     C**********         ENDSL                                                       CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         EVAL      ISPTY1A = *BLANKS                                 CSW213 MD023793
     C**********         EVAL      ISPTY1 = CCTDST                                   CSW213 MD023793
     C**********         EVAL      ISPTY2 = *BLANKS                                  CSW213 MD023793
     C**********         EVAL      ISPTY3 = *BLANKS                                  CSW213 MD023793
     C**********         EVAL      ISPTY4 = *BLANKS                                  CSW213 MD023793
     C**********         EVAL      ISPTY5 = *BLANKS                                  CSW213 MD023793
     C**********         EVAL      IVTAG1 = ' '                                      CSW213 MD023793
     C**********         EVAL      IVTAG2 = ' '                                      CSW213 MD023793
     C**********         EVAL      IVTAG3 = ' '                                      CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         EXSR      SRCSID                                            CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         IF        @RTCD = *BLANKS AND                               CSW213 MD023793
     C**********                   BBCSID <> *BLANKS                                 CSW213 MD023793
     C**********         EVAL      WDEST = BBCSID                                    CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
      **********                                                                     CSW213 MD023793
      ***If*destination*and*sender*ID*is*entered***********************              CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         IF        WDEST <> *BLANKS AND                              CSW213 MD023793
     C**********                   STID <> *BLANKS                                   CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         EVAL      WDCnCdFn = 'N'                                    CSW213 MD023793
     C**********         EVAL      WSCnCdFn = 'N'                                    CSW213 MD023793
      **********                                                                     CSW213 MD023793
      ***Get*the*country*code*of*destination***************************              CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         EVAL      Char18 = WDEST                                    CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         CALLB     'AOBICDV0'                                        CSW213 MD023793
     C**********         PARM      *Blanks       RetCodeIn                           CSW213 MD023793
     C**********         PARM                    Char18                              CSW213 MD023793
     C**********         PARM                    @Type                               CSW213 MD023793
     C*****MEBICD        PARM      *BLANKS       DSSDY                               CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         IF        @Type = '*BIC'                                    CSW213 MD023793
     C**********         EVAL      WDCnCd = %SUBST(BDBICC:5:2)                       CSW213 MD023793
      **********                                                                     CSW213 MD023793
      ** Check if destination country code exists in ISO country code**              CSW213 MD023793
      ***table.*If*found,*check*if*'IBAN*Required*in*MT102+*and*MT103'*              CSW213 MD023793
      ***flag*is*'Y'.**************************************************              CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C*****WDCnCd        CHAIN     MEISOCL1                           27             CSW213 MD023793
     C**********         IF        *IN27 = *OFF AND                                  CSW213 MD023793
     C**********                   M3IBAR = 'Y'                                      CSW213 MD023793
     C**********         EVAL      WDCnCdFn = 'Y'                                    CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
      **********                                                                     CSW213 MD023793
      ***Get*the*country*code*of*sender*ID*****************************              CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         EVAL      Char18 = %SUBST(STID:1:8) +                       CSW213 MD023793
     C**********                            %SUBST(STID:10:3)                        CSW213 MD023793
     C**********         CALLB     'AOBICDV0'                                        CSW213 MD023793
     C**********         PARM      *BLANKS       RetCodeIn                           CSW213 MD023793
     C**********         PARM                    Char18                              CSW213 MD023793
     C**********         PARM                    @Type                               CSW213 MD023793
     C**********         PARM                    DSSDY                               CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         IF        @Type = '*BIC'                                    CSW213 MD023793
     C**********         EVAL      MEBICD = DSSDY                                    CSW213 MD023793
     C**********         EVAL      WSCnCd = %SUBST(BDBICC:5:2)                       CSW213 MD023793
      **********                                                                     CSW213 MD023793
      ***Check*if*sender*ID*country*code*exists*in*ISO*country*code****              CSW213 MD023793
      ***table.*If*found,*check*if*'IBAN*Required*in*MT102+*and*MT103'*              CSW213 MD023793
      ***flag*is*'Y'.**************************************************              CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C*****WSCnCd        CHAIN     MEISOCL1                           27             CSW213 MD023793
     C**********         IF        *IN27 = *OFF AND                                  CSW213 MD023793
     C**********                   M3IBAR = 'Y'                                      CSW213 MD023793
     C**********         EVAL      WSCnCdFn = 'Y'                                    CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
      **********                                                                     CSW213 MD023793
      ***Account*with*instituion***************************************              CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         EVAL      SVORDITP = ORDITP                               MD022546 MD023793
     C**********         EVAL      WAccInFn = 'Y'                                 MD021993A MD023793
     C*****CCTID         SETLL     FT102DL1                                          CSW213 MD023793
     C*****CCTID         READE     FT102DL1                               90         CSW213 MD023793
     C**********         IF        *IN90 = *OFF                                      CSW213 MD023793
     C**********         IF        ACCI35 <> *BLANKS   OR                            CSW213 MD023793
     C**********                   ACCI11 <> *BLANKS                                 CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         If        ACCI11 <> *BLANKS                                 CSW213 MD023793
      **********                                                                     CSW213 MD023793
      ***Is*the*second*field*a*BIC*?***********************************              CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         EVAL      Char18 = ACCI11                                   CSW213 MD023793
     C**********         CALLB     'AOBICDV0'                                        CSW213 MD023793
     C**********         PARM      *BLANKS       RetCodeIn                           CSW213 MD023793
     C**********         PARM                    Char18                              CSW213 MD023793
     C**********         PARM                    @Type                               CSW213 MD023793
     C**********         PARM                    DSSDY                               CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         IF        @Type = '*BIC'                                    CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********                   OR CSW201 = 'Y' AND                               CSW213 MD023793
     C**********                   RetCodeIn = '*BICFND'                             CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         EVAL      WACCI = ACCI11                                    CSW213 MD023793
     C**********         EVAL      WAccIn = %SUBST(BDBICC:5:2)                       CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
      **********                                                                   MD022546 MD023793
     C**********         EVAL      ORDITP = SVORDITP                               MD022546 MD023793
      **********                                                                     CSW213 MD023793
     C**********         IF        WACCI <> *BLANKS                                  CSW213 MD023793
     C**********         EVAL      WAccInFn = 'N'                                    CSW213 MD023793
      **********                                                                     CSW213 MD023793
      ***Check*if*Account*with*instituion*country*code*exists*in*ISO****             CSW213 MD023793
      ***country*code*table.*If*found,*check*if*'IBAN*Required*in*******             CSW213 MD023793
      ***MT102+*and MT103'*flag*is*'Y'.*********************************             CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C*****WAccIn        CHAIN     MEISOCL1                           27             CSW213 MD023793
     C**********         IF        *IN27 = *OFF AND                                  CSW213 MD023793
     C**********                   M3IBAR = 'Y'                                      CSW213 MD023793
     C**********         EVAL      WAccInFn = 'Y'                                    CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
      **********                                                                     CSW213 MD023793
     C**********         ENDSR                                                       CSW213 MD023793
     C/EJECT
      *****************************************************************
      * SRMPGI - Map General Information Details to MGOMSGPD fields   *
      *****************************************************************
      *
     C     SRMPGI        Begsr
      *                                                                         187213
      * Set up block 3: for processing                                          187213
      *                                                                         187213
     C     CCTID         Ifne      FILREF                                       187213
     C                   Z-Add     1             Q                              187213
     C     Q             Occur     MULT                                         187213
     C                   Movel(p)  '3:'          MTAG                           187213
     C                   Movel     *blanks       MFLD                           187213
     C                   Movel     '(108:'       MFLD                           187213
     C     MFLD          Cat       CCTID:0       MFLD                           187213
     C                   Movel     *blanks       CTRC                           187213
     C                   Else                                                   187213
     C                   Z-Add     0             Q                              187213
     C                   Endif                                                  187213
      **********                                                                     CSW213 MD023793
     C**********         IF        CSW213 = 'Y'                                      CSW213 MD023793
     C**********         EXSR      STPTAG                                            CSW213 MD023793
     C**********         IF        WDCnCdFn = 'Y' AND                                CSW213 MD023793
     C**********                   WSCnCdFn = 'Y  ' AND                              CSW213 MD023793
     C**********                   WAccInFn = 'Y'                                    CSW213 MD023793
      *                                                                                       CSW209
      ** Field :119: - STP                                                                    CSW209
      *                                                                                       CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   MOVEL     ':119:'       MTAG                                         CSW209
     C                   MOVEL     'STP'         MFLD                                         CSW209
      *                                                                                       CSW213
     C**********         ENDIF                                                       CSW213 MD023793
     C**********         ENDIF                                                       CSW213 MD023793
      *
      * Field :20: - Transaction Reference Number.
      *
     C                   Eval      TOTTRN = *Zeros
     C                   Eval      TOTRCV = *Zeros
     C                   Eval      TOTSND = *Zeros
     C*********          Z-Add     1             Q                              187213
     C                   Add       1             Q                              187213
     C     Q             Occur     MULT
     C                   Movea     *BLANKS       @WRK
      *
     C                   Movel     ':20:'        MTAG
     C                   Eval      MFLD = FILREF
      *
      * Save the transaction Reference Number.
      *
     C                   Movel     MFLD          TRNA             16
      *
      * Field 23: Bank Operation Code
      *
     C                   If        CCTBOC <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':23:'

     C                   IF        CCTBOC = 'CREDIT' OR CCTBOC = 'SPAY'                       CSW209
     C                   MOVE      'Y'           W23                                          CSW209
     C                   ELSE                                                                 CSW209
     C                   MOVE      'N'           W23                                          CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      * Only positions 1 - 6 allowed (?)
     C                   Eval      MFLD = %Subst(CCTBOC:1:6)
     C                   Endif
      *
      * Sending Institution
      *
      ** If SWIFT 2001 enhancement is installed, this field will be                           CSW201
      ** changed from mandatory to optional                                                   CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'N' OR                                            CSW201
     C                             SINST <> *BLANKS                                           CSW201
                                                                                              CSW201
     C                   Eval      Char18 = SINST
     C                   CallB     'AOBICDV0'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18           18
     C                   Parm                    @Type
     C                   Parm                    DSSDY

     C                   If        @Type = '*BIC'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':51A:'
     C                   Eval      MFLD = SINST

      * Not a Bic. Find it
     C                   Else

     C                   Movel     SINST         KeyVal

     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    KeyVal           10
     C                   Parm      *Blanks       @Type
     C                   Parm                    SDCUST

     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':51A:'
     C                   Eval      MFLD = BBCSID
     C                   Endif
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       197639
     C                   MOVEL     *BLANKS       @Type                                        197639

      *
      * Ordering Customer
      * Can enter a customer number, shortname or account
      * MUST ONLY OUTPUT ADDRESS

      * Check if Swift 2007 is ON and Customer is not blanks                                  CSW207
     C                   EVAL      PRTCD = 'A'                                               CSW207A
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                             AND TOCUS1 <> *BLANKS                                      CSW207
     C                   MOVEL     *BLANKS       ParmStr          35                          CSW207
     C                   IF        %SUBST(TOCUS1:1:1) = '/'                                   CSW207
     C                   EVAL      ParmStr = %SUBST(TOCUS1:2:34)                              CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      ParmStr = TOCUS1                                           CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   EVAL      PIN1 = TOCUS1                                             CSW207A
     C                   EVAL      PIN2 = TOCUS2                                             CSW207A
     C                   EVAL      PIN3 = TOCUS3                                             CSW207A
     C                   EVAL      PIN4 = TOCUS4                                             CSW207A
     C                   EVAL      PIN5 = TOCUS5                                             CSW207A
      * Call Format program                                                                   CSW207
     C                   EVAL      PRTCD = 'A'                                               CSW207A
     C                   EXSR      SRFORMAT                                                   CSW207
     C                   IF        MTAG = ':50F:'                                             CSW207
     C                   EVAL      RORDC1 = POUT1                                             CSW207
     C                   EVAL      RORDC2 = POUT2                                             CSW207
     C                   EVAL      RORDC3 = POUT3                                             CSW207
     C                   EVAL      RORDC4 = POUT4                                             CSW207
     C                   EVAL      RORDC5 = POUT5                                             CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   If        TOCUS1 <> *Blanks
     C                             AND MTAG <> ':50F:'                                        CSW207
     C                             AND PRTCD <> *BLANKS                                      CSW207A
     C                   Eval      HOCDone = 'Y'
     C                   MOVEL     CUSTTH        ISPTP
     C                   MOVEL     *BLANKS       ISPTY1A
     C                   MOVEL     TOCUS1        ISPTY1
     C                   MOVEL     TOCUS2        ISPTY2
     C                   MOVEL     TOCUS3        ISPTY3
     C                   MOVEL     TOCUS4        ISPTY4
     C                   MOVEL     *Blanks       ISPTY5
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   MOVEL     TOCUS5        ISPTY5                                       CSW207
     C                   ENDIF                                                                CSW207
     C                   MOVEL     ' '           IVTAG1
     C                   MOVEL     ' '           IVTAG2
     C                   MOVEL     'D'           IVTAG3
     C                   EXSR      SRCSID
     C                   MOVE      CUSTNO        PCNUM                                      BUG19322

      * If customer details not found

     C                   If        @RTCD <> *Blanks
     C                   Movel     TOCUS1        OFSPT1
     C                   Movel     TOCUS2        OFSPT2
     C                   Movel     TOCUS3        OFSPT3
     C                   Movel     TOCUS4        OFSPT4
     C                   Movel     *blanks       OFSPT5
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   MOVEL     TOCUS5        OFSPT5                                       CSW207
     C                   ENDIF                                                                CSW207
     C                   Endif
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed and customer is existing.                     CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             @RTCD = *BLANKS                                            CSW201
      *                                                                                       CSW201
      ** Check if SWIFT ID exists in BIC directory                                            CSW201
      *                                                                                       CSW201
     C                   IF        BBCSID <> *BLANKS                                          CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
                                                                                              CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C                   PARM                    DSSDY                                        CSW201
      *                                                                                       CSW201
     C                   IF        @TYPE = '*BIC'                                             CSW201
                                                                                              CSW201
     C                   IF        %SUBST(TOCUS1:1:1) = '/'                                   CSW201
     C                   EVAL      OFSPT1 = TOCUS1                                            CSW201
     C                   EVAL      OFSPT2 = BBCSID                                            CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      OFSPT1 = BBCSID                                            CSW201
     C                   EVAL      OFSPT2 = *BLANKS                                           CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   EVAL      OFSPT3 = *BLANKS                                           CSW201
     C                   EVAL      OFSPT4 = *BLANKS                                           CSW201
     C                   EVAL      OFSPT5 = *BLANKS                                           CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        BBCSID = *BLANKS OR                                        CSW201
     C                             @TYPE <> '*BIC'                                            CSW201
                                                                                              CSW201
     C                   IF        %SUBST(TOCUS1:1:1) = '/'                                   CSW201
     C                   EVAL      OFSPT1 = TOCUS1                                            CSW201
     C                   EVAL      OFSPT2 = BBCNA1                                            CSW201
     C                   EVAL      OFSPT3 = BBCNA2                                            CSW201
     C                   EVAL      OFSPT4 = BBCNA3                                            CSW201
     C                   EVAL      OFSPT5 = BBCNA4                                            CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      OFSPT1 = BBCNA1                                            CSW201
     C                   EVAL      OFSPT2 = BBCNA2                                            CSW201
     C                   EVAL      OFSPT3 = BBCNA3                                            CSW201
     C                   EVAL      OFSPT4 = BBCNA4                                            CSW201
     C                   EVAL      OFSPT5 = *BLANKS                                           CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201

     C                   EVAL      RORDC1 = OFSPT1
     C                   EVAL      RORDC2 = OFSPT2
     C                   EVAL      RORDC3 = OFSPT3
     C                   EVAL      RORDC4 = OFSPT4
     C                   EVAL      RORDC5 = OFSPT5                                            CSW201
      *
     C                   If        OFSPT1<> *Blanks or OFSPT2<> *Blanks or
     C                             OFSPT3<> *Blanks or OFSPT4<> *Blanks

     C                   If        OFSPT1 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
      *
      ** If SWIFT 2001 is installed and BIC, format with :50A, if not BIC                     CSW201
      ** format with :50K.                                                                    CSW201
      *                                                                                       CSW201
     C                   SELECT                                                               CSW201
     C                   WHEN      CSW201 = 'N'                                               CSW201
     C                   Eval      MTAG = ':50:'
     C                   WHEN      @TYPE  = '*BIC'                                            CSW201
     C                   EVAL      MTAG = ':50A:'                                             CSW201
     C                   OTHER                                                                CSW201
     C                   EVAL      MTAG = ':50K:'                                             CSW201
     C                   ENDSL                                                                CSW201
      *                                                                                       CSW201
     C                   Eval      MFLD = OFSPT1
     C                   EVAL      TAG202 = MTAG                                              CSW209
     C                   EVAL      FLDCOV1 = MFLD                                             CSW209
     C                   Endif

     C                   If        OFSPT2<> *Blanks
     C                   Eval      Q = Q +1
     C     Q             Occur     MULT
     C                   Eval      MFLD = OFSPT2
     C                   EVAL      FLDCOV2 = MFLD                                             CSW209
     C                   Endif
      *
     C                   If        OFSPT3 <> *Blanks
     C                   Eval      Q = Q +1
     C     Q             Occur     MULT
     C                   Eval      MFLD = OFSPT3
     C                   EVAL      FLDCOV3 = MFLD                                             CSW209
     C                   Endif
      *
     C                   If        OFSPT4 <> *Blanks
     C                   Eval      Q = Q +1
     C     Q             Occur     MULT
     C                   Eval      MFLD = OFSPT4
     C                   EVAL      FLDCOV4 = MFLD                                             CSW209
     C                   Endif
                                                                                              CSW201
     C                   If        OFSPT5 <> *Blanks                                          CSW201
     C                   Eval      Q = Q +1                                                   CSW201
     C     Q             Occur     MULT                                                       CSW201
     C                   Eval      MFLD = OFSPT5                                              CSW201
     C                   EVAL      FLDCOV5 = MFLD                                             CSW209
     C                   Endif                                                                CSW201
                                                                                              CSW201
     C                   Endif
     C                   Endif
      *
      * Ordering Institution
      *
      ** Ordering institution (11 chars)
      ** can only be a BIC or a customer number
     C                   If        OINST1 <> *Blanks OR
     C                             OINST3 <> *Blanks

     C                   Eval      Sav52A1 = *Blanks
     C                   Eval      Sav52A2 = *Blanks
     C                   Eval      Sav52AType = *Blanks
     C                   If        OINST1 <> *Blanks
     C                   Eval      Sav52AType = 'A'
     C                   Eval      Char18 = OINST1
     C                   CallB     'AOBICDV0'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18           18
     C                   Parm                    @Type
     C                   Parm                    DSSDY

      ** If not a Bic then convert the customer number into a BIC
      ** (and override field)
     C                   If        @Type <> '*BIC'
     C                   Eval      LigArg = OINST1
     C                   Exsr      RtvCus
     C                   If        NoCust = 'NF'
     C                             AND CSW207 <> 'Y'                                         CSW207A
      ** Customer must exist in Midas
     C     *LOCK         IN        LDA
     C                   Movel     'SDCUSTPD'    DBFILE
     C                   Movel     OINST1        DBKEY
     C                   Z-Add     20            DBASE
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Else
     C                   If        LigSwift <> *BLANK
     C                   Eval      OINST1 = LigSwift
     C                   Else
     C                   If        CSW207 <> 'Y'                                             CSW207A
      ** Customer must have a SWIFT address
     C     *LOCK         IN        LDA
     C                   Movel     'SDCUSTPD'    DBFILE
     C                   Movel     BBCUST        DBKEY
     C                   Z-Add     20            DBASE
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif                                                               CSW207A
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif

      ** Ordering institution (35 chars)
      ** can only be a clearing code or an account
      ** if not a clearing code and no SWIFT id entered
      ** then convert the account into a SWIFT
      ** (put the result in OINST1 supposed to be blank)
      *                                                                                       CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
                                                                                              CSW201
     C                   If        OINST3 <> *Blanks
     C                   If        %subst(OINST3:1:1) <> '/'
     C                   Eval      OINST3 = '/' + OINST3
     C                   Endif
     C                   If        %subst(OINST3:1:2) = '//'
     C                   If        OINST1 = *BLANK
     C                   Eval      Sav52AType = 'C'
     C                   Endif
     C                   Else
     C                   If        OINST1 = *BLANK
     C                   Eval      Sav52AType = 'A'
     C**********         MOVEL     ORDITP        ISPTP                                      MD022347
     C                   MOVEL     HORDITP       ISPTP                                      MD022347
     C                   MOVEL     *BLANKS       ISPTY1A
     C                   MOVEL     OINST3        ISPTY1
     C                   MOVEL     *BLANKS       ISPTY2
     C                   MOVEL     *BLANKS       ISPTY3
     C                   MOVEL     *BLANKS       ISPTY4
     C                   MOVEL     *BLANKS       ISPTY5
     C                   MOVEL     'A'           IVTAG1
     C                   MOVEL     ' '           IVTAG2
     C                   MOVEL     ' '           IVTAG3
     C                   EXSR      SRCSID
     C                   If        NoCust = 'NF'
      *                                                                                       CSW201
      ** If not found, second line could be BIC.                                              CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      Char18 = %SUBST(OINST3:2)                                  CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C     MEBICD        PARM      *BLANKS       DSSDY                                        CSW201
      *                                                                                       CSW201
     C                   IF        @Type = '*BIC'                                             CSW201
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   CALL      'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRetCode                                     CSW202
     C                   PARM      '*VERIFY'     POption                                      CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
     C                   IF        (BDSUBT = 'BEID' OR                                        CSW201
     C                             BDSUBT = 'TRCO')                                           CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y'                                           CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW202
     C                   EVAL      Sav52Atype = 'C'                                           CSW201
     C                   ENDIF                                                                CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'N' OR                                            CSW201
     C                             WChgInd <> 'Y'                                             CSW201
      *                                                                                       CSW201
      ** Account must exist in Midas
     C     *LOCK         IN        LDA
     C                   Movel     'SRCSID    '  DBFILE
     C                   Movel     OINST3        DBKEY
     C                   Z-Add     21            DBASE
     C                   OUT       LDA
     C                   Exsr      *PSSR
      *                                                                                       CSW201
     C                   ENDIF                                                                CSW201
     C                   Endif
     C                   If        BBCSID <> *BLANK
     C                   Eval      OINST1 = BBCSID
     C                   Else
     C                   If        CSW207 <> 'Y'                                             CSW207A
      ** Customer must have a SWIFT id
     C     *LOCK         IN        LDA
     C                   Movel     'SDCUSTPD'    DBFILE
     C                   Movel     BBCUST        DBKEY
     C                   Z-Add     22            DBASE
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif                                                               CSW207A
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed and customer has                              CSW201
      ** a SWIFT ID.                                                                          CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             Sav52Atype = 'A' AND                                       CSW201
     C                             WChgInd <> 'Y'                                             CSW201
      *                                                                                       CSW201
      ** Check if SWIFT ID exists in BIC directory                                            CSW201
      *                                                                                       CSW201
     C                   EVAL      Char18 = OINST1                                            CSW201
                                                                                              CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C     MEBICD        PARM      *BLANKS       DSSDY                                        CSW201
                                                                                              CSW202
     C                   IF        CSW202 = 'Y' AND @Type = '*BIC'                            CSW202
     C                   CALL      'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRetCode                                     CSW202
     C                   PARM      '*VERIFY'     POption                                      CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
      *                                                                                       CSW201
     C                   IF        @Type = '*BIC' AND                                         CSW201
     C                             (BDSUBT = 'BEID' OR                                        CSW201
     C                             BDSUBT = 'TRCO')                                           CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y' AND @Type = '*BIC'                        CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW202
     C                   EVAL      Sav52Atype = 'C'                                           CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201

     C                   If        Sav52AType = 'A'
     C                   Eval      WMTAG = ':52A:'
     C                   If        OINST3 <> *Blanks
     C**********         Eval      Q = Q + 1                                                BUG25937
     C*****Q****         Occur     MULT                                                     BUG25937
     C**********         Eval      MTAG = WMTAG                                             BUG25937
     C**********         Eval      WMTAG = *BLANK                                           BUG25937
     C**********         Eval      MFLD = OINST3                                            BUG25937
     C**********         Eval      Sav52A1 = OINST3                                         BUG25937
     C**********         Endif                                                              BUG25937
     C                   If        OINST1 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = WMTAG
     C                   Eval      MFLD = OINST1
     C**********         Eval      Sav52A2 = OINST1                                         BUG25937
     C                   Eval      Sav52A1 = OINST1                                         BUG25937
     C                   Endif
     C                   Endif                                                              BUG25937
     C                   Endif

     C                   If        Sav52AType = 'C'
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   IF        OINST3 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG = ':52C:'                                             CSW201
     C                   EVAL      MFLD = OINST3                                              CSW201
     C                   EVAL      Sav52A1 = OINST3                                           CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   IF        OINST1 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG = ':52C:'                                             CSW201
     C                   EVAL      MFLD = '/' + OINST1                                        CSW201
     C                   EVAL      Sav52A1 = OINST1                                           CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':52C:'
     C                   Eval      MFLD = OINST3
     C                   Eval      Sav52A1 = OINST3
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   Endif

     C                   IF        Sav52AType <> 'A'                                          CSW209
     C                   EVAL      W52A = 'N'                                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Endif

      * Transaction Type Code
     C                   If        TRNSTP <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':26T:'
     C                   Eval      MFLD = TRNSTP
     C                   Endif

      * Regulatory Reporting
     C                   If        REGRP1 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':77B:'
     C                   Eval      MFLD = REGRP1
     C                   Eval      RREGR1 = REGRP1
      *
     C                   If        REGRP2 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = REGRP2
     C                   Eval      RREGR2 = REGRP2
     C                   Endif
      *
     C                   If        REGRP3 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = REGRP3
     C                   Eval      RREGR3 = REGRP3
     C                   Endif
     C                   Endif
      *
      * Details of Charges
     C                   If        CCTCHG <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':71A:'
     C                   Eval      MFLD = CCTCHG
     C                   Eval      RDCHG= CCTCHG
     C                   Endif

      * HEADER Exchange Rate
     C                   If        CCTRTE <> *Zeros
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':36:'
      *
     C                   Call      'ZM0030'
     C                   Parm      CCTRTE        ZEXRT            13 8
     C                   Parm      *Blanks       ZSEXRT           12
     C                   Eval      MFLD = ZSEXRT
     C                   Eval      REXRAT = ZSEXRT
     C                   Endif

     C                   Endsr
      /EJECT
      *****************************************************************
      * SRMPTD - Map Transaction Details fields to MGOMSGPD fields    *
      *****************************************************************
      *
     C     SRMPTD        Begsr
      *
      * Transaction Reference
      *
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':21:'
     C                   Eval      MFLD = TRNSID

      * Transaction Amount
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':32B:'
      *
      * Currency
     C                   Eval      CCY32 = CCTCCY
     C                   Move      CCTCCY        WCCY              3
     C                   Eval      WAMNT = CCTAMT
     C                   Exsr      SRFAMT
     C                   Move      CDP           WCDP              1 0
     C                   Eval      AMNT32 = AMT
      *
     C                   Eval      MFLD = FLD32
      *
     C                   Eval      TOTTRN = TOTTRN + CCTAMT

      * Ordering Customer (Name and Address ONLY)

      * Check if Swift 2007 is ON and Customer is not blanks                                  CSW207
     C                   EVAL      PRTCD = 'A'                                               CSW207A
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                             AND ORDCU1 <> *BLANKS                                      CSW207
     C                             AND HOCDone <> 'Y'                                         CSW207
     C                   EVAL      ParmStr = *BLANKS                                          CSW207
     C                   IF        %SUBST(ORDCU1:1:1) = '/'                                   CSW207
     C                   EVAL      ParmStr = %SUBST(ORDCU1:2:34)                              CSW207
     C                   ELSE                                                                 CSW207
     C                   EVAL      ParmStr = ORDCU1                                           CSW207
     C                   ENDIF                                                                CSW207
                                                                                              CSW207
     C                   EVAL      PIN1 = ORDCU1                                             CSW207A
     C                   EVAL      PIN2 = ORDCU2                                             CSW207A
     C                   EVAL      PIN3 = ORDCU3                                             CSW207A
     C                   EVAL      PIN4 = ORDCU4                                             CSW207A
     C                   EVAL      PIN5 = ORDCU5                                             CSW207A
      * Call Format program                                                                   CSW207
     C                   EXSR      SRFORMAT                                                   CSW207
     C                   IF        MTAG = ':50F:'                                             CSW207
     C                   EVAL      ORDCU1 = POUT1                                             CSW207
     C                   EVAL      ORDCU2 = POUT2                                             CSW207
     C                   EVAL      ORDCU3 = POUT3                                             CSW207
     C                   EVAL      ORDCU4 = POUT4                                             CSW207
     C                   EVAL      ORDCU5 = POUT5                                             CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   If        HOCDone <> 'Y'
     C                             AND MTAG <> ':50F:'                                        CSW207
     C                             AND PRTCD <> *BLANKS                                      CSW207A

     C                   If        ORDCU1 <> *Blanks
     C                   MOVEL     CUSTTD        ISPTP
     C                   MOVEL     *BLANKS       ISPTY1A
     C                   MOVEL     ORDCU1        ISPTY1
     C                   MOVEL     ORDCU2        ISPTY2
     C                   MOVEL     ORDCU3        ISPTY3
     C                   MOVEL     ORDCU4        ISPTY4
     C                   MOVEL     *Blanks       ISPTY5
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   MOVEL     ORDCU5        ISPTY5                                       CSW207
     C                   ENDIF                                                                CSW207
     C                   MOVEL     ' '           IVTAG1
     C                   MOVEL     ' '           IVTAG2
     C                   MOVEL     'D'           IVTAG3
     C                   EXSR      SRCSID

      * If customer details not found

     C                   If        @RTCD <> *Blanks
     C                   Movel     ORDCU1        OFSPT1
     C                   Movel     ORDCU2        OFSPT2
     C                   Movel     ORDCU3        OFSPT3
     C                   Movel     ORDCU4        OFSPT4
     C                   Movel     *blanks       OFSPT5
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                   MOVEL     ORDCU5        OFSPT5                                       CSW207
     C                   ENDIF                                                                CSW207
     C                   Endif
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed and customer is                               CSW201
      ** existing.                                                                            CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             @RTCD = *BLANKS                                            CSW201
      *                                                                                       CSW201
      ** Check if SWIFT ID exists in BIC directory                                            CSW201
      *                                                                                       CSW201
     C                   IF        BBCSID <> *BLANKS                                          CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
                                                                                              CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C                   PARM                    DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        @TYPE = '*BIC'                                             CSW201
                                                                                              CSW201
     C                   IF        %SUBST(ORDCU1:1:1) = '/'                                   CSW201
     C                   EVAL      OFSPT1 = ORDCU1                                            CSW201
     C                   EVAL      OFSPT2 = BBCSID                                            CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      OFSPT1 = BBCSID                                            CSW201
     C                   EVAL      OFSPT2 = *BLANKS                                           CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   EVAL      OFSPT3 = *BLANKS                                           CSW201
     C                   EVAL      OFSPT4 = *BLANKS                                           CSW201
     C                   EVAL      OFSPT5 = *BLANKS                                           CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        BBCSID = *BLANKS OR                                        CSW201
     C                             @TYPE <> '*BIC'                                            CSW201
                                                                                              CSW201
     C                   IF        %SUBST(ORDCU1:1:1) = '/'                                   CSW201
     C                   EVAL      OFSPT1 = ORDCU1                                            CSW201
     C                   EVAL      OFSPT2 = BBCNA1                                            CSW201
     C                   EVAL      OFSPT3 = BBCNA2                                            CSW201
     C                   EVAL      OFSPT4 = BBCNA3                                            CSW201
     C                   EVAL      OFSPT5 = BBCNA4                                            CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      OFSPT1 = BBCNA1                                            CSW201
     C                   EVAL      OFSPT2 = BBCNA2                                            CSW201
     C                   EVAL      OFSPT3 = BBCNA3                                            CSW201
     C                   EVAL      OFSPT4 = BBCNA4                                            CSW201
     C                   EVAL      OFSPT5 = *BLANKS                                           CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201

     C                   If        OFSPT1<> *Blanks or OFSPT2<> *Blanks or
     C                             OFSPT3<> *Blanks or OFSPT4<> *Blanks

     C                   If        OFSPT1 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
      *
      ** If SWIFT 2001 is installed and BIC, format with :50A, if not BIC                     CSW201
      ** format with :50K.                                                                    CSW201
      *                                                                                       CSW201
     C                   SELECT                                                               CSW201
     C                   WHEN      CSW201 = 'N'                                               CSW201
     C                   Eval      MTAG = ':50:'
     C                   WHEN      @TYPE  = '*BIC'                                            CSW201
     C                   EVAL      MTAG = ':50A:'                                             CSW201
     C                   OTHER                                                                CSW201
     C                   EVAL      MTAG = ':50K:'                                             CSW201
     C                   ENDSL                                                                CSW201
                                                                                              CSW201
     C                   Eval      MFLD = OFSPT1
     C                   EVAL      TAG202 = MTAG                                              CSW209
     C                   EVAL      FLDCOV1 = MFLD                                             CSW209
     C                   Endif

     C                   If        OFSPT2<> *Blanks
     C                   Eval      Q = Q +1
     C     Q             Occur     MULT
     C                   Eval      MFLD = OFSPT2
     C                   EVAL      FLDCOV2 = MFLD                                             CSW209
     C                   Endif
      *
     C                   If        OFSPT3 <> *Blanks
     C                   Eval      Q = Q +1
     C     Q             Occur     MULT
     C                   Eval      MFLD = OFSPT3
     C                   EVAL      FLDCOV3 = MFLD                                             CSW209
     C                   Endif
      *
     C                   If        OFSPT4 <> *Blanks
     C                   Eval      Q = Q +1
     C     Q             Occur     MULT
     C                   Eval      MFLD = OFSPT4
     C                   EVAL      FLDCOV4 = MFLD                                             CSW209
     C                   Endif
                                                                                              CSW201
     C                   If        OFSPT5 <> *Blanks                                          CSW201
     C                   Eval      Q = Q +1                                                   CSW201
     C     Q             Occur     MULT                                                       CSW201
     C                   Eval      MFLD = OFSPT5                                              CSW201
     C                   EVAL      FLDCOV5 = MFLD                                             CSW209
     C                   Endif                                                                CSW201
                                                                                              CSW201
     C                   EXSR      GetEXTN                                                  BUG19322
     C                   Endif
     C                   Endif
     C                   Endif
      *
      * Ordering Institution
      *
      ** Ordering institution (11 chars)
      ** can only be a BIC or a customer number
     C                   If        ORDI11 <> *Blanks OR
     C                             ORDI35 <> *Blanks

     C                   Eval      Sav52A1 = *Blanks
     C                   Eval      Sav52A2 = *Blanks
     C                   Eval      Sav52AType = *Blanks
     C                   If        ORDI11 <> *Blanks
     C                   Eval      Sav52AType = 'A'
     C                   Eval      Char18 = ORDI11
     C                   CallB     'AOBICDV0'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18           18
     C                   Parm                    @Type
     C                   Parm                    DSSDY

      ** If not a Bic then convert the customer number into a BIC
      ** (and override field)
     C                   If        @Type <> '*BIC'
     C                   Eval      LigArg = ORDI11
     C                   Exsr      RtvCus
     C                   If        NoCust = 'NF'
     C                             AND CSW207 <> 'Y'                                         CSW207A
      ** Customer must exist in Midas
     C     *LOCK         IN        LDA
     C                   Movel     'SDCUSTPD'    DBFILE
     C                   Movel     ORDI11        DBKEY
     C                   Z-Add     20            DBASE
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Else
     C                   If        LigSwift <> *BLANK
     C                   Eval      ORDI11 = LigSwift
     C                   Else
     C                   If        CSW207 <> 'Y'                                             CSW207A
      ** Customer must have a SWIFT address
     C     *LOCK         IN        LDA
     C                   Movel     'SDCUSTPD'    DBFILE
     C                   Movel     BBCUST        DBKEY
     C                   Z-Add     20            DBASE
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif                                                               CSW207A
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif

      ** Ordering institution (35 chars)
      ** can only be a clearing code or an account
      ** if not a clearing code and no SWIFT id entered
      ** then convert the account into a SWIFT
      ** (put the result in ORDI11 supposed to be blank)
      *                                                                                       CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
                                                                                              CSW201
     C                   If        ORDI35 <> *Blanks
     C                   If        %subst(ORDI35:1:1) <> '/'
     C                   Eval      ORDI35 = '/' + ORDI35
     C                   Endif
     C                   If        %subst(ORDI35:1:2) = '//'
     C                   If        ORDI11 = *BLANK
     C                   Eval      Sav52AType = 'C'
     C                   Endif
     C                   Else
     C                   If        ORDI11 = *BLANK
     C                   Eval      Sav52AType = 'A'
     C                   MOVEL     ORDITP        ISPTP
     C                   MOVEL     *BLANKS       ISPTY1A
     C                   MOVEL     ORDI35        ISPTY1
     C                   MOVEL     *BLANKS       ISPTY2
     C                   MOVEL     *BLANKS       ISPTY3
     C                   MOVEL     *BLANKS       ISPTY4
     C                   MOVEL     *BLANKS       ISPTY5
     C                   MOVEL     'A'           IVTAG1
     C                   MOVEL     ' '           IVTAG2
     C                   MOVEL     ' '           IVTAG3
     C                   EXSR      SRCSID
     C                   If        NoCust = 'NF'
      *                                                                                       CSW201
      ** If not found, check if second line is BIC.                                           CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      Char18 = %SUBST(ORDI35:2)                                  CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C     MEBICD        PARM      *BLANKS       DSSDY                                        CSW201
      *                                                                                       CSW201
     C                   IF        @Type = '*BIC'                                             CSW201
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   CALL      'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRetCode                                     CSW202
     C                   PARM      '*VERIFY'     POption                                      CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
     C                   IF        (BDSUBT = 'BEID' OR                                        CSW201
     C                             BDSUBT = 'TRCO')                                           CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y'                                           CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW202
     C                   EVAL      Sav52Atype = 'C'                                           CSW201
     C                   ENDIF                                                                CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'N' OR                                            CSW201
     C                             WChgInd <> 'Y'                                             CSW201
      *                                                                                       CSW201
      ** Account must exist in Midas
     C     *LOCK         IN        LDA
     C                   Movel     'SRCSID    '  DBFILE
     C                   Movel     ORDI35        DBKEY
     C                   Z-Add     21            DBASE
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   Endif
     C                   If        BBCSID <> *BLANK
     C                   Eval      ORDI11 = BBCSID
     C                   Else
     C                   If        CSW207 <> 'Y'                                             CSW207A
      ** Customer must have a SWIFT id
     C     *LOCK         IN        LDA
     C                   Movel     'SDCUSTPD'    DBFILE
     C                   Movel     BBCUST        DBKEY
     C                   Z-Add     22            DBASE
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif                                                               CSW207A
     C                   Endif
     C                   Endif
     C                   Endif
     C                   Endif
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed and customer has                              CSW201
      ** a SWIFT ID                                                                           CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             Sav52Atype = 'A' AND                                       CSW201
     C                             WChgInd <> 'Y'                                             CSW201
                                                                                              CSW201
     C                   EVAL      Char18 = ORDI11                                            CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C     MEBICD        PARM      *BLANKS       DSSDY                                        CSW201
                                                                                              CSW202
     C                   IF        CSW202 = 'Y' AND @Type = '*BIC'                            CSW202
     C                   CALL      'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRetCode                                     CSW202
     C                   PARM      '*VERIFY'     POption                                      CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
      *                                                                                       CSW201
     C                   IF        @Type = '*BIC' AND                                         CSW201
     C                             (BDSUBT = 'BEID' OR                                        CSW201
     C                             BDSUBT = 'TRCO')                                           CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y' AND @Type = '*BIC'                        CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW202
     C                   EVAL      Sav52Atype = 'C'                                           CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201

     C                   If        Sav52AType = 'A'
     C                   Eval      WMTAG = ':52A:'
     C                   If        ORDI35 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = WMTAG
     C                   Eval      WMTAG = *BLANK
     C                   Eval      MFLD = ORDI35
     C                   Eval      Sav52A1 = ORDI35
     C                   Endif
     C                   If        ORDI11 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = WMTAG
     C                   Eval      MFLD = ORDI11
     C                   Eval      Sav52A2 = ORDI11
     C                   Endif
     C                   Endif

     C                   If        Sav52AType = 'C'
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   IF        ORDI35 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG = ':52C:'                                             CSW201
     C                   EVAL      MFLD = ORDI35                                              CSW201
     C                   EVAL      Sav52A1 = ORDI35                                           CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   IF        ORDI11 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG = ':52C:'                                             CSW201
     C                   EVAL      MFLD = '/' + ORDI11                                        CSW201
     C                   EVAL      Sav52A1 = ORDI11                                           CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':52C:'
     C                   Eval      MFLD = ORDI35
     C                   Eval      Sav52A1 = ORDI35
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   Endif

     C**********         IF        Sav52AType = 'A'                                  CSW209 MD023793
     C                   IF        Sav52AType <> 'A'                                        MD023793
     C                   EVAL      W52A = 'N'                                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Endif

      *
      * Account with Institution
     C                   If        ACCI35 <> *Blanks   OR
     C                             ACCI11 <> *Blanks

     C                   If        ACCI11 <> *Blanks
      * Is the second field a BIC ?
     C                   Eval      Char18 = ACCI11
     C                   CallB     'AOBICDV0'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18           18
     C                   Parm                    @Type
     C                   Parm                    DSSDY

     C                   If        @Type = '*BIC'
                                                                                              CSW201
     C                             OR CSW201 = 'Y' AND                                        CSW201
     C                             RetCodeIn = '*BICFND'                                      CSW201
                                                                                              CSW201
     C                   EVAL      WACCI = ACCI11                                             CSW209
     C                   EVAL      WAccIn = %SUBST(BDBICC:5:2)                                CSW209
                                                                                              CSW209
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
      *                                                                                       CSW201
     C                   IF        RetCodeIn = '*BICFND'                                      CSW201
     C                   EVAL      SDCUST = DSSDY                                             CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C                   PARM                    DSSDY                                        CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   EVAL      MEBICD = DSSDY                                             CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   CALL      'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRetCode                                     CSW202
     C                   PARM      '*VERIFY'     POption                                      CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
      *                                                                                       CSW201
      ** subtype is 'BEID' or 'TRCO'                                                          CSW201
      *                                                                                       CSW201
     C**********         IF        BDSUBT = 'BEID' OR                                  CSW201 CSW202
     C**********                   BDSUBT = 'TRCO'                                     CSW201 CSW202
                                                                                              CSW202
     C                   IF        (BDSUBT = 'BEID' OR                                        CSW202
     C                             BDSUBT = 'TRCO')                                           CSW202
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y'                                           CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW202
     C                   EVAL      MTAG = ':57C:'                                             CSW201
     C                   IF        ACCI35 <> *BLANKS                                          CSW201
     C                   EVAL      MFLD = ACCI35                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      MFLD = '/' + ACCI11                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   IF        CSW209 = 'Y'                                             BUG24806
     C                   EVAL      Sav57aType = 'C'                                         BUG24806
     C                   EVAL      Sav57a = MFLD                                            BUG24806
     C                   ENDIF                                                              BUG24806
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             WChgInd <> 'Y' OR                                          CSW201
     C                             CSW201 <> 'Y'                                              CSW201
     C                   Eval      MTAG = ':57A:'
     C                   IF        ACCI35 <> *BLANKS                                        MD034390
     C                   EVAL      MFLD = ACCI35                                            MD034390
     C                   ENDIF                                                              MD034390
     C                   IF        ACCI11 <> *BLANKS                                        MD034390
     C                   IF        ACCI35 <> *BLANKS                                        MD035625
     C                   EVAL      Q = Q + 1                                                MD034390
     C     Q             Occur     MULT                                                     MD034390
     C                   ENDIF                                                              MD035625
     C**********         Eval      MFLD = ACCI11                                            MD034390
     C                   EVAL      MFLD = BBCSID                                            MD034390
     C                   ENDIF                                                              MD034390
     C                   IF        CSW209 = 'Y'                                             BUG24806
     C                   EVAL      Sav57aType = 'A'                                         BUG24806
     C                   EVAL      Sav57a = MFLD                                            BUG24806
     C                   ENDIF                                                              BUG24806
     C                   ENDIF                                                                CSW201

      * Not a Bic.  Just move in first field
     C                   Else

     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':57C:'
     C                   Eval      MFLD = ACCI35
     C                   IF        CSW209 = 'Y'                                             BUG24806
     C                   EVAL      Sav57aType = 'C'                                         BUG24806
     C                   EVAL      Sav57a = MFLD                                            BUG24806
     C                   ENDIF                                                              BUG24806
      *
     C                   Endif
     C                   Endif
                                                                                              CSW209
     C                   IF        WACCI = *BLANKS                                            CSW209
     C                   EVAL      W57A = 'N'                                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Endif
      *
      * Beneficiary Customer.  can be 4 lines of name and address ONLY .
      *                        can be 5 lines if first line starts with /.
      *
     C                   If        BENF1  <> *Blanks
     C                   MOVEL     BENTTD        ISPTP
     C                   MOVEL     *BLANKS       ISPTY1A

     C                   Eval      OFSPT1 = *BLANK
     C                   Eval      OFSPT2 = *BLANK
     C                   Eval      OFSPT3 = *BLANK
     C                   Eval      OFSPT4 = *BLANK
     C                   Eval      OFSPT5 = *BLANK
      *                                                                                       CSW215
      ** SWIFT 2015 change for :59F:                                                          CSW215
      *                                                                                       CSW215
     C                   EVAL      Wrk59F = 'N'                                               CSW215
     C                   IF        CSW215 = 'Y'                                               CSW215
     C                   EXSR      SRFormat59F                                                CSW215
     C                   ENDIF                                                                CSW215

     C                   IF        Wrk59F = 'N'                                               CSW215
     C                   EVAL      WChgInd = 'N'                                              CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   MOVEL     BENF1         ISPTY1                                       CSW201
     C                   MOVEL     BENF2         ISPTY2                                       CSW201
     C                   MOVEL     BENF3         ISPTY3                                       CSW201
     C                   MOVEL     BENF4         ISPTY4                                       CSW201
     C                   MOVEL     *Blanks       ISPTY5                                       CSW201
     C                   MOVEL     ' '           IVTAG1                                       CSW201
     C                   MOVEL     ' '           IVTAG2                                       CSW201
     C                   MOVEL     'D'           IVTAG3                                       CSW201
     C                   EXSR      SRCSID                                                     CSW201
      *                                                                                       CSW201
      ** If customer is existing, check if SWIFT ID is existing                               CSW201
      ** in BIC directory.                                                                    CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = *BLANKS AND                                        CSW201
     C                             BBCSID <> *BLANKS                                          CSW201
                                                                                              CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C                   PARM                    DSSDY                                        CSW201
      *                                                                                       CSW201
     C                   IF        @TYPE = '*BIC'                                             CSW201
     C                   EVAL      OFSPT1 = BENF1                                             CSW201
     C                   EVAL      OFSPT2 = BBCSID                                            CSW201
     C                   EVAL      OFSPT3 = *BLANKS                                           CSW201
     C                   EVAL      OFSPT4 = *BLANKS                                           CSW201
     C                   EVAL      OFSPT5 = *BLANKS                                           CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Perform normal formatting if SWIFT 2001 is not installed or                          CSW201
      ** customer has no BIC id.                                                              CSW201
      *                                                                                       CSW201
     C                   IF        WChgInd = 'N'                                              CSW201
     C                   If        %Subst(BENF1:1:1) = '/'
     C                   Eval      OFSPT1 = BENF1
     C                   Eval      LigArg = BENF2
     C                   Exsr      RtvCus
     C                   IF        NoCust <>'NF'
      *                                                                                       CSW201
      ** If second line contains customer, check if BIC.                                      CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C                   PARM                    DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        @TYPE = '*BIC'                                             CSW201
     C                   EVAL      OFSPT1 = BENF1                                             CSW201
     C                   EVAL      OFSPT2 = BBCSID                                            CSW201
     C                   EVAL      OFSPT3 = *BLANKS                                           CSW201
     C                   EVAL      OFSPT4 = *BLANKS                                           CSW201
     C                   EVAL      OFSPT5 = *BLANKS                                           CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   Else                                                               BUG15274
      *                                                                                     BUG15274
     C                   If        BENTTD = 'C'                                             BUG15274
     C                             And BENF2 <> *Blanks                                     BUG15274
     C                             Or BENTTD = 'A'                                          BUG15274
     C                   Eval      OFSPT2 = BENF2                                           BUG15274
     C                   Eval      OFSPT3 = BENF3                                           BUG15274
     C                   Eval      OFSPT4 = BENF4                                           BUG15274
     C                   Eval      OFSPT5 = BENF5                                           BUG15274
     C                   EndIf                                                              BUG15274
      *                                                                                     BUG15274
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   Eval      OFSPT2 = LigCus1
     C                   Eval      OFSPT3 = LigCus2
     C                   Eval      OFSPT4 = LigCus3
     C                   Eval      OFSPT5 = LigCus4
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   Else
     C                   Eval      OFSPT2 = BENF2
     C                   Eval      OFSPT3 = BENF3
     C                   Eval      OFSPT4 = BENF4
     C                   Eval      OFSPT5 = BENF5
     C                   Endif
     C                   Else
     C                   Eval      LigArg = BENF1
     C                   Exsr      RtvCus
     C                   IF        NoCust <>'NF'
     C                   Eval      OFSPT1 = LigCus1
     C                   Eval      OFSPT2 = LigCus2
     C                   Eval      OFSPT3 = LigCus3
     C                   Eval      OFSPT4 = LigCus4
     C                   Else
     C                   Eval      OFSPT1 = BENF1
     C                   Eval      OFSPT2 = BENF2
     C                   Eval      OFSPT3 = BENF3
     C                   Eval      OFSPT4 = BENF4
     C                   Endif
     C                   Endif
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW215

     C                   IF        OFSPT1 <> *Blanks or
     C                             OFSPT2 <> *Blanks or
     C                             OFSPT3 <> *Blanks or
     C                             OFSPT4 <> *Blanks
      *
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
      *                                                                                       CSW215
      ** :59F: for SWIFT 2015                                                                 CSW215
      *                                                                                       CSW215
     C                   IF        Wrk59F = 'Y'                                               CSW215
     C                   EVAL      MTAG = ':59F:'                                             CSW215
     C                   ELSE                                                                 CSW215
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed and BIC, format with :59A. Otherwise                      CSW201
      ** format with no letter option.                                                        CSW201
     C                   IF        WChgInd = 'N'                                              CSW201
     C                   Eval      MTAG = ':59:'
     C                   ELSE                                                                 CSW201
     C                   Eval      MTAG = ':59A:'                                             CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW215
     C                   Eval      MFLD = OFSPT1
     C                   EVAL      TAG202B = MTAG                                             CSW209
     C                   EVAL      FLDCOVB1 = MFLD                                            CSW209
      *
     C                   IF        %SUBST(OFSPT1:1:1) <> '/'                                  CSW209
     C                   MOVE      'N'           W59A                                         CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   If        OFSPT2 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = OFSPT2
     C                   EVAL      FLDCOVB2 = MFLD                                            CSW209
     C                   Else
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = 'NO FURTHER DETAILS'
     C                   EVAL      FLDCOVB2 = MFLD                                            CSW209
     C                   Endif
      *
     C                   If        OFSPT3 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = OFSPT3
     C                   EVAL      FLDCOVB3 = MFLD                                            CSW209
     C                   Endif
      *
     C                   If        OFSPT4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = OFSPT4
     C                   EVAL      FLDCOVB4 = MFLD                                            CSW209
     C                   Endif
      *
     C                   If        OFSPT5 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = OFSPT5
     C                   EVAL      FLDCOVB5 = MFLD                                            CSW209
     C                   Endif

     C                   Endif

     C                   Endif

      * Remittance Information
     C                   If        REMI1 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':70:'
     C                   Eval      MFLD = REMI1
     C                   Endif

     C                   If        REMI2 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = REMI2
     C                   Endif

     C                   If        REMI3 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = REMI3
     C                   Endif

     C                   If        REMI4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = REMI4
     C                   Endif

      * Transaction Type Code
     C                   If        CCTTYC <> *Blanks  AND
     C                             TRNSTP = *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':26T:'
     C                   Eval      MFLD = CCTTYC
     C                   Endif

      * Regulatory Reporting
     C                   If        REGRP1 <> *Blanks
     C                   Eval      Q=Q+1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':77B:'
     C                   Eval      MFLD = REGRP1
     C                   Endif

     C                   If        REGRP2 <> *Blanks
     C                   Eval      Q=Q+1
     C     Q             Occur     MULT
     C                   Eval      MFLD = REGRP2
     C                   Endif

     C                   If        REGRP3 <> *Blanks
     C                   Eval      Q=Q+1
     C     Q             Occur     MULT
     C                   Eval      MFLD = REGRP3
     C                   Endif
      *
      * Currency/Original Ordered Amount
      * Mandatory if X currency conversion has taken place
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      WDCnCdFn = 'N'                                             CSW201
     C                   EVAL      WSCnCdFn = 'N'                                             CSW201
     C                   EVAL      Output33B = 'N'                                            CSW201
      *                                                                                       CSW201
      ** Check if destination is a BIC                                                        CSW201
      *                                                                                       CSW201
     C                   EVAL      Char18 = CCTDST                                            CSW201
                                                                                              CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C                   PARM                    DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        @Type = '*BIC'                                             CSW201
     C                   EVAL      WDEST = CCTDST                                             CSW201
     C                   ELSE                                                                 CSW201
      *                                                                                       CSW201
      ** Check for account type                                                               CSW201
     C                   CALLB     'AOACCTV1'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
     C                   PARM      *BLANKS       @Type                                        CSW201
     C                   PARM                    CCTDST                                       CSW201
     C                   PARM                    DSSDY                                        CSW201
                                                                                              CSW201
     C                   SELECT                                                               CSW201
     C                   WHEN      @Type = 'IBAN'                                             CSW201
     C                   EVAL      ISPTP = 'I'                                                CSW201
     C                   WHEN      @Type = '*LEDGER'                                          CSW201
     C                   EVAL      ISPTP = 'G'                                                CSW201
     C                   WHEN      @Type = '*NOSTRO'                                          CSW201
     C                   EVAL      ISPTP = 'F'                                                CSW201
     C                   WHEN      @Type = '*RETAIL'                                          CSW201
     C                   EVAL      ISPTP = 'R'                                                CSW201
     C                   OTHER                                                                CSW201
     C                   EVAL      ISPTP = *BLANK                                             CSW201
     C                   ENDSL                                                                CSW201
                                                                                              CSW201
     C                   EVAL      ISPTY1A = *BLANKS                                          CSW201
     C                   EVAL      ISPTY1 = CCTDST                                            CSW201
     C                   EVAL      ISPTY2 = *BLANKS                                           CSW201
     C                   EVAL      ISPTY3 = *BLANKS                                           CSW201
     C                   EVAL      ISPTY4 = *BLANKS                                           CSW201
     C                   EVAL      ISPTY5 = *BLANKS                                           CSW201
     C                   EVAL      IVTAG1 = ' '                                               CSW201
     C                   EVAL      IVTAG2 = ' '                                               CSW201
     C                   EVAL      IVTAG3 = ' '                                               CSW201
                                                                                              CSW201
     C                   EXSR      SRCSID                                                     CSW201
                                                                                              CSW201
     C                   IF        @RTCD = *BLANKS AND                                        CSW201
     C                             BBCSID <> *BLANKS                                          CSW201
     C                   EVAL      WDEST = BBCSID                                             CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If destination and sender ID is entered                                              CSW201
      *                                                                                       CSW201
     C                   IF        WDEST <> *BLANKS AND                                       CSW201
     C                             STID <> *BLANKS                                            CSW201
      *                                                                                       CSW201
     C                   EVAL      WDCnCdFn = 'N'                                             CSW201
     C                   EVAL      WSCnCdFn = 'N'                                             CSW201
      *                                                                                       CSW201
      ** Get the country code of destination                                                  CSW201
      *                                                                                       CSW201
     C                   EVAL      Char18 = WDEST                                             CSW201
                                                                                              CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *Blanks       RetCodeIn                                    CSW201
     C                   PARM                    Char18           18                          CSW201
     C                   PARM                    @Type                                        CSW201
     C     MEBICD        PARM      *BLANKS       DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        @Type = '*BIC'                                             CSW201
     C                   EVAL      WDCnCd = %SUBST(BDBICC:5:2)                                CSW201
      *                                                                                       CSW201
      ** Check if destination country code exists in ISO country code                         CSW201
      ** table. If found, check if 'Supports Charges Transparency'                            CSW201
      ** flag is 'Y'.                                                                         CSW201
      *                                                                                       CSW201
     C     WDCnCd        CHAIN     MEISOCL1                           27                      CSW201
     C**********         IF        *IN27 = *OFF AND                                  CSW201 MD023793
     C**********                   M3SCHT = 'Y'                                      CSW201 MD023793
     C                   IF        *IN27 = *OFF                                             MD023793
     C                   IF        M3SCHT = 'Y' AND                                         MD023793
     C                             CSW213 = 'N' OR                                          MD023793
     C                             M3IBAR = 'Y' AND                                         MD023793
     C                             CSW213 = 'Y'                                             MD023793
     C                   EVAL      WDCnCdFn = 'Y'                                             CSW201
     C                   ENDIF                                                              MD023793
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Get the country code of sender ID                                                    CSW201
      *                                                                                       CSW201
     C                   EVAL      Char18 = %SUBST(STID:1:8) +                                CSW201
     C                                      %SUBST(STID:10:3)                                 CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *Blanks       RetCodeIn                                    CSW201
     C                   PARM                    Char18           18                          CSW201
     C                   PARM                    @Type                                        CSW201
     C                   PARM                    DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        @Type = '*BIC'                                             CSW201
     C                   EVAL      MEBICD = DSSDY                                           BUG24748
     C                   EVAL      WSCnCd = %SUBST(BDBICC:5:2)                                CSW201
      *                                                                                       CSW201
      ** Check if sender ID country code exists in ISO country code                           CSW201
      ** table. If found, check if 'Supports Charges Transparency'                            CSW201
      ** flag is 'Y'.                                                                         CSW201
      *                                                                                       CSW201
     C     WSCnCd        CHAIN     MEISOCL1                           27                      CSW201
     C**********         IF        *IN27 = *OFF AND                                  CSW201 MD023793
     C**********                   M3SCHT = 'Y'                                      CSW201 MD023793
     C                   IF        *IN27 = *OFF                                             MD023793
     C                   IF        M3SCHT = 'Y' AND                                         MD023793
     C                             CSW213 = 'N' OR                                          MD023793
     C                             M3IBAR = 'Y' AND                                         MD023793
     C                             CSW213 = 'Y'                                             MD023793
     C                   EVAL      WSCnCdFn = 'Y'                                             CSW201
     C                   ENDIF                                                              MD023793
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Both destination and sender ID country codes exists in ISO                           CSW201
      ** country Code table with 'Supports Charges Transparency'                              CSW201
      ** flag set to 'Y'                                                                      CSW201
      *                                                                                       CSW201
     C                   IF        WDCnCdFn = 'Y' AND                                         CSW201
     C                             WSCnCdFn = 'Y'                                             CSW201
     C                   EVAL      Output33B = 'Y'                                            CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        Output33B <> 'Y' AND                                       CSW201
     C                             (SNDCCY <> *BLANKS OR                                      CSW201
     C                             RCVCCY <> *BLANKS)                                         CSW201
     C                   EVAL      Output33B = 'Y'                                            CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C**********         If        PAYCCY <> CCTCCY                                           CSW201
                                                                                              CSW201
     C                   IF        PAYCCY <> CCTCCY OR                                        CSW201
     C                             CSW201 = 'Y' AND                                           CSW201
     C                             Output33B = 'Y'                                            CSW201
                                                                                              CSW201
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':33B:'
     C                   Eval      CCY33 = PAYCCY
     C                   Eval      WCCY = PAYCCY
     C                   Eval      WAMNT = PAYAMT
     C                   Exsr      SRFAMT
     C                   Eval      AMNT33 = AMT
     C                   Eval      MFLD = FLD33
     C                   Endif

     C                   IF        WACCI <> *BLANKS                                           CSW209
     C                   EVAL      WAccInFn = 'N'                                             CSW209
      *                                                                                       CSW209
      ** Check if Account with instituion country code exists in ISO                          CSW209
      ** country code table. If found, check if 'Supports Charges                             CSW209
      ** Transparency' flag is 'Y'.                                                           CSW209
      *                                                                                       CSW209
     C     WAccIn        CHAIN     MEISOCL1                           27                      CSW209
     C**********         IF        *IN27 = *OFF AND                                  CSW209 MD023793
     C**********                   M3SCHT = 'Y'                                        CSW209 CSW213
     C**********                   M3IBAR = 'Y'                                      CSW213 MD023793
     C                   IF        *IN27 = *OFF                                             MD023793
     C                   IF        M3SCHT = 'Y' AND                                         MD023793
     C                             CSW213 = 'N' OR                                          MD023793
     C                             M3IBAR = 'Y' AND                                         MD023793
     C                             CSW213 = 'Y'                                             MD023793
     C                   EVAL      WAccInFn = 'Y'                                             CSW209
     C                   ENDIF                                                              MD023793
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   MOVE      'N'           WIBANF            1                          CSW209
     C                   IF        CFT004 = 'Y'                                               CSW209
     C                   EXSR      SRIBAN                                                     CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        WDCnCdFn = 'Y' AND                                         CSW209
     C                             WSCnCdFn = 'Y'                                             CSW209
     C**********         IF        W57A = 'Y' OR                                     CSW209 MD023793
     C                   IF        W57A = 'N' OR                                            MD023793
     C                             (W57A = 'Y' AND WAccInFn = 'Y')                            CSW209
     C**********         IF        WIBANF <> 'Y'                                       CSW209 CSW213
     C**********         IF        WIBANF <> 'Y' AND M3IBAR <> 'Y'                   CSW213 MD023793
     C                   IF        WIBANF <> 'Y'                                            MD023793
     C                   MOVE      'N'           W59A                                         CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      * Details of Charges
     C                   If        CCYCHG <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':71A:'
     C                   Eval      MFLD = CCYCHG

     C                   If        CCYCHG <> 'OUR'
     C                   Eval      ShowRSum = 'N'
     C                   Endif

     C                   Endif

      * Sender's Charges/Amount in transaction currency
     C                   If        SNDCTF <> *Zeros  AND
     C                             CCYCHG = 'BEN'    OR
     C                             SNDCTF <> *Zeros  AND
     C                             CCTCHG = 'BEN'
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed, also format if                               CSW201
      ** at least one sender charge is entered.                                               CSW201
      *                                                                                       CSW201
     C                             OR CSW201 = 'Y' AND                                        CSW201
     C                             SNDCCY <> *BLANKS                                          CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
      *                                                                                       CSW201
      ** Setup senders charges currency array                                                 CSW201
     C                   EVAL      WArSndCcy(1) = SNDCCY                                      CSW201
     C                   EVAL      WArSndCcy(2) = SDCCY2                                      CSW201
     C                   EVAL      WArSndCcy(3) = SDCCY3                                      CSW201
     C                   EVAL      WArSndCcy(4) = SDCCY4                                      CSW201
     C                   EVAL      WArSndCcy(5) = SDCCY5                                      CSW201
      *                                                                                       CSW201
      ** Setup senders charges array                                                          CSW201
     C                   EVAL      WArSndChg(1) = SNDCHG                                      CSW201
     C                   EVAL      WArSndChg(2) = SDCHG2                                      CSW201
     C                   EVAL      WArSndChg(3) = SDCHG3                                      CSW201
     C                   EVAL      WArSndChg(4) = SDCHG4                                      CSW201
     C                   EVAL      WArSndChg(5) = SDCHG5                                      CSW201
      *                                                                                       CSW201
      ** Setup senders charges in transfer currency array                                     CSW201
     C                   EVAL      WArSndChgT(1) = SNDCTF                                     CSW201
     C                   EVAL      WArSndChgT(2) = SDCTF2                                     CSW201
     C                   EVAL      WArSndChgT(3) = SDCTF3                                     CSW201
     C                   EVAL      WArSndChgT(4) = SDCTF4                                     CSW201
     C                   EVAL      WArSndChgT(5) = SDCTF5                                     CSW201
      *                                                                                       CSW201
      ** Determine the last non-blank senders charges currency                                CSW201
      ** (Assuming that SNDCHG could not be blank when details of                             CSW201
      ** charges is equal to 'BEN')                                                           CSW201
      *                                                                                       CSW201
     C                   EVAL      Wy = 1                                                     CSW201
                                                                                              CSW201
     C     *BLANKS       LOOKUP    WArSndCcy(Wy)                          28                  CSW201
      *                                                                                       CSW201
      ** If all sender's charges entered, set index to 6.                                     CSW201
     C                   IF        *IN28 = *OFF                                               CSW201
     C                   EVAL      Wy = 6                                                     CSW201
     C                   ENDIF                                                                CSW201
     C                   EVAL      Wz = Wy - 2                                                CSW201
     C                   EVAL      Wl = Wy - 1                                                CSW201
     C                   EVAL      Wc = 1                                                     CSW201
      *                                                                                       CSW201
      ** Sender charges 2 and above is blank                                                  CSW201
      *                                                                                       CSW201
     C                   IF        Wz = 0                                                     CSW201
                                                                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG   = ':71F:'                                           CSW201
     C                   EVAL      CCY71  = CCTCCY                                            CSW201
     C                   EVAL      WCCY   = CCTCCY                                            CSW201
     C                   EVAL      WAMNT  = WArSndChgT(Wl)                                    CSW201
     C                   EXSR      SRFAMT                                                     CSW201
     C                   EVAL      AMNT71 = AMT                                               CSW201
     C                   EVAL      MFLD   = FLD71                                             CSW201
      *                                                                                       CSW201
      **  Sender charges 2 is not blank                                                       CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG   = ':71F:'                                           CSW201
                                                                                              CSW201
     C                   DO        Wz                                                         CSW201
                                                                                              CSW201
     C                   IF        Wc > 1                                                     CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG   = ':71F:'                                           CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   EVAL      CCY71  = WArSndCcy(Wc)                                     CSW201
     C                   EVAL      WCCY   = WArSndCcy(Wc)                                     CSW201
     C                   EVAL      WAMNT  = WArSndChg(Wc)                                     CSW201
     C                   EXSR      SRFAMT                                                     CSW201
     C                   EVAL      AMNT71 = AMT                                               CSW201
     C                   EVAL      MFLD   = FLD71                                             CSW201
                                                                                              CSW201
     C                   EVAL      Wc = Wc + 1                                                CSW201
     C                   ENDDO                                                                CSW201
                                                                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG   = ':71F:'                                           CSW201
     C                   EVAL      CCY71  = CCTCCY                                            CSW201
     C                   EVAL      WCCY   = CCTCCY                                            CSW201
     C                   EVAL      WAMNT  = WArSndChgT(Wl)                                    CSW201
     C                   EXSR      SRFAMT                                                     CSW201
     C                   EVAL      AMNT71 = AMT                                               CSW201
     C                   EVAL      MFLD   = FLD71                                             CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG   = ':71F:'
     C                   Eval      CCY71  = CCTCCY
     C                   Eval      WCCY   = CCTCCY
     C                   Eval      WAMNT  = SNDCTF
     C                   Exsr      SRFAMT
     C                   Eval      AMNT71 = AMT
     C                   Eval      MFLD   = FLD71
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   Endif

      * Receivers Charges
     C                   Eval      FLD71 = *Blanks
     C                   If        RCVCTF <> 0    AND
     C                             CCYCHG = 'OUR' OR
     C                             RCVCTF <> 0    AND
     C                             CCTCHG = 'OUR'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':71G:'
     C                   Eval      CCY71 = CCTCCY
     C                   Eval      WCCY  = CCTCCY
     C                   Eval      WAMNT = RCVCTF
     C                   Exsr      SRFAMT
     C                   Eval      AMNT71 = AMT
     C                   Eval      MFLD = FLD71
     C                   Endif

      * Exchange Rate
      * C5 + C7 of swift manual.
     C                   If        PAYCCY <> CCTCCY   AND
     C                             CCTRTE =  *Zeros
     C                   Eval      Q=Q+1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':36:'

     C                   Call      'ZM0030'
     C                   Parm      XRATE         ZEXRT            13 8
     C                   Parm      *Blanks       ZSEXRT           12
     C                   Eval      MFLD = ZSEXRT

     C                   Endif
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * SRMPST - Map Settlement Details fields to MGOMSGPD fields     *
      *****************************************************************
      *
     C     SRMPST        Begsr
      *
      *  Convert run date to YYMMDD
      *
     C                   Call      'ZM0060'
     C                   Parm      TTVDTE        ZMDAY             5 0
     C                   Parm                    ZMDATE            6
     C                   Move      ZMDATE        VDAT32A
     C                   Move      CCTCCY        CCY32A
     C                   Eval      WCCY = CCTCCY
      *
      * Sum of amounts including receivers charges
      *
     C                   Eval      Q = Q+1
     C     Q             Occur     MULT
     C                   Eval      WAMNT = SAVSUMAMT
     C                   Exsr      SRFAMT
     C                   Move      AMT           AMNT32A
     C                   Eval      MTAG = ':32A:'
     C                   Eval      MFLD = FLD32A
     C                   Eval      Sav32A = MFLD
     C
      * Sum of Amounts :19:
     C                   If        SUMCCT <> *Zeros AND
     C                             SUMCCT <> SAVSUMAMT
     C                   Eval      WAMNT = SUMCCT

     C                   Eval      WCCY = CCTCCY
     C                   Exsr      SRFAMT
     C                   Eval      Q = Q+1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':19:'
     C                   Eval      MFLD = AMT
     C                   Endif
     C
      * Sum of Sender's Charges
      * THERE SHOULD NOT BE ANY !!!!
      *
     C
      * Sum of Receiver's Charges
     C                   If        SUMRCH   <> *Zeros AND
     C                             CCTCHG   =  'OUR'  OR
     C                             SUMRCH   <> *Zeros AND
     C                             ShowRSum <> 'N'
     C                   Eval      WAMNT = SUMRCH
     C                   Eval      WCCY = CCTCCY
     C                   Exsr      SRFAMT
     C                   Eval      Q = Q+1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':71G:'
     C                   Eval      CCY71G = CCTCCY
     C                   Eval      AMNT71G = AMT
     C                   Eval      MFLD = FLD71G
     C                   Endif
     C
      * Sender's Correspondent
      * Must be customer account.  If BIC for customer found, put BIC in
      * line 1.

     C                   If        SNDCOR <> *Blanks
                                                                                 184188
     C                   Eval      Char18 = SNDCOR                               184188
     C                   CallB     'AOBICDV0'                                    184188
     C                   Parm      *Blanks       RetCodeIn                       184188
     C                   Parm                    Char18           18             184188
     C                   Parm                    @Type                           184188
     C                   Parm                    DSSDY                           184188
                                                                                 184188
     C                   If        @Type = '*BIC'                                184188
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      MEBICD = DSSDY                                             CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   CALL      'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRetCode                                     CSW202
     C                   PARM      '*VERIFY'     POption                                      CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
      *                                                                                       CSW201
      ** subtype is 'BEID' or 'TRCO'                                                          CSW201
      *                                                                                       CSW201
     C**********         IF        BDSUBT = 'BEID' OR                                  CSW201 CSW202
     C**********                   BDSUBT = 'TRCO'                                     CSW201 CSW202
                                                                                              CSW202
     C                   IF        (BDSUBT = 'BEID' OR                                        CSW202
     C                             BDSUBT = 'TRCO')                                           CSW202
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y'                                           CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW202
     C                   Eval      Q = Q + 1                                                  CSW201
     C     Q             Occur     MULT                                                       CSW201
     C                   EVAL      MTAG = ':53C:'                                             CSW201
     C                   Eval      MFLD = '/' + SNDCOR                                        CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             WChgInd <> 'Y' OR                                          CSW201
     C                             CSW201 <> 'Y'                                              CSW201
     C                   Eval      Q = Q + 1                                     184188
     C     Q             Occur     MULT                                          184188
     C                   Eval      MTAG = ':53A:'                                184188
     C                   Eval      MFLD = SNDCOR                                 184188
     C                   Eval      SavSndBic = SNDCOR                                       BUG24800
     C                   Eval      SavSndBicF = SNDCOR                                      BUG24800
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                 184188
      * Not a Bic. Find it                                                       184188
     C                   Else                                                    184188
     C                   MOVEL     SNDTYP        ISPTP
     C                   MOVEL     *Blanks       ISPTY1A
     C                   MOVEL     SNDCOR        ISPTY1
     C                   MOVEL     *Blanks       ISPTY2
     C                   MOVEL     *Blanks       ISPTY3
     C                   MOVEL     *Blanks       ISPTY4
     C                   MOVEL     *Blanks       ISPTY5

     C                   If        sndtyp = 'C' or sndtyp = 'S' or
     C                             sndtyp = *blanks
     C                   MOVEL     'A'           IVTAG1
     C                   Else
     C                   MOVEL     'C'           IVTAG3
     C                   Endif

     C                   MOVEL     ' '           IVTAG2

     C                   EXSR      SRCSID

     C                   If        %Subst(SNDCOR:1:1) <> '/'
     C     '/'           Cat(p)    SNDCOR        SNDCOR
     C                   Endif

     C                   If        BBCSID <> *Blanks
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed, check if                                     CSW201
      ** if SWIFT ID exists in BIC directory                                                  CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
      *                                                                                       CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C     MEBICD        PARM      *BLANKS       DSSDY                                        CSW201
                                                                                              CSW202
     C                   IF        CSW202 = 'Y' AND @Type = '*BIC'                            CSW202
     C                   CALL      'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRetCode                                     CSW202
     C                   PARM      '*VERIFY'     POption                                      CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
      *                                                                                       CSW201
     C                   IF        @TYPE = '*BIC' AND                                         CSW201
     C                             (BDSUBT = 'BEID' OR                                        CSW201
     C                             BDSUBT = 'TRCO')                                           CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y' AND @Type = '*BIC'                        CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW202
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG = ':53C:'                                             CSW201
     C                   IF        SNDCOR <> *BLANKS                                          CSW201
     C                   EVAL      MFLD = SNDCOR                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      MFLD = '/' + BBCSID                                        CSW201
     C                   ENDIF                                                                CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             WChgInd <> 'Y' OR                                          CSW201
     C                             CSW201 <> 'Y'                                              CSW201
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':53A:'
     C                   Eval      MFLD = SNDCOR

     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = BBCSID

     C                   Movel     BBCSID        SavSndBic
     C                   Movel     BBCSID        SavSndBicF
     C                   ENDIF                                                                CSW201

     C                   Else
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':53C:'
     C                   Eval      MFLD = SNDCOR
     C                   Endif
      *
     C                   Endif                                                   184188
     C                   Endif

      * Receivers correspondent.
      * Can be BIC, Cust No. SName, or account.  Get BIC and then A/C
     C                   If        RCVCOR <> *Blanks

      * Is is a BIC
     C                   If        %Subst(RCVCOR:1:1) = '/'
     C                   Eval      Char18 = %Subst(RCVCOR:2:18)
     C                   Else
     C                   Eval      Char18 = RCVCOR
     C                   Endif

     C                   CallB     'AOBICDV0'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18           18
     C                   Parm                    @Type
     C                   Parm                    DSSDY

     C                   If        @Type = '*BIC'
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':54A:'
     C                   Eval      MFLD = RCVCOR
     C                   Eval      Sav54AType = 'A'
     C                   Eval      Sav54A1 = MFLD

      * Not a Bic.  Move first field and then BIC
     C                   Else

     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':54A:'
     C                   If        %Subst(RCVCOR:1:1) = '/'
     C                   Eval      MFLD = RCVCOR
     C                   Eval      Sav54AType = 'A'
     C                   Eval      Sav54A1 = MFLD
     C                   Else
     C     '/'           Cat(P)    RCVCOR        MFLD
     C                   Eval      Sav54AType = 'A'
     C                   Eval      Sav54A1 = MFLD
     C                   Endif

      * Now find BIC of Account / Number / Shortname
     C                   MOVEL     RCVTYP        ISPTP
     C                   MOVEL     *Blanks       ISPTY1A
     C                   MOVEL     RCVCOR        ISPTY1
     C                   MOVEL     *Blanks       ISPTY2
     C                   MOVEL     *Blanks       ISPTY3
     C                   MOVEL     *Blanks       ISPTY4
     C                   MOVEL     *Blanks       ISPTY5

     C                   If        RCVTYP = 'C' or RCVTYP = 'S' or
     C                             RCVTYP = *blanks
     C                   MOVEL     'A'           IVTAG1
     C                   Else
     C                   MOVEL     'C'           IVTAG3
     C                   Endif

     C                   MOVEL     ' '           IVTAG2

     C                   EXSR      SRCSID

     C                   If        BBCSID <> *Blanks
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
                                                                                              CSW201
     C                   EVAL      PMBICC = BBCSID                                            CSW201
     C                   EVAL      PMBICB = %SUBST(BBCSID:9:3)                                CSW201
                                                                                              CSW201
     C                   CALL      'ME1400'                                                   CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
     C                   PARM                    PMBICC                                       CSW201
     C                   PARM                    PMBICB                                       CSW201
     C                   PARM                    SDCUST                                       CSW201
     C                   PARM                    SDCNST                                       CSW201
     C                   PARM                    MEBICD                                       CSW201
     C                   PARM      *BLANKS       PMCUST                                       CSW201
     C                   PARM      *BLANKS       PMCNST                                       CSW201
     C                   PARM      *BLANKS       PMBICD                                       CSW201
      *                                                                                       CSW201
      ** RCVCOR is a BIC                                                                      CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = *BLANKS AND                                        CSW201
     C                             PMBICD = 'Y'                                               CSW201
                                                                                              CSW202
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   CALL      'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRetCode                                     CSW202
     C                   PARM      '*VERIFY'     POption                                      CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
      *                                                                                       CSW201
      ** subtype is 'BEID' or 'TRCO'                                                          CSW201
      *                                                                                       CSW201
     C**********         IF        BDSUBT = 'BEID' OR                                  CSW201 CSW202
     C**********                   BDSUBT = 'TRCO'                                     CSW201 CSW202
                                                                                              CSW202
     C                   IF        (BDSUBT = 'BEID' OR                                        CSW202
     C                             BDSUBT = 'TRCO')                                           CSW202
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y'                                           CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW202
     C                   EVAL      Sav54AType = 'D'                                           CSW201
     C                   EVAL      MTAG = ':54D:'                                             CSW201
                                                                                              CSW201
     C                   SELECT                                                               CSW201
                                                                                              CSW201
     C                   WHEN      PMCUST = 'Y'                                               CSW201
     C                   EVAl      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = BBCNA1                                              CSW201
     C                   EVAL      Sav54A2 = MFLD                                             CSW201
                                                                                              CSW201
     C                   IF        BBCNA2 <> *Blanks                                          CSW201
     C                   EVAl      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = BBCNA2                                              CSW201
     C                   EVAL      Sav54A3 = MFLD                                             CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        BBCNA3 <> *Blanks                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = BBCNA3                                              CSW201
     C                   EVAL      Sav54A4 = MFLD                                             CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        BBCNA4 <> *Blanks                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = BBCNA4                                              CSW201
     C                   EVAL      Sav54A5 = MFLD                                             CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   WHEN      PMCNST = 'Y'                                               CSW201
     C                   EVAl      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = AWCPNM                                              CSW201
     C                   EVAL      Sav54A2 = MFLD                                             CSW201
                                                                                              CSW201
     C                   IF        AWCNTN <> *BLANKS                                          CSW201
     C                   EVAl      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = AWCNTN                                              CSW201
     C                   EVAL      Sav54A3 = MFLD                                             CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDSL                                                                CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             WChgInd <> 'Y' OR                                          CSW201
     C                             CSW201 <> 'Y'                                              CSW201
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C*                  Eval      MTAG = ':54A:'
     C                   Eval      Mfld = BBCSID
     C                   Eval      Sav54AType = 'A'
     C                   Eval      Sav54A2 = MFLD
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   Endif

     C                   Endif

      **Now*must*enter*into*field*72*the*ISO*BIC                                            BUG24808
     C**********         If        BBCSID <> *Blanks                                        BUG24808
     C**********         Eval      Q = Q + 1                                                BUG24808
     C*****Q****         Occur     MULT                                                     BUG24808
     C**********         Eval      MTAG = ':72:'                                            BUG24808
     C*****'/RCB/'       Cat(P)    BBCSID        MFLD                                       BUG24808
     C**********         Eval      Fld72On = 'Y'                                            BUG24808
     C**********         Endif                                                              BUG24808


     C                   Endif

      * Sender to Receiver Information
                                                                                              CSW209
     C                   EXSR      SR72                                                       CSW209
                                                                                              CSW209
     C                   If        ADNLI1 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   If        Fld72On <> 'Y'
     C                   Eval      MTAG = ':72:'
     C                   Endif
     C                   Eval      MFLD = ADNLI1

     C                   If        ADNLI2 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = ADNLI2
     C                   Endif

     C                   If        ADNLI3 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = ADNLI3
     C                   Endif

     C                   If        ADNLI4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = ADNLI4
     C                   Endif

     C                   If        ADNLI5 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = ADNLI5
     C                   Endif

     C                   If        ADNLI6 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = ADNLI6
     C                   Endif
     C                   Endif

     C                   Endsr
      /EJECT
      *****************************************************************
      * SRBRCH - Validate each booking branch for every record called *
      *          by main processing.                                  *
      *****************************************************************
      *
     C     SRBRCH        Begsr
      *
      * Save Booking Branch (BRCA) Read from FT102HPD
      *
     C                   Move      BRCA          BRCAA             3
      *
      * Set up key and access inst. control rec branch code (TABLETR)
      *
      **********
     C**********         Movel     '10    '      ZTABKY                                     BUG13217
     C**********         Move      BRCA          ZTABKY                                     BUG13217
     C*****ZTABKY        Chain     TABFP                              10                    BUG13217
     C**********         If        *IN10 or RECI <> 'D'                                     BUG13217
     C******LOCK         IN        LDA                                                      BUG13217
     C**********         Movel     'TABFP'       DBFILE                                     BUG13217
     C**********         Movel     ZTABKY        DBKEY                                      BUG13217
     C**********         Z-Add     9             DBASE                                      BUG13217
     C**********         OUT       LDA                                                      BUG13217
     C**********         Exsr      *PSSR                                                    BUG13217
     C**********         Endif                                                              BUG13217
      *
      * Save Branch Internal Customer No.
      *
     C**********         Move      BICN          SBICN             6 0                        CSD027
     C**********         Move      BICN          SBICN             6                 CSD027 BUG13217
      *                                                                                     BUG13217
      * Access SDBRCHPD instead on TABLETR                                                  BUG13217
      *                                                                                     BUG13217
     C                   EVAL      WBranch  = BRCA                                          BUG13217
     C     WBranch       Chain     SDBRCHL1                           09                    BUG13217
      *                                                                                     BUG13217
     C                   If        *IN09 or RECI <> 'D'                                     BUG13217
     C     *LOCK         IN        LDA                                                      BUG13217
     C                   Movel     'SDBRCHL1'    DBFILE                                     BUG13217
     C                   Movel     A8BRCD        DBKEY                                      BUG13217
     C                   Z-Add     11            DBASE                                      BUG13217
     C                   OUT       LDA                                                      BUG13217
     C                   Exsr      *PSSR                                                    BUG13217
     C                   Endif                                                              BUG13217
      *                                                                                     BUG13217
     C                   Move      A8BICN        SBICN             6                        BUG13217
     C                   Move      A8BTID        SNCSID                                     BUG13217
     C                   Move      A8BTID        SCSID                                      BUG13217
     C                   Move      SCSID         ROTID                                      BUG13217
      *
      **  Access SDCUSTPD using branch internal customer number
      *
     C                   Move      *BLANKS       @KEY1
     C**********         Movel     BICN          @KEY1                                      BUG13217
     C                   Movel     A8BICN        @KEY1                                      BUG13217
     C                   Call      'AOCUSTR0'
     C                   Parm      '*MSG   '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    @KEY1            10
     C                   Parm      *BLANKS       @KYST             7
     C     SDCUST        Parm      SDCUST        DSSDY
      *
      ** Customer record not found - Error
      *
     C     @RTCD         Ifne      *BLANKS
     C     CSW207        ANDNE     'Y'                                                       CSW207A
     C     *LOCK         IN        LDA
     C                   Z-add     10            DBASE                            * * * * * * *
     C                   Movel     @KEY1         DBKEY                            * DBERR 021 *
     C                   Movel     'SDCUSTPD'    DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
      **  Save sender's addresses & parent customer number
      *
     C                   Move      BBTXA1        STELX            10
     C                   Move      BBSTAD        SSTTX            12
     C                   Move      BBCRNM        SCRNM            20
      *
      ** Move new field names to old to ensure pgm continuity.
      *
     C                   Move      BBCSID        CSID             12
     C                   Movel     BBTXA1        TELX             12
      *
      **************************************
      *     ** Do  Not **                  *
      *    Remove Terminal ID              *
      **************************************
      *
      * Save 'OUR TID' Field in Work Area
      *
     C                   Move      TELX          MXOTLX           12
      ****************************************************************************          BUG13217
      **Access*to*SDBRCHL5********************************************************          BUG13217
      ****************************************************************************          BUG13217
     C**********         Move      BICN          WWBICN            6                        BUG13217
     C*****WWBICN        Chain     SDBRCHL5                           09                    BUG13217
      **********                                                                            BUG13217
     C**********         If        *IN09 or RECI <> 'D'                                     BUG13217
     C******LOCK         IN        LDA                                                      BUG13217
     C**********         Movel     'SDBRCHL5'    DBFILE                                     BUG13217
     C**********         Movel     A8BICN        DBKEY                                      BUG13217
     C**********         Z-Add     11            DBASE                                      BUG13217
     C**********         OUT       LDA                                                      BUG13217
     C**********         Exsr      *PSSR                                                    BUG13217
     C**********         Endif                                                              BUG13217
      **********                                                                            BUG13217
     C**********         Move      A8BTID        SNCSID                                     BUG13217
     C**********         Move      A8BTID        SCSID                                      BUG13217
     C**********         Move      SCSID         ROTID                                      BUG13217
     C                   Endsr
     C/EJECT
      *****************************************************************
      * SRCSID - Subroutine to access SWIFT ID of Customer            *
      *****************************************************************
     C     SRCSID        Begsr
      *
     C                   Move      *Blanks       OFSPT1
     C                   Move      *Blanks       OFSPT2
     C                   Move      *Blanks       OFSPT3
     C                   Move      *Blanks       OFSPT4
     C                   Move      *Blanks       OFSPT5
     C                   Move      *Blanks       NoCust            2

     C                   Move      *Blanks       OSTAG             1
     C                   Move      'N'           OSUFLG            1

     C                   If        %Subst(ISPTY1:1:1) = '/'
     C                   Eval      ISPTY1=%SUBST(ISPTY1:2:34)
     C                   Endif


     C                   Select
     C                   When      ISPTP = 'F'
     C                   MOVEL     ISPTY1        TLCCNN            5
     C                   Movel     '70'          TABTLK
     C                   Move      TLCCNN        TABTLK           12
      *
     C     TABTLK        Chain     TABFP                              10
     C                   If        *IN10
     C     *LOCK         IN        LDA
     C                   Movel     TABTLK        DBKEY
     C                   Z-Add     12            DBASE
     C                   Movel     'TABFP'       DBFILE
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
     C                   Eval      CUSTNO = CNUM
     C                   Eval      BRCA = BRCAA
      *
      * Retail Account Processing
      *
     C                   When      ISPTP = 'R'

     C                   Move      *Blanks       ParmStr          35
     C                   Movel     ISPTY1        ParmStr

     C                   CallB     'AOACCTV1'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      *Blanks       @Type             7
     C                   Parm                    ParmStr
     C                   Parm                    DSSDY
     C                   Eval      P@ACC = DSSDY

     C                   Eval      CUSTNO = CNUM

      *
      * Customer Number
      *
     C                   When      ISPTP = 'C'
     C                   Movel     ISPTY1        ##001             1
     C**********         If        ##001 = '/'                                              BUG15250
     C                   If        ISPTY2 <> *Blanks                                        BUG15250
     C                   Movel     ISPTY2        CUSTNO
     C                   Else
     C                   Movel     ISPTY1        CUSTNO
     C                   Endif
      *
      * General Ledger Account
      *
     C                   When      ISPTP = 'G'
      *
      * If using account line construct then use FIRST line
      *
     C                   Movel     ISPTY1        ##001             1
     C                   If        ##001 = '/'
     C                   Eval      Custnot = %Subst(ISPTY1:5:6)
     C                   Movel     Custnot       Custno
     C                   Else
     C                   Eval      Custnot = %Subst(ISPTY1:4:6)
     C                   Movel     Custnot       Custno
     C                   Endif
      *
      * IBAN Account
      *
     C                   When      CFT004 = 'Y' and ISPTP = 'I'
      *
     C                   Eval      WIBAN = ISPTY1
     C     WIBAN         Chain     ACCNTL6F                           10
     C                   If         Not *IN10
     C                   Eval      CUSTNO = CNUM
     C                   Else
     C     *LOCK         IN        LDA
     C                   Movel     'ACCNTL6'     DBFILE
     C                   Movel     ISPTY1        DBKEY
     C                   Z-Add     14            DBASE
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
     C
     C                   Other
     C**********         Eval      CUSTNO = *Zeros                                            CSD027
     C                   Eval      CUSTNO = *Blanks                                           CSD027
     C                   Movel     ISPTY1        ##001
     C                   If        ##001 = '/'
     C                   Move      ISPTY1        WISPTY           34
     C                   Movel     WISPTY        CUSTKY
     C                   Else
     C                   Movel     ISPTY1        CUSTKY           10
     C                   Endif
     C                   Endsl
      *
      * Access SDCUSTPD using Customer number
      *
     C                   Move      *Blanks       @KEY1
     C**********         If        CUSTNO <> *Zeros                                           CSD027
     C                   If        CUSTNO <> *Blanks                                          CSD027
     C                   Movel     CUSTNO        @KEY1
     C                   Else
     C                   If        CUSTKY <> *Blanks
     C                   Movel     CUSTKY        @KEY1
     C                   Endif
     C                   Endif
     C
      *
     C                   If        @KEY1 <> *Blanks
     C                   Call      'AOCUSTR0'
     C                   Parm      '*MSG       ' @RTCD
     C                   Parm      '*KEY       ' @OPTN
     C                   Parm                    @KEY1            10
     C                   Parm      *Blanks       @KYST             7
     C     SDCUST        Parm      SDCUST        DSSDY
      *
      * Customer record not found
      *
     C                   If        @RTCD <> *Blanks
     C                   Eval      NoCust = 'NF'
     C                   Eval      CNA1 = *Blanks
     C                   Eval      CNA2 = *Blanks
     C                   Eval      CNA3 = *Blanks
     C                   Eval      CNA4 = *Blanks
     C                   Else
      *
     C                   Movel     BBCUST        CUSTNO
     C                   Eval      CNA1 = BBCNA1
     C                   Eval      CNA2 = BBCNA2
     C                   Eval      CNA3 = BBCNA3
     C                   Eval      CNA4 = BBCNA4
     C                   Endif
      *
     C                   Movel     BBCUST        CUSTNO
     C                   Endif
      *
     C                   MOVEL     ISPTY1        ##002             2
      *
     C                   SELECT

     C                   When      IVTAG1 = 'A' AND ISPTY1A <> *Blanks

     C                   MOVEL     ISPTY1A       SCSID
     C                   MOVEL     ISPTY1        ##001
      *
     C                   IF        ##001 = '/'
     C                   MOVEL     ISPTY1        OFSPT1
     C                   MOVEL     SCSID         OFSPT2
     C                   ELSE
     C                   MOVEL     SCSID         OFSPT1
     C                   ENDIF
     C                   MOVE      'A'           OSTAG
      *
     C                   WHEN      IVTAG3 = 'C' AND ISPTY1A = *Blanks

     C                   MOVEL     ISPTY1        OFSPT1
     C                   MOVE      'C'           OSTAG
     C
     C                   WHEN      IVTAG3 = 'D'
     C                   MOVEL     CNA1          OFSPT1
     C                   MOVEL     CNA2          OFSPT2
     C                   MOVEL     CNA3          OFSPT3
     C                   MOVEL     CNA4          OFSPT4
     C                   MOVE      'D'           OSTAG
     C                   ENDSL
     C
     C                   Endsr
     C/EJECT
      *****************************************************************
      * SRFAMT - Subroutine to Format Amount                          *
      *****************************************************************
     C     SRFAMT        Begsr
      *
      * Chain to TABTG10 to find Decimal position
      *
     C                   Movel     '20'          TABTGK           12
     C                   Movel     WCCY          TGCCSR            4
     C                   Move      '1'           TGCCSR
     C                   Move      TGCCSR        TABTGK
     C     TABTGK        Chain     TABFP                              10
      *
     C                   If        *IN10
     C     *LOCK         IN        LDA
     C                   Movel     'TABFP'       DBFILE
     C                   Movel     TABTGK        DBKEY
     C                   Z-Add     15            DBASE
     C                   OUT       LDA
     C                   Exsr      *PSSR
      *
     C                   Endif
      *
     C                   Call      'ZM1140'
     C                   Parm      WAMNT         ZAMNT            15 0
     C                   Parm      CDP           ZCDP              1 0
     C                   Parm      *Blanks       ZSAMNT           17
     C                   Parm      *Blanks       ZOAMNT           21
      *
     C                   Eval      AMT = ZSAMNT
     C                   ENDSR
     C/EJECT
     C*****************************************************************
     C*   OMSG - output correctly generated messages                  *
     C*   Called by:  Main process                                    *
     C*   Calls:  SRMPRF - Write o/p reference to PF/MGOREFPD.        *
     C*****************************************************************
      *
     C     OMSG          Begsr
      *
      **  Write reference record to PF/MGOREFPD.
      *
     C                   EXSR      SRMPRF
      *
      **  Write multiple occurrence data structure to MGOMSGPD
     C**********         Z-ADD     1             X                 2 0          190200
     C                   Z-ADD     1             X                 4 0          190200
     C     X             OCCUR     MULT
                                                                                              CSW209
     C                   IF        W23  = 'N' OR                                              CSW209
     C                             W52A = 'N' OR                                              CSW209
     C                             W57A = 'N' OR                                              CSW209
     C                             W59A = 'N' OR                                              CSW209
     C                             W72  = 'N'                                                 CSW209
     C                   Eval      X = X + 1                                                  CSW209
     C     X             OCCUR     MULT                                                       CSW209
     C                   ELSE                                                               BUG24553
      *                                                                                     BUG24553
     C     CCTID         CHAIN     FT102HL3                                                 BUG24553
     C                   EVAL      CCOMVF= 'STP'                                            BUG24553
     C                   UPDATE    CCT3                                                     BUG24553
      *                                                                                     BUG24553
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
      *
     C                   Dow       X <= Q
     C                   Write     MGOMSGD0                             42
      *
      **  Error on write to PF/MGOMSGPD (message data file)
      *
     C                   If        *IN42
     C     *LOCK         IN        LDA
     C                   Z-Add     16            DBASE                          * * * * * * * *
     C                   Movel     '       '     DBKEY                          *  DBERR 005  *
     C                   Movel     'MGOMSGPD'    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Eval      X = X + 1
     C     X             OCCUR     MULT
     C                   END
      *
      ** Write multiple occurrence data structure to MGOEXTPD                               BUG19322
      *                                                                                     BUG19322
     C                   Z-ADD     1             V                 2 0                      BUG19322
     C     V             OCCUR     EXTN                                                     BUG19322
     C                   DOW       V <= 20  And                                             BUG19322
     C                             MCSI <> *BLANKS                                          BUG19322
     C                   WRITE     MGOEXTD0                             43                  BUG19322
      *                                                                                     BUG19322
      **  Error on write to PF/MGOEXTPD (message data extension file)                       BUG19322
      *                                                                                     BUG19322
     C                   IF        *IN43 = *ON                                              BUG19322
     C                   MOVE      '043'         DBASE                       * * * * * * * *BUG19322
     C                   MOVEL     '   '         DBKEY                       *  DBERR 043  *BUG19322
     C                   MOVEL     'MGOEXTPD'    DBFILE                      * * * * * * * *BUG19322
     C                   EXSR      *PSSR                                                    BUG19322
     C                   ENDIF                                                              BUG19322
      *                                                                                     BUG19322
     C                   EVAL      V = V + 1                                                BUG19322
     C     V             OCCUR     EXTN                                                     BUG19322
     C                   ENDDO                                                              BUG19322
      *                                                                                     BUG19322
     C                   Endsr
      *
     C/EJECT
      *****************************************************************
      * SRMPRF - Map General Information Details to MGOREFPD fields   *
      *****************************************************************
     C     SRMPRF        Begsr
     C                   Eval      MODI = 'FT'
     C                   Eval      TRNO = CCTID
     C                   Eval      TRNF = *Blanks
     C                   Eval      TRNM = *Blanks
     C                   Eval      MTRN = CCTID
     C                   Eval      TNTP = CCTTYP
     C                   Eval      SBTP = CCTTST
     C                   Eval      EVTP = *Blanks
     C                   Eval      NWRK = 'SWIFT'
     C                   Eval      SECN = SBICN
     C                   Eval      NWSN = STID
      *
      * Destination.  Must be a BIC C/N or S/N
     C                   If        CCTDST <> *Blanks
     C                   Eval      Char18 = CCTDST
     C                   CallB     'AOBICDV0'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18           18
     C                   Parm                    @Type
     C                   Parm                    DSSDY

     C                   If        @Type = '*BIC'
     C                   Eval      NWDS = CCTDST
     C                   Eval      SavDstBicF = CCTDST                               184260

      * Not a Bic. Find it
     C                   Else

     C                   MOVEL     DSTTYP        ISPTP                               177668
     C                   MOVEL     *BLANKS       ISPTY1A                             177668
     C                   MOVEL     CCTDST        ISPTY1                              177668
     C                   MOVEL     *BLANKS       ISPTY2                              177668
     C                   MOVEL     *BLANKS       ISPTY3                              177668
     C                   MOVEL     *BLANKS       ISPTY4                              177668
     C                   MOVEL     *BLANKS       ISPTY5                              177668
     C                   MOVEL     ' '           IVTAG1                              177668
     C                   MOVEL     ' '           IVTAG2                              177668
     C                   MOVEL     'C'           IVTAG3                              177668
     C                   EXSR      SRCSID                                            177668
     C                   If        BBCSID <> *BLANK                                  177668
                                                                                     177668
     C                   Eval      NWDS = BBCSID                                     177668
     C                   Eval      SavDstBicF = BBCSID                               184260

     C                   If        DSTTYP = 'F'                                      184175
     C                   Eval      CharNost = %Subst(CCTDST:4:2)                     184175
     C                   Movel     CharNost      NSNO                                184175
     C                   Endif                                                       184175

     C                   Else                                                        177668
     C                   If        CSW207 <> 'Y'                                             CSW207A
      ** Customer must have a SWIFT id                                               177668
     C     *LOCK         IN        LDA                                               177668
     C                   Movel     'SDCUSTPD'    DBFILE                              177668
     C                   Movel     BBCUST        DBKEY                               177668
     C                   Z-Add     24            DBASE                               177668
     C                   OUT       LDA                                               177668
     C                   Exsr      *PSSR                                             177668
     C                   Endif                                                               CSW207A
     C                   Endif                                                       177668
                                                                                     177668
     C**********         Movel     CCTDST        KeyVal                              177668
                                                                                     177668
     C*********          CallB     'AOCUSTR0'                                        177668
     C**********         Parm      *Blanks       @Rtcd                               177668
     C**********         Parm      '*KEY   '     @Optn                               177668
     C**********         Parm                    KeyVal           10                 177668
     C**********         Parm      *Blanks       @Type                               177668
     C**********         Parm                    SDCUST                              177668
     C                   Endif
     C                   Endif

      * Save destination BIC for MT202
     C                   Movel     NWDS          SavDstBic
      *
     C                   Eval      NWBN = *Blanks
     C                   Eval      MTPY = '102'
     C                   Eval      MPRY = SWPRIO


     C                   If        FTCS = 'R'
     C                   Eval      MGST = 'RSND'
     C                   Eval      MGSG = '2'
     C                   Else
     C                   Eval      MGST = 'CRTD'
     C                   Eval      MGSG = '1'
     C                   Endif
                                                                                              CSD015
      ** If Watch List Checking (CSD015) is applied and                                       CSD015
      ** Midas Message Manager is not applied (CSW025)                                        CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y' AND CSW025 = 'N'                              CSD015
     C                             AND W1EWLC = 'Y'                                           222385
     C                   EXSR      SrWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
      *
     C                   Eval      LSCC = *Blanks
     C                   Eval      F57U = *Blanks
     C                   Eval      PTST = *Blanks
     C                   Eval      CARQ = *Blanks
     C                   Eval      MPDE = *Blanks
     C                   Eval      HRDT = @HRDT
      *
      **  Convert run date to YYMMDD
      *
     C                   Call      'ZM0060'
     C                   Parm      RUND          ZMDAY             5 0
     C                   Parm                    ZMDATE            6
     C                   Move      ZMDATE        MGDE
      *
     C                   TIME                    MGTM
     C                   Eval      LADT = RUNA
     C                   Eval      LATM = MGTM
     C                   Eval      RELD = *Blanks
     C                   Eval      RELT = *Zeros
     C                   Eval      RUSR = *Blanks
     C                   Eval      RWSN = *Blanks
      *
     C                   Call      'ZM1140'
     C                   Parm      TOTTRN        ZAMNT            15 0
     C                   Parm      WCDP          ZCDP              1 0
     C                   Parm      *Blanks       ZSAMNT           17
     C                   Parm      *Blanks       ZOAMNT           21
      *
     C                   Eval      AMTX = ZSAMNT
     C                   Eval      AMTS = ZSAMNT
      *
     C                   Call      'ZM0060'
     C                   Parm      TTVDTE        ZMDAY
     C                   Parm                    ZMDATE
     C                   Eval      SVDT = ZMDATE
     C                   Eval      CCY = CCTCCY
     C*******************Eval      NSNO = *Zeros                                 184175
     C                   Eval      SACN = *Blanks
     C                   Eval      AORR = *Blanks
     C                   Eval      DESI = *Blanks
     C                   Eval      BRCA = BRCAA
     C                   Eval      OTHB = ORBR
     C                   Eval      RCBR = *Blanks
     C                   If        MBIN = 'Y'
     C                   Eval      OTHT = 'Originating Branch'
     C                   Endif
     C                   Eval      NETI = *Blanks
     C
     C                   Eval      DYST = *Blanks
     C                   Eval      RSID = *Blanks
     C                   Eval      MSE1 = *Blanks
      *
     C                   If        CCTCCY <> *Blanks
     C                   Callb     'AOCURRR0'
     C                   Parm      '*MSG   '     @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm      CCTCCY        @CCY              3
     C     SDCURR        Parm      SDCURR        DSSDY
      *                                                                   S01117
     C                   If        @RTCD <> *Blanks
     C     *LOCK         IN        LDA
     C                   Z-Add     17            DBASE                            *************
     C                   Movel     @CCY          DBKEY                            * DBERR 027 *
     C                   Movel     'SDCURRPD'    DBFILE                           *************
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
      *                                                                   S01117
     C                   If        A6NDWR = 'Y'
     C                   If        A6DNOR = 'Y'
     C                   Eval      DELC = '3'
     C                   Else
     C                   Eval      DELC = '1'
     C                   Endif
      *
     C                   Else
     C                   If        A6DNOR = 'Y'
     C                   Eval      DELC = '2'
     C                   Else
     C                   Eval      DELC = *Blanks
     C                   Endif
     C                   Endif
      *
      ** Ensure message priority and delivery notification valid                              196129
      ** MPRY = 'U' DELC = '1' or '3',                                                        196129
      ** MPRY = 'N' DELC = ' ' or '2'.                                                        196129
     C     MPRY          IFEQ      'U'                                                        196129
     C     DELC          ANDEQ     ' '                                                        196129
     C     MPRY          OREQ      'U'                                                        196129
     C     DELC          ANDEQ     '2'                                                        196129
     C                   MOVEL     '1'           DELC                                         196129
     C                   END                                                                  196129
      *                                                                                       196129
     C     MPRY          IFEQ      'N'                                                        196129
     C     DELC          ANDEQ     '1'                                                        196129
     C     MPRY          OREQ      'N'                                                        196129
     C     DELC          ANDEQ     '3'                                                        196129
     C                   MOVEL     '2'           DELC                                         196129
     C                   END                                                                  196129
      *                                                                                       196129
      ** Change the Network to 'PAPER' if the Precious Metal Indicator                        CSW215
      ** of the currency is 'Y' and Network is currently set to 'SWIFT'                       CSW215
      *                                                                                       CSW215
     C                   EVAL      WNETWK = *BLANKS                                         MD035623
     C                   IF        CSW215 = 'Y' AND NWRK = 'SWIFT'                            CSW215
     C                             AND A6PMRT = 'Y'                                           CSW215
     C                   MOVEL     'PAPER'       NWRK                                         CSW215
     C                   ENDIF                                                                CSW215
     C                   EVAL      WNETWK = NWRK                                            MD035623
      *                                                                                       CSW215
     C                   Eval      ELIN = *Blanks
     C                   Eval      SSAC = *Blanks
     C                   Eval      MIR  = *Blanks
     C                   Eval      TSKS = 'Y'
     C                   Eval      TSKY = *Blanks
     C                   Eval      TSEQ = *Zeros
     C                   Eval      CFPF = *Blanks
     C                   Eval      PT210 = *Zeros
     C                   Eval      AVDT = *Zeros
     C                   Eval      ASEQ = *Zeros
     C                   Eval      TODY = *Blanks
      *
      ** Set-up Message Generation Century flag
      *
     C                   Movel     MGDE          YY                2 0
     C                   If        YY < 72
     C                   Eval      CIND = '2'
     C                   Else
     C                   Eval      CIND = '1'
     C                   Endif
      *
     C                   Eval      CINDV = *Blanks
     C                   MOVEL     @CHG          AORR                                         CSW025
     C                   Write     MGOREFD0                             41
      *
      * Error on write to PF/MGOREFPD (message reference file)
      *
     C                   If        *IN41
     C     *LOCK         IN        LDA
     C                   Z-Add     18            DBASE                          * * * * * * * *
     C                   Movel     '       '     DBKEY                          *  DBERR 014  *
     C                   Movel     'MGOREFPD'    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endsr
     C/EJECT
      *****************************************************************
      * SRCLRF - Subroutine to clear Multiple occurrence Data Structure
      *****************************************************************
     C     SRCLRF        Begsr
      *
     C                   Move      *BLANKS       TRNO
     C                   Move      *BLANKS       TRNA
     C                   Move      '      '      NWRK
     C**********         Z-Add     0             SECN                                         CSD027
     C                   Eval      SECN = *BLANKS                                             CSD027
     C                   Move      *BLANKS       NWSN
     C**********         Z-Add     0             DECN                                         CSD027
     C                   Eval      DECN = *BLANKS                                             CSD027
     C                   Move      *BLANKS       NWDS
     C                   Move      *BLANKS       MGSG
     C                   Move      *BLANKS       MGST
     C                   Z-Add     0             MGTM
     C                   Z-Add     0             LATM
     C                   Move      *BLANKS       RELD
     C                   Z-Add     0             RELT
     C                   Move      *BLANKS       AMTS
     C                   Move      *BLANKS       SVDT
     C                   Move      *BLANKS       CINDV
      *
     C                   Move      *BLANKS       SNCSID           12
     C                   Move      *BLANKS       STELX            10
     C                   Move      *BLANKS       SSTTX            12
     C                   Move      *BLANKS       SCRNM            20
      *
     C**********         Eval      CUSTNO = *Zeros                                            CSD027
     C                   Eval      CUSTNO = *Blanks                                           CSD027
     C                   Eval      CUSTKY = *Blanks
      *
     C                   Eval      RCCTBOC = *Blanks
     C                   Eval      RSINST = *Blanks
     C                   EVAL      RORDC1 = *Blanks
     C                   EVAL      RORDC2 = *Blanks
     C                   EVAL      RORDC3 = *Blanks
     C                   EVAL      RORDC4 = *Blanks
     C                   Eval      RORINS = *Blanks
     C                   Eval      ROINS1 = *Blanks
     C                   Eval      ROINS2 = *Blanks
     C                   Eval      RTRNTP = *Blanks
     C                   Eval      RREGR1 = *Blanks
     C                   Eval      RREGR2 = *Blanks
     C                   Eval      RREGR3 = *Blanks
     C                   Eval      RDCHG = *Blanks
     C                   Eval      REXRAT = *Blanks
      *
     C                   Eval      X = 1
     C                   Dow       X <= Q
     C     X             Occur     MULT
     C                   Movel     CRLF          CTRC                           187213
     C                   Eval      MTAG = *Blanks
     C                   Eval      MFLD = *Blanks
     C                   Eval      MSEQ = *Blanks                                           BUG24811
     C                   Eval      X = X + 1
     C                   Enddo
      *                                                                                     BUG19322
      ** Clear multiple occurrence DS for the extension file.                               BUG19322
      *                                                                                     BUG19322
     C                   Eval      V = 1                                                    BUG19322
     C     V             Occur     EXTN                                                     BUG19322
     C                   Dow       V <= 20                                                  BUG19322
     C                   Eval      MPSN = *Zeros                                            BUG19322
     C                   Eval      MTG = *Blanks                                            BUG19322
     C                   Eval      MCSI = *Blanks                                           BUG19322
     C                   Eval      V = V + 1                                                BUG19322
     C     V             Occur     EXTN                                                     BUG19322
     C                   Enddo                                                              BUG19322
     C                   Eval      V = *Zeros                                               BUG19322
     C
     C                   Endsr
     C/EJECT
      *****************************************************************
      * SRH1 - Output an entry to SWIFT Message Report                *
      *****************************************************************
     C     SRH1          Begsr
     C                   Eval      PAGEP1 = PAGEP1 + 1
     C                   Eval      RCCTID = CCTID
     C                   Eval      ROTID = STID
     C                   Eval      RSWPC = SWPRIO
     C                   Eval      RADDR = OINST1
     C
     C                   Select
     C                   When      PRTYPE = 'H'
     C                   Write     P1H1                                 80
     C                   When      PRTYPE = 'D'
      *                                                                                       CSW201
      ** When SWIFT 2001 enhancement is installed                                             CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      *IN29 = *ON                                                CSW201
      *                                                                                       CSW201
      ** Setup indicators for senders charges                                                 CSW201
      *                                                                                       CSW201
     C                   MOVEA     '00000'       *IN(30)                                      CSW201
                                                                                              CSW201
     C                   IF        SNDCCY <> *BLANKS                                          CSW201
     C                   EVAL      *IN30 = *ON                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        SDCCY2 <> *BLANKS                                          CSW201
     C                   EVAL      *IN31 = *ON                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        SDCCY3 <> *BLANKS                                          CSW201
     C                   EVAL      *IN32 = *ON                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        SDCCY4 <> *BLANKS                                          CSW201
     C                   EVAL      *IN33 = *ON                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        SDCCY5 <> *BLANKS                                          CSW201
     C                   EVAL      *IN34 = *ON                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** SWIFT 2001 enhancement is off                                                        CSW201
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   MOVEA     '000000'      *IN(29)                                      CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   Write     P1D1                                 80
     C                   Endsl
      *
     C                   IF        *IN80
     C     *LOCK         IN        LDA
     C                   MOVEL     'FT0658P1'    DBFILE
     C                   MOVEL     '1'           DBKEY
     C                   Z-ADD     19            DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Endsr
     C/EJECT
      *****************************************************************
      * SRAU - Output an entry to SWIFT Message Report                *
      *****************************************************************
     C     SRAU          Begsr
      *
     C                   Eval      STITL = TITL
     C                   Eval      PAGEAU = 1
     C                   Write     HEADAU
     C                   Endsr
     C/EJECT
      *****************************************************************
      * RtvCus - Retrieve Customer details                            *
      *****************************************************************
     C     RtvCus        Begsr
      *
     C     *Like         Define    LigCus1       LigArg
     C     *Like         Define    BBCSID        LigSwift
     C                   Eval      LigCus1 = *BLANK
     C                   Eval      LigCus2 = *BLANK
     C                   Eval      LigCus3 = *BLANK
     C                   Eval      LigCus4 = *BLANK
     C                   Eval      LigSwift = *BLANK
     C                   Eval      NoCust = *BLANK
     C                   Eval      @KEY1 = LigArg
     C                   Call      'AOCUSTR0'
     C                   Parm      '*MSG       ' @RTCD
     C                   Parm      '*KEY       ' @OPTN
     C                   Parm                    @KEY1            10
     C                   Parm      *Blanks       @KYST             7
     C     SDCUST        Parm      SDCUST        DSSDY
      *
      * Customer record not found
      *
     C                   If        @RTCD <> *Blanks
     C                   Eval      NoCust = 'NF'
     C                   Else
     C                   Eval      LigCus1 = BBCNA1
     C                   Eval      LigCus2 = BBCNA2
     C                   Eval      LigCus3 = BBCNA3
     C                   Eval      LigCus4 = BBCNA4
     C                   Eval      LigSwift = BBCSID
     C                   Endif

     C                   Endsr
     C/EJECT
      *****************************************************************
     C     MT202         Begsr

      * Set processing conditions here.
     C                   If        SNDCOR <> *Blanks  AND
     C                             SavSndBic <> SavDstBic


     C*****CCTID*********CAT(P)    'X'           TRNO                            184188
     C*****CCTID         CAT(P)    'X':0         TRNO                                184188 BUG25158
     C     'X'           CAT(P)    CCTID:0       TRNO                                       BUG25158
     C                   Eval      NWDS = SavSndBicF
     C                   Eval      SECN = SBICN
     C                   Eval      NWSN = STID
      *
     C                   Eval      MTPY = '202'

     C                   If        FTCS = 'R'
     C                   Eval      MGST = 'RSND'
     C                   Eval      MGSG = '2'
     C                   Else
     C                   Eval      MGST = 'CRTD'
     C                   Eval      MGSG = '1'
     C                   Endif
      *
     C                   Eval      HRDT = @HRDT
      *
     C                   Call      'ZM1140'
     C                   Parm      TOTTRN        ZAMNT            15 0
     C                   Parm      WCDP          ZCDP              1 0
     C                   Parm      *Blanks       ZSAMNT           17
     C                   Parm      *Blanks       ZOAMNT           21
      *
     C                   Eval      AMTX = ZSAMNT
     C                   Eval      AMTS = ZSAMNT
      *
     C                   Call      'ZM0060'
     C                   Parm      TTVDTE        ZMDAY
     C                   Parm                    ZMDATE
     C                   Eval      SVDT = ZMDATE
     C                   Eval      CCY = CCTCCY
     C                   Eval      NSNO = *Zeros
     C                   Eval      SACN = *Blanks
     C                   Eval      AORR = *Blanks
     C                   Eval      DESI = *Blanks
     C                   Eval      BRCA = BRCAA
     C                   Eval      OTHB = ORBR
     C                   Eval      RCBR = *Blanks

     C**********         Eval      NWRK = 'SWIFT'                                           MD035623
     C                   EVAL      NWRK = WNETWK                                            MD035623
     C                   TIME                    MGTM
     C                   Eval      LATM = MGTM
     C                   Eval      LATM = MGTM

     C                   MOVEL     @CHG          AORR                                         CSW025
     C                   Write     MGOREFD0                             41
      *
      * Error on write to PF/MGOREFPD (message reference file)
      *
     C                   If        *IN41
     C     *LOCK         IN        LDA
     C                   Z-Add     18            DBASE                          * * * * * * * *
     C                   Movel     '       '     DBKEY                          *  DBERR 014  *
     C                   Movel     'MGOREFPD'    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif

      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
      *                    M E S S A G E     D A T A
      * Field :20: MT202
     C                   Eval      Q = Q + 1
     C                   Z-Add     1             Q
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':20:'
     C*******************Eval      MFLD = 'X' + %Subst(CCTID:2:15)
     C                   Eval      MFLD = 'X' + CCTID

      * Field :21: MT202 CCT Reference
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':21:'
     C                   Eval      MFLD = CCTID

      * Field :32A: As field 32A in CCT
     C                   If        Sav32A <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':32A:'
     C                   Eval      MFLD = Sav32A
     C                   Endif

      * Field :52A: As field 52A in CCT
     C                   If        Sav52A1 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   If        Sav52AType = 'A'
     C                   Eval      MTAG = ':52A:'
     C                   Else
     C                   Eval      MTAG = ':52C:'
     C                   Endif
     C                   Eval      MFLD = Sav52A1
     C                   If        Sav52A2 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C**********         Eval      MFLD = Sav52A1                                             CSW201
     C                   Eval      MFLD = Sav52A2                                             CSW201
     C                   Endif
     C                   Endif

      * Field :57A: As field 54A in CCT
     C                   If        Sav54A1 <> *Blanks

     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   If        Sav54AType = 'A'
     C                   Eval      MTAG = ':57A:'
     C                   Else
     C                   If        Sav54AType = 'B'
     C                   Eval      MTAG = ':54B:'
     C                   Else
     C                   Eval      MTAG = ':54D:'
     C                   Endif
     C                   Endif

     C                   Eval      MFLD = Sav54A1
     C                   If        Sav54A2 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = Sav54A2
     C                   Endif
                                                                                              CSW201
     C                   IF        Sav54A3 <> *Blanks                                         CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = Sav54A3                                             CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        Sav54A4 <> *Blanks                                         CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = Sav54A4                                             CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        Sav54A5 <> *Blanks                                         CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = Sav54A5                                             CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        Sav54AType <> 'A'                                          CSW209
     C                   EVAL      W57A = 'N'                                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   Endif

      * Field :58A: As field destination
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':58A:'
     C*******************Eval      MFLD = NWDS                                   184260
     C**********         Eval      MFLD = SavSndBicF                                 184260 BUG24516
     C                   Eval      MFLD = SavDstBicF                                        BUG24516
      *
      **  Write multiple occurrence data structure to MGOMSGPD
     C**********         Z-ADD     1             X                 2 0          190200
     C                   Z-ADD     1             X                 4 0          190200
     C     X             OCCUR     MULT
      *
     C                   Dow       X <= Q
     C                   Write     MGOMSGD0                             42
      *
      **  Error on write to PF/MGOMSGPD (message data file)
      *
     C                   If        *IN42
     C     *LOCK         IN        LDA
     C                   Z-Add     16            DBASE                          * * * * * * * *
     C                   Movel     '       '     DBKEY                          *  DBERR 005  *
     C                   Movel     'MGOMSGPD'    DBFILE                         * * * * * * * *
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Eval      X = X + 1
     C     X             OCCUR     MULT
     C                   Enddo
      *
     C                   Endif

     C                   Endsr
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SrWatch - Compliance Watch Processing                        *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrWatch       BEGSR                                                                CSD015
                                                                                              CSD015
      ** Check if message if for automatic release. If yes, default to CRTD status            CSD015
      ** and setup Automatic Release flag.                                                    CSD015
                                                                                              CSD015
     C                   IF        MGST = 'RSND' AND                                          CSD015
     C                             (NWRK = 'SWIFT' OR NWRK = 'TELEX' OR                       CSD015
     C                             NWRK = 'STTX')                                             CSD015
     C                   MOVEL     'CRTD'        MGST                                         CSD015
     C                   MOVEL     '1'           MGSG                                         CSD015
     C                   MOVEL     'Y'           PARLS                                        CSD015
     C                   ELSE                                                                 CSD015
     C                   MOVEL     'N'           PARLS                                        CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Initialise WLTDS data structure                                                      CSD015
                                                                                              CSD015
     C                   CLEAR                   WLTDS                                        CSD015
     C                   Z-ADD     *ZERO         W4AMT1                                       CSD015
     C                   Z-ADD     *ZERO         W4AMT2                                       CSD015
                                                                                              CSD015
      ** Setup parameter for Compliance Engine Program                                        CSD015
                                                                                              CSD015
     C                   EVAL      W4ITEM = MTPY                                              CSD015
     C                   EVAL      W4IDEN = TRNO                                              CSD015
     C                   EVAL      W4BRCH = BRCAA                                             CSD015
     C                   EVAL      W4FUNT = 'MGOREF'                                          CSD015
     C                   EVAL      W4ARLS = PARLS                                             CSD015
                                                                                              CSD015
      ** Access AOCUSTR0 to get details of Destination                                        CSD015
                                                                                              CSD015
     C                   EXSR      SrExtCust                                                  CSD015
                                                                                              CSD015
      ** Set up date fields                                                                   CSD015
                                                                                              CSD015
     C                   MOVE      RUND          PInDate                                      CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   MOVE      PAMDate       W4DDAT                                       CSD015
                                                                                              CSD015
     C                   MOVE      *ZEROS        PInDate                                      CSD015
     C                   EXSR      SrCvtDate                                                  CSD015
     C                   MOVE      PAMDate       W4VDAT                                       CSD015
     C                   MOVE      PAMDate       W4MDAT                                       CSD015
                                                                                              CSD015
      ***Send*Transaction*Details to Compliance Watch                                  CSD015 221145
      *******************                                                              CSD015 221145
     C*******************CALL      'SDCWLCHK'                                          CSD015 221145
     C*******************PARM                    WLTDS                                 CSD015 221145
     C*******************PARM      *BLANKS       PString                               CSD015 221145
                                                                                              CSD015
     C     SRWEND        ENDSR                                                                CSD015
      *****************************************************************                       221145
      /EJECT                                                                                  221145
      *****************************************************************                       221145
      *                                                               *                       221145
      * WLCDQ   - Submit information to Watch List Checking           *                       221145
      *                                                               *                       221145
      *****************************************************************                       221145
                                                                                              221145
     C     WLCDQ         BEGSR                                                                221145
                                                                                              221145
                                                                                              221145
      ** Send transaction to compliance engine program                                        221145
                                                                                              221145
     C                   CALL      'SDCWLCHK'                                                 221145
     C                   PARM                    WLTDS                                        221145
     C                   PARM      *BLANKS       PString                                      221145
                                                                                              221145
     C                   ENDSR                                                                221145
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SrCvtDate - Convert dates to be used for Watch Engine Pgm    *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrCvtDate     BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM                    PInDate                                      CSD015
     C                   PARM                    PAMDate                                      CSD015
     C                   PARM                    POutDate                                     CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
                                                                                              CSD015
      *****************************************************************                       CSD015
      /EJECT                                                          *                       CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      *  SrExtCust - Extract customer                                 *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrExtCust     BEGSR                                                                CSD015
                                                                                              CSD015
     C                   EVAL      PInput1 = NWDS                                             CSD015
     C                   EVAL      PInCcy = *BLANKS                                           CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM                    PInput1                                      CSD015
     C                   PARM      *BLANKS       PInput2                                      CSD015
     C                   PARM      *BLANKS       PInput3                                      CSD015
     C                   PARM      *BLANKS       PInput4                                      CSD015
     C                   PARM      *BLANKS       PInput5                                      CSD015
     C                   PARM      *BLANKS       PInput6                                      CSD015
     C                   PARM                    PInCcy                                       CSD015
     C                   PARM                    POutput                                      CSD015
     C                   PARM                    PCOutput                                     CSD015
                                                                                              CSD015
     C                   IF        PCOutput <> '*CPART' AND PCOutput <> '*FREE'               CSD015
     C                   EVAL      W4CNUM = PCOutput                                          CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C     EGetCntrPty   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
     C/EJECT
      *****************************************************************                       CSW209
     C     MT202COV      Begsr                                                                CSW209
                                                                                              CSW209
     C                   IF        SNDCOR <> *BLANKS  AND                                     CSW209
     C                             SavSndBic <> SavDstBic                                     CSW209
                                                                                              CSW209
     C*****CCTID         CAT(P)    'X':0         TRNO                                CSW209 BUG24805
     C                   MOVEL     TRNSID        TRNO                                       BUG24805
     C                   MOVEL     'X'           TRNO                                       BUG24805
     C                   EVAL      NWDS = SavSndBicF                                          CSW209
     C                   EVAL      SECN = SBICN                                               CSW209
     C                   EVAL      NWSN = STID                                                CSW209
                                                                                              CSW209
     C**********         EVAL      MTPY = '102'                                     CSW209 BUG24542A
     C                   EVAL      MTPY = '202'                                            BUG24542A
                                                                                              CSW209
     C                   IF        FTCS = 'R'                                                 CSW209
     C                   EVAL      MGST = 'RSND'                                              CSW209
     C                   EVAL      MGSG = '2'                                                 CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      MGST = 'CRTD'                                              CSW209
     C                   EVAL      MGSG = '1'                                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   EVAL      HRDT = @HRDT                                               CSW209
                                                                                              CSW209
     C                   CALL      'ZM1140'                                                   CSW209
     C                   PARM      TOTTRN        ZAMNT            15 0                        CSW209
     C                   PARM      WCDP          ZCDP              1 0                        CSW209
     C                   PARM      *Blanks       ZSAMNT           17                          CSW209
     C                   PARM      *Blanks       ZOAMNT           21                          CSW209
                                                                                              CSW209
     C                   EVAL      AMTX = ZSAMNT                                              CSW209
     C                   EVAL      AMTS = ZSAMNT                                              CSW209
                                                                                              CSW209
     C                   CALL      'ZM0060'                                                   CSW209
     C                   PARM      TTVDTE        ZMDAY                                        CSW209
     C                   PARM                    ZMDATE                                       CSW209
     C                   EVAL      SVDT = ZMDATE                                              CSW209
     C                   EVAL      CCY = CCTCCY                                               CSW209
     C                   EVAL      NSNO = *Zeros                                              CSW209
     C                   EVAL      SACN = *Blanks                                             CSW209
     C                   EVAL      AORR = *Blanks                                             CSW209
     C                   EVAL      DESI = SAVDSTBICF                                          CSW209
     C                   EVAL      BRCA = BRCAA                                               CSW209
     C                   EVAL      OTHB = ORBR                                                CSW209
     C                   EVAL      RCBR = *Blanks                                             CSW209
                                                                                              CSW209
     C**********         EVAL      NWRK = 'SWIFT'                                    CSW209 MD035623
     C                   EVAL      NWRK = WNETWK                                            MD035623
     C                   TIME                    MGTM                                         CSW209
     C                   EVAL      LATM = MGTM                                                CSW209
     C                   EVAL      LATM = MGTM                                                CSW209
                                                                                              CSW209
     C                   MOVEL     @CHG          AORR                                         CSW209
     C                   WRITE     MGOREFD0                             41                    CSW209
      *                                                                                       CSW209
      ** Error on write to PF/MGOREFPD (message reference file)                               CSW209
      *                                                                                       CSW209
     C                   IF        *IN41                                                      CSW209
     C     *LOCK         IN        LDA                                                        CSW209
     C                   Z-ADD     18            DBASE                                        CSW209
     C                   MOVEL     '       '     DBKEY                                        CSW209
     C                   MOVEL     'MGOREFPD'    DBFILE                                       CSW209
     C                   OUT       LDA                                                        CSW209
     C                   EXSR      *PSSR                                                      CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                     BUG24553
      ** Update Outgoing Validation Flag (Cover) CCOCVF to 'COV'                            BUG24553
      *                                                                                     BUG24553
     C     CCTID         CHAIN     FT102HL3                                                 BUG24553
     C                   EVAL      CCOCVF= 'COV'                                            BUG24553
     C                   UPDATE    CCT3                                                     BUG24553
                                                                                              CSW209
      * = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =                   CSW209
      *                    M E S S A G E     D A T A                                          CSW209
      ** Field :119: MT202 COV                                                                CSW209
      *                                                                                       CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C                   Z-ADD     1             Q                                            CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MTAG = ':119:'                                             CSW209
     C                   EVAL      MFLD = 'COV'                                               CSW209
      *                                                                                       CSW209
      ** Field :20: MT202 COV                                                                 CSW209
      *                                                                                       CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MTAG = ':20:'                                              CSW209
     C**********         EVAL      MFLD = 'X' + CCTID                                CSW209 BUG24804
     C**********         EVAL      MFLD = 'X' + TRNSID                             BUG24804 BUG24884
     C                   MOVEL     TRNSID        MFLD                                       BUG24884
     C                   MOVEL     'X'           MFLD                                       BUG24884
      *                                                                                       CSW209
      ** Field :21: MT202 COV CCT Reference                                                   CSW209
      *                                                                                       CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MTAG = ':21:'                                              CSW209
     C**********         EVAL      MFLD = CCTID                                      CSW209 BUG24804
     C                   EVAL      MFLD = TRNSID                                            BUG24804
      *                                                                                       CSW209
      ** Field :32A: As field 32A in CCT                                                      CSW209
      *                                                                                       CSW209
     C                   IF        Sav32A <> *Blanks                                          CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MTAG = ':32A:'                                             CSW209
     C**********         EVAL      MFLD = Sav32A                                     CSW209 BUG24865
     C                   MOVEL     AMNT32        AMNT32A                                    BUG24865
     C                   EVAL      MFLD = FLD32A                                            BUG24865
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Field :52A: As field 52A in CCT                                                      CSW209
      *                                                                                       CSW209
     C                   IF        Sav52A1 <> *Blanks                                         CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   IF        Sav52AType = 'A'                                           CSW209
     C                   EVAL      MTAG = ':52A:'                                             CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      MTAG = ':52C:'                                             CSW209
     C                   ENDIF                                                                CSW209
     C                   EVAL      MFLD = Sav52A1                                             CSW209
     C                   IF        Sav52A2 <> *BLANKS                                         CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = Sav52A2                                             CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Field :57A: As field 54A in CCT                                                      CSW209
      *                                                                                       CSW209
     C                   IF        Sav54A1 <> *BLANKS                                         CSW209
                                                                                              CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   IF        Sav54AType = 'A'                                           CSW209
     C                   EVAL      MTAG = ':57A:'                                             CSW209
     C                   ELSE                                                                 CSW209
     C                   IF        Sav54AType = 'B'                                           CSW209
     C                   EVAL      MTAG = ':54B:'                                             CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      MTAG = ':54D:'                                             CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   EVAL      MFLD = Sav54A1                                             CSW209
     C                   IF        Sav54A2 <> *BLANKS                                         CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = Sav54A2                                             CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        Sav54A3 <> *BLANKS                                         CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MFLD = Sav54A3                                             CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        Sav54A4 <> *Blanks                                         CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MFLD = Sav54A4                                             CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        Sav54A5 <> *Blanks                                         CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             OCCUR     MULT                                                       CSW209
     C                   EVAL      MFLD = Sav54A5                                             CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Field :58A: As field destination                                                     CSW209
      *                                                                                       CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MTAG = ':58A:'                                             CSW209
     C                   EVAL      MFLD = SavDstBicF                                          CSW209
      *                                                                                       CSW209
      ** Field :50A: Sequence B                                                               CSW209
      *                                                                                       CSW209
     C                   IF        FLDCOV1 <> *BLANKS                                         CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MTAG = TAG202                                              CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   EVAL      MFLD = FLDCOV1                                             CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        FLDCOV2 <> *BLANKS                                         CSW209
     C                   EVAL      Q = Q +1                                                   CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   Eval      MSEQ = 'B'                                               BUG24811
     C                   EVAL      MFLD = FLDCOV2                                             CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   IF        FLDCOV3 <> *BLANKS                                         CSW209
     C                   EVAL      Q = Q +1                                                   CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   Eval      MSEQ = 'B'                                               BUG24811
     C                   EVAL      MFLD = FLDCOV3                                             CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   IF        FLDCOV4 <> *BLANKS                                         CSW209
     C                   EVAL      Q = Q +1                                                   CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   Eval      MSEQ = 'B'                                               BUG24811
     C                   EVAL      MFLD = FLDCOV4                                             CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        FLDCOV5 <> *BLANKS                                         CSW209
     C                   EVAL      Q = Q +1                                                   CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   Eval      MSEQ = 'B'                                               BUG24811
     C                   EVAL      MFLD = FLDCOV5                                             CSW209
     C                   ENDIF                                                                CSW209
     C                   EXSR      GetEXTN                                                    CSW209
      *                                                                                       CSW209
      ** Field :52A: Sequence B                                                               CSW209
      *                                                                                       CSW209
     C                   IF        Sav52A1 <> *Blanks                                         CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   IF        Sav52AType = 'A'                                           CSW209
     C                   EVAL      MTAG = ':52A:'                                             CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      MTAG = ':52C:'                                             CSW209
     C                   ENDIF                                                                CSW209
     C                   EVAL      MFLD = Sav52A1                                             CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   IF        Sav52A2 <> *Blanks                                         CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = Sav52A2                                             CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Field :57A: Sequence B                                                               CSW209
      *                                                                                       CSW209
     C**********         IF        Sav54A1 <> *Blanks                                CSW209 BUG24806
     C                   IF        Sav57a <> *Blanks                                        BUG24806
                                                                                              CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C**********         IF        Sav54AType = 'A'                                  CSW209 BUG24806
     C                   IF        Sav57aType = 'A'                                         BUG24806
     C                   EVAL      MTAG = ':57A:'                                             CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      MTAG = ':57C:'                                           BUG24806
     C**********         IF        Sav54AType = 'B'                                  CSW209 BUG24806
     C**********         EVAL      MTAG = ':54B:'                                    CSW209 BUG24806
     C**********         ELSE                                                        CSW209 BUG24806
     C**********         EVAL      MTAG = ':54D:'                                    CSW209 BUG24806
     C**********         ENDIF                                                       CSW209 BUG24806
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C**********         EVAL      MFLD = Sav54A1                                    CSW209 BUG24806
     C                   EVAL      MFLD = Sav57a                                            BUG24806
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C**********         IF        Sav54A2 <> *Blanks                                CSW209 BUG24806
     C**********         EVAL      Q = Q + 1                                         CSW209 BUG24806
     C*****Q****         Occur     MULT                                              CSW209 BUG24806
     C**********         EVAL      MFLD = Sav54A2                                    CSW209 BUG24806
     C**********         EVAL      MSEQ = 'B'                                        CSW209 BUG24806
     C**********         ENDIF                                                       CSW209 BUG24806
      **********                                                                     CSW209 BUG24806
     C**********         IF        Sav54A3 <> *Blanks                                CSW209 BUG24806
     C**********         EVAL      Q = Q + 1                                         CSW209 BUG24806
     C*****Q****         OCCUR     MULT                                              CSW209 BUG24806
     C**********         EVAL      MFLD = Sav54A3                                    CSW209 BUG24806
     C**********         EVAL      MSEQ = 'B'                                        CSW209 BUG24806
     C**********         ENDIF                                                       CSW209 BUG24806
      **********                                                                     CSW209 BUG24806
     C**********         IF        Sav54A4 <> *Blanks                                CSW209 BUG24806
     C**********         EVAL      Q = Q + 1                                         CSW209 BUG24806
     C*****Q****         OCCUR     MULT                                              CSW209 BUG24806
     C**********         EVAL      MFLD = Sav54A4                                    CSW209 BUG24806
     C**********         EVAL      MSEQ = 'B'                                        CSW209 BUG24806
     C**********         ENDIF                                                       CSW209 BUG24806
      **********                                                                     CSW209 BUG24806
     C**********         IF        Sav54A5 <> *Blanks                                CSW209 BUG24806
     C**********         EVAL      Q = Q + 1                                         CSW209 BUG24806
     C*****Q****         OCCUR     MULT                                              CSW209 BUG24806
     C**********         EVAL      MFLD = Sav54A5                                    CSW209 BUG24806
     C**********         EVAL      MSEQ = 'B'                                        CSW209 BUG24806
     C**********         ENDIF                                                       CSW209 BUG24806
                                                                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Field :59A: Sequence B                                                               CSW209
      *                                                                                       CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MTAG = TAG202B                                             CSW209
     C                   EVAL      MFLD = FLDCOVB1                                            CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
                                                                                              CSW209
     C                   IF        FLDCOVB2 <> *BLANKS                                        CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = FLDCOVB2                                            CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   IF        FLDCOVB3 <> *BLANKS                                        CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = FLDCOVB3                                            CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   IF        FLDCOVB4 <> *BLANKS                                        CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = FLDCOVB4                                            CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   IF        FLDCOVB5 <> *BLANKS                                        CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = FLDCOVB5                                            CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Field :70: Sequence B                                                                CSW209
      *                                                                                       CSW209
     C                   IF        REMI1 <> *Blanks                                           CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MTAG = ':70:'                                              CSW209
     C                   EVAL      MFLD = REMI1                                               CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        REMI2 <> *Blanks                                           CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = REMI2                                               CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        REMI3 <> *Blanks                                           CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = REMI3                                               CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        REMI4 <> *Blanks                                           CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = REMI4                                               CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Field :72: Sequence B                                                                CSW209
      *                                                                                       CSW209
     C                   IF        ADNLI1 <> *Blanks                                          CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   IF        Fld72On <> 'Y'                                             CSW209
     C                   EVAL      MTAG = ':72:'                                              CSW209
     C                   ENDIF                                                                CSW209
     C                   EVAL      MFLD = ADNLI1                                              CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
                                                                                              CSW209
     C                   IF        ADNLI2 <> *Blanks                                          CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = ADNLI2                                              CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI3 <> *Blanks                                          CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = ADNLI3                                              CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI4 <> *Blanks                                          CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = ADNLI4                                              CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   If        ADNLI5 <> *Blanks                                          CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = ADNLI5                                              CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI6 <> *Blanks                                          CSW209
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MFLD = ADNLI6                                              CSW209
     C                   EVAL      MSEQ = 'B'                                                 CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Field :33B: Sequence B                                                               CSW209
      *                                                                                       CSW209
     C                   IF        FLD33 <> *BLANKS                                         BUG24865
     C                   EVAL      Q = Q + 1                                                  CSW209
     C     Q             Occur     MULT                                                       CSW209
     C                   EVAL      MTAG = ':33B:'                                             CSW209
     C                   Eval      MSEQ = 'B'                                               BUG24811
     C                   EVAL      CCY33 = PAYCCY                                             CSW209
     C                   EVAL      WCCY = PAYCCY                                              CSW209
     C                   EVAL      WAMNT = PAYAMT                                             CSW209
     C                   EXSR      SRFAMT                                                     CSW209
     C                   EVAL      AMNT33 = AMT                                               CSW209
     C                   EVAL      MFLD = FLD33                                               CSW209
     C                   ENDIF                                                              BUG24865
      *                                                                                       CSW209
      **  Write multiple occurrence data structure to MGOMSGPD                                CSW209
     C                   Z-ADD     1             X                 4 0                        CSW209
     C     X             OCCUR     MULT                                                       CSW209
      *                                                                                       CSW209
     C                   Dow       X <= Q                                                     CSW209
     C                   Write     MGOMSGD0                             42                    CSW209
      *                                                                                       CSW209
      **  Error on write to PF/MGOMSGPD (message data file)                                   CSW209
      *                                                                                       CSW209
     C                   If        *IN42                                                      CSW209
     C     *LOCK         IN        LDA                                                        CSW209
     C                   Z-Add     16            DBASE                                        CSW209
     C                   Movel     '       '     DBKEY                                        CSW209
     C                   Movel     'MGOMSGPD'    DBFILE                                       CSW209
     C                   OUT       LDA                                                        CSW209
     C                   Exsr      *PSSR                                                      CSW209
     C                   Endif                                                                CSW209
      *                                                                                       CSW209
     C                   Eval      X = X + 1                                                  CSW209
     C     X             OCCUR     MULT                                                       CSW209
     C                   Enddo                                                                CSW209
      *                                                                                       CSW209
     C                   Endif                                                                CSW209
                                                                                              CSW209
     C                   Endsr                                                                CSW209
     C/EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR72 - Sets on W72 flag if all the conditions for field 72    *                       CSW209
      *        are satisfied.                                         *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
     C     SR72          BEGSR                                                                CSW209
      *                                                                                       CSW209
      ** It must not contain the codeword /REJT/, /RETN/, /OCMT/ and /CHGS/                   CSW209
      *                                                                                       CSW209
     C                   MOVE      'N'           W72                                          CSW209
                                                                                              CSW209
     C                   IF        ADNLI1 <> *BLANKS                                          CSW209
     C     '/REJT/'      SCAN      ADNLI1                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/RETN/'      SCAN      ADNLI1                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/OCMT/'      SCAN      ADNLI1                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/CHGS/'      SCAN      ADNLI1                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI2 <> *BLANKS                                          CSW209
     C     '/REJT/'      SCAN      ADNLI2                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/RETN/'      SCAN      ADNLI2                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/OCMT/'      SCAN      ADNLI2                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/CHGS/'      SCAN      ADNLI2                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI3 <> *BLANKS                                          CSW209
     C     '/REJT/'      SCAN      ADNLI3                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/RETN/'      SCAN      ADNLI3                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/OCMT/'      SCAN      ADNLI3                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/CHGS/'      SCAN      ADNLI3                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI4 <> *BLANKS                                          CSW209
     C     '/REJT/'      SCAN      ADNLI4                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/RETN/'      SCAN      ADNLI4                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/OCMT/'      SCAN      ADNLI4                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/CHGS/'      SCAN      ADNLI4                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI5 <> *BLANKS                                          CSW209
     C     '/REJT/'      SCAN      ADNLI4                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/RETN/'      SCAN      ADNLI5                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/OCMT/'      SCAN      ADNLI5                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/CHGS/'      SCAN      ADNLI5                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI6 <> *BLANKS                                          CSW209
     C     '/REJT/'      SCAN      ADNLI4                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/RETN/'      SCAN      ADNLI6                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/OCMT/'      SCAN      ADNLI6                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     '/CHGS/'      SCAN      ADNLI6                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** If field 72 contains /INS/, it should be followed by a SWIFT                         CSW209
      ** address.  The SWIFT address will be validated via call to                            CSW209
      ** ME1400.  It is a SWIFT address if it is found in Customers                           CSW209
      ** file, Counterparty Nostros file, or in BIC Directory.                                CSW209
      *                                                                                       CSW209
     C                   IF        ADNLI1 <> *BLANKS                                          CSW209
     C     '/INS/'       SCAN      ADNLI1                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   EVAL      PMBICC = %SUBST(ADNLI1:6:8)                                CSW209
     C                   EVAL      PMBICB = %SUBST(ADNLI1:15:3)                               CSW209
     C                   EXSR      SR1400                                                     CSW209
     C                   IF        PMCUST <> 'Y' AND                                          CSW209
     C                             PMCNST <> 'Y' AND                                          CSW209
     C                             PMBICD <> 'Y'                                              CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI2 <> *BLANKS                                          CSW209
     C     '/INS/'       SCAN      ADNLI2                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   EVAL      PMBICC = %SUBST(ADNLI2:6:8)                                CSW209
     C                   EVAL      PMBICB = %SUBST(ADNLI2:15:3)                               CSW209
     C                   EXSR      SR1400                                                     CSW209
     C                   IF        PMCUST <> 'Y' AND                                          CSW209
     C                             PMCNST <> 'Y' AND                                          CSW209
     C                             PMBICD <> 'Y'                                              CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI3 <> *BLANKS                                          CSW209
     C     '/INS/'       SCAN      ADNLI3                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   EVAL      PMBICC = %SUBST(ADNLI3:6:8)                                CSW209
     C                   EVAL      PMBICB = %SUBST(ADNLI3:15:3)                               CSW209
     C                   EXSR      SR1400                                                     CSW209
     C                   IF        PMCUST <> 'Y' AND                                          CSW209
     C                             PMCNST <> 'Y' AND                                          CSW209
     C                             PMBICD <> 'Y'                                              CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI4 <> *BLANKS                                          CSW209
     C     '/INS/'       SCAN      ADNLI4                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   EVAL      PMBICC = %SUBST(ADNLI4:6:8)                                CSW209
     C                   EVAL      PMBICB = %SUBST(ADNLI4:15:3)                               CSW209
     C                   EXSR      SR1400                                                     CSW209
     C                   IF        PMCUST <> 'Y' AND                                          CSW209
     C                             PMCNST <> 'Y' AND                                          CSW209
     C                             PMBICD <> 'Y'                                              CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI5 <> *BLANKS                                          CSW209
     C     '/INS/'       SCAN      ADNLI5                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   EVAL      PMBICC = %SUBST(ADNLI5:6:8)                                CSW209
     C                   EVAL      PMBICB = %SUBST(ADNLI5:15:3)                               CSW209
     C                   EXSR      SR1400                                                     CSW209
     C                   IF        PMCUST <> 'Y' AND                                          CSW209
     C                             PMCNST <> 'Y' AND                                          CSW209
     C                             PMBICD <> 'Y'                                              CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   IF        ADNLI6 <> *BLANKS                                          CSW209
     C     '/INS/'       SCAN      ADNLI6                                 95                  CSW209
     C                   IF        *IN95 = *ON                                                CSW209
     C                   EVAL      PMBICC = %SUBST(ADNLI6:6:8)                                CSW209
     C                   EVAL      PMBICB = %SUBST(ADNLI6:15:3)                               CSW209
     C                   EXSR      SR1400                                                     CSW209
     C                   IF        PMCUST <> 'Y' AND                                          CSW209
     C                             PMCNST <> 'Y' AND                                          CSW209
     C                             PMBICD <> 'Y'                                              CSW209
     C                   GOTO      END72                                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   MOVE      'Y'           W72                                          CSW209
     C                                                                                        CSW209
     C     END72         ENDSR                                                                CSW209
     C/EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR1400  - Call to ME1400                                      *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
     C     SR1400        BEGSR                                                                CSW209
                                                                                              CSW209
     C                   CALL      'ME1400'                                                   CSW209
     C                   PARM      *BLANKS       @RTCD                                        CSW209
     C                   PARM                    PMBICC                                       CSW209
     C                   PARM                    PMBICB                                       CSW209
     C                   PARM                    SDCUST                                       CSW209
     C                   PARM                    SDCNST                                       CSW209
     C                   PARM                    MEBICD                                       CSW209
     C                   PARM      *BLANKS       PMCUST                                       CSW209
     C                   PARM      *BLANKS       PMCNST                                       CSW209
     C                   PARM      *BLANKS       PMBICD                                       CSW209
                                                                                              CSW209
     C                   ENDSR                                                                CSW209
     C/EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SRIBAN - Determine if Beneficiary Bank is an IBAN             *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
     C     SRIBAN        BEGSR                                                                CSW209
                                                                                              CSW209
     C                   EVAL      WIBAN09 = %SUBST(BENF1:2:34)                               CSW209
     C                   MOVE      *BLANKS       W@IBAN           34                          CSW209
     C                                                                                        CSW209
     C                   CALL      'AOIBANR3'                                                 CSW209
     C                   PARM      *BLANKS       PRTCD                                        CSW209
     C                   PARM                    WIBAN09          47                          CSW209
     C                   PARM                    POWITH           47                          CSW209
     C     W@IBAN        PARM                    PONOBL           34                          CSW209
     C                   IF        PRTCD = *BLANKS                                            CSW209
     C                   EVAL      WTRD1 = %SUBST(W@IBAN:1:1)                                 CSW209
     C                   EVAL      WTRD2 = %SUBST(W@IBAN:2:1)                                 CSW209
     C                   EVAL      WTRD3 = %SUBST(W@IBAN:3:1)                                 CSW209
     C                   EVAL      WTRD4 = %SUBST(W@IBAN:4:1)                                 CSW209
     C                   IF        %LOOKUP(WTRD1:#ALPH) > 0 AND                               CSW209
     C                             %LOOKUP(WTRD2:#ALPH) > 0 AND                               CSW209
     C                             %LOOKUP(WTRD3:#NUMC) > 0 AND                               CSW209
     C                             %LOOKUP(WTRD4:#NUMC) > 0                                   CSW209
     C                   CALL      'AOIBANR5'                                                 CSW209
     C                   PARM      *BLANKS       PRTCD                                        CSW209
     C                   PARM                    W@IBAN                                       CSW209
     C                   IF        PRTCD = *BLANKS                                            CSW209
     C                   MOVE      'Y'           WIBANF                                       CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
     C                                                                                        CSW209
     C                   ENDSR                                                                CSW209
     C/EJECT                                                                                  CSW209
      *****************************************************************                       CSW207
      *                                                               *                       CSW207
      * SRFORMAT   - Format ":50F:" for ordering                      *                       CSW207
      *              customer in a SWIFT message                      *                       CSW207
      *                                                               *                       CSW207
      * Calls: FT001000                                               *                       CSW207
      *                                                               *                       CSW207
      *****************************************************************                       CSW207
                                                                                              CSW207
     C     SRFORMAT      BEGSR                                                                CSW207
      *                                                                                       CSW207
     C**********         CALLB     'AOACCTV1'                                         CSW207 CSW207A
     C**********         PARM      *Blanks       @RTCD                                CSW207 CSW207A
     C**********         PARM      *Blanks       @Type                                CSW207 CSW207A
     C**********         PARM                    ParmStr                              CSW207 CSW207A
     C**********         PARM                    DSSDY                                CSW207 CSW207A
      **********                                                                      CSW207 CSW207A
     C**********         IF        @RTCD = *BLANKS                                    CSW207 CSW207A
     C**********         EVAL      P@ACC = DSSDY                                      CSW207 CSW207A
     C**********         MOVEL     CNUM          PCNUM                                CSW207 CSW207A
     C**********         Eval      PATYP = *Blanks                                BUG14755 BUG15010A
     C                   Movel     *Blanks       PCCD                                      BUG15010A
     C                   Movel     *Blanks       PCNUM                                     BUG15010A
     C                   Movel     *Blanks       PACNT                                     BUG15010A
     C                   Movel     *Blanks       PNOST                                     BUG15010A
      *                                                                                    BUG15010A
      ** get Country of location of Destination                                            BUG15010A
     C                   If        %Subst(CCTDST:1:1) = '/'                                BUG15010A
     C                   EVAL      ParmStr = %SUBST(CCTDST:2:34)                           BUG15010A
     C                   Else                                                              BUG15010A
     C                   EVAL      ParmStr = CCTDST                                        BUG15010A
     C                   EndIf                                                             BUG15010A
      *                                                                                    BUG15010A
     C                   CallB     'AOACCTV1'                                               BUG14755
     C                   Parm      *Blanks       @RTCD                                      BUG14755
     C                   Parm      *Blanks       @Type                                      BUG14755
     C                   Parm                    ParmStr                                    BUG14755
     C**********         Parm                    DSSDY                            BUG14755 BUG15010A
     C                   Parm      *Blanks       A_DSSDY                                   BUG15010A
                                                                                            BUG14755
     C                   If        @RTCD = *BLANKS                                          BUG14755
                                                                                            BUG14755
     C                   Select                                                             BUG14755
     C                   When      @Type = '*RETAIL'                                        BUG14755
     C                             Or @Type = '*LEDGER'                                     BUG14755
     C                             Or @Type = '*NOSTRO'                                    BUG15010A
     C**********         If        @Type = '*RETAIL'                              BUG14755 BUG15010A
     C**********         Eval      PATYP = 'R'                                    BUG14755 BUG15010A
     C**********         Else                                                     BUG14755 BUG15010A
     C**********         Eval      PATYP = 'G'                                    BUG14755 BUG15010A
     C**********         EndIf                                                    BUG14755 BUG15010A
     C**********         Eval      SDACCNT = DSSDY                                BUG14755 BUG15010A
     C**********         Move      SWF07CNUM     WCNUM             6              BUG14755 BUG15010A
     C**********         Move      SWF07ACOD     WACOD            10              BUG14755 BUG15010A
     C**********         Move      SWF07ACSQ     WACSQ             2              BUG14755 BUG15010A
     C**********         Eval      PACNT = SWF07BRCA+ WCNUM + SWF07CCY            BUG14755 BUG15010A
     C**********                        + WACOD + WACSQ                           BUG14755 BUG15010A
                                                                                           BUG15010A
     C                   If        @Type = '*NOSTRO'                                       BUG15010A
     C                   Eval      N_SDNOST = A_DSSDY                                      BUG15010A
     C                   Movel     N_A7CUST      @KEY1                                     BUG15010A
     C                   Movel     N_A7NONB      PNOST                                     BUG15010A
     C                   Else                                                              BUG15010A
     C                   Eval      SDACCNT = A_DSSDY                                       BUG15010A
     C                   Move      SWF07CNUM     WCNUM             6                       BUG15010A
     C                   Movel     WCNUM         @KEY1                                     BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
     C                   CALL      'AOCUSTR0'                                              BUG15010A
     C                   PARM      *BLANKS       @RTCD                                     BUG15010A
     C                   PARM      '*KEY   '     @OPTN                                     BUG15010A
     C                   PARM                    @KEY1                                     BUG15010A
     C                   PARM      *BLANKS       @KYST                                     BUG15010A
     C     C_SDCUST      PARM      *BLANKS       A_DSSDY                                   BUG15010A
                                                                                           BUG15010A
      * if valid customer capture Country of location as Parameter to FT001000             BUG15010A
     C                   IF        @RTCD = *BLANKS                                         BUG15010A
     C                   Movel     C_BBCOLC      PCCD                                      BUG15010A
     C                   ENDIF                                                             BUG15010A
                                                                                            BUG14755
     C                   When      @Type = '*CUSTNO'                                        BUG14755
     C                             Or @Type = '*SHNAME'                                     BUG14755
     C**********         Eval      PATYP = 'C'                                    BUG14755 BUG15010A
     C**********         Eval      PCNUM = ParmStr                                BUG14755 BUG15010A
     C**********         Eval      PCCD = BBCOLC                                  BUG15010 BUG15010A
     C                   Eval      C_SDCUST = A_DSSDY                                      BUG15010A
     C                   Movel     C_BBCOLC      PCCD                                      BUG15010A
                                                                                           BUG15010A
     C                   When      @Type = '*SWIFT'                                        BUG15010A
     C                   Eval      PCCD = %Subst(ParmStr:5:2)                              BUG15010A
                                                                                            BUG14755
     C                   EndSl                                                              BUG14755
                                                                                            BUG14755
     C                   Else                                                               BUG14755
     C                   Movel     ParmStr       WIBAN                                      BUG14755
     C     WIBAN         Chain     ACCNTL6F                           10                    BUG14755
     C                   If         Not *IN10                                               BUG14755
     C**********         Eval      PATYP = 'I'                                    BUG14755 BUG15010A
     C**********         Move      CNUM          WCNUM             6              BUG14755 BUG15010A
     C**********         Move      ACOD          WACOD            10              BUG14755 BUG15010A
     C**********         Move      ACSQ          WACSQ             2              BUG14755 BUG15010A
     C**********         Eval      PACNT = BRCA + WCNUM + CCY                     BUG14755 BUG15010A
     C**********                        + WACOD + WACSQ                           BUG14755 BUG15010A
                                                                                           BUG15010A
     C                   Move      CNUM          WCNUM                                     BUG15010A
     C                   Movel     WCNUM         @KEY1                                     BUG15010A
     C                   CALL      'AOCUSTR0'                                              BUG15010A
     C                   PARM      *BLANKS       @RTCD                                     BUG15010A
     C                   PARM      '*KEY   '     @OPTN                                     BUG15010A
     C                   PARM                    @KEY1                                     BUG15010A
     C                   PARM      *BLANKS       @KYST                                     BUG15010A
     C     C_SDCUST      PARM      *BLANKS       A_DSSDY                                   BUG15010A
                                                                                           BUG15010A
      * if valid IBAN capture Country of location as Parameter to FT001000                 BUG15010A
     C                   IF        @RTCD = *BLANKS                                         BUG15010A
     C                   Movel     C_BBCOLC      PCCD                                      BUG15010A
     C                   ENDIF                                                             BUG15010A
     C                   EndIf                                                              BUG14755
     C                   EndIf                                                              BUG14755
                                                                                            BUG15090
     C                   MOVE      *BLANKS       OCTYP             1                        BUG15090
     C                   If        CUSTTD <> *Blanks                                        BUG15090
     C                   Eval      OCTYP = CUSTTD                                           BUG15090
     C                   Else                                                               BUG15090
     C                   Eval      OCTYP = CUSTTH                                           BUG15090
     C                   EndIf                                                              BUG15090
                                                                                           BUG15010A
      ** Get Nostro parameter from Sender or Receiver Correspondent if <> Blanks           BUG15010A
     C                   If        SNDCOR <> *Blanks Or                                    BUG15010A
     C                             RCVCOR <> *Blanks                                       BUG15010A
     C                   Exsr      GetNostro                                               BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
      ** if input type is customer, set value to customer parameter of FT001000            BUG15010A
     C                   If        OCTYP = 'C'                                             BUG15010A
     C                   If        %subst(PIN1:1:1) = '/'                                   BUG15250
     C                             and CSW207 = 'Y'                                         BUG15250
     C                   Movel     PIN2          PCNUM                                      BUG15250
     C                   Else                                                               BUG15250
     C                   Movel     PIN1          PCNUM                                     BUG15010A
     C                   EndIf                                                              BUG15250
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
      ** if input type is IBAN, Retail or Ledger, set Account parameter of FT001000        BUG15010A
     C                   If        OCTYP = 'I' Or                                          BUG15010A
     C                             OCTYP = 'P' Or                                          BUG15010A
     C                             OCTYP = 'G' Or                                           BUG19611
     C                             OCTYP = 'R'                                             BUG15010A
     C                   Exsr      GetAccount                                              BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                              CSW207
     C                   Call      'FT001000'                                                 CSW207
      ** Return Code                                                                          CSW207
     C                   Parm      *BLANKS       PRTCD             7                          CSW207
      ** Message ID Field                                                                     CSW207
     C                   Parm      *BLANKS       PMSGID            7                          CSW207
      ** Flag                                                                                 CSW207
     C                   Parm      *BLANK        PFLAG             1                          CSW207
      ** Type of Validation                                                                   CSW207
     C                   Parm      'FRMT'        PVALTYP           4                          CSW207
      ** 5X35 lines to be checked                                                             CSW207
     C                   Parm                    PIN1             35                          CSW207
     C                   Parm                    PIN2             35                          CSW207
     C                   Parm                    PIN3             35                          CSW207
     C                   Parm                    PIN4             35                          CSW207
     C                   Parm                    PIN5             35                          CSW207
      ** Input Type                                                                           CSW207
     C**********         Parm                    PATYP             1                 CSW207 BUG15065
     C**********         Parm      CUSTTH        PATYP             1               BUG15065 BUG15090
     C                   Parm      OCTYP         PATYP             1                        BUG15090
      ** Account                                                                              CSW207
     C                   Parm                    PACNT            34                          CSW207
      ** Customer Number                                                                      CSW207
     C**********         Parm                    PCNUM             6                  CSW207 CSW207A
     C**********         Parm      *Blanks       PCNUM             6                CSW207A BUG14862
     C                   Parm                    PCNUM             6                        BUG14862
      ** Non Account Holder                                                                   CSW207
     C**********         Parm                    PNAHT            10                CSW207 BUG15010A
     C                   Parm      *Blanks       PNAHT            10                       BUG15010A
      ** Network                                                                              CSW207
     C                   Parm      'SWIFT'       PNWRK             6                          CSW207
      ** Message Type                                                                         CSW207
     C                   Parm      '102'         PMSGTP            3                          CSW207
      ** Message Tag                                                                          CSW207
     C                   Parm      ':50F:'       PMSGTG            5                          CSW207
      ** Country of Location                                                                  CSW207
     C                   Parm                    PCCD              2                          CSW207
      ** Branch Code                                                                          CSW207
     C**********         Parm                    PBRCH             3                 CSW207 BUG15010
     C                   Parm      BRCA          PBRCH             3                        BUG15010
      ** Currency Code                                                                        CSW207
     C**********         Parm      CCY           PCCY              3                 CSW207 BUG15010
     C                   Parm      CCTCCY        PCCY              3                        BUG15010
      ** Nostro                                                                               CSW207
     C                   Parm                    PNOST             2                          CSW207
      ** Module Indicator                                                                     CSW207
     C**********         Parm                    PMODI             2                 CSW207 BUG15010
     C                   Parm      'FT'          PMODI             2                        BUG15010
      ** 5X35 lines to be output                                                              CSW207
     C                   Parm                    POUT1            35                          CSW207
     C                   Parm                    POUT2            35                          CSW207
     C                   Parm                    POUT3            35                          CSW207
     C                   Parm                    POUT4            35                          CSW207
     C                   Parm                    POUT5            35                          CSW207
      *                                                                                       CSW207
     C                   IF        PRTCD = *BLANKS                                            CSW207
     C**********         EVAL      MTAG = ':50F:'                                    CSW207A CSW207A
      *                                                                                       CSW207
      * Message 1                                                                             CSW207
     C                   IF        POUT1 <> *BLANKS                                           CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   EVAL      MTAG = ':50F:'                                             CSW207
     C                   EVAL      SAVMTG = MTAG                                            BUG19322
     C                   MOVEL     POUT1         MFLD                                         CSW207
     C                   EVAL      TAG202 = MTAG                                            BUG24735
     C                   MOVEL     POUT1         FLDCOV1                                    BUG24735
      * Message 2                                                                             CSW207
     C                   IF        POUT2 <> *BLANKS                                           CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   MOVEL     POUT2         MFLD                                         CSW207
     C                   MOVEL     POUT2         FLDCOV2                                    BUG24735
      * Message 3                                                                             CSW207
     C                   IF        POUT3 <> *BLANKS                                           CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   MOVEL     POUT3         MFLD                                         CSW207
     C                   MOVEL     POUT3         FLDCOV3                                    BUG24735
      * Message 4                                                                             CSW207
     C                   IF        POUT4 <> *BLANKS                                           CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   MOVEL     POUT4         MFLD                                         CSW207
     C                   MOVEL     POUT4         FLDCOV4                                    BUG24735
      * Message 5                                                                             CSW207
     C                   IF        POUT5 <> *BLANKS                                           CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   MOVEL     POUT5         MFLD                                         CSW207
     C                   MOVEL     POUT5         FLDCOV5                                    BUG24735
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
     C**********         EVAL      MTAG = ':50F:'                                     CSW207 CSW207A
     C                   EXSR      GetEXTN                                                  BUG19322
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C**********         ENDIF                                                        CSW207 CSW207A
      *                                                                                       CSW207
     C                   ENDSR                                                                CSW207
                                                                                              CSW207
      *****************************************************************                       CSW207
      /EJECT                                                                                  CSW207
      *****************************************************************                    BUG15010A
      *                                                               *                    BUG15010A
      *  GetNostro - Get Nostro parameter for FT001000                *                    BUG15010A
      *                                                               *                    BUG15010A
      *****************************************************************                    BUG15010A
     C     GetNostro     BEGSR                                                             BUG15010A
                                                                                           BUG15010A
     C                   If        SNDCOR <> *Blanks                                       BUG15010A
     C                   EVAL      ParmStr = SNDCOR                                        BUG15010A
     C                   Else                                                              BUG15010A
     C                   EVAL      ParmStr = RCVCOR                                        BUG15010A
     C                   Endif                                                             BUG15010A
                                                                                           BUG15010A
     C                   CallB     'AOACCTV1'                                              BUG15010A
     C                   Parm      *Blanks       @RTCD                                     BUG15010A
     C                   Parm      *Blanks       @Type                                     BUG15010A
     C                   Parm                    ParmStr                                   BUG15010A
     C                   Parm      *Blanks       A_DSSDY                                   BUG15010A
                                                                                           BUG15010A
     C                   If        @RTCD = *BLANKS                                         BUG15010A
                                                                                           BUG15010A
     C                   Select                                                            BUG15010A
     C                   When      @Type = '*NOSTRO'                                       BUG15010A
     C                   Eval      N_SDNOST = A_DSSDY                                      BUG15010A
     C                   Movel     N_A7NONB      PNOST                                     BUG15010A
                                                                                           BUG15010A
     C                   When      @Type = '*RETAIL'                                       BUG15010A
     C                             Or @Type = '*LEDGER'                                    BUG15010A
     C                   Eval      SDACCNT = A_DSSDY                                       BUG15010A
     C                   Move      SWF07CNUM     PCUST                                     BUG15010A
     C                   Movel     SWF07CCY      PCYCD                                     BUG15010A
     C                   Move      SWF07ACOD     PACCD                                     BUG15010A
     C                   Move      SWF07ACSQ     PACSN                                     BUG15010A
     C                   Movel     SWF07BRCA     PBRCD                                     BUG15010A
                                                                                           BUG15010A
     C                   CALLB     'AONOSTR0'                                              BUG15010A
     C                   PARM      *BLANKS       @RTCD                                     BUG15010A
     C                   PARM      '*KEY   '     POPTN             7                       BUG15010A
     C                   PARM                    PCUST                                     BUG15010A
     C                   PARM                    PCYCD                                     BUG15010A
     C                   PARM                    PACCD                                     BUG15010A
     C                   PARM                    PACSN                                     BUG15010A
     C                   PARM      *BLANKS       PNONB                                     BUG15010A
     C                   PARM                    PBRCD                                     BUG15010A
     C                   PARM      *BLANKS       PCSSN                                     BUG15010A
     C                   PARM      *BLANKS       PPNOI                                     BUG15010A
     C     N_SDNOST      PARM      *BLANKS       DSFDY                                     BUG15010A
                                                                                           BUG15010A
     C                   If        @RTCD = *Blanks                                         BUG15010A
     C                   Movel     N_A7NONB      PNOST                                     BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
     C                   EndSl                                                             BUG15010A
                                                                                           BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
     C                   ENDSR                                                             BUG15010A
      *****************************************************************                    BUG15010A
     C/EJECT                                                                               BUG15010A
      *****************************************************************                    BUG15010A
      *                                                               *                    BUG15010A
      *  GetAccount - Get Account parameter for FT001000              *                    BUG15010A
      *                                                               *                    BUG15010A
      *****************************************************************                    BUG15010A
     C     GetAccount    BEGSR                                                             BUG15010A
                                                                                           BUG15010A
     C                   If        %Subst(PIN1:1:1) = '/'                                  BUG15010A
     C                   EVAL      ParmStr = %SUBST(PIN1:2:34)                             BUG15010A
     C                   Else                                                              BUG15010A
     C                   EVAL      ParmStr = PIN1                                          BUG15010A
     C                   EndIf                                                             BUG15010A
      *                                                                                    BUG15010A
     C                   CallB     'AOACCTV1'                                              BUG15010A
     C                   Parm      *Blanks       @RTCD                                     BUG15010A
     C                   Parm      *Blanks       @Type                                     BUG15010A
     C                   Parm                    ParmStr                                   BUG15010A
     C                   Parm      *Blanks       A_DSSDY                                   BUG15010A
                                                                                           BUG15010A
     C                   If        @RTCD = *Blanks                                         BUG15010A
     C                   Eval      SDACCNT = A_DSSDY                                       BUG15010A
     C                   Move      SWF07CNUM     WCNUM                                     BUG15010A
     C                   Move      SWF07ACOD     WACOD            10                       BUG15010A
     C                   Move      SWF07ACSQ     WACSQ             2                       BUG15010A
     C                   Eval      PACNT = SWF07BRCA+ WCNUM + SWF07CCY                     BUG15010A
     C                                  + WACOD + WACSQ                                    BUG15010A
     C                   Else                                                              BUG15010A
     C                   Movel     ParmStr       WIBAN                                     BUG15010A
     C     WIBAN         Chain     ACCNTL6F                           10                   BUG15010A
     C                   If         Not *IN10                                              BUG15010A
     C                   Move      CNUM          WCNUM                                     BUG15010A
     C                   Move      ACOD          WACOD                                     BUG15010A
     C                   Move      ACSQ          WACSQ                                     BUG15010A
     C                   Eval      PACNT = BRCA + WCNUM + CCY                              BUG15010A
     C                                  + WACOD + WACSQ                                    BUG15010A
     C                   EndIf                                                             BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
     C                   ENDSR                                                             BUG15010A
      *****************************************************************                    BUG15010A
     C/EJECT                                                                               BUG15010A
      *****************************************************************                     BUG19322
      *                                                               *                     BUG19322
      *  GetEXTN - Store customer with SWIFT address to data structure*                     BUG19322
      *                                                               *                     BUG19322
      *****************************************************************                     BUG19322
     C     GetEXTN       BEGSR                                                              BUG19322
      *                                                                                     BUG19322
     C                   IF        SAVMTG <> *Blanks                                        BUG19322
     C                   EVAL      @MTG = SAVMTG                                            BUG19322
     C                   ELSE                                                               BUG19322
     C                   EVAL      @MTG = MTAG                                              BUG19322
     C                   ENDIF                                                              BUG19322
     C                   IF        FLDTYP = '5' And                                         BUG19322
     C                             FLDTAG = 'A' Or                                          BUG19322
     C                             FLDTYP = '5' And                                         BUG19322
     C                             FLDTAG = 'F'                                             BUG19322
     C                   EVAL      V = V + 1                                                BUG19322
     C     V             OCCUR     EXTN                                                     BUG19322
     C                   EVAL      MPSN = Q                                                 BUG19322
     C                   EVAL      MTG = @MTG                                               BUG19322
     C                   EVAL      MCSI = PCNUM                                             BUG19322
     C                   ENDIF                                                              BUG19322
      *                                                                                     BUG19322
     C                   ENDSR                                                              BUG19322
      *****************************************************************                       CSW215
     C/EJECT                                                                                  CSW215
      *****************************************************************                       CSW215
      *                                                               *                       CSW215
      * SRFormat59F - Format :59F: for Beneficiary Customer           *                       CSW215
      *                                                               *                       CSW215
      * Calls: MG001001                                               *                       CSW215
      *                                                               *                       CSW215
      *                                                               *                       CSW215
      *****************************************************************                       CSW215
      *                                                                                       CSW215
     C     SRFormat59F   BEGSR                                                                CSW215
      *                                                                                       CSW215
     C                   IF        %SUBST(BENF1:1:1) = '1/' OR                                CSW215
     C                             (%SUBST(BENF1:1:1) = '/' AND                               CSW215
     C                              %SUBST(BENF2:1:2) = '1/')                                 CSW215
      *                                                                                       CSW215
     C                   EVAL      WRK59F  = 'Y'                                              CSW215
     C                   EVAL      OFSPT1 = BENF1                                             CSW215
     C                   EVAL      OFSPT2 = BENF2                                             CSW215
     C                   EVAL      OFSPT3 = BENF3                                             CSW215
     C                   EVAL      OFSPT4 = BENF4                                             CSW215
     C                   EVAL      OFSPT5 = BENF5                                             CSW215
     C                   ELSE                                                                 CSW215
      *                                                                                       CSW215
      ** Execute Midas MG Validation & Formatting for 59F                                     CSW215
      *                                                                                       CSW215
     C                   CALL      'MG001001'                                                 CSW215
      ** Return Code                                                                          CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
      ** Validtion Type                                                                       CSW215
     C                   PARM      'FRMT'        PVALTYP                                      CSW215
      ** 5X35 lines to be checked                                                             CSW215
     C                   PARM                    BENF1                                        CSW215
     C                   PARM                    BENF2                                        CSW215
     C                   PARM                    BENF3                                        CSW215
     C                   PARM                    BENF4                                        CSW215
     C                   PARM                    BENF5                                        CSW215
      ** Network                                                                              CSW215
     C                   PARM      'SWIFT'       PNWRK                                        CSW215
      ** Message Type                                                                         CSW215
     C                   PARM      '102'         PMSGTP                                       CSW215
      ** Message Tag                                                                          CSW215
     C                   PARM      ':59F:'       PMSGTG                                       CSW215
      ** Branch Code                                                                          CSW215
     C**********         PARM      BRCA          PBRCH                               CSW215 MD034842
     C                   PARM      BRCAA         PBRCH                                      MD034842
      ** Country of Location                                                                  CSW215
     C                   PARM                    PCCD                                         CSW215
      ** Currency Code                                                                        CSW215
     C                   PARM      CCTCCY        PCCY                                         CSW215
      ** Nostro                                                                               CSW215
     C                   PARM                    PNOST                                        CSW215
      ** 5X35 lines to be output                                                              CSW215
     C                   PARM                    OFSPT1                                       CSW215
     C                   PARM                    OFSPT2                                       CSW215
     C                   PARM                    OFSPT3                                       CSW215
     C                   PARM                    OFSPT4                                       CSW215
     C                   PARM                    OFSPT5                                       CSW215
      ** Message ID Field                                                                     CSW215
     C                   PARM      *BLANKS       PMSGID                                       CSW215
      ** Error Type                                                                           CSW215
     C                   PARM      *BLANKS       PErrTyp                                      CSW215
      *                                                                                       CSW215
     C                   IF        PRTCD = *BLANKS                                            CSW215
     C                   EVAL      WRK59F  = 'Y'                                              CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   ENDSR                                                                CSW215
      *****************************************************************                     BUG19322
      /EJECT                                                                                BUG19322
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        Begsr
      *
      * Input/Output Parameters
      *
     C     *ENTRY        Plist
     C                   Parm                    IPPARM            1
     C                   Parm                    OPPARM            1
     C                   Parm                    RSEQ              5
      *
     C                   If        MBIN = 'Y'
     C                   Eval      *IN50 = *ON
     C                   Endif
      *
     C                   Z-add     SFNUM1        SPLNO
     C                   Eval      SFILP = SFILE1

     C                   Call      'ZSFILE'
     C                   Parm                    RSEQ              5
     C                   Parm      *Blanks       RENT              3
     C                   Parm                    SFILP            10
     C                   Parm                    SPLNO             6 0
     C                   Parm      *Blanks       ZERR              1

     C                   If        ZERR = 'Y'
     C     *LOCK         IN        LDA
     C                   Eval      *INU7= *ON
     C                   Eval      *INU8= *ON
     C                   Eval      *INLR= *ON
     C                   Eval      DBKEY = 'FT0657P1'
     C                   Eval      DBASE = 1
     C                   Eval      DBFILE = 'ZSFILE'
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Z-add     SFNUMU        SPLNO
     C                   Eval      SFILP = SFILEU
      *
     C                   Call      'ZSFILE'
     C                   Parm                    RSEQ              5
     C                   Parm      *Blanks       RENT              3
     C                   Parm                    SFILP            10
     C                   Parm                    SPLNO             6 0
     C                   Parm      *Blanks       ZERR              1

     C                   If        ZERR = 'Y'
     C     *LOCK         IN        LDA
     C                   Eval      *INU7= *ON
     C                   Eval      *INU8= *ON
     C                   Eval      *INLR= *ON
     C                   Eval      DBKEY = 'FT0657P1'
     C                   Eval      DBASE = 2
     C                   Eval      DBFILE = 'ZSFILE'
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   TIME                    TIME              6 0
      *
      * Set up key and access installation control record (TABTB10F)
      *
     C                   MOVEL     '01      '    ZTABKY           12
     C                   MOVE      '  10'        ZTABKY
      *
     C     ZTABKY        CHAIN     TABFP                              99
     C                   If        *IN99  or RECI <>'D'
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'TABFP'       DBFILE
     C                   MOVEL     ZTABKY        DBKEY
     C                   Z-Add     3             DBASE
     C                   EXSR      *PSSR
     C                   Endif
      *
      * Installation Control Record Found so save fields
      *
     C                   MOVE      RUNA          SRUNA             7
     C                   MOVE      TITL          STITL            53
      *
      * Set up key and access installation control record (TABTB11F)
      *
     C                   MOVE      *BLANKS       ZTABKY
     C                   MOVEL     '01'          ZTABKY
     C                   MOVE      '11'          ZTABKY
     C     ZTABKY        CHAIN     TABFP                              10
      *
     C                   If        *IN10 or RECI <> 'D'
     C     *LOCK         IN        LDA
     C                   MOVEL     'TABFP'       DBFILE
     C                   MOVEL     ZTABKY        DBKEY
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
      * Inst. Control Record Found so save CUST. NO. OF HEAD OFFICE
      *
     C**********         Z-ADD     HEAD          SHEAD             6 0                        CSD027
     C                   MOVE      HEAD          SHEAD             6                          CSD027
      *
      * Access SDMMODPD for networks available.
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** If no record is found on sdmmodpd.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Access SDMGMEPD for drop SWIFT msg. no. days
      *
     C                   CALL      'AOMGMER0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMGME        PARM      SDMGME        DSFDY
      *
      ** If no record is found on SDMGMEPD.
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     6             DBASE
     C                   MOVEL     'FIRST'       DBKEY
     C                   MOVEL     'SDMGMEPD'    DBFILE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
      *
      **  Convert history retention date to YYMMDD
      *
     C     RUND          ADD       ENDSMN        ZMDAY
     C                   CALL      'ZM0060'                             15
     C                   PARM                    ZMDAY
     C                   PARM                    ZMDATE
      *
      ** If the program ends in error.
      *
     C     *IN15         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     7             DBASE                            * * * * * * *
     C                   MOVEL     '       '     DBKEY                            * DBERR 026 *
     C                   MOVEL     'ZM0060'      DBFILE                           * * * * * * *
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   END
     C                   MOVE      ZMDATE        @HRDT             6
      *
      * Initialise constant fields
      *
     C                   MOVE      *LOVAL        CR                1
     C                   BITON     '457'         CR
     C                   MOVE      *LOVAL        LF                1
     C                   BITON     '257'         LF
     C                   MOVEL     CR            CRLF              2
     C                   MOVE      LF            CRLF
     C                   MOVE      ':'           COLON1
     C                   MOVE      ':'           COLON2
      *
      * CRLF Control Character for message data records
      *
     C                   MOVE      CRLF          CTRC
      *
      * Set message Production Parameter
      *
     C                   MOVE      'N'           OPPARM            1
      *
      * Access SAR details to determine if EMU Settlement Details
      * switched on (CFT004)
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT004'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * If core feature is switched ON, set a variable field to
      * condition the rest of the processing
      *
     C                   If        @RTCD = *BLANKS
     C                   Move      'Y'           CFT004
     C                   Else
      *
      * else, database error (return code other than *NRF)
      *
     C                   If        @RTCD <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   Movel     'SCSARDPD'    DBFILE                         ************
     C                   Movel     '*VERIFY'     DBKEY                          * DBERR 30 *
     C                   Z-Add     8             DBASE                          ************
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
      *                                                                                       CSW207
      ** Check if SWIFT2007 is installed                                                      CSW207
      *                                                                                       CSW207
     C                   CALL      'SWIF2007'                                                 CSW207
     C                   PARM                    @RTCD                                        CSW207
      *                                                                                       CSW207
     C                   IF        @RTCD = 'CSW2007'                                          CSW207
     C                   MOVE      'Y'           CSW207            1                          CSW207
     C                   ELSE                                                                 CSW207
     C                   MOVE      'N'           CSW207                                       CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW201
      ** Check if SWIFT 2001 enhancement is installed                                         CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM                    @RTCD                                        CSW201
                                                                                              CSW201
     C                   IF        @RTCD = 'CSW2001'                                          CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW202
      ** Check if SWIFT 2002 enhancement is installed                                         CSW202
                                                                                              CSW202
     C                   CALL      'SWIF2002'                                                 CSW202
     C                   PARM      *BLANKS       PRetCode                                     CSW202
                                                                                              CSW202
     C                   IF        PRetCode = 'CSW2002'                                       CSW202
     C                   EVAL      CSW202 = 'Y'                                               CSW202
     C                   ELSE                                                                 CSW202
     C                   EVAL      CSW202 = 'N'                                               CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSD015
      ** Check if Midas Message Manager (CSW025) is installed                                 CSD015
                                                                                              CSD015
     C                   EVAL      CSW025 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSW025'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRtnCode <> *BLANKS AND                                    CSD015
     C                             PRtnCode <> '*NRF'                                         CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSW025'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 27                                                 CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtnCode = *BLANKS                                         CSD015
     C                   EVAL      CSW025 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if Compliance Watch Enhancement (CSD015) is installed                          CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
     C                   EVAL      W1EWLC = 'N'                                               222385
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtnCode                                     CSD015
     C                   PARM      '*VERIFY'     POption                                      CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRtnCode <> *BLANKS AND                                    CSD015
     C                             PRtnCode <> '*NRF'                                         CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 29                                                 CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtnCode = *BLANKS                                         CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
      **********                                                                     CSC022 BUG17013
      ***Access*SAR*details*to*see*if*CSC022*is*switched*on*                         CSC022 BUG17013
      **********                                                                     CSC022 BUG17013
     C**********         CallB     'AOSARDR0'                                        CSC022 BUG17013
     C**********         Parm      *Blanks       PRtnCode                            CSC022 BUG17013
     C**********         Parm      '*VERIFY'     POption                             CSC022 BUG17013
     C**********         Parm      'CSC022'      PSard                               CSC022 BUG17013
     C*****SCSARD        Parm      SCSARD        DSFDY                               CSC022 BUG17013
      ***Initialize*CSC022*and*Skip*Commit*Flags*                                    CSC022 BUG17013
     C**********         Eval      CSC022 = 'N'                                      CSC022 BUG17013
     C**********         Eval      WSkpComtRolbk = 'N'                               CSC022 BUG17013
      **********                                                                     CSC022 BUG17013
     C**********         If        PRtnCode = *BLANKS                                CSC022 BUG17013
     C**********         Eval      CSC022 = 'Y'                                      CSC022 BUG17013
      **********                                                                     CSC022 BUG17013
      ***Get*Jobs*currently*running*i*batch*mode*using*SCCMRJOB*dataarea*            CSC022 BUG17013
      **********                                                                     CSC022 BUG17013
     C**********         In        SCCMTJOB                                          CSC022 BUG17013
     C**********         If        ComitNum > 0                                      CSC022 BUG17013
      ***Move*committed*jobs*to*arrary*for*checking*                                 CSC022 BUG17013
     C**********         MoveA     WDSJobs       WJobs                               CSC022 BUG17013
      ***Verify*if*job*running*exists*in*array*                                      CSC022 BUG17013
     C**********         Eval      WArrPtr = %LookUp(PSJobName:WJobs)                CSC022 BUG17013
     C**********         If        WArrPtr > 0                                       CSC022 BUG17013
     C**********         Eval      WSkpComtRolbk = 'Y'                               CSC022 BUG17013
     C**********         EndIf                                                       CSC022 BUG17013
     C**********         EndIf                                                       CSC022 BUG17013
      **********                                                                     CSC022 BUG17013
     C**********         Else                                                        CSC022 BUG17013
      ***Execute**PSSR*if*CSC022*is*not*found*or*Database*error*                     CSC022 BUG17013
     C**********         If        PRtnCode <> '*NRF'                                CSC022 BUG17013
     C******Lock         In        LDA                                               CSC022 BUG17013
     C**********         Eval      DBFile = 'SCSARDPD'                               CSC022 BUG17013
     C**********         Eval      DBPgm  = 'FT0658'                                 CSC022 BUG17013
     C**********         Eval      DBKey  = 'CSC022'                                 CSC022 BUG17013
     C**********         Eval      DBase  = 900                                      CSC022 BUG17013
     C**********         Out       LDA                                               CSC022 BUG17013
     C**********         Exsr      *PSSR                                             CSC022 BUG17013
     C**********         EndIf                                                       CSC022 BUG17013
     C**********         EndIf                                                       CSC022 BUG17013
      **********                                                                     CSC022 BUG17013
      *                                                                                       222385
      ** Access AOWLCCR0 to check if function code MESSGENT is available                      222385
      *                                                                                       222385
     C                   CALLB     'AOWLCCR0'                                                 222385
     C                   PARM      *BLANKS       PRtnCode                                     222385
     C                   PARM      '*KEY   '     POption                                      222385
     C                   PARM      'MESSGENT'    Pfunc             8                          222385
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        222385
                                                                                              222385
      ** Database error                                                                       222385
                                                                                              222385
     C                   IF        PRtnCode <> *BLANKS AND                                    222385
     C                             PRtnCode <> '*NRF'                                         222385
     C     *LOCK         IN        LDA                                                        222385
     C                   EVAL      DBKEY = 'MESSGENT'                                         222385
     C                   EVAL      DBFILE = 'SDWLCCPD'                                        222385
     C                   EVAL      DBASE = 24                                                 222385
     C                   OUT       LDA                                                        222385
     C                   EXSR      *PSSR                                                      222385
     C                   ENDIF                                                                222385
                                                                                              222385
     C                   ENDIF                                                                CSD015
      **                                                                                    BUG17013
      ** Access SAR details to see if CSC022 is switched on                                 BUG17013
      **                                                                                    BUG17013
     C                   CallB     'AOSARDR0'                                               BUG17013
     C                   Parm      *Blanks       PRtnCode                                   BUG17013
     C                   Parm      '*VERIFY'     POption                                    BUG17013
     C                   Parm      'CSC022'      PSard                                      BUG17013
     C     SCSARD        Parm      SCSARD        DSFDY                                      BUG17013
      ** Initialize CSC022 and Skip Commit Flags                                            BUG17013
     C                   Eval      CSC022 = 'N'                                             BUG17013
     C                   Eval      WSkpComtRolbk = 'N'                                      BUG17013
      **                                                                                    BUG17013
     C                   If        PRtnCode = *BLANKS                                       BUG17013
     C                   Eval      CSC022 = 'Y'                                             BUG17013
      **                                                                                    BUG17013
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                    BUG17013
      **                                                                                    BUG17013
     C                   In        SCCMTJOB                                                 BUG17013
     C                   If        ComitNum > 0                                             BUG17013
      ** Move committed jobs to arrary for checking                                         BUG17013
     C                   MoveA     WDSJobs       WJobs                                      BUG17013
      ** Verify if job running exists in array                                              BUG17013
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                       BUG17013
     C                   If        WArrPtr > 0                                              BUG17013
     C                   Eval      WSkpComtRolbk = 'Y'                                      BUG17013
     C                   EndIf                                                              BUG17013
     C                   EndIf                                                              BUG17013
      **                                                                                    BUG17013
     C                   Else                                                               BUG17013
      ** Execute *PSSR if CSC022 is not found or Database error                             BUG17013
     C                   If        PRtnCode <> '*NRF'                                       BUG17013
     C     *Lock         In        LDA                                                      BUG17013
     C                   Eval      DBFile = 'SCSARDPD'                                      BUG17013
     C                   Eval      DBPgm  = 'FT0658'                                        BUG17013
     C                   Eval      DBKey  = 'CSC022'                                        BUG17013
     C                   Eval      DBase  = 900                                             BUG17013
     C                   Out       LDA                                                      BUG17013
     C                   Exsr      *PSSR                                                    BUG17013
     C                   EndIf                                                              BUG17013
     C                   EndIf                                                              BUG17013
      **                                                                                    BUG17013
      *                                                                                       CSW209
      ** Check if SWIFT2009 is installed                                                      CSW209
      *                                                                                       CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM                    @RTCD                                        CSW209
                                                                                              CSW209
     C                   IF        @RTCD = 'CSW2009'                                          CSW209
     C                   MOVE      'Y'           CSW209            1                          CSW209
     C                   ELSE                                                                 CSW209
     C                   MOVE      'N'           CSW209                                       CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW213
      ** Check if SWIFT2013 is installed                                                      CSW213
      *                                                                                       CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM                    @RTCD                                        CSW213
                                                                                              CSW213
     C                   IF        @RTCD = 'CSW2013'                                          CSW213
     C                   MOVE      'Y'           CSW213                                       CSW213
     C                   ELSE                                                                 CSW213
     C                   MOVE      'N'           CSW213                                       CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW215
      ** Check if SWIFT2015 is installed                                                      CSW215
      *                                                                                       CSW215
     C                   CALL      'SWIF2015'                                                 CSW215
     C                   PARM                    PRTCD                                        CSW215
                                                                                              CSW215
     C                   IF        PRTCD = 'CSW2015'                                          CSW215
     C                   EVAL      CSW215 = 'Y'                                               CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      CSW215 = 'N'                                               CSW215
     C                   ENDIF                                                                CSW215
                                                                                              CSW209
     C                   MOVE      'Y'           W23                                          CSW209
     C                   MOVE      'Y'           W52A                                         CSW209
     C                   MOVE      'Y'           W57A                                         CSW209
     C                   MOVE      'Y'           W59A                                         CSW209
     C                   MOVE      'Y'           W72                                          CSW209
                                                                                              CSW209
      *
      * Clear multiple occurrence data structure
      *
     C**********         Z-add     95            Q                 2 0               189511
     C**********         Z-add     95            Q                 4 0         189511190200
     C                   Z-add     5000          Q                 4 0         189511190200
      *
     C                   ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     @RUN          IFEQ      *BLANK
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   MOVE      '1'           *IN78
     C                   EXSR      SRAU
     C                   END
      *
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
     C/EJECT
      *
     O/COPY FTCPYSRC,FTSWIFTRAN                                                 184509
**  CPY@
(c) Finastra International Limited 2001
**  #NUMC                                                                                     CSW209
0123456789                                                                                    CSW209
**  #ALPH                                                                                     CSW209
ABCDEFGHIJKLMNOPQRSTUVWXYZ                                                                    CSW209
