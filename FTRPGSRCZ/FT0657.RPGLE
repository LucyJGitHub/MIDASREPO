     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
     H FTRANS                                                                   184509
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Request for transfer SWIFT msg generation')   *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT0657 - Request for Transfer Swift Message Generation       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD035561           Date 24Aug15               *
      *  Prev Amend No. MD034368           Date 08May15               *
      *                 MD034339           Date 06May15               *
      *                 CSW215             Date 06Apr15               *
      *                 MD027286           Date 25Nov14               *
      *                 AR972805           Date 27Feb13               *
      *                 CRE075             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG25891           Date 08Sep09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG21328           Date 16Oct08               *
      *                 BUG21160           Date 22Sep08               *
      *                 256564             Date 17Sep08               *
      *                 BUG15010A          Date 25Oct07               *
      *                 BUG15090           Date 23Oct07               *
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
      *                 221761             Date 01Apr04               *
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
      *                 196129             Date 25Jul01               *
      *                 CSW201             Date 02May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 190200             Date 20Feb01               *
      *                 189511             Date 04Feb00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187213             Date 21No000               *
      *                 185107             Date 17Oct00               *
      *                 184509             Date 03Oct00               *
      *                 184183                  28Sep00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 177680                  11Apr00               *
      *                 CFT006  *Create    Date 30Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD035561 - Additional lines were generated in field tag 50F  *
      *             of MT101                                          *
      *  MD034368 - Clearing code //CN12345678901234 in Field Tag 56A *
      *             of MT101 does not displayed                       *
      *  MD034339 - Tag 57a displayed twice in MT101                  *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  MD027286 - Missing :57 Tag in MT101                          *
      *  AR972805 - Remove equate translation as done externally.     *
      *             Recompile over FTCPYSRC,FTSWIFTRAN.               *
      *             (Child: AR972806)                                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  BUG25891 - Ordering Customer 3 and 4 did not post on         *
      *             messages. Apply GEMS fix 221627.                  *
      *  221627 - Only lines 1 and 2 (lines 3,4 and 5 are missing) of *
      *           Ordering Customer entered in the Transaction details*
      *           part of 'RO' are output to the MT101 message.       *
      *  BUG21328 - Incorrect MT101 Ordering customer format          *
      *  BUG21160 - Destination field not included in MT101           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
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
      *  221761 - Recompiled due to change made in PF/FT101HPD.       *
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
      *  CSW202 - SWIFT 2002 Standard Update                          *
      *  CSW025 - Midas Message Manager                               *
      *           - Pass original change type                         *
      *  196129 - Check message priority and delivery notification    *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  190200 - Extend 189511                                       *
      *  189511 - MT102 Messages are not being produced when dealing  *
      *           with a large number of payments                     *
      *  187213 - Support block 3 processing for TI Interface         *
      *           Originally IPL060                                   *
      *  185107 - Mapping of details from swift message - Recompile   *
      *  184509 - Foreign accent marks not allowed in SWIFT msgs      *
      *  184183 - Not incrementing datastructure occurrence when      *
      *           writing beneficiary.                                *
      *  CDL008 - Continuous Linked Settlement (Recompiled MGOREFPD)  *
      *  177680 - Second line of Ordering Customer not on Swift File  *
      *  CFT006 - Funds Transfer addition of MT101 and MT102 messages *
      *                                                               *
      *****************************************************************
     FFT101HL8  IF   E           K DISK    INFSR(*PSSR)
     FFT101HL9  UF   E           K DISK    RENAME(FT101HD0:RFT9)
     FFT101DL2  IF   E           K DISK    INFSR(*PSSR)
     FMGOREFPD  O    E           K DISK    COMMIT
     FMGOMSGPD  O    E           K DISK    COMMIT
     F***SDBRCHL5  IF   E           K DISK                                                  BUG13217
     FSDBRCHL1  IF   E           K DISK                                                     BUG13217
     FACCNTL6   IF   E           K DISK    RENAME(ACCNTABF:ACCNTL6F)
     FTABFP     IF   E           K DISK    IGNORE(TABTB20F:TABTG20F)
     F                                     IGNORE(TABLETHF:TABLETPF)
     F                                     IGNORE(TABLET5F:TABTE10F)
      *
     FFT0657AU  O    E             PRINTER INFDS(SPOOLU)
     F*                                                                                       147933
     FFT0657P1  O    E             PRINTER INFDS(SPOOL1)                                      147933
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
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
 
     D RUNDAT          DS            13
     D* DATA STRUCTURE TO RETRIEVE MULTIBRANCH INDICATOR
     D  MBIN                  13     13
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
      *
     D FLD32           DS            18
     D  CCY32                  1      3
     D  AMNT32                 4     18
     D*
     D FLD33           DS            18
     D  CCY33                  1      3
     D  AMNT33                 4     18
     D*MULT*****       DS                  OCCURS(95)                           189511
     D MULT            DS                  OCCURS(5000)                         189511
     D  MTAG                   1      5
     D  MFLD                   6     55
     D  CTRC                  56     57                                         187213
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
     D                 DS
      *
      * Data Structure redefining Address fields
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
      /EJECT
     D MEBEIS        E DS                  EXTNAME(MEBEISPD)                                  CSW202
      ** Data Structure for Business Entity Identifier file                                   CSW202
      *                                                                                       CSW202
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structure for access programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      **  Long data structure for access programs
      *
      * External data structure - SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *
     D P@ACC         E DS                  EXTNAME(ACCNT)
      *
      ** Externally described DS for Nostro details                                           CSW201
      *                                                                                       CSW201
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSW201
                                                                                              CSD015
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
      *
     D AMT             S             15
     D WAMNT           S             15  0
     D TOTTRN          S             15  0
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
     D ISCCY           S              3
     D CUSTNOC         S              6
     D*CUSTNO***       S              6  0                                                    CSD027
     D CUSTNO          S              6                                                       CSD027
     D WIBAN           S             34
     D CNA1            S             35
     D CNA2            S             35
     D CNA3            S             35
     D CNA4            S             35
     D IVTAG1          S              1
     D IVTAG2          S              1
     D IVTAG3          S              1
     D CFT004          S              1    INZ(' ')
     D WRKTAG          S              5                                                     MD034339
      *                                                                                       CSW201
      ** Work Variables for CSW201                                                            CSW201
      *                                                                                       CSW201
     D CSW201          S              1                                                       CSW201
     D WSwiftID        S             11                                                       CSW201
     D WChgInd         S              1                                                       CSW201
     D Wx              S              2  0                                                    CSW201
      *                                                                                       CSW201
      ** Parameters for AONOSTR0                                                              CSW201
      *                                                                                       CSW201
     D PNOSD           S              5                                                       CSW201
     D PCUST           S              6                                                       CSW201
     D PCYCD           S              3                                                       CSW201
     D***PACCD**         S              4                                              CSW201 CGL029
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
                                                                                              CSD015
      ** Variables for CSD015 Enhancement                                                     CSD015
                                                                                              CSD015
     D CSD015          S              1A                                                      CSD015
     D CSW025          S              1A                                                      CSD015
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
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
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
     D WBranch         S              3A   INZ(*BLANKS)                                     BUG13217
      **                                                                                      CSC022
                                                                                              CSW202
     D CSW215          S              1                                                       CSW215
     D PErrTyp         S              1                                                       CSW215
     D WRK59F          S              1                                                       CSW215
                                                                                              CSW215
     C                   Z-Add     0             AUNO1
     C                   Z-Add     0             DBASE
     C                   Read      FT101HL8                               90
     C                   MOVEL     CHTP          @CHG              1                          CSW025
                                                                                              CSW025
     C                   Dow       Not *IN90
 
     C                   Movel     *Blanks       HOCDone           1
 
     C                   Exsr      SRCLRF
     C                   Exsr      SRBRCH
      *
      * Address data structure
      *
      *
      * Keep tally of number of records read from LF/FT101HL8
      *
     C                   Eval      AUNO1 = AUNO1 + 1
     C                   Exsr      SRMPGI
      *
      * Output Entry to the SWIFT Message Report PRTF/FT0657P1
      *
     C                   EXSR      SRH1
      *
      * Read all Transaction Details
      *
     C                   Movel     RFTID         WRFTID           15
     C     WRFTID        Setll     FT101DL2
     C     WRFTID        ReadE     FT101DL2                               90
     C                   Dow       Not *IN90
     C                   Exsr      SRMPTD
      *
      * Output Entry to the SWIFT Message Report PRTF/FT0657P1
      *
     C                   EXSR      SRD1
     C     WRFTID        ReadE     FT101DL2                               90
     C                   Enddo
     C                   Exsr      OMSG
      *
      * Update file
      *
     C     RFTID         CHAIN     FT101HL9                           97
     C                   Eval      GEN101 = 'Y'
     C                   Update    RFT9
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
     C                   Read      FT101HL8                               90
     C                   MOVEL     CHTP          @CHG              1                          CSW025
     C                   Enddo
     C                   Exsr      SRAU
     C                   Eval      *INLR = *ON
     C/EJECT
      *****************************************************************
      * SRMPGI - Map General Information Details to MGOMSGPD fields   *
      *****************************************************************
      *
     C     SRMPGI        Begsr
      *                                                                         187213
      * Set up block 3: for processing                                          187213
      *                                                                         187213
     C     RFTID         Ifne      SNDREF                                       187213
     C                   Z-Add     1             Q                              187213
     C     Q             Occur     MULT                                         187213
     C                   Movel(p)  '3:'          MTAG                           187213
     C                   Movel     *blanks       MFLD                           187213
     C                   Movel     '(108:'       MFLD                           187213
     C     MFLD          Cat       RFTID:0       MFLD                           187213
     C                   Movel     *blanks       CTRC                           187213
     C                   Else                                                   187213
     C                   Z-Add     0             Q                              187213
     C                   Endif                                                  187213
      *
      * Field :20: - Transaction Reference Number.
      *
     C                   Eval      TOTTRN = *Zeros
     C*********          Z-Add     1             Q                              187213
     C                   Add       1             Q                              187213
     C     Q             Occur     MULT
     C                   Movea     *BLANKS       @WRK
     C
      *
     C                   Eval      MTAG = ':20:'
     C                   Movea     SNDREF        @HLD
     C                   Movea     @HLD(1)       @WRK(1)
     C                   Movea     @WRK          MFLD
      *
      * Save the transaction Reference Number.
      *
     C                   Movel     MFLD          TRNA
      *
      * Field 21R: Customer Specified Reference
      *
     C                   If        CUSTRF <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':21R:'
     C                   Eval      MFLD = CUSTRF
     C                   Endif
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG = ':28D:'                                             CSW201
     C                   EVAL      MFLD = '00001/00001'                                       CSW201
     C                   EVAL      RMSGIT = '00001/00001'                                     CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
      *
      * Instructing Party
      *
     C                   If        HINPTY <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             OCCUR     MULT
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      WSwiftID = *BLANKS                                         CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
      *                                                                                       CSW201
      ** If field entered is a customer number                                                CSW201
      *                                                                                       CSW201
     C                   IF        %SUBST(HINPTY:1:6) <> *BLANKS AND                          CSW201
     C                             %SUBST(HINPTY:7:29) = *BLANKS OR                           CSW201
      *                                                                                       CSW201
      ** Or a Customer shortname                                                              CSW201
      *                                                                                       CSW201
     C                             %SUBST(HINPTY:1:10) <> *BLANKS AND                         CSW201
     C                             %SUBST(HINPTY:11:25) = *BLANKS                             CSW201
      *                                                                                       CSW201
      ** Access customer details file to determine if entry is valid                          CSW201
      *                                                                                       CSW201
     C                   EVAL      @KEY1 = HINPTY                                             CSW201
                                                                                              CSW201
     C                   CALL      'AOCUSTR0'                                                 CSW201
     C                   PARM      '*BLANKS'     @RTCD                                        CSW201
     C                   PARM      '*KEY   '     @OPTN                                        CSW201
     C                   PARM                    @KEY1                                        CSW201
     C                   PARM      *BLANKS       @KYST                                        CSW201
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSW201
      *                                                                                       CSW201
      ** Field entered is a valid customer number or shortname and                            CSW201
      ** Customer SWIFT ID is not blank                                                       CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = *BLANKS AND                                        CSW201
     C                             BBCSID <> *BLANKS                                          CSW201
     C                   EVAL      WSwiftID = BBCSID                                          CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If field entered is a SWIFT ID                                                       CSW201
      *                                                                                       CSW201
     C                   IF        WSwiftID = *BLANKS                                         CSW201
     C                   IF        %SUBST(HINPTY:1:8) <> *BLANKS AND                          CSW201
     C                             %SUBST(HINPTY:9:27) = *BLANKS OR                           CSW201
     C                             %SUBST(HINPTY:1:11) <> *BLANKS AND                         CSW201
     C                             %SUBST(HINPTY:12:24) = *BLANKS                             CSW201
     C                   EVAL      WSwiftID = HINPTY                                          CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If the variable Swift ID is not blank, check if                                      CSW201
      ** if SWIFT ID exists in BIC directory                                                  CSW201
      *                                                                                       CSW201
     C                   IF        WSwiftID <> *BLANKS                                        CSW201
      *                                                                                       CSW201
     C                   EVAL      Char18 = WSwiftID                                          CSW201
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
      ** If existing and BEI, format using option C.                                          CSW201
      *                                                                                       CSW201
     C                   IF        @Type = '*BIC'  AND                                        CSW201
     C                             (BDSUBT = 'BEID' OR                                        CSW201
     C                              BDSUBT = 'TRCO')                                          CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y' AND @Type = '*BIC'                        CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW202
     C                   EVAL      MTAG = ':50C:'                                             CSW201
     C                   EVAL      MFLD = WSwiftID                                            CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             WChgInd <> 'Y' OR                                          CSW201
     C                             CSW201 <> 'Y'                                              CSW201
                                                                                              CSW201
      *
     C                   Eval      MTAG = ':50L:'
     C                   Eval      MFLD = HINPTY
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   Endif
      *
      * Ordering Customer (HEADER)
      * First line MUST be an account number
      * Subsequent lines MUST be name and address
      *
      * Check if Swift 2007 is ON and Customer is not blanks                                  CSW207
     C                   EVAL      PRTCD = 'A'                                               CSW207A
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                             AND HOCUS1 <> *BLANKS                                      CSW207
     C                   EVAL      ParmStr = *BLANKS                                          CSW207
     C                   If        %Subst(HOCUS1:1:1) = '/'                                 BUG14755
     C                   EVAL      ParmStr = %SUBST(HOCUS1:2:34)                              CSW207
     C                   Else                                                               BUG14755
     C                   Eval      ParmStr = HOCUS1                                         BUG14755
     C                   EndIf                                                              BUG14755
                                                                                              CSW207
     C                   EVAL      PIN1 = HOCUS1                                             CSW207A
     C                   EVAL      PIN2 = HOCUS2                                             CSW207A
     C                   EVAL      PIN3 = HOCUS3                                             CSW207A
     C                   EVAL      PIN4 = HOCUS4                                             CSW207A
     C                   EVAL      PIN5 = HOCUS5                                             CSW207A
      * Call Format program                                                                   CSW207
     C                   EXSR      SRFORMAT                                                   CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   If        HOCUS1  <> *Blanks
     C                             AND MTAG <> ':50F:'                                        CSW207
     C                             AND PRTCD <> *BLANKS                                      CSW207A
 
     C                   Eval      HOCDone = 'Y'
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':50H:'
     C                   Eval      MFLD = HOCUS1
 
     C                   If        CUSTTP = 'S'  OR                             177680
     C                             CUSTTP = 'C'                                 177680
     C                   Eval      KeyVal = %Subst(Hocus1:2)                    177680
     C                   Else                                                   177680
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      KEYVAL = *BLANKS                                           CSW201
     C                   SELECT                                                               CSW201
      *                                                                                       CSW201
      ** Retail Account                                                                       CSW201
      *                                                                                       CSW201
     C                   WHEN      CUSTTP = 'R'                                               CSW201
                                                                                              CSW201
     C                   EVAL      ParmStr = *BLANKS                                          CSW201
     C                   EVAL      ParmStr = %SUBST(HOCUS1:2:10)                              CSW201
                                                                                              CSW201
     C                   CALLB     'AOACCTV1'                                                 CSW201
     C                   PARM      *Blanks       @RTCD                                        CSW201
     C                   PARM      *Blanks       @Type                                        CSW201
     C                   PARM                    ParmStr                                      CSW201
     C                   PARM                    DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        @RTCD = *BLANKS                                            CSW201
     C                   EVAL      P@ACC = DSSDY                                              CSW201
     C                   MOVEL     CNUM          KEYVAL                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Nostro Account                                                                       CSW201
      *                                                                                       CSW201
     C                   WHEN      CUSTTP = 'F'                                               CSW201
                                                                                              CSW201
     C                   EVAL      PNOSD = %SUBST(HOCUS1:2:5)                                 CSW201
     C                   EVAL      PCYCD = %SUBST(PNOSD:1:3)                                  CSW201
     C                   EVAL      PNONB = %SUBST(PNOSD:4:2)                                  CSW201
      *                                                                                       CSW201
     C                   CALLB     'AONOSTR0'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
     C                   PARM      '*KEY   '     @OPTN                                        CSW201
     C                   PARM      *BLANKS       PCUST                                        CSW201
     C                   PARM                    PCYCD                                        CSW201
     C                   PARM      *BLANKS       PACCD                                        CSW201
     C                   PARM      *BLANKS       PACSN                                        CSW201
     C                   PARM                    PNONB                                        CSW201
     C                   PARM      *BLANKS       PBRCD                                        CSW201
     C                   PARM      *BLANKS       PCSSN                                        CSW201
     C                   PARM      *BLANKS       PPNOI                                        CSW201
     C     SDNOST        PARM      *BLANKS       DSFDY                                        CSW201
                                                                                              CSW201
     C                   IF        @RTCD = *BLANKS                                            CSW201
     C                   EVAL      KEYVAL = A7CUST                                            CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** General Ledger Account                                                               CSW201
      *                                                                                       CSW201
     C                   WHEN      CUSTTP = 'G'                                               CSW201
     C                   EVAL      KEYVAL = %SUBST(HOCUS1:5:6)                                CSW201
      *                                                                                       CSW201
      ** IBAN Account                                                                         CSW201
      *                                                                                       CSW201
     C                   WHEN      CUSTTP = 'I' AND                                           CSW201
     C                             CFT004 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      PIBAN = %SUBST(HOCUS1:2:34)                                CSW201
                                                                                              CSW201
     C                   CALLB     'AOIBANR4'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
     C                   PARM      '*KEY   '     @OPTN                                        CSW201
     C                   PARM                    PIBAN                                        CSW201
     C     P@ACC         PARM      *BLANKS       DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        @RTCD = *BLANKS                                            CSW201
     C                   MOVEL     CNUM          KEYVAL                                       CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDSL                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             KEYVAL = *BLANKS OR                                        CSW201
     C                             CSW201 <> 'Y'                                              CSW201
                                                                                              CSW201
      * The second line may contain a customer number, shortname or address
     C                   Movel     HOCUS2        KeyVal
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   Endif                                                  177680
 
     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    KeyVal           10
     C                   Parm      *Blanks       @Type
     C                   Parm                    SDCUST
 
     C*******************If        @Type = '*CSHT  ' or                         177680
     C*******************          @Type = '*CNUM  '                            177680
     C                   If        @Rtcd = *Blanks                              177680
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed, check if                                     CSW201
      ** if SWIFT ID exists in BIC directory                                                  CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             BBCSID <> *BLANKS                                          CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
                                                                                              CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C     MEBICD        PARM      *BLANKS       DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        CSW202 = 'Y' AND @Type = '*BIC'                            CSW202
     C                   CALL      'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRetCode                                     CSW202
     C                   PARM      '*VERIFY'     POption                                      CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
     C                   IF        @Type = '*BIC' AND                                         CSW201
     C                             (BDSUBT = 'BEID' OR                                        CSW201
     C                             BDSUBT = 'TRCO')                                           CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y' AND @Type = '*BIC'                        CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW201
     C                   EVAL      MTAG = ':50G:'                                             CSW201
                                                                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = BBCSID                                              CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             WChgInd <> 'Y' OR                                          CSW201
     C                             CSW201 <> 'Y'                                              CSW201
                                                                                              CSW201
      * Put in FOUND address
     C                   If        BBCNA1 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = BBCNA1
     C                   Endif
 
     C                   If        BBCNA2 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = BBCNA2
     C                   Endif
 
     C                   If        BBCNA3 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = BBCNA3
     C                   Endif
 
     C                   If        BBCNA4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = BBCNA4
     C                   Endif
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
 
     C                   Else
 
     C                   If        HOCUS2 <> *Blanks
      *                                                                                       CSW201
      ** If CSW201 is on, check if second field is BEI. If it is, format with G               CSW201
      ** option.                                                                              CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
     C                   EVAL      Char18 = HOCUS2                                            CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C     MEBICD        PARM      *BLANKS       DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        CSW202 = 'Y' AND @Type = '*BIC'                            CSW202
     C                   CALL      'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRetCode                                     CSW202
     C                   PARM      '*VERIFY'     POption                                      CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
     C                   IF        @Type = '*BIC' AND                                         CSW201
     C                             (BDSUBT = 'BEID' OR                                        CSW201
     C                             BDSUBT = 'TRCO')                                           CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y' AND @Type = '*BIC'                        CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW202
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   EVAL      MTAG = ':50G:'                                             CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = HOCUS2
     C                   Endif
 
     C                   IF        CSW201 = 'N' OR                                            CSW201
     C                             WChgInd = 'N'                                              CSW201
                                                                                              CSW201
     C                   If        HOCUS3 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = HOCUS3
     C                   Endif
 
     C                   If        HOCUS4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = HOCUS4
     C                   Endif
 
     C                   If        HOCUS5 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = HOCUS5
     C                   Endif
     C                   ENDIF                                                                CSW201
 
     C                   Endif
     C                   Endif
      *
      * Account Servicing Institution
     C                   If        HACSV1 <> *Blanks   OR
     C                             HACSV2 <> *Blanks
 
     C                   If        HACSV2 <> *Blanks
      * Is the second field a BIC ?
     C                   Eval      Char18 = HACSV2
     C                   CallB     'AOBICDV0'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18           18
     C                   Parm                    @Type
     C                   Parm                    DSSDY
 
     C                   If        @Type = '*BIC'
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed check if subtype is                           CSW201
      ** 'BEID' or 'TRCO'                                                                     CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
     C                   EVAL      MEBICD = DSSDY                                             CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
      *                                                                                       CSW201
     C                   IF        CSW202 = 'Y'                                               CSW202
     C                   CALL      'AOBEISR0'                                                 CSW202
     C                   PARM      *BLANKS       PRetCode                                     CSW202
     C                   PARM      '*VERIFY'     POption                                      CSW202
     C                   PARM      BDSUBT        PBICD                                        CSW202
     C     MEBEIS        PARM      MEBEIS        DSFDY                                        CSW202
     C                   ENDIF                                                                CSW202
                                                                                              CSW202
     C**********         IF        BDSUBT = 'BEID' OR                                  CSW201 CSW202
     C**********                   BDSUBT = 'TRCO'                                     CSW201 CSW202
                                                                                              CSW202
     C                   IF        (BDSUBT = 'BEID' OR                                        CSW202
     C                             BDSUBT = 'TRCO')                                           CSW202
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y' AND                                       CSW202
     C                             PRetCode = *BLANKS)                                        CSW202
                                                                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG = ':52C:'                                             CSW201
     C                   IF        HACSV1 <> *BLANKS                                          CSW201
     C                   EVAL      MFLD = HACSV1                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      MFLD = '/' + HACSV2                                        CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             WChgInd <> 'Y' OR                                          CSW201
     C                             CSW201 <> 'Y'                                              CSW201
                                                                                              CSW201
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':52A:'
     C                   Eval      MFLD = HACSV1
 
     C                   Eval      Q = Q + 1
     C     Q             OCCUR     MULT                                                     MD034368
     C                   Eval      MFLD = HACSV2
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
 
      * Not a Bic.  Must be a customer number or shortname
     C                   Else
 
     C                   Movel     HACSV2        KeyVal
 
     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    KeyVal           10
     C                   Parm      *Blanks       @Type
     C                   Parm                    SDCUST
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed, check if SWIFT Id                            CSW201
      ** exists in BIC directory                                                              CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             BBCSID <> *BLANKS AND                                      CSW201
     C                             @RTCD = *BLANKS                                            CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
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
      ** If existing and subtype is 'BEID' or 'TRCO'                                          CSW201
      *                                                                                       CSW201
     C                   IF        @Type = '*BIC' AND                                         CSW201
     C                             (BDSUBT = 'BEID' OR                                        CSW201
     C                             BDSUBT = 'TRCO')                                           CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y' AND @Type = '*BIC'                        CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG = ':52C:'                                             CSW201
     C                   IF        HACSV1 <> *BLANKS                                          CSW201
     C                   EVAL      MFLD = HACSV1                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      MFLD = '/' + BBCSID                                        CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             WChgInd <> 'Y' OR                                          CSW201
     C                             CSW201 <> 'Y'                                              CSW201
 
      * Customer must have a BIC
                                                                                            MD035561
     C                   IF        HACSV1 <> *BLANKS                                        MD035561
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':52A:'
     C                   Eval      MFLD = HACSV1
     C                   ENDIF                                                              MD035561
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   IF        HACSV1 = *BLANKS                                         MD035561
     C                   EVAL      MTAG = ':52A:'                                           MD035561
     C                   ENDIF                                                              MD035561
     C                   Eval      MFLD = BBCSID
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
 
     C                   Endif
     C                   Else
      *
      ** Field 2 not entered.  Just report on field 1
      *
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':52C:'
     C                   Eval      MFLD = HACSV1
      *
     C                   Endif
     C                   Endif
 
      * Request Execution Date
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':30:'
      *
     C                   Call      'ZM0060'
     C                   Parm      EXDATE        ZMDAY             5 0
     C                   Parm                    ZMDATE            6
     C                   Eval      MFLD = ZMDATE
     C                   Eval      REXDTE = ZMDATE
 
      * Authorisation
     C                   If        AUTHTX <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':25:'
     C                   Eval      MFLD = AUTHTX
     C                   Endif
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * SRMPTD - Map Transaction Details fields to MGOMSGPD fields    *
      *****************************************************************
      *
     C     SRMPTD        Begsr
      *
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':21:'
     C                   Eval      MFLD = TRNSID
 
      * FX Deal Reference
     C******             If        FXDREF = *Blanks                             177680
     C                   If        FXDREF <> *Blanks                            177680
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':21F:'
     C                   Eval      MFLD = FXDREF
     C                   Endif
 
      * Instruction Code
     C                   If        INSCA4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':23E:'
     C                   Movel     'Y'           M23On             1
     C                   If        INSCA4 = 'PHON' and
     C                             INSA31 <> *Blanks or
     C                             INSCA4 = 'OTHR' and
     C                             INSA31 <> *Blanks
     C                   Eval      INSTCD = INSCA4
     C                   Eval      INSTAI = INSA31
     C                   Eval      MFLD = FLD23
     C                   Else
     C                   Eval      MFLD = INSCA4
     C                   Endif
     C                   Endif
 
      * Instruction Code 2
     C                   If        INSCB4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':23E:'
     C                   If        INSCB4 = 'PHON' and
     C                             INSB31 <> *Blanks or
     C                             INSCB4 = 'OTHR' and
     C                             INSB31 <> *Blanks
     C                   Eval      INSTCD = INSCB4
     C                   Eval      INSTAI = INSB31
     C                   Eval      MFLD = FLD23
     C                   Else
     C                   Eval      MFLD = INSCB4
     C                   Endif
     C                   Endif
 
      * Instruction Code 3
     C                   If        INSCC4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':23E:'
     C                   Eval      MFLD = INSCC4
     C                   Endif
 
      * Instruction Code 4
     C                   If        INSCD4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':23E:'
     C                   Eval      MFLD = INSCD4
     C                   Endif
 
      * Instruction Code 5
     C                   If        INSCE4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':23E:'
     C                   Eval      MFLD = INSCE4
     C                   Endif
 
      *
      * Transfer ccy and amount
      *
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':32B:'
      *
      * Currency.
      *
     C                   Eval      WAMNT = TRNAMT
     C                   Eval      CCY32 = TRNCCY
     C                   Move      TRNCCY        WCCY              3
     C                   Exsr      SRFAMT
     C                   Move      CDP           WCDP              1 0
     C                   Eval      AMNT32 = AMT
      *
     C                   Eval      MFLD = FLD32
     C                   Eval      R32B = FLD32
     C                   Eval      TOTTRN = TOTTRN + TRNAMT
 
      * Instructing Party
     C                   If        TINPTY <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      WSwiftID = *BLANKS                                         CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
      *                                                                                       CSW201
      ** If field entered is a customer number                                                CSW201
      *                                                                                       CSW201
     C                   IF        %SUBST(TINPTY:1:6) <> *BLANKS AND                          CSW201
     C                             %SUBST(TINPTY:7:29) = *BLANKS OR                           CSW201
      *                                                                                       CSW201
      ** Or a Customer shortname                                                              CSW201
      *                                                                                       CSW201
     C                             %SUBST(TINPTY:1:10) <> *BLANKS AND                         CSW201
     C                             %SUBST(TINPTY:11:25) = *BLANKS                             CSW201
      *                                                                                       CSW201
      ** Access customer details file to determine if entry is valid                          CSW201
      *                                                                                       CSW201
     C                   EVAL      @KEY1 = TINPTY                                             CSW201
                                                                                              CSW201
     C                   CALL      'AOCUSTR0'                                                 CSW201
     C                   PARM      '*BLANKS'     @RTCD                                        CSW201
     C                   PARM      '*KEY   '     @OPTN                                        CSW201
     C                   PARM                    @KEY1                                        CSW201
     C                   PARM      *BLANKS       @KYST                                        CSW201
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSW201
      *                                                                                       CSW201
      ** Field entered is a valid customer number or shortname and                            CSW201
      ** Customer SWIFT ID is not blank                                                       CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = *BLANKS AND                                        CSW201
     C                             BBCSID <> *BLANKS                                          CSW201
     C                   EVAL      WSwiftID = BBCSID                                          CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If field entered is a SWIFT ID                                                       CSW201
      *                                                                                       CSW201
     C                   IF        WSwiftID = *BLANKS                                         CSW201
     C                   IF        %SUBST(TINPTY:1:8) <> *BLANKS AND                          CSW201
     C                             %SUBST(TINPTY:9:27) = *BLANKS OR                           CSW201
     C                             %SUBST(TINPTY:1:11) <> *BLANKS AND                         CSW201
     C                             %SUBST(TINPTY:12:24) = *BLANKS                             CSW201
     C                   EVAL      WSwiftID = TINPTY                                          CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If the variable Swift ID is not blank, check if  SWIFT Id                            CSW201
      ** exists in BIC directory.                                                             CSW201
      *                                                                                       CSW201
     C                   IF        WSwiftID <> *BLANKS                                        CSW201
     C                   EVAL      Char18 = WSwiftID                                          CSW201
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
      ** If existing and subtype is 'BEID' or 'TRCO'                                          CSW201
      *                                                                                       CSW201
     C                   IF        @Type = '*BIC' AND                                         CSW201
     C                             (BDSUBT = 'BEID' OR                                        CSW201
     C                             BDSUBT = 'TRCO')                                           CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y' AND @Type = '*BIC'                        CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW202
     C                   EVAL      MTAG = ':50C:'                                             CSW201
     C                   EVAL      MFLD = WSwiftID                                            CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             WChgInd <> 'Y' OR                                          CSW201
     C                             CSW201 <> 'Y'                                              CSW201
                                                                                              CSW201
     C                   Eval      MTAG = ':50L:'
     C                   Eval      MFLD = TINPTY
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   Endif
 
      * Ordering Customer (DETAILS
      * Must have an account number on line 1 and name and address on line 2
 
      * Check if Swift 2007 is ON and Customer is not blanks                                  CSW207
     C                   EVAL      PRTCD = 'A'                                               CSW207A
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                             AND TOCUS1 <> *BLANKS                                      CSW207
     C                             AND HOCDone <> 'Y'                                         CSW207
     C                   EVAL      ParmStr = *BLANKS                                          CSW207
     C                   If        %Subst(TOCUS1:1:1) = '/'                                 BUG14755
     C                   EVAL      ParmStr = %SUBST(TOCUS1:2:34)                              CSW207
     C                   Else                                                               BUG14755
     C                   EVAL      ParmStr = TOCUS1                                         BUG14755
     C                   EndIf                                                              BUG14755
                                                                                              CSW207
     C                   EVAL      PIN1 = TOCUS1                                             CSW207A
     C                   EVAL      PIN2 = TOCUS2                                             CSW207A
     C                   EVAL      PIN3 = TOCUS3                                             CSW207A
     C                   EVAL      PIN4 = TOCUS4                                             CSW207A
     C                   EVAL      PIN5 = TOCUS5                                             CSW207A
      * Call Format program                                                                   CSW207
     C                   EXSR      SRFORMAT                                                   CSW207
     C                   ENDIF                                                                CSW207
      *                                                                                       CSW207
     C                   If        HOCDone <> 'Y'
     C                             AND MTAG <> ':50F:'                                        CSW207
     C                             AND PRTCD <> *BLANKS                                      CSW207A
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':50H:'
     C                   Eval      MFLD = TOCUS1
 
      * Is the Ordering Customer a shortname or Customer number
     C                   Eval      KeyVal = %Subst(TOCUS1:2)
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   EVAL      Char18 = *BLANKS                                           CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             DCUSTP <> 'S' OR                                           CSW201
     C                             CSW201 = 'Y' AND                                           CSW201
     C                             DCUSTP <> 'C'                                              CSW201
     C                   EVAL      KEYVAL = *BLANKS                                           CSW201
                                                                                              CSW201
     C                   SELECT                                                               CSW201
      *                                                                                       CSW201
      ** Retail Account                                                                       CSW201
      *                                                                                       CSW201
     C                   WHEN      DCUSTP = 'R'                                               CSW201
                                                                                              CSW201
     C                   EVAL      ParmStr = *BLANKS                                          CSW201
     C                   EVAL      ParmStr = %SUBST(TOCUS1:2:10)                              CSW201
                                                                                              CSW201
     C                   CALLB     'AOACCTV1'                                                 CSW201
     C                   PARM      *Blanks       @RTCD                                        CSW201
     C                   PARM      *Blanks       @Type                                        CSW201
     C                   PARM                    ParmStr                                      CSW201
     C                   PARM                    DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        @RTCD = *BLANKS                                            CSW201
     C                   EVAL      P@ACC = DSSDY                                              CSW201
     C                   MOVEL     CNUM          KEYVAL                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Nostro Account                                                                       CSW201
      *                                                                                       CSW201
     C                   WHEN      DCUSTP = 'F'                                               CSW201
                                                                                              CSW201
     C                   EVAL      PNOSD = %SUBST(TOCUS1:2:5)                                 CSW201
     C                   EVAL      PCYCD = %SUBST(PNOSD:1:3)                                  CSW201
     C                   EVAL      PNONB = %SUBST(PNOSD:4:2)                                  CSW201
      *                                                                                       CSW201
      ** Find Nostro details                                                                  CSW201
      *                                                                                       CSW201
     C                   CALLB     'AONOSTR0'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
     C                   PARM      '*KEY   '     @OPTN                                        CSW201
     C                   PARM      *BLANKS       PCUST                                        CSW201
     C                   PARM                    PCYCD                                        CSW201
     C                   PARM      *BLANKS       PACCD                                        CSW201
     C                   PARM      *BLANKS       PACSN                                        CSW201
     C                   PARM                    PNONB                                        CSW201
     C                   PARM      *BLANKS       PBRCD                                        CSW201
     C                   PARM      *BLANKS       PCSSN                                        CSW201
     C                   PARM      *BLANKS       PPNOI                                        CSW201
     C     SDNOST        PARM      *BLANKS       DSFDY                                        CSW201
                                                                                              CSW201
     C                   IF        @RTCD = *BLANKS                                            CSW201
     C                   EVAL      KEYVAL = A7CUST                                            CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** General Ledger Account                                                               CSW201
      *                                                                                       CSW201
     C                   WHEN      DCUSTP = 'G'                                               CSW201
     C                   EVAL      KEYVAL = %SUBST(TOCUS1:5:6)                                CSW201
      *                                                                                       CSW201
      ** IBAN Account                                                                         CSW201
      *                                                                                       CSW201
     C                   WHEN      DCUSTP = 'I' AND                                           CSW201
     C                             CFT004 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      DSSDY = *BLANKS                                            CSW201
     C                   EVAL      PIBAN = %SUBST(TOCUS1:2:34)                                CSW201
                                                                                              CSW201
     C                   CALLB     'AOIBANR4'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
     C                   PARM      '*KEY   '     @OPTN                                        CSW201
     C                   PARM                    PIBAN                                        CSW201
     C     P@ACC         PARM      *BLANKS       DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        @RTCD = *BLANKS                                            CSW201
     C                   MOVEL     CNUM          KEYVAL                                       CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDSL                                                                CSW201
     C                   ENDIF                                                                CSW201
 
     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    KeyVal           10
     C                   Parm      *Blanks       @Type
     C                   Parm                    SDCUST
 
     C                   If        @Type = '*CSHT  ' or
     C                             @Type = '*CNUM  '
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed, check if SWIFT Id                            CSW201
      ** exists in BIC directory                                                              CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             BBCSID <> *BLANKS AND                                      CSW201
     C                             @RTCD = *BLANKS                                            CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
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
      ** If existing and subtype is 'BEID' or 'TRCO'                                          CSW201
      *                                                                                       CSW201
     C                   IF        @Type = '*BIC' AND                                         CSW201
     C                             (BDSUBT = 'BEID' OR                                        CSW201
     C                             BDSUBT = 'TRCO')                                           CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y' AND @Type = '*BIC'                        CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW201
     C                   EVAL      MTAG = ':50G:'                                             CSW201
                                                                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = BBCSID                                              CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'N' OR                                            CSW201
     C                             WChgInd <> 'Y'                                             CSW201
                                                                                              CSW201
      * Put in FOUND address
     C                   If        BBCNA1 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = BBCNA1
     C                   Endif
 
     C                   If        BBCNA2 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = BBCNA2
     C                   Endif
 
     C                   If        BBCNA3 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = BBCNA3
     C                   Endif
 
     C                   If        BBCNA4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = BBCNA4
     C                   Endif
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
 
     C                   Else
 
     C                   If        TOCUS2 <> *Blanks
      *                                                                                       CSW201
      ** If CSW201 is on, check if second field is customer, if not check                     CSW201
      ** if BEI.                                                                              CSW201
      *                                                                                       CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
     C                   EVAL      WSwiftId = *BLANKS                                         CSW201
     C                   EVAL      KeyVal = TOCUS2                                            CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   CALLB     'AOCUSTR0'                                                 CSW201
     C                   PARM      *Blanks       @Rtcd                                        CSW201
     C                   PARM      '*KEY   '     @Optn                                        CSW201
     C                   PARM                    KeyVal                                       CSW201
     C                   PARM      *Blanks       @Type                                        CSW201
     C                   PARM                    SDCUST                                       CSW201
                                                                                              CSW201
     C                   IF        @RtCd = *BLANKS                                            CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      Char18 = TOCUS2                                            CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   EVAL      WSwiftId = Char18                                          CSW201
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed, check if SWIFT Id                            CSW201
      ** exists in BIC directory.                                                             CSW201
      *                                                                                       CSW201
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
                                                                                              CSW201
     C                   IF        @Type = '*BIC' AND                                         CSW201
     C                             (BDSUBT = 'BEID' OR                                        CSW201
     C                             BDSUBT = 'TRCO')                                           CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y' AND @Type = '*BIC'                        CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW202
     C                   EVAL      MTAG = ':50G:'                                             CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
                                                                                              CSW201
     C                   IF        WChgInd = 'Y'                                              CSW201
     C                   EVAL      MFLD = WSwiftId                                            CSW201
     C                   ELSE                                                                 CSW201
     C                   Eval      MFLD = TOCUS2
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   Endif
 
     C                   IF        CSW201 = 'N' OR                                            CSW201
     C**********                   WChgInd = 'Y'                                       CSW201 221627
     C                             WChgInd = 'N'                                              221627
                                                                                              CSW201
     C                   If        TOCUS3 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = TOCUS3
     C                   Endif
 
     C                   If        TOCUS4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = TOCUS4
     C                   Endif
 
     C                   If        TOCUS5 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = TOCUS5
     C                   Endif
     C                   ENDIF                                                                CSW201
 
     C                   Endif
     C                   Endif
 
      * Account Servicing Institution
 
     C                   If        TASI35 <> *Blanks   OR
     C                             TACC11 <> *Blanks
 
     C                   If        TACC11 <> *Blanks
      * Is the second field a BIC ?
     C                   Eval      Char18 = TACC11
     C                   CallB     'AOBICDV0'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18           18
     C                   Parm                    @Type
     C                   Parm                    DSSDY
 
     C                   If        @Type = '*BIC'
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed, check if subtype is                          CSW201
      ** 'BEID' or 'TRCO'.                                                                    CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
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
     C**********         IF        BDSUBT = 'BEID' OR                                  CSW201 CSW202
     C**********                   BDSUBT = 'TRCO'                                     CSW201 CSW202
                                                                                              CSW202
     C                   IF        (BDSUBT = 'BEID' OR                                        CSW202
     C                             BDSUBT = 'TRCO')                                           CSW202
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y'                                           CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG = ':52C:'                                             CSW201
     C                   IF        TASI35 <> *BLANKS                                          CSW201
     C                   EVAL      MFLD = TASI35                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      MFLD = '/' + TACC11                                        CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             WChgInd <> 'Y' OR                                          CSW201
     C                             CSW201 <> 'Y'                                              CSW201
                                                                                              CSW201
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':52A:'
     C                   Eval      MFLD = TASI35
 
     C                   Eval      Q = Q + 1
     C                   Eval      MFLD = TACC11
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
 
      * Not a Bic.  Must be a customer number or shortname
     C                   Else
 
     C                   Movel     TACC11        KeyVal
 
     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    KeyVal           10
     C                   Parm      *Blanks       @Type
     C                   Parm                    SDCUST
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             BBCSID <> *BLANKS AND                                      CSW201
     C                             @RTCD = *BLANKS                                            CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
      *                                                                                       CSW201
      ** Check if SWIFT ID exists in BIC directory                                            CSW201
      *                                                                                       CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
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
                                                                                              CSW201
     C                   IF        @Type = '*BIC' AND                                         CSW201
     C                             (BDSUBT = 'BEID' OR                                        CSW201
     C                             BDSUBT = 'TRCO')                                           CSW201
     C                             AND CSW202 = 'N'                                           CSW202
                                                                                              CSW202
     C                             OR (CSW202 = 'Y' AND @Type = '*BIC'                        CSW202
     C                             AND PRetCode = *BLANKS)                                    CSW202
                                                                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG = ':52C:'                                             CSW201
     C                   IF        TASI35 <> *BLANKS                                          CSW201
     C                   EVAL      MFLD = TASI35                                              CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      MFLD = '/' +  BBCSID                                       CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             WChgInd <> 'Y' OR                                          CSW201
     C                             CSW201 <> 'Y'                                              CSW201
 
      * Customer must have a BIC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':52A:'
     C                   Eval      MFLD = TASI35
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = BBCSID
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
 
     C                   Endif
     C                   Else
      *
      ** Field 2 not entered.  Just report on field 1
      *
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':52C:'
     C                   Eval      MFLD = TASI35
      *
     C                   Endif
     C                   Endif
 
      * Intermediary
      * BIC
      * 1.  PARTY ID + BIC
      * 2.  PARTY ID
      * 3.  NAME AND ADDRESS
     C                   If        TINSTA <> *Blanks   OR
     C                             TINST1 <> *Blanks
 
     C                   If        TINSTA <> *Blanks
      * Is the second field a BIC ?
     C**********         Eval      Char18 = TINSTA                                            CSW201
     C**********         CallB     'AOBICDV0'                                                 CSW201
     C**********         Parm      *Blanks       RetCodeIn                                    CSW201
     C**********         Parm                    Char18           18                          CSW201
     C**********         Parm                    @Type                                        CSW201
     C**********         Parm                    DSSDY                                        CSW201
 
     C**********         If        @Type = '*BIC'                                             CSW201
      *                                                                                       CSW201
      ** Use ME1400 to check if TINSTA is a BIC                                               CSW201
      *                                                                                       CSW201
     C                   EVAL      PMBICC = TINSTA                                            CSW201
     C                   EVAL      PMBICB = %SUBST(TINSTA:9:3)                                CSW201
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
      ** TINSTA is a BIC                                                                      CSW201
      *                                                                                       CSW201
     C                   IF        @RTCD = *BLANKS AND                                        CSW201
     C                             PMBICD = 'Y'                                               CSW201
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
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
      ** Subtype is 'BEID' or 'TRCO'                                                          CSW201
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
                                                                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG = ':56D:'                                             CSW201
                                                                                              CSW201
     C                   IF        TINST1 <> *BLANKS                                          CSW201
     C                   EVAL      MFLD = TINST1                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   SELECT                                                               CSW201
      *                                                                                       CSW201
      ** If second line entered, set up as address                                            CSW201
      *                                                                                       CSW201
     C                   WHEN      TINST1 <> *BLANKS AND                                      CSW201
     C                             TINST2 <> *BLANKS                                          CSW201
                                                                                              CSW201
     C                   EVAL      MFLD = TINST2                                              CSW201
                                                                                              CSW201
     C                   IF        TINST3 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = TINST3                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        TINST4 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = TINST4                                              CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If customer, set up using customer address. If party identifier is                   CSW201
      ** entered, set up together with customer address.                                      CSW201
      *                                                                                       CSW201
     C                   WHEN      PMCUST = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      MFLD = BBCNA1                                              CSW201
                                                                                              CSW201
     C                   IF        BBCNA2 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = BBCNA2                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        BBCNA3 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = BBCNA3                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        BBCNA4 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = BBCNA4                                              CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If counterparty, use counterparty address. If party identifier is                    CSW201
      ** entered, set up together with counterparty address.                                  CSW201
      *                                                                                       CSW201
     C                   WHEN      PMCNST = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      MFLD = AWCPNM                                              CSW201
     C                                                                                        CSW201
     C                   IF        AWCNTN <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = AWCNTN                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   OTHER                                                                CSW201
     C                   EVAL      MFLD = TINSTA                                              CSW201
     C                   ENDSL                                                                CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             WChgInd <> 'Y' OR                                          CSW201
     C                             CSW201 <> 'Y'                                              CSW201
                                                                                              CSW201
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':56A:'
     C                   EVAL      MFLD = TINST1                                            MD034368
      *                                                                                     MD034368
     C                   EVAL      Q = Q + 1                                                MD034368
     C     Q             OCCUR     MULT                                                     MD034368
     C                   Eval      MFLD = TINSTA
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
 
      * Not a Bic.  Must be a customer number or shortname
     C                   Else
 
     C                   Movel     TINSTA        KeyVal
     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    KeyVal           10
     C                   Parm      *Blanks       @Type
     C                   Parm                    SDCUST
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y' AND                                           CSW201
     C                             BBCSID <> *BLANKS AND                                      CSW201
     C                             @RTCD = *BLANKS                                            CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
      *                                                                                       CSW201
      ** Check if SWIFT ID exists in BIC directory                                            CSW201
      *                                                                                       CSW201
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
      ** BBCSID is a BIC                                                                      CSW201
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
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MTAG = ':56D:'                                             CSW201
                                                                                              CSW201
     C                   IF        TINST1 <> *BLANKS                                          CSW201
     C                   EVAL      MFLD = TINST1                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If second line entered, set up as address                                            CSW201
      *                                                                                       CSW201
     C                   IF        TINST1 <> *BLANKS AND                                      CSW201
     C                             TINST2 <> *BLANKS                                          CSW201
                                                                                              CSW201
     C                   EVAL      MFLD = TINST2                                              CSW201
                                                                                              CSW201
     C                   IF        TINST3 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = TINST3                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        TINST4 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = TINST4                                              CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If customer, set up using customer address. If party identifier is                   CSW201
      ** entered, set up together with customer address.                                      CSW201
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   EVAL      MFLD = BBCNA1                                              CSW201
                                                                                              CSW201
     C                   IF        BBCNA2 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = BBCNA2                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        BBCNA3 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = BBCNA3                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   IF        BBCNA4 <> *BLANKS                                          CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = BBCNA4                                              CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
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
 
      * Customer must have a BIC
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':56A:'
     C                   EVAL      MFLD = TINST1                                            MD034368
      *                                                                                     MD034368
     C                   EVAL      Q = Q + 1                                                MD034368
     C     Q             OCCUR     MULT                                                     MD034368
     C                   Eval      MFLD = BBCSID
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
 
     C                   Endif
 
     C                   Else
      *
      ** Field 2 not entered.  Just report on field 1
      *
     C                   If        TINST1 <> *Blanks  AND
     C                             TINST2 = *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':56C:'
     C                   Eval      MFLD = TINST1
     C                   Else
 
     C                   If        TINST1 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':56D:'
     C                   Eval      MFLD = TINST1
     C                   Endif
 
     C                   If        TINST2 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = TINST2
     C                   Endif
 
     C                   If        TINST3 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = TINST3
     C                   Endif
 
     C                   If        TINST4 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = TINST4
     C                   Endif
 
     C                   Endif
     C                   Endif
     C                   Endif
 
      * Account with Institution (:57:)
 
      *                                                                                     MD027286
      ** The following output is re-written down below to display                           MD027286
      ** the correct ouput, the correct tags and make the codes                             MD027286
      ** more readable                                                                      MD027286
      *                                                                                     MD027286
     C**********         If        TACA35 <> *Blanks   OR                                   MD027286
     C**********                   TACA11 <> *Blanks                                        MD027286
      **********                                                                            MD027286
     C**********         If        TACA11 <> *Blanks                                        MD027286
      **Is*the*second field a BIC ?                                                         MD027286
     C**********         Eval      Char18 = TACA11                                            CSW201
     C**********         CallB     'AOBICDV0'                                                 CSW201
     C**********         Parm      *Blanks       RetCodeIn                                    CSW201
     C**********         Parm                    Char18           18                          CSW201
     C**********         Parm                    @Type                                        CSW201
     C**********         Parm                    DSSDY                                        CSW201
      **********                                                                            MD027286
     C**********         If        @Type = '*BIC'                                             CSW201
      **********                                                                     CSW201 MD027286
      ***Use*ME1400 to check if TACA11 ia a BIC                                      CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         EVAL      PMBICC = TACA11                                   CSW201 MD027286
     C**********         EVAL      PMBICB = %SUBST(TACA11:9:3)                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         CALL      'ME1400'                                          CSW201 MD027286
     C**********         PARM      *BLANKS       @RTCD                               CSW201 MD027286
     C**********         PARM                    PMBICC                              CSW201 MD027286
     C**********         PARM                    PMBICB                              CSW201 MD027286
     C**********         PARM                    SDCUST                              CSW201 MD027286
     C**********         PARM                    SDCNST                              CSW201 MD027286
     C**********         PARM                    MEBICD                              CSW201 MD027286
     C**********         PARM      *BLANKS       PMCUST                              CSW201 MD027286
     C**********         PARM      *BLANKS       PMCNST                              CSW201 MD027286
     C**********         PARM      *BLANKS       PMBICD                              CSW201 MD027286
      **********                                                                     CSW201 MD027286
      ***TACA11*is a BIC                                                             CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        @RTCD = *BLANKS AND                               CSW201 MD027286
     C**********                   PMBICD = 'Y'                                      CSW201 MD027286
      **********                                                                     CSW201 MD027286
      ***If*SWIFT*2001 enhancement is installed                                      CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        CSW201 = 'Y'                                      CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         EVAL      WChgInd = 'N'                                     CSW201 MD027286
      **********                                                                     CSW202 MD027286
     C**********         IF        CSW202 = 'Y'                                      CSW202 MD027286
     C**********         CALL      'AOBEISR0'                                        CSW202 MD027286
     C**********         PARM      *BLANKS       PRetCode                            CSW202 MD027286
     C**********         PARM      '*VERIFY'     POption                             CSW202 MD027286
     C**********         PARM      BDSUBT        PBICD                               CSW202 MD027286
     C*****MEBEIS        PARM      MEBEIS        DSFDY                               CSW202 MD027286
     C**********         ENDIF                                                       CSW202 MD027286
      **********                                                                     CSW201 MD027286
      ***subtype*is 'BEID' or 'TRCO'                                                 CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        BDSUBT = 'BEID' OR                                  CSW201 CSW202
     C**********                   BDSUBT = 'TRCO'                                     CSW201 CSW202
      **********                                                                     CSW202 MD027286
     C**********         IF        (BDSUBT = 'BEID' OR                               CSW202 MD027286
     C**********                   BDSUBT = 'TRCO')                                  CSW202 MD027286
     C**********                   AND CSW202 = 'N'                                  CSW202 MD027286
      **********                                                                     CSW202 MD027286
     C**********                   OR (CSW202 = 'Y'                                  CSW202 MD027286
     C**********                   AND PRetCode = *BLANKS)                           CSW202 MD027286
      **********                                                                     CSW202 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MTAG = ':57D:'                                    CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        TACA35 <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      MFLD = TACA35                                     CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         SELECT                                                      CSW201 MD027286
      **********                                                                     CSW201 MD027286
      ***If*second line entered, set up as address                                   CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         WHEN      TACA35 <> *BLANKS AND                             CSW201 MD027286
     C**********                   TACB35 <> *BLANKS                                 CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         EVAL      MFLD = TACB35                                     CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        TACC35 <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MFLD = TACC35                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        TACD35 <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MFLD = TACD35                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
      ***If*customer, set up using customer address. If party identifier is          CSW201 MD027286
      ***entered,*set up together with customer address.                             CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         WHEN      PMCUST = 'Y'                                      CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         EVAL      MFLD = BBCNA1                                     CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        BBCNA2 <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MFLD = BBCNA2                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        BBCNA3 <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MFLD = BBCNA3                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        BBCNA4 <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MFLD = BBCNA4                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
      ***If*counterparty, use counterparty address. If party identifier is           CSW201 MD027286
      ***entered,*set up together with counterparty address.                         CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         WHEN      PMCNST = 'Y'                                      CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         EVAL      MFLD = AWCPNM                                     CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        AWCNTN <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MFLD = AWCNTN                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         ENDSL                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         EVAL      WChgInd = 'Y'                                     CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        CSW201 = 'Y' AND                                  CSW201 MD027286
     C**********                   WChgInd <> 'Y' OR                                 CSW201 MD027286
     C**********                   CSW201 <> 'Y'                                     CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         Eval      Q = Q + 1                                                MD027286
     C*****Q****         Occur     MULT                                                     MD027286
     C**********         Eval      MTAG = ':57A:'                                           MD027286
     C**********         Eval      MFLD = TACA11                                            MD027286
      **********                                                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                            MD027286
      **Not*a*Bic.  Must be a customer number or shortname                                  MD027286
     C**********         Else                                                               MD027286
     C**********         Movel     TACA11        KeyVal                                     MD027286
     C**********         CallB     'AOCUSTR0'                                               MD027286
     C**********         Parm      *Blanks       @Rtcd                                      MD027286
     C**********         Parm      '*KEY   '     @Optn                                      MD027286
     C**********         Parm                    KeyVal           10                        MD027286
     C**********         Parm      *Blanks       @Type                                      MD027286
     C**********         Parm                    SDCUST                                     MD027286
      **********                                                                     CSW201 MD027286
      ***If*SWIFT 2001 enhancement is installed                                      CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        CSW201 = 'Y' AND                                  CSW201 MD027286
     C**********                   BBCSID <> *BLANKS AND                             CSW201 MD027286
     C**********                   @RTCD = *BLANKS                                   CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         EVAL      WChgInd = 'N'                                     CSW201 MD027286
      **********                                                                     CSW201 MD027286
      ***Check*if SWIFT ID exists in BIC directory                                   CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         EVAL      PMBICC = BBCSID                                   CSW201 MD027286
     C**********         EVAL      PMBICB = %SUBST(BBCSID:9:3)                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         CALL      'ME1400'                                          CSW201 MD027286
     C**********         PARM      *BLANKS       @RTCD                               CSW201 MD027286
     C**********         PARM                    PMBICC                              CSW201 MD027286
     C**********         PARM                    PMBICB                              CSW201 MD027286
     C**********         PARM                    SDCUST                              CSW201 MD027286
     C**********         PARM                    SDCNST                              CSW201 MD027286
     C**********         PARM                    MEBICD                              CSW201 MD027286
     C**********         PARM      *BLANKS       PMCUST                              CSW201 MD027286
     C**********         PARM      *BLANKS       PMCNST                              CSW201 MD027286
     C**********         PARM      *BLANKS       PMBICD                              CSW201 MD027286
      **********                                                                     CSW201 MD027286
      ***BBCSID*is a BIC                                                             CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        @RTCD = *BLANKS AND                               CSW201 MD027286
     C**********                   PMBICD = 'Y'                                      CSW201 MD027286
      **********                                                                     CSW202 MD027286
     C**********         IF        CSW202 = 'Y'                                      CSW202 MD027286
     C**********         CALL      'AOBEISR0'                                        CSW202 MD027286
     C**********         PARM      *BLANKS       PRetCode                            CSW202 MD027286
     C**********         PARM      '*VERIFY'     POption                             CSW202 MD027286
     C**********         PARM      BDSUBT        PBICD                               CSW202 MD027286
     C*****MEBEIS        PARM      MEBEIS        DSFDY                               CSW202 MD027286
     C**********         ENDIF                                                       CSW202 MD027286
      **********                                                                     CSW201 MD027286
      ***subtype is 'BEID' or 'TRCO'                                                 CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        BDSUBT = 'BEID' OR                                  CSW201 CSW202
     C**********                   BDSUBT = 'TRCO'                                     CSW201 CSW202
      **********                                                                     CSW202 MD027286
     C**********         IF        (BDSUBT = 'BEID' OR                               CSW202 MD027286
     C**********                   BDSUBT = 'TRCO')                                  CSW202 MD027286
     C**********                   AND CSW202 = 'N'                                  CSW202 MD027286
      **********                                                                     CSW202 MD027286
     C**********                   OR (CSW202 = 'Y'                                  CSW202 MD027286
     C**********                   AND PRetCode = *BLANKS)                           CSW202 MD027286
      **********                                                                     CSW202 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MTAG = ':57D:'                                    CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        TACA35 <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      MFLD = TACA35                                     CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
      **********                                                                     CSW201 MD027286
      ***If*second line entered, set up as address                                   CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        TACA35 <> *BLANKS AND                             CSW201 MD027286
     C**********                   TACB35 <> *BLANKS                                 CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         EVAL      MFLD = TACB35                                     CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        TACC35 <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MFLD = TACC35                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        TACD35 <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MFLD = TACD35                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
      ***If*customer, set up using customer address. If party identifier is          CSW201 MD027286
      ***entered, set up together with customer address.                             CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         ELSE                                                        CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         EVAL      MFLD = BBCNA1                                     CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        BBCNA2 <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MFLD = BBCNA2                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        BBCNA3 <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MFLD = BBCNA3                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        BBCNA4 <> *BLANKS                                 CSW201 MD027286
     C**********         EVAL      Q = Q + 1                                         CSW201 MD027286
     C*****Q****         OCCUR     MULT                                              CSW201 MD027286
     C**********         EVAL      MFLD = BBCNA4                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         EVAL      WChgInd = 'Y'                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         IF        CSW201 = 'Y' AND                                  CSW201 MD027286
     C**********                   WChgInd <> 'Y' OR                                 CSW201 MD027286
     C**********                   CSW201 <> 'Y'                                     CSW201 MD027286
      **********                                                                            MD027286
      **Customer*must have a BIC                                                            MD027286
     C**********         Eval      Q = Q + 1                                                MD027286
     C*****Q****         Occur     MULT                                                     MD027286
     C**********         Eval      MTAG = ':57A:'                                           MD027286
     C**********         Eval      MFLD = TACA35                                            MD027286
      **********                                                                            MD027286
     C**********         Eval      Q = Q + 1                                                MD027286
     C*****Q****         Occur     MULT                                                     MD027286
     C**********         Eval      MFLD = BBCSID                                            MD027286
      **********                                                                     CSW201 MD027286
     C**********         ENDIF                                                       CSW201 MD027286
      **********                                                                     CSW201 MD027286
     C**********         Endif                                                              MD027286
      **********                                                                            MD027286
     C**********         Else                                                               MD027286
      **********                                                                            MD027286
      ***Field*2*not entered.  Just report on field 1                                       MD027286
      **********                                                                            MD027286
     C**********         If        TACA35 <> *Blanks  AND                                   MD027286
     C**********                   TACB35 = *Blanks                                         MD027286
     C**********         Eval      Q = Q + 1                                                MD027286
     C*****Q****         Occur     MULT                                                     MD027286
     C**********         Eval      MTAG = ':57C:'                                           MD027286
     C**********         Eval      MFLD = TACA35                                            MD027286
     C**********         Else                                                               MD027286
      **********                                                                            MD027286
     C**********         If        TACA35 <> *Blanks                                        MD027286
     C**********         Eval      Q = Q + 1                                                MD027286
     C*****Q****         Occur     MULT                                                     MD027286
     C**********         Eval      MTAG = ':57D:'                                           MD027286
     C**********         Eval      MFLD = TACA35                                            MD027286
      **********                                                                            MD027286
     C**********         If        TACB35 <> *Blanks                                        MD027286
     C**********         Eval      Q = Q + 1                                                MD027286
     C*****Q****         Occur     MULT                                                     MD027286
     C**********         Eval      MFLD = TACB35                                            MD027286
     C**********         Endif                                                              MD027286
     C**********         If        TACC35 <> *Blanks                                        MD027286
     C**********         Eval      Q = Q + 1                                                MD027286
     C*****Q****         Occur     MULT                                                     MD027286
     C**********         Eval      MFLD = TACC35                                            MD027286
     C**********         Endif                                                              MD027286
     C**********         If        TACD35 <> *Blanks                                        MD027286
     C**********         Eval      Q = Q + 1                                                MD027286
     C*****Q****         Occur     MULT                                                     MD027286
     C**********         Eval      MFLD = TACD35                                            MD027286
     C**********         Endif                                                              MD027286
     C**********         Endif                                                              MD027286
     C**********         Endif                                                              MD027286
     C**********         Endif                                                              MD027286
     C**********         Endif                                                              MD027286
      *                                                                                     MD027286
      *    ACCOUNT WITH INSTITUTION                                                         MD027286
      *                                                                                     MD027286
      ***  Output fields according to Input type (AWITTP)                                   MD027286
      ***  AWITTP can only be one of S (SWIFT Bic), C (Customer), A (free format address)   MD027286
      ***      X (Party Identfier only - 57C)                                               MD027286
      ***  If S or C,  TACA11 is filled, TACA35 may be filled with account line, TAC(B-E)35 MD027286
      ***    should be blank                                                                MD027286
      ***  If A, TACA11 should be blank, TAC(B-E)35 filled (some or all), TACA11 may be     MD027286
      ***    should be blank                                                                MD027286
      ***  If X, TACA11 should be blank, TACA35 filled, TAC(B-E)35 *blank                   MD027286
      ***                                                                                   MD027286
      *                                                                                     MD027286
      *  SWIFT Id Entry                                                                     MD027286
      *                                                                                     MD027286
     C                   Eval      WSwiftId = *blanks                                       MD027286
     C                   EVAL      WRKTAG = *BLANKS                                         MD034339
      *                                                                                     MD027286
     C                   If        AWITTP = 'S'                                             MD027286
      *                                                                                     MD027286
      * Now, determine if BIC is BEI                                                        MD027286
      *                                                                                     MD027286
     C                   Eval      WChgInd = *blanks                                        MD027286
     C                   Eval      Char18  = *blanks                                        MD027286
     C                   Movel     TACA11        Char18                                     MD027286
                                                                                            MD027286
     C                   CALLB     'AOBICDV0'                                               MD027286
     C                   PARM      *BLANKS       RetCodeIn                                  MD027286
     C                   PARM                    Char18                                     MD027286
     C                   PARM                    @Type                                      MD027286
     C     MEBICD        PARM      *BLANKS       DSSDY                                      MD027286
                                                                                            MD027286
     C                   IF        @Type = '*BIC'                                           MD027286
     C                   CALL      'AOBEISR0'                                               MD027286
     C                   PARM      *BLANKS       PRetCode                                   MD027286
     C                   PARM      '*VERIFY'     POption                                    MD027286
     C                   PARM      BDSUBT        PBICD                                      MD027286
     C     MEBEIS        PARM      MEBEIS        DSFDY                                      MD027286
      *                                                                                     MD027286
     C                   IF        PRetCode = *blanks                                       MD027286
     C                   EVAL      WChgInd = 'Y'                                            MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   EVAL      MTAG = ':57D:'                                           MD027286
     C                   EVAL      WRKTAG = MTAG                                            MD034339
      *                                                                                     MD027286
     C                   If        TACA35 <> *blanks                                        MD027286
     C                   EVAL      MFLD = TACA35                                            MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   Endif                                                              MD027286
      *                                                                                     MD027286
     C                   EVAL      MFLD = TACA11                                            MD027286
      *                                                                                     MD027286
     C                   ENDIF                                                              MD027286
      *                                                                                     MD027286
     C                   ENDIF                                                              MD027286
      *                                                                                     MD027286
     C                   If        WChgInd <> 'Y'                                           MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   EVAL      MTAG = ':57A:'                                           MD027286
     C                   EVAL      WRKTAG = MTAG                                            MD034339
     C                   If        TACA35 <> *blanks                                        MD027286
     C                   EVAL      MFLD = TACA35                                            MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   Endif                                                              MD027286
     C                   EVAL      MFLD = TACA11                                            MD027286
     C                   Endif                                                              MD027286
      *                                                                                     MD027286
     C                   ENDIF                                                  End 'S'     MD027286
      *                                                                                     MD027286
      *  Customer entry                                                                     MD027286
     C                   If        AWITTP = 'C'                                             MD027286
      *                                                                                     MD027286
     C                   Movel     *blanks       Char18                                     MD027286
     C                   Eval      WChgInd = *blanks                                        MD027286
      *                                                                                     MD027286
     C                   MOVEL     TACA11        @KEY1                                      MD027286
     C                   CALL      'AOCUSTR0'                                               MD027286
     C                   PARM      '*BLANKS'     @RTCD                                      MD027286
     C                   PARM      '*KEY   '     @OPTN                                      MD027286
     C                   PARM                    @KEY1                                      MD027286
     C                   PARM      *BLANKS       @KYST                                      MD027286
     C     SDCUST        PARM      SDCUST        DSSDY                                      MD027286
      *                                                                                     MD027286
     C                   IF        @RTCD = *BLANKS                                          MD027286
      *                                                                                     MD027286
     C                   If        BBCSID <> *BLANKS                                        MD027286
     C                   Movel     BBCSID        Char18                                     MD027286
      *                                                                                     MD027286
      * Now, determine if BIC is BEI                                                        MD027286
     C                   CALLB     'AOBICDV0'                                               MD027286
     C                   PARM      *BLANKS       RetCodeIn                                  MD027286
     C                   PARM                    Char18                                     MD027286
     C                   PARM                    @Type                                      MD027286
     C     MEBICD        PARM      *BLANKS       DSSDY                                      MD027286
                                                                                            MD027286
     C                   IF        @Type = '*BIC'                                           MD027286
     C                   CALL      'AOBEISR0'                                               MD027286
     C                   PARM      *BLANKS       PRetCode                                   MD027286
     C                   PARM      '*VERIFY'     POption                                    MD027286
     C                   PARM      BDSUBT        PBICD                                      MD027286
     C     MEBEIS        PARM      MEBEIS        DSFDY                                      MD027286
      *                                                                                     MD027286
     C                   IF        PRetCode = *blanks                                       MD027286
     C                   EVAL      WChgInd = 'Y'                                            MD027286
     C                   Endif                                                              MD027286
     C                   Endif                                                              MD027286
     C                   Endif                                                              MD027286
                                                                                            MD027286
     C                   If        WChgInd = 'Y' or                                         MD027286
     C                             BBCSID  = *blanks                                        MD027286
                                                                                            MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   EVAL      MTAG = ':57D:'                                           MD027286
     C                   EVAL      WRKTAG = MTAG                                            MD034339
      *                                                                                     MD027286
     C                   If        TACA35 <> *blanks                                        MD027286
     C                   EVAL      MFLD = TACA35                                            MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   Endif                                                              MD027286
                                                                                            MD027286
     C                   If        BBCNA1 <> *Blanks                                        MD027286
     C                   Eval      MFLD = BBCNA1                                            MD027286
     C                   Endif                                                              MD027286
                                                                                            MD027286
     C                   If        BBCNA2 <> *Blanks                                        MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   Eval      MFLD = BBCNA2                                            MD027286
     C                   Endif                                                              MD027286
     C                   If        BBCNA3 <> *Blanks                                        MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   Eval      MFLD = BBCNA3                                            MD027286
     C                   Endif                                                              MD027286
     C                   If        BBCNA4 <> *Blanks                                        MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   Eval      MFLD = BBCNA4                                            MD027286
     C                   Endif                                                              MD027286
      *                                                                                     MD027286
     C                   ELSE                                                               MD027286
                                                                                            MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   EVAL      MTAG = ':57A:'                                           MD027286
     C                   EVAL      WRKTAG = MTAG                                            MD034339
      *                                                                                     MD027286
     C                   If        TACA35 <> *blanks                                        MD027286
     C                   EVAL      MFLD = TACA35                                            MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   Endif                                                              MD027286
                                                                                            MD027286
     C                   Eval      MFLD = BBCSID                                            MD027286
      *                                                                                     MD027286
     C                   ENDIF                                                              MD027286
      *                                                                                     MD027286
     C                   ENDIF                                                              MD027286
      *                                                                                     MD027286
     C                   ENDIF                                                  End 'C'     MD027286
      *                                                                                     MD034339
     C                   IF        WRKTAG = *BLANKS                                         MD034339
      *                                                                                     MD027286
      * Party Identifier                                                                    MD027286
      *                                                                                     MD027286
     C                   If        AWITTP = 'A'  And                                        MD027286
     C                             %subst(TACA35:1:2) = '//'  And                           MD027286
     C                             TACB35 = *blank     And                                  MD027286
     C                             TACC35 = *blank     And                                  MD027286
     C                             TACD35 = *blank     And                                  MD027286
     C                             TACE35 = *blank                                          MD027286
      *                                                                                     MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   EVAL      MTAG = ':57C:'                                           MD027286
     C                   EVAL      MFLD = TACA35                                            MD027286
      *                                                                                     MD027286
     C                   Else                                                    End 57C    MD027286
      *                                                                                     MD027286
      ** Address entry                                                                      MD027286
      *                                                                                     MD027286
      *                                                                                     MD027286
     C                   IF        TACA35 <> *Blanks                                        MD034339
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   EVAL      MTAG = ':57D:'                                           MD027286
     C**********         If        TACA35 <> *Blanks                               MD027286 MD034339
     C                   EVAL      MFLD = TACA35                                            MD027286
     C                   Endif                                                              MD027286
                                                                                            MD027286
     C                   If        TACB35 <> *Blanks                                        MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   Eval      MFLD = TACB35                                            MD027286
     C                   Endif                                                              MD027286
                                                                                            MD027286
     C                   If        TACC35 <> *Blanks                                        MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   Eval      MFLD = TACC35                                            MD027286
     C                   Endif                                                              MD027286
                                                                                            MD027286
     C                   If        TACD35 <> *Blanks                                        MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   Eval      MFLD = TACD35                                            MD027286
     C                   Endif                                                              MD027286
                                                                                            MD027286
     C                   If        TACE35 <> *Blanks                                        MD027286
     C                   Eval      Q = Q + 1                                                MD027286
     C     Q             Occur     MULT                                                     MD027286
     C                   Eval      MFLD = TACE35                                            MD027286
     C                   Endif                                                              MD027286
      *                                                                                     MD027286
     C                   Endif                                                   End 'A'    MD027286
 
     C                   ENDIF                                                              MD034339
 
      * Beneficiary
      *                                                                                       CSW215
      ** SWIFT 2015 changes :59F:                                                             CSW215
      *                                                                                       CSW215
     C                   EVAL      WRK59F = 'N'                                               CSW215
      *                                                                                       CSW215
     C                   IF        CSW215 = 'Y'                                               CSW215
     C                   IF        %SUBST(TBNA35:1:1) = '1/' OR                               CSW215
     C                             (%SUBST(TBNA35:1:1) = '/' AND                              CSW215
     C                              %SUBST(TBNB35:1:2) = '1/')                                CSW215
     C                   EVAL      WChgInd = 'N'                                              CSW215
     C                   EVAL      WRK59F  = 'Y'                                              CSW215
     C                   EVAL      Q = Q + 1                                                  CSW215
     C     Q             OCCUR     MULT                                                       CSW215
     C                   EVAL      MTAG = ':59F:'                                             CSW215
     C                   EVAL      MFLD = TBNA35                                              CSW215
     C                   ELSE                                                                 CSW215
      ** Format :59F:                                                                         CSW215
     C                   EVAL      PIN1 = TBNA35                                              CSW215
     C                   EVAL      PIN2 = TBNB35                                              CSW215
     C                   EVAL      PIN3 = TBNC35                                              CSW215
     C                   EVAL      PIN4 = TBND35                                              CSW215
     C                   EVAL      PIN5 = TBNE35                                              CSW215
     C                   EXSR      SRFormat59F                                                CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   IF        WRK59F = 'N'                                               CSW215
      * Both the first and second fields are mandatory
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':59:'
     C                   Eval      MFLD = TBNA35
      *                                                                                       CSW201
      ** If SWIFT 2001 enhancement is installed                                               CSW201
      *                                                                                       CSW201
     C                   IF        CSW201 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      WChgInd = 'N'                                              CSW201
     C                   EVAL      KEYVAL = *BLANKS                                           CSW201
     C                   EVAL      Char18 = *BLANKS                                           CSW201
                                                                                              CSW201
     C                   IF        %SUBST(TBNA35:1:1) = '/'                                   CSW201
     C                   Z-ADD     2             Wx                                           CSW201
     C                   ELSE                                                                 CSW201
     C                   Z-ADD     1             Wx                                           CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   SELECT                                                               CSW201
      *                                                                                       CSW201
      ** Retail Account                                                                       CSW201
      *                                                                                       CSW201
     C                   WHEN      BENTTP = 'R'                                               CSW201
                                                                                              CSW201
     C                   EVAL      ParmStr = *BLANKS                                          CSW201
     C                   EVAL      ParmStr = %SUBST(TBNA35:Wx:10)                             CSW201
                                                                                              CSW201
     C                   CALLB     'AOACCTV1'                                                 CSW201
     C                   PARM      *Blanks       @RTCD                                        CSW201
     C                   PARM      *Blanks       @Type                                        CSW201
     C                   PARM                    ParmStr                                      CSW201
     C                   PARM                    DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        @RTCD = *BLANKS                                            CSW201
     C                   EVAL      P@ACC = DSSDY                                              CSW201
     C                   MOVEL     CNUM          KEYVAL                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Nostro Account                                                                       CSW201
      *                                                                                       CSW201
     C                   WHEN      BENTTP = 'F'                                               CSW201
                                                                                              CSW201
     C                   EVAL      PNOSD = %SUBST(TBNA35:Wx:5)                                CSW201
     C                   EVAL      PCYCD = %SUBST(PNOSD:1:3)                                  CSW201
     C                   EVAL      PNONB = %SUBST(PNOSD:4:2)                                  CSW201
      *                                                                                       CSW201
     C                   CALLB     'AONOSTR0'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
     C                   PARM      '*KEY   '     @OPTN                                        CSW201
     C                   PARM      *BLANKS       PCUST                                        CSW201
     C                   PARM                    PCYCD                                        CSW201
     C                   PARM      *BLANKS       PACCD                                        CSW201
     C                   PARM      *BLANKS       PACSN                                        CSW201
     C                   PARM                    PNONB                                        CSW201
     C                   PARM      *BLANKS       PBRCD                                        CSW201
     C                   PARM      *BLANKS       PCSSN                                        CSW201
     C                   PARM      *BLANKS       PPNOI                                        CSW201
     C     SDNOST        PARM      *BLANKS       DSFDY                                        CSW201
                                                                                              CSW201
     C                   IF        @RTCD = *BLANKS                                            CSW201
     C                   EVAL      KEYVAL = A7CUST                                            CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** General Ledger Account                                                               CSW201
      *                                                                                       CSW201
     C                   WHEN      BENTTP = 'G'                                               CSW201
                                                                                              CSW201
     C                   IF        Wx = 1                                                     CSW201
     C                   EVAL      KEYVAL = %SUBST(TBNA35:4:6)                                CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      KEYVAL = %SUBST(TBNA35:5:6)                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** IBAN Account                                                                         CSW201
      *                                                                                       CSW201
     C                   WHEN      BENTTP = 'I' AND                                           CSW201
     C                             CFT004 = 'Y'                                               CSW201
                                                                                              CSW201
     C                   EVAL      DSSDY = *BLANKS                                            CSW201
     C                   EVAL      PIBAN = %SUBST(TBNA35:Wx:34)                               CSW201
                                                                                              CSW201
     C                   CALLB     'AOIBANR4'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
     C                   PARM      '*KEY   '     @OPTN                                        CSW201
     C                   PARM                    PIBAN                                        CSW201
     C     P@ACC         PARM      *BLANKS       DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        @RTCD = *BLANKS                                            CSW201
     C                   MOVEL     CNUM          KEYVAL                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** entry could be a customer number or a customer shortname                             CSW201
      *                                                                                       CSW201
     C                   OTHER                                                                CSW201
      *                                                                                       CSW201
     C                   IF        Wx = 1                                                     CSW201
                                                                                              CSW201
     C                   IF        %SUBST(TBNA35:1:6) <> *BLANKS AND                          CSW201
     C                             %SUBST(TBNA35:7:29) = *BLANKS                              CSW201
     C                   EVAL      KEYVAL = %SUBST(TBNA35:1:6)                                CSW201
     C                   ELSE                                                                 CSW201
     C                   IF        %SUBST(TBNA35:1:10)<> *BLANKS AND                          CSW201
     C                             %SUBST(TBNA35:11:25) = *BLANKS                             CSW201
     C                   EVAL      KEYVAL = %SUBST(TBNA35:1:10)                               CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   IF        %SUBST(TBNA35:2:6) <> *BLANKS AND                          CSW201
     C                             %SUBST(TBNA35:8:28) = *BLANKS                              CSW201
     C                   EVAL      KEYVAL = %SUBST(TBNA35:2:6)                                CSW201
     C                   ELSE                                                                 CSW201
     C                   IF        %SUBST(TBNA35:2:10)<> *BLANKS AND                          CSW201
     C                             %SUBST(TBNA35:12:24) = *BLANKS                             CSW201
     C                   EVAL      KEYVAL = %SUBST(TBNA35:2:10)                               CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDSL                                                                CSW201
                                                                                              CSW201
     C                   IF        KEYVAL <> *BLANKS                                          CSW201
     C                   CALLB     'AOCUSTR0'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
     C                   PARM      '*KEY   '     @OPTN                                        CSW201
     C                   PARM                    KEYVAL                                       CSW201
     C                   PARM      *BLANKS       @TYPE                                        CSW201
     C                   PARM                    SDCUST                                       CSW201
     C                   IF        @RTCD = *BLANKS AND                                        CSW201
     C                             BBCSID <> *BLANKS                                          CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** If customer not existing, check if second field is BEI/BIC.                          CSW201
      *                                                                                       CSW201
     C                   IF        Char18 = *BLANKS AND                                       CSW201
     C                             TBNB35 <> *BLANKS                                          CSW201
                                                                                              CSW201
     C                   EVAL      KEYVAL = TBNB35                                            CSW201
                                                                                              CSW201
     C                   CALLB     'AOCUSTR0'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
     C                   PARM      '*KEY   '     @OPTN                                        CSW201
     C                   PARM                    KEYVAL                                       CSW201
     C                   PARM      *BLANKS       @TYPE                                        CSW201
     C                   PARM                    SDCUST                                       CSW201
                                                                                              CSW201
     C                   IF        @RTCD = *BLANKS AND                                        CSW201
     C                             BBCSID <> *BLANKS                                          CSW201
     C                   EVAL      Char18 = BBCSID                                            CSW201
     C                   ELSE                                                                 CSW201
     C                   EVAL      Char18 = TBNB35                                            CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   EVAL      WSwiftId = Char18                                          CSW201
      *                                                                                       CSW201
      ** Check if SWIFT ID exists in BIC directory                                            CSW201
      *                                                                                       CSW201
     C                   IF        Char18 <> *BLANKS                                          CSW201
     C                   CALLB     'AOBICDV0'                                                 CSW201
     C                   PARM      *BLANKS       RetCodeIn                                    CSW201
     C                   PARM                    Char18                                       CSW201
     C                   PARM                    @Type                                        CSW201
     C     MEBICD        PARM      *BLANKS       DSSDY                                        CSW201
                                                                                              CSW201
     C                   IF        @Type = '*BIC'                                             CSW201
     C                   EVAL      MTAG = ':59A:'                                             CSW201
     C                   EVAL      WChgInd = 'Y'                                              CSW201
     C                   EVAL      Q = Q + 1                                                  CSW201
     C     Q             OCCUR     MULT                                                       CSW201
     C                   EVAL      MFLD = WSwiftId                                            CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW201
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
     C                   ENDIF                                                                CSW215
                                                                                              CSW201
     C                   IF        CSW201 = 'N' OR                                            CSW201
     C                             WChgInd <> 'Y'                                             CSW201
 
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = TBNB35
 
     C                   If        TBNC35 <> *Blanks
     C                   Eval      Q = Q + 1                                     184183
     C     Q             Occur     MULT
     C                   Eval      MFLD = TBNC35
     C                   Endif
 
     C                   If        TBND35 <> *Blanks
     C                   Eval      Q = Q + 1                                     184183
     C     Q             Occur     MULT
     C                   Eval      MFLD = TBND35
     C                   Endif
 
     C                   If        TBNE35 <> *Blanks
     C                   Eval      Q = Q + 1                                     184183
     C     Q             Occur     MULT
     C                   Eval      MFLD = TBNE35
     C                   Endif
                                                                                              CSW201
     C                   ENDIF                                                                CSW201
 
      * Remittance Information
     C                   If        TRMA35 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG =  ':70:'
     C                   Eval      MFLD = TRMA35
     C                   Endif
      *
     C                   If        TRMB35 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = TRMB35
     C                   Endif
      *
     C                   If        TRMC35 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = TRMC35
     C                   Endif
      *
     C                   If        TRMD35 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = TRMD35
     C                   Endif
 
      * Regulatory Reporting
     C                   If        TRGA35 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG =  ':77B:'
     C                   Eval      MFLD = TRGA35
     C                   Endif
      *
     C                   If        TRGB35 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = TRGB35
     C                   Endif
      *
     C                   If        TRGC35 <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MFLD = TRGC35
     C                   Endif
 
      * Currency/Original Ordered Amount
     C                   If        TOCCY <> *Blanks  AND
     C                             TOCCY <> TRNCCY
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':33B:'
     C                   Eval      CCY33 = TOCCY
     C                   Eval      WCCY = TOCCY
     C                   Eval      WAMNT = TOOAMT
     C                   Exsr      SRFAMT
     C                   Eval      AMNT33 = AMT
     C                   Eval      MFLD = FLD33
     C                   Eval      R33B = FLD33
     C                   Endif
 
      * Details of Charges
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':71A:'
     C                   Eval      MFLD = TDCHGS
 
      * Charges Account
     C                   If        CHGACC <> *Blanks
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':25A:'
     C                   Eval      MFLD = CHGACC
     C                   Endif
 
      * Exchange Rate
     C                   If        XRATE <> 0     AND
     C                             TOOAMT <> 0    AND
     C                             TOCCY <> TRNCCY
     C                   Eval      Q = Q + 1
     C     Q             Occur     MULT
     C                   Eval      MTAG = ':36:'
     C                   Call      'ZM0030'
     C                   Parm      XRATE         ZEXRT            13 8
     C                   Parm      *Blanks       ZSEXRT           12
     C                   Eval      MFLD = ZSEXRT
     C                   Eval      RXRATE = ZSEXRT
     C                   Endif
 
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * SRBRCH - Validate each booking branch for every record called *
      *          by main processing.                                  *
      *****************************************************************
      *
     C     SRBRCH        Begsr
      *
      * Save Booking Branch (BRCA) Read from FT101HPD
      *
     C                   Move      BRCA          BRCAA             3
      *
      * Set up key and access inst. control rec branch code (TABLETR)
      *
     C**********         Movel     '10    '      ZTABKY                                     BUG13217
     C**********         Move      BRCA          ZTABKY                                     BUG13217
     C*****ZTABKY        Chain     TABFP                              10                    BUG13217
     C**********         If        *IN10 or RECI <> 'D'                                     BUG13217
     C******LOCK         In        LDA                                                      BUG13217
     C**********         Movel     'TABFP'       DBFILE                                     BUG13217
     C**********         Movel     ZTABKY        DBKEY                                      BUG13217
     C**********         Z-add     9             DBASE                                      BUG13217
     C**********         Out       LDA                                                      BUG13217
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
      *
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
 
     C                   Move      *Blanks       OSTAG             1
     C                   Move      'N'           OSUFLG            1
 
 
     C                   If        %Subst(ISPTY1:1:1) = '/'
     C                   If        %Subst(ISPTY1:2:1) <> '/'
     C                   Eval      ISPTY1 = %Subst(ISPTY1:2:34)
     C                   Endif
     C                   Endif
 
     C                   Select
     C                   When      ISPTP = 'F'
     C                   Movel     ISPTY1        TLCCNN            5
     C                   Movel     '70'          TABTLK
     C                   Move      TLCCNN        TABTLK           12
      *
     C     TABTLK        Chain     TABFP                              10
     C                   If        *IN10
     C     *LOCK         In        LDA
     C                   Movel     TABTLK        DBKEY
     C                   Z-add     12            DBASE
     C                   Eval      DBFILE = 'TABFP'
     C                   Out       LDA
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
      * General Ledger Account
      *
     C                   When      ISPTP = 'G' or ISPTP = 'C'
      *
      * If using account line construct then use second line
      *
     C                   If        ISPTP = 'G'
     C                   Eval      CUSTNOC = %Subst(ISPTY1:4:6)
     C                   MOVEL     CUSTNOC       CUSTNO
     C                   Else
     C                   If        ##001 = '/'
     C                   Eval      CUSTNOC = %Subst(ISPTY1:2:6)
     C                   Else
     C                   Eval      CUSTNOC = %Subst(ISPTY1:1:6)
     C                   Endif
     C                   MOVEL     CUSTNOC       CUSTNO
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
     C     *LOCK         In        LDA
     C                   Movel     'ACCNTL6'     DBFILE
     C                   Movel     ISPTY1        DBKEY
     C                   Z-add     14            DBASE
     C                   Out       LDA
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
     C                   Endif
     C                   Movel     ISPTY1        ##002             2
      *
     C                   Select
 
     C                   When      IVTAG1 = 'A' AND ISPTY1A <> *Blanks
 
     C                   Eval      SCSID = ISPTY1A
 
     C                   Movel     ISPTY1        ##001             1
      *
     C                   If        ##001 = '/'
     C                   Movel     ISPTY1        OFSPT1
     C                   Movel     SCSID         OFSPT2
     C                   Else
     C                   Movel     SCSID         OFSPT1
     C                   Endif
     C                   Move      'A'           OSTAG
      *
     C                   When      IVTAG3 = 'C' AND ISPTY1A = *Blanks
 
     C                   Movel     ISPTY1        OFSPT1
     C                   Move      'C'           OSTAG
     C
     C                   When      IVTAG3 = 'D'
      *
     C                   Movel     ISPTY1        ##001
     C                   Move      'D'           OSTAG
     C                   If        ##001 = '/'
     C                   Movel     ISPTY1        OFSPT1
     C                   Movel     CNA1          OFSPT2
     C                   Movel     CNA2          OFSPT3
     C                   Movel     CNA3          OFSPT4
     C                   Movel     CNA4          OFSPT5
     C                   Else
     C                   Movel     CNA1          OFSPT1
     C                   Movel     CNA2          OFSPT2
     C                   Movel     CNA3          OFSPT3
     C                   Movel     CNA4          OFSPT4
     C                   Endif
     C                   Endsl
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
     C                   Exsr      SRMPRF
      *
      **  Write multiple occurrence data structure to MGOMSGPD
     C**********         Z-Add     1             X                 2 0    190200
     C                   Z-Add     1             X                 4 0    190200
     C     X             Occur     MULT
      *
     C                   Dow       X <= Q
     C                   If        MFLD <> *Blanks
     C                   Write     MGOMSGD0                             42
     C                   Endif
      *
      **  Error on write to PF/MGOMSGPD (message data file)
      *
     C                   If        *IN42
     C     *LOCK         In        LDA
     C                   Z-Add     16            DBASE                          * * * * * * * *
     C                   Movel     MFLD          DBKEY                          *  DBERR 005  *
     C                   Movel     'MGOMSGPD'    DBFILE                         * * * * * * * *
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   Eval      X = X + 1
     C     X             Occur     MULT
     C                   Enddo
      *
     C                   Endsr
      *
     C/EJECT
      *****************************************************************
      * SRMPRF - Map General Information Details to MGOREFPD fields   *
      *****************************************************************
     C     SRMPRF        Begsr
     C                   Eval      MODI = 'FT'
     C                   Eval      TRNO = RFTID
     C                   Eval      TRNF = *Blanks
     C                   Eval      TRNM = *Blanks
     C                   Eval      MTRN = RFTID
     C                   Eval      TNTP = PYTP
     C                   Eval      SBTP = PYST
     C                   Eval      EVTP = *Blanks
     C                   Eval      NWRK = 'SWIFT'
     C                   Eval      SECN = SBICN
     C                   Eval      NWSN = STID
      *
      * Field Destination
      *  Must come from destination field in header record.
      *  Can be entered in as a BIC or customer number or Shortname.
      *
     C                   Eval      Char18 = RFTDST
     C**********         CallB     'AOBICDV0'                                               BUG21160
     C                   CallB     'AOBICDV01'                                              BUG21160
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    Char18           18
     C                   Parm                    @Type
     C                   Parm                    DSSDY
 
     C                   If        @Type = '*BIC'
     C                   Eval      NWDS = RFTDST
 
      * Not a Bic.  Must be a customer number or shortname
     C                   Else
 
     C                   Movel     RFTDST        KeyVal
 
     C                   CallB     'AOCUSTR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Optn
     C                   Parm                    KeyVal           10
     C                   Parm      *Blanks       @Type
     C                   Parm                    SDCUST
 
      * Customer must have a BIC
     C                   Eval      NWDS = BBCSID
 
     C                   Endif
      *
      *
     C                   Eval      NWBN = *Blanks
     C                   Eval      MTPY = '101'
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
     C                   Parm      EXDATE        ZMDAY
     C                   Parm                    ZMDATE
     C                   Eval      SVDT = ZMDATE
     C                   Eval      CCY = TRNCCY
     C                   Eval      NSNO = *Zeros
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
     C                   If        TRNCCY <> *Blanks
     C                   Callb     'AOCURRR0'
     C                   Parm      '*MSG   '     @RTCD             7
     C                   Parm      '*KEY   '     @OPTN             7
     C                   Parm      TRNCCY        @CCY              3
     C     SDCURR        Parm      SDCURR        DSSDY
      *                                                                   S01117
     C                   If        @RTCD <> *Blanks
     C     *LOCK         In        LDA
     C                   Z-Add     17            DBASE                            *************
     C                   Movel     @CCY          DBKEY                            * DBERR 027 *
     C                   Movel     'SDCURRPD'    DBFILE                           *************
     C                   Out       LDA
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
     C                   IF        CSW215 = 'Y' AND NWRK = 'SWIFT'                            CSW215
     C                             AND A6PMRT = 'Y'                                           CSW215
     C                   MOVEL     'PAPER'       NWRK                                         CSW215
     C                   ENDIF                                                                CSW215
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
     C                   Eval      X = 1
     C                   Dow       X <= Q
     C     X             Occur     MULT
     C                   Movel     CRLF          CTRC                           187213
     C                   Eval      MTAG = *Blanks
     C                   Eval      MFLD = *Blanks
     C                   Eval      X = X + 1
     C                   Enddo
     C
     C                   Endsr
     C/EJECT
      *****************************************************************
      * SRH1 - Output an entry to SWIFT Message Report                *
      *****************************************************************
     C     SRH1          Begsr
     C                   Eval      PAGEP1 = PAGEP1 + 1
     C                   Eval      RRFTID = RFTID
     C                   Eval      ROTID = STID
     C                   Eval      RSWPC = SWPRIO
     C                   Eval      RADDR = HACSV2
     C                   Eval      RCUSTR = CUSTRF
     C                   Eval      RINPTY = HINPTY
     C                   Eval      RORDC1 = HOCUS1
     C                   Eval      RORDC2 = HOCUS2
     C                   Eval      RORDC3 = HOCUS3
     C                   Eval      RORDC4 = HOCUS4
     C                   Eval      RORDC5 = HOCUS5
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                             AND PRTCD = *BLANKS                                        CSW207
     C                   Eval      RORDC1 = POUT1                                             CSW207
     C                   Eval      RORDC2 = POUT2                                             CSW207
     C                   Eval      RORDC3 = POUT3                                             CSW207
     C                   Eval      RORDC4 = POUT4                                             CSW207
     C                   Eval      RORDC5 = POUT5                                             CSW207
     C                   ENDIF                                                                CSW207
     C                   Eval      RACSV1 = HACSV1
     C                   Eval      RACSV2 = HACSV2
     C                   Eval      RSINST = SINST
     C                   Eval      RAUTHX = AUTHTX
     C
     C                   Write     P1H1
     C                   Endsr
     C/EJECT
      *****************************************************************
      * SRD1 - Output an entry to SWIFT Message Report                *
      *****************************************************************
     C     SRD1          Begsr
     C                   Eval      PAGEP1 = PAGEP1 + 1
     C                   Eval      RTRNRF = TRNSID
     C                   Eval      RFXDLR = FXDREF
     C                   Eval      RINSC1 = INSCA4
     C                   Eval      RINSC2 = INSCB4
     C                   Eval      RINSC3 = INSCC4
     C                   Eval      RINSC4 = INSCD4
     C                   Eval      RINSC5 = INSCE4
     C                   Eval      RINSC6 = INSA31
     C                   Eval      RINSC7 = INSB31
     C                   Eval      RDINPY = TINPTY
     C                   Eval      RDORC1 = TOCUS1
     C                   Eval      RDORC2 = TOCUS2
     C                   Eval      RDORC3 = TOCUS3
     C                   Eval      RDORC4 = TOCUS4
     C                   Eval      RDORC5 = TOCUS5
     C                   IF        CSW207 = 'Y'                                               CSW207
     C                             AND PRTCD = *BLANKS                                        CSW207
     C                   Eval      RDORC1 = POUT1                                             CSW207
     C                   Eval      RDORC2 = POUT2                                             CSW207
     C                   Eval      RDORC3 = POUT3                                             CSW207
     C                   Eval      RDORC4 = POUT4                                             CSW207
     C                   Eval      RDORC5 = POUT5                                             CSW207
     C                   ENDIF                                                                CSW207
     C                   Eval      RDACS1 = TASI35
     C                   Eval      RDACS2 = TACC11
     C                   Eval      RINT1 = TINST1
     C                   Eval      RINT2 = TINST2
     C                   Eval      RINT3 = TINST3
     C                   Eval      RINT4 = TINST4
     C                   Eval      RINT5 = TINST5
     C                   Eval      RINT6 = TINSTA
     C                   Eval      RACI1 = TACA35
     C                   Eval      RACI2 = TACB35
     C                   Eval      RACI3 = TACC35
     C                   Eval      RACI4 = TACD35
     C                   Eval      RACI5 = TACE35
     C                   Eval      RACI6 = TACA11
     C                   Eval      RBEN1 = TBNA35
     C                   Eval      RBEN2 = TBNB35
     C                   Eval      RBEN3 = TBNC35
     C                   Eval      RBEN4 = TBND35
     C                   Eval      RBEN5 = TBNE35
     C                   Eval      RREM1 = TRMA35
     C                   Eval      RREM2 = TRMB35
     C                   Eval      RREM3 = TRMC35
     C                   Eval      RREM4 = TRMD35
     C                   Eval      RREG1 = TRGA35
     C                   Eval      RREG2 = TRGB35
     C                   Eval      RREG3 = TRGC35
     C                   Eval      RDETCH = TDCHGS
     C                   Eval      RCHRAC = CHGACC
     C
     C                   Write     P1D1
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
     C                   Movel     'FT'          PMODI                                     BUG15010A
      *                                                                                    BUG15010A
      ** get Country of location of Destination                                            BUG15010A
     C                   If        %Subst(RFTDST:1:1) = '/'                                BUG15010A
     C                   EVAL      ParmStr = %SUBST(RFTDST:2:34)                           BUG15010A
     C                   Else                                                              BUG15010A
     C                   EVAL      ParmStr = RFTDST                                        BUG15010A
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
     C                   Move      SWF07CNUM     WCNUM                                     BUG15010A
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
     C                   Move      CNUM          WCNUM             6                       BUG15010A
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
     C                   If        DCUSTP <> *Blanks                                        BUG15090
     C                   Eval      OCTYP = DCUSTP                                           BUG15090
     C                   Else                                                               BUG15090
     C                   Eval      OCTYP = CUSTTP                                           BUG15090
     C                   EndIf                                                              BUG15090
                                                                                           BUG15010A
      ** if input type is customer, set value to customer parameter of FT001000            BUG15010A
     C                   If        OCTYP = 'C'                                             BUG15010A
     C                   IF        %SUBST(PIN1:1:1) = '/'                                   BUG21328
     C                             AND CSW207 = 'Y'                                         BUG21328
     C                   MOVEL     PIN2          PCNUM                                      BUG21328
     C                   ELSE                                                               BUG21328
     C                   Movel     PIN1          PCNUM                                     BUG15010A
     C                   ENDIF                                                              BUG21328
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
      ** if input type is IBAN, Retail or Ledger, set Account parameter of FT001000        BUG15010A
     C                   If        OCTYP = 'I' Or                                          BUG15010A
     C                             OCTYP = 'P' Or                                          BUG15010A
     C                             OCTYP = 'G' Or                                           BUG21328
     C                             OCTYP = 'R'                                             BUG15010A
     C                   Exsr      GetAccount                                              BUG15010A
     C                   EndIf                                                             BUG15010A
                                                                                           BUG15010A
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
     C**********         Parm      CUSTTP        PATYP             1               BUG15065 BUG15090
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
     C                   Parm      '101'         PMSGTP            3                          CSW207
      ** Message Tag                                                                          CSW207
     C                   Parm      ':50F:'       PMSGTG            5                          CSW207
      ** Country of Location                                                                  CSW207
     C                   Parm                    PCCD              2                          CSW207
      ** Branch Code                                                                          CSW207
     C**********         Parm                    PBRCH             3                 CSW207 BUG15010
     C                   Parm      BRCA          PBRCH             3                        BUG15010
      ** Currency Code                                                                        CSW207
     C*                  Parm      CCY           PCCY              3                          CSW207
     C**********         Parm                    PCCY              3                 CSW207 BUG15010
     C                   Parm      TRNCCY        PCCY              3                        BUG15010
      ** Nostro                                                                               CSW207
     C**********         Parm                    PNOST             2                CSW207 BUG15010A
     C                   Parm      *Blanks       PNOST             2                       BUG15010A
      ** Module Indicator                                                                     CSW207
     C                   Parm                    PMODI             2                          CSW207
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
     C                   MOVEL     POUT1         MFLD                                         CSW207
      * Message 2                                                                             CSW207
     C                   IF        POUT2 <> *BLANKS                                           CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   MOVEL     POUT2         MFLD                                         CSW207
      * Message 3                                                                             CSW207
     C                   IF        POUT3 <> *BLANKS                                           CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   MOVEL     POUT3         MFLD                                         CSW207
      * Message 4                                                                             CSW207
     C                   IF        POUT4 <> *BLANKS                                           CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   MOVEL     POUT4         MFLD                                         CSW207
      * Message 5                                                                             CSW207
     C                   IF        POUT5 <> *BLANKS                                           CSW207
     C                   EVAL      Q = Q + 1                                                  CSW207
     C     Q             OCCUR     MULT                                                       CSW207
     C                   MOVEL     POUT5         MFLD                                         CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
     C                   ENDIF                                                                CSW207
     C**********         EVAL      MTAG = ':50F:'                                     CSW207 CSW207A
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
      *****************************************************************                       CSW215
     C/EJECT                                                                                  CSW215
      *****************************************************************                       CSW215
      *                                                               *                       CSW215
      * SRFormat59F - Format :59F: for Beneficiary Customer           *                       CSW215
      *                                                               *                       CSW215
      * Calls: MG001001                                               *                       CSW215
      *                                                               *                       CSW215
      *****************************************************************                       CSW215
      *                                                                                       CSW215
     C     SRFormat59F   BEGSR                                                                CSW215
      *                                                                                       CSW215
      ** Execute Midas MG Validation & Formatting for 59F                                     CSW215
      *                                                                                       CSW215
     C                   CALL      'MG001001'                                                 CSW215
      ** Return Code                                                                          CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
      ** Validtion Type                                                                       CSW215
     C                   PARM      'FRMT'        PVALTYP                                      CSW215
      ** 5X35 lines to be checked                                                             CSW215
     C                   PARM                    PIN1                                         CSW215
     C                   PARM                    PIN2                                         CSW215
     C                   PARM                    PIN3                                         CSW215
     C                   PARM                    PIN4                                         CSW215
     C                   PARM                    PIN5                                         CSW215
      ** Network                                                                              CSW215
     C                   PARM      'SWIFT'       PNWRK                                        CSW215
      ** Message Type                                                                         CSW215
     C                   PARM      '101'         PMSGTP                                       CSW215
      ** Message Tag                                                                          CSW215
     C                   PARM      ':59F:'       PMSGTG                                       CSW215
      ** Branch Code                                                                          CSW215
     C                   PARM      BRCA          PBRCH                                        CSW215
      ** Country of Location                                                                  CSW215
     C                   PARM                    PCCD                                         CSW215
      ** Currency Code                                                                        CSW215
     C                   PARM      TRNCCY        PCCY                                         CSW215
      ** Nostro                                                                               CSW215
     C                   PARM      *BLANKS       PNOST                                        CSW215
      ** 5X35 lines to be output                                                              CSW215
     C                   PARM                    POUT1                                        CSW215
     C                   PARM                    POUT2                                        CSW215
     C                   PARM                    POUT3                                        CSW215
     C                   PARM                    POUT4                                        CSW215
     C                   PARM                    POUT5                                        CSW215
      ** Message ID Field                                                                     CSW215
     C                   PARM      *BLANKS       PMSGID                                       CSW215
      ** Error Type                                                                           CSW215
     C                   PARM      *BLANKS       PErrTyp                                      CSW215
      *                                                                                       CSW215
     C                   IF        PRTCD = *BLANKS                                            CSW215
     C                   EVAL      WChgInd = 'Y'                                              CSW215
     C                   EVAL      WRK59F  = 'Y'                                              CSW215
      * Message 1                                                                             CSW215
     C                   IF        POUT1 <> *BLANKS                                           CSW215
     C                   EVAL      Q = Q + 1                                                  CSW215
     C     Q             OCCUR     MULT                                                       CSW215
     C                   EVAL      MTAG = ':59F:'                                             CSW215
     C                   MOVEL     POUT1         MFLD                                         CSW215
      * Message 2                                                                             CSW215
     C                   IF        POUT2 <> *BLANKS                                           CSW215
     C                   EVAL      Q = Q + 1                                                  CSW215
     C     Q             OCCUR     MULT                                                       CSW215
     C                   MOVEL     POUT2         MFLD                                         CSW215
      * Message 3                                                                             CSW215
     C                   IF        POUT3 <> *BLANKS                                           CSW215
     C                   EVAL      Q = Q + 1                                                  CSW215
     C     Q             OCCUR     MULT                                                       CSW215
     C                   MOVEL     POUT3         MFLD                                         CSW215
      * Message 4                                                                             CSW215
     C                   IF        POUT4 <> *BLANKS                                           CSW215
     C                   EVAL      Q = Q + 1                                                  CSW215
     C     Q             OCCUR     MULT                                                       CSW215
     C                   MOVEL     POUT4         MFLD                                         CSW215
      * Message 5                                                                             CSW215
     C                   IF        POUT5 <> *BLANKS                                           CSW215
     C                   EVAL      Q = Q + 1                                                  CSW215
     C     Q             OCCUR     MULT                                                       CSW215
     C                   MOVEL     POUT5         MFLD                                         CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   ENDSR                                                                CSW215
      *                                                                                       CSW215     
      *****************************************************************                    BUG15010A
     C/EJECT                                                                               BUG15010A
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
     C                   Movel     '01      '    ZTABKY           12
     C                   Move      '  10'        ZTABKY
      *
     C     ZTABKY        Chain     TABFP                              99
     C                   If        *IN99  or RECI <>'D'
      *
     C     *LOCK         In        LDA
     C                   Movel     'TABFP'       DBFILE
     C                   Movel     ZTABKY        DBKEY
     C                   Z-Add     3             DBASE
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
      * Installation Control Record Found so save fields
      *
     C                   Move      RUNA          SRUNA             7
     C                   Move      TITL          STITL            53
      *
      * Set up key and access installation control record (TABTB11F)
      *
     C                   Move      *BLANKS       ZTABKY
     C                   Movel     '01'          ZTABKY
     C                   Move      '11'          ZTABKY
     C     ZTABKY        Chain     TABFP                              10
      *
     C                   If        *IN10 or RECI <> 'D'
     C     *LOCK         In        LDA
     C                   Movel     'TABFP'       DBFILE
     C                   Movel     ZTABKY        DBKEY
     C                   Z-Add     4             DBASE
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
      * Inst. Control Record Found so save CUST. NO. OF HEAD OFFICE
      *
     C**********         Z-Add     HEAD          SHEAD             6 0                        CSD027
     C                   Move      HEAD          SHEAD             6                          CSD027
      *
      * Access SDMMODPD for networks available.
      *
     C                   Call      'AOMMODR0'
     C                   Parm      '*MSG   '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDMMOD        Parm      SDMMOD        DSFDY
      *
      ** If no record is found on sdmmodpd.
      *
     C     @RTCD         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Z-Add     5             DBASE
     C                   Movel     'FIRST'       DBKEY
     C                   Movel     'SDMMODPD'    DBFILE
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
      **  Access SDMGMEPD for drop SWIFT msg. no. days
      *
     C                   Call      'AOMGMER0'
     C                   Parm      '*MSG   '     @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDMGME        Parm      SDMGME        DSFDY
      *
      ** If no record is found on SDMGMEPD.
      *
     C     @RTCD         IfNe      *BLANKS
     C     *LOCK         In        LDA
     C                   Z-Add     6             DBASE
     C                   Movel     'FIRST'       DBKEY
     C                   Movel     'SDMGMEPD'    DBFILE
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
      *
      **  Convert history retention date to YYMMDD
      *
     C     RUND          Add       ENDSMN        ZMDAY
     C                   Call      'ZM0060'                             15
     C                   Parm                    ZMDAY
     C                   Parm                    ZMDATE
      *
      ** If the program ends in error.
      *
     C     *IN15         Ifeq      '1'
     C     *LOCK         In        LDA
     C                   Z-Add     7             DBASE                            * * * * * * *
     C                   Movel     ZMDAY         DBKEY                            * DBERR 026 *
     C                   Movel     'ZM0060'      DBFILE                           * * * * * * *
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   Endif
     C                   Move      ZMDATE        @HRDT             6
      *
      * Initialise constant fields
      *
     C                   Move      *LOVAL        CR                1
     C                   Biton     '457'         CR
     C                   Move      *LOVAL        LF                1
     C                   Biton     '257'         LF
     C                   Movel     CR            CRLF              2
     C                   Move      LF            CRLF
     C                   Move      ':'           COLON1
     C                   Move      ':'           COLON2
      *
      * CRLF Control Character for message data records
      *
     C                   Move      CRLF          CTRC
      *
      * Set message Production Parameter
      *
     C                   Move      'N'           OPPARM            1
      *
      * Access SAR details to determine if EMU Settlement Details
      * switched on (CFT004)
      *
     C                   Call      'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT004'      @SARD             6
     C     SCSARD        Parm      SCSARD        DSFDY
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
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE                         ************
     C                   Movel     '*VERIFY'     DBKEY                          * DBERR 30 *
     C                   Z-Add     8             DBASE                          ************
     C                   Out       LDA
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
                                                                                              CSW201
     C                   EVAL      CSW201 = 'Y'                                               CSW201
     C                   EVAL      *IN27 = *ON                                                CSW201
                                                                                              CSW201
     C                   ELSE                                                                 CSW201
                                                                                              CSW201
     C                   EVAL      CSW201 = 'N'                                               CSW201
     C                   EVAL      *IN27 = *OFF                                               CSW201
                                                                                              CSW201
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
     C                   EVAL      DBASE = 23                                                 CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtnCode = *BLANKS                                         CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
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
      **                                                                                      CSC022
      ** Access SAR details to see if CSC022 is switched on                                   CSC022
      **                                                                                      CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *Blanks       PRtnCode                                     CSC022
     C                   Parm      '*VERIFY'     POption                                      CSC022
     C                   Parm      'CSC022'      PSard                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      ** Initialize CSC022 and Skip Commit Flags                                              CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
      **                                                                                      CSC022
     C                   If        PRtnCode = *BLANKS                                         CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MoveA     WDSJobs       WJobs                                        CSC022
      ** Verify if job running exists in array                                                CSC022
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                         CSC022
     C                   If        WArrPtr > 0                                                CSC022
     C                   Eval      WSkpComtRolbk = 'Y'                                        CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
     C                   Else                                                                 CSC022
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C                   If        PRtnCode <> '*NRF'                                         CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBPgm  = 'FT0657'                                          CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 900                                               CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
                                                                                              CSW215
      ** Check if SWIFT 2015 enhancement is installed                                         CSW215
                                                                                              CSW215
     C                   CALL      'SWIF2015'                                                 CSW215
     C                   PARM      *BLANKS       PRetCode                                     CSW215
                                                                                              CSW215
     C                   IF        PRetCode = 'CSW2015'                                       CSW215
     C                   EVAL      CSW215 = 'Y'                                               CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      CSW215 = 'N'                                               CSW215
     C                   ENDIF                                                                CSW215
      *
      * Clear multiple occurrence data structure
      *
     C**********         Z-add     95            Q                 2 0               189511
     C                   Z-add     5000          Q                 4 0         189511190200
      *
     C                   Endsr
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
     C     *PSSR         Begsr
      *
     C     @RUN          Ifeq      *BLANK
     C                   Move      'Y'           @RUN              1
     C                   Dump
     C                   Move      '1'           *IN78
     C                   Exsr      SRAU
     C                   Endif
      *
     C                   Move      *ON           *INU7
     C                   Move      *ON           *INU8
     C                   Move      *ON           *INLR
     C                   Return
     C                   Endsr
      *
     O/COPY FTCPYSRC,FTSWIFTRAN                                                 184509
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
