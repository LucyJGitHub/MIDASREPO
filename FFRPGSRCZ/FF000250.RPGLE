     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Closing Trades Input - Main')
/*OVR *: OVRDBF TRANSIN TRANS                                       : *
/*OVR *: OVRDBF TRSETIN TRSET                                       : *
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FF000250 - Closing Trades Input - Main                       *
      *                                                               *
      *  Component of: FFC000240 - Closing Trades Input               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CAAA03             Date 28Apr04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 215528             Date 21Mar03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CFF007  *CREATE    Date 13Feb01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CAAA03 - Webfacing Changes. (recompile)                      *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  215528 - System is associating a wrong premium amount.       *
      *  CFF007 - Futures and Options Enhancement for Private Banking *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    02         Insert                                          *
      *    03         Amend                                           *
      *    04         Delete                                          *
      *    05         Enquire                                         *
      *    06         DSPF/FF000240DF - Read fail                     *
      *    07         INVITE enabled                                  *
      *    10         Valid exit Indicator                            *
      *    11         Record Updated by Another Workstation           *
      *    11+12      Related Record Updated by Another Workstation   *
      *    11+16      Related Record Deleted by Another Workstation   *
      *    13         Insert/Amend main screen                        *
      *    14         Broker was present for requested transaction    *
      *    15         Customer was present for requested transaction  *
      *    18         General Error Indicator                         *
      *    19         Counterparty nostro numeric                     *
      *                                                               *
      *    Field Error Indicators                                     *
      *   ~~~~~~~~~~~~~~~~~~~~~~~~                                    *
      *    20         Action Code   (in FF000240)                     *
      *    21         Market Centre (in FF000240)                     *
      *                                                               *
      *    22         Transaction Reference                           *
      *    29         Value Date (NON-DISPLAY)                        *
      *    30         Closing Price                                   *
      *    31         Transaction Date                                *
      *    35         Number of Contracts to close                    *
      *    36         No selection in user query facility of Customer *
      *    37         No selection in user query facility of Broker   *
      *    38         Closure Reference                               *
      *    39         Value Date                                      *
      *                                                               *
      *    Broker Settlement details                                  *
      *   ~~~~~~~~~~~~~~~~~~~~~~~~                                    *
      *    40         Commission Code (Standard)                      *
      *    41         Commission Code (Same Day)                      *
      *    42         Commission Amount                               *
      *    43         Charge Code                                     *
      *    44         Charge Amount                                   *
      *    45         Settlement Branch                               *
      *    46         Settlement Type                                 *
      *    47         Settlement Account                              *
      *    48         For Account Of                                  *
      *    49         Counterparty Nostro                             *
      *                                                               *
      *    Customer Settlement details                                *
      *   ~~~~~~~~~~~~~~~~~~~~~~~~                                    *
      *    50         Commission Code (Standard)                      *
      *    51         Commission Code (Same Day)                      *
      *    52         Commission Amount                               *
      *    53         Charge Code                                     *
      *    54         Charge Amount                                   *
      *    55         Settlement Branch                               *
      *    56         Settlement Type                                 *
      *    57         Settlement Account                              *
      *    58         For Account Of                                  *
      *    59         Counterparty Nostro                             *
      *                                                               *
      *    General Settlement details                                 *
      *   ~~~~~~~~~~~~~~~~~~~~~~~~                                    *
      *    60         Settlement Type (SRVSettlTyp SR.)               *
      *    61         Settlement Account (SRVSettlAcc SR.)            *
      *    62         For Account Of (SRVForAccOf SR.)                *
      *    63         Counterparty Nostro (SRVCtrPtyNost SR.)         *
      *    64         Multi-Branch Ind. 'N'                           *
      *    65         EOC Processed Ind. 'N'                          *
      *    66         Don't execute SRVSettlAcc, SRVForAccOf &        *
      *    66                SRVCtrPtyNost SR's                       *
      *                                                               *
      *    67         Settlement Branch (SRVSettlAcc SR.)             *
      *    68         Value Date                                      *
      *    69         Counterparty nostro field contains customer     *
      *                 shortname                                     *
      *    70         LF/TABFF - ICD record - Read/Chain fail         *
      *    71         Other files - Read/Chain fail                   *
      *    72         Enquiry on a deleted record                     *
      *    73         Account Type is R (Retail)                      *
      *    74         Work indicator                                  *
      *    75         Subroutine is called from SRVCustSR.            *
      *    76         Subroutine is called from SRVBroker SR.         *
      *    77         Write to LF/TRANS fails                         *
      *    78         Transaction dates of Trade and Closing are same *
      *    79         Final Contracts on a Trade are being closed     *
      *                                                               *
      *    80-89      Reserved for Standard FF Subroutines            *
      *    90-99      Reserved for Standard MIDAS Subroutines         *
      *                                                               *
      *    KC         F3 - exit program                               *
      *    KL         F12 - return to previous screen                 *
      *                   also set on after valid detail screen entry *
      *    KJ         F10 - Delete (only valid for P0Action = 'D')    *
      *    KI         F9  - Return to initial screen (ACTION/MARKET)  *
      *                                                               *
      *    U7+U8      Database Errors                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFF000240DFCF   E             WORKSTN INFSR(*PSSR)
 
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     F                                     PREFIX(ACT)
 
     FACNUM     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMABF)
     F                                     PREFIX(ACM)
 
     FCLINT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLINTCAF)
     F                                     IGNORE(CLINTCCF)
     F                                     IGNORE(CLINTC1F)
     F                                     PREFIX(CLI)
 
     FSNAME     IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLINTCBF:SNAMECBF)
 
     FCHGCM     IF   E           K DISK    INFSR(*PSSR)
 
     FFOCLT     IF   E           K DISK    INFSR(*PSSR)
 
     FDEFLT     IF   E           K DISK    INFSR(*PSSR)
 
     FINTYP2    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(INTYPDF:INTYP2DF)
 
     FINTYP     IF   E           K DISK    INFSR(*PSSR)
 
     FTRSETIN   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRSETDF:TRSETINF)
     F                                     USROPN
 
     FTRANSIN   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRANSDF:TRANSINF)
     F                                     USROPN
 
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(TRANSDF:TRANS2DF)
 
     FTRANSA    UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
     FPOSTNC    UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
     FPOSTNK    UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
     FMEMOSM    UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
     FPRONOM    UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
     FCLOST     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
 
     FCLOST2    UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
     FTRSET     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
     FTRANS     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
     FFOPCC     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
     FFOPCK     UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
     FFFACMVD   O  A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     USROPN
 
     FREADVCL1  UF A E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
      * MIDAS RE Settled Transaction Index file                                               CRE020
                                                                                              CRE020
      *****************************************************************
      /EJECT
      ****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
 
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA
 
      ** Next available transaction number
     D MNATN           DS                  DTAARA
     D  TRAN                   1      5
     D  TRAN2                  1      5  0
 
      ** Next available Close Out number
     D NACON           DS             6    DTAARA
     D  NCON                   1      6  0
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Error Messages
     D WTbMsg          S             76    DIM(5) CTDATA PERRCD(1)
 
      ** Month short names
     D WTbMonth        S              3    DIM(12) CTDATA PERRCD(12)
 
     D                 DS
     D*WFFSETA**               1     12                                                       CGL029
     D WFFSETA                 1     18                                                       CGL029
     D**WFFSETA0106            1      6  0                                                    CSD027
     D  WFFSETA0106            1      6                                                       CSD027
     D**WFFSETA0710            7     10  0                                                    CGL029
     D**WFFSETA1112           11     12  0                                                    CGL029
     D  WFFSETA0710            7     16  0                                                    CGL029
     D  WFFSETA1112           17     18  0                                                    CGL029
 
      ** Work field data structure for settlement account (Screen)
     D*WDsCSLA**       DS            12                                                       CGL029
     D WDsCSLA         DS            18                                                       CGL029
     D  WDssCSLA0102           1      2
     D  WDssCSLA0106           1      6
     D  WDssCSLA0110           1     10
     D**WDssCSLA0312           3     12                                                       CGL029
     D**WDssCSLA0712           7     12                                                       CGL029
     D**WDssCSLA0710           7     10                                                       CGL029
     D**WDssCSLA1112          11     12                                                       CGL029
     D  WDssCSLA0312           3     18                                                       CGL029
     D  WDssCSLA0712           7     18                                                       CGL029
     D  WDssCSLA0710           7     16                                                       CGL029
     D  WDssCSLA1112          17     18                                                       CGL029
 
      ** Work field Data Structure for Settlement Account (File)
     D*WFSAC****       DS            15                                                       CGL029
     D**WFSLA***               1     12                                                       CGL029
     D WFSAC           DS            21                                                       CGL029
     D  WFSLA                  1     18                                                       CGL029
     D**WFFCustP               1      6  0                                                    CSD027
     D  WFFCustP               1      6                                                       CSD027
     D**FFACD2**               7     10  0                                                    CGL029
     D**WFFACSQ*              11     12  0                                                    CGL029
     D**FFBRC2**              13     15                                                       CGL029
     D  FFACD2                 7     16  0                                                    CGL029
     D  WFFACSQ               17     18  0                                                    CGL029
     D  FFBRC2                19     21                                                       CGL029
 
      **  Key to LF/POSTNC
     D PSTNCK          DS            34
     D  KBRCAC                 1      3
     D**KCBCDC**               4      9  0                                                    CSD027
     D  KCBCDC                 4      9                                                       CSD027
     D  KISTTC                10     14
     D  KYRNOC                15     16  0
     D  KMTHNC                17     18  0
     D  KPCALC                19     19
     D  KSTRPC                20     34  8
 
      ** Key to LF/POSTNK
     D PSTNKK          DS            30
     D  KBRCAK                 1      3
     D  KBOKCK                 4      5
     D  KISTTK                 6     10
     D  KYRNOK                11     12  0
     D  KMTHNK                13     14  0
     D  KPCALK                15     15
     D  KSTRPK                16     30  8
 
      **   Key for ICD records
     D ICDK            DS            12
     D  KICD1                  1      2
     D  KICD2                 11     12
 
      **  Key to LF/INTYP. Also, to redefine Instrument Type into
      **  Market Centre and Instrument Code.
     D ISTTK           DS             5
     D  KInsTyp                1      5
     D  KMRKT                  1      2
     D  KISTC                  3      5
 
     D WRNG            DS            45
      ** Data structure to store all CHRG/COMS lower range limit
     D  RNG                    1     45  0
     D                                     DIM(9)
     D  LR01                   1      5  0
     D  LR02                   6     10  0
     D  LR03                  11     15  0
     D  LR04                  16     20  0
     D  LR05                  21     25  0
     D  LR06                  26     30  0
     D  LR07                  31     35  0
     D  LR08                  36     40  0
     D  LR09                  41     45  0
 
     D WAMT            DS           117
      ** Data structure to store all CHRG/COMS amount
     D  AMT                    1    117  0
     D                                     DIM(9)
     D  CA01                   1     13  0
     D  CA02                  14     26  0
     D  CA03                  27     39  0
     D  CA04                  40     52  0
     D  CA05                  53     65  0
     D  CA06                  66     78  0
     D  CA07                  79     91  0
     D  CA08                  92    104  0
     D  CA09                 105    117  0
 
     D                 DS
     D WSBCM                   1      4
     D #4BCMC                  1      2
     D #4BCMS                  3      4
     D #4BCMA                  9     22
     D WSBCMA1                 9      9
     D WSBCMA2                10     22
     D #4BOCO                 31     40
     D WSBOCO1                31     31
     D WSBOCO9                32     40
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Third DS for access programs, very logn data structure
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** External data structure for bank ICD details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External data structure for FF Customer/Broker Details
     D SDFOCS        E DS                  EXTNAME(SDFOCSPD)
 
      ** External data structure for GL ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External data structure for RE ICD
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External data structure for FF ICD
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External data stucture for nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC3       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External data stucture for counterparty nostro details
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
 
      ** External data stucture for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data stucture for book details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
 
      ** External data stucture for customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
 
      ** External data stucture for portfolio ICD
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** External data stucture for MIDAS modules ICD
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External data stucture for account code details
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D  QQACC4       E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External data stucture for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Sharing of field values across all record formats.
      ** If possible, only use group of fields prefixed by 'WSc'.
     D                 DS
 
     D WScActn                28     28
     D WScMkt                 29     30
     D WScMktNme              31     50
     D WScTransRef            51     56
     D WScCloseTrade          57     62
     D WScErrLne2             63    139
     D  WArErr                63    142
     D                                     DIM(20)
     D WScCLSR               151    156
     D WScPutCall            157    157
     D WScSTRP               158    173
     D WScPTFR               174    177
     D WScTRTY               178    178
     D WScNUCO               179    183
     D WScTBLO               184    184
     D WScNOCO               185    189
     D WScCUSC               190    199
     D WScBOKC               200    201
     D WScBRCA               202    204
     D WScNCTE               205    209
     D WScEXPR               210    225
     D WScTRSD               226    231
     D WScVALD               232    237
     D WScTNAR               238    262
     D WSCCM                 263    266
     D  WScCCMC              263    264
     D  WScCCMS              265    266
     D WScCCMA               267    280
     D  WSCCMA1              267    267
     D  WSCCMA2              268    280
     D WScCCHC               281    282
     D WScCCHA               283    296
     D WScCSLT               297    298
     D WScCSBR               299    301
     D*WScCSLA**             302    313                                                       CGL029
     D WScCCPN               314    323
     D WScCFAO               324    333
     D WScCSLA               334    351                                                       CGL029
 
     D #1ACTN                 28     28
     D #1MRKT                 29     30
     D #1ERCD1                63    139
 
     D #2ACTN                 28     28
     D #2MKTN                 31     50
     D #2TNBR                 51     56
     D #2CLTR                 57     62
     D #2ERCD1                63    139
     D #2CLSR                151    156
 
     D #3ACTN                 28     28
     D #3MKTN                 31     50
     D #3TNBR                 51     56
     D #3ERCD1                63    139
 
     D #4ACTN                 28     28
     D #4MRKT                 29     30
     D #4MKTN                 31     50
     D #4TNBR                 51     56
     D #4ERCD1                63    139
     D #4CLSR                151    156
     D #4PCAL                157    157
     D #4STRP                158    173
     D #4PTFR                174    177
     D #4TRTY                178    178
     D #4NUCO                179    183
     D #4TBLO                184    184
     D #4NOCO                185    189
     D #4CUSC                190    199
     D #4BOKC                200    201
     D #4BRCA                202    204
     D #4NCTE                205    209
     D #4EXPR                210    225
     D #4TRSD                226    231
     D #4VALD                232    237
     D #4TNAR                238    262
     D #4CCMC                263    264
     D #4CCMS                265    266
     D #4CCMA                267    280
     D #4CCHC                281    282
     D #4CCHA                283    296
     D #4CSLT                297    298
     D #4CSBR                299    301
     D*#4CSLA***             302    313                                                       CGL029
     D #4CCPN                314    323
     D #4CFAO                324    333
     D #4CSLA                334    351                                                       CGL029
 
     D #5ACTN                 28     28
     D #5MKTN                 31     50
     D #5TNBR                 51     56
     D #5ERCD1                63    139
     D #5CLSR                151    156
     D #5PCAL                157    157
     D #5STRP                158    173
     D #5PTFR                174    177
     D #5TRTY                178    178
     D #5NUCO                179    183
     D #5TBLO                184    184
     D #5NOCO                185    189
     D #5CUSC                190    199
     D #5BOKC                200    201
     D #5BRCA                202    204
     D #5NCTE                205    209
     D #5EXPR                210    225
     D #5TRSD                226    231
     D #5VALD                232    237
     D #5TNAR                238    262
     D #5CCMC                263    264
     D #5CCMS                265    266
     D #5CCMA                267    280
     D #45CHC                281    282
     D #5CCHA                283    296
     D #5CSLT                297    298
     D #5CSBR                299    301
     D*#5CSLA***             302    313                                                       CGL029
     D #5CCPN                314    323
     D #5CFAO                324    333
     D #5CSLA                334    351                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameters
     D P0Action        S              1A
     D P0Mkt           S              2A
     D P0MktNme        S             20A
     D P0RunDateA      S              7A
     D P0RunDay        S              5P 0
     D P0DateFmt       S              1A
     D P0MultBrch      S              1A
     D P0BusiDate      S              5P 0
     D P0MktLocCcy     S              3A
     D P0MktLocCde     S              3A
 
      ** Parameter fields for standard FF* pgms
     D PFRtnCde10A     S             10A
     D PFScrPriceA     S             16A
     D PFFilPriceP     S             15P 8
     D PFTckDenomP     S              3P 0
     D PFTckValP       S             14P 5
     D PFMinPriceFlcP  S             15P 8
     D PFWrkDayP       S              5P 0
     D PFDateCde07A    S              7A
     D PFMonth020P     S              2P 0
     D PFYear020P      S              2P 0
     D PFMktCcyA       S              3A
     D PFMktLocA       S              3A
     D PFInsCcyA       S              3A
     D PFOtherCcyA     S              3A
     D PFDateFmtA      S              1A
     D PFTotValP       S             13P 0
     D PFContractP     S              5P 0
     D PFPriceP        S             15P 8
     D PFPremiumP      S             13P 0
     D PFInsTypS       S              1S 0
     D PFCntrctTypS    S              1S 0
     D PFCntngntAmtP   S             13P 0
     D PFSTRP          S                   LIKE(STRP)                                         215528
 
      ** Parameter fields for standard Z* pgms
     D PZAction01A     S              1A
     D PZErrNum010     S              1P 0
     D PZFld16A        S             16A
     D PZDecP          S              1P 0
     D PZDigP          S              2P 0
     D PZDayNumP       S              5P 0
     D PZDayNumP2      S              5P 0
     D PZDayFwdP       S              2P 0
     D PZDateFmtA      S              1A
     D PZDate060P      S              6P 0
     D PZDate06A       S              6A
     D PZDate07A       S              7A
     D PZRtnOK         S              1A
     D PZRtnErr        S              1A
     D PZRtnCde10A     S             10A
     D PZCcyA          S              3A
     D PZLocA          S              3A
     D PZHolIndA       S              1A
     D PZNxtTransP     S              5P 0
     D PZErr010P       S              1P 0
     D PZBranch03A     S              3A
 
      ** Parameter fields for access programs
     D PRtnCde07A      S              7A
     D POption07A      S              7A
     D PCcy03A         S              3A
     D*PAccCde04A      S              4A                                                      CGL029
     D PAccCde04A      S             10A                                                      CGL029
     D PAccSeq02A      S              2A
     D PNostro02A      S              2A
     D PBrch03A        S              3A
     D PNostroNme10A   S             10A
     D PPrimeNost01A   S              1A
     D PCust06A        S              6A
     D PCust10A        S             10A
     D PBookCde02A     S              2A
     D PChr008         S              8A
     D PSAR06A         S              6A
 
      ** Work fields
     D WRun            S              1A
     D WCtlDate        S              5P 0
     D WBrokeNameFlg   S              1A
     D WCustNameFlg    S              1A
     D WStrHisDte      S              5P 0
     D WChr004         S              4A
     D WChr005         S              5A
     D WChr006         S              6A
     D*WCust060P       S              6P 0                                                    CSD027
     D WCust060P       S              6A                                                      CSD027
     D WCust10A        S             10A
 
      ** Input/Ouput parameters of SR/SRFF*
     D WFFBRCA         S              3A
     D*WFFCBCD**       S              6P 0                                                    CSD027
     D WFFCBCD         S              6A                                                      CSD027
     D WFFBRKI         S              1A
     D WFFSETP         S              2P 0
     D WFFSETB         S              3A
     D WFFCCY          S              3A
     D WFFBRCB         S              3A
     D*WFFCNUM**       S              6P 0                                                    CSD027
     D WFFCNUM         S              6A                                                      CSD027
     D*WFFACOD**       S              4P 0                                                    CGL029
     D WFFACOD         S             10P 0                                                    CGL029
     D WFFNOSN         S              2P 0
     D WFFMIND         S              1A
     D WFFPIND         S              1A
     D WFFNOC          S              5P 0
     D WFFTKDM         S              3P 0
     D WFFMNPF         S             15P 8
     D WFFPOL          S             13P 0
     D WFFNTVL         S             13P 0
 
      ** Array index for WArErr
     D WEx             S              3P 0
 
      ** Validation error flag for SR/SRVIns1
     D WErVIns1        S              1A
 
      ** Validation error flag for SR/SRVIns2
     D WErVIns2        S              1A
 
      ** Validation error flag for SR/SRVAmDeEn1
     D WErVAmDeEn1     S              1A
 
      ** Error flag for SR/SROutTrans
     D WErOutTrans     S              1A
 
      ** Equals to 'Y' if PF/FOPCC was already opened
     D WOpnFOPCC       S              1A
 
      ** Equals to 'Y' if PF/FOPCK was already opened
     D WOpnFOPCK       S              1A
 
      ** Switchable Features Flags                                                            CRE020
     D CRE020          S              1A   INZ('N')                                           CRE020
                                                                                              CRE020
      ** Key Fields                                                                           CRE020
     D KAdvcRef        S             30A                                                      CRE020
     D KAdvcPGM        S             10A   INZ('FF000250')                                    CRE020
                                                                                              CRE020
      ** Parameters for System Values Access Object                                           CRE020
     D PRtCd           S              7A                                                      CRE020
     D PSValOpt        S             20A   INZ('ClosingTradesInput')                          CRE020
     D PSysVal         S            200A   INZ(' ')                                           CRE020
     D PSValOptB       S             20A   INZ(' ')                                           CRE020
     D PSysValB        S            200A   INZ(' ')                                           CRE020
                                                                                              CRE020
      *****************************************************************
      /EJECT
      *****************************************************************
 
     IINTYPDF
      **   Selected Instrument Type details
     I              CTAM                        FFCTAM
     I              CNTT                        FFCNTT
 
     IINTYP2DF
      **   Selected Instrument Type details
     I              RECI                        RECI2
     I              ISTT                        ISTT2
     I              ISTI                        ISTI2
     I              ISPT                        ISPT2
     I              ISCY                        ISCY2
     I              QOTC                        QOTC2
     I              TKDM                        TKDM2
     I              MNPF                        MNPF2
     I              TKVL                        TKVL2
     I              OTHC                        OTHC2
 
     ICHGCMDF
     I              PRFC                        PRFCC
 
     IFOPCCDF
      ** Customer/Broker Position Profit Centre
     I              RECI                        RECICC
     I              BRCA                        BRCACC
     I              CBCD                        CBCDCC
     I              ISTT                        ISTTCC
 
     IFOPCKDF
      ** Book Position Profit Centre
     I              RECI                        RECICK
     I              BRCA                        BRCACK
     I              BOKC                        BOKCCK
     I              ISTT                        ISTTCK
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: *INZSR is   ¦
      ** ¦ executed at program activation.                            ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
     C                   EXSR      SRInit
 
      ** Select screen to process
     C                   SELECT
 
      ** Insert
     C                   WHEN      P0Action = 'I'
     C                   EXSR      SRInsert
 
      ** Amend, Delete or Enquire
     C                   OTHER
     C                   EXSR      SRAmDeEn
     C                   ENDSL
 
      ** If F9 taken, blank out screen fields and also the
      ** action code parameter (used in FFC0211).
      *
     C     *INKI         IFEQ      *ON
     C                   MOVE      *BLANKS       P0Action
     C                   MOVE      *BLANKS       WScActn
     C                   MOVE      *BLANKS       WScMkt
 
      ** Close the overridden files.
     C                   CLOSE     TRANS
     C                   CLOSE     TRSET
     C                   CLOSE     TRANSIN
     C                   CLOSE     TRSETIN
     C                   CLOSE     MEMOSM
     C                   CLOSE     PRONOM
     C                   CLOSE     FFACMVD
     C                   CLOSE     POSTNC
     C                   CLOSE     POSTNK
     C                   CLOSE     CLOST
     C                   CLOSE     CLOST2
     C                   CLOSE     TRANSA
 
      ** Write Initial screen (to be processed by FF000240)
     C                   SETON                                        07
     C                   SETOFF                                       182238
     C                   WRITE     FF000240F1
     C                   SETOFF                                       07
      *
      **   Otherwise (ie: F3 taken), Set on LR and end program
     C                   ELSE
     C                   SETON                                        LR
     C                   ENDIF
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit     - Initial processing.                             *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   OPEN      TRANS
     C                   OPEN      TRSET
     C                   OPEN      TRANSIN
     C                   OPEN      TRSETIN
     C                   OPEN      MEMOSM
     C                   OPEN      PRONOM
     C                   OPEN      FFACMVD
     C                   OPEN      POSTNC
     C                   OPEN      POSTNK
     C                   OPEN      CLOST
     C                   OPEN      CLOST2
     C                   OPEN      TRANSA
 
      ** Determine Current Trading Date
      ** - Mkt Instr (= Market Business date)
     C     P0Mkt         IFNE      *BLANKS
     C                   Z-ADD     P0BusiDate    WCtlDate
     C                   ELSE
      ** - O.T.C. (= Run date)
     C                   Z-ADD     P0RunDay      WCtlDate
     C                   ENDIF
 
      ** Determine start of Historical Data Period
     C     WCtlDate      SUB       BXHSPR        WStrHisDte
 
      ** Screen fields (constant)
     C                   MOVE      P0Action      WScActn
     C                   MOVE      P0Mkt         WScMkt
     C                   MOVE      P0MktNme      WScMktNme
 
      ** - Action Code inds
     C     P0Action      COMP      'I'                                    02
     C     P0Action      COMP      'A'                                    03
     C     P0Action      COMP      'D'                                    04
     C     P0Action      COMP      'E'                                    05
     C                   SETOFF                                       13
 
      ** Initialise broker shortname neededand customer shortname
      ** needed flags
     C                   MOVE      'N'           WBrokeNameFlg
     C                   MOVE      'N'           WCustNameFlg
 
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert   - Insert processing.                              *
      *                                                               *
      *****************************************************************
     C     SRInsert      BEGSR
 
      ** Read secondary screen
     C                   READ      FF000240F2                             06
 
      ** Continue until F3 or F9 taken
     C     *INKC         DOWEQ     *OFF
     C     *INKI         ANDEQ     *OFF
 
      ** Validate Input
     C                   EXSR      SRVIns1
     C     WErVIns1      IFEQ      'Y'
     C                   MOVE      *ON           *IN18
     C                   ENDIF
 
     C     WErVIns1      IFEQ      'N'
 
      ** Access branch details for the branch internal customer
      ** of the transaction branch
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      BRCA          PBrch03A
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     PRtnCde07A    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     12            DBASE
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     PBrch03A      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      A8BICN        BICN
     C                   MOVE      A8LCCD        BLOC
 
      ** Output and process Detail screen
     C                   SETON                                        13
     C                   EXSR      SRInsDtl
 
      ** If F12 taken or valid entry on main screen, blank fields
     C     *INKL         IFEQ      '1'
 
     C                   MOVE      *BLANKS       WScTransRef
     C                   MOVE      *BLANKS       WScCLSR
     C     WNARR         IFNE      *BLANKS
     C                   MOVEL(P)  WNARR         WScErrLne2
     C                   SETON                                        18
     C                   MOVE      *BLANKS       WNARR
     C                   ELSE
     C                   SETOFF                                       18
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   Redisplay screen, check for Cmd keys on later screen
     C     *INKC         IFEQ      *OFF
     C     *INKI         ANDEQ     *OFF
     C                   EXFMT     FF000240F2
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmDeEn   - (Amend/Delete/Enquire) Secondary screen control *
      *                                                               *
      *****************************************************************
     C     SRAmDeEn      BEGSR
 
      ** Read secondary screen
     C                   READ      FF000240F3                             06
 
      ** Continue until F3 or F9 taken
     C     *INKC         DOWEQ     *OFF
     C     *INKI         ANDEQ     *OFF
 
      ** Validate Input
     C                   EXSR      SRVAmDeEn1
     C     WErVAmDeEn1   IFEQ      'Y'
     C                   MOVE      *ON           *IN18
     C                   ENDIF
 
     C     WErVAmDeEn1   IFEQ      'N'
 
      ** Access branch details for the branch internal customer
      ** of the transaction branch
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      BRCA          PBrch03A
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     PRtnCde07A    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     13            DBASE
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     PBrch03A      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      A8BICN        BICN
     C                   MOVE      A8LCCD        BLOC
 
      ** Proceed to full details screen
     C                   SETOFF                                       3865
     C                   SETOFF                                       3637
 
     C     CFF003        IFEQ      'Y'
     C                   SETOFF                                       39
     C                   ENDIF
 
     C                   SETOFF                                       68
     C                   MOVEA     '000000'      *IN(30)
     C                   MOVEA     '00000'       *IN(40)
     C                   MOVEA     '00000'       *IN(45)
     C                   MOVEA     '00000'       *IN(50)
     C                   MOVEA     '00000'       *IN(55)
 
     C     P0Action      IFEQ      'A'
     C                   SETON                                        13
     C                   ENDIF
 
     C     P0Mkt         IFNE      *BLANKS
     C                   EXSR      SRAmDeEnMkIn
     C                   ELSE
     C                   EXSR      SRAmDeEnOTC
     C                   ENDIF
 
      ** If F12 taken or valid entry on main screen, blank fields
     C     *INKL         IFEQ      '1'
     C                   MOVE      *BLANKS       WScTransRef
     C                   SETOFF                                       18
     C                   ENDIF
 
     C                   ENDIF
 
      ** Redisplay screen, check for Cmd keys on later screen
     C     *INKC         IFNE      '1'
     C     *INKI         ANDNE     '1'
     C                   EXSR      SRExecFmt0F3
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsDtl   - Insert Detail screen control                    *
      *                                                               *
      *****************************************************************
     C     SRInsDtl      BEGSR
 
      ** Access LF/INTYP record
     C                   MOVE      ISTT          KInsTyp
     C     KInsTyp       CHAIN     INTYP                              71
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     14            DBASE
     C                   MOVEL     'INTYP'       DBFILE
     C                   MOVEL     KInsTyp       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise Broker Settlement defaults where relevant
     C                   SETOFF                                       1415
     C*****BOCO*         IFNE      *ZEROS                                                     CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   SETON                                        14
     C                   EXSR      SRBrokeDft
     C                   ENDIF
 
      ** Initialise Customer Settlement defaults where relevant
     C*****CUSC*         IFNE      *ZEROS                                                     CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   SETON                                        15
     C                   EXSR      SRCustDft
     C                   ENDIF
 
      **   Display and process screen
     C     CFF003        IFEQ      'Y'
     C                   MOVEA     '0000'        *IN(36)
     C                   ELSE
     C                   MOVEA     '000'         *IN(36)
     C                   ENDIF
 
     C                   MOVE      '0'           *IN68
     C                   MOVEA     '000000'      *IN(30)
     C                   MOVEA     '00000'       *IN(40)
     C                   MOVEA     '00000'       *IN(45)
     C                   MOVEA     '00000'       *IN(50)
     C                   MOVEA     '00000'       *IN(55)
 
      ** - Market instrument
     C     P0Mkt         IFNE      *BLANKS
     C                   EXSR      SRInsMktInst
      ** - Over the counter
     C                   ELSE
     C                   EXSR      SRInsOTC
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsMktInst - Insert Market Instrument details processing   *
      *                                                               *
      *****************************************************************
     C     SRInsMktInst  BEGSR
 
      ** Initialise screen fields then Write/Read detail screen
     C                   EXSR      SRMktInst
     C                   EXSR      SRExecFmt04
 
      ** Continue until F3, F9 or F12 taken, or valid exit.
     C     *INKC         DOWEQ     *OFF
     C     *INKI         ANDEQ     *OFF
     C     *INKL         ANDEQ     *OFF
 
      **   Validate Input
     C     CFF003        IFEQ      'Y'
     C                   MOVEA     '0000'        *IN(36)
     C                   ELSE
     C                   MOVEA     '000'         *IN(36)
     C                   ENDIF
 
     C                   MOVE      '0'           *IN68
     C                   MOVEA     '000000'      *IN(30)
     C                   MOVEA     '00000'       *IN(40)
     C                   MOVEA     '00000'       *IN(45)
     C                   MOVEA     '00000'       *IN(50)
     C                   MOVEA     '00000'       *IN(55)
     C                   EXSR      SRVIns2
     C     WErVIns2      IFEQ      'Y'
     C                   MOVE      *ON           *IN18
     C                   ENDIF
 
      **   If valid attempt file updates
     C     WErVIns2      IFEQ      'N'
 
     C                   MOVE      '1'           *INKL
     C                   EXSR      SRUpdIns
 
      ** If Record/Related Record updated by another workstation
      ** - display screen, protected, with updated details
     C     *IN11         IFEQ      '1'
     C                   WRITE     FF000240F4
     C                   EXSR      SRExecFmt06
     C                   MOVE      '1'           *INKL
     C                   SETOFF                                       111216
     C                   ENDIF
 
      ** If invalid redisplay screen with error codes
     C                   ELSE
     C                   EXSR      SRExecFmt04
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsOTC   - Insert Over the counter details processing      *
      *                                                               *
      *****************************************************************
     C     SRInsOTC      BEGSR
 
      **   Initialise screen fields then Write/Read detail screen
     C                   EXSR      SRInitOTC
     C                   EXSR      SRExecFmt05
 
      **   Continue until F3, F9 or F12 taken, or valid exit.
     C     *INKC         DOWNE     '1'
     C     *INKI         ANDNE     '1'
     C     *INKL         ANDNE     '1'
 
      **   Validate Input
     C     CFF003        IFEQ      'Y'
     C                   MOVEA     '0000'        *IN(36)
     C                   ELSE
     C                   MOVEA     '000'         *IN(36)
     C                   ENDIF
 
     C                   MOVE      '0'           *IN68
     C                   MOVEA     '000000'      *IN(30)
     C                   MOVEA     '00000'       *IN(40)
     C                   MOVEA     '00000'       *IN(45)
     C                   MOVEA     '00000'       *IN(50)
     C                   MOVEA     '00000'       *IN(55)
     C                   EXSR      SRVIns2
     C     WErVIns2      IFEQ      'Y'
     C                   MOVE      *ON           *IN18
     C                   ENDIF
 
      **   If valid attempt file updates
     C     WErVIns2      IFEQ      'N'
 
     C                   MOVE      '1'           *INKL
     C                   EXSR      SRUpdIns
 
      **   If Record/Related Record updated by another workstation
      **   - display screen, protected, with updated details
     C     *IN11         IFEQ      '1'
     C                   WRITE     FF000240F5
     C                   EXSR      SRExecFmt06
     C                   MOVE      '1'           *INKL
     C                   SETOFF                                       111216
     C                   ENDIF
 
      **   If invalid redisplay screen with error codes
     C                   ELSE
     C                   EXSR      SRExecFmt05
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmDeEnMkIn - Amd/Del/Enq Market Instrument control         *
      *                                                               *
      *****************************************************************
     C     SRAmDeEnMkIn  BEGSR
 
      ** Initialise screen fields, then Write/Read detail screen
     C                   EXSR      SRMktInst
     C                   EXSR      SRExecFmt04
 
      **   No validation necessary if action is Enquire
     C     P0Action      IFEQ      'E'
 
     C                   MOVE      *BLANKS       WScTransRef
 
      **   Continue until F3, F9 or F12 taken, or valid exit.
     C                   ELSE
 
     C     *INKC         DOWNE     '1'
     C     *INKI         ANDNE     '1'
     C     *INKL         ANDNE     '1'
 
      ** Validate Input if action is Amend and End of Centre
      ** processing has not been carried out for the trade.
     C     P0Action      IFEQ      'A'
 
     C                   MOVEA     '00000'       *IN(40)
     C                   MOVEA     '00000'       *IN(45)
     C                   MOVEA     '00000'       *IN(50)
     C                   MOVEA     '00000'       *IN(55)
     C                   SETOFF                                       18
     C                   Z-ADD     0             WEx
     C                   MOVE      *BLANK        WArErr
 
     C     *IN65         IFEQ      '1'
 
     C*****CUSC*         IFNE      *ZERO                                                      CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL(P)  CUSC          PCust10A
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM                    PCust10A
     C                   PARM                    @KYST
     C     SDCUST        PARM      SDCUST        DSLDY
     C                   EXSR      SRVCust
     C                   ENDIF
 
     C*****BOCO*         IFNE      *ZERO                                                      CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   EXSR      SRVBroker
     C                   ENDIF
 
     C                   ENDIF
 
      **   Otherwise (ie - Delete), test for F10
     C                   ELSE
 
     C                   SETOFF                                       18
     C     *INKJ         IFNE      '1'
     C                   SETON                                        18
     C                   MOVEA     WTbMsg(1)     WScErrLne2
     C                   ENDIF
 
     C                   ENDIF
 
      **   If entry is valid, attempt file updates
     C     *IN18         IFEQ      '0'
     C                   MOVE      '1'           *INKL
 
     C     P0Action      IFEQ      'A'
     C                   EXSR      SRUpdAmd
     C                   ELSE
     C                   EXSR      SRUpdDel
     C                   ENDIF
 
      **   If Record/Related Record updated by another workstation
      **   - display screen, protected with updated details
     C     *IN11         IFEQ      '1'
     C                   WRITE     FF000240F4
     C                   EXSR      SRExecFmt06
     C                   MOVE      '1'           *INKL
     C                   SETOFF                                       111216
     C                   ENDIF
 
      **   If invalid, redisplay screen with error codes
     C                   ELSE
     C                   EXSR      SRExecFmt04
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmDeEnOTC- Amd/Del/Enq Over the counter Control            *
      *                                                               *
      *****************************************************************
     C     SRAmDeEnOTC   BEGSR
 
      **   Initialise screen fields then Write/Read detail screen
     C                   EXSR      SRInitOTC
     C                   EXSR      SRExecFmt05
 
      **   No validation necessary if action is Enquire
     C     P0Action      IFEQ      'E'
 
     C                   MOVE      *BLANKS       WScTransRef
 
      **   Continue until F3, F9 or F12 taken, or valid exit.
     C                   ELSE
 
     C     *INKC         DOWNE     '1'
     C     *INKI         ANDNE     '1'
     C     *INKL         ANDNE     '1'
 
      **   Validate Input if action is Amend and End of Centre
      **   processing has not been carried out for the trade.
     C     P0Action      IFEQ      'A'
     C                   MOVEA     '00000'       *IN(40)
     C                   MOVEA     '00000'       *IN(45)
     C                   MOVEA     '00000'       *IN(50)
     C                   MOVEA     '00000'       *IN(55)
     C                   SETOFF                                       18
     C                   Z-ADD     0             WEx
     C                   MOVE      *BLANK        WArErr
 
     C     *IN65         IFEQ      '1'
     C                   MOVEL(P)  CUSC          PCust10A
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM                    PCust10A
     C                   PARM                    @KYST
     C     SDCUST        PARM      SDCUST        DSLDY
     C                   EXSR      SRVCust
     C                   ENDIF
 
      **   Otherwise (ie - Delete), test for F10
     C                   ELSE
 
     C                   SETOFF                                       18
     C     *INKJ         IFNE      '1'
     C                   SETON                                        18
     C                   MOVEA     WTbMsg(1)     WScErrLne2
     C                   ENDIF
 
     C                   ENDIF
 
      **   If entry is valid, attempt file updates
     C     *IN18         IFEQ      '0'
     C                   MOVE      '1'           *INKL
 
     C     P0Action      IFEQ      'A'
     C                   EXSR      SRUpdAmd
     C                   ELSE
     C                   EXSR      SRUpdDel
     C                   ENDIF
 
      **   If Record/Related Record updated by another workstation
      **   - display screen, protected with updated details
     C     *IN11         IFEQ      '1'
     C                   WRITE     FF000240F5
     C                   EXSR      SRExecFmt06
     C                   MOVE      '1'           *INKL
     C                   SETOFF                                       111216
     C                   ENDIF
 
      **   If Invalid, redisplay screen with error codes
     C                   ELSE
     C                   EXSR      SRExecFmt05
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExecFmt03 - Screen input/output processing.                *
      *                                                               *
      *****************************************************************
     C     SRExecFmt0F3  BEGSR
 
     C     WEx           IFGT      *ZERO
     C                   MOVE      *ON           *IN18
     C                   ENDIF
     C                   EXFMT     FF000240F3
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExecFmt04 - Screen input/output processing.                *
      *                                                               *
      *****************************************************************
     C     SRExecFmt04   BEGSR
 
     C     WEx           IFGT      *ZERO
     C                   MOVE      *ON           *IN18
     C                   ENDIF
     C                   EXFMT     FF000240F4
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExecFmt05 - Screen input/output processing.                *
      *                                                               *
      *****************************************************************
     C     SRExecFmt05   BEGSR
 
     C     WEx           IFGT      *ZERO
     C                   MOVE      *ON           *IN18
     C                   ENDIF
     C                   EXFMT     FF000240F5
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExecFmt06 - Screen input/output processing.                *
      *                                                               *
      *****************************************************************
     C     SRExecFmt06   BEGSR
 
     C     WEx           IFGT      *ZERO
     C                   MOVE      *ON           *IN18
     C                   ENDIF
     C                   EXFMT     FF000240F6
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBrokeDft - Broker defaults.                                *
      *                                                               *
      *****************************************************************
     C     SRBrokeDft    BEGSR
 
      ** Access settlement defaults from LF/FOCLT
     C                   MOVEL     BOCO          KCBCD
     C     KCBCD         CHAIN     FOCLT                              71
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     15            DBASE
     C                   MOVEL     'FOCLT'       DBFILE
     C                   MOVEL     KCBCD         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      PSCI          PSCIS             1
     C                   MOVE      SETP          SETPS             2 0
     C**********         MOVE      SETA          SETAS            12                          CGL029
     C                   MOVE      SETA          SETAS            18                          CGL029
     C                   MOVE      SEBR          SEBRS             3
     C                   MOVE      FACO          FACOS            10
     C                   MOVE      CNOS          CNOSS             8
 
      ** Access Broker defaults from LF/DEFLT
     C                   MOVE      ISTT          ISTTK
     C     KDEFLT        CHAIN     DEFLT                              71
 
      ** If LF/DEFLT record doesn't exist get Charge/Commission
      ** codes from LF/INTYP
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
 
     C                   MOVE      BCPT          WBCPT             1
 
     C     BCPT          IFNE      ' '
     C                   MOVE      BCMC          #4BCMC
     C                   MOVE      BCMS          #4BCMS
     C                   ENDIF
 
     C     TRTY          IFEQ      'P'
 
     C     BCGP          IFNE      00
     C                   MOVE      BCGP          #4BCHC
     C                   ENDIF
 
     C                   ELSE
 
     C     BCGS          IFNE      00
     C                   MOVE      BCGS          #4BCHC
     C                   ENDIF
 
     C                   ENDIF
 
      ** If LF/DEFLT record exists
      **
      ** Commission details - (from LF/DEFLT)
     C                   ELSE
 
     C     CPAT          IFNE      *BLANK
     C                   MOVE      CPAT          WBCPT
     C                   MOVE      CMCD          #4BCMC
     C                   MOVE      CMSD          #4BCMS
      ** (from LF/INTYP)
     C                   ELSE
     C                   MOVE      BCPT          WBCPT
     C     BCPT          IFNE      ' '
     C                   MOVE      BCMC          #4BCMC
     C                   MOVE      BCMS          #4BCMS
     C                   ENDIF
     C                   ENDIF
 
      ** - 2. Charge code (Purchase)
     C     TRTY          IFEQ      'P'
 
      ** (from LF/DEFLT)
     C     CGEP          IFNE      00
     C                   MOVE      CGEP          #4BCHC
      ** (from LF/INTYP)
     C                   ELSE
     C     BCGP          IFNE      00
     C                   MOVE      BCGP          #4BCHC
     C                   ENDIF
     C                   ENDIF
 
      ** - 3. Charge code (Sale)
      **
      ** (from LF/DEFLT)
     C                   ELSE
 
     C     CGES          IFNE      00
     C                   MOVE      CGES          #4BCHC
      ** (from LF/INTYP)
     C                   ELSE
     C     BCGS          IFNE      00
     C                   MOVE      BCGS          #4BCHC
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Settlement Defaults
     C     *IN71         IFEQ      *OFF
     C     RECI          ANDEQ     'D'
     C     SETP          ANDNE     00
 
      ** - from LF/DEFLT
     C                   MOVE      SETP          #4BSLT
     C                   MOVE      SETA          #4BSLA
     C     P0MultBrch    IFEQ      'Y'
     C                   MOVE      SEBR          #4BSBR
     C                   ELSE
     C                   MOVE      *BLANK        #4BSBR
     C                   ENDIF
     C                   MOVE      FACO          #4BFAO
     C                   MOVEL     CNOS          #4BCPN
 
      ** - from LF/FOCLT
     C                   ELSE
 
     C                   MOVE      SETPS         #4BSLT
     C                   MOVE      SETAS         #4BSLA
     C     P0MultBrch    IFEQ      'Y'
     C                   MOVE      SEBRS         #4BSBR
     C                   ELSE
     C                   MOVE      *BLANK        #4BSBR
     C                   ENDIF
     C                   MOVE      FACOS         #4BFAO
     C                   MOVEL     CNOSS         #4BCPN
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCustDft  - Customer defaults.                              *
      *                                                               *
      *****************************************************************
     C     SRCustDft     BEGSR
 
      ** Access Settlement defaults from LF/FOCLT
     C                   MOVEL     CUSC          KCBCD
     C     KCBCD         CHAIN     FOCLT                              71
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     16            DBASE
     C                   MOVEL     'FOCLT'       DBFILE
     C                   MOVEL     KCBCD         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      SETP          SETPS             2 0
     C**********         MOVE      SETA          SETAS            12                          CGL029
     C                   MOVE      SETA          SETAS                                        CGL029
     C                   MOVE      SEBR          SEBRS             3
     C                   MOVE      FACO          FACOS            10
     C                   MOVE      CNOS          CNOSS             8
 
      ** Access Customer defaults from LF/DEFLT
      ** - no defaults exist for O.T.C.'s
     C                   MOVE      *OFF          *IN71
     C                   MOVE      ISTT          ISTTK
     C     P0Mkt         IFNE      *BLANKS
     C     KDEFLT        CHAIN     DEFLT                              71
     C                   ELSE
     C                   MOVE      *ON           *IN71
     C                   ENDIF
 
      ** If LF/DEFLT record doesn't exist get Charge/Commission
      ** codes from LF/INTYP
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
 
     C                   MOVE      CCPT          WCCPT             1
 
     C     CCPT          IFNE      *BLANK
     C                   MOVE      CCMC          WScCCMC
     C                   MOVE      CCMS          WScCCMS
     C                   ENDIF
 
     C     TRTY          IFEQ      'P'
     C     CCGP          IFNE      00
     C                   MOVE      CCGP          WScCCHC
     C                   ENDIF
     C                   ELSE
     C     CCGS          IFNE      00
     C                   MOVE      CCGS          WScCCHC
     C                   ENDIF
     C                   ENDIF
 
      ** If LF/DEFLT record exists
      **
      ** Commission details - (from LF/DEFLT)
     C                   ELSE
 
     C     CPAT          IFNE      *BLANK
     C                   MOVE      CPAT          WCCPT
     C                   MOVE      CMCD          WScCCMC
     C                   MOVE      CMSD          WScCCMS
      **    (from LF/INTYP)
     C                   ELSE
     C                   MOVE      CCPT          WCCPT
     C     CCPT          IFNE      ' '
     C                   MOVE      CCMC          WScCCMC
     C                   MOVE      CCMS          WScCCMS
     C                   ENDIF
     C                   ENDIF
 
      ** - 2. Charge code (Purchase)
     C     TRTY          IFEQ      'P'
 
      **    (from LF/DEFLT)
     C     CGEP          IFNE      00
     C                   MOVE      CGEP          WScCCHC
      **    (from LF/INTYP)
     C                   ELSE
     C     CCGP          IFNE      00
     C                   MOVE      CCGP          WScCCHC
     C                   ENDIF
     C                   ENDIF
 
      ** - 3. Charge code (Sale)
      **
      ** (from LF/DEFLT)
      *
     C                   ELSE
 
     C     CGES          IFNE      00
     C                   MOVE      CGES          WScCCHC
      **    (from LF/INTYP)
     C                   ELSE
     C     CCGS          IFNE      00
     C                   MOVE      CCGS          WScCCHC
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   Settlement Defaults
     C     *IN71         IFEQ      *OFF
     C     RECI          ANDEQ     'D'
     C     SETP          ANDNE     00
 
      **   - from LF/DEFLT
     C                   MOVE      SETP          WScCSLT
     C                   MOVE      SETA          WScCSLA
 
     C     P0MultBrch    IFEQ      'Y'
     C                   MOVE      SEBR          WScCSBR
     C                   ELSE
     C                   MOVE      *BLANK        WScCSBR
     C                   ENDIF
 
     C                   MOVE      FACO          WScCFAO
     C                   MOVEL     CNOS          WScCCPN
 
      **   - from LF/FOCLT
     C                   ELSE
 
     C                   MOVE      SETPS         WScCSLT
     C                   MOVE      SETAS         WScCSLA
 
     C     P0MultBrch    IFEQ      'Y'
     C                   MOVE      SEBRS         WScCSBR
     C                   ELSE
     C                   MOVE      *BLANK        WScCSBR
     C                   ENDIF
 
     C                   MOVE      FACOS         WScCFAO
     C                   MOVEL     CNOSS         WScCCPN
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMktInst  - Initialise Screen details  (Market Inst.)       *
      *                                                               *
      *****************************************************************
     C     SRMktInst     BEGSR
 
      ** Determine Instrument Currency dec. places
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      ISCY          PCcy03A
     C     SDCURR        PARM      SDCURR        DSSDY
     C     PRtnCde07A    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     17            DBASE
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     ISCY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     FTRF          IFNE      *BLANKS
 
      ** Access underlying Instrument to discover MNPF and TKDM
     C                   MOVE      FTRF          KISTC
     C     KInsTyp       CHAIN     INTYP2                             71
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI2         ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     18            DBASE
     C                   MOVEL     'INTYP'       DBFILE
     C                   MOVEL     KInsTyp       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Save fields for later Price validation
     C                   Z-ADD     TKDM2         TKDMX             3 0
     C                   Z-ADD     TKVL2         TKVLX            11 5
     C     *LIKE         DEFINE    MNPF          MNPFX
     C                   Z-ADD     MNPF2         MNPFX
     C                   MOVE      ISTT          KISTC
 
     C                   ELSE
 
     C                   Z-ADD     TKDM          TKDMX
     C                   Z-ADD     TKVL          TKVLX
     C                   Z-ADD     MNPF          MNPFX
     C                   MOVE      ISTT          KISTC
 
     C                   ENDIF
 
      ** Set up fields for display for Amend/Delete/Enquire or Record
      ** Updated by another workstation.
     C     *IN02         IFEQ      '0'
     C     *IN11         OREQ      '1'
     C                   EXSR      SRMAmDeEnIN
     C                   ENDIF
 
      ** Copy fields from LF/TRANS for all action codes
     C                   MOVE      P0Mkt         WScMkt
     C                   MOVE      ISTT          #4ISTC
     C                   MOVE      WTbMonth(MTHN)#4MTHN
     C                   MOVE      YRNO          #4YRNO
     C                   MOVE      PCAL          WScPutCall
     C                   MOVE      TRTY          WScTRTY
 
     C*****BOCO*         IFNE      *ZEROS                                                     CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL(P)  BOCO          #4BOCO
     C                   ELSE
     C                   MOVE      *BLANKS       #4BOCO
     C                   ENDIF
 
     C*****CUSC*         IFNE      *ZEROS                                                     CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL(P)  CUSC          WScCUSC
     C                   ELSE
     C                   MOVE      *BLANKS       WScCUSC
     C                   ENDIF
 
     C                   MOVE      BOKC          WScBOKC
 
     C                   Z-ADD     0             PZDecP
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      NUCO          PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScNUCO
 
     C                   MOVE      TBLO          WScTBLO
 
     C                   MOVEL     *BLANKS       PZFld16A
     C                   MOVE      NOCO          PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScNOCO
 
     C                   MOVE      BRCA          WScBRCA
     C     *LIKE         DEFINE    COPR          COPRS
     C                   Z-ADD     COPR          COPRS
 
      ** Strike Price must be formatted via FFPRCS SR.
     C     *LIKE         DEFINE    STRP          WSTRP
     C                   Z-ADD     STRP          WSTRP
     C                   Z-ADD     STRP          PFFilPriceP
     C                   Z-ADD     TKDMX         PFTckDenomP
     C                   Z-ADD     MNPFX         PFMinPriceFlcP
     C                   CALLB     'FFPRCS'
     C                   PARM      *BLANKS       PFRtnCde10A
     C                   PARM      *BLANKS       PFScrPriceA
     C                   PARM                    PFFilPriceP
     C                   PARM                    PFTckDenomP
     C                   PARM                    PFMinPriceFlcP
     C     STRP          IFNE      *ZEROS
     C                   MOVE      PFScrPriceA   WScSTRP
     C                   ELSE
     C                   MOVE      *BLANKS       WScSTRP
     C                   ENDIF
     C     *LIKE         DEFINE    STRP          STRPS
     C                   Z-ADD     STRP          STRPS
 
      ** Portfolio management module is installed
      ** If Bank Portfolios are supported, treat as if PM off
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDNE     'B'
 
      ** Portfolio reference is not equal blanks
     C     PTFR          IFNE      *BLANKS
     C     PTFR          IFNE      '9997'
     C                   MOVEL     PTFR          WScPTFR
     C                   ELSE
     C                   MOVEL     FCR997        WScPTFR
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     *BLANKS       WScPTFR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAmDeEnIN - Initialise Screen details                      *
      *                (Mkt Inst. - A/D/E/Rec Upd by another Wkstn)   *
      *                                                               *
      *****************************************************************
     C     SRMAmDeEnIN   BEGSR
 
      ** Discover if 'End of Centre Processed ind.' = 'N'
     C     ECPI          IFEQ      'N'
     C                   SETON                                        65
     C                   ENDIF
 
      ** Set up fields which come from the LF/TRANS record for the
      ** Closing , this record has already been accessed.
     C                   Z-ADD     0             PZDecP
     C                   MOVEL     *BLANKS       PZFld16A
     C                   MOVE      NUCO          PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
 
     C                   MOVE      PZFld16A      WScNCTE
     C                   MOVE      NUCO          WNCTE
     C                   MOVE      TRSD          OTRSD
     C                   MOVE      TRSD          PZDayNumP
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNumP
     C                   PARM      BJDFIN        PZDateFmtA
     C                   PARM                    PZDate060P
     C                   PARM                    PZDate07A
 
     C                   MOVE      PZDate060P    WScTRSD
     C                   MOVE      VALD          PZDayNumP
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNumP
     C                   PARM      BJDFIN        PZDateFmtA
     C                   PARM                    PZDate060P
     C                   PARM                    PZDate07A
 
     C                   MOVE      PZDate060P    WScVALD
     C                   MOVE      TNAR          WScTNAR
 
      ** Closing  Price must be formatted
     C                   Z-ADD     COPR          PFFilPriceP
     C                   Z-ADD     TKDMX         PFTckDenomP
     C                   Z-ADD     MNPFX         PFMinPriceFlcP
     C                   CALLB     'FFPRCS'
     C                   PARM      *BLANKS       PFRtnCde10A
     C                   PARM      *BLANKS       PFScrPriceA
     C                   PARM                    PFFilPriceP
     C                   PARM                    PFTckDenomP
     C                   PARM                    PFMinPriceFlcP
 
     C                   MOVE      PFScrPriceA   WScEXPR
     C                   MOVE      CLSR          WScCLSR
 
      ** Access TRSET record
     C     KTrans        CHAIN     TRSETIN                            71
     C     *IN71         IFEQ      '1'
     C     *IN71         OREQ      *OFF
     C     *IN72         ANDEQ     *OFF
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     19            DBASE
     C                   MOVEL     'TRSET'       DBFILE
     C                   MOVEL     KTrans        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Initialise Broker Settlement Details
     C                   Z-ADD     A6NBDP        PZDecP
 
     C     *IN14         IFEQ      *ON
 
      ** Commission codes are taken from file if non-zero
     C     BCMC          IFNE      0
     C                   MOVE      BCMC          #4BCMC
     C                   ENDIF
     C     BCMS          IFNE      0
     C                   MOVE      BCMS          #4BCMS
     C                   ENDIF
 
      ** Commission amount is taken from file if non-zero
     C     BCMA          IFEQ      0
      ** If it is zero and Commission pattern is 'A', amount is 'A'
     C     BCPT          IFEQ      'A'
     C                   MOVEL     'A'           #4BCMA
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     *BLANKS       PZfld16A
     C                   MOVE      BCMA          PZfld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      #4BCMA
     C                   ENDIF
 
      ** Charge code is taken from file if non-zero
     C     BCHC          IFNE      0
     C                   MOVE      BCHC          #4BCHC
     C                   ENDIF
 
      ** Charge amount is taken from file if non-zero
     C     BCHA          IFNE      0
     C                   MOVEL     *BLANKS       PZFld16A
     C                   MOVE      BCHA          PZfld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      #4BCHA
     C                   ENDIF
 
      ** Settlement type is taken from the file
     C                   MOVE      BSLT          #4BSLT
     C                   MOVE      BSLT          BSLTS             2 0
     C**********         MOVE      BSLA          BSLAS            12                          CGL029
     C                   MOVE      BSLA          BSLAS            18                          CGL029
     C                   MOVE      BSBR          BSBRS             3
 
      **   Settlement account is taken from the file unless settlement
      **   type is 04,06 or 15. In these cases it is blank
     C     BSLT          IFEQ      04
     C     BSLT          OREQ      06
     C     BSLT          OREQ      15
     C                   MOVE      *BLANK        #4BSLA
     C                   ELSE
     C                   MOVE      BSLA          #4BSLA
     C                   ENDIF
 
      ** Settlement branch are taken from the file unless settlement
      ** type is 04, 06, 15 or is not multibranch.  In these cases
      ** it is blank
     C     P0MultBrch    IFNE      'Y'
     C     BSLT          OREQ      04
     C     BSLT          OREQ      06
     C     BSLT          OREQ      15
     C                   MOVE      *BLANK        #4BSBR
     C                   ELSE
     C                   MOVE      BSBR          #4BSBR
     C                   ENDIF
 
      ** For Account of and Counterparty come from file
     C                   MOVE      BFAO          #4BFAO
     C                   MOVEL     BCPN          #4BCPN
 
     C                   ENDIF
 
      ** Initialise Customer Settlement Details
     C     *IN15         IFEQ      '1'
 
      ** Commission codes are taken from file if non-zero
     C     CCMC          IFNE      0
     C                   MOVE      CCMC          WScCCMC
     C                   ENDIF
     C     CCMS          IFNE      0
     C                   MOVE      CCMS          WScCCMS
     C                   ENDIF
 
      **   Commission amount is taken from file if non-zero
     C     CCMA          IFEQ      0
      **   If it is zero and Commission pattern is 'A', amount is 'A'
     C     CCPT          IFEQ      'A'
     C                   MOVEL     'A'           WScCCMA
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      CCMA          PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScCCMA
     C                   ENDIF
 
      **   Charge code is taken from file if non-zero
     C     CCHC          IFNE      0
     C                   MOVE      CCHC          WScCCHC
     C                   ENDIF
 
      ** Charge amount is taken from file if non-zero
     C     CCHA          IFNE      0
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      CCHA          PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScCCHA
     C                   ENDIF
 
      ** Settlement type is taken from the file
     C                   MOVE      CSLT          WScCSLT
     C                   MOVE      CSLT          CSLTS             2 0
     C**********         MOVE      CSLA          CSLAS            12                          CGL029
     C                   MOVE      CSLA          CSLAS            18                          CGL029
     C                   MOVE      BRSC          BRSCS             3
 
      ** Settlement account is taken from the file unless settlement
      ** type is 04,06 or 15. In these cases it is blank
     C     CSLT          IFEQ      04
     C     CSLT          OREQ      06
     C     CSLT          OREQ      15
     C                   MOVE      *BLANK        WScCSLA
     C                   ELSE
     C                   MOVE      CSLA          WScCSLA
     C                   ENDIF
 
      ** Settlement branch are taken from the file unless settlement
      ** type is 04, 06, 15 or is not multibranch.  In these cases
      ** it is blank
     C     P0MultBrch    IFNE      'Y'
     C     CSLT          OREQ      04
     C     CSLT          OREQ      06
     C     CSLT          OREQ      15
     C                   MOVE      *BLANK        WScCSBR
     C                   ELSE
     C                   MOVE      BRSC          WScCSBR
     C                   ENDIF
 
      ** For Account of and Counterparty come from file
     C                   MOVE      CFAO          WScCFAO
     C                   MOVEL     CCPN          WScCCPN
 
     C                   ENDIF
 
      ** Access LF/TRANS record for Trade, using closure reference
      ** from Closing  record.
     C     *IN11         IFEQ      '0'
     C     CLSR          ORNE      *ZEROS
 
     C                   MOVE      CLSR          KTrans
     C     KTrans        CHAIN     TRANSIN                            71
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     20            DBASE
     C                   MOVEL     'TRANS'       DBFILE
     C                   MOVEL     KTrans        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Broker, Customer and Book
     C                   MOVEL     BOCO          #4BOCO
     C*****BOCO*         IFEQ      *ZEROS                                                     CSD027
     C     BOCO          IFEQ      *BLANKS                                                    CSD027
     C                   MOVE      *BLANKS       #4BOCO
     C                   ENDIF
 
     C                   MOVEL     CUSC          WScCUSC
     C*****CUSC*         IFEQ      *ZEROS                                                     CSD027
     C     CUSC          IFEQ      *BLANKS                                                    CSD027
     C                   MOVE      *BLANKS       WScCUSC
     C                   ENDIF
     C                   MOVE      BOKC          WScBOKC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitOTC  - Initialise Screen details (O.T.C.)              *
      *                                                               *
      *****************************************************************
     C     SRInitOTC     BEGSR
 
      **   Determine Instrument Currency dec. places
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      ISCY          PCcy03A
     C     SDCURR        PARM      SDCURR        DSSDY
     C     PRtnCde07A    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     21            DBASE
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     ISCY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **   Save fields for later Price validation
     C                   Z-ADD     TKDM          TKDMX             3 0
     C                   Z-ADD     TKVL          TKVLX            11 5
      ** MNPFX Previously Defined.
     C                   Z-ADD     MNPF          MNPFX
 
      **   Set up fields for display for Amend/Delete/Enquire or Record
      **   Updated by another workstation.
     C     *IN02         IFEQ      '0'
     C     *IN11         OREQ      '1'
     C                   EXSR      SRInitAmDeEn
     C                   ENDIF
 
      **   Copy fields from LF/TRANS for all action codes
     C                   MOVE      ISTT          #5ISTT
     C                   MOVE      PCAL          WScPutCall
     C                   MOVE      TRTY          WScTRTY
 
     C*****BOCO*         IFNE      *ZEROS                                                     CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      BOCO          #4BOCO
     C                   ELSE
     C                   MOVE      *BLANKS       #4BOCO
     C                   ENDIF
 
     C*****CUSC*         IFNE      *ZEROS                                                     CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL(P)  CUSC          WScCUSC
     C                   ELSE
     C                   MOVE      *BLANKS       WScCUSC
     C                   ENDIF
     C                   MOVE      BOKC          WScBOKC
 
     C                   Z-ADD     0             PZDecP
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      NUCO          PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScNUCO
 
     C                   MOVE      TBLO          WScTBLO
 
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      NOCO          PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScNOCO
 
     C                   MOVE      BRCA          WScBRCA
     C                   Z-ADD     COPR          COPRS
 
      **   Strike Price must be formatted via FFPRCS
     C                   Z-ADD     STRP          WSTRP
     C                   Z-ADD     STRP          PFFilPriceP
     C                   Z-ADD     TKDMX         PFTckDenomP
     C                   Z-ADD     MNPFX         PFMinPriceFlcP
     C                   CALLB     'FFPRCS'
     C                   PARM      *BLANKS       PFRtnCde10A
     C                   PARM      *BLANKS       PFScrPriceA
     C                   PARM                    PFFilPriceP
     C                   PARM                    PFTckDenomP
     C                   PARM                    PFMinPriceFlcP
     C                   MOVE      PFScrPriceA   WScSTRP
     C                   Z-ADD     STRP          STRPS
 
      **   Portfolio management module is installed
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDNE     'B'
 
      **   Portfolio reference is not equal blanks
     C     PTFR          IFNE      *BLANKS
     C     PTFR          IFNE      '9997'
     C                   MOVEL     PTFR          WScPTFR
     C                   ELSE
     C                   MOVEL     FCR997        WScPTFR
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     *BLANKS       WScPTFR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitAmDeEn- Initialise Screen details                      *
      *               (O.T.C. - A/D/E/Rec Upd by another Wkstn)       *
      *                                                               *
      *****************************************************************
     C     SRInitAmDeEn  BEGSR
 
      **   Discover if 'End of Centre Processed ind.' = 'N'
     C     ECPI          IFEQ      'N'
     C                   SETON                                        65
     C                   ENDIF
 
      **   Set up fields which come from the LF/TRANS record for the
      **   Closing , this record has already been accessed.
     C                   Z-ADD     0             PZDecP
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      NUCO          PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScNCTE
 
     C                   MOVE      NUCO          WNCTE
     C                   MOVE      TRSD          OTRSD
     C                   MOVE      TRSD          PZDayNumP
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNumP
     C                   PARM      BJDFIN        PZDateFmtA
     C                   PARM                    PZDate060P
     C                   PARM                    PZDate07A
     C                   MOVE      PZDate060P    WScTRSD
 
     C     CFF003        IFEQ      'Y'
     C                   MOVE      VALD          OVALD
     C                   MOVE      VALD          PZDayNumP
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNumP
     C                   PARM      BJDFIN        PZDateFmtA
     C                   PARM                    PZDate060P
     C                   PARM                    PZDate07A
     C                   MOVE      PZDate060P    WScVALD
     C                   ENDIF
 
     C                   MOVE      TNAR          WScTNAR
 
      **   Closing  Price must be formatted via FFPRCS
     C                   Z-ADD     COPR          PFFilPriceP
     C                   Z-ADD     TKDMX         PFTckDenomP
     C                   Z-ADD     MNPFX         PFMinPriceFlcP
     C                   CALLB     'FFPRCS'
     C                   PARM      *BLANKS       PFRtnCde10A
     C                   PARM      *BLANKS       PFScrPriceA
     C                   PARM                    PFFilPriceP
     C                   PARM                    PFTckDenomP
     C                   PARM                    PFMinPriceFlcP
     C                   MOVE      PFScrPriceA   WScEXPR
     C                   MOVE      CLSR          WScCLSR
 
      **   Access TRSET record
     C     KTrans        CHAIN     TRSETIN                            71
     C     *IN71         IFEQ      '1'
     C     *IN71         OREQ      *OFF
     C     *IN72         ANDEQ     *OFF
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     22            DBASE
     C                   MOVEL     'TRSET'       DBFILE
     C                   MOVEL     KTrans        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **   Initialise Customer Settlement Details
     C                   Z-ADD     A6NBDP        PZDecP            1 0
 
      **   Commission codes are taken from file if non-zero
     C     CCMC          IFNE      0
     C                   MOVE      CCMC          WScCCMC
     C                   ENDIF
 
     C     CCMS          IFNE      0
     C                   MOVE      CCMS          WScCCMS
     C                   ENDIF
 
      **   Commission amount is taken from file if non-zero
     C     CCMA          IFEQ      0
      **   If it is zero and Commission pattern is 'A', amount is 'A'
     C     CCPT          IFEQ      'A'
     C                   MOVEL     'A'           WScCCMA
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      CCMA          PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScCCMA
     C                   ENDIF
 
      **   Charge code is taken from file if non-zero
     C     CCHC          IFNE      0
     C                   MOVE      CCHC          WScCCHC
     C                   ENDIF
 
      **   Charge amount is taken from file if non-zero
     C     CCHA          IFNE      0
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      CCHA          PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScCCHA
     C                   ENDIF
 
      **   Settlement type is taken from the file
     C                   MOVE      CSLT          WScCSLT
     C                   MOVE      CSLT          CSLTS
     C                   MOVE      CSLA          CSLAS
     C                   MOVE      BRSC          BRSCS
 
      **   Settlement account is taken from the file unless settlement
      **   type is 04,06 or 15. In these cases it is blank
     C     CSLT          IFEQ      04
     C     CSLT          OREQ      06
     C     CSLT          OREQ      15
     C                   MOVE      *BLANK        WScCSLA
     C                   ELSE
     C                   MOVE      CSLA          WScCSLA
     C                   ENDIF
 
      **   Settlement branch are taken from the file unless settlement
      **   type is 04, 06, 15 or is not multibranch.  In these cases
      **   it is blank
     C     P0MultBrch    IFNE      'Y'
     C     CSLT          OREQ      04
     C     CSLT          OREQ      06
     C     CSLT          OREQ      15
     C                   MOVE      *BLANK        WScCSBR
     C                   ELSE
     C                   MOVE      BRSC          WScCSBR
     C                   ENDIF
 
      **   For Account of and Counterparty come from file
     C                   MOVE      CFAO          WScCFAO
     C                   MOVEL     CCPN          WScCCPN
 
      **   Access LF/TRANS record for Trade, using closure reference
      **   from Closing  record.
     C                   MOVE      CLSR          KTrans
     C     KTrans        CHAIN     TRANSIN                            71
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     23            DBASE
     C                   MOVEL     'TRANS'       DBFILE
     C                   MOVEL     KTrans        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **   Customer and Book
      *
     C                   MOVEL     CUSC          WScCUSC
     C*****CUSC*         IFEQ      *ZEROS                                                     CSD027
     C     CUSC          IFEQ      *BLANKS                                                    CSD027
     C                   MOVE      *BLANKS       WScCUSC
     C                   ENDIF
     C                   MOVE      BOKC          WScBOKC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVIns1    - Validate Insert secondary screen                *
      *                                                               *
      *****************************************************************
     C     SRVIns1       BEGSR
 
     C                   MOVE      'N'           WErVIns1
     C                   MOVE      *OFF          *IN18
     C                   SETOFF                                       223872
     C                   Z-ADD     0             WEx
     C                   MOVE      *BLANK        WArErr
 
      ** --------------------- **
      ** Transaction Reference **
      ** --------------------- **
 
     C                   MOVEL     WScTransRef   WChr006
     C                   TESTN                   WChr006              74
 
      ** Error if not numeric or if equal to zero
     C     *IN74         IFEQ      *OFF
     C     WScTransRef   OREQ      '000000'
 
     C                   ADD       1             WEx
     C                   MOVE      ' 014'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns1
     C                   MOVE      *ON           *IN22
 
     C                   ELSE
 
      ** Error if record already exists
     C                   MOVE      WScTransRef   KTrans
     C     KTrans        CHAIN     TRANS2                             71
     C     *IN71         IFEQ      *OFF
     C                   ADD       1             WEx
     C                   MOVE      ' 015'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns1
     C                   MOVE      *ON           *IN22
     C                   ENDIF
 
     C                   ENDIF
 
      ** ----------------- **
      ** Closure Reference **
      ** ----------------- **
 
     C                   MOVEL     WScCLSR       WChr006
     C                   TESTN                   WChr006              74
 
      ** Error if not numeric or if equal to zero
     C     *IN74         IFEQ      *OFF
     C     WScCLSR       OREQ      '000000'
 
     C                   ADD       1             WEx
     C                   MOVE      ' 020'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns1
     C                   MOVE      *ON           *IN38
 
     C                   ELSE
 
      ** Error if LF/TRANS record doesn't exist or isn't live
     C                   MOVE      WScCLSR       KTrans
     C     KTrans        CHAIN     TRANSIN                            71
 
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C     *IN71         OREQ      *OFF
     C     CLSR          ANDNE     *ZEROS
 
     C                   ADD       1             WEx
     C                   MOVE      ' 021'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns1
     C                   MOVE      *ON           *IN38
 
     C                   ELSE
 
      ** SPF checking on booking branch when MBIN = Y
     C     P0MultBrch    IFEQ      'Y'
 
     C                   CALL      'ZVACTBU'
     C                   PARM      'I'           PZAction01A
     C                   PARM      BRCA          PZBranch03A
     C                   PARM                    PZErr010P
     C     PZErr010P     IFNE      0
     C                   ADD       1             WEx
     C                   MOVE      ' 305'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns1
     C                   MOVE      *ON           *IN38
     C                   GOTO      ExVIns1
     C                   ENDIF
 
      ** SPF checking on originating branch when MBIN = Y and
      ** originating branch used and validated = Y
     C     BKOBRU        IFEQ      'Y'
     C     BKOBUV        ANDEQ     'Y'
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          PZBranch03A
     C                   PARM                    PZErr010P
     C     PZErr010P     IFNE      0
     C                   ADD       1             WEx
     C                   MOVE      ' 308'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns1
     C                   MOVE      *ON           *IN38
     C                   GOTO      ExVIns1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVE      TRSD          TRSDS             5 0
 
      ** Transaction type must be 'P' or 'S'
     C     TRTY          IFNE      'P'
     C     TRTY          ANDNE     'S'
     C                   ADD       1             WEx
     C                   MOVE      ' 022'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns1
     C                   MOVE      *ON           *IN38
     C                   ENDIF
 
      ** Number of open contracts must be greater than zero
     C     NOCO          IFLE      0
     C                   ADD       1             WEx
     C                   MOVE      ' 024'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns1
     C                   MOVE      *ON           *IN38
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     ExVIns1       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAmDeEn1 -  Validate Amd/Del/Enq secondary screen.         *
      *                                                               *
      *****************************************************************
     C     SRVAmDeEn1    BEGSR
 
      ** Reset Processing
     C                   MOVE      'N'           WErVAmDeEn1
     C                   MOVE      *OFF          *IN18
     C                   SETOFF                                       1415
     C                   SETOFF                                       2272
     C                   Z-ADD     0             WEx
     C                   MOVE      *BLANK        WArErr
 
      ** --------------------- **
      ** Transaction Reference **
      ** --------------------- **
 
     C                   MOVEL     WScTransRef   WChr006
     C                   TESTN                   WChr006              74
      ** Error if not numeric or if equal to zero
     C     *IN74         IFEQ      '0'
     C     WScTransRef   OREQ      '000000'
     C                   ADD       1             WEx
     C                   MOVE      ' 014'        WArErr(WEx)
     C                   MOVE      'Y'           WErVAmDeEn1
     C                   MOVE      *ON           *IN22
     C                   GOTO      ExVAmDeEn1
     C                   ENDIF
 
     C                   MOVE      WScTransRef   KTrans
     C     KTrans        CHAIN     TRANSIN                            71
 
      ** Check if record ID is 'R' as system changes the record ID
      ** of a deleted trade to 'R' during COB
     C     *IN71         IFEQ      '0'
     C     WScActn       ANDEQ     'E'
     C     RECI          IFEQ      '*'
     C     RECI          OREQ      'R'
     C                   MOVE      *ON           *IN72
     C                   ENDIF
     C                   ENDIF
 
      ** Error if record isn't live unless WScActn = 'E'
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C     WScActn       ANDNE     'E'
     C                   ADD       1             WEx
     C                   MOVE      ' 016'        WArErr(WEx)
     C                   MOVE      'Y'           WErVAmDeEn1
     C                   MOVE      *ON           *IN22
     C                   GOTO      ExVAmDeEn1
     C                   ENDIF
 
      ** SPF checking on booking branch when MBIN = Y
     C     P0MultBrch    IFEQ      'Y'
 
     C                   CALL      'ZVACTBU'
     C                   PARM      WScActn       PZAction01A
     C                   PARM      BRCA          PZBranch03A
     C                   PARM                    PZErr010P
     C     PZErr010P     IFNE      0
     C                   ADD       1             WEx
     C                   MOVE      ' 304'        WArErr(WEx)
     C                   MOVE      'Y'           WErVAmDeEn1
     C                   MOVE      *ON           *IN22
     C                   GOTO      ExVAmDeEn1
     C                   ENDIF
 
      ** SPF checking on originating branch when MBIN = Y and
      ** originating branch used and validated = Y and
      ** action not = E
     C     BKOBRU        IFEQ      'Y'
     C     BKOBUV        ANDEQ     'Y'
     C     WScActn       ANDNE     'E'
     C                   CALL      'ZVOBU'
     C                   PARM      ORBR          PZBranch03A
     C                   PARM                    PZErr010P
     C     PZErr010P     IFNE      0
     C                   ADD       1             WEx
     C                   MOVE      ' 307'        WArErr(WEx)
     C                   MOVE      'Y'           WErVAmDeEn1
     C                   MOVE      *ON           *IN22
     C                   GOTO      ExVAmDeEn1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Save Date, Type and No. of last change to Closing
     C                   Z-ADD     LCD           XLCD              5 0
     C                   MOVE      CHTP          XCHTP             1
     C                   Z-ADD     TNLU          XTNLU             5 0
 
      ** Access LF/INTYP record
     C                   MOVE      ISTT          KInsTyp
     C     KInsTyp       CHAIN     INTYP                              71
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     24            DBASE
     C                   MOVEL     'INTYP'       DBFILE
     C                   MOVEL     KInsTyp       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      BCPT          BCPTX             1
     C                   MOVE      CCPT          CCPTX             1
 
      ** Transaction type must be 'S' OR 'P'
     C     TRTY          IFNE      'S'
     C     TRTY          ANDNE     'P'
     C     CLSR          OREQ      *ZEROS
     C                   ADD       1             WEx
     C                   MOVE      ' 017'        WArErr(WEx)
     C                   MOVE      'Y'           WErVAmDeEn1
     C                   MOVE      *ON           *IN22
     C                   ENDIF
 
      ** Check if Broker and/or Customer present for trade
     C*****BOCO*         IFNE      *ZEROS                                                     CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      *ON           *IN14
     C                   ENDIF
 
     C*****CUSC*         IFNE      *ZEROS                                                     CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      *ON           *IN15
     C                   ENDIF
 
     C     ExVAmDeEn1    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVIns2    - Validate Insert main detail screen              *
      *                                                               *
      *****************************************************************
     C     SRVIns2       BEGSR
 
     C                   MOVE      'N'           WErVIns2
     C                   MOVE      *OFF          *IN18
     C                   MOVE      *OFF          *IN74
     C                   Z-ADD     0             WEx
     C                   MOVE      *BLANK        WArErr
 
      ** ------------- **
      ** Customer code **
      ** ------------- **
 
     C                   MOVE      WScCUSC       WCust10A
 
     C     WCust10A      IFNE      *BLANKS
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      WCust10A      PCust10A
     C                   PARM                    @KYST
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C                   SELECT
 
      ** If record is found, use the customer number from the record
     C     PRtnCde07A    WHENEQ    *BLANKS
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      BBCUST        PCust10A
     C                   PARM                    @KYST
     C     SDCUST        PARM      SDCUST        DSLDY
     C     @KYST         IFEQ      '*CNUM'
     C                   MOVE      *BLANKS       WScCUSC
     C                   MOVEL     BBCUST        WScCUSC
     C                   ENDIF
     C                   MOVE      *BLANKS       WCust10A
     C                   MOVEL     BBCUST        WCust10A
 
     C     PRtnCde07A    WHENEQ    '*NOSEL'
     C                   SETON                                        36
 
      ** Otherwise check that entry is numeric, error if not
     C                   OTHER
     C                   MOVEL     WCust10A      WChr006
     C                   MOVE      WCust10A      WChr004
     C**********         TESTN                   WChr006              74                      CSD027
     C******IN74         IFEQ      '0'                                                        CSD027
     C*****WChr004       ORNE      *BLANKS                                                    CSD027
     C     WChr004       IFNE      *BLANKS                                                    CSD027
     C                   SETON                                        33
     C                   ENDIF
 
     C                   ENDSL
 
      ** If Customer code entered is blank, zero is assumed
     C**********         ELSE                                                                 CSD027
 
     C**********         MOVEL     '000000'      WCust10A                                     CSD027
 
     C                   ENDIF
 
      ** Compare resultant customer number with CUSC on LF/TRANS
     C     *IN33         IFEQ      *OFF
     C     *IN36         ANDEQ     *OFF
     C                   MOVEL     WCust10A      WCust060P
     C     CUSC          IFNE      WCust060P
     C                   SETON                                        33
     C                   ENDIF
     C                   ENDIF
 
      ** If they do not match, set up error code
     C     *IN33         IFEQ      *ON
     C                   ADD       1             WEx
     C                   MOVEL     ' 041'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   ENDIF
 
     C     *IN36         IFEQ      '1'
     C                   ADD       1             WEx
     C                   MOVEL     ' 042'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   MOVE      *ON           *IN33
     C                   ENDIF
 
      ** --------- **
      ** Book code **
      ** --------- **
 
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      WScBOKC       PBookCde02A
     C     SDBOOK        PARM      SDBOOK        DSFDY
 
     C                   SELECT
 
     C     PRtnCde07A    WHENEQ    *BLANKS
     C                   MOVE      BDBKCD        WScBOKC
     C     BOKC          IFNE      WScBOKC
     C                   SETON                                        34
     C                   ADD       1             WEx
     C                   MOVEL     ' 051'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   ENDIF
 
     C     PRtnCde07A    WHENEQ    '*NOSEL '
     C                   SETON                                        34
     C                   ADD       1             WEx
     C                   MOVEL     ' 052'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
 
     C                   OTHER
     C     BOKC          IFNE      WScBOKC
     C                   SETON                                        34
     C                   ADD       1             WEx
     C                   MOVEL     ' 051'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   ENDIF
 
     C                   ENDSL
 
      ** --------------------------- **
      ** Number of Contracts Closing **
      ** --------------------------- **
 
     C                   MOVE      *BLANKS       PZFld16A
     C                   MOVEL     WScNCTE       PZFld16A
     C                   Z-ADD     5             PZDigP
     C                   Z-ADD     0             PZDecP
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        PZRtnOK
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   PARM                    PZDigP
 
      ** Error if it's invalid or if entry was blank or zero
     C     PZRtnOK       IFEQ      'N'
     C     PZFld16A      OREQ      *ZERO
     C                   ADD       1             WEx
     C                   MOVE      ' 061'        WArErr(WEx)
     C                   SETON                                        35
     C                   MOVE      'Y'           WErVIns2
 
      ** If it's valid, check that it is not greater than the number
      ** of open contracts for the Trade
     C                   ELSE
 
     C                   MOVE      PZFld16A      WNCTE             5 0
     C     WNCTE         IFGT      NOCO
     C                   ADD       1             WEx
     C                   MOVE      ' 062'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        35
     C                   ELSE
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScNCTE
     C                   ENDIF
 
     C                   ENDIF
 
      ** ------------- **
      ** Closing Price **
      ** ------------- **
 
     C                   MOVE      WScEXPR       PFScrPriceA
     C                   Z-ADD     TKDMX         PFTckDenomP
     C                   Z-ADD     MNPFX         PFMinPriceFlcP
     C                   CALLB     'FFPRVL'
     C                   PARM      *BLANKS       PFRtnCde10A
     C                   PARM      *ZERO         PFFilPriceP
     C                   PARM                    PFScrPriceA
     C                   PARM                    PFTckDenomP
     C                   PARM                    PFMinPriceFlcP
     C     *LIKE         DEFINE    MNPF          WEXPR
     C                   Z-ADD     PFFilPriceP   WEXPR
 
     C     PFRtnCde10A   IFNE      *BLANKS
 
     C                   ADD       1             WEx
     C                   MOVE      ' 072'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        30
     C                   SETOFF                                       89
 
      ** Error if output from routine is zero
     C                   ELSE
 
     C     WEXPR         IFEQ      *ZERO
     C                   ADD       1             WEx
     C                   MOVE      ' 071'        WArErr(WEx)
     C                   SETON                                        30
     C                   MOVE      'Y'           WErVIns2
     C                   ELSE
     C                   Z-ADD     TKDMX         PFTckDenomP
     C                   Z-ADD     MNPFX         PFMinPriceFlcP
     C                   CALLB     'FFPRCS'
     C                   PARM      *BLANKS       PFRtnCde10A
     C                   PARM      *BLANKS       PFScrPriceA
     C                   PARM                    PFFilPriceP
     C                   PARM                    PFTckDenomP
     C                   PARM                    PFMinPriceFlcP
     C                   MOVE      PFScrPriceA   WScEXPR
     C                   ENDIF
 
     C                   ENDIF
 
      ** ---------------- **
      ** Transaction Date **
      ** ---------------- **
 
      ** If blank, defaults to control date
     C     WScTRSD       IFEQ      *BLANKS
     C                   MOVE      WCtlDate      OTRSD
     C                   SETON                                        78
     C                   MOVE      WCtlDate      PZDayNumP
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNumP
     C                   PARM      BJDFIN        PZDateFmtA
     C                   PARM                    PZDate060P
     C                   PARM                    PZDate07A
     C                   MOVE      PZDate060P    WScTRSD
     C                   ENDIF
 
      ** Check if entry is in valid date format
     C                   MOVE      WScTRSD       PZDate06A
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDate06A
     C                   PARM                    PZDayNumP
     C                   PARM      BJDFIN        PZDateFmtA
     C                   PARM      *BLANK        PZRtnErr
      ** Error if entry isn't a valid date
     C     PZRtnErr      IFEQ      'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 081'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        31
     C                   ENDIF
 
      ** Check that Date entered is not in the future
     C     *IN31         IFEQ      *OFF
     C                   MOVE      PZDayNumP     OTRSD             5 0
     C     OTRSD         IFGT      WCtlDate
     C                   ADD       1             WEx
     C                   MOVE      ' 082'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        31
     C                   ENDIF
     C                   ENDIF
 
      ** Check that Date entered is not a holiday
     C     *IN31         IFEQ      *OFF
 
     C     P0Mkt         IFNE      *BLANKS
     C                   MOVE      P0MktLocCcy   PZCcyA
     C                   MOVE      P0MktLocCde   PZLocA
     C                   ELSE
     C                   MOVE      BJLCCY        PZCcyA
     C                   MOVE      BLOC          PZLocA
     C                   ENDIF
 
      ** Check if date entered is a holiday
     C                   CALLB     'ZCHKH'
     C                   PARM                    PZDayNumP
     C                   PARM                    PZCcyA
     C                   PARM                    PZLocA
     C                   PARM      *BLANK        PZHolIndA
      ** Set up error code if date is a holiday
     C     PZHolIndA     IFEQ      'H'
     C                   ADD       1             WEx
     C                   MOVE      ' 083'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        31
     C                   ENDIF
 
     C                   ENDIF
 
      ** Must not be before start of Historical Data Period
     C     *IN31         IFEQ      *OFF
     C     OTRSD         IFLT      WStrHisDte
     C                   ADD       1             WEx
     C                   MOVE      ' 084'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        31
     C                   ENDIF
     C                   ENDIF
 
      ** Check that date entered is not prior to transaction date for
      ** the Trade being Closing
     C     *IN31         IFEQ      *OFF
     C     OTRSD         COMP      TRSD                                   78
     C     OTRSD         IFLT      TRSD
     C                   ADD       1             WEx
     C                   MOVE      ' 085'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        31
     C                   ENDIF
     C                   ENDIF
 
      ** If OTC enhancements are not on
     C     CFF003        IFNE      'Y'
 
      ** If the instrument is an OTC, set the settlement date to
      ** that on LF/INTYP, otherwise calculate it via FFDATE
     C     *IN31         IFEQ      *OFF
 
     C     P0Mkt         IFEQ      *BLANKS
     C                   Z-ADD     SETD          STDATE            5 0
     C                   ELSE
     C                   MOVE      SEDF          PFDateCde07A
     C                   MOVE      MTHN          PFMonth020P
     C                   MOVE      YRNO          PFYear020P
     C                   MOVE      P0MktLocCcy   PFMktCcyA
     C                   MOVE      P0MktLocCde   PFMktLocA
     C                   MOVE      ISCY          PFInsCcyA
     C                   MOVE      OTHC          PFOtherCcyA
     C                   CALLB     'FFDATE'
     C                   PARM      *BLANKS       PFRtnCde10A
     C                   PARM      *ZERO         PFWrkDayP
     C                   PARM                    PFDateCde07A
     C                   PARM                    PFMonth020P
     C                   PARM                    PFYear020P
     C                   PARM                    PFMktCcyA
     C                   PARM                    PFMktLocA
     C                   PARM                    PFInsCcyA
     C                   PARM                    PFOtherCcyA
     C                   PARM      BJDFIN        PFDateFmtA
     C                   MOVE      PFWrkDayP     STDATE
     C                   ENDIF
 
      ** Transaction date must not be after final transaction date
     C     OTRSD         IFGT      STDATE
     C     ISTI          ANDEQ     'N'
     C     OTRSD         ORGT      SETD
     C     ISTI          ANDEQ     'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 086'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        31
     C                   ENDIF
 
     C                   ENDIF
 
      ** If OTC enhancements are on
     C                   ELSE
 
      ** Validate Value Date if OTC and Transaction Date is OK
     C                   Z-ADD     *ZERO         OVALD             5 0
 
     C     P0Mkt         IFEQ      *BLANKS
     C     *IN31         ANDEQ     *OFF
 
      ** If blank, set equal to Closing (transaction) date
     C     WScVALD       IFEQ      *BLANK
     C                   MOVEL     WScTRSD       WScVALD
     C                   ENDIF
 
      ** Check if entry is in valid date format
     C                   MOVE      WScVALD       PZDate06A
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDate06A
     C                   PARM                    PZDayNumP
     C                   PARM      BJDFIN        PZDateFmtA
     C                   PARM      *BLANK        PZRtnErr
     C     PZRtnErr      IFEQ      'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 091'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        39
     C                   ENDIF
 
      ** Check that Date entered is not a holiday
     C     *IN39         IFEQ      *OFF
      ** Call ZCHKH to check if date entered is a holiday
     C                   CALLB     'ZCHKH'
     C                   PARM                    PZDayNumP
     C                   PARM      BJLCCY        PZCcyA
     C                   PARM      BLOC          PZLocA
     C                   PARM      *BLANK        PZHolIndA
     C     PZHolIndA     IFEQ      'H'
     C                   ADD       1             WEx
     C                   MOVE      ' 092'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        39
     C                   ENDIF
     C                   ENDIF
 
      ** Check that date entered is not prior to transaction date
     C     *IN39         IFEQ      *OFF
     C                   MOVE      PZDayNumP     OVALD
     C     OVALD         IFLT      OTRSD
     C                   ADD       1             WEx
     C                   MOVE      ' 093'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        39
     C                   ENDIF
     C                   ENDIF
 
      ** Value date must not be after the settlement date for
      ** an American style option.
     C     *IN39         IFEQ      *OFF
     C     AEIN          IFEQ      'A'
     C     OVALD         ANDGT     SETD
     C                   ADD       1             WEx
     C                   MOVE      ' 094'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        39
     C                   ENDIF
     C                   ENDIF
 
      ** Value date must be equal to the settlement date for
      ** a European style option.
     C     *IN39         IFEQ      *OFF
     C     AEIN          IFEQ      'E'
     C     OVALD         ANDNE     SETD
     C                   ADD       1             WEx
     C                   MOVE      ' 095'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        39
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** ---------- **
      ** Value Date **
      ** ---------- **
 
     C     WScMkt        IFNE      *BLANKS
     C     WScMkt        OREQ      *BLANKS
     C     CFF003        ANDEQ     'N'
 
     C     WScVALD       IFEQ      *BLANKS
     C     *IN31         ANDEQ     *OFF
 
     C                   MOVE      WScTRSD       PZDate06A
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDate06A
     C                   PARM                    PZDayNumP
     C                   PARM      BJDFIN        PZDateFmtA
     C                   PARM      *BLANK        PZRtnErr
     C                   Z-ADD     PZDayNumP     WTRSD             5 0
 
     C     ISTI          IFEQ      'Y'
     C                   Z-ADD     2             PZDayFwdP
     C                   MOVE      *BLANKS       PZLocA
     C                   ELSE
     C                   Z-ADD     1             PZDayFwdP
     C                   ENDIF
 
     C                   CALLB     'ZFWDT'
     C                   PARM                    PZDayNumP
     C                   PARM                    PZDayFwdP
     C                   PARM                    PZDayNumP2
     C                   PARM      WFFCCY        PZCcyA
     C                   PARM                    PZLocA
 
     C                   MOVE      PZDayNumP2    PZDayNumP
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayNumP
     C                   PARM      BJDFIN        PZDateFmtA
     C                   PARM                    PZDate060P
     C                   PARM                    PZDate07A
     C                   MOVE      PZDate060P    WScVALD
 
     C                   ENDIF
 
      ** Check if entry is in valid date format
     C                   MOVE      WScVALD       PZDate06A
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDate06A
     C                   PARM                    PZDayNumP
     C                   PARM      BJDFIN        PZDateFmtA
     C                   PARM      *BLANK        PZRtnErr
     C     PZRtnErr      IFEQ      'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 325'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        68
     C                   ENDIF
 
     C                   Z-ADD     PZDayNumP     WVALD             5 0
 
      ** Must not be greater than settlement date
     C     WScMkt        IFNE      *BLANKS
     C                   MOVE      SEDF          PFDateCde07A
     C                   MOVE      MTHN          PFMonth020P
     C                   MOVE      YRNO          PFYear020P
     C                   MOVE      P0MktLocCcy   PFMktCcyA
     C                   MOVE      KCCY          PFInsCcyA
     C                   MOVE      OTHC          PFOtherCcyA
     C                   CALLB     'FFDATE'
     C                   PARM      *BLANKS       PFRtnCde10A
     C                   PARM      *ZERO         PFWrkDayP
     C                   PARM                    PFDateCde07A
     C                   PARM                    PFMonth020P
     C                   PARM                    PFYear020P
     C                   PARM                    PFMktCcyA
     C                   PARM                    PFMktLocA
     C                   PARM                    PFInsCcyA
     C                   PARM                    PFOtherCcyA
     C                   PARM      BJDFIN        PFDateFmtA
     C                   Z-ADD     PFWrkDayP     WSETD             5 0
     C                   ELSE
     C                   Z-ADD     SETD          WSETD
     C                   ENDIF
 
     C     WVALD         IFGT      WSETD
     C     *IN68         ANDEQ     *OFF
     C                   ADD       1             WEx
     C                   MOVE      ' 327'        WArErr(WEx)
     C                   SETON                                        68
     C                   MOVE      'Y'           WErVIns2
     C                   ENDIF
 
      ** Must not be before Trade Date
     C     WVALD         IFLT      WTRSD
     C     *IN68         ANDEQ     '0'
     C                   ADD       1             WEx
     C                   MOVE      ' 326'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        68
     C                   ENDIF
 
      ** Must not be a holiday
     C     WScMkt        IFNE      *BLANKS
     C                   MOVE      P0MktLocCcy   PZCcyA
     C                   ELSE
     C                   MOVE      BJLCCY        PZCcyA
     C                   ENDIF
 
     C                   Z-ADD     WVALD         PZDayNumP
     C                   CALLB     'ZCHKH'
     C                   PARM                    PZDayNumP
     C                   PARM                    PZCcyA
     C                   PARM      *BLANKS       PZLocA
     C                   PARM      *BLANK        PZHolIndA
 
     C     PZHolIndA     IFEQ      'H'
     C     *IN68         ANDEQ     '0'
     C     WVALD         ANDNE     WSVALD
     C     PZHolIndA     OREQ      'H'
     C     *IN68         ANDEQ     '0'
     C     WEx           ANDNE     *ZEROS
     C                   Z-ADD     WVALD         WSVALD            5 0
     C                   ADD       1             WEx
     C                   MOVE      ' W18'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        68
     C                   ENDIF
 
     C                   ENDIF
 
      ** -------------------------------- **
      ** Customer Settlement Instructions **
      ** -------------------------------- **
 
     C*****CUSC*         IFNE      *ZERO                                                      CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL(P)  CUSC          PCust10A
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM                    PCust10A
     C                   PARM                    @KYST
     C     SDCUST        PARM      SDCUST        DSLDY
     C                   EXSR      SRVCust
     C     *IN18         IFEQ      *ON
     C                   MOVE      'Y'           WErVIns2
     C                   ENDIF
     C                   ENDIF
 
      ** ------------------- **
      ** Routine for O.T.C's **
      ** ------------------- **
 
     C     P0Mkt         IFNE      *BLANKS
 
      ** Validate Broker code
     C                   MOVE      *BLANKS       WBOCO            10
     C                   MOVE      #4BOCO        WBOCO
 
      ** If Broker code entered is blank or *, zero is assumed
     C     WBOCO         IFEQ      *BLANKS
     C     WSBOCO1       OREQ      '*'
     C     WSBOCO9       ANDEQ     *BLANKS
 
     C**********         MOVEL     '000000'      WBOCO                                        CSD027
     C                   EVAL      WBOCO = *BLANKS                                            CSD027
 
     C                   ELSE
 
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      WBOCO         PCust10A
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSLDY
 
     C                   SELECT
      **   If record is found, use the customer number from the record
     C     PRtnCde07A    WHENEQ    *BLANKS
     C     @KYST         IFEQ      '*CNUM'
     C                   MOVE      *BLANKS       #4BOCO
     C                   MOVEL     BBCUST        #4BOCO
     C                   ENDIF
     C                   MOVE      *BLANKS       WBOCO
     C                   MOVEL     BBCUST        WBOCO
 
     C     PRtnCde07A    WHENEQ    '*NOSEL'
     C                   SETON                                        37
 
      **   Otherwise check that entry is numeric, error if not
     C                   OTHER
     C                   MOVEL     WBOCO         WChr006
     C                   MOVE      WBOCO         WChr004
     C**********         TESTN                   WChr006              74                      CSD027
     C******IN74         IFEQ      '0'                                                        CSD027
     C*****WChr004       ORNE      *BLANKS                                                    CSD027
     C     WChr004       IFNE      *BLANKS                                                    CSD027
     C                   SETON                                        32
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
      ** Compare resultant Broker number with BOCO on LF/TRANS
     C     *IN32         IFEQ      '0'
     C     *IN37         ANDEQ     '0'
     C**********         MOVEL     WBOCO         WBROK             6 0                        CSD027
     C                   MOVEL     WBOCO         WBROK             6                          CSD027
     C     BOCO          IFNE      WBROK
     C                   SETON                                        32
     C                   ENDIF
     C                   ENDIF
 
      ** If they do not match, set up error code
     C     *IN32         IFEQ      '1'
     C                   ADD       1             WEx
     C                   MOVEL     ' 031'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   ENDIF
 
     C     *IN37         IFEQ      '1'
     C                   ADD       1             WEx
     C                   MOVEL     ' 032'        WArErr(WEx)
     C                   MOVE      'Y'           WErVIns2
     C                   SETON                                        32
     C                   ENDIF
 
      ** Validate Broker Settlement Instructions
     C*****BOCO*         IFNE      *ZERO                                                      CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   EXSR      SRVBroker
     C     *IN18         IFEQ      *ON
     C                   MOVE      'Y'           WErVIns2
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCust    - Validate Customer Settlement Instructions       *
      *                                                               *
      *****************************************************************
     C     SRVCust       BEGSR
 
     C                   SETOFF                                       667174
     C                   Z-ADD     0             WCCMA
     C                   Z-ADD     0             WCCHA
 
      ** ------------------------- **
      ** Customer Commission codes **
      ** ------------------------- **
 
     C                   MOVE      ISCY          KCCY
 
      ** - Standard
     C     WScCCMC       IFNE      *BLANKS
 
     C                   MOVE      WScCCMC       KCGCM
     C     KCHGCM        CHAIN     CHGCM                              71
      ** Error if not found on Charges/Commissions file
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C                   ADD       1             WEx
     C                   MOVE      ' 210'        WArErr(WEx)
     C                   SETON                                        1850
     C                   ENDIF
 
     C                   ENDIF
 
      ** - Same day
     C     WScCCMS       IFNE      *BLANKS
 
     C                   MOVE      WScCCMS       KCGCM
     C     KCHGCM        CHAIN     CHGCM                              71
      ** Error if not found on Charges/Commissions file
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C                   ADD       1             WEx
     C                   MOVE      ' 211'        WArErr(WEx)
     C                   SETON                                        1851
     C                   ENDIF
 
     C                   ENDIF
 
      **   If one Commission code is entered the other must be entered
     C     *IN50         IFEQ      '0'
     C     *IN51         ANDEQ     '0'
     C     WSCCM         ANDNE     *BLANK
 
     C     WScCCMC       IFEQ      *BLANK
     C                   ADD       1             WEx
     C                   MOVE      ' 210'        WArErr(WEx)
     C                   SETON                                        1850
     C                   ENDIF
 
     C     WScCCMS       IFEQ      *BLANK
     C                   ADD       1             WEx
     C                   MOVE      ' 211'        WArErr(WEx)
     C                   SETON                                        1851
     C                   ENDIF
 
     C                   ENDIF
 
      ** -------------------------- **
      ** Customer Commission Amount **
      ** -------------------------- **
 
     C                   Z-ADD     A6NBDP        PZDecP
     C     13            SUB       A6NBDP        PZDigP
 
     C     WScCCMA       IFNE      *BLANKS
     C     BBPRBA        OREQ      'Y'
 
      ** If 'A' is entered, rest of field must be blank
     C     WSCCMA1       IFEQ      'A'
 
     C     WSCCMA2       IFNE      *BLANKS
     C                   ADD       1             WEx
     C                   MOVE      ' 212'        WArErr(WEx)
     C                   SETON                                        1852
      ** except for Commission codes that must Not be blank
     C                   ELSE
     C     WSCCM         IFEQ      '    '
     C                   ADD       1             WEx
     C                   MOVE      ' 213'        WArErr(WEx)
     C                   SETON                                        1852
     C                   ENDIF
     C                   ENDIF
 
      ** Error if it's not a valid number
     C                   ELSE
 
     C                   MOVE      *BLANKS       PZFld16A
     C                   MOVE      WScCCMA       PZFld16A
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        PZRtnOK
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   PARM                    PZDigP
     C                   MOVE      PZFld16A      WCCMA            13 0
     C     PZRtnOK       IFEQ      'N'
     C                   ADD       1             WEx
     C                   MOVE      ' 212'        WArErr(WEx)
     C                   SETON                                        1852
     C                   ENDIF
 
      ** Error if Codes and amount entered unless amount = 'A'
     C     WSCCM         IFNE      *BLANKS
     C     BBPRBA        ANDNE     'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 213'        WArErr(WEx)
     C                   SETON                                        1852
     C                   ELSE
     C     WSCCM         IFEQ      *BLANK
     C     WScCCMA       ANDNE     *BLANK
     C     BBPRBA        ANDEQ     'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 262'        WArErr(WEx)
     C                   SETON                                        185051
     C                   ENDIF
     C                   ENDIF
 
     C     *IN52         IFEQ      '0'
     C     *IN50         ANDEQ     '0'
     C     *IN51         ANDEQ     '0'
 
     C     WSCCM         IFNE      *BLANK
     C     WScCCMC       ANDEQ     WScCCMS
     C     BBPRBA        ANDEQ     'Y'
 
     C     CCPT          IFEQ      'H'
     C     CCPT          OREQ      'A'
     C     CCPT          OREQ      'E'
 
     C                   Z-ADD     WNCTE         WCONO             5 0
     C                   MOVE      WScCCMC       CGCM
     C                   Z-ADD     0             WRATA            13 0
 
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRCalcRate
     C                   ENDIF
 
     C     WRATA         IFNE      0
     C                   Z-ADD     A6NBDP        PZDecP
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      WRATA         PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      ZXCMA            14
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     WCCMA         IFEQ      0
 
     C     WSCCM         IFNE      *BLANK
     C     WScCCMC       ANDEQ     WScCCMS
     C     BBPRBA        ANDEQ     'Y'
     C                   Z-ADD     WRATA         WCCMA
 
     C     WScCCMA       IFEQ      *BLANKS
     C                   SETON                                        18
     C                   ENDIF
 
     C                   MOVE      ZXCMA         WScCCMA
     C                   MOVE      'A'           CCPT
     C                   MOVE      'Y'           CMCC
     C                   ELSE
     C                   MOVE      *BLANK        WScCCMA
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     A6NBDP        PZDecP
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      WCCMA         PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScCCMA
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** -------------------- **
      ** Customer Charge code **
      ** -------------------- **
 
     C     WScCCHC       IFNE      *BLANKS
 
     C                   MOVE      WScCCHC       KCGCM
     C     KCHGCM        CHAIN     CHGCM                              71
      **   Error if not found on Charges/Commissions file
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C                   ADD       1             WEx
     C                   MOVE      ' 214'        WArErr(WEx)
     C                   SETON                                        1853
     C                   ENDIF
      *
     C                   ENDIF
 
      ** ---------------------- **
      ** Customer Charge Amount **
      ** ---------------------- **
 
     C     WScCCHA       IFNE      *BLANKS
     C     BBPRBA        OREQ      'Y'
 
     C     WScCCHA       IFNE      *BLANKS
     C                   MOVE      *BLANKS       PZFld16A
     C                   MOVE      WScCCHA       PZFld16A
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        PZRtnOK
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   PARM                    PZDigP
     C                   MOVE      PZFld16A      WCCHA            13 0
     C     PZRtnOK       IFEQ      'N'
     C                   ADD       1             WEx
     C                   MOVE      ' 215'        WArErr(WEx)
     C                   SETON                                        1854
     C                   ENDIF
     C                   ENDIF
 
      ** Error if Code and amount entered
     C     WScCCHC       IFNE      *BLANKS
     C     BBPRBA        ANDNE     'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 216'        WArErr(WEx)
     C                   SETON                                        1854
     C                   ELSE
     C     WScCCHC       IFEQ      *BLANK
     C     WScCCHA       ANDNE     *BLANK
     C     BBPRBA        ANDEQ     'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 264'        WArErr(WEx)
     C                   SETON                                        1853
     C                   ENDIF
     C                   ENDIF
 
     C     *IN54         IFEQ      '0'
     C     *IN53         ANDEQ     '0'
 
     C     WScCCHC       IFNE      *BLANK
     C     BBPRBA        ANDEQ     'Y'
 
     C     CCPT          IFEQ      'S'
     C     CCPT          OREQ      'H'
     C     CCPT          OREQ      'A'
     C     CCPT          OREQ      'E'
 
     C                   Z-ADD     WNCTE         WCONO             5 0
     C                   MOVE      WScCCHC       CGCM
     C                   Z-ADD     0             WRATA            13 0
 
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRCalcRate
     C                   ENDIF
 
     C     WRATA         IFNE      0
     C                   Z-ADD     A6NBDP        PZDecP
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      WRATA         PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      ZXCMA            14
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     WCCHA         IFEQ      0
 
     C     WScCCHC       IFNE      *BLANKS
     C     BBPRBA        ANDEQ     'Y'
     C                   Z-ADD     WRATA         WCCHA
     C     WScCCHA       IFEQ      *BLANKS
     C                   SETON                                        18
     C                   ENDIF
     C                   MOVE      ZXCMA         WScCCHA
     C                   MOVE      'A'           CCPT
     C                   MOVE      'Y'           CHCC
     C                   ELSE
     C                   MOVE      *BLANK        WScCCHA
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     A6NBDP        PZDecP
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      WCCHA         PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScCCHA
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up work fields and indicator for lower level SR's
     C                   MOVE      WScCSLT       SWSLT             2
     C                   MOVE      WScCSLA       WDsCSLA
     C                   MOVE      WScCSBR       SWSBR             3
     C                   MOVE      WScCFAO       SWFAO            10
     C                   MOVE      WScCCPN       SWCPN            10
     C                   SETON                                        75
     C                   SETOFF                                       606162
     C                   SETOFF                                       637376
     C                   SETOFF                                       67
 
      ** --------------------- **
      ** Four remaining fields **
      ** --------------------- **
 
     C                   MOVE      BBPRBA        WWTOFC
     C                   EXSR      SRVSettlTyp
     C     *IN60         IFEQ      *ON
     C                   SETON                                        56
     C                   ENDIF
 
     C     *IN66         IFEQ      '0'
 
     C                   EXSR      SRVSettlAcc
     C     *IN61         IFEQ      *ON
     C                   SETON                                        57
     C                   ENDIF
     C     *IN67         IFEQ      '1'
     C                   SETON                                        55
     C                   ENDIF
 
      ** Save fields for update of LF/MEMOSM and LF/PRONOM
     C                   MOVE      XMIND         CMIND             1
     C                   MOVE      XPIND         CPIND             1
     C                   MOVE      WFFNOSN       KNOSNC            2 0
     C**********         MOVE      WFFCustP      KCNUMC            6 0                        CSD027
     C                   MOVE      WFFCustP      KCNUMC            6                          CSD027
     C**********         MOVE      WFFACOD       KACODC            4 0                        CGL029
     C                   MOVE      WFFACOD       KACODC           10 0                        CGL029
     C                   MOVE      WFFACSQ       KACSQC            2 0
     C                   MOVE      WFFBRCB       KBRCAC            3
 
      ** Set up the account field for output to file
     C                   MOVE      WFFBRCB       WCBID             3
 
     C     SWSLT         IFEQ      '04'
     C     SWSLT         OREQ      '06'
     C     SWSLT         OREQ      '15'
     C**********         MOVE      WFSLA         WCSLA            12                          CGL029
     C                   MOVE      WFSLA         WCSLA            18                          CGL029
     C                   MOVE      FFBRC2        WCSBR             3
     C                   ELSE
     C                   MOVE      WScCSLA       WCSLA
     C     P0MultBrch    IFNE      'Y'
     C     SWSLT         ANDEQ     '05'
     C                   MOVE      WFFBRCB       WCSBR
     C                   ELSE
     C                   MOVE      WScCSBR       WCSBR
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRVForAccOf
     C     *IN62         IFEQ      *ON
     C                   SETON                                        58
     C                   ENDIF
     C                   EXSR      SRVCtrPtyNost
     C     *IN63         IFEQ      *ON
     C                   SETON                                        59
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBroker  - Validate Broker Settlement Instructions         *
      *                                                               *
      *****************************************************************
     C     SRVBroker     BEGSR
 
     C                   SETOFF                                       667174
     C                   Z-ADD     0             WBCMA
     C                   Z-ADD     0             WBCHA
 
      ** ----------------------- **
      ** Broker Commission codes **
      ** ----------------------- **
 
     C                   MOVE      ISCY          KCCY
      ** - Standard
     C     #4BCMC        IFNE      *BLANKS
 
     C                   MOVE      #4BCMC        KCGCM
     C     KCHGCM        CHAIN     CHGCM                              71
      ** Error if not found on Charges/Commissions file
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C                   ADD       1             WEx
     C                   MOVE      ' 200'        WArErr(WEx)
     C                   SETON                                        1840
     C                   ENDIF
 
     C                   ENDIF
 
      ** - Same day
     C     #4BCMS        IFNE      '  '
 
     C                   MOVE      #4BCMS        KCGCM
     C     KCHGCM        CHAIN     CHGCM                              71
      ** Error if not found on Charges/Commissions file
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C                   ADD       1             WEx
     C                   MOVE      ' 201'        WArErr(WEx)
     C                   SETON                                        1841
     C                   ENDIF
 
     C                   ENDIF
 
      ** If one Commission code is entered the other must be entered
     C     *IN40         IFEQ      '0'
     C     *IN41         ANDEQ     '0'
     C     WSBCM         ANDNE     *BLANK
 
     C     #4BCMC        IFEQ      *BLANK
     C                   ADD       1             WEx
     C                   MOVE      ' 200'        WArErr(WEx)
     C                   SETON                                        1840
     C                   ENDIF
 
     C     #4BCMS        IFEQ      *BLANK
     C                   ADD       1             WEx
     C                   MOVE      ' 201'        WArErr(WEx)
     C                   SETON                                        1841
     C                   ENDIF
 
     C                   ENDIF
 
      ** ------------------------ **
      ** Broker Commission Amount **
      ** ------------------------ **
 
     C                   Z-ADD     A6NBDP        PZDecP
     C     13            SUB       A6NBDP        PZDigP
      *
     C     #4BCMA        IFNE      *BLANKS
     C     BBPRBA        OREQ      'Y'
 
      ** If 'A' is entered, rest of field must be blank
     C     WSBCMA1       IFEQ      'A'
 
     C     WSBCMA2       IFNE      *BLANKS
     C                   ADD       1             WEx
     C                   MOVE      ' 202'        WArErr(WEx)
     C                   SETON                                        1842
      ** If 'A' is entered, Commission codes must not be blank
     C                   ELSE
     C     WSBCM         IFEQ      '    '
     C     BBPRBA        ANDNE     'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 203'        WArErr(WEx)
     C                   SETON                                        1842
     C                   ENDIF
     C                   ENDIF
 
      ** Error if it's not a valid number
     C                   ELSE
 
     C                   MOVE      *BLANKS       PZFld16A
     C                   MOVE      #4BCMA        PZFld16A
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        PZRtnOK
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   PARM                    PZDigP
     C                   MOVE      PZFld16A      WBCMA            13 0
     C     PZRtnOK       IFEQ      'N'
     C                   ADD       1             WEx
     C                   MOVE      ' 202'        WArErr(WEx)
     C                   SETON                                        1842
     C                   ENDIF
 
      ** Error if Codes and amount entered unless amount = 'A'
     C     WSBCM         IFNE      '    '
     C     BBPRBA        ANDNE     'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 203'        WArErr(WEx)
     C                   SETON                                        1842
     C                   ELSE
     C     WSBCM         IFEQ      *BLANK
     C     #4BCMA        ANDNE     *BLANK
     C     BBPRBA        ANDEQ     'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 258'        WArErr(WEx)
     C                   SETON                                        184041
     C                   ENDIF
     C                   ENDIF
 
     C     *IN42         IFEQ      '0'
     C     *IN41         ANDEQ     '0'
     C     *IN42         ANDEQ     '0'
 
     C     WSBCM         IFNE      *BLANK
     C     #4BCMC        ANDEQ     #4BCMS
     C     BBPRBA        ANDEQ     'Y'
 
     C     BCPT          IFEQ      'H'
     C     BCPT          OREQ      'A'
     C     BCPT          OREQ      'E'
 
     C                   Z-ADD     WNCTE         WCONO
     C                   MOVE      #4BCMC        CGCM
     C                   Z-ADD     0             WRATA
 
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRCalcRate
     C                   ENDIF
 
     C     WRATA         IFNE      0
     C                   Z-ADD     A6NBDP        PZDecP
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      WRATA         PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      ZXCMA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     WBCMA         IFEQ      0
 
     C     WSBCM         IFNE      *BLANK
     C     #4BCMC        ANDEQ     #4BCMS
     C     BBPRBA        ANDEQ     'Y'
     C                   Z-ADD     WRATA         WBCMA
     C     #4BCMA        IFEQ      *BLANKS
     C                   SETON                                        18
     C                   ENDIF
     C                   MOVE      ZXCMA         #4BCMA
     C                   MOVE      'A'           BCPT
     C                   MOVE      'Y'           CMCB
     C                   ELSE
     C                   MOVE      *BLANK        #4BCMA
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     A6NBDP        PZDecP
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      WBCMA         PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      #4BCMA
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** ------------------ **
      ** Broker Charge code **
      ** ------------------ **
 
     C     #4BCHC        IFNE      '  '
 
     C                   MOVE      #4BCHC        KCGCM
     C     KCHGCM        CHAIN     CHGCM                              71
      ** Error if not found on Charges/Commissions file
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C                   ADD       1             WEx
     C                   MOVE      ' 204'        WArErr(WEx)
     C                   SETON                                        1843
     C                   ENDIF
      *
     C                   ENDIF
 
      ** -------------------- **
      ** Broker Charge Amount **
      ** -------------------- **
 
     C     #4BCHA        IFNE      *BLANKS
     C     BBPRBA        OREQ      'Y'
      *
     C     #4BCHA        IFNE      *BLANKS
     C                   MOVE      *BLANKS       PZFld16A
     C                   MOVE      #4BCHA        PZFld16A
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        PZRtnOK
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   PARM                    PZDigP
     C                   MOVE      PZFld16A      WBCHA            13 0
     C     PZRtnOK       IFEQ      'N'
     C                   ADD       1             WEx
     C                   MOVE      ' 205'        WArErr(WEx)
     C                   SETON                                        1844
     C                   ENDIF
     C                   ENDIF
 
      ** Error if Code and amount entered
     C     #4BCHC        IFNE      '  '
     C     BBPRBA        ANDNE     'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 206'        WArErr(WEx)
     C                   SETON                                        1844
     C                   ELSE
     C     #4BCHC        IFEQ      *BLANK
     C     #4BCHA        ANDNE     *BLANK
     C     BBPRBA        ANDEQ     'Y'
     C                   ADD       1             WEx
     C                   MOVE      ' 260'        WArErr(WEx)
     C                   SETON                                        1843
     C                   ENDIF
     C                   ENDIF
 
     C     *IN44         IFEQ      '0'
     C     *IN43         ANDEQ     '0'
 
     C     #4BCHC        IFNE      *BLANK
     C     BBPRBA        ANDEQ     'Y'
 
     C     BCPT          IFEQ      'S'
     C     BCPT          OREQ      'H'
     C     BCPT          OREQ      'A'
     C     BCPT          OREQ      'E'
 
     C                   Z-ADD     WNCTE         WCONO
     C                   MOVE      #4BCHC        CGCM
     C                   Z-ADD     0             WRATA
 
     C     WCONO         IFNE      0
     C     CGCM          ANDNE     0
     C                   EXSR      SRCalcRate
     C                   ENDIF
 
     C     WRATA         IFNE      0
     C                   Z-ADD     A6NBDP        PZDecP
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      WRATA         PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      ZXCMA
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     WBCHA         IFEQ      0
 
     C     #4BCHC        IFNE      *BLANKS
     C     BBPRBA        ANDEQ     'Y'
     C                   Z-ADD     WRATA         WBCHA
     C     #4BCHA        IFEQ      *BLANKS
     C                   SETON                                        18
     C                   ENDIF
     C                   MOVE      ZXCMA         #4BCHA
     C                   MOVE      'A'           BCPT
     C                   MOVE      'Y'           CHCB
     C                   ELSE
     C                   MOVE      *BLANK        #4BCHA
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     A6NBDP        PZDecP
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      WBCHA         PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      #4BCHA
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up work fields and indicator for lower level SR's
 
     C                   MOVE      #4BSLT        SWSLT
     C                   MOVE      #4BSLA        WDsCSLA
     C                   MOVE      #4BSBR        SWSBR
     C                   MOVE      #4BFAO        SWFAO
     C                   MOVE      #4BCPN        SWCPN
     C                   SETON                                        76
     C                   SETOFF                                       606162
     C                   SETOFF                                       637375
     C                   SETOFF                                       67
 
      ** --------------------- **
      ** Four remaining fields **
      ** --------------------- **
 
     C                   MOVE      'N'           WWTOFC            1
     C                   EXSR      SRVSettlTyp
     C     *IN60         IFEQ      *ON
     C                   SETON                                        46
     C                   ENDIF
 
     C     *IN66         IFEQ      '0'
 
     C                   EXSR      SRVSettlAcc
     C     *IN61         IFEQ      *ON
     C                   SETON                                        47
     C                   ENDIF
     C     *IN67         IFEQ      '1'
     C                   SETON                                        45
     C                   ENDIF
 
      ** Save fields for later update of LF/MEMOSM and LF/PRONOM
     C                   MOVE      XMIND         BMIND             1
     C                   MOVE      XPIND         BPIND             1
     C                   MOVE      WFFNOSN       KNOSNB            2 0
     C**********         MOVE      WFFCustP      KCNUMB            6 0                        CSD027
     C                   MOVE      WFFCustP      KCNUMB            6                          CSD027
     C**********         MOVE      WFFACOD       KACODB            4 0                        CGL029
     C                   MOVE      WFFACOD       KACODB           10 0                        CGL029
     C                   MOVE      WFFACSQ       KACSQB            2 0
     C                   MOVE      WFFBRCB       KBRCAB            3
 
      ** Set up the account field for output to file
     C                   MOVE      WFFBRCB       WBBID             3
 
     C     SWSLT         IFEQ      '04'
     C     SWSLT         OREQ      '06'
     C     SWSLT         OREQ      '15'
     C**********         MOVE      WFSLA         WBSLA            12                          CGL029
     C                   MOVE      WFSLA         WBSLA            18                          CGL029
     C                   MOVE      FFBRC2        WBSBR             3
     C                   ELSE
     C                   MOVE      #4BSLA        WBSLA
     C     P0MultBrch    IFNE      'Y'
     C     SWSLT         ANDEQ     '05'
     C                   MOVE      WFFBRCB       WBSBR
     C                   ELSE
     C                   MOVE      #4BSBR        WBSBR
     C                   ENDIF
     C                   ENDIF
 
     C                   EXSR      SRVForAccOf
     C     *IN62         IFEQ      *ON
     C                   SETON                                        48
     C                   ENDIF
     C                   EXSR      SRVCtrPtyNost
     C     *IN63         IFEQ      *ON
     C                   SETON                                        49
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSettlTyp- Validate settlement type                        *
      *                                                               *
      *****************************************************************
     C     SRVSettlTyp   BEGSR
 
     C     SWSLT         IFEQ      '  '
     C     WWTOFC        ANDNE     'Y'
 
     C                   MOVE      '00'          SWSLT
 
      ** Defaults to zero if blank
     C     *IN75         IFEQ      '1'
     C                   MOVE      '00'          WScCSLT
     C                   ELSE
     C                   MOVE      '00'          #4BSLT
     C                   ENDIF
 
      ** Must be a valid settlement type
     C                   ELSE
 
     C     SWSLT         IFNE      '04'
     C     SWSLT         ANDNE     '05'
     C     SWSLT         ANDNE     '14'
     C     SWSLT         ANDNE     '15'
     C     WWTOFC        ANDEQ     'Y'
      ** Set up error code if invalid
     C                   ADD       1             WEx
     C                   MOVE      ' 256'        WArErr(WEx)
     C                   SETON                                        186066
     C                   ELSE
     C     SWSLT         IFEQ      '09'
     C     SWSLT         OREQ      '10'
     C     SWSLT         OREQ      '11'
     C     SWSLT         OREQ      '13'
     C     SWSLT         ORGE      '16'
     C     SWSLT         ORLT      '00'
      ** Set up error code if invalid
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 240'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 220'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        186066
     C                   ENDIF
     C                   ENDIF
 
      ** Settlement type can be 04 or 14 only if Retail is set on
     C     SWSLT         IFEQ      '04'
     C     SWSLT         OREQ      '14'
     C*****BGRTBN        IFEQ      'Y'                                                        CRE020
     C     BGRTBN        IFNE      'Y'                                                        CRE020
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 241'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 221'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        1860
     C                   ENDIF
     C                   ENDIF
 
      ** Check that Instrument currency is correct if type is 07
     C     SWSLT         IFEQ      '07'
     C     ISCY          IFNE      'USD'
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 242'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 222'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        1860
     C                   ENDIF
     C                   ENDIF
 
      ** Check that Retail Account numbers are supported if type is 14
     C     *IN60         IFEQ      '0'
     C     SWSLT         ANDEQ     '14'
     C     BMRANR        ANDNE     'Y'
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 243'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 223'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        1860
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVSettlAcc - Validate settlement account.                   *
      *                                                               *
      *****************************************************************
     C     SRVSettlAcc   BEGSR
 
      ** Reset work fields
     C                   MOVE      'N'           XMIND             1
     C                   MOVE      'N'           XPIND             1
     C                   Z-ADD     0             WFFNOSN
     C**********         Z-ADD     0             WFFCustP                                     CSD027
     C                   EVAL      WFFCustP = *BLANKS                                         CSD027
     C                   Z-ADD     0             WFFACOD
     C                   Z-ADD     0             WFFACSQ
     C                   Z-ADD     0             FFACD2
     C                   MOVE      *BLANKS       WFFBRCB
     C                   MOVE      *BLANKS       FFBRC2
 
      ** --------------------------------- **
      ** Settlement type is 00, 04, 06, 15 **
      ** --------------------------------- **
 
     C     SWSLT         IFEQ      '00'
     C     SWSLT         OREQ      '04'
     C     SWSLT         OREQ      '06'
     C     SWSLT         OREQ      '15'
 
      ** Account must be blank
     C     WDsCSLA       IFNE      *BLANKS
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 244'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 224'        WArErr(WEx)
     C                   ENDIF
     C                   MOVE      *ON           *IN18
     C                   MOVE      *ON           *IN61
     C                   ELSE
     C                   MOVE      WScBRCA       WFFBRCB
     C                   ENDIF
 
     C                   ENDIF
 
      ** ------------------------------------- **
      ** Settlement type is 01, 02, 07, 18, 12 **
      ** ------------------------------------- **
 
     C     SWSLT         IFEQ      '01'
     C     SWSLT         OREQ      '02'
     C     SWSLT         OREQ      '07'
     C     SWSLT         OREQ      '08'
     C     SWSLT         OREQ      '12'
 
     C                   MOVE      'Y'           XPIND
 
     C     WDsCSLA       IFNE      *BLANKS
 
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      *BLANKS       PCust06A
     C                   PARM      ISCY          PCcy03A
     C                   PARM      *BLANKS       PAccCde04A
     C                   PARM      *BLANKS       PAccSeq02A
     C                   PARM      WDssCSLA0102  PNostro02A
     C                   PARM      *BLANKS       PBrch03A
     C                   PARM      *BLANKS       PNostroNme10A
     C                   PARM      *BLANK        PPrimeNost01A
     C     SDNOST        PARM      SDNOST        DSFDY
 
     C     PRtnCde07A    IFNE      *BLANKS
     C     WDssCSLA0312  ORNE      *BLANKS
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 245'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 225'        WArErr(WEx)
     C                   ENDIF
     C                   MOVE      *ON           *IN18
     C                   MOVE      *ON           *IN61
      ** Set up fields for later chains if record is found
     C                   ELSE
     C                   MOVE      WDssCSLA0102  WFFNOSN
     C                   MOVE      A7ACCD        WFFACOD
     C                   MOVE      A7CUST        WFFCustP
     C                   MOVE      A7ACSN        WFFACSQ
     C                   MOVE      A7BRCD        WFFBRCB
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** --------------------- **
      ** Settlement type is 03 **
      ** --------------------- **
 
     C     SWSLT         IFEQ      '03'
 
      ** Must be a 6-digit numeric field
     C**********         TESTN                   WDssCSLA0106         74                      CSD027
 
     C******IN74         IFEQ      *OFF                                                       CSD027
     C*****WDssCSLA0712  ORNE      *BLANKS                                                    CSD027
     C     WDssCSLA0712  IFNE      *BLANKS                                                    CSD027
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 246'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 226'        WArErr(WEx)
     C                   ENDIF
     C                   MOVE      *ON           *IN18
     C                   MOVE      *ON           *IN61
     C                   ELSE
     C                   MOVE      BXDCAC        WFFACOD
     C                   MOVE      BICN          WFFCustP
     C                   Z-ADD     1             WFFACSQ
     C                   MOVE      WScBRCA       WFFBRCB
     C                   ENDIF
 
     C                   ENDIF
 
      ** --------------------- **
      ** Settlement type is 05 **
      ** --------------------- **
 
     C     SWSLT         IFEQ      '05'
 
      ** Must consist of valid Customer, Account and Sequence
     C***********        TESTN                   WDsCSLA              74                      CSD027
     C                   TESTN                   WDssCSLA0712         74                      CSD027
 
     C     *IN74         IFEQ      '0'
     C                   MOVE      *ON           *IN61
     C                   MOVE      *ON           *IN18
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 247'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 227'        WArErr(WEx)
     C                   ENDIF
     C                   ENDIF
 
      ** Customer (WDssCSLA0106) must exist on LF/CLINT
     C     *IN61         IFEQ      '0'
 
     C                   MOVE      WDssCSLA0106  WFFCustP
     C                   MOVE      WDssCSLA0106  KCNUM
     C                   MOVE      'A'           KRCDT
     C     KCLINT        CHAIN     CLINT                              71
     C     *IN71         IFEQ      *ON
     C     RECI          ORNE      'D'
     C                   MOVE      *ON           *IN61
     C                   MOVE      *ON           *IN18
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 247'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 227'        WArErr(WEx)
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Account code (WDssCSLA0710) must exist on standing data file
     C     *IN61         IFEQ      '0'
 
     C                   MOVE      WDssCSLA0710  WFFACOD
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      WDssCSLA0710  PAccCde04A
     C     SDACOD        PARM      SDACOD        DSSDY
     C     PRtnCde07A    IFNE      *BLANKS
     C     PRtnCde07A    OREQ      *BLANKS
     C     A5ACTY        ANDNE     'R'
     C     WWTOFC        ANDEQ     'Y'
     C                   MOVE      *ON           *IN61
     C                   MOVE      *ON           *IN18
     C                   ADD       1             WEx
     C     A5ACTY        IFNE      'R'
     C     WWTOFC        ANDEQ     'Y'
     C                   MOVE      ' 257'        WArErr(WEx)
     C                   ELSE
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 247'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 227'        WArErr(WEx)
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C     A5ACTY        IFEQ      'R'
     C                   MOVE      *ON           *IN73
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      **   Account sequence (WDssCSLA1112) must be greater than zero
     C     *IN61         IFEQ      *OFF
 
     C     WDssCSLA1112  IFLE      '0'
     C                   MOVE      *ON           *IN61
     C                   MOVE      *ON           *IN18
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 247'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 227'        WArErr(WEx)
     C                   ENDIF
     C                   ELSE
     C                   MOVE      WDssCSLA1112  WFFACSQ
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up Settlement branch for type is 05
     C     *IN61         IFEQ      '0'
 
     C     P0MultBrch    IFEQ      'Y'
     C                   MOVE      SWSBR         WFFBRCB
     C                   ELSE
     C                   MOVE      WScBRCA       WFFBRCB
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDIF
 
      ** --------------------- **
      ** Settlement type is 14 **
      ** --------------------- **
 
      ** Must consist of valid Retail Account Number if type is 14
     C     SWSLT         IFEQ      '14'
 
     C                   TESTN                   WDssCSLA0110         74
 
      ** Invalid if first 10 characters not numeric or rest not blank
     C     *IN74         IFEQ      '0'
     C     WDssCSLA1112  ORNE      *BLANKS
     C                   MOVE      *ON           *IN61
     C                   ENDIF
 
      ** Otherwise account number must exist on LF/ACNUM
     C     *IN61         IFEQ      '0'
 
     C                   MOVE      WDssCSLA0110  KAccNum
     C     KAccNum       CHAIN     ACNUM                              71
     C     *IN71         IFEQ      *ON
     C     ACMRECI       ORNE      'D'
     C                   SETON                                        61
     C                   ENDIF
 
      ** If there is no error, set up key fields for later chain
     C     *IN61         IFEQ      '0'
     C                   MOVE      ACMACOD       WFFACOD
     C                   MOVE      ACMCNUM       WFFCustP
     C                   MOVE      ACMACSQ       WFFACSQ
     C                   MOVE      ACMBRCA       WFFBRCB
     C                   ENDIF
      *
     C                   ENDIF
 
      ** Account currency must be the same as Instrument currency
     C     *IN61         IFEQ      *OFF
     C     ACMCCY        ANDNE     ISCY
     C                   MOVE      *ON           *IN61
     C                   ENDIF
 
      ** Set up error code if any error occurred
     C     *IN61         IFEQ      *ON
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 248'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 228'        WArErr(WEx)
     C                   ENDIF
     C                   MOVE      *ON           *IN18
     C                   ENDIF
      *
     C                   ENDIF
 
      ** ---------------------------- **
      ** Settlement branch validation **
      ** ---------------------------- **
 
     C     P0MultBrch    IFEQ      'Y'
 
     C     SWSLT         IFEQ      '05'
 
      ** The Settlement branch must be a valid branch if type is 05
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      SWSBR         PBrch03A
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     PRtnCde07A    IFNE      *BLANKS
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 301'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 300'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        1867
     C                   ENDIF
 
     C                   ELSE
 
      ** The Settlement branch must be blank if settlement <> 05
     C     SWSBR         IFNE      *BLANKS
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 301'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 300'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        1867
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** ------------------ **
      ** Account validation **
      ** ------------------ **
 
      ** The Account must exist and be open if ATYP = 'R' (Retail)
     C     BGRTBN        IFEQ      'Y'
     C     *IN61         ANDEQ     '0'
     C     *IN60         ANDEQ     '0'
     C     *IN67         ANDEQ     '0'
     C     SWSLT         ANDNE     '00'
 
      ** Set up key field for access of TABTE10
     C     SWSLT         IFEQ      '04'
     C     *IN75         IFEQ      *ON
     C                   MOVE      CUSC          WFFCustP
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      BOCO          WFFCustP
     C                   ENDIF
     C                   MOVE      BMACCD        WFFACOD
     C                   MOVE      BMACCD        FFACD2
     C                   Z-ADD     1             WFFACSQ
     C                   MOVE      WFFBRCB       FFBRC2
     C                   ENDIF
 
     C     SWSLT         IFEQ      '06'
     C                   MOVE      BICN          WFFCustP
     C                   MOVE      BKACCD        WFFACOD
     C                   MOVE      BKACCD        FFACD2
     C                   Z-ADD     1             WFFACSQ
     C                   MOVE      WFFBRCB       FFBRC2
     C                   ENDIF
 
     C     SWSLT         IFEQ      '15'
     C     *IN75         IFEQ      *ON
     C                   MOVE      CUSC          WFFCustP
     C                   MOVE      BXDCAC        WFFACOD
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      BOCO          WFFCustP
     C                   MOVE      BXACCD        WFFACOD
     C                   ENDIF
     C                   MOVE      WFFACOD       FFACD2
     C                   Z-ADD     1             WFFACSQ
     C                   MOVE      WFFBRCB       FFBRC2
     C                   ENDIF
 
      ** SDACODPD has already been accessed if type = 05
     C     SWSLT         IFNE      '05'
 
     C                   MOVE      WFFACOD       PAccCde04A
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM                    PAccCde04A
     C     SDACOD        PARM      SDACOD        DSSDY
     C     PRtnCde07A    IFEQ      *BLANKS
     C     A5ACTY        ANDEQ     'R'
     C                   SETON                                        73
     C                   ENDIF
 
     C                   ENDIF
 
      ** Currency is Instrument currency
     C     *IN73         IFEQ      '1'
     C                   MOVE      ISCY          WFFCCY
 
      ** Chain LF/ACCNT to check that live account exists
     C************       Z-ADD     WFFCustP      KCust                                        CSD027
     C                   MOVE      WFFCustP      KCust                                        CSD027
     C                   MOVE      WFFCCY        KCcy
     C                   Z-ADD     WFFACOD       KAccCde
     C                   Z-ADD     WFFACSQ       KAccSeq
     C                   MOVE      WFFBRCB       KBrch
     C     KFullAcc      CHAIN     ACCNT                              71
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     ACTRECI       ANDNE     'D'
     C     *IN71         OREQ      *OFF
     C     ACTACST       ANDEQ     'C'
 
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 249'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 229'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        1861
     C     SWSLT         IFEQ      '05'
     C                   SETON                                        67
     C                   ENDIF
 
      **   If live account does exist, set on MEMOS update indicator
 
     C                   ELSE
 
     C                   MOVE      'Y'           XMIND
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   Transaction date must not be prior to the back value date
 
      **   Calculate business date minus back value period
 
     C     XMIND         IFEQ      'Y'
     C     *IN31         ANDEQ     '0'
 
     C     WCtlDate      SUB       BJBVPD        HOLD              5 0
 
      **   Compare the above result with Date account opened from LF/ACCNT
      **   and check that Transaction date is not prior to the more recent
     C     ACTDACO       SUB       HOLD          HOLD2             5 0  74
     C     *IN74         IFEQ      '1'
 
     C     HOLD          IFGT      OTRSD
     C                   SETON                                        61
     C                   ENDIF
 
     C                   ELSE
     C     ACTDACO       IFGT      OTRSD
     C                   SETON                                        61
     C                   ENDIF
      *
     C                   ENDIF
 
      ** Set up error code if invalid
     C     *IN61         IFEQ      '1'
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 250'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 230'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        18
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVForAccOf- Validate 'For Account of'                       *
      *                                                               *
      *****************************************************************
     C     SRVForAccOf   BEGSR
 
      ** Must be blank unless Settlement type is 01,02,07,08 or 12
     C     SWSLT         IFNE      '01'
     C     SWSLT         ANDNE     '02'
     C     SWSLT         ANDNE     '07'
     C     SWSLT         ANDNE     '08'
     C     SWSLT         ANDNE     '12'
     C     SWFAO         ANDNE     *BLANKS
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 251'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 231'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        1862
     C                   ENDIF
 
      ** Must exist on LF/CLINT or LF/SNAME unless it's blank
     C     *IN62         IFEQ      '0'
     C     SWFAO         ANDNE     *BLANKS
 
      ** Chain LF/CLINT if entry is 6 characters numeric
     C                   MOVEL     SWFAO         WFAO6             6
     C                   MOVE      SWFAO         WFAO4             4
     C**********         TESTN                   WFAO6                74                      CSD027
      *
     C******IN74         IFEQ      '1'                                                        CSD027
     C*****WFAO4         ANDEQ     *BLANKS                                                    CSD027
     C     WFAO4         IFEQ      *BLANKS                                                    CSD027
     C                   MOVE      WFAO6         KCNUM
     C                   MOVE      'A'           KRCDT
     C     KCLINT        CHAIN     CLINT                              71
     C  N71RECI          COMP      'D'                                7171
 
      **   Set up error code if record not found
     C     *IN71         IFEQ      '1'
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 252'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 232'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        1862
     C                   ENDIF
 
      ** Otherwise Chain LF/SNAME
     C                   ELSE
     C     SWFAO         CHAIN     SNAME                              71
     C  N71RECI          COMP      'D'                                7171
 
      ** Set up error code if record not found
     C     *IN71         IFEQ      '1'
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 252'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 232'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        1862
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVCtrPtyNost- Validate Counterparty Nostro                  *
      *                                                               *
      *****************************************************************
     C     SRVCtrPtyNost BEGSR
 
      ** Must be blank unless Settlement type is 01,02,07,08 or 12
     C     SWSLT         IFNE      '01'
     C     SWSLT         ANDNE     '02'
     C     SWSLT         ANDNE     '07'
     C     SWSLT         ANDNE     '08'
     C     SWSLT         ANDNE     '12'
     C     SWCPN         ANDNE     *BLANKS
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 254'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 234'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        1863
     C                   ENDIF
 
      ** Must exist on PF/TABLET2 or on PF/CLINTCB unless it's blank
     C     *IN63         IFEQ      '0'
     C                   MOVEL     SWCPN         SWCPN6            6
     C**********         TESTN                   SWCPN6               19                      CSD027
 
      ** If counterparty nostro is numeric, access LF/CLINT
      ** to check that record exists
     C******IN19         IFEQ      '1'                                                        CSD027
 
     C                   MOVE      SWCPN6        KCNUM
     C                   MOVE      'A'           KRCDT
     C     KCLINT        CHAIN     CLINTCBF                           71
     C**N71RECI*****     COMP      'D'                                7171                    CSD027
     C******IN71****     IFEQ      '1'                                                        CSD027
      * If chain suceeded but RECI not D                                                      CSD027
     C     *IN71         IFEQ      *OFF                                                       CSD027
     C     RECI          ANDNE     'D'                                                        CSD027
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 255'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 235'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        1863
     C                   ENDIF
     C***********        MOVE      '0'           *IN19                                        CSD027
 
      ***Else*counterparty*nostro*is*non-numeric******************                            CSD027
      * If counterparty chain failed above then check to see if this is a cparty nostro       CSD027
     C     *IN71         IFEQ      *ON                                                        CSD027
     C**********         ELSE                                                                 CSD027
 
      ** If counterparty nostro is not blank, access LF/SNAME to
      ** check for customer shortname
     C     SWCPN         IFNE      *BLANK
     C     SWCPN         CHAIN     SNAME                              69
     C  N69RECI          COMP      'D'                                6969
 
      **   If record found, store customer number for this customer
      **   shortname in work field
     C     *IN69         IFEQ      '0'
      *
      **   If broker counterparty nostro being processed, set on
      **   broker shortname needed flag
     C     *IN76         IFEQ      '1'
     C**********         Z-ADD     CNUM          CNUMB             6 0                        CSD027
     C                   MOVE      CNUM          CNUMB             6                          CSD027
     C                   MOVE      'Y'           WBrokeNameFlg
     C                   ENDIF
 
      ** If customer counterparty nostro being processed, set on
      ** customer shortname needed flag
     C     *IN75         IFEQ      '1'
     C**********         Z-ADD     CNUM          CNUMC             6 0                        CSD027
     C                   MOVE      CNUM          CNUMC             6                          CSD027
     C                   MOVE      'Y'           WCustNameFlg
     C                   ENDIF
 
      ** Else access PF/TABLET2 to check for valid counterparty
      ** nostro
     C                   ELSE
 
     C                   MOVE      SWCPN         PChr008
     C                   CALLB     'AOCNSTR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM                    PChr008
     C     SDCNST        PARM      SDCNST        DSFDY
     C     PRtnCde07A    IFNE      *BLANKS
     C                   ADD       1             WEx
     C     *IN75         IFEQ      *ON
     C                   MOVE      ' 255'        WArErr(WEx)
     C                   ENDIF
     C     *IN76         IFEQ      *ON
     C                   MOVE      ' 235'        WArErr(WEx)
     C                   ENDIF
     C                   SETON                                        1863
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdIns   - Update Insert Control                           *
      *                                                               *
      *****************************************************************
     C     SRUpdIns      BEGSR
 
      ** Set up and write LF/TRANS Closing  record
     C                   EXSR      SROutTrans
 
     C     WErOutTrans   IFEQ      'N'
 
      ** If OTC enhancements are switched on
     C     CFF003        IFEQ      'Y'
 
      ** Write FX deal on Closing of an OTC
     C     P0Mkt         IFEQ      *BLANK
     C     ISPT          ANDEQ     5
     C                   CALL      'FF0391'
     C                   PARM      TNBR          ##TNBR            6 0
     C                   PARM      NUCO          ##NUCO            5 0
     C                   PARM      CLSR          ##CLSR            6 0
     C                   PARM      TRSD          ##TRSD            5 0
     C                   PARM      VALD          ##VALD            5 0
     C                   PARM      *BLANK        ##RTCD            7
     C     ##RTCD        IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   Z-ADD     25            DBASE
     C                   MOVEL     'FF0391'      DBFILE
     C                   MOVEL     ##RTCD        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up and write LF/TRSET Closing  record
     C                   EXSR      SROutTRSET
 
      ** Access LF/TRANS Trade record to prepare for update
     C                   MOVE      WScCLSR       KTrans
     C     KTrans        CHAIN     TRANS                              71
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     26            DBASE
     C                   MOVEL     'TRANS'       DBFILE
     C                   MOVEL     KTrans        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Update LF/TRANS Trade record
     C                   EXSR      SRUpdTTRANS
 
      ** - if Trade record changed at another workstation
     C     *IN12         IFEQ      '1'
     C                   SETON                                        11
     C                   ROLBK
     C                   Z-ADD     0             PZDecP
     C                   MOVEL     *BLANK        PZFld16A
     C                   MOVE      NOCO          PZFld16A
     C                   CALLB     'ZEDIT'
     C                   PARM                    PZFld16A
     C                   PARM                    PZDecP
     C                   MOVE      PZFld16A      WScNOCO
     C                   MOVEA     WTbMsg(3)     WScErrLne2
     C                   ENDIF
 
      ** - if Trade record deleted at another workstation
     C     *IN16         IFEQ      '1'
     C                   SETON                                        11
     C                   ROLBK
     C                   MOVEA     WTbMsg(4)     WScErrLne2
     C                   ENDIF
 
      ** Set up and update LF/TRSET Trade record
     C     *IN12         IFEQ      '0'
     C     *IN16         ANDEQ     '0'
 
     C                   EXSR      SRUpdTTRSET
      ** Set up and write record to LF/CLOST
     C                   EXSR      SROutCLOST
      ** Set up and write records to LF/CLOST2
     C                   EXSR      SROutCLOST2
 
      ** Set up and write/update records in LF/MEMOSM
      **
      ** - Customer
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C     CMIND         ANDEQ     'Y'
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
     C                   MOVE      KCNUMC        WFFCustP
     C                   MOVE      KACODC        WFFACOD
     C                   MOVE      KACSQC        WFFACSQ
     C                   MOVE      KBRCAC        WFFBRCB
     C                   EXSR      SRUpdMEMOS
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
      ** Set MEMOSM/PRONOM Update Indicator to 'M' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'M'           MPIND             1
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAC        FOBRCA            3
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
      **   - Broker
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     BMIND         ANDEQ     'Y'
     C                   MOVE      KCNUMB        WFFCustP
     C                   MOVE      KACODB        WFFACOD
     C                   MOVE      KACSQB        WFFACSQ
     C                   MOVE      KBRCAB        WFFBRCB
     C                   EXSR      SRUpdMEMOS
      ** Set MEMOSM/PRONOM Update Indicator to 'M' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'M'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAB        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
      ** Set up and write/update records in LF/PRONOM
      **
      ** - Customer
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C     CPIND         ANDEQ     'Y'
 
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
     C                   MOVE      KNOSNC        KNOSNP
     C                   EXSR      SRUpdPRONO
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
 
     C     CMIND         IFNE      'Y'
      ** Set MEMOSM/PRONOM Update Indicator to 'P' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'P'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAC        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
     C                   ENDIF
 
      ** - Broker
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     BPIND         ANDEQ     'Y'
 
     C                   MOVE      KNOSNB        KNOSNP
     C                   EXSR      SRUpdPRONO
 
     C     BMIND         IFNE      'Y'
      ** Set MEMOSM/PRONOM Update Indicator to 'P' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'P'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAB        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
     C                   ENDIF
 
      ** LF/FOPCC + LF/FOPCK - Positions Profit Centre
     C     BKPRCU        IFEQ      'Y'
     C                   EXSR      SRUpdFOPC
     C                   ENDIF
 
      ** Set up and write records to LF/POSTNC and LF/POSTNK
 
      ** - Calculate Total Transaction Value
     C                   CALLB     'FFTVCL'
     C                   PARM      0             PFTotValP
     C                   PARM      WNCTE         PFContractP
     C                   PARM      COPR          PFPriceP
     C                   PARM      TKDM          PFTckDenomP
     C                   PARM      MNPF          PFMinPriceFlcP
 
     C                   Z-ADD     PFTotValP     WTNVL            13 0
 
      ** LF/POSTNC - Customer
     C     WScCUSC       IFNE      *BLANKS
     C                   EXSR      SRUpdPOSTNC
     C                   ENDIF
 
      ** - Broker
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   EXSR      SRUpdPOSTNC2
     C                   ENDIF
 
      ** LF/POSTNK - Book
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     WScCUSC       ANDEQ     *BLANKS
     C*****BOCO*         OREQ      0                                                          CSD027
     C     BOCO          OREQ      *BLANKS                                                    CSD027
     C     WScCUSC       ANDNE     *BLANKS
     C                   EXSR      SRUpdPOSTNK
     C                   ENDIF
 
      ** Update Transaction Audit file (PF/TRANSA)
     C                   EXSR      SRUpdTRANSAu
      ** End of Commitment Cycle
     C                   COMMIT
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdAmd   - Update Amend Control                            *
      *                                                               *
      *****************************************************************
     C     SRUpdAmd      BEGSR
 
      ** Access LF/TRANS Exercise record
     C                   MOVE      WScTransRef   KTrans
     C     KTrans        CHAIN     TRANS                              71
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     27            DBASE
     C                   MOVEL     'TRANS'       DBFILE
     C                   MOVEL     KTrans        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Rec Updated by Another Wkstn ?
     C     TNLU          IFNE      XTNLU
 
     C     CHTP          IFEQ      'D'
     C                   SETON                                        72
     C                   ENDIF
     C                   EXSR      SRVUpdWrkstn
 
     C                   ELSE
 
      ** Set up and update LF/TRANS Exercise record
     C                   EXSR      SRUpdTRANS
 
      ** Set up & update LF/TRSET Exercise record if EOC not processed
     C     *IN65         IFEQ      '1'
     C                   EXSR      SRUpdTRSET
 
      ** Set up and write/update records in LF/MEMOSM
      ** Calculate Realised P & L using standard SR. SRFFPLCL
     C                   Z-ADD     WNCTE         WFFNOC
     C                   Z-ADD     TKDMX         WFFTKDM
     C                   Z-ADD     TKVLX         WFFTKVL
     C                   Z-ADD     MNPFX         WFFMNPF
     C                   Z-ADD     ISPT          WFFISPT
     C                   Z-ADD     FFCNTT        WFFCNTT
     C                   Z-ADD     FFCTAM        WFFCTAM
 
      ** Which Price is which depends on PCAL
     C     WScPutCall    IFEQ      'C'
     C                   Z-ADD     COPR          WFFPRCX
     C                   Z-ADD     STRPS         WFFPRCY
     C                   ELSE
     C                   Z-ADD     COPR          WFFPRCY
     C                   Z-ADD     STRPS         WFFPRCX
     C                   ENDIF
 
     C                   EXSR      SRFFPLCL
     C                   Z-ADD     WFFPOL        COPLS
 
      ** Write/update records in LF/MEMOSM for reversed out details
      **
      ** - Customer, SRFFSettle to decide if update is required
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      WScBRCA       WFFBRCA
     C**********         Z-ADD     CUSC          WFFCBCD                                      CSD027
     C                   EVAL      WFFCBCD = CUSC                                             CSD027
     C                   MOVE      'N'           WFFBRKI
     C                   MOVE      CSLTS         WFFSETP
     C                   MOVE      CSLAS         WFFSETA
     C                   MOVE      BRSCS         WFFSETB
     C                   EXSR      SRFFSettle
     C                   SETOFF                                       89
     C                   MOVE      WFFPIND       CPIND2            1
     C                   MOVE      WFFNOSN       KNSNC2            2 0
     C                   MOVE      WFFMIND       SAVCMN            1
 
      ** Update LF/MEMOSM if settlement was across a Retail account
     C     WFFMIND       IFEQ      'Y'
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
     C                   EXSR      SRUpdRevMEMOS
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
      ** Set MEMOSM/PRONOM Update Indicator to 'M' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'M'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAC        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
     C                   ENDIF
 
      **   - Broker, SRFFSettle SR to decide if update is required
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
 
     C                   MOVE      WScBRCA       WFFBRCA
     C**********         Z-ADD     BOCO          WFFCBCD                                      CSD027
     C                   EVAL      WFFCBCD = BOCO                                             CSD027
     C                   MOVE      'Y'           WFFBRKI
     C                   MOVE      BSLTS         WFFSETP
     C                   MOVE      BSLAS         WFFSETA
     C                   MOVE      BSBRS         WFFSETB
     C                   EXSR      SRFFSettle
     C                   SETOFF                                       89
     C                   MOVE      WFFPIND       BPIND2            1
     C                   MOVE      WFFNOSN       KNSNB2            2 0
     C                   MOVE      WFFMIND       SAVBMN            1
 
      ** Update LF/MEMOSM if settlement was across a Retail account
     C     WFFMIND       IFEQ      'Y'
     C                   EXSR      SRUpdRevMEMOS
      ** Set MEMOSM/PRONOM Update Indicator to 'M' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'M'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAB        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Write/update records in LF/MEMOSM for new account details
      **
      ** - Customer
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C     CMIND         ANDEQ     'Y'
 
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
     C                   MOVE      KCNUMC        WFFCustP
     C                   MOVE      KACODC        WFFACOD
     C                   MOVE      KACSQC        WFFACSQ
     C                   MOVE      KBRCAC        WFFBRCB
     C                   EXSR      SRUpdMEMOS
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
      ** Set MEMOSM/PRONOM Update Indicator to 'M' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'M'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAC        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
      ** - Broker
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     BMIND         ANDEQ     'Y'
     C                   MOVE      KCNUMB        WFFCustP
     C                   MOVE      KACODB        WFFACOD
     C                   MOVE      KACSQB        WFFACSQ
     C                   MOVE      KBRCAB        WFFBRCB
     C                   EXSR      SRUpdMEMOS
      ** Set MEMOSM/PRONOM Update Indicator to 'M' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'M'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAB        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
      ** Write/update records in LF/PRONOM for reversed out details
      **
      ** - Customer
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C     CPIND2        ANDEQ     'Y'
 
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
     C                   MOVE      KNSNC2        KNOSNP
     C                   EXSR      SRUpdRevPRONO
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
 
     C     SAVCMN        IFNE      'Y'
      ** Set MEMOSM/PRONOM Update Indicator to 'P' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'P'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAC        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
     C                   ENDIF
 
      ** - Broker
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     BPIND2        ANDEQ     'Y'
     C                   MOVE      KNSNB2        KNOSNP
     C                   EXSR      SRUpdRevPRONO
 
     C     SAVBMN        IFNE      'Y'
      ** Set MEMOSM/PRONOM Update Indicator to 'P' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'P'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAB        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Write/update records in LF/PRONOM for new account details
      **
      ** - Customer
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C     CPIND         ANDEQ     'Y'
 
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
     C                   MOVE      KNOSNC        KNOSNP
     C                   EXSR      SRUpdPRONO
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
 
     C     CMIND         IFNE      'Y'
      ** Set MEMOSM/PRONOM Update Indicator to 'P' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'P'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAC        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
     C                   ENDIF
 
      ** - Broker
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     BPIND         ANDEQ     'Y'
 
     C                   MOVE      KNOSNB        KNOSNP
     C                   EXSR      SRUpdPRONO
 
     C     BMIND         IFNE      'Y'
      ** Set MEMOSM/PRONOM Update Indicator to 'P' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'P'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAB        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Update Transaction Audit file (PF/TRANSA)
     C                   EXSR      SRUpdTRANSAu
 
      ** End of Commitment Cycle
     C                   COMMIT
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdDel   -  Update Delete Control                          *
      *                                                               *
      *****************************************************************
     C     SRUpdDel      BEGSR
 
     C                   MOVE      ISCY          KCCY
 
      **   Access LF/TRANS Closing  record
     C                   MOVE      WScTransRef   KTrans
     C     KTrans        CHAIN     TRANS                              71
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     28            DBASE
     C                   MOVEL     'TRANS'       DBFILE
     C                   MOVEL     KTrans        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     CUSC          WCust10A
     C                   MOVEL     BOCO          WBOCO
     C                   ENDIF
 
      **   Rec Upd by Another Wkstn ?
     C     TNLU          IFNE      XTNLU
      *
     C     CHTP          IFEQ      'D'
     C                   SETON                                        72
     C                   ENDIF
     C                   EXSR      SRVUpdWrkstn
 
     C                   ELSE
 
      **   Set up and update LF/TRANS Closing  record
     C                   EXSR      SRUpdTRANS
 
      **   Set up and update LF/TRSET Closing  record
     C                   EXSR      SRUpdTRSET
 
      **   Access LF/TRANS Trade record to prepare for update
     C                   MOVE      WScCLSR       KTrans
     C     KTrans        CHAIN     TRANS                              71
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     29            DBASE
     C                   MOVEL     'TRANS'       DBFILE
     C                   MOVEL     KTrans        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **   Access LF/FOCLT record if broker is present
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     BOCO          CHAIN     FOCLT                              71
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     30            DBASE
     C                   MOVEL     'FOCLT'       DBFILE
     C                   MOVEL     BOCO          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      **   Update LF/TRANS Trade record
     C                   EXSR      SRUpdTTRANS
 
      **   Set up and update LF/TRSET Trade record
     C                   EXSR      SRUpdTTRSET
 
      **   Set up and update LF/CLOST record
     C                   EXSR      SRUpdCLOST
 
      **   Write/update records in LF/MEMOSM for reversed out details
      **
      **   - Customer, SRFFSettle SR to decide if update is required
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
 
     C                   MOVE      WScBRCA       WFFBRCA
     C**********         Z-ADD     CUSC          WFFCBCD                                      CSD027
     C                   EVAL      WFFCBCD = CUSC                                             CSD027
     C                   MOVE      'N'           WFFBRKI
     C                   MOVE      CSLTS         WFFSETP
     C                   MOVE      CSLAS         WFFSETA
     C                   MOVE      BRSCS         WFFSETB
     C                   EXSR      SRFFSettle
     C                   SETOFF                                       89
     C                   MOVE      WFFPIND       CPIND2            1
     C                   MOVE      WFFNOSN       KNSNC2            2 0
     C                   MOVE      WFFMIND       SAVCMN            1
 
      ** Update LF/MEMOSM if settlement was across a Retail account
     C     WFFMIND       IFEQ      'Y'
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
     C                   EXSR      SRUpdRevMEMOS
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
      ** Set MEMOSM/PRONOM Update Indicator to 'M' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'M'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      WFFBRCB       FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
     C                   ENDIF
 
      **   - Broker, SRFFSettle SR to decide if update is required
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
 
     C                   MOVE      WScBRCA       WFFBRCA
     C**********         Z-ADD     BOCO          WFFCBCD                                      CSD027
     C                   EVAL      WFFCBCD = BOCO                                             CSD027
     C                   MOVE      'Y'           WFFBRKI
     C                   MOVE      BSLTS         WFFSETP
     C                   MOVE      BSLAS         WFFSETA
     C                   MOVE      BSBRS         WFFSETB
     C                   EXSR      SRFFSettle
     C                   SETOFF                                       89
     C                   MOVE      WFFPIND       BPIND2            1
     C                   MOVE      WFFNOSN       KNSNB2            2 0
     C                   MOVE      WFFMIND       SAVBMN            1
 
      ** Update LF/MEMOSM if settlement was across a Retail account
     C     WFFMIND       IFEQ      'Y'
     C                   EXSR      SRUpdRevMEMOS
      ** Set MEMOSM/PRONOM Update Indicator to 'M' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'M'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      WFFBRCB       FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Write/update records in LF/PRONOM for reversed out details
      **
      ** - Customer
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C     CPIND2        ANDEQ     'Y'
 
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
     C                   MOVE      KNSNC2        KNOSNP
     C                   EXSR      SRUpdRevPRONO
     C   14PRMPS         MULT      -1            PRMPS
     C   14COPLS         MULT      -1            COPLS
 
     C     SAVCMN        IFNE      'Y'
      ** Set MEMOSM/PRONOM Update Indicator to 'P' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'P'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAC        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
     C                   ENDIF
 
      **   - Broker
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     BPIND2        ANDEQ     'Y'
 
     C                   MOVE      KNSNB2        KNOSNP
     C                   EXSR      SRUpdRevPRONO
 
     C     SAVBMN        IFNE      'Y'
      ** Set MEMOSM/PRONOM Update Indicator to 'P' (used in
      ** SR/SROutFFACMVD)
     C                   MOVE      'P'           MPIND
      ** Set up branch code for update of PF/FFACMVD.
     C                   MOVE      KBRCAB        FOBRCA
      ** Write record to PF/FFACMVD
     C                   EXSR      SROutFFACMVD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up and write records to LF/POSTNC and LF/POSTNK
      **
      ** - Calculate Total Transaction Value
     C                   Z-ADD     WNCTE         PFContractP
     C                   Z-ADD     COPR          PFPriceP
     C                   Z-ADD     TKDM          PFTckDenomP
     C                   Z-ADD     MNPF          PFMinPriceFlcP
 
     C                   CALLB     'FFTVCL'
     C                   PARM      *ZERO         PFTotValP
     C                   PARM                    PFContractP
     C                   PARM                    PFPriceP
     C                   PARM                    PFTckDenomP
     C                   PARM                    PFMinPriceFlcP
     C                   Z-ADD     PFTotValP     WTNVL            13 0
 
      **    LF/POSTNC - Customer
     C     WScCUSC       IFNE      *BLANKS
     C                   EXSR      SRUpdPOSTNC
     C                   ENDIF
 
      **    - Broker
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   EXSR      SRUpdPOSTNC2
     C                   ENDIF
 
      **    LF/POSTNK - Book
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     WScCUSC       ANDEQ     *BLANKS
     C*****BOCO*         OREQ      0                                                          CSD027
     C     BOCO          OREQ      *BLANKS                                                    CSD027
     C     WScCUSC       ANDNE     *BLANKS
     C                   EXSR      SRUpdPOSTNK
     C                   ENDIF
 
      **   Update Transaction Audit file (PF/TRANSA)
     C                   EXSR      SRUpdTRANSAu
 
      **   End of Commitment Cycle
     C                   COMMIT
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROutTrans - Write record to LF/TRANS.                       *
      *                                                               *
      *****************************************************************
     C     SROutTrans    BEGSR
 
     C                   MOVE      'N'           WErOutTrans
      **   Set up fields for output of record to LF/TRANS
     C                   MOVE      'D'           RECI
     C                   MOVE      WScTransRef   TNBR
     C                   MOVE      WScBRCA       BRCA
     C                   MOVEL     WCust10A      CUSC
     C                   MOVE      WScBOKC       BOKC
     C                   MOVE      ISTT          ISTT
     C                   MOVE      WScPutCall    PCAL
     C                   Z-ADD     WSTRP         STRP
 
     C     WScTRTY       IFEQ      'S'
     C                   MOVE      'P'           TRTY
     C                   ELSE
     C                   MOVE      'S'           TRTY
     C                   ENDIF
 
     C                   MOVE      *BLANKS       ULTT
     C                   MOVE      OTRSD         TRSD
     C                   Z-ADD     WNCTE         NUCO
     C                   Z-ADD     0             NOCO
     C                   Z-ADD     0             NOBO
     C                   Z-ADD     WEXPR         COPR
     C                   MOVE      WScTNAR       TNAR
     C                   MOVE      'N'           TBLO
     C                   Z-ADD     0             LNKR
     C                   MOVE      WScCLSR       CLSR
     C                   MOVE      'N'           ECPI
     C                   MOVE      ISCY          ISCY
     C                   MOVE      'N'           CBPI
     C                   Z-ADD     0             FCDA
     C                   MOVE      'N'           FCIN
     C                   MOVE      ORBR          ORBR
     C                   MOVE      PRFC          PRFC
     C                   Z-ADD     WCtlDate      LCD
     C                   MOVE      'I'           CHTP
     C                   Z-ADD     PZNxtTransP   TNLU
     C                   MOVE      BPRC          BPRC
     C                   MOVE      TPRC          TPRC
 
     C                   Z-ADD     WVALD         VALD
     C     CFF003        IFEQ      'Y'
     C     P0Mkt         ANDEQ     *BLANKS
     C                   Z-ADD     OVALD         VALD
     C                   ENDIF
 
      ** Move Run date into 'Original Entry date'
     C                   Z-ADD     P0RunDay      ORED
 
      **   Some fields are output differently for OTC's and Market Inst's
      **
      **   - Market instrument
     C     P0Mkt         IFNE      '  '
     C                   MOVEL     WBOCO         BOCO
     C                   MOVE      #4YRNO        YRNO
     C                   MOVE      MTHN          MTHN
      **   - O.T.C.
     C                   ELSE
     C**********         Z-ADD     0             BOCO                                         CSD027
     C                   EVAL      BOCO = *BLANKS                                             CSD027
     C                   Z-ADD     0             YRNO
     C                   Z-ADD     0             MTHN
     C                   ENDIF
 
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      'N'           FBIN
     C                   ELSE
     C                   MOVE      'Y'           FBIN
     C                   ENDIF
 
      **   Portfolio management module is installed
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDNE     'B'
 
      **   If the display field is equal to the "reference attached to
      **   9997 portfolio"
     C     WScPTFR       IFEQ      FCR997
     C     WScPTFR       ANDNE     *BLANKS
     C                   MOVEL     '9997'        PTFR
     C                   ELSE
     C                   MOVEL     WScPTFR       PTFR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Set up new fields on PF/TRANSD
     C                   MOVE      'N'           ACNI
     C                   Z-ADD     0             MABK
     C                   Z-ADD     0             MACU
     C                   Z-ADD     0             CUUN
     C                   Z-ADD     0             UNPL
     C                   Z-ADD     0             UPLS
     C                   MOVE      *BLANKS       MHEX
 
      **   Write record to LF/TRANS
     C                   WRITE     TRANSDF                              71
      ** If write fails - Rollback and discontinue updates
     C     *IN71         IFEQ      *ON
     C                   SETOFF                                       1415
     C                   MOVE      'Y'           WErOutTrans
     C                   EXSR      SRVUpdWrkstn
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROutTRSET - Write record to  LF/TRSET                       *
      *                                                               *
      *****************************************************************
     C     SROutTRSET    BEGSR
 
      **  Set up fields for output to LF/TRSET
     C                   MOVE      'D'           RECI
     C                   MOVE      WScTransRef   TNBR
     C                   MOVE      'N'           CMCB
     C                   MOVE      'N'           CHCB
     C                   MOVE      'N'           CMCC
     C                   MOVE      'N'           CHCC
     C                   Z-ADD     0             OCSB
     C                   Z-ADD     0             OCDB
     C                   Z-ADD     0             CPSB
     C                   Z-ADD     0             CPDB
     C                   Z-ADD     0             OCSC
     C                   Z-ADD     0             OCDC
     C                   Z-ADD     0             CPSC
     C                   Z-ADD     0             CPDC
 
      **   Data output to next four fields depends on Transaction Dates
      **   of Trade and Closing  and whether Broker/Customer is present
      **
      **   - Dates are the same:
     C     *IN78         IFEQ      '1'
 
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     PSCIS         ANDEQ     'N'
     C                   Z-ADD     0             CCSB
     C                   Z-ADD     WNCTE         CCDB
     C                   ELSE
     C                   Z-ADD     0             CCSB
     C                   Z-ADD     0             CCDB
     C                   ENDIF
 
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   Z-ADD     0             CCSC
     C                   Z-ADD     WNCTE         CCDC
     C                   ELSE
     C                   Z-ADD     0             CCSC
     C                   Z-ADD     0             CCDC
     C                   ENDIF
 
      **   - Dates are different:
     C                   ELSE
 
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     PSCIS         ANDEQ     'N'
     C                   Z-ADD     0             CCDB
     C                   Z-ADD     WNCTE         CCSB
     C                   ELSE
     C                   Z-ADD     0             CCSB
     C                   Z-ADD     0             CCDB
     C                   ENDIF
 
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   Z-ADD     0             CCDC
     C                   Z-ADD     WNCTE         CCSC
     C                   ELSE
     C                   Z-ADD     0             CCDC
     C                   Z-ADD     0             CCSC
     C                   ENDIF
 
     C                   ENDIF
 
      ** Use the strike price in the Premium calculation
      ** for processing type 8
     C     ISPT          IFEQ      8
     C                   Z-ADD     STRPS         PFPriceP
      ** for other types of options use the contract price
     C                   ELSE
     C                   Z-ADD     WEXPR         PFPriceP
     C                   ENDIF
 
     C                   CALLB     'FFPMCL'
     C                   PARM      0             PFPremiumP
     C                   PARM      WNCTE         PFContractP
     C                   PARM                    PFPriceP
     C                   PARM      TKDM          PFTckDenomP
     C                   PARM      MNPF          PFMinPriceFlcP
     C                   PARM      TKVL          PFTckValP
     C                   PARM                    PFInsTypS
     C                   PARM                    PFCntrctTypS
     C                   PARM                    PFCntngntAmtP
     C                   PARM      STRP          PFSTRP                                       215528
 
      ** For processing type 8, multiply the amount calculated
      ** by the contract price.
     C     ISPT          IFEQ      8
     C                   MULT      WEXPR         PFPremiumP
     C                   ENDIF
     C                   Z-ADD     PFPremiumP    PRMP
     C     PUPF          IFEQ      'N'
     C                   Z-ADD     PRMP          PRMPS            13 0
     C                   ELSE
     C                   Z-ADD     0             PRMPS
     C                   ENDIF
 
      **   Broker Settlement details
     C     #4BOCO        IFNE      *BLANK
     C     #4BOCO        ANDNE     '*'
 
      **   If an amount is entered, set pattern to 'A'
     C     #4BCMA        IFEQ      'A'
     C     WBCMA         ORNE      0
 
     C                   MOVE      'A'           BCPT
 
     C                   ELSE
 
      **   If codes are entered, use default pattern
     C     WSBCM         IFNE      '    '
     C                   MOVE      WBCPT         BCPT
      **   If default pattern is blank, set pattern to 'A'
     C     BCPT          IFEQ      ' '
     C                   MOVE      'A'           BCPT
     C                   ENDIF
      **   If neither amount nor codes entered, set pattern to blank
     C                   ELSE
     C                   MOVE      ' '           BCPT
     C                   ENDIF
 
     C                   ENDIF
 
      **   Set up other fields from the screen entries
     C                   MOVE      #4BCMC        BCMC
     C                   MOVE      #4BCMS        BCMS
     C                   Z-ADD     WBCMA         BCMA
     C                   MOVE      #4BCHC        BCHC
     C                   Z-ADD     WBCHA         BCHA
     C                   MOVE      #4BSLT        BSLT
     C                   MOVE      WBSLA         BSLA
     C                   MOVE      WBSBR         BSBR
     C                   MOVE      WBBID         BBID
     C                   MOVE      #4BFAO        BFAO
 
      **   If broker shortname needed flag set on, write customer
      **   number for shortname to file, else write screen field
      **   to file
     C     WBrokeNameFlg IFEQ      'Y'
     C                   MOVEL     CNUMB         BCPN
     C                   MOVE      'N'           WBrokeNameFlg
     C                   ELSE
     C                   MOVEL     #4BCPN        BCPN
     C                   ENDIF
 
     C     BBPRBA        IFEQ      'Y'
 
     C     BCMC          IFNE      *ZEROS
     C     BCMA          ANDNE     *ZEROS
     C                   MOVE      'Y'           CMCB
     C                   ELSE
     C                   MOVE      'N'           CMCB
     C                   ENDIF
 
     C     BCHC          IFNE      *ZEROS
     C     BCHA          ANDNE     *ZEROS
     C                   MOVE      'Y'           CHCB
     C                   ELSE
     C                   MOVE      'N'           CHCB
     C                   ENDIF
 
     C                   ENDIF
 
      **   Blank/zeroise fields if Broker not present
     C                   ELSE
 
     C                   MOVE      ' '           BCPT
     C                   Z-ADD     0             BCMC
     C                   Z-ADD     0             BCMS
     C                   Z-ADD     0             BCMA
     C                   Z-ADD     0             BCHC
     C                   Z-ADD     0             BCHA
     C                   Z-ADD     0             BSLT
     C                   MOVE      *BLANK        BSLA
     C                   MOVE      *BLANK        BSBR
     C                   MOVE      *BLANK        BBID
     C                   MOVE      *BLANK        BFAO
     C                   MOVE      *BLANK        BCPN
 
     C                   ENDIF
 
     C                   Z-ADD     0             BMAR
     C                   Z-ADD     0             BCHP
     C                   Z-ADD     0             BCMP
 
      **   Customer Settlement details
     C     WScCUSC       IFNE      *BLANK
 
      **   If an amount is entered, set pattern to 'A'
     C     WScCCMA       IFEQ      'A'
     C     WCCMA         ORNE      0
     C                   MOVE      'A'           CCPT
     C                   ELSE
 
      **   If codes are entered, use default pattern
     C     WSCCM         IFNE      '    '
     C                   MOVE      WCCPT         CCPT
      **   If default pattern is blank, set pattern to 'A'
     C     CCPT          IFEQ      ' '
     C                   MOVE      'A'           CCPT
     C                   ENDIF
      **   If neither amount nor codes entered, set pattern to blank
     C                   ELSE
     C                   MOVE      ' '           CCPT
     C                   ENDIF
 
     C                   ENDIF
 
      **   Set up other fields from the screen entries
     C                   MOVE      WScCCMC       CCMC
     C                   MOVE      WScCCMS       CCMS
     C                   Z-ADD     WCCMA         CCMA
     C                   MOVE      WScCCHC       CCHC
     C                   Z-ADD     WCCHA         CCHA
     C                   MOVE      WScCSLT       CSLT
     C                   MOVE      WCSLA         CSLA
     C                   MOVE      WCSBR         BRSC
     C                   MOVE      WCBID         CBID
     C                   MOVE      WScCFAO       CFAO
 
      **   If customer shortname needed flag set on, write customer
      **   number for shortname to file, else write screen field
      **   to file
     C     WCustNameFlg  IFEQ      'Y'
     C                   MOVEL     CNUMC         CCPN
     C                   MOVE      'N'           WCustNameFlg
     C                   ELSE
     C                   MOVEL     WScCCPN       CCPN
     C                   ENDIF
 
     C     BBPRBA        IFEQ      'Y'
 
     C     CCMC          IFNE      *ZEROS
     C     CCMA          ANDNE     *ZEROS
     C                   MOVE      'Y'           CMCC
     C                   ELSE
     C                   MOVE      'N'           CMCC
     C                   ENDIF
 
     C     CCHC          IFNE      *ZEROS
     C     CCHA          ANDNE     *ZEROS
     C                   MOVE      'Y'           CHCC
     C                   ELSE
     C                   MOVE      'N'           CHCC
     C                   ENDIF
 
     C                   ENDIF
 
      **   Blank/zeroise fields if Customer not present
     C                   ELSE
 
     C                   MOVE      ' '           CCPT
     C                   Z-ADD     0             CCMC
     C                   Z-ADD     0             CCMS
     C                   Z-ADD     0             CCMA
     C                   Z-ADD     0             CCHC
     C                   Z-ADD     0             CCHA
     C                   Z-ADD     0             CSLT
     C                   MOVE      *BLANK        CSLA
     C                   MOVE      *BLANK        BRSC
     C                   MOVE      *BLANK        CBID
     C                   MOVE      *BLANK        CFAO
     C                   MOVE      *BLANK        CCPN
 
     C                   ENDIF
 
     C                   Z-ADD     0             CMAR
     C                   Z-ADD     0             CCHP
     C                   Z-ADD     0             CCMP
 
      **   Write new record to LF/TRSET
     C                   WRITE     TRSETDF
 
      ** If Online Printing of Advice is on and is set in the system,                         CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                             AND PSysVal = 'Y'                                          CRE020
                                                                                              CRE020
      ** Check if system value for the maintenance is on                                      CRE020
      ** if so, update READVCPD                                                               CRE020
                                                                                              CRE020
     C                   EXSR      SrUpdAdvice                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdTRANS - Update LF/TRANS main                            *
      *                                                               *
      *****************************************************************
     C     SRUpdTRANS    BEGSR
 
      **   Amend - Update Narrative and control fields on LF/TRANS
     C     WScActn       IFEQ      'A'
     C                   MOVE      WScTNAR       TNAR
     C     XLCD          IFNE      WCtlDate
     C                   MOVE      'A'           CHTP
     C                   ENDIF
      **   Delete - Update RECI and control fields on LF/TRANS
     C                   ELSE
     C                   MOVE      '*'           RECI
     C                   MOVE      'D'           CHTP
     C                   ENDIF
 
     C                   Z-ADD     WCtlDate      LCD
     C                   Z-ADD     PZNxtTransP   TNLU
 
      **   Update record
     C                   EXCEPT    ETRANS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdTRSET - Update LF/TRSET main                            *
      *                                                               *
      *****************************************************************
     C     SRUpdTRSET    BEGSR
 
      **   Access LF/TRSET main
     C     KTrans        CHAIN     TRSET                              71
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     31            DBASE
     C                   MOVEL     'TRSET'       DBFILE
     C                   MOVEL     KTrans        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     PUPF          IFEQ      'N'
     C                   Z-ADD     PRMP          PRMPS
     C                   ELSE
     C                   Z-ADD     0             PRMPS
     C                   ENDIF
 
      **   Delete
     C     WScActn       IFEQ      'D'
 
     C                   MOVE      '*'           RECI
     C                   EXCEPT    DTRSET
 
      ** If Online Printing of Advice is on and is set in the system,                         CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                             AND PSysVal = 'Y'                                          CRE020
                                                                                              CRE020
      ** Check if system value for the maintenance is on                                      CRE020
      ** if so, update READVCPD                                                               CRE020
                                                                                              CRE020
     C                   EXSR      SrUpdAdvice                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      **   Amend
     C                   ELSE
 
      **   - Broker Settlement details
     C     #4BOCO        IFNE      *BLANK
 
      **   If an amount is entered, set pattern to 'A'
     C     #4BCMA        IFEQ      'A'
     C     WBCMA         ORNE      0
 
     C                   MOVE      'A'           BCPT
     C                   ELSE
 
      **   If codes are entered, use default pattern
     C     WSBCM         IFNE      '    '
     C                   EXSR      SRBrkComPat
     C                   MOVE      WBCPT         BCPT
      **   If default pattern is blank, set pattern to 'A'
     C     BCPT          IFEQ      ' '
     C                   MOVE      'A'           BCPT
     C                   ENDIF
      **   If neither amount nor codes entered, set pattern to blank
     C                   ELSE
     C                   MOVE      ' '           BCPT
     C                   ENDIF
 
     C                   ENDIF
 
      **   Set up other fields from the screen entries
     C                   MOVE      #4BCMC        BCMC
     C                   MOVE      #4BCMS        BCMS
     C                   Z-ADD     WBCMA         BCMA
     C                   MOVE      #4BCHC        BCHC
     C                   Z-ADD     WBCHA         BCHA
     C                   MOVE      #4BSLT        BSLT
     C                   MOVE      WBSLA         BSLA
     C                   MOVE      WBSBR         BSBR
     C                   MOVE      WBBID         BBID
     C                   MOVE      #4BFAO        BFAO
 
      **   If broker shortname needed flag set on, write customer
      **   number for shortname to file, else write screen field
      **   to file
     C     WBrokeNameFlg IFEQ      'Y'
     C                   MOVEL     CNUMB         BCPN
     C                   MOVE      'N'           WBrokeNameFlg
     C                   ELSE
     C                   MOVEL     #4BCPN        BCPN
     C                   ENDIF
 
     C     BBPRBA        IFEQ      'Y'
 
     C     BCMC          IFNE      *ZEROS
     C     BCMA          ANDNE     *ZEROS
     C                   MOVE      'Y'           CMCB
     C                   ELSE
     C                   MOVE      'N'           CMCB
     C                   ENDIF
 
     C     BCHC          IFNE      *ZEROS
     C     BCHA          ANDNE     *ZEROS
     C                   MOVE      'Y'           CHCB
     C                   ELSE
     C                   MOVE      'N'           CHCB
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **     - Customer Settlement details
     C     WScCUSC       IFNE      *BLANK
 
      **   If an amount is entered, set pattern to 'A'
     C     WScCCMA       IFEQ      'A'
     C     WCCMA         ORNE      0
     C                   MOVE      'A'           CCPT
     C                   ELSE
 
      **   If codes are entered, use default pattern
     C     WSCCM         IFNE      '    '
     C                   EXSR      SRCustComPat
     C                   MOVE      WCCPT         CCPT
      **   If neither amount nor codes entered, set pattern to blank
     C     CCPT          IFEQ      ' '
     C                   MOVE      'A'           CCPT
     C                   ENDIF
      **   If neither amount nor codes entered, set pattern to blank
     C                   ELSE
     C                   MOVE      ' '           CCPT
     C                   ENDIF
 
     C                   ENDIF
 
      **   Set up other fields from the screen entries
     C                   MOVE      WScCCMC       CCMC
     C                   MOVE      WScCCMS       CCMS
     C                   Z-ADD     WCCMA         CCMA
     C                   MOVE      WScCCHC       CCHC
     C                   Z-ADD     WCCHA         CCHA
     C                   MOVE      WScCSLT       CSLT
     C                   MOVE      WCSLA         CSLA
     C                   MOVE      WCSBR         BRSC
     C                   MOVE      WCBID         CBID
     C                   MOVE      WScCFAO       CFAO
 
      **   If customer shortname needed flag set on, write customer
      **   number for shortname to file, else write screen field
      **   to file
     C     WCustNameFlg  IFEQ      'Y'
     C                   MOVEL     CNUMC         CCPN
     C                   MOVE      'N'           WCustNameFlg
     C                   ELSE
     C                   MOVEL     WScCCPN       CCPN
     C                   ENDIF
 
     C     BBPRBA        IFEQ      'Y'
 
     C     CCMC          IFNE      *ZEROS
     C     CCMA          ANDNE     *ZEROS
     C                   MOVE      'Y'           CMCC
     C                   ELSE
     C                   MOVE      'N'           CMCC
     C                   ENDIF
 
     C     CCHC          IFNE      *ZEROS
     C     CCHA          ANDNE     *ZEROS
     C                   MOVE      'Y'           CHCC
     C                   ELSE
     C                   MOVE      'N'           CHCC
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   Update record
     C                   UPDATE    TRSETDF
 
      ** If Online Printing of Advice is on and is set in the system,                         CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                             AND PSysVal = 'Y'                                          CRE020
                                                                                              CRE020
      ** Check if system value for the maintenance is on                                      CRE020
      ** if so, update READVCPD                                                               CRE020
                                                                                              CRE020
     C                   EXSR      SrUpdAdvice                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBrkComPat- Access Broker Commission Pattern for Amend      *
      *                                                               *
      *****************************************************************
     C     SRBrkComPat   BEGSR
 
      ** Access  Broker Defaults from LF/DEFLT
     C                   MOVEL     #4BOCO        KCBCD
     C     KDEFLT        CHAIN     DEFLT                              71
     C  N71RECI          COMP      'D'                                7171
 
     C     *IN71         IFEQ      '0'
     C     CPAT          ANDNE     ' '
      ** - from LF/DEFLT
     C                   MOVE      CPAT          WBCPT
     C                   ELSE
      ** - from LF/INTYP
     C                   MOVE      BCPTX         WBCPT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCustComPat- Access Customer Commission Pattern for Amend   *
      *                                                               *
      *****************************************************************
     C     SRCustComPat  BEGSR
 
      **   Access Customer Defaults from LF/DEFLT
     C                   MOVEL     WScCUSC       KCBCD
     C     KDEFLT        CHAIN     DEFLT                              71
     C  N71RECI          COMP      'D'                                7171
 
     C     *IN71         IFEQ      '0'
     C     CPAT          ANDNE     ' '
      **   - from LF/DEFLT
     C                   MOVE      CPAT          WCCPT
     C                   ELSE
      **   - from LF/INTYP
     C                   MOVE      CCPTX         WCCPT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdTTRANS- Update LF/TRANS Trade record                    *
      *                                                               *
      *****************************************************************
     C     SRUpdTTRANS   BEGSR
 
      **   Calculate number of open contracts
      **
      **   - Insert
     C                   SETOFF                                       1216
     C     WScActn       IFEQ      'I'
 
     C     RECI          COMP      '*'                                    16
     C     NOCO          SUB       WNCTE         WNOCO             5 0  1279
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     PSCIS         ANDEQ     'N'
     C     NOBO          SUB       WNCTE         WNOBO             5 0
     C                   ELSE
     C                   Z-ADD     NOBO          WNOBO
     C                   ENDIF
 
      **   - Delete
     C                   ELSE
 
     C     OTRSD         COMP      TRSD                                   78
     C     NOCO          ADD       WNCTE         NOCO
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     PSCI          ANDEQ     'N'
     C     NOBO          ADD       WNCTE         NOBO
     C                   ENDIF
 
     C                   ENDIF
 
      **   Update Relevant fields on LF/TRANS Trade record
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   MOVE      'N'           FBIN
     C                   ENDIF
     C                   MOVE      'N'           FCIN
     C                   Z-ADD     PZNxtTransP   TNLU
 
      **   Update record
     C     *IN12         IFEQ      '0'
     C     *IN16         ANDEQ     '0'
     C     WScActn       IFEQ      'I'
     C                   Z-ADD     WNOCO         NOCO
     C                   Z-ADD     WNOBO         NOBO
     C                   ENDIF
     C                   EXCEPT    TTRANS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdTTRSET     - Update LF/TRSET Trade record               *
      *                                                               *
      *****************************************************************
     C     SRUpdTTRSET   BEGSR
 
      **   Access LF/TRSET Trade record
     C     KTrans        CHAIN     TRSET                              71
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     32            DBASE
     C                   MOVEL     'TRSET'       DBFILE
     C                   MOVEL     KTrans        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     BMAR          XBMAR            13 0
     C                   Z-ADD     CMAR          XCMAR            13 0
 
      **   Insert
     C     WScActn       IFEQ      'I'
 
      **   Output depends on Transaction Dates of Trade and Closing
      **   - and on whether a Customer is present
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C     *IN78         IFEQ      '0'
     C     OCSC          ADD       WNCTE         OCSC
     C                   ELSE
     C     OCDC          ADD       WNCTE         OCDC
     C                   ENDIF
     C                   ENDIF
 
      **   - and on whether a Broker is present
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     PSCIS         ANDEQ     'N'
     C     *IN78         IFEQ      '0'
     C     OCSB          ADD       WNCTE         OCSB
     C                   ELSE
     C     OCDB          ADD       WNCTE         OCDB
     C                   ENDIF
     C                   ENDIF
 
      **   If Trade is now fully closed out, zeroise margins unless
      **   they are negative
     C     *IN79         IFEQ      '1'
     C     BMAR          IFGT      0
     C                   Z-ADD     0             BMAR
     C                   ENDIF
     C     CMAR          IFGT      0
     C                   Z-ADD     0             CMAR
     C                   ENDIF
     C                   ENDIF
 
      **   Delete
      **
      **   Output depends on Transaction Dates of Trade and Closing
     C                   ELSE
      *
      **   - and on whether a Customer is present
      *
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C     *IN78         IFEQ      '0'
     C     OCSC          SUB       WNCTE         OCSC
     C                   ELSE
     C     OCDC          SUB       WNCTE         OCDC
     C                   ENDIF
     C                   ENDIF
 
      **   - and on whether a Broker is present
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     PSCI          ANDEQ     'N'
     C     *IN78         IFEQ      '0'
     C     OCSB          SUB       WNCTE         OCSB
     C                   ELSE
     C     OCDB          SUB       WNCTE         OCDB
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      **   Update record
     C                   EXCEPT    TTRSET
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROutCLOST - Write LF/CLOST record                           *
      *                                                               *
      *****************************************************************
     C     SROutCLOST    BEGSR
 
      **   Access DTAARA/NACON Next available Close-out number
     C     *LOCK         IN        NACON
     C                   Z-ADD     NCON          CLON
     C                   ADD       1             NCON
     C                   OUT       NACON
 
      **   Set up fields for output
     C                   MOVE      WScBRCA       BRCA
     C                   MOVEL     WCust10A      CUSC
 
     C     #4BOCO        IFNE      *BLANKS
     C     WScCUSC       ANDNE     *BLANKS
     C                   MOVE      *BLANKS       BOKC
     C                   ELSE
     C                   MOVE      WScBOKC       BOKC
     C                   ENDIF
 
     C                   MOVE      ISTT          ISTT
     C                   MOVE      WScPutCall    PCAL
     C                   Z-ADD     WSTRP         STRP
     C                   MOVE      ISCY          ISCY
     C                   Z-ADD     WCtlDate      CLOD
     C                   MOVE      'Y'           CLOT
     C                   MOVE      'N'           CORI
     C                   MOVE      'Y'           SHPI
     C                   MOVE      'N'           ECPI
 
      **   Calculate Realised P & L using standard SR. SRFFPLCL
     C                   Z-ADD     WNCTE         WFFNOC
     C                   Z-ADD     TKDMX         WFFTKDM
     C                   Z-ADD     TKVLX         WFFTKVL
     C                   Z-ADD     MNPFX         WFFMNPF
     C                   Z-ADD     ISPT          WFFISPT
     C                   Z-ADD     FFCNTT        WFFCNTT
     C                   Z-ADD     FFCTAM        WFFCTAM
 
      **   Which Price is which depends on PCAL
     C                   Z-ADD     WEXPR         WFFPRCX
     C                   Z-ADD     COPRS         WFFPRCY
     C                   EXSR      SRFFPLCL
     C                   Z-ADD     WFFPOL        COPL
     C                   Z-ADD     WFFPOL        COPLS
     C     WScTRTY       IFEQ      'S'
     C     WScPutCall    ANDEQ     'C'
     C                   Z-SUB     WFFPOL        COPL
     C                   Z-SUB     WFFPOL        COPLS
     C                   ENDIF
 
      **   Some fields are output differently for OTC's and Market Inst's
      **
      **   - Market instrument
     C     P0Mkt         IFNE      '  '
     C                   MOVEL     WBOCO         BOCO
     C                   MOVE      #4YRNO        YRNO
     C                   MOVE      MTHN          MTHN
      **   - O.T.C.
     C                   ELSE
     C**********         Z-ADD     0             BOCO                                         CSD027
     C                   EVAL      BOCO = *BLANKS                                             CSD027
     C                   Z-ADD     0             YRNO
     C                   Z-ADD     0             MTHN
     C                   ENDIF
 
     C                   MOVE      *BLANKS       STTA
     C                   MOVE      *BLANKS       STTB
     C*****CUSC*         IFNE      *ZEROS                                                     CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
      *
     C**********         Z-ADD     CUSC          KCBCD                                        CSD027
     C                   EVAL      KCBCD = CUSC                                               CSD027
     C                   MOVE      P0Mkt         KMRKT
     C                   MOVE      ISTT          KISTC
     C     KDEFLT        CHAIN     DEFLT                              50
     C                   MOVE      *BLANKS       WWSETP            2
     C**********         MOVE      *BLANKS       WWSTTA           12                          CGL029
     C                   MOVE      *BLANKS       WWSTTA           18                          CGL029
     C                   MOVE      *BLANKS       WWSEBR            3
     C                   MOVE      *BLANKS       WWSECY            3
      *
     C     *IN50         IFEQ      '1'
     C     *IN50         OREQ      '0'
     C     SETP          ANDEQ     *ZEROS
 
     C                   MOVE      CUSC          PCust06A
     C                   CALLB     'AOFOCSR0'
     C                   PARM      *BLANK        PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM                    PCust06A
     C     SDFOCS        PARM      SDFOCS        DSFDY
     C     PRtnCde07A    IFEQ      *BLANKS
     C                   MOVE      BHSTTY        WWSETP
     C                   MOVE      BHSMAC        WWSTTA
     C                   MOVE      BHSEBR        WWSEBR
     C                   MOVE      BHCYCD        WWSECY
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      SETP          WWSETP
     C                   MOVE      SETA          WWSTTA
     C                   MOVE      SEBR          WWSEBR
     C                   MOVE      ISCY          WWSECY
     C                   ENDIF
 
     C     WWSETP        IFNE      *BLANKS
 
      ** 01 - Nostro by Telex
      ** 07 - Nostro by CHIPS
      ** 08 - Nostro by SWIFT
     C     WWSETP        IFEQ      '01'
     C     WWSETP        OREQ      '07'
     C     WWSETP        OREQ      '08'
     C                   MOVEL     WWSTTA        PNostro02A
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY    '    POption07A
     C                   PARM      *BLANKS       PCust06A
     C                   PARM      ISCY          PCcy03A
     C                   PARM      *BLANKS       PAccCde04A
     C                   PARM      *BLANKS       PAccSeq02A
     C                   PARM                    PNostro02A
     C                   PARM      *BLANKS       PBrch03A
     C                   PARM      *BLANKS       PNostroNme10A
     C                   PARM      *BLANKS       PPrimeNost01A
     C     SDNOST        PARM      SDNOST        DSFDY
     C     PRtnCde07A    IFEQ      *BLANKS
     C                   MOVEL     A7CUST        WSTTA1            9
     C                   MOVE      ISCY          WSTTA1
     C**********         MOVEL     A7ACCD        WSTTA2            6                          CGL029
     C                   MOVEL     A7ACCD        WSTTA2           12                          CGL029
     C                   MOVE      A7ACSN        WSTTA2
     C                   MOVEL     WSTTA1        STTA
     C                   MOVE      WSTTA2        STTA
     C                   MOVE      A7BRCD        WWSEBR
     C                   ENDIF
     C                   ENDIF
 
      ** 04 - Counterparty's prime retail account
      ** 15 - Counterparty designated account
     C     WWSETP        IFEQ      '04'
     C     WWSETP        OREQ      '15'
     C                   MOVEL     CUSC          WSTTA1
     C                   MOVE      ISCY          WSTTA1
     C     WWSETP        IFEQ      '04'
     C                   MOVEL     BMACCD        WSTTA2
     C                   ELSE
     C                   MOVEL     BXDCAC        WSTTA2
     C                   ENDIF
     C                   MOVE      '01'          WSTTA2
     C                   MOVEL     WSTTA1        STTA
     C                   MOVE      WSTTA2        STTA
     C                   MOVEL(P)  CUSC          PCust10A
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM                    PCust10A
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSLDY
     C                   MOVE      BBBRCD        WWSEBR
     C                   ENDIF
 
      ** 05 - Any Account
     C     WWSETP        IFEQ      '05'
     C**********         MOVEL     WWSTTA        WSTTA2                                       CGL029
     C**********         MOVE      WWSTTA        WSTTA1                                       CGL029
     C**********         MOVEL     ISCY          WSTTA1                                       CGL029
     C**********         MOVEL     WSTTA2        STTA                                         CGL029
     C**********         MOVE      WSTTA1        STTA                                         CGL029
     C                   MOVEL     WWSTTA        WSTTA1                                       CGL029
     C                   MOVE      ISCY          WSTTA1                                       CGL029
     C                   MOVE      WWSTTA        WSTTA2                                       CGL029
     C                   MOVEL     WSTTA1        STTA                                         CGL029
     C                   MOVE      WSTTA2        STTA                                         CGL029
     C                   ENDIF
 
      ** 06 - Suspense Account
     C     WWSETP        IFEQ      '06'
     C                   MOVEL     BICN          WSTTA1
     C                   MOVE      ISCY          WSTTA1
     C                   MOVEL     BKACCD        WSTTA2
     C                   MOVE      '01'          WSTTA2
     C                   MOVEL     WSTTA1        STTA
     C                   MOVE      WSTTA2        STTA
     C                   MOVE      A8BRCD        WWSEBR
     C                   ENDIF
 
      ** 14 - Any Current Account
     C     WWSETP        IFEQ      '14'
     C                   MOVEL     STTA          KAccNum
     C     KAccNum       CHAIN     ACNUM                              50
     C     *IN50         IFEQ      '0'
     C                   MOVEL     CNUM          WSTTA1
     C                   MOVE      CCY           WSTTA1
     C                   MOVEL     ACOD          WSTTA2
     C                   MOVE      ACSQ          WSTTA2
     C                   MOVEL     WSTTA1        STTA
     C                   MOVE      WSTTA2        STTA
     C                   MOVE      BRCA          WWSEBR
     C                   ENDIF
     C                   ENDIF
 
     C     STTA          IFEQ      *BLANKS
     C                   MOVEL     BICN          WSTTA1
     C                   MOVE      ISCY          WSTTA1
     C                   MOVEL     BKACCD        WSTTA2
     C                   MOVE      '01'          WSTTA2
     C                   MOVEL     WSTTA1        STTA
     C                   MOVE      WSTTA2        STTA
     C                   MOVE      A8BRCD        WWSEBR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     BGPFMG        IFEQ      'Y'
     C     FCPORS        ANDNE     'B'
      **   If the display field is equal to the "reference attached to
      **   9997 portfolio"
     C     WScPTFR       IFEQ      FCR997
     C     WScPTFR       ANDNE     *BLANKS
     C                   MOVEL     '9997'        PTFR
     C                   ELSE
     C                   MOVEL     WScPTFR       PTFR
     C                   ENDIF
     C                   ENDIF
 
     C     STTA          IFNE      *BLANKS
     C     STTB          ANDEQ     *BLANKS
     C                   MOVE      WWSEBR        STTB
     C                   ENDIF
      *
     C                   MOVE      'D'           RECI
     C                   Z-ADD     WCtlDate      LCD
     C                   MOVE      'I'           CHTP
     C                   Z-ADD     PZNxtTransP   TNLU
 
      **   Write record to LF/CLOST
     C                   WRITE     CLOSTDF
     C                   MOVEA     WTbMsg(5)     WNARR            33
     C                   MOVE      CLON          WNARR
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROutCLOST2- Write LF/CLOST2 records                         *
      *                                                               *
      *****************************************************************
     C     SROutCLOST2   BEGSR
 
      **   Set up fields for output to both records
     C                   MOVE      'D'           RECI
     C                   Z-ADD     CLON          CLON
     C                   Z-ADD     WNCTE         NCCL
 
      **   Set up fields for output to Closing  record only
     C                   MOVE      WScTransRef   TNBR
     C                   Z-ADD     OTRSD         TRSD
     C                   MOVE      'Y'           FCLI
 
     C     WScTRTY       IFEQ      'S'
     C                   MOVE      'P'           TRTY
     C                   ELSE
     C                   MOVE      'S'           TRTY
     C                   ENDIF
 
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     PSCIS         ANDEQ     'N'
     C                   Z-ADD     0             OCOB
     C                   Z-ADD     WNCTE         CCOB
     C                   ELSE
     C                   Z-ADD     0             OCOB
     C                   Z-ADD     0             CCOB
     C                   ENDIF
 
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   Z-ADD     0             OCOC
     C                   Z-ADD     WNCTE         CCOC
     C                   ELSE
     C                   Z-ADD     0             OCOC
     C                   Z-ADD     0             CCOC
     C                   ENDIF
 
      **   Write Closing  record to LF/CLOST2
     C                   WRITE     CLOSTTF
 
      **   Set up fields for output to Trade record only
     C                   MOVE      WScCLSR       TNBR
     C                   Z-ADD     TRSDS         TRSD
     C                   MOVE      WScTRTY       TRTY
 
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   Z-ADD     0             CCOC
     C                   Z-ADD     WNCTE         OCOC
     C                   ELSE
     C                   Z-ADD     0             CCOC
     C                   Z-ADD     0             OCOC
     C                   ENDIF
 
      **   - and on whether a Broker is present
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     PSCIS         ANDEQ     'N'
     C                   Z-ADD     0             CCOB
     C                   Z-ADD     WNCTE         OCOB
     C                   ELSE
     C                   Z-ADD     0             CCOB
     C                   Z-ADD     0             OCOB
     C                   ENDIF
 
     C                   MOVE      'N'           FCLI
 
     C*****CUSC*         IFNE      0                                                          CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C     BOKC          ORNE      *BLANKS
     C     WNOCO         IFEQ      *ZEROS
     C                   MOVE      'Y'           FCLI
     C                   ENDIF
     C                   ENDIF
      *
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C     WNOBO         ANDEQ     *ZEROS
     C                   MOVE      'Y'           FCLI
     C                   ENDIF
 
      **   Write Trade record to LF/CLOST2
     C                   WRITE     CLOSTTF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdCLOST - Update LF/CLOST record                          *
      *                                                               *
      *****************************************************************
     C     SRUpdCLOST    BEGSR
 
      **   Access LF/CLOST2 record for the deleted Closing
     C                   MOVE      WScTransRef   KTrans
     C                   Z-ADD     0             KCLON
     C                   MOVEL     WScTransRef   CLST2K           12
     C                   MOVE      '000000'      CLST2K
     C     KCLST2        SETLL     CLOST2
     C                   READ      CLOST2                                 71
 
      **   Database error if not found
     C     *IN71         IFEQ      '1'
     C     TNBR          ORNE      KTrans
     C     *LOCK         IN        LDA
     C                   Z-ADD     33            DBASE
     C                   MOVEL     'CLST2'       DBFILE
     C                   MOVEL     CLST2K        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **   If it is found, Chain to the related LF/CLOST record for update
     C     CLON          CHAIN     CLOST                              71
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     34            DBASE
     C                   MOVEL     'CLOST'       DBFILE
     C                   MOVEL     CLON          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **   Determine Profit/loss direction for deletion amount
      **    dependent on original purchase/sale
     C     WScTRTY       IFEQ      'P'
     C                   Z-ADD     COPL          COPLS
     C                   ELSE
     C                   Z-SUB     COPL          COPLS            13 0
     C                   ENDIF
 
      **   Set up fields for update
     C                   MOVE      'Y'           CORI
     C                   Z-ADD     WCtlDate      LCD
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     PZNxtTransP   TNLU
 
      **   Update record in LF/CLOST
     C                   EXCEPT    CLOSTU
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdMEMOS - Update LF/MEMOSM. Apply retail a/c shadow       *
      *               balance.                                        *
      *                                                               *
      *****************************************************************
     C     SRUpdMEMOS    BEGSR
 
      **   Attempt to access LF/MEMOSM
     C     KMEMOS        CHAIN     MEMOSM                             71
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     0             LDBL
     C                   Z-ADD     0             CLBL
     C                   ENDIF
 
      ** Store Ledger Balance in work field for use in SR/SROutFFACMVD
     C                   Z-ADD     LDBL          WLDBL            15 0
 
      **   'Apply' updates due to the new trade
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     LDBL          SUB       PRMPS         LDBL
     C     CLBL          SUB       PRMPS         CLBL
     C     LDBL          ADD       COPLS         LDBL
     C     CLBL          ADD       COPLS         CLBL
      **    - Sale
     C                   ELSE
     C     LDBL          ADD       PRMPS         LDBL
     C     CLBL          ADD       PRMPS         CLBL
     C     LDBL          SUB       COPLS         LDBL
     C     CLBL          SUB       COPLS         CLBL
     C                   ENDIF
 
      **   Update LF/MEMOSM
     C     *IN71         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   MOVE      WFFCustP      CNUM
     C                   MOVE      WFFCCY        CCY
     C                   MOVE      WFFACOD       ACOD
     C                   MOVE      WFFACSQ       ACSQ
     C                   MOVE      WFFBRCB       BRCA
     C                   WRITE     MEMOSMEF
     C                   ELSE
     C                   UPDATE    MEMOSMEF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdRevMEMOS- Update LF/MEMOSM. Reverse out retail a/c      *
      *                 shadow balance.                               *
      *                                                               *
      *****************************************************************
     C     SRUpdRevMEMOS BEGSR
 
      **   Attempt to access LF/MEMOSM
     C     KMEMOS        CHAIN     MEMOSM                             71
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     0             LDBL
     C                   Z-ADD     0             CLBL
     C                   ENDIF
 
      ** Store Ledger Balance in a work field for use in SROutFFACMVD
     C                   Z-ADD     LDBL          WLDBL
 
      **   Reverse out updates due to the amended trade
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     LDBL          ADD       PRMPS         LDBL
     C     CLBL          ADD       PRMPS         CLBL
     C     LDBL          SUB       COPLS         LDBL
     C     CLBL          SUB       COPLS         CLBL
      **    - Sale
     C                   ELSE
     C     LDBL          SUB       PRMPS         LDBL
     C     CLBL          SUB       PRMPS         CLBL
     C     LDBL          ADD       COPLS         LDBL
     C     CLBL          ADD       COPLS         CLBL
     C                   ENDIF
 
      **   Update LF/MEMOSM
     C     *IN71         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   MOVE      WFFCustP      CNUM
     C                   MOVE      WFFCCY        CCY
     C                   MOVE      WFFACOD       ACOD
     C                   MOVE      WFFACSQ       ACSQ
     C                   MOVE      WFFBRCB       BRCA
     C                   WRITE     MEMOSMEF
     C                   ELSE
     C                   UPDATE    MEMOSMEF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdPRONO - Update LF/PRONOM. Apply projected nostro        *
      *               balance.                                        *
      *                                                               *
      *****************************************************************
     C     SRUpdPRONO    BEGSR
 
      **   Attempt to access LF/PRONOM
     C     KPRONO        CHAIN     PRONOM                             71
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     0             PNBL
     C                   ENDIF
 
      **   Store Projected Nostro Balance in a work field for use in
      **   SR/SROutFFACMVD
     C                   Z-ADD     PNBL          WPNBL            15 0
 
      **   'Apply' updates due to the new trade
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     PNBL          SUB       PRMPS         PNBL
     C     PNBL          ADD       COPLS         PNBL
      **    - Sale
     C                   ELSE
     C     PNBL          ADD       PRMPS         PNBL
     C     PNBL          SUB       COPLS         PNBL
     C                   ENDIF
 
      **   Update LF/PRONOM
     C     *IN71         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   MOVE      WFFCCY        CCY
     C                   MOVE      KNOSNP        NOSN
     C                   WRITE     PRONOMEF
     C                   ELSE
     C                   UPDATE    PRONOMEF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdRevPRONO- Update LF/PRONOM. Reverse out projected       *
      *                 nostro balance.                               *
      *                                                               *
      *****************************************************************
     C     SRUpdRevPRONO BEGSR
 
      **   Attempt to access LF/PRONOM
     C     KPRONO        CHAIN     PRONOM                             71
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     0             PNBL
     C                   ENDIF
 
      **   Store Projected Nostro Balance in a work field for use in
      **   SR/SROutFFACMVD
     C                   Z-ADD     PNBL          WPNBL
      *
      **   Reverse out updates due to the amended trade
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     PNBL          ADD       PRMPS         PNBL
     C     PNBL          SUB       COPLS         PNBL
      **    - Sale
     C                   ELSE
     C     PNBL          SUB       PRMPS         PNBL
     C     PNBL          ADD       COPLS         PNBL
     C                   ENDIF
 
      **   Update LF/PRONOM
     C     *IN71         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   MOVE      WFFCCY        CCY
     C                   MOVE      KNOSNP        NOSN
     C                   WRITE     PRONOMEF
     C                   ELSE
     C                   UPDATE    PRONOMEF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROutFFACMVD- Write record to PF/FFACMVD                     *
      *                                                               *
      *****************************************************************
     C     SROutFFACMVD  BEGSR
 
      **   Set up fields for output to PF/FFACMVD
      **   Branch Code
     C                   MOVE      FOBRCA        BRCA
      **   Customer Number
     C**********         Z-ADD     WFFCustP      CUSN                                         CSD027
     C                   EVAL      CUSN = WFFCustP                                            CSD027
      **   Currency Code
     C                   MOVE      WFFCCY        CCYD
      **   Account Code
     C                   Z-ADD     WFFACOD       ACDE
      **   Account Sequence
     C                   Z-ADD     WFFACSQ       ASNC
      **   Posting Date
     C                   Z-ADD     P0RunDay      PTDT
      **   Value Date
     C                   Z-ADD     P0RunDay      VUDT
      **   Transaction Type
     C                   MOVE      WScTRTY       TRYP
      **   Narrative Code
     C                   Z-ADD     0             NRTC
      **   Narrative Description
     C                   MOVEL     ISTN          NRTD
 
      **   Transaction Number
     C     *IN03         IFEQ      '1'
     C     *IN04         OREQ      '1'
     C                   MOVE      WScCLSR       TNMR
     C                   ELSE
     C                   MOVE      TNBR          TNMR
     C                   ENDIF
 
      **   Cheque Number
     C                   Z-ADD     *ZERO         CQNR
 
      **   Movement Amount = change in Ledger Balance/Projected
      **                     Nostro Balance
     C     MPIND         IFEQ      'M'
     C     LDBL          SUB       WLDBL         WMVAM            13 0
     C                   Z-ADD     WMVAM         MVAM
     C                   ENDIF
 
     C     MPIND         IFEQ      'P'
     C     PNBL          SUB       WPNBL         WMVAM
     C                   Z-ADD     WMVAM         MVAM
     C                   ENDIF
 
     C     MVAM          IFNE      *ZERO
 
      **   Debit or Credit
     C     MPIND         IFEQ      'M'
     C     LDBL          IFGE      WLDBL
     C                   Z-ADD     0             DORC
     C                   ELSE
     C                   Z-SUB     MVAM          MVAM
     C                   Z-ADD     1             DORC
     C                   ENDIF
     C                   ENDIF
 
      **  If Nostro Code is Zero then Settlement Instructions are Blank
     C     MPIND         IFEQ      'P'
 
     C     NOSN          IFNE      0
 
      **  Access PF/TABLETL for Customer Number, Account Code, Account
      **  Sequence
     C                   MOVE      NOSN          PNostro02A
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      *BLANKS       PCust06A
     C                   PARM                    PCcy03A
     C                   PARM      *BLANKS       PAccCde04A
     C                   PARM      *BLANKS       PAccSeq02A
     C                   PARM                    PNostro02A
     C                   PARM      *BLANKS       PBrch03A
     C                   PARM      *BLANKS       PNostroNme10A
     C                   PARM      *BLANK        PPrimeNost01A
     C     SDNOST        PARM      SDNOST        DSFDY
     C     PRtnCde07A    IFNE      *BLANKS
     C                   MOVE      PNostro02A    WChr005
     C                   MOVEL     PCcy03A       WChr005
     C     *LOCK         IN        LDA
     C                   Z-ADD     35            DBASE
     C                   MOVEL     'SDNOSTPD'    DBFILE
     C                   MOVEL     WChr005       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      ** Branch Not moved from TABLE File because it has the same field
      ** name as BRANCH on the Account Movements File (ie BRCA to BRCA)
     C                   MOVE      CNUM          CUSN
     C                   Z-ADD     ACOD          ACDE
     C                   Z-ADD     ACSQ          ASNC
 
     C                   ELSE
 
     C                   MOVE      *BLANKS       BRCA
     C**********         Z-ADD     0             CUSN                                         CSD027
     C                   EVAL      CUSN = *BLANKS                                             CSD027
     C                   Z-ADD     0             ACDE
     C                   Z-ADD     0             ASNC
 
     C                   ENDIF
 
     C     PNBL          IFGE      WPNBL
     C                   Z-ADD     0             DORC
     C                   ELSE
     C                   Z-SUB     MVAM          MVAM
     C                   Z-ADD     1             DORC
     C                   ENDIF
 
     C                   ENDIF
 
      **  Write record to PF/FFACMVD
     C                   WRITE     FFACMVDF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdPOSTNC- Update LF/POSTNC: Customer Position             *
      *                                                               *
      *****************************************************************
     C     SRUpdPOSTNC   BEGSR
 
      **   Access Customer Position off LF/POSTNC
     C                   MOVE      WScBRCA       KBRCAC
     C                   MOVEL     WCust10A      KCBCDC
     C                   MOVE      ISTT          KISTTC
     C                   MOVE      YRNO          KYRNOC
     C                   MOVE      MTHN          KMTHNC
     C                   MOVE      WScPutCall    KPCALC
     C                   Z-ADD     STRPS         KSTRPC
     C     KPSTNC        CHAIN     POSTNC                             71
      **   Record must exist and be live, otherwise DB Error
     C     *IN71         IFEQ      '1'
     C     P0Action      ANDNE     'I'
     C     *IN71         OREQ      '0'
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     36            DBASE
     C                   MOVEL     'PSTNC'       DBFILE
     C                   MOVEL     PSTNCK        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **   Delete - Reverse out updates due to the old trade
     C     P0Action      IFEQ      'D'
 
      **   - a) Broker involved
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
 
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     LOPC          ADD       WNCTE         LOPC
     C     CUTV          ADD       WTNVL         CUTV
     C     RPLD          SUB       COPLS         RPLD
      **    - Sale
     C                   ELSE
     C     SOPC          ADD       WNCTE         SOPC
     C     CUTV          SUB       WTNVL         CUTV
     C     RPLD          ADD       COPLS         RPLD
     C                   ENDIF
 
      **    Margin
     C     XCMAR         IFEQ      0
 
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     LOCO          ADD       WNCTE         LOCO
      **    - Sale
     C                   ELSE
     C     SOCO          ADD       WNCTE         SOCO
     C                   ENDIF
 
     C                   ENDIF
 
      **   - b) Broker not involved
     C                   ELSE
 
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     SOPC          ADD       WNCTE         SOPC
     C     CUTV          SUB       WTNVL         CUTV
     C     RPLD          ADD       COPLS         RPLD
      **    - Sale
     C                   ELSE
     C     LOPC          ADD       WNCTE         LOPC
     C     CUTV          ADD       WTNVL         CUTV
     C     RPLD          SUB       COPLS         RPLD
     C                   ENDIF
 
      **    Margin
     C     XCMAR         IFEQ      0
 
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     SOCO          ADD       WNCTE         SOCO
      **    - Sale
     C                   ELSE
     C     LOCO          ADD       WNCTE         LOCO
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   Insert - Apply updates due to the new trade
     C                   ELSE
 
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     0             LOPC
     C                   Z-ADD     0             SOPC
     C                   Z-ADD     0             CUTV
     C                   Z-ADD     0             TOTM
     C                   Z-ADD     0             LOCO
     C                   Z-ADD     0             SOCO
     C                   Z-ADD     0             RPLD
     C                   ENDIF
 
      **   - a) Broker involved
     C*****BOCO*         IFNE      0                                                          CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
 
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     LOPC          SUB       WNCTE         LOPC
     C     CUTV          SUB       WTNVL         CUTV
     C     RPLD          ADD       COPLS         RPLD
      **    - Sale
     C                   ELSE
     C     SOPC          SUB       WNCTE         SOPC
     C     CUTV          ADD       WTNVL         CUTV
     C     RPLD          SUB       COPLS         RPLD
     C                   ENDIF
 
      **    Margin
     C     XCMAR         IFEQ      0
 
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     LOCO          SUB       WNCTE         LOCO
      **    - Sale
     C                   ELSE
     C     SOCO          SUB       WNCTE         SOCO
     C                   ENDIF
 
     C                   ELSE
 
     C     XCMAR         IFGT      0
     C     *IN79         ANDEQ     '1'
     C     TOTM          SUB       XCMAR         TOTM
     C                   ENDIF
 
     C                   ENDIF
 
      **   - b) Broker not involved
     C                   ELSE
 
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     SOPC          SUB       WNCTE         SOPC
     C     CUTV          ADD       WTNVL         CUTV
     C     RPLD          SUB       COPLS         RPLD
      **    - Sale
     C                   ELSE
     C     LOPC          SUB       WNCTE         LOPC
     C     CUTV          SUB       WTNVL         CUTV
     C     RPLD          ADD       COPLS         RPLD
     C                   ENDIF
 
      **    Margin
     C     XCMAR         IFEQ      0
 
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     SOCO          SUB       WNCTE         SOCO
      **    - Sale
     C                   ELSE
     C     LOCO          SUB       WNCTE         LOCO
     C                   ENDIF
 
     C                   ELSE
 
     C     XCMAR         IFGT      0
     C     *IN79         ANDEQ     '1'
     C     TOTM          SUB       XCMAR         TOTM
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   Update Customer's Instrument Position
     C     *IN71         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   MOVE      KBRCAC        BRCA
     C                   MOVE      KCBCDC        CBCD
     C                   MOVE      KISTTC        ISTT
     C                   MOVE      KYRNOC        YRNO
     C                   MOVE      KMTHNC        MTHN
     C                   MOVE      KPCALC        PCAL
     C                   Z-ADD     KSTRPC        STRP
     C                   MOVE      'N'           BRKI
     C                   MOVE      KCCY          ISCY
     C                   Z-ADD     0             LSPO
     C                   Z-ADD     0             LSCP
     C                   Z-ADD     0             LSDA
     C                   Z-ADD     0             LTPO
     C                   Z-ADD     0             LTCP
     C                   Z-ADD     0             LTDA
     C                   Z-ADD     0             LOPE
     C                   Z-ADD     0             SOPE
     C                   Z-ADD     0             CUPL
     C                   Z-ADD     0             UPLP
     C                   Z-ADD     0             UPSP
     C                   Z-ADD     0             RPLD
     C                   Z-ADD     0             RPLY
     C                   Z-ADD     0             UPLY
     C                   Z-ADD     0             TOPL
     C                   Z-ADD     0             CMTM
     C                   Z-ADD     0             CHTM
     C                   Z-ADD     0             PMTM
     C                   Z-ADD     0             UPLM
     C                   Z-ADD     0             RPLM
     C                   WRITE     POSTNCDF
     C                   ELSE
     C                   EXCEPT    CBPSTN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdPOSTNC2- Update LF/POSTNC: Broker Position              *
      *                                                               *
      *****************************************************************
     C     SRUpdPOSTNC2  BEGSR
 
      **   Access Broker Position off LF/POSTNC
     C                   MOVE      WScBRCA       KBRCAC
     C                   MOVEL     WBOCO         KCBCDC
     C                   MOVE      ISTT          KISTTC
     C                   MOVE      #4YRNO        KYRNOC
     C                   MOVE      MTHN          KMTHNC
     C                   MOVE      WScPutCall    KPCALC
     C                   Z-ADD     STRPS         KSTRPC
     C     KPSTNC        CHAIN     POSTNC                             71
 
      **   1. Record must exist and must be live, otherwise DB Error
     C     *IN71         IFEQ      '1'
     C     P0Action      ANDNE     'I'
     C     *IN71         OREQ      '0'
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     37            DBASE
     C                   MOVEL     'PSTNC'       DBFILE
     C                   MOVEL     PSTNCK        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **   Delete - Reverse out updates due to the old trade
     C     P0Action      IFEQ      'D'
 
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     SOPC          ADD       WNCTE         SOPC
     C     CUTV          SUB       WTNVL         CUTV
     C     RPLD          ADD       COPLS         RPLD
      **    - Sale
     C                   ELSE
     C     LOPC          ADD       WNCTE         LOPC
     C     CUTV          ADD       WTNVL         CUTV
     C     RPLD          SUB       COPLS         RPLD
     C                   ENDIF
 
      **    Margin
     C     XBMAR         IFEQ      0
 
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     SOCO          ADD       WNCTE         SOCO
      **    - Sale
     C                   ELSE
     C     LOCO          ADD       WNCTE         LOCO
     C                   ENDIF
      *
     C                   ENDIF
 
      **   Insert - Apply updates due to the new trade
     C                   ELSE
      *
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     0             LOPC
     C                   Z-ADD     0             SOPC
     C                   Z-ADD     0             CUTV
     C                   Z-ADD     0             RPLD
     C                   ENDIF
 
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     SOPC          SUB       WNCTE         SOPC
     C     CUTV          ADD       WTNVL         CUTV
     C     RPLD          SUB       COPLS         RPLD
      **    - Sale
     C                   ELSE
     C     LOPC          SUB       WNCTE         LOPC
     C     CUTV          SUB       WTNVL         CUTV
     C     RPLD          ADD       COPLS         RPLD
     C                   ENDIF
 
      **    Margin
     C     XBMAR         IFEQ      0
 
      **    - Purchase
     C     WScTRTY       IFEQ      'P'
     C     SOCO          SUB       WNCTE         SOCO
      **    - Sale
     C                   ELSE
     C     LOCO          SUB       WNCTE         LOCO
     C                   ENDIF
 
     C                   ELSE
 
     C     XBMAR         IFGT      0
     C     *IN79         ANDEQ     '1'
     C     TOTM          SUB       XBMAR         TOTM
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   Update Broker's Instrument Position
     C     *IN71         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   MOVE      KBRCAK        BRCA
     C                   MOVE      KBOKCK        BOKC
     C                   MOVE      KISTTK        ISTT
     C                   MOVE      KYRNOK        YRNO
     C                   MOVE      KMTHNK        MTHN
     C                   MOVE      KPCALK        PCAL
     C                   Z-ADD     KSTRPK        STRP
     C                   MOVE      KCCY          ISCY
     C                   Z-ADD     0             LOPE
     C                   Z-ADD     0             SOPE
     C                   Z-ADD     0             POSM
     C                   Z-ADD     0             CUPL
     C                   Z-ADD     0             UPLP
     C                   Z-ADD     0             UPSP
     C                   Z-ADD     0             RPLD
     C                   Z-ADD     0             RPLY
     C                   Z-ADD     0             UPLY
     C                   Z-ADD     0             TOPL
     C                   Z-ADD     0             TOTP
     C                   Z-ADD     0             TOTS
     C                   Z-ADD     0             CMSP
     C                   Z-ADD     0             CMSR
     C                   Z-ADD     0             CPTM
     C                   Z-ADD     0             CRTM
     C                   Z-ADD     0             PMTM
     C                   Z-ADD     0             UPLM
     C                   Z-ADD     0             RPLM
     C                   WRITE     POSTNCDF
     C                   ELSE
     C                   EXCEPT    CBPSTN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdPOSTNK- Update LF/POSTNK: Book Position                 *
      *                                                               *
      *****************************************************************
     C     SRUpdPOSTNK   BEGSR
 
      **   Access Book Position off LF/POSTNK
     C                   MOVE      WScBRCA       KBRCAK
     C                   MOVE      WScBOKC       KBOKCK
     C                   MOVE      ISTT          KISTTK
     C                   MOVE      YRNO          KYRNOK
     C                   MOVE      MTHN          KMTHNK
     C                   MOVE      WScPutCall    KPCALK
     C                   Z-ADD     STRPS         KSTRPK
     C     KPSTNK        CHAIN     POSTNK                             71
      **   Live record must exist, otherwise DB Error
     C     *IN71         IFEQ      '1'
     C     P0Action      ANDNE     'I'
     C     *IN71         OREQ      '0'
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   Z-ADD     38            DBASE
     C                   MOVEL     'PSTNK'       DBFILE
     C                   MOVEL     PSTNKK        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **   1. 'Reverse out' updates due to the old trade
 
     C     P0Action      IFEQ      'D'
 
      **   - Purchase
     C     WScTRTY       IFEQ      'P'
     C     LOPC          ADD       WNCTE         LOPC
     C     CUTV          ADD       WTNVL         CUTV
     C     RPLD          SUB       COPLS         RPLD
      **   - Sale
     C                   ELSE
     C     SOPC          ADD       WNCTE         SOPC
     C     CUTV          SUB       WTNVL         CUTV
     C     RPLD          ADD       COPLS         RPLD
     C                   ENDIF
 
      **   Insert - Apply updates due to the new trade
 
     C                   ELSE
 
     C     *IN71         IFEQ      '1'
     C                   Z-ADD     0             LOPC
     C                   Z-ADD     0             SOPC
     C                   Z-ADD     0             CUTV
     C                   Z-ADD     0             RPLD
     C                   ENDIF
 
      **   - Purchase
     C     WScTRTY       IFEQ      'P'
     C     LOPC          SUB       WNCTE         LOPC
     C     CUTV          SUB       WTNVL         CUTV
     C     RPLD          ADD       COPLS         RPLD
      **   - Sale
     C                   ELSE
     C     SOPC          SUB       WNCTE         SOPC
     C     CUTV          ADD       WTNVL         CUTV
     C     RPLD          SUB       COPLS         RPLD
     C                   ENDIF
 
     C                   ENDIF
 
      **   Update Book's Instrument Position
     C     *IN71         IFEQ      '1'
     C                   MOVE      'D'           RECI
     C                   MOVE      KBRCAK        BRCA
     C                   MOVE      KBOKCK        BOKC
     C                   MOVE      KISTTK        ISTT
     C                   MOVE      KYRNOK        YRNO
     C                   MOVE      KMTHNK        MTHN
     C                   MOVE      KPCALK        PCAL
     C                   Z-ADD     KSTRPK        STRP
     C                   MOVE      KCCY          ISCY
     C                   Z-ADD     0             LOPE
     C                   Z-ADD     0             SOPE
     C                   Z-ADD     0             POSM
     C                   Z-ADD     0             CUPL
     C                   Z-ADD     0             UPLP
     C                   Z-ADD     0             UPSP
     C                   Z-ADD     0             RPLD
     C                   Z-ADD     0             RPLY
     C                   Z-ADD     0             UPLY
     C                   Z-ADD     0             TOPL
     C                   Z-ADD     0             TOTP
     C                   Z-ADD     0             TOTS
     C                   Z-ADD     0             CMSP
     C                   Z-ADD     0             CMSR
     C                   Z-ADD     0             CPTM
     C                   Z-ADD     0             CRTM
     C                   Z-ADD     0             PMTM
     C                   Z-ADD     0             UPLM
     C                   Z-ADD     0             RPLM
     C                   WRITE     POSTNKDF
     C                   ELSE
     C                   EXCEPT    BKPSTN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdTRANSAu- Update Transaction Audit file                  *
      *                                                               *
      *****************************************************************
     C     SRUpdTRANSAu  BEGSR
 
      **   Access audit record
     C     1             CHAIN     TRANSA                             71
     C     *IN71         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   Z-ADD     39            DBASE
     C                   MOVEL     'TRANS'       DBFILE
     C                   MOVEL     'AUDIT'       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **   If Trade is an insert
     C     WScActn       IFEQ      'I'
 
     C                   ADD       1             NORE
     C                   ADD       1             NINS
 
      **   If Trade is an amend
     C                   ELSE
 
     C     WScActn       IFEQ      'A'
 
      **   If not previously amended today
     C     XLCD          IFNE      WCtlDate
     C                   ADD       1             NAMD
     C                   ENDIF
 
      **   If Trade is a delete
     C                   ELSE
     C                   SUB       1             NORE
     C                   ADD       1             NDEL
      *
      **   If previously processed today
      *
     C     XLCD          IFEQ      WCtlDate
      **   If previously inserted today
     C     XCHTP         IFEQ      'I'
     C                   SUB       1             NINS
     C                   ENDIF
      **   If previously amended today
     C     XCHTP         IFEQ      'A'
     C                   SUB       1             NAMD
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   Update audit record
     C                   UPDATE    TRANSAF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVUpdWrkstn- 'Record Updated By Another Workstation' ctl.   *
      *                                                               *
      *****************************************************************
     C     SRVUpdWrkstn  BEGSR
 
      **   Access TRANS record if SR. called due to Write failure
     C                   ROLBK
     C     WScActn       IFEQ      'I'
     C                   MOVE      WScTransRef   KTrans
     C     KTrans        CHAIN     TRANSIN                            71
      **   Check if Broker and/or Customer present for inserted Closing
     C*****BOCO*         IFNE      *ZEROS                                                     CSD027
     C     BOCO          IFNE      *BLANKS                                                    CSD027
     C                   SETON                                        14
     C                   ENDIF
     C*****CUSC*         IFNE      *ZEROS                                                     CSD027
     C     CUSC          IFNE      *BLANKS                                                    CSD027
     C                   SETON                                        15
     C                   ENDIF
     C                   ENDIF
 
      **   Reset Processing
     C                   SETON                                        11
 
      **   Initialise updated screen details
     C     P0Mkt         IFNE      ' '
     C                   EXSR      SRMktInst
     C                   ELSE
     C                   EXSR      SRInitOTC
     C                   ENDIF
 
     C                   MOVEA     WTbMsg(2)     WScErrLne2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdFOPC  - Update LF/FOPCC + LF/FOPCK. Apply profit centre.*
      *                                                               *
      *****************************************************************
     C     SRUpdFOPC     BEGSR
 
      **   - open LF/FOPCC and LF/FOPCK
     C     WOpnFOPCC     IFNE      'Y'
     C                   OPEN      FOPCC
     C                   MOVE      'Y'           WOpnFOPCC
     C                   ENDIF
     C     WOpnFOPCK     IFNE      'Y'
     C                   OPEN      FOPCK
     C                   MOVE      'Y'           WOpnFOPCK
     C                   ENDIF
 
      **   - set up key fields to chain LF/FOPCC for customer
     C     *IN15         IFEQ      '1'
      *
     C                   MOVE      WScBRCA       KBRCAO
     C                   MOVEL     WCust10A      KCBCDO
     C     WScMkt        IFEQ      '  '
     C                   MOVE      #5ISTT        KISTTO
     C                   ELSE
     C                   MOVEL     WScMkt        KISTTO
     C                   MOVE      #4ISTC        KISTTO
     C                   ENDIF
 
     C     KFPCC         CHAIN     FOPCC                              89
      **   - set up fields for LF/FOPCC
     C                   MOVE      'D'           RECICC
     C                   MOVE      WScBRCA       BRCACC
     C                   MOVEL     WCust10A      CBCDCC
     C     WScMkt        IFEQ      '  '
     C                   MOVE      #5ISTT        ISTTCC
     C                   ELSE
     C                   MOVEL     WScMkt        ISTTCC
     C                   MOVE      #4ISTC        ISTTCC
     C                   ENDIF
     C     CAC003        IFEQ      'Y'
     C     BGN0ST        ANDEQ     'Y'
     C                   MOVE      TPRC          PCCB
     C                   ELSE
     C                   MOVE      PRFC          PCCB
     C                   ENDIF
 
      **  Set up new fields LCD with RUNDAT, CHTP with 'I', and TNLU
      **   with Trans No. of Last Update from DTAARA MNATN.
     C                   MOVE      BJRDNB        LCD
     C                   MOVE      'I'           CHTP
 
      ** Increase Trans No. of Last Update by One.
     C     *LOCK         IN        MNATN
     C                   MOVE      TRAN          TNLU
     C                   ADD       1             TRAN2
     C                   OUT       MNATN
 
      **   - new position
     C     *IN89         IFEQ      '1'
     C                   WRITE     FOPCCDF                              89
     C                   ENDIF
 
      **   If WRITE fail :-
     C     *IN89         IFEQ      '1'
      **   - 'Rec Upd by Another Wrkstn' - discontinue updates/Rollback
     C                   EXSR      SRVUpdWrkstn2
     C                   GOTO      UAPRE
     C                   ENDIF
 
     C                   ENDIF
 
      **   - set up key fields to chain LF/FOPCC for broker
     C     *IN14         IFEQ      '1'
 
     C                   MOVE      WScBRCA       KBRCAO
     C                   MOVEL     WBOCO         KCBCDO
     C     WScMkt        IFEQ      '  '
     C                   MOVE      #5ISTT        KISTTO
     C                   ELSE
     C                   MOVEL     WScMkt        KISTTO
     C                   MOVE      #4ISTC        KISTTO
     C                   ENDIF
 
     C     KFPCC         CHAIN     FOPCC                              89
 
      **   - set up fields for LF/FOPCC
     C                   MOVE      'D'           RECICC
     C                   MOVE      WScBRCA       BRCACC
     C                   MOVEL     WBOCO         CBCDCC
     C     WScMkt        IFEQ      '  '
     C                   MOVE      #5ISTT        ISTTCC
     C                   ELSE
     C                   MOVEL     WScMkt        ISTTCC
     C                   MOVE      #4ISTC        ISTTCC
     C                   ENDIF
     C                   MOVE      PRFC          PCCB
 
      ** Set up new fields LCD with RUNDAT, CHTP with 'I', and TNLU
      **   with Trans No. of Last Update from DTAARA MNATN.
     C                   MOVE      BJRDNB        LCD
     C                   MOVE      'I'           CHTP
 
      ** Increase Trans No. of Last Update by One.
     C     *LOCK         IN        MNATN
     C                   MOVE      TRAN          TNLU
     C                   ADD       1             TRAN2
     C                   OUT       MNATN
 
      **   - new position
     C     *IN89         IFEQ      '1'
     C                   WRITE     FOPCCDF                              89
     C                   ENDIF
 
      **   If WRITE fail :-
     C     *IN69         IFEQ      '1'
      **   - 'Rec Upd by Another Wrkstn' - discontinue updates/Rollback
     C                   EXSR      SRVUpdWrkstn2
     C                   GOTO      UAPRE
     C                   ENDIF
 
     C                   ENDIF
 
      ** Write to FOPCKD for a New Book Position Profit Centre
     C                   MOVE      WScBRCA       KBRCAF
     C                   MOVE      WScBOKC       KBOKCF
     C     WScMkt        IFEQ      '  '
     C                   MOVE      #5ISTT        KISTTF
     C                   ELSE
     C                   MOVEL     WScMkt        KISTTF
     C                   MOVE      #4ISTC        KISTTF
     C                   ENDIF
 
     C     KFPCK         CHAIN     FOPCK                              89
 
      **   - set up fields for LF/FOPCK
     C                   MOVE      'D'           RECICK
     C                   MOVE      WScBRCA       BRCACK
     C                   MOVE      WScBOKC       BOKCCK
     C     WScMkt        IFEQ      '  '
     C                   MOVE      #5ISTT        ISTTCK
     C                   ELSE
     C                   MOVEL     WScMkt        ISTTCK
     C                   MOVE      #4ISTC        ISTTCK
     C                   ENDIF
     C     CAC003        IFEQ      'Y'
     C     BGN0ST        ANDEQ     'Y'
     C                   MOVE      BPRC          PCBK
     C                   ELSE
     C                   MOVE      PRFC          PCBK
     C                   ENDIF
 
      ** Set up new fields LCD with RUNDAT, CHTP with 'I', and TNLU
      **   with Trans No. of Last Update from DTAARA MNATN.
     C                   MOVE      BJRDNB        LCD
     C                   MOVE      'I'           CHTP
 
      ** Increase Trans No. of Last Update by One.
     C     *LOCK         IN        MNATN
     C                   MOVE      TRAN          TNLU
     C                   ADD       1             TRAN2
     C                   OUT       MNATN
 
      **   - new position
     C     *IN89         IFEQ      '1'
     C                   WRITE     FOPCKDF                              89
     C                   ENDIF
 
      **   If WRITE fail :-
     C     *IN89         IFEQ      '1'
      **   - 'Rec Upd by Another Wrkstn' - discontinue updates/Rollback
     C                   EXSR      SRVUpdWrkstn2
     C                   GOTO      UAPRE
     C                   ENDIF
 
     C     UAPRE         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVUpdWrkstn2     -  'Profit Centre File Updated By Another  *
      *                        Workstation'                           *
      *                                                               *
      *****************************************************************
     C     SRVUpdWrkstn2 BEGSR
 
     C                   ROLBK
      **   Reset Processing
     C                   SETON                                        11
     C                   MOVEA     WTbMsg(3)     WScErrLne2
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalcRate - To calculate Tier, Threshold of flat rate       *
      *                                                               *
      *****************************************************************
     C     SRCalcRate    BEGSR
 
      ** Access CHGCM for charges and commissions details
     C                   MOVE      ISCY          KCCY
     C                   Z-ADD     CGCM          KCGCM
     C     KCHGCM        CHAIN     CHGCM                              89
     C     *IN89         IFEQ      *ON
     C     RECI          ORNE      'D'
     C                   MOVEL     ISCY          CHGCMT            5
     C                   MOVE      CGCM          CHGCMT
     C     *LOCK         IN        LDA
     C                   Z-ADD     40            DBASE
     C                   MOVEL     'CHGCM   '    DBFILE
     C                   MOVEL     CHGCMT        DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Locate the highest valued charged range lower limit on CHGCM
      ** whose value is less than or equal to the contract number
     C                   Z-ADD     9             Y                 1 0
     C                   MOVE      'N'           WFOUND            1
 
     C     WFOUND        DOWEQ     'N'
     C     Y             ANDGT     1
     C     RNG(Y)        IFNE      0
     C     RNG(Y)        ANDLE     WCONO
     C                   MOVE      'Y'           WFOUND
     C                   ELSE
     C                   SUB       1             Y
     C                   ENDIF
     C                   ENDDO
 
      ** If charges are tiered
     C     TTFI          IFEQ      'T'
 
     C     WCONO         SUB       RNG(Y)        TCONO             5 0
     C                   ADD       1             TCONO
     C     TCONO         MULT      AMT(Y)        WRATA
     C     Y             DOWGE     2
     C     Y             SUB       1             Z                 1 0
     C     RNG(Y)        SUB       RNG(Z)        TCONO
     C     TCONO         MULT      AMT(Z)        TRATA            13 0
     C                   ADD       TRATA         WRATA
     C                   SUB       1             Y
     C                   ENDDO
 
     C                   ENDIF
 
      ** If charges are threshold
     C     TTFI          IFEQ      'X'
     C     WCONO         MULT      AMT(Y)        WRATA
     C                   ENDIF
 
      ** If charges are flat
     C     TTFI          IFEQ      'F'
     C                   Z-ADD     AMT(Y)        WRATA
     C                   ENDIF
 
      ** If rate amount < min charge commission
     C     WRATA         IFLT      MINC
     C     MINC          ANDNE     0
     C                   Z-ADD     MINC          WRATA
     C                   ENDIF
 
      ** If rate amount > max charge commission
     C     WRATA         IFGT      MAXC
     C     MAXC          ANDNE     0
     C                   Z-ADD     MAXC          WRATA
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFFSettle - From /copy FFSTLZ4. Determines from input       *
      *               settlement details wether MEMOS or PRONO        *
      *               processing is required. In addition, whilst     *
      *               doing this, the associated settlement account   *
      *               ID is constructed.                              *
      *                                                               *
      *        Input:                                                 *
      *               WFFBRCA - Booking branch                  (3A)  *
      *               WFFCBCD - Customer/Broker code          (6,0P)  *
      *               WFFBRKI - Broker indicator                (1A)  *
      *               WFFSETP - Settlement type               (2,0P)  *
      *               WFFSETA - Settlement account             (12A)  *
      *               WFFSETB - Settlement branch               (3A)  *
      *               WFFCCY  - Currency                        (3A)  *
      *                                                               *
      *        Output:                                                *
      *               WFFBRCB - Branch code                     (3A)  *
      *               WFFCNUM - Customer number               (6,0P)  *
      *               WFFACOD - Account code                    (3A)  *
      *               WFFACSQ - Account sequence                (3A)  *
      *               WFFNOSN - Nostro number                   (3A)  *
      *               WFFMIND - MEMOS update indicator (Y,N,E)  (1A)  *
      *               WFFPIND - PRONO update indicator (Y,N)    (1A)  *
      *                                                               *
      *****************************************************************
     C     SRFFSettle    BEGSR
 
      ** Reset output fields
     C                   MOVE      *BLANKS       WFFBRCB
     C**********         Z-ADD     *ZERO         WFFCNUM                                      CSD027
     C                   EVAL      WFFCNUM = *BLANKS                                          CSD027
     C                   Z-ADD     *ZERO         WFFACOD
     C                   Z-ADD     *ZERO         WFFACSQ
     C                   Z-ADD     *ZERO         WFFNOSN
     C                   MOVE      'N'           WFFMIND
     C                   MOVE      'N'           WFFPIND
 
     C                   SELECT
 
      ** ------------------------------------- **
      ** Settlement type is 01, 02, 07, 08, 12 **
      ** ------------------------------------- **
 
     C     WFFSETP       WHENEQ    01
     C     WFFSETP       OREQ      02
     C     WFFSETP       OREQ      07
     C     WFFSETP       OREQ      08
     C     WFFSETP       OREQ      12
 
     C                   MOVE      'Y'           WFFPIND
     C     WFFSETA       IFEQ      *BLANK
     C                   Z-ADD     0             WFFNOSN
     C                   GOTO      ExFFSettle
     C                   ENDIF
 
     C                   MOVEL     WFFSETA       PNostro02A
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM      *BLANKS       PCust06A
     C                   PARM      WFFCCY        PCcy03A
     C                   PARM      *BLANKS       PAccCde04A
     C                   PARM      *BLANKS       PAccSeq02A
     C                   PARM                    PNostro02A
     C                   PARM      *BLANKS       PBrch03A
     C                   PARM      *BLANKS       PNostroNme10A
     C                   PARM      *BLANK        PPrimeNost01A
     C     SDNOST        PARM      SDNOST        DSFDY
     C     PRtnCde07A    IFNE      *BLANKS
     C                   Z-ADD     0             WFFNOSN
     C                   GOTO      ExFFSettle
     C                   ENDIF
 
     C                   MOVE      A7BRCD        WFFBRCB
     C                   MOVE      A7CUST        WFFCNUM
     C                   MOVE      A7ACCD        WFFACOD
     C                   Z-ADD     A7ACSN        WFFACSQ
 
      ** --------------------- **
      ** Settlement type is 03 **
      ** --------------------- **
 
     C     WFFSETP       WHENEQ    03
 
     C                   MOVE      WFFBRCA       WFFBRCB
     C                   MOVE      BICN          WFFCNUM
     C                   MOVE      BXDCAC        WFFACOD
     C                   Z-ADD     1             WFFACSQ
 
      ** ------------------------------------- **
      ** Settlement type is 01, 02, 07, 08, 12 **
      ** ------------------------------------- **
 
     C     WFFSETP       WHENEQ    04
 
     C                   MOVE      WFFBRCA       WFFBRCB
     C**********         Z-ADD     WFFCBCD       WFFCNUM                                      CSD027
     C                   EVAL      WFFCNUM = WFFCBCD                                          CSD027
     C                   MOVE      BMACCD        WFFACOD
     C                   Z-ADD     1             WFFACSQ
 
      ** ------------------------------------- **
      ** Settlement type is 01, 02, 07, 08, 12 **
      ** ------------------------------------- **
 
     C     WFFSETP       WHENEQ    05
 
     C                   MOVE      WFFSETB       WFFBRCB
     C**********         Z-ADD     WFFSETA0106   WFFCNUM                                      CSD027
     C                   EVAL      WFFCNUM = WFFSETA0106                                      CSD027
     C                   Z-ADD     WFFSETA0710   WFFACOD
     C                   Z-ADD     WFFSETA1112   WFFACSQ
 
      ** ------------------------------------- **
      ** Settlement type is 01, 02, 07, 08, 12 **
      ** ------------------------------------- **
 
     C     WFFSETP       WHENEQ    06
 
     C                   MOVE      WFFBRCA       WFFBRCB
     C                   MOVE      BICN          WFFCNUM
     C                   MOVE      BKACCD        WFFACOD
     C                   Z-ADD     1             WFFACSQ
 
      ** ------------------------------------- **
      ** Settlement type is 01, 02, 07, 08, 12 **
      ** ------------------------------------- **
 
     C     WFFSETP       WHENEQ    14
 
     C                   MOVEL     WFFSETA       KAccNum
     C     KAccNum       CHAIN     ACNUM                              71
     C     *IN71         IFEQ      *ON
     C     *IN71         OREQ      *OFF
     C     ACMRECI       ANDNE     'D'
     C                   GOTO      ExFFSettle
     C                   ENDIF
     C                   MOVE      ACMBRCA       WFFBRCB
     C**********         Z-ADD     ACMCNUM       WFFCNUM                                      CSD027
     C                   EVAL      WFFCNUM = ACMCNUM                                          CSD027
     C                   Z-ADD     ACMACOD       WFFACOD
     C                   Z-ADD     ACMACSQ       WFFACSQ
 
      ** --------------------- **
      ** Settlement type is 15 **
      ** --------------------- **
 
     C     WFFSETP       WHENEQ    15
 
     C                   MOVE      WFFBRCA       WFFBRCB
     C**********         Z-ADD     WFFCBCD       WFFCNUM                                      CSD027
     C                   EVAL      WFFCNUM = WFFCBCD                                          CSD027
     C     WFFBRKI       IFEQ      'Y'
      ** - Default Broker Account code
     C                   MOVE      BXACCD        WFFACOD
     C                   ELSE
      ** - Default Customer Account code
     C                   MOVE      BXDCAC        WFFACOD
     C                   ENDIF
     C                   Z-ADD     1             WFFACSQ
 
     C                   ENDSL
 
      ** Retail module is installed
     C     BGRTBN        IFEQ      'Y'
 
     C                   MOVE      WFFACOD       PAccCde04A
     C                   CALLB     'AOACODR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*KEY   '     POption07A
     C                   PARM                    PAccCde04A
     C     SDACOD        PARM      SDACOD        DSSDY
     C     PRtnCde07A    IFEQ      *BLANKS
 
      ** If a Retail account access LF/ACCNT
     C     A5ACTY        IFEQ      'R'
     C                   MOVE      WFFCNUM       KCust
     C                   MOVE      WFFCCY        KCcy
     C                   MOVE      WFFACOD       KAccCde
     C                   MOVE      WFFACSQ       KAccSeq
     C                   MOVE      WFFBRCB       KBrch
     C     KFullAcc      CHAIN     ACCNT                              71
      ** If record exists and is neither flagged for deletion
      ** nor closed then set MEMOS Update ind. to 'Y'.
     C     *IN71         IFEQ      *OFF
     C     ACTRECI       ANDNE     '*'
     C     ACTACST       ANDNE     'C'
     C                   MOVE      'Y'           WFFMIND
     C                   ELSE
     C                   MOVE      'E'           WFFMIND
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     ExFFSettle    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFFPLCL   - Subroutine to calculate profit or loss (and     *
      *               equivalent net transaction value) for a given   *
      *               number of contracts due to a price difference   *
      *               between one price (WZFFPriceX) and another      *
      *               (WZFFPriceY).                                   *
      *                                                               *
      *               Coding was taken from /copy FFPLCLZ1.           *
      *                                                               *
      *        Input:                                                 *
      *               WFFPRCX - Price X                               *
      *               WFFPRCY - Price Y                               *
      *               WFFISPT - Instrument type                       *
      *               WFFCNTT - Contract type                         *
      *               WFFCTAM - Contingent amount                     *
      *               WFFNOC  - Number of contracts                   *
      *               WFFTKVL - Tick value                            *
      *               WFFTKDM - Tick denominator                      *
      *               WFFMNPF - Minimum Price fluctuation             *
      *                                                               *
      *        Output:                                                *
      *               WFFPOL  - Profit or Loss                        *
      *               WFFNTVL - Net transaction value                 *
      *                                                               *
      *****************************************************************
     C     SRFFPLCL      BEGSR
 
      ** Local variables intended for this subroutine only
     C                   Z-ADD     *ZERO         WZFFYldX         15 8
     C                   Z-ADD     *ZERO         WZFFYldY         15 8
     C                   Z-ADD     *ZERO         WZFFPriceX       15 9
     C                   Z-ADD     *ZERO         WZFFPriceY       15 9
     C                   Z-ADD     *ZERO         WFFNTVL
     C                   Z-ADD     *ZERO         WFFPOL
 
      ** If processing type is in range 1 through 6
     C     WFFISPT       IFLE      6
 
      ** Calculate the transaction value for price X
     C                   CALLB     'FFTVCL'
     C                   PARM      0             PFTotValP
     C                   PARM      WFFNOC        PFContractP
     C                   PARM      WFFPRCX       PFPriceP
     C                   PARM      WFFTKDM       PFTckDenomP
     C                   PARM      WFFMNPF       PFMinPriceFlcP
 
     C                   Z-ADD     PFTotValP     WFFNTVL
 
      ** Calculate the transaction value for price Y
     C                   CALLB     'FFTVCL'
     C                   PARM      0             PFTotValP
     C                   PARM      WFFNOC        PFContractP
     C                   PARM      WFFPRCY       PFPriceP
     C                   PARM      WFFTKDM       PFTckDenomP
     C                   PARM      WFFMNPF       PFMinPriceFlcP
 
     C                   SUB       PFTotValP     WFFNTVL
 
      ** Calculate Profit or Loss by multiplying the Net Transaction
      ** Value by the Tick Value
     C     WFFNTVL       MULT      WFFTKVL       WFFPOL
 
     C                   ELSE
      ** If processing type is in range 7 through 8
 
      ** Calculate yields for each price
     C     100           SUB       WFFPRCX       WZFFYldX
     C     100           SUB       WFFPRCY       WZFFYldY
 
      ** Calculate WZFFPriceX and WZFFPriceY by executing subroutine FFYTOP
      ** with WZFFYldX and WZFFYldY.
     C                   CALLB     'FFYTOP'
     C                   PARM      0             PZFFPriceC       15 9
     C                   PARM      WZFFYldX      PZFFYld          15 8
     C                   PARM                    WFFCNTT
     C                   Z-ADD     PZFFPriceC    WZFFPriceX
 
     C                   CALLB     'FFYTOP'
     C                   PARM      0             PZFFPriceC
     C                   PARM      WZFFYldY      PZFFYld
     C                   PARM                    WFFCNTT
     C                   Z-ADD     PZFFPriceC    WZFFPriceY
 
      ** Calculate profit or loss.
      ** i.e., Premium = (WZFFPriceX - WZFFPriceY) x WFFNOC x WFFCTAM
     C     WFFCNTT       IFEQ      1
     C     WFFCNTT       OREQ      2
     C     WFFCTAM       DIV       10000         WW130            13 0
     C     WZFFPriceX    MULT(H)   WW130         WX302            30 2
     C     WZFFPriceY    MULT(H)   WW130         WY302            30 2
     C                   SUB       WY302         WX302
     C                   MULT      100           WX302
     C     WX302         MULT(H)   WFFNOC        WFFPOL
     C                   ELSE
     C     WZFFPriceX    SUB       WZFFPriceY    W309             30 9
     C                   MULT      WFFCTAM       W309
     C     W309          MULT(H)   WFFNOC        WFFPOL
     C                   DIV(H)    100           WFFPOL
     C                   ENDIF
 
      ** Set net transaction value to zero. Whilst this is not the real
      ** value, the value is not used for these processing types and
      ** its calculation if therefore unnecessary.
     C                   Z-ADD     *ZERO         WFFNTVL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   CLOSE     TRANS
     C                   CLOSE     TRSET
     C                   CLOSE     TRANSIN
     C                   CLOSE     TRSETIN
     C                   CLOSE     MEMOSM
     C                   CLOSE     PRONOM
     C                   CLOSE     FFACMVD
     C                   CLOSE     POSTNC
     C                   CLOSE     POSTNK
     C                   CLOSE     CLOST
     C                   CLOSE     CLOST2
     C                   CLOSE     TRANSA
 
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
      **********************************************************************                  CRE020
      *                                                                    *                  CRE020
      * SrUpdAdvice - Update the Retail File Index Advice                  *                  CRE020
      *                                                                    *                  CRE020
      **********************************************************************                  CRE020
     C     SrUpdAdvice   BEGSR                                                                CRE020
                                                                                              CRE020
      ** Set Reference Key                                                                    CRE020
                                                                                              CRE020
     C                   MOVEL     TNBR          RREFNO                                       CRE020
     C                   EVAL      KAdvcRef = RRefNo                                          CRE020
     C                   EVAL      RPRGMN = KAdvcPGM                                          CRE020
     C                   EVAL      RTRTYP = TRTY                                              CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
                                                                                              CRE020
      ** Check READVCL1 if an entry already exists                                            CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
     C     KAdvc         CHAIN     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   IF        %FOUND(READVCL1)                                           CRE020
                                                                                              CRE020
     C                   SELECT                                                               CRE020
                                                                                              CRE020
     C                   WHEN      P0Action = 'A'                                             CRE020
                                                                                              CRE020
      ** If the Transaction was just inserted, print an insert advice instead                 CRE020
      ** of an amendment to advice                                                            CRE020
                                                                                              CRE020
     C                   IF        RCHTYP <> 'I' AND RSAPIN <> 'N'                            CRE020
     C                             OR RCHTYP = 'I' AND RSAPIN = 'Y'                           CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   EVAL      RCHTYP = 'A'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   WHEN      P0Action = 'D'                                             CRE020
                                                                                              CRE020
      ** If the Transaction was just deleted before quiting maintenance,                      CRE020
      ** delete record from advice file, else, setup for a delete advice                      CRE020
                                                                                              CRE020
     C                   IF        RCHTYP = 'I' AND RSAPIN = 'N'                              CRE020
     C                   EVAL      RSAPIN = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   EVAL      RCHTYP = 'D'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C                   ENDSL                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   EVAL      RCHTYP = 'I'                                               CRE020
     C                   EVAL      RSEQNO = *BLANKS                                           CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   WRITE     READVCD0                                                   CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      **********************************************************************                  CRE020
      /EJECT                                                                                  CRE020
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    P0Action
     C                   PARM                    P0Mkt
     C                   PARM                    P0MktNme
     C                   PARM                    P0RunDateA
     C                   PARM                    P0RunDay
     C                   PARM                    P0DateFmt
     C                   PARM                    P0MultBrch
     C                   PARM                    P0BusiDate
     C                   PARM                    P0MktLocCcy
     C                   PARM                    P0MktLocCde
 
      ** LF/DEFLT
     C     KDEFLT        KLIST
     C                   KFLD                    KCBCD
     C                   KFLD                    KMRKT             2
     C                   KFLD                    KISTC             3
 
      ** LF/FOPCC
     C     KFPCC         KLIST
     C                   KFLD                    KBRCAO            3
     C**********         KFLD                    KCBCDO            6 0                        CSD027
     C                   KFLD                    KCBCDO            6                          CSD027
     C                   KFLD                    KISTTO            5
 
      ** LF/FOPCK
     C     KFPCK         KLIST
     C                   KFLD                    KBRCAF            3
     C                   KFLD                    KBOKCF            2
     C                   KFLD                    KISTTF            5
 
      ** LF/CHGCM
     C     KCHGCM        KLIST
     C                   KFLD                    KCCY              3
     C                   KFLD                    KCGCM             2 0
 
      ** LF/CLINT
     C     KCLINT        KLIST
     C**********         KFLD                    KCNUM             6 0                        CSD027
     C                   KFLD                    KCNUM             6                          CSD027
     C                   KFLD                    KRCDT             1
 
      ** LF/CLOST2
     C     KCLST2        KLIST
     C                   KFLD                    KTrans
     C                   KFLD                    KCLON             6 0
 
      ** LF/MEMOSM
     C     KMEMOS        KLIST
     C                   KFLD                    WFFBRCB
     C                   KFLD                    WFFCustP
     C                   KFLD                    WFFCCY
     C                   KFLD                    WFFACOD
     C                   KFLD                    WFFACSQ
 
      ** LF/PRONOM
     C     KPRONO        KLIST
     C                   KFLD                    KCCY
     C                   KFLD                    KNOSNP            2 0
 
      ** LF/POSTNC
     C     KPSTNC        KLIST
     C                   KFLD                    KBRCAC            3
     C**********         KFLD                    KCBCDC            6 0                        CSD027
     C                   KFLD                    KCBCDC            6                          CSD027
     C                   KFLD                    KISTTC            5
     C                   KFLD                    KYRNOC            2 0
     C                   KFLD                    KMTHNC            2 0
     C                   KFLD                    KPCALC            1
     C                   KFLD                    KSTRPC
 
      ** LF/POSTNK
     C     KPSTNK        KLIST
     C                   KFLD                    KBRCAK            3
     C                   KFLD                    KBOKCK            2
     C                   KFLD                    KISTTK            5
     C                   KFLD                    KYRNOK            2 0
     C                   KFLD                    KMTHNK            2 0
     C                   KFLD                    KPCALK            1
     C                   KFLD                    KSTRPK
 
      ** LF/ACCNT
     C     KFullAcc      KLIST
     C                   KFLD                    KCust
     C                   KFLD                    KCcy
     C                   KFLD                    KAccCde
     C                   KFLD                    KAccSeq
     C                   KFLD                    KBrch
 
      ** Key field for LF/ACNUM
     C     *LIKE         DEFINE    ACMACNO       KAccNum
 
      ** Key field for LF/TRANS*
     C     *LIKE         DEFINE    TNBR          KTrans
 
      ** Key field for LF/INTYP*
     C     *LIKE         DEFINE    ISTT          KInsTyp
 
     C     *LIKE         DEFINE    A8BICN        BICN
     C     *LIKE         DEFINE    A8LCCD        BLOC
     C     *LIKE         DEFINE    CBCD          KCBCD
     C     *LIKE         DEFINE    ACTCNUM       KCust
     C     *LIKE         DEFINE    ACTCCY        KCcy
     C     *LIKE         DEFINE    ACTACOD       KAccCde
     C     *LIKE         DEFINE    ACTACSQ       KAccSeq
     C     *LIKE         DEFINE    ACTBRCA       KBrch
     C     *LIKE         DEFINE    COPR          WFFPRCX
     C     *LIKE         DEFINE    STRP          WFFPRCY
     C     *LIKE         DEFINE    ISPT          WFFISPT
     C     *LIKE         DEFINE    FFCNTT        WFFCNTT
     C     *LIKE         DEFINE    FFCTAM        WFFCTAM
     C     *LIKE         DEFINE    TKVL          WFFTKVL
 
      ** NB. RUNDAT data is passed in as parameters
     C     P0DateFmt     COMP      'M'                                    98
     C     P0MultBrch    IFNE      'Y'
     C                   SETON                                            64
     C                   ENDIF
 
      ** Access data area--RUNDAT
     C                   IN        RUNDAT
 
      ** Reset LDA
     C     *LOCK         IN        LDA
     C                   MOVE      *BLANKS       DBFile
     C                   MOVE      *BLANKS       DBKey
     C                   Z-ADD     *ZEROS        DBASE
     C                   MOVEL     PSProcMod     DBPgm
     C                   OUT       LDA
 
      ** Bank ICD details
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*FIRST'      POption07A
     C     SDBANK        PARM      SDBANK        DSFDY
     C     PRtnCde07A    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     01            DBASE
     C                   MOVEL     'SDBANKPD'    DBFile
     C                   MOVEL     '*FIRST  '    DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** General Ledger ICD details
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*FIRST '     POption07A
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
     C     PRtnCde07A    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'SDGELRPD'    DBFile
     C                   MOVEL     '*FIRST  '    DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retail ICD details
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*FIRST '     POption07A
     C     SDRETL        PARM      SDRETL        DSFDY
     C     PRtnCde07A    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     3             DBASE
     C                   MOVEL     'SDRETLPD'    DBFile
     C                   MOVEL     '*FIRST  '    DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Futures and Options ICD details
     C                   CALL      'AOFODAR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*FIRST '     POption07A
     C     SDFODA        PARM      SDFODA        DSFDY
     C     PRtnCde07A    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     4             DBASE
     C                   MOVEL     'SDFODAPD'    DBFile
     C                   MOVEL     '*FIRST  '    DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     BKOBRU        COMP      'Y'                                    61
     C     BKPRCU        COMP      'Y'                                    62
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*FIRST '     POption07A
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     PRtnCde07A    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVEL     'SDMMODPD'    DBFile
     C                   MOVEL     *BLANKS       DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     BJMRDT        P0RunDateA
     C                   Z-ADD     BJRDNB        P0RunDay
     C                   MOVEL     BJDFIN        P0DateFmt
     C                   MOVEL     AGMBIN        P0MultBrch
     C                   MOVEL     BJMRDT        #1MRDT
     C                   MOVEL     PSJobName     #1JOB
     C                   MOVEL     PSUser        #1USER
     C                   MOVEL     BJMRDT        #2MRDT
     C                   MOVEL     PSJobName     #2JOB
     C                   MOVEL     PSUser        #2USER
     C                   MOVEL     BJMRDT        #3MRDT
     C                   MOVEL     PSJobName     #3JOB
     C                   MOVEL     PSUser        #3USER
     C                   MOVEL     BJMRDT        #4MRDT
     C                   MOVEL     PSJobName     #4JOB
     C                   MOVEL     PSUser        #4USER
     C                   MOVEL     BJMRDT        #5MRDT
     C                   MOVEL     PSJobName     #5JOB
     C                   MOVEL     PSUser        #5USER
 
      ** If Portfolio Management is present, access Portfolio ICD to
      ** retrieve "the reference attached to 9997 portfolio"
     C     BGPFMG        IFEQ      'Y'
 
      **   Display narrative on screen
     C                   MOVE      *ON           *IN23
 
     C                   CALLB     'AOPORTR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*FIRST '     POption07A
     C     SDPORT        PARM      SDPORT        DSFDY
     C     PRtnCde07A    IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     6             DBASE
     C                   MOVEL     'SDPORTPD'    DBFile
     C                   MOVEL     *BLANKS       DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVE      *OFF          *IN17
     C                   MOVE      'N'           S01457            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*VERIFY'     POption07A
     C                   PARM      'S01457'      PSAR06A
     C     SCSARD        PARM      SCSARD        DSFDY
     C     PRtnCde07A    IFEQ      *BLANKS
     C                   MOVE      'Y'           S01457
     C                   MOVE      *ON           *IN17
     C                   ELSE
     C     PRtnCde07A    IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     7             DBASE
     C                   MOVEL     'S01457  '    DBKey
     C                   MOVEL     'SCSARDPD'    DBFile
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check switchable features file to see if Enhanced OTC
      ** Processing (Phase II) CFF003 is on.
     C                   MOVE      'N'           CFF003            1
     C                   MOVE      *OFF          *IN29
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*VERIFY'     POption07A
     C                   PARM      'CFF003'      PSAR06A
     C     SCSARD        PARM      SCSARD        DSFDY
     C     PRtnCde07A    IFEQ      *BLANKS
     C                   MOVE      'Y'           CFF003
     C                   MOVE      *ON           *IN29
     C                   ELSE
     C     PRtnCde07A    IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     8             DBASE
     C                   MOVEL     'CFF003  '    DBKey
     C                   MOVEL     'SCSARDPD'    DBFile
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if SAR CAC003 is installed using AOSARDR0
     C                   MOVE      'N'           CAC003            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtnCde07A
     C                   PARM      '*VERIFY'     POption07A
     C                   PARM      'CAC003'      PSAR06A
     C     SCSARD        PARM      SCSARD        DSFDY
     C     PRtnCde07A    IFEQ      *BLANKS
     C                   MOVE      'Y'           CAC003
     C                   ELSE
     C     PRtnCde07A    IFNE      '*NRF   '
     C     *LOCK         IN        LDA
     C                   Z-ADD     9             DBASE
     C                   MOVEL     'SCSARDPD'    DBFile
     C                   MOVEL     'CAC003'      DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if On Line Printing of Advice is on                                            CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtnCde07A                                   CRE020
     C                   PARM      '*VERIFY'     POption07A                                   CRE020
     C                   PARM      'CRE020'      PSar06A                                      CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   IF        PRtnCde07A = *BLANKS                                       CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
                                                                                              CRE020
      ** Check if system value for the maintenance is on                                      CRE020
                                                                                              CRE020
     C                   CALL      'AOSVALR0'                                                 CRE020
     C                   PARM                    PRtCd                                        CRE020
     C                   PARM                    PSValOpt                                     CRE020
     C                   PARM                    PSysVal                                      CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
     C                   PARM                    PSValOptB                                    CRE020
     C                   PARM                    PSysValB                                     CRE020
                                                                                              CRE020
      ** Database Error                                                                       CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> *Blanks AND                                       CRE020
     C                             PRtCd <> '*NRF'                                            CRE020
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBASE = 036                                                CRE020
     C                   EVAL      DBKEY = 'CRE020'                                           CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Database Error                                                                       CRE020
                                                                                              CRE020
     C                   IF        PRtnCde07A <> *BLANKS AND                                  CRE020
     C                             PRtnCde07A <> '*NRF'                                       CRE020
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBASE = 035                                                CRE020
     C                   EVAL      DBKEY = 'CRE020'                                           CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C     KAdvc         KLIST                                                                CRE020
     C                   KFLD                    KAdvcRef                                     CRE020
     C                   KFLD                    KAdvcPGM                                     CRE020
                                                                                              CRE020
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
     OTRANSDF   E            ETRANS
      ** Amend/Delete LF/TRANS (Closing )
     O                       RECI
     O                       TNAR
     O                       LCD
     O                       CHTP
     O                       TNLU
      *
     OTRSETDF   E            DTRSET
      ** Delete LF/TRSET (Closing )
     O                       RECI
      *
     OTRANSDF   E            TTRANS
      ** Amend LF/TRANS (Trade)
     O                       NOCO
     O                       NOBO
     O                       FCIN
     O                       FBIN
     O                       TNLU
      *
     OTRSETDF   E            TTRSET
      ** Amend LF/TRSET (Trade)
     O                       OCSB
     O                       OCDB
     O                       OCSC
     O                       OCDC
     O                       BMAR
     O                       CMAR
      *
     OCLOSTDF   E            CLOSTU
      ** Close Out reversal LF/CLOST
     O                       CORI
     O                       LCD
     O                       CHTP
     O                       TNLU
      *
     OPOSTNCDF  E            CBPSTN
      ** Customer/Broker Position on LF/POSTNC
     O                       LOPC
     O                       SOPC
     O                       CUTV
     O                       RPLD
     O                       TOTM
     O                       LOCO
     O                       SOCO
      *
     OPOSTNKDF  E            BKPSTN
      ** Book Position on LF/POSTNK
     O                       LOPC
     O                       SOPC
     O                       CUTV
     O                       RPLD
      *****************************************************************
** WTbMsg - Error messages
 INVALID COMMAND KEY: PRESS F10 TO DELETE
 CLOSING RECORD HAS BEEN UPDATED BY ANOTHER WORKSTATION
 TRADE RECORD HAS BEEN UPDATED BY ANOTHER WORKSTATION
 TRADE RECORD HAS BEEN DELETED BY ANOTHER WORKSTATION
 CLOSE OUT NUMBER ASSIGNED
** WTbMonth - Month short names
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
