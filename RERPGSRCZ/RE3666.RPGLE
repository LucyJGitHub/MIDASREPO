     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas RE Generate entries - income and expense')       *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE3666 - GENERATE ENTRIES - INCOME & EXPENSE                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE100             Date 21Mar14               *
      *  Prev Amend No. MD022635           Date 30Sep13               *
      *                 MD021155 *CONVERT  Date 10Jul13               *
      *                 MD020099           Date 22Apr13               *
      *                 CRE093             Date 06Aug12               *
      *                 CGL120             Date 06Aug12               *
      *                 261620             Date 28Nov12               *
      *                 220323             Date 06Oct12               *
      *                 CRE083AC           Date 06Aug12               *
      *                 CRE073             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 AR676213           Date 19Nov10               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260297A            Date 28May09               *
      *                 CSC042             Date 16Feb09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12635           Date 19Dec06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4096            Date 03Sep04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CRE008             Date 19Feb02               *
      *                 CGL020             Date 12Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 25Aug00               *
      * Midas DBA 3.04 -----------------------------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 157064             Date 02Jul99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CGL007             Date 26Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 139903             DATE 26JUL98               *
      *                 CSD005             Date 02Mar99               *
      *                 CTI002             DATE 09Sep98               *
      *                 103460             DATE 06Mar98               *
      *                 101709             DATE 29Apr97               *
      *                 CRE001             Date 20Feb97               *
      *                 104075             DATE 12FEB97               *
      *                 095479             DATE 25OCT95               *
      *                 093825             DATE 05OCT95               *
      *                 S01408             DATE 06SEP95               *
      *                 086125             DATE 16MAR95               *
      *                 S01522             DATE 25JAN95               *
      *                 075257             DATE 01SEP94               *
      *                 052664             DATE 02SEP93               *
      *                 S01413 *CREATE     DATE 13APR93               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CRE100 - Allow Customer Number For Retail Accrual And Charge *
      *           Postings.                                           *
      *  MD022635 - Multiple reconciliation differences field OTRF,   *
      *             OTST, FACO needs to be populated.                 *
      *  MD021155 - COB Restructure Phase 1 remnants                  *
      *           - Code not annotated correctly                      *
      *  MD020099 - Amount accrual postings fields for Extension File *
      *             Reference Number and late Accrual Indicator       *
      *             display +++++ instead of zero or blank            *
      *  CRE093 - Tactical COB changes REC3666                        *
      *  CGL120 - GL COB Components Task Split                        *
      *  261620 - Multiple reconciliation differences that seem to be *
      *           caused by CRE008.                                   *
      *           Amended in such a way that the population of FACO,  *
      *           OTRF & OTST will be correct.                        *
      *         - Applied for AR1006287 (Child: AR1006288)            *
      *  220323 - Retail Capitalisation and Income/Expense postings   *
      *           difference. Calculated interest has 0.01            *
      *           discrepancy. Externalise SR/ZICD and patterned      *
      *           additional fix from ZINTDYZ2. Removed *DEFN for     *
      *           fields ZISY2, ZINOM and ZIM2 so that this program   *
      *           can be recompiled. "OUT  LDA" should be performed   *
      *           immediately.  Removed it from SR/*PSSR and placed   *
      *           it in correct location. The correct location should *
      *           be after few lines from *LOCK IN LDA.               *
      *         - Applied for 259032.                                 *
      *         - Added German Feature checking in SCSARDPD.          *
      *  CRE083AC - COB Restructure - RE COB Optimisation Phase 1     *
      *           - Cache details returned by AOACODR0 into an array  *
      *             to minimize calls to the said program             *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  AR676213 - Incorrect definition of CLGLAI field (Recompile)  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *           (Recompile)                                         *
      *  260297A- Incorrect interest calculation w/ calc basis 6.     *
      *           Recompile using the correct src for ZICDREZ2.       *
      *  CSC042 - COB Performance fixes                               *
      *           AOBRCHR* is called more than 1 Million times for    *
      *           205 records.                                        *
      *  BUG12635 - Fix Threshold balance lookup for Rate/Sprd        *
      *             extraction                                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4096 - Extra accrual generated on monthend run. Amended   *
      *            program to end when APDA > DNWD. Applied fix       *
      *            218823.                                            *
      *  CLE025 - Credit Lines                                        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CRE008 - Cash Management                                     *
      *  CGL020 - Midas Compliance Watch - Additional A/C Postings    *
      *           Information                                         *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *           (Recompiled)                                        *
      *  157064 - Amended to post a reversing entry for the accrual   *
      *           account based on the DIIE/CIIE of the secondary     *
      *           account when processing linked accounts during COB. *
      *  CGL007 - Account Postings Enquiry                            *
      *  139903 - Packed field CHGA written to file as zoned causing  *
      *           overwriting of BOKC and other fields, causes        *
      *           MCC0320 to fail.  Also change NITMS                 *
      *  CSD005 - Standing Data Account Narrative.  Add new field     *
      *           to SDACODPD.  Recompilation of programs.            *
      *  CTI002 - Recompiled : File SDACODPD changed                  *
      *  103460 - Only charge interest if the balance exceeds the     *
      *           initial threshhold.                                 *
      *  101709 - Incorrect message id for Retail a/c posting         *
      *           narrative.  New one added to message file.          *
      *  CRE001 - Overdraft Interest Calculation:                     *
      *           Recompiled due to changes in Retail Accrued         *
      *           Interest Charges file LF/REACR.                     *
      *  104075 - Posting date incorrect on non-working days.         *
      *           (Part of 096487).                                   *
      *  095479 - Format Narrative if REPNAR not on.                  *
      *  093825 - No narrative ouput if UDC feature REPNAR is off     *
      *  S01408 - Addition of hook RE3666CCP1.                        *
      *           Addition of hook RE3666OOP1.                        *
      *           Addition of hook RE3666OOP2.                        *
      *  086125 - Add new parameter to AOPNARR0                       *
      *  S01522 - Call to AOPNARR0 if switchable feature installed    *
      *           and UDC present                                     *
      *  075257 - Major accrual probs when have both DR and CR        *
      *           accrual caused by a backvaluation. A CAIC amount is *
      *           used for the following account causing two errors.  *
      *  052664 - Suppress Calculation of Accrued Interest as this    *
      *           will now be done by RE3662.                         *
      *  S01413 - Retail 3 Incorporation.                             *
      *                                                               *
      *****************************************************************
 
     FREACRD    UF   E             DISK    COMMIT
     F                                     RECNO(RRN)
     FACCNT     UF   E           K DISK    COMMIT
     FREACRDPD  IF   E             DISK
     FREHRCJ    IF   E           K DISK
     FREHRDJ    IF   E           K DISK
     FREGAHLJ2  IF   E           K DISK    USROPN
     FREZSHLJ2  IF   E           K DISK    USROPN
     FACRLAR    O    F  110        DISK    COMMIT
     FREACRLZZ  O    F    5        DISK    COMMIT
     FGEIERPD   O    F  620        DISK    COMMIT
     FREGEIEZZ  O    F   23        DISK    COMMIT
     FRE3666AU  O    F  132        PRINTER
     F/COPY WNCPYSRC,RE3666F001
 
      *****************************************************************
      *                                                               *
      *   F U N C T I O N   O F   I N D I C A T O R S                 *
      *                                                               *
      *       02      REACR Detail Record                             *
      *       03      REACR Trailer/Catchall.                         *
      *       04      REACR Closed Account                            *
      *       30      First cycle file header output.                 *
      *       31      Retail A/C No. present                          *
      *       33      Outstanding Debit accrued interest is zero.     *
      *       34      Outstanding Credit accrued interest is zero.    *
      *       40      First cycle calculations done                   *
      *       41      Total CR amt to post is negative                *
      *       42            DR         DITTO                          *
      *       60      Posting amount zero                             *
      *       61      Total accrual zero                              *
      *       70      Profit Centre not used                          *
      *       80      Output GEIER detail                             *
      *       81      Output Debit ACRL record                        *
      *       82      Output Credit ACRL record                       *
      *       83      Debit posting                                   *
      *       84      Credit posting                                  *
      *       85      Update A/C Master record                        *
      *       86      Update REACR detail record                      *
      *       87      No. of records out of balance                   *
      *       91-99   Subroutines.                                    *
      *          U7   Database Error                                  *
      *          U8   File out of Balance                             *
      *                                                               *
      *****************************************************************
 
     ** Arrays to hold acumulating debit & credit hash totals
     ** Items 1 & 2 in each arrays are DR & CR hash totals for ACCNT
     ** Not used by Retail II. because of inclusion of REACR file.
 
     D INT             S             15  0 DIM(3)
     D DEC             S              3  0 DIM(3)
     D ZIR             S             11  7 DIM(11)
     D ZIB             S             15  0 DIM(11) ASCEND
     D ZIN             S             13  0 DIM(11)
     D ZIA             S             15  0 DIM(11)
     D ZIA1            S             30  9 DIM(11)
     D/COPY ZSRSRC,ZDATE2Z1LE
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
                                                                                              CRE100
      ** System Value Array Definition                                                        CRE100
     D SVAL            S             20    DIM(1) CTDATA PERRCD(1)                            CRE100
     D ##BR            S              3    DIM(999)
     D ##BI            S              6    DIM(999)
 
      ** Define array to hold Account Codes and details from AOACODR0.
 
     D ##AC            S             10    DIM(300)
     D ##AR            S             47    DIM(300)
     D #LRU            S             13  0 DIM(300)
     D #LRUC           S             13  0 DIM(300)
     D QQACOD          S              4  0
     D XRFN            S             10  0
     D LTAI            S              1  0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D  TITL         E                     EXTFLD(BJURPT)
     D  DNWD         E                     EXTFLD(BJDNWD)
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** Module Details Accessed via access program
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** SAR File details accessed via access program AOSARDR0
 
     D CGPNAR        E DS                  EXTNAME(CGPNARPD)
      ** UDC Multi Language Narrative Data Structure
 
     D ##PRM1          DS
      ** Data Structure for Customer and Branch
 
     D  A#CUST                 1      6
     D  A#BRCA                 7      9
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer Details Data Structure
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  APDA         E                     EXTFLD(BKAPDT)
     D  PFCU         E                     EXTFLD(BKPRCU)
     D  QQACC1       E                     EXTFLD(QQACCD)
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  LDAC         E                     EXTFLD(BMLDAI)
     D  QQACC2       E                     EXTFLD(QQACCD)
 
      ** Branch Codes Record
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  BICN         E                     EXTFLD(A8BICN)
     D  QQDFA1       E                     EXTFLD(QQDFAC)
 
     D SDACOD        E DS                  EXTNAME(SDACODPD)
     D  ATYP         E                     EXTFLD(A5ACTY)
     D  ACCS         E                     EXTFLD(A5ACSC)
     D  DIAD         E                     EXTFLD(A5DIAD)
     D  DIAC         E                     EXTFLD(A5DIAC)
     D  CIAD         E                     EXTFLD(A5CIAD)
     D  CIAC         E                     EXTFLD(A5CIAC)
     D  QQACC3       E                     EXTFLD(QQACCD)
 
      ** Data Structure for ACOD details caching.
 
     D ACODDS          DS            47
     D  #ATYP                  1      1
     D  #ACCS                  2      3
     D  #DIAD                  4     13
     D  #DIAC                 14     23
     D  #CIAD                 24     33
     D  #CIAC                 34     43
     D  #QQACC                44     47
 
      ** Data Structure for Date format DD/MM/YY
 
     D                 DS
     D  RESULT                 1      6  0
     D  ZDAY                   1      2  0
     D  ZMTH                   3      4  0
     D  ZYEAR                  5      6  0
 
      ** Data Structure for Beginning Date
 
     D                 DS
     D  SRES                   1      6  0
     D  ZISD                   1      2  0
     D  ZISM                   3      4  0
     D  ZISY                   5      6  0
 
      ** Data Structure for Finishing Date
 
     D                 DS
     D  FRES                   1      6  0
     D  ZIFD                   1      2  0
     D  ZIFM                   3      4  0
     D  ZIFY                   5      6  0
 
      ** Data Structure for Beginning Date MM/DD/YY
 
     D                 DS
     D  SRESX                  1      6  0
     D  ZISMX                  1      2  0
     D  ZISDX                  3      4  0
     D  ZISYX                  5      6  0
 
      ** Data Structure for Finishing Date MM/DD/YY
 
     D                 DS
     D  FRESX                  1      6  0
     D  ZIFMX                  1      2  0
     D  ZIFDX                  3      4  0
     D  ZIFYX                  5      6  0
 
      ** Data Structure to split from alpha to numeric Debit and
      ** Credit balances
 
     D WDBAL           DS
     D  ZIBD                   1     88P 0
     D                                     DIM(11)
     D  ZBD01                  1      8P 0
     D  ZBD02                  9     16P 0
     D  ZBD03                 17     24P 0
     D  ZBD04                 25     32P 0
     D  ZBD05                 33     40P 0
     D  ZBD06                 41     48P 0
     D  ZBD07                 49     56P 0
     D  ZBD08                 57     64P 0
     D  ZBD09                 65     72P 0
     D  ZBD10                 73     80P 0
     D  ZBD11                 81     88P 0
     D  ZBD12                 89     96P 0
 
     D WCBAL           DS
     D  ZIBC                   1     88P 0
     D                                     DIM(11)
     D  ZBC01                  1      8P 0
     D  ZBC02                  9     16P 0
     D  ZBC03                 17     24P 0
     D  ZBC04                 25     32P 0
     D  ZBC05                 33     40P 0
     D  ZBC06                 41     48P 0
     D  ZBC07                 49     56P 0
     D  ZBC08                 57     64P 0
     D  ZBC09                 65     72P 0
     D  ZBC10                 73     80P 0
     D  ZBC11                 81     88P 0
     D  ZBC12                 89     96P 0
 
      ** Data Structure to split from alpha to numeric Debit and
      ** Credit rates
 
     D WDRAT           DS
     D  ZIRD                   1     66P 7
     D                                     DIM(11)
     D  ZRD01                  1      6P 7
     D  ZRD02                  7     12P 7
     D  ZRD03                 13     18P 7
     D  ZRD04                 19     24P 7
     D  ZRD05                 25     30P 7
     D  ZRD06                 31     36P 7
     D  ZRD07                 37     42P 7
     D  ZRD08                 43     48P 7
     D  ZRD09                 49     54P 7
     D  ZRD10                 55     60P 7
     D  ZRD11                 61     66P 7
     D  ZRD12                 67     72P 7
 
     D WCRAT           DS
     D  ZIRC                   1     66P 7
     D                                     DIM(11)
     D  ZRC01                  1      6P 7
     D  ZRC02                  7     11P 7
     D  ZRC03                 13     18P 7
     D  ZRC04                 19     24P 7
     D  ZRC05                 25     30P 7
     D  ZRC06                 31     36P 7
     D  ZRC07                 37     42P 7
     D  ZRC08                 43     48P 7
     D  ZRC09                 49     54P 7
     D  ZRC10                 55     60P 7
     D  ZRC11                 61     66P 7
     D  ZRC12                 67     72P 7
     D/COPY WNCPYSRC,RE3666I001
 
      ** Key Data Structure : REHKEY to fill LKEY if error
 
     D                 DS
     D  REHKEY                 1     29
     D  BRCA                   1      3
     D  CNUM                   4      9
     D  REHCCY                10     12
     D  ACOD                  13     22  0
     D  ACSQ                  23     24  0
     D  REHDAT                25     29  0
 
      ** Table Key-Data Structure
 
     D                 DS
     D  KEYTAB                 1     12
      **   KEY FOR ACCOUNT CODES RECORDS
 
     D  RECTKY                 1      2
     D  ACODKY                 2     11
     D  SRECKY                12     12
      ** Key for Branch Codes records
 
     D  BRCAKY                10     12
 
      ** Data Area Rundat
 
     D RUNDAT          DS
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  MBIN                  13     13
 
      ** Standard Local Data Area fields
 
     D LDA             DS           256
     D  LPROC                  1      8
     D  LFILE                134    141
     D  LKEY                 142    170
     D  LPROG                171    180
     D  LDBNO                181    183  0
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183  0
     D  LRUND                187    191  0
     D  LRUNA                192    198
 
      ** Data Structure for key in database error
 
     D ACKEY1          DS
     D  CNUM1                  1      6
     D  CNUM1A                 1      6
     D  CCY1                   7      9
     D  ACOD1                 10     19  0
     D  ACSQ1                 20     21  0
     D  ACSQ1A                20     21
     D  BRCA1                 22     24
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short Data Structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long Data Structure
 
     D DSPNAR          DS            30
      ** DS to set up Posting Narrative
 
     D  D#TXT                  1      6
     D  D#CNUM                 7     12
     D  D#CCY                 13     15
     D  D#ACOD                16     25
     D  D#ACSQ                26     27
     D  D#BRCA                28     30
     D  D#ACNO                14     23
 
      ** Constant Value
 
     D I#TXT           C                   CONST('ACCR. ')
 
      ** Account Master detail record
 
     IACCNTABF
     I              ACNO                        AACNO
     I              DAIC                        ADAIC
     I              CAIC                        ACAIC
     I              GADI                        AGADI
     I              GACI                        AGACI
     I              MADI                        AMADI
     I              MACI                        AMACI
     I              PFCU                        APFCU
 
      ** REACR file - Detail record
 
     IREACRDF
     I              DAIC1                       DAIC
     I              CAIC1                       CAIC
     I              CUST                        CNUM
     I              ACCY                        CCY
     I              ASEQ                        ACSQ
     I              LCD                         RHISD
     I              HISB                        RHISB
 
      ** Rename REHRCJF format fields - REHRCJ file
 
     IREHRCJF
     I              INTH                        INTHC
 
      ** Rename REHRDJF format fields - REHRDJ file
 
     IREHRDJF
     I              INTH                        INTHD
 
     I/COPY WNCPYSRC,RE3666I002
      *****************************************************************
     C/EJECT
      *****************************************************************
 
      ** Key Field to access to REHRDJ/REHRCJ file
 
     C     DCKEY         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    KDATE
 
      ** Key Field to access to ACCNT file
 
     C     ACCKEY        KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    BRCA
 
      ** Work Fields definition
 
     C                   MOVE      *BLANKS       ERRDAT           15
     C     *LIKE         DEFINE    ACOD          ZLYCHK
     C     *LIKE         DEFINE    RUND          ZIBEG
     C     *LIKE         DEFINE    RUND          ZIEND
     C     *LIKE         DEFINE    RUND          KDATE
     C     *LIKE         DEFINE    RUND          ZIBW1
     C     *LIKE         DEFINE    RUND          ZILPCP
     C     *LIKE         DEFINE    RUND          ZIDREM
     C     *LIKE         DEFINE    RUND          ZIDW2
     C     *LIKE         DEFINE    RUND          ZID1
     C     *LIKE         DEFINE    RUND          ZID2
     C     *LIKE         DEFINE    RUND          ZLDTM
     C     *LIKE         DEFINE    RUND          ZIREM
     C     *LIKE         DEFINE    RHISB         DINT
     C     *LIKE         DEFINE    RHISB         CINT
     C     *LIKE         DEFINE    RHISB         ZIAMT
     C     *LIKE         DEFINE    RHISB         ZIAMT1
     C     *LIKE         DEFINE    RHISB         ZIAMTR
     C     *LIKE         DEFINE    RHISB         ZITHR
     C     *LIKE         DEFINE    RHISB         ZBAL
     C     *LIKE         DEFINE    DRIC          ZERROR
     C     *LIKE         DEFINE    DRIC          ZICALC
     C     *LIKE         DEFINE    DRIC          LOOP
     C     *LIKE         DEFINE    ACSQ          ZICT
     C     *LIKE         DEFINE    ACSQ          ZIDW1
     C     *LIKE         DEFINE    ACSQ          ZIM1
     C     *LIKE         DEFINE    ACSQ          ZLYREM
     C     *LIKE         DEFINE    ACSQ          ZIY1
     C     *LIKE         DEFINE    ACSQ          ZIMAN
     C     *LIKE         DEFINE    ACSQ          Z
     C     *LIKE         DEFINE    ACSQ          Y
     C                   Z-ADD     *ZEROS        ZIFY2             3 0
     C     *LIKE         DEFINE    DIIE          ZINTR
     C     *LIKE         DEFINE    DRIS          ZIRATE
 
     C     *DTAARA       DEFINE                  LDA
     C     *DTAARA       DEFINE                  RUNDAT
 
      **   First Cycle Calcs
 
     C                   SETOFF                                       30
     C  N40              SETON                                        30
     C   40              GOTO      DETAIL
     C                   SETON                                        40
     C                   Z-ADD     0             QQACOD
     C                   Z-ADD     0             XRFN
     C                   Z-ADD     0             LTAI
     C                   MOVEA     CPY@          BIS@             80
     C                   Z-ADD     0             ##BNDX            4 0
     C     *LIKE         DEFINE    ##BNDX        B
     C     *LIKE         DEFINE    ##BNDX        ##BSV
 
      ** Define variables for LRU and initializations
 
     C                   Z-ADD     0             #LEAST           13 0
     C     *LIKE         DEFINE    #LEAST        ##LC
 
     C                   Z-ADD     0             ##ANDX            4 0
     C     *LIKE         DEFINE    ##ANDX        A
     C     *LIKE         DEFINE    ##ANDX        ##ASAV
     C                   Z-ADD     300           ##ANDX
     C                   Z-ADD     0             ##LC
 
     C                   IN        RUNDAT
 
     C                   MOVE      ' '           BLK200          200
     C                   BITOFF    '1'           PRIN              1
 
     C                   Z-ADD     RUND          LRUND
     C                   MOVE      RUNA          LRUNA
 
     C     DATF          IFEQ      'M'
     C                   SETON                                        98
     C                   END
 
     C                   MOVEL     'RE3666'      LPROG
     C                   MOVEL     'RE3666'      DBPGM
     C                   MOVE      *BLANKS       LFILE
     C                   MOVEL     'REACR'       LFILE
     C                   MOVEL     'ZERROR'      ERRDAT
     C                   MOVE      ' =    '      ERRDAT
     C                   Z-ADD     *ZEROS        ZIWRK1           30 9
     C                   Z-ADD     *ZEROS        ZIWRK2           30 9
     C                   Z-ADD     *ZEROS        ZDAYN2            9 4
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     001           DBASE
     C                   OUT       LDA
     C                   SETON                                        U7LR
     C                   EXSR      *PSSR
     C                   END
 
     C/COPY WNCPYSRC,RE3666C024
 
      ** Call Module Prog. for module details.
     C                   CALL      'AOMMODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     86            DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7LR
     C                   EXSR      *PSSR
     C                   ELSE
     C/COPY WNCPYSRC,REH00404
 
      ** Call SAR Prog. for Switchable feature
 
     C                   MOVE      'N'           REPNAR            1
     C                   MOVE      '0'           *IN65
     C     BGN1ST        IFEQ      'Y'
     C/COPY WNCPYSRC,REH00405
 
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'REPNAR'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     87            DBASE
     C                   MOVEL     @SARD         DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7LR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           REPNAR
     C                   MOVE      '1'           *IN65
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Access SAR details to see if CGL020 is enabled.
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL020'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   MOVE      'N'           CGL020            1
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL020
     C                   ELSE
 
     C     @RTCD         IFNE      '*NRF'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     @SARD         DBKEY
     C                   Z-ADD     88            DBASE
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INLR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** Determine if Cash Management is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE008'      @SARD
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     210           DBASE
     C                   MOVEL     @SARD         DBKEY
     C                   SETON                                        U7LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRE008            1
     C                   OPEN      REGAHLJ2
     C                   OPEN      REZSHLJ2
     C                   ENDIF
 
      ** Call AOSARDR0 to check for CER016
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CER016'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CER016            1
     C                   MOVE      'Y'           WFIRST            1
 
     C                   ELSE
     C                   MOVE      'N'           CER016
     C                   MOVE      'N'           WFIRST
     C                   ENDIF
 
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
 
     C     *LOCK         IN        LDA
     C                   MOVEL     'CER016'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     106           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
                                                                                              CRE100
      ** Determine system values whether internal postings for interest                       CRE100
      ** accrual should be posted at customer or bank level.                                  CRE100
                                                                                              CRE100
     C                   Eval      *IN38 = *Off                                               CRE100
      *                                                                                       CRE100
     C                   Call      'AOSVALR0'                                                 CRE100
     C                   Parm      *Blanks       W0RTCD            1                          CRE100
     C                   Parm      SVAL(1)       PVALK1           20                          CRE100
     C                   Parm      *Blanks       PVAL1           200                          CRE100
     C                   Parm      *Blanks       PVALK2           20                          CRE100
     C                   Parm      *Blanks       PVAL2           200                          CRE100
     C                   Parm      *Blanks       PVALK3           20                          CRE100
     C                   Parm      *Blanks       PVAL3           200                          CRE100
     C                   Parm      *Blanks       PVALK4           20                          CRE100
     C                   Parm      *Blanks       PVAL4           200                          CRE100
     C                   Parm      *Blanks       PVALK5           20                          CRE100
     C                   Parm      *Blanks       PVAL5           200                          CRE100
     C                   Parm      *Blanks       PVALK6           20                          CRE100
     C                   Parm      *Blanks       PVAL6           200                          CRE100
     C                   Parm      *Blanks       PVALK7           20                          CRE100
     C                   PARM      *Blanks       PVAL7           200                          CRE100
     C                   PARM      *Blanks       PVALK8           20                          CRE100
     C                   PARM      *Blanks       PVAL8           200                          CRE100
     C                   PARM      *Blanks       PVALK9           20                          CRE100
     C                   PARM      *Blanks       PVAL9           200                          CRE100
     C                   PARM      *Blanks       PVALK10          20                          CRE100
     C                   PARM      *Blanks       PVAL10          200                          CRE100
      *                                                                                       CRE100
     C                   If        W0RTCD = *Blanks                                           CRE100
      *                                                                                       CRE100
     C                   If        PVAL1 = 'Y'                                                CRE100
     C                   Eval      *IN38 = *On                                                CRE100
     C                   Endif                                                                CRE100
      *                                                                                       CRE100
     C                   Else                                                                 CRE100
      *                                                                                       CRE100
     C                   If        W0RTCD <> '*NRF'                                           CRE100
     C     *Lock         In        LDA                                                        CRE100
     C                   Eval      DBASE = 107                                                CRE100
     C                   Eval      DBFILE = 'SDSVALPD'                                        CRE100
     C                   Eval      DBKEY = PVALK1                                             CRE100
     C                   Out       LDA                                                        CRE100
     C                   Exsr      *PSSR                                                      CRE100
     C                   Endif                                                                CRE100
      *                                                                                       CRE100
     C                   Endif                                                                CRE100
 
     C/COPY WNCPYSRC,RE3666C031
     C                   CALL      'AOGELRR1'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
     C/COPY WNCPYSRC,RE3666C032
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     002           DBASE
     C                   OUT       LDA
     C                   SETON                                        U7LR
     C                   EXSR      *PSSR
     C                   END
 
      ** If Profit Centre is not used, blank the Profit Centre field
      ** in all related files
 
     C     PFCU          IFNE      'Y'
     C                   SETON                                        70
     C                   END
 
     C     MBIN          IFEQ      'Y'
     C                   MOVE      '1'           *IN50
     C                   ELSE
     C                   MOVE      '0'           *IN50
     C                   END
     C/COPY WNCPYSRC,RE3666C019
 
     C   LR              GOTO      END
 
     C                   CALL      'AORETLR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDRETLPD'    DBFILE
     C                   MOVEL     @OPTN         DBKEY
     C                   Z-ADD     007           DBASE
     C                   OUT       LDA
     C                   SETON                                        U7LR
     C                   EXSR      *PSSR
     C                   END
 
     C   LR              GOTO      END
 
     C                   Z-ADD     RUND          RNDT              5 0
     C                   Z-ADD     APDA          RUND
 
     C     LDAC          IFNE      'Y'
     C                   ADD       1             RUND
     C                   END
 
     C                   Z-ADD     0             ZERO03            3 0
     C                   Z-ADD     0             ZERO5             5 0
     C                   Z-ADD     0             ZERO15           15 0
     C                   Z-ADD     0             ZERO13           13 0
 
     C                   MOVE      '  '          BLNK12           12
 
     C                   Z-ADD     0             RRACM             5 0
     C                   Z-ADD     0             RRN               9 0
 
     C/COPY WNCPYSRC,RE3666CCP1
 
      ** Initialise Account Posting fields for PF/GEIERPD.
 
     C                   Z-ADD     *ZEROS        SDLB             15 0
     C                   Z-ADD     *ZEROS        SDCB             15 0
     C                   Z-ADD     *ZEROS        CHGA             13 0
     C                   MOVE      *BLANK        REBI              1
     C                   MOVE      *BLANKS       PRFC              4
     C                   MOVE      *BLANKS       OTRF             21
     C                   MOVEL     '91080'       OTTP             10
     C                   MOVE      *BLANKS       OTST             10
     C                   MOVE      *BLANKS       BOKC              2
 
      ** Initialise fields for Management Accounting
 
     C                   Z-ADD     0             VOIN              1 0
     C                   Z-ADD     235959        PTIM              6 0
     C                   Z-ADD     1             NITMS             5 0
 
      ** Clear the AML Fee Fields for CGL020 enhancement
 
     C                   MOVE      *BLANK        ACKEY            20
     C                   MOVE      *BLANK        FEEFLG            1
     C                   Z-ADD     0             FEEVAL           13 0
     C                   Z-ADD     0             FEEPCT            5 2
     C                   MOVE      *BLANKS       RORACT           20
     C                   MOVE      *BLANKS       RORCTY            2
     C                   MOVE      *BLANKS       RORBNK           20
     C                   MOVE      *BLANKS       RORCDE           11
     C                   MOVE      *BLANKS       PORACT           20
     C                   MOVE      *BLANKS       PORCTY            2
     C                   MOVE      *BLANKS       PORBNK           20
     C                   MOVE      *BLANKS       PORCDE           11
     C                   MOVE      *BLANKS       DSTACT           35
     C                   MOVE      *BLANKS       DSTCTY            2
     C                   MOVE      *BLANKS       DSTBNK           20
     C                   Z-ADD     *ZEROS        SETDAT            5 0
     C                   MOVE      *BLANKS       TICKER           10
     C                   MOVE      *BLANKS       EXCHNG           20
     C                   Z-ADD     *ZEROS        NOMINL           13 2
     C                   MOVE      *BLANKS       FPTRID           16
     C                   Z-ADD     0             ORAMT            13 0
 
      ** Main Processing
 
     C     DETAIL        TAG
 
      ** Do not generate postings if Accr Profit Date > Next Working Day
 
     C     APDA          IFGE      DNWD
     C                   MOVE      *ON           *INLR
     C                   GOTO      END
     C                   ENDIF
 
     C                   READ      REACRDPD
     C     REFERN        SETLL     REACRD
     C                   READ      REACRD
     C                   DOW       NOT %EOF(REACRD) AND RRN <= RETERN
 
      ** Set off Indicators
 
     C                   SETOFF                                       020304
     C                   SETOFF                                       6082
     C                   SETOFF                                       808185
     C                   MOVE      '0'           *IN86
 
     C/COPY WNCPYSRC,RE3666C025
 
      ** Records read
 
     C     RECI          IFEQ      'D'
 
     C                   SETON                                        02
     C                   ELSE
     C     RECI          IFEQ      'C'
     C                   SETON                                        04
     C                   ELSE
     C                   SETON                                        03
     C                   END
 
     C                   END
     C   04
     COR 02RRACM         ADD       1             RRACM
 
     C   04
     COR 03              GOTO      END
 
      ** Access Details
      ** Get Account Codes details
 
     C                   MOVE      ACOD          ACODKY
     C/COPY WNCPYSRC,RE3666C012
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      ACODKY        @ACOD            10
     C     SDACOD        PARM      SDACOD        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDACODPD'    DBFILE
     C                   MOVEL     @ACOD         DBKEY
     C                   Z-ADD     004           DBASE
     C                   OUT       LDA
     C                   SETON                                        U7LR
     C                   EXSR      *PSSR
     C                   END
     C   U7              GOTO      END
 
      ** Get Branch details
 
     C                   MOVEL     BRCA          ##KB
     C                   EXSR      ##CHKB
 
      ** If branch is in the array then use the details
 
     C     ##FIC         IFEQ      'Y'
     C                   EXSR      ##SETB
     C                   ELSE
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BRCA          @BRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     @BRCA         DBKEY
     C                   Z-ADD     005           DBASE
     C                   OUT       LDA
     C                   SETON                                        U7LR
     C                   EXSR      *PSSR
     C                   ELSE
 
      ** Details found on the DB so add them to the array
      ** if the array still has room
 
     C                   EXSR      ##ADDB
     C                   END
     C                   ENDIF
     C   U7              GOTO      END
 
      ** Save original Account Code information for future use
 
     C                   MOVE      DIAD          DIAD1            10
     C                   MOVE      DIAC          DIAC1            10
     C                   MOVE      CIAD          CIAD1            10
     C                   MOVE      CIAC          CIAC1            10
     C/COPY WNCPYSRC,RE3666C014
 
      ** Interest calculation between two dates and update DR/CR
      ** interest on REACR file
 
     C                   MOVE      CNUM          CNUM1
     C                   MOVE      CCY           CCY1
     C                   MOVE      ACOD          ACOD1
     C                   MOVE      ACSQ          ACSQ1
     C                   MOVE      BRCA          BRCA1
     C                   EXSR      ACTCHN
     C   U7              GOTO      END
     C/COPY WNCPYSRC,RE3666C004
 
     C                   Z-ADD     *ZEROS        DINT
     C                   Z-ADD     *ZEROS        CINT
     C                   Z-ADD     *ZEROS        INRT
     C                   Z-ADD     *ZEROS        INTP
     C                   Z-ADD     *ZEROS        ZINTR
     C                   Z-ADD     *ZEROS        ZLDTM
 
      ** Suppress calculation of accrued interest as this is now
      ** done by RE3662
 
     C     DINT          IFNE      0
     C     CINT          ORNE      0
     C                   ADD       DINT          DAIC
     C                   ADD       CINT          CAIC
     C                   MOVE      '1'           *IN86
     C                   EXSR      OUTPUT
     C                   END
 
      ** Process Debits
 
     C     DEBITS        TAG
 
      ** Do not process debit accruals for secondary accounts.
      ** Instead, post a reversing entry to PF/GEIERPD and also
      ** to PF/ACRLAR when DIIE is not equal to zero.
 
     C     LTAC          IFEQ      *ZERO
     C/COPY WNCPYSRC,RE3666C005
     C                   Z-ADD     DAIC          OAINTD           15 0
     C     OAINTD        ADD       MADI          OAINTD
     C     OAINTD        ADD       GADI          OAINTD
     C     OAINTD        COMP      0                                      33
 
     C     AACNO         COMP      0                                  3131
     C     OAINTD        SUB       DIIE          PSTAD            13 0  4260
     C                   ELSE
     C                   Z-SUB     DIIE          PSTAD                  4260
     C                   ENDIF
     C     DIIE          ADD       PSTAD         DAID             13 0    61
     C   61DIIE          COMP      0                                      61
     C                   Z-ADD     PSTAD         DAIP             13 0
     C   42              Z-SUB     PSTAD         PSTAD
 
      ** Do not output record if total is zero & no changes this month
 
     C   61              GOTO      DGEIER
     C                   SETON                                        81
     C                   EXSR      OUTPUT
     C     RWACRL        ADD       1             RWACRL            5 0
 
      ** If zero do not output debit interest posting records
 
     C     DGEIER        TAG
 
     C   60              GOTO      CREDIT
 
      ** Posting to income amount - CR if interest is debit
 
     C                   MOVE      DIAC1         ACODGE           10
     C/COPY WNCPYSRC,RE3666C015
     C                   MOVE      '1'           DRCRGE            1
     C   42              MOVE      '0'           DRCRGE
     C                   EXSR      ACDCHN
     C   LR              GOTO      END
 
     C                   SETON                                        8083
     C/COPY WNCPYSRC,RE3666C026
     C*****CRE008        IFEQ      'Y'                                                      MD022635
     C                   MOVEL     DIAC1         OTST
     C                   MOVE      'DIAC'        OTST
     C**********         ENDIF                                                              MD022635
     C                   EXSR      OUTPUT
     C*****CRE008        IFEQ      'Y'                                                      MD022635
     C                   MOVEL     *BLANK        OTST
     C**********         ENDIF                                                              MD022635
     C/COPY WNCPYSRC,RE3666C027
 
      ** Posting to A.I. receivable account - DB if interest is debit
 
     C                   MOVE      DIAD1         ACODGE
     C/COPY WNCPYSRC,RE3666C016
     C                   MOVE      '0'           DRCRGE
     C   42              MOVE      '1'           DRCRGE
     C                   EXSR      ACDCHN
     C   LR              GOTO      END
 
     C                   SETON                                        8083
     C*****CRE008        IFEQ      'Y'                                                      MD022635
     C                   MOVEL     DIAD1         OTST
     C                   MOVE      'DIAD'        OTST
     C**********         ENDIF                                                              MD022635
     C                   EXSR      OUTPUT
     C*****CRE008        IFEQ      'Y'                                                      MD022635
     C                   MOVEL     *BLANK        OTST
     C**********         ENDIF                                                              MD022635
 
      ** Control Totals
      ** Hash total of records written to GEIER
 
     C                   Z-ADD     3             S                 2 0
     C     PSTAD         DIV       500           ZZAMT
     C                   EXSR      HASH
 
      ** Count of records written to GEIER
 
     C     RWGEI         ADD       2             RWGEI             5 0
 
      ** Process Credits
 
     C     CREDIT        TAG
 
      ** Do not process credit accruals for secondary accounts.
      ** Instead, post a reversing entry to PF/GEIERPD and also
      ** to PF/ACRLAR when CIIE is not equal to zero.
     C     LTAC          IFEQ      *ZERO
     C                   Z-ADD     CAIC          OAINTC           15 0
     C     OAINTC        ADD       MACI          OAINTC
     C     OAINTC        ADD       GACI          OAINTC
     C     OAINTC        COMP      0                                      34
 
     C     AACNO         COMP      0                                  3131
     C     OAINTC        SUB       CIIE          PSTAC            13 0  4160
     C                   ELSE
     C                   Z-SUB     CIIE          PSTAC                  4160
     C                   ENDIF
     C     CIIE          ADD       PSTAC         CAID             13 0    61
     C   61CIIE          COMP      0                                      61
     C                   Z-ADD     PSTAC         CAIP             13 0
     C   41              Z-SUB     PSTAC         PSTAC
 
      ** Do not output record if total is zero & no changes this month
 
     C   61              GOTO      CGEIER
     C                   SETON                                        82
     C                   EXSR      OUTPUT
     C     RWACRL        ADD       1             RWACRL
 
      ** If zero do not output credit interest posting records
 
     C     CGEIER        TAG
 
     C   60              GOTO      END1
 
      ** Posting to Expense Account - DR if interest is credit
 
     C                   MOVE      CIAD1         ACODGE
     C/COPY WNCPYSRC,RE3666C017
     C                   MOVE      '1'           DRCRGE
     C  N41              MOVE      '0'           DRCRGE
     C                   EXSR      ACDCHN
     C   LR              GOTO      END
 
     C                   SETON                                        8084
     C/COPY WNCPYSRC,RE3666C028
     C*****CRE008        IFEQ      'Y'                                                      MD022635
     C                   MOVEL     CIAD1         OTST
     C                   MOVE      'CIAD'        OTST
     C**********         ENDIF                                                              MD022635
     C                   EXSR      OUTPUT
     C*****CRE008        IFEQ      'Y'                                                      MD022635
     C                   MOVEL     *BLANK        OTST
     C**********         ENDIF                                                              MD022635
     C/COPY WNCPYSRC,RE3666C029
 
      ** Posting to A.I. payable account - CR if interest is credit
 
     C                   MOVE      CIAC1         ACODGE
     C/COPY WNCPYSRC,RE3666C018
     C                   MOVE      '0'           DRCRGE
     C  N41              MOVE      '1'           DRCRGE
     C                   EXSR      ACDCHN
     C   LR              GOTO      END
     C                   SETON                                        8084
     C*****CRE008        IFEQ      'Y'                                                      MD022635
     C                   MOVEL     CIAC1         OTST
     C                   MOVE      'CIAC'        OTST
     C**********         ENDIF                                                              MD022635
     C                   EXSR      OUTPUT
     C*****CRE008        IFEQ      'Y'                                                      MD022635
     C                   MOVEL     *BLANK        OTST
     C**********         ENDIF                                                              MD022635
 
      ** Hash total of records written to GEIER
 
     C                   Z-ADD     3             S
     C     PSTAC         DIV       500           ZZAMT
     C                   EXSR      HASH
 
      ** Count of records written to GEIER
 
     C     RWGEI         ADD       2             RWGEI
     C/COPY WNCPYSRC,RE3666C006
 
     C     END1          TAG
 
      ** Update ACCNT record with new fields
 
     C                   SETON                                        85
     C                   EXSR      OUTPUT
     C/COPY WNCPYSRC,REH00153
     C     END           TAG
 
     C                   MOVEL     LKEY          KEY              15
     C     *INLR         IFEQ      *ON
     C     *INU7         ANDEQ     *ON
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   READ      REACRD
     C                   ENDDO
 
      ** Update trailers
      ** REACRLZZ trailer
 
     C                   ADD       RWACRL        NOREZ             5 0
 
      ** REGEIEZZ trailer
 
     C                   ADD       RWGEI         NORE1             5 0
     C     HRWN          MULT      1000          #WRK20           20 0
     C     #WRK20        ADD       HRDC          TFILE            20 0
     C     INT(3)        MULT      1000          #WRK20
     C     #WRK20        ADD       DEC(3)        TCOUN            20 0
     C     TCOUN         ADD       TFILE         #WRK20
     C     #WRK20        DIV       1000          HRWN             15 0
     C     HRWN          MULT      1000          #HRWN            20 0
     C     #WRK20        SUB       #HRWN         HRDC              3 0
 
     C                   MOVE      *ON           *INLR
 
      ** Level Breaks & Subroutines
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  ##CHKA - check if ACOD is already cached in the array.       *
      *      Called by: ACDCHN                                        *
      *      Calls: None                                              *
      *****************************************************************
     C     ##CHKA        BEGSR
     C                   MOVE      *IN20         #IN20             1
 
     C                   ADD       1             ##LC
     C     *LIKE         DEFINE    ACODGE        ##KA
     C                   MOVEL     *BLANK        ##AFIC            1
 
      ** Restore saved value of A index
 
     C                   Z-ADD     ##ASAV        A
 
      ** Defend against A == 0
 
     C     A             IFEQ      0
     C                   Z-ADD     1             A
     C                   ENDIF
 
      ** Is this the same as the last LOKUP? if so, we can bypass LOKUP
 
     C     ##KA          IFEQ      ##AC(A)
     C                   SETON                                        20
     C                   ELSE
 
      ** Begin lookup from last saved or if full, start from 1.
 
     C     ##ANDX        IFEQ      0
     C                   Z-ADD     1             A
     C                   ELSE
     C                   Z-ADD     ##ANDX        A
     C                   ENDIF
 
     C     ##KA          LOOKUP    ##AC(A)                                20
     C                   ENDIF
 
     C     *IN20         IFEQ      *ON
 
      ** Update LRU
 
     C                   MOVE      ##LC          #LRU(A)
 
      ** Save the last update to A
 
     C                   Z-ADD     A             ##ASAV
 
      ** Turn on indicator so that program will know it is in the array
 
     C                   MOVEL     'Y'           ##AFIC
     C                   ENDIF
 
     C                   MOVE      #IN20         *IN20
     C                   ENDSR
      *****************************************************************
      *  ##ADDA - This subroutine adds the newly acquired SDACOD to   *
      *           the cache. If the cache is full, it replaces the    *
      *           least recently used.                                *
      *      Called by: ACDCHN                                        *
      *      Calls: None                                              *
      *****************************************************************
     C     ##ADDA        BEGSR
     C                   MOVE      *IN40         #IN40             1
 
      ** Check if there is still an available slot in the array.
 
     C     ##ANDX        IFNE      0
     C                   Z-ADD     ##ANDX        A
 
     C                   MOVE      ATYP          #ATYP
     C                   MOVE      ACCS          #ACCS
     C                   MOVE      DIAD          #DIAD
     C                   MOVE      DIAC          #DIAC
     C                   MOVE      CIAD          #CIAD
     C                   MOVE      CIAC          #CIAC
     C                   MOVE      QQACC3        #QQACC
 
     C                   MOVE      ACODGE        ##AC(A)
     C                   MOVE      ACODDS        ##AR(A)
 
     C                   MOVE      ##LC          #LRU(A)
     C                   SUB       1             ##ANDX
 
      ** Else replace the LRU
 
     C                   ELSE
     C                   Z-ADD     1             A
     C                   MOVEA     #LRU          #LRUC
     C                   SORTA     #LRUC
     C                   Z-ADD     #LRUC(1)      #LEAST
     C     #LEAST        LOOKUP    #LRU(A)                                40
 
     C                   MOVE      ATYP          #ATYP
     C                   MOVE      ACCS          #ACCS
     C                   MOVE      DIAD          #DIAD
     C                   MOVE      DIAC          #DIAC
     C                   MOVE      CIAD          #CIAD
     C                   MOVE      CIAC          #CIAC
     C                   MOVE      QQACC3        #QQACC
 
     C                   MOVE      ACODGE        ##AC(A)
     C                   MOVE      ACODDS        ##AR(A)
 
     C                   MOVE      ##LC          #LRU(A)
     C                   ENDIF
 
      ** Update ASAVE so next call to ##CHKB checks
      ** this newly added element.
 
     C                   Z-ADD     A             ##ASAV
     C                   MOVE      #IN40         *IN40
     C                   ENDSR
      *****************************************************************
      *  ##SETA - Retrieve data from the cache.                       *
      *      Called by: ACDCHN                                        *
      *      Calls: None                                              *
      *****************************************************************
     C     ##SETA        BEGSR
     C                   MOVEL     ##AC(A)       ACODGE
     C                   MOVEL     ##AR(A)       ACODDS
     C                   MOVE      #ATYP         ATYP
     C                   MOVE      #ACCS         ACCS
     C                   MOVE      #DIAD         DIAD
     C                   MOVE      #DIAC         DIAC
     C                   MOVE      #CIAD         CIAD
     C                   MOVE      #CIAC         CIAC
     C                   MOVE      #QQACC        QQACC3
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** ##CHKB - Subroutine to check the Branch in the arrays
 
     C     ##CHKB        BEGSR
 
     C     *LIKE         DEFINE    A8BRCD        ##KB
 
      ** Set off the branch found indicator
 
     C                   MOVEL     *BLANK        ##FIC             1
 
      ** Save the state of indicator 30 so it can be reset at the end
      ** of the SR as it may be used elsewhere in the code
 
     C     *IN30         IFEQ      *ON
     C                   MOVEL     'Y'           #IN30             1
     C                   ELSE
     C                   MOVEL     'N'           #IN30
     C                   ENDIF
 
     C                   SETOFF                                           30
 
      ** Restore the saved Value of B
 
     C                   Z-ADD     ##BSV         B
 
      ** Check whether details for Branch already in array
      ** Is this the same as the last LOKUP, if so we can bypass
      ** the LOKUP
      ** Defend against B being 0
 
     C     B             IFEQ      0
     C                   Z-ADD     1             B
     C                   ENDIF
 
      ** If the branch being checked is the same then use these
      ** details rather than doing a LOKUP
 
     C     ##KB          IFEQ      ##BR(B)
 
      ** Found so seton 30
 
     C                   SETON                                            30
     C                   ELSE
     C                   Z-ADD     1             B
     C     ##KB          LOOKUP    ##BR(B)                                30
     C                   ENDIF
 
      ** Save the last update to B
 
     C     *IN30         IFEQ      *ON
     C                   Z-ADD     B             ##BSV
 
      ** Set the indicator to show the data was found
 
     C                   MOVEL     'Y'           ##FIC
     C                   ENDIF
 
      ** Reset the state of indicator 30.
 
     C     #IN30         IFEQ      'Y'
     C                   MOVEL     *ON           *IN30
     C                   ELSE
     C                   MOVEL     *OFF          *IN30
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** ##SETB - Sets up the SDBRCHPD fields used in the code from the
      ** arrays
 
     C     ##SETB        BEGSR
 
     C                   MOVEL     ##BR(B)       A8BRCD
     C                   MOVEL     ##BI(B)       BICN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** ##ADDB - Adds the SDBRCHPD fields used in the code to the
      ** arrays
 
     C     ##ADDB        BEGSR
 
      ** If there is still room in the array then add the details
 
     C     ##BNDX        IFLT      999
     C                   ADD       1             ##BNDX
     C                   Z-ADD     ##BNDX        B
     C                   MOVEL     A8BRCD        ##BR(B)
     C                   MOVEL     BICN          ##BI(B)
     C                   ENDIF
 
      ** Update ##BSV  so next call to ##CHKB checks this latest
      ** addition to the array files
 
     C                   Z-ADD     B             ##BSV
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Subr. to chain to A/C Codes table records
 
     C     ACDCHN        BEGSR
 
     C                   MOVEL     ACODGE        ##KA
     C                   EXSR      ##CHKA
 
     C     ##AFIC        IFEQ      'Y'
     C                   EXSR      ##SETA
     C                   ELSE
     C                   CALL      'AOACODR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      ACODGE        @ACOD
     C     SDACOD        PARM      SDACOD        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDACODPD'    DBFILE
     C                   MOVEL     @ACOD         DBKEY
     C                   Z-ADD     006           DBASE
     C                   OUT       LDA
     C                   SETON                                        U7LR
     C                   EXSR      *PSSR
     C                   ELSE
 
      ** If found, add the details into the array
 
     C                   EXSR      ##ADDA
     C                   END
     C                   ENDIF
     C                   ENDSR
 
      ** Subr. to do EXCPT OUTPUT
 
     C     OUTPUT        BEGSR
 
      ** Move values to exception fields
 
     C                   Z-ADD     DIIE          DAIL             13 0
     C                   Z-ADD     CIIE          CAIL             13 0
     C                   Z-ADD     ZIEND         RHISD
     C                   Z-ADD     APDA          LPAR
 
      ** CIIE must be conditioned otherwise DR output will change CIIE
      ** before it is used in credit selection check for *IN60.
 
     C     *IN83         IFEQ      '1'
     C                   Z-ADD     DAID          DIIE
     C                   END
     C                   Z-ADD     APDA          LPAP
     C     *IN84         IFEQ      '1'
     C                   Z-ADD     CAID          CIIE
     C                   END
 
     C/COPY WNCPYSRC,REH00166
     C     *IN70         IFEQ      '1'
     C                   MOVE      *BLANKS       PRFC
     C                   END
 
      ** Get the posting narrative if a posting is to be output.
 
     C     *IN80         IFEQ      *ON
     C                   EXSR      SRPNAR
     C/COPY WNCPYSRC,RE3666C030
     C                   ENDIF
     C     *IN80         IFEQ      *ON
     C*****CRE008        ANDEQ     'Y'                                                      MD022635
     C                   EXSR      ACCDET
     C                   ENDIF
     C                   Z-ADD     0             XRFN                                         CRE100
 
     C/COPY WNCPYSRC,RE3666C003
     C                   EXCEPT
 
     C                   SETOFF                                       808182
     C                   SETOFF                                       838485
     C                   MOVE      '0'           *IN86
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
     C     ACCDET        BEGSR
 
     C                   MOVEL     BRCA1         ORBR              3
     C                   MOVEL     CCY1          TRCCY             3
     C                   MOVEL     *BLANK        FACO             10
     C                   MOVEL     ACOD1         FACO
     C                   MOVEL     *BLANK        OTRF
     C                   CAT       CNUM1A:0      OTRF
     C                   CAT       ACSQ1A:0      OTRF
     C                   MOVEL     *BLANK        TRST              2
     C     CRE008        IFEQ      'Y'
     C     CMACKY        CHAIN     REGAHLJ2                           99
     C  N99              MOVEL     'G'           TRST
     C     CMACKY        CHAIN     REZSHLJ2                           99
     C  N99              MOVE      'Z'           TRST
     C                   ENDIF
 
     C     CMACKY        KLIST
     C                   KFLD                    CNUM1
     C                   KFLD                    CCY1
     C                   KFLD                    ACOD1
     C                   KFLD                    ACSQ1
     C                   KFLD                    BRCA1
 
     C                   ENDSR
 
      ** Subr. to chain Account Master file
 
     C     ACTCHN        BEGSR
 
     C                   SETOFF                                       01
     C     ACCKEY        CHAIN     ACCNT                              99
     C     *IN99         IFEQ      '1'
     C                   SETON                                        U7LR
     C                   END
     C   U7              MOVE      *BLANKS       LFILE
     C   U7              MOVEL     'ACCNT'       LFILE
     C   U7              MOVE      BLK200        LKEY
     C   U7              MOVEL     ACKEY1        LKEY
     C   U7              Z-ADD     003           LDBNO
 
     C/COPY WNCPYSRC,RE3666C013
     C                   ENDSR
 
      ** Subr. to accumulate hash totals
 
     C     HASH          BEGSR
 
     C                   Z-ADD     INT(S)        ZZTOTI
     C                   Z-ADD     DEC(S)        ZZTOTD
 
     C                   EXSR      GLZADD
 
     C                   Z-ADD     ZZTOTI        INT(S)           15 0
     C                   Z-ADD     ZZTOTD        DEC(S)            3 0
 
     C                   ENDSR
 
      ** Subroutine to add an amount (ZZAMT) to the total (ZZTOTI,ZZTOTD)
      ** ind '99' is set by an overflow error
 
     CSR   GLZADD        BEGSR
 
     CSR                 Z-ADD     ZZAMT         ZZAMT            15 3    91
     CSR 91              GOTO      ZZAEND
 
      ** Split ZZAMT into integer and decimal fields
 
     CSR                 Z-ADD     ZZAMT         ZZAMTI           15 0
     CSR                 MOVE      ZZAMT         ZZAMTD            3 0
 
      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now
 
     CSR                 EXSR      GLZSUM
     CSR   ZZAEND        ENDSR
 
      ** Subroutine to carry out the addition for subroutines -
      ** GLZADD, GLZSUB, GLZCMP.
      ** parameters passed -
      ** I/P ZZAMTI ZZAMTD
      ** O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
 
     CSR   GLZSUM        BEGSR
 
     CSR                 Z-ADD     ZZTOTI        ZZTOTI           15 0
     CSR                 Z-ADD     ZZTOTD        ZZTOTD            3 0
     CSR                 SETOFF                                       919293
     CSR                 SETOFF                                       949599
 
      ** Determine sign of ZZAMTI & D, 92 if neg
 
     CSR   ZZAMTI        COMP      0                                    9293
     CSR 93ZZAMTD        COMP      0                                    9293
     CSR 93              GOTO      ZZSEND
 
      ** Determine sign of ZZTOTI & D, 91 if neg
 
     CSR   ZZTOTI        COMP      0                                    9193
     CSR 93ZZTOTD        COMP      0                                    9193
 
      ** If ZZTOTAL is zero, return ZZAMOUNT
 
     CSR 93              Z-ADD     ZZAMTI        ZZTOTI
     CSR 93              Z-ADD     ZZAMTD        ZZTOTD
     CSR 93              GOTO      ZZSEND
 
      ** If signs differ, bypass overflow checks
 
     CSR 91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
 
     CSR   ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     CSR   ZZWK2         COMP      999                                93
     CSRN93ZZWK2         COMP      -999                                 93
 
     CSR 93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0
     CSR 93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     CSR 93ZZTOTI        ADD       ZZWK3         ZZWK3
     CSRN93ZZTOTI        ADD       ZZAMTI        ZZWK3
 
      ** If the modulus of ZZWK3 is LT MOD. ZZTOTI then O/F has occured
 
     CSRN92ZZWK3         COMP      ZZTOTI                               99
     CSR 92ZZWK3         COMP      ZZTOTI                             99
     CSRN99              Z-ADD     ZZWK2         ZZTOTD
     CSRN99              Z-ADD     ZZWK3         ZZTOTI
 
      ** If O/F zeroize ZZAMT , Ind '99' set and ZZTOT fields left intact
 
     CSR 99              Z-ADD     0             ZZAMT            15 3
     CSR                 GOTO      ZZSEND
 
      ** The 'signs' are different
 
     CSR   ZZOFPS        TAG
 
      ** If ZZAMT was negative, make it pos. to COMP with ZZTOT
 
     CSR 92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     CSR 92              Z-SUB     ZZAMTD        ZZAMTD            3 0
 
      ** if ZZTOT was negative, make it pos. to COMP with ZZAMT
 
     CSR 91              Z-SUB     ZZTOTI        ZZTOTI
     CSR 91              Z-SUB     ZZTOTD        ZZTOTD
 
      ** Both ZZAMT and ZZTOT are now positive
 
     CSR   ZZTOTI        COMP      ZZAMTI                             93  95
     CSR 95ZZTOTD        COMP      ZZAMTD                             93  95
 
      ** If ZZTOT eq. ZZAMT return zero
 
     CSR 95              Z-ADD     0             ZZTOTI
     CSR 95              Z-ADD     0             ZZTOTD
     CSR 95              GOTO      ZZSEND
 
      ** If ZZTOT GT ZZAMT
 
     CSR 93ZZAMTD        COMP      ZZTOTD                             94
     CSR 93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     CSR 93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     CSR 93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     CSR 93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     CSR 93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
 
      ** If ZZAMT GT ZZTOT
 
     CSRN93ZZTOTD        COMP      ZZAMTD                             94
     CSRN93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     CSRN93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     CSRN93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     CSRN93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     CSRN93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     CSRN93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
 
      ** Reverse sign of ZZTOT if larger I/P fields were negative
 
     CSR                 SETOFF                                       94
     CSR 93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     CSR 94              Z-SUB     ZZTOTI        ZZTOTI
     CSR 94              Z-SUB     ZZTOTD        ZZTOTD
 
      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed
 
     CSR 92              Z-SUB     ZZAMTI        ZZAMTI
     CSR 92              Z-SUB     ZZAMTD        ZZAMTD
     CSR   ZZSEND        TAG
 
      ** If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD
 
     CSR                 SETOFF                                       96
     CSR   ZZTOTD        COMP      0                                      91
     CSR 91ZZTOTI        COMP      0                                    96
     CSR 96              MOVE      '.000-'       ZZNEGD            5
     CSR                 ENDSR
 
      ** DBSR SR. to detect a database error from INTCAL
 
     C     DBSR          BEGSR
 
     C                   MOVE      '1'           *INLR
     C                   MOVE      '1'           *INU7
     C                   GOTO      END
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      * *PSSR  --- SUBROUTINE TO HANDLE ABNORMAL ERROR CONDITIONS     *
      *                                                               *
      * CALLED FROM: AFTER ABNORNAL OPERATION OCCURS                  *
      *                                                               *
      * CALLS: NOTHING                                                *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C     @RUN          IFEQ      *BLANKS
     C                   MOVE      'Y'           @RUN              1
     C                   DUMP
     C                   OUT       LDA
     C                   END
 
     C                   ENDSR
      *****************************************************************
      *                                                               *
      *  INTCAL subroutine for interest calculation between two dates *
      *                                                               *
      *      Called by       External program                         *
      *      Calls           CRINIT,DATEIN,DRINIT,ZIC00,ZIC01,ZIC02   *
      *****************************************************************
     C     INTCAL        BEGSR
 
      ** Loading of currency to chain to REHRDJ/REHRCJ files
 
     C                   MOVE      CCY           REHCCY
     C                   Z-ADD     *ZEROS        INRT
     C                   Z-ADD     *ZEROS        INTP
     C                   Z-ADD     *ZEROS        INST
     C                   Z-ADD     *ZEROS        ZINTR
     C                   Z-ADD     *ZEROS        ZLDTM
 
      ** Debit processing
 
     C     RHISB         IFGT      *ZEROS
     C     MNBL          ORGT      *ZEROS
     C                   EXSR      DRINIT
     C                   END
 
     C                   Z-ADD     INRT          ZIRATE
     C                   Z-ADD     INTP          ZICT
     C                   Z-ADD     DRIC          ZICALC
     C                   Z-ADD     RHISD         ZIBEG
     C                   Z-ADD     RUND          ZIEND
     C/COPY WNCPYSRC,RE3666C020
 
     C     INTP          IFLT      3
     C     RHISB         IFGT      0
     C                   Z-ADD     RHISB         ZIAMT
     C     ZICT          CASEQ     0             ZIC00
     C     ZICT          CASEQ     1             ZIC01
     C     ZICT          CASEQ     2             ZIC02
     C                   END
     C                   Z-ADD     ZINTR         DINT
     C                   END
 
     C                   ELSE
 
      ** Searching end-of-month date
 
     C                   EXSR      DATEIN
 
     C     RUND          IFLE      ZLDTM
     C     MNBL          IFGT      0
     C                   Z-ADD     MNBL          ZIAMT
     C     INTP          IFEQ      3
     C                   Z-ADD     1             ZICT
     C                   ELSE
     C                   Z-ADD     2             ZICT
     C                   END
     C     ZICT          CASEQ     1             ZIC01
     C     ZICT          CASEQ     2             ZIC02
     C                   END
     C                   Z-ADD     ZINTR         DINT
     C                   END
 
     C                   ELSE
 
      ** if change of month occurs with methods 3 & 4 then two processings
      ** First Processing:
 
     C     MNBL          IFGT      0
     C                   Z-ADD     MNBL          ZIAMT
     C                   Z-ADD     ZLDTM         ZIEND
     C     INTP          IFEQ      3
     C                   Z-ADD     1             ZICT
     C                   ELSE
     C                   Z-ADD     2             ZICT
     C                   END
     C     ZICT          CASEQ     1             ZIC01
     C     ZICT          CASEQ     2             ZIC02
     C                   END
     C                   Z-ADD     ZINTR         DINT
     C                   END
 
      ** Second Processing:
 
     C     RHISB         IFGT      0
     C                   Z-ADD     RHISB         ZIAMT
     C                   Z-ADD     ZLDTM         ZIBEG
     C                   Z-ADD     RUND          ZIEND
     C     INTP          IFEQ      3
     C                   Z-ADD     1             ZICT
     C                   ELSE
     C                   Z-ADD     2             ZICT
     C                   END
     C     ZICT          CASEQ     1             ZIC01
     C     ZICT          CASEQ     2             ZIC02
     C                   END
     C                   ADD       ZINTR         DINT
     C                   END
 
     C                   END
 
     C                   END
     C/COPY WNCPYSRC,RE3666C021
 
      ** Credit Processing
 
     C                   Z-ADD     *ZEROS        INRT
     C                   Z-ADD     *ZEROS        INTP
     C                   Z-ADD     *ZEROS        INST
     C                   Z-ADD     *ZEROS        ZINTR
     C                   Z-ADD     *ZEROS        ZLDTM
 
     C     RHISB         IFLT      *ZEROS
     C     MNBL          ORLT      *ZEROS
     C                   EXSR      CRINIT
     C                   END
 
     C                   Z-ADD     INRT          ZIRATE
     C                   Z-ADD     INTP          ZICT
     C                   Z-ADD     CRIC          ZICALC
     C                   Z-ADD     RHISD         ZIBEG
     C                   Z-ADD     RUND          ZIEND
 
     C     INTP          IFLT      3
     C     RHISB         IFLT      0
     C                   Z-ADD     RHISB         ZIAMT
     C     ZICT          CASEQ     0             ZIC00
     C     ZICT          CASEQ     1             ZIC01
     C     ZICT          CASEQ     2             ZIC02
     C                   END
     C                   Z-ADD     ZINTR         CINT
     C                   END
 
     C                   ELSE
 
      ** Searching end-of-month date
 
     C                   EXSR      DATEIN
 
     C     RUND          IFLE      ZLDTM
     C     MNBL          IFGT      0
     C                   Z-ADD     MNBL          ZIAMT
     C     INTP          IFEQ      3
     C                   Z-ADD     1             ZICT
     C                   ELSE
     C                   Z-ADD     2             ZICT
     C                   END
     C     ZICT          CASEQ     1             ZIC01
     C     ZICT          CASEQ     2             ZIC02
     C                   END
     C                   Z-ADD     ZINTR         CINT
     C                   END
 
     C                   ELSE
 
      ** If change of month occurs with methods 3 & 4 then two processings
      ** First Processing:
 
     C     MNBL          IFGT      0
     C                   Z-ADD     MNBL          ZIAMT
     C                   Z-ADD     ZLDTM         ZIEND
     C     INTP          IFEQ      3
     C                   Z-ADD     1             ZICT
     C                   ELSE
     C                   Z-ADD     2             ZICT
     C                   END
     C     ZICT          CASEQ     1             ZIC01
     C     ZICT          CASEQ     2             ZIC02
     C                   END
     C                   Z-ADD     ZINTR         CINT
     C                   END
 
      ** Second Processing:
 
     C     RHISB         IFGT      0
     C                   Z-ADD     RHISB         ZIAMT
     C                   Z-ADD     ZLDTM         ZIBEG
     C                   Z-ADD     RUND          ZIEND
     C     INTP          IFEQ      3
     C                   Z-ADD     1             ZICT
     C                   ELSE
     C                   Z-ADD     2             ZICT
     C                   END
     C     ZICT          CASEQ     1             ZIC01
     C     ZICT          CASEQ     2             ZIC02
     C                   END
     C                   ADD       ZINTR         CINT
     C                   END
 
     C                   END
 
     C                   END
 
     C                   ENDSR
     C/COPY ZSRSRC,ZICDREZ2LE
      *****************************************************************
     C/EJECT
      *****************************************************************
 
      ** ZIC00 subroutine to calculate interest (type=00)
      **     Called by       INTCAL
      **     Calls           ZICD
 
     C     ZIC00         BEGSR
     C/COPY WNCPYSRC,RE3666C001
 
      ** Reverse sign of amount if it's negative
 
     C     ZIAMT         IFLT      0
     C                   Z-SUB     ZIAMT         ZIAMT
     C                   END
 
      ** Find number of days to calculate interest according to calc. basis
      ** For calc basis 6, use the factored number of days
 
     C     ZIAMT         MULT      ZIRATE        ZIWRK1
     C     ZICALC        IFEQ      6
     C     ZIWRK1        MULT      INT6DY        ZIWRK2
 
     C                   ELSE
     C     ZIWRK1        MULT      ZDAYN2        ZIWRK2
     C                   ENDIF
 
     C     ZICALC        IFEQ      7
     C     ZICALC        OREQ      5
     C     ZICALC        OREQ      3
     C     ZICALC        OREQ      2
     C     ZIWRK2        DIV(H)    36000         ZINTR
     C                   END
 
     C     ZICALC        IFEQ      4
     C     ZICALC        OREQ      1
     C     ZIWRK2        DIV(H)    36500         ZINTR
     C                   END
 
     C     ZICALC        IFEQ      6
     C     ZIWRK2        DIV(H)    36600         ZINTR
     C                   END
 
     C/COPY WNCPYSRC,RE3666C002
     C                   ENDSR
      ********************************************************************
     C/EJECT
      ********************************************************************
 
      ** ZIC01 subroutine to calculate interest (type=01)
      **     Called by       INTCAL
      **     Calls           ZICD
 
     C     ZIC01         BEGSR
     C/COPY WNCPYSRC,RE3666C008
 
      ** Reverse sign of amount if it's negative
 
     C     ZIAMT         IFLT      0
     C                   Z-SUB     ZIAMT         ZIAMT
     C                   END
 
      ** Initialize work fields
 
     C                   Z-ADD     ZIAMT         ZIAMT1
     C                   Z-ADD     1             Z
     C                   Z-ADD     *ZEROS        ZIAMTR
     C                   Z-ADD     *ZEROS        ZIA
     C                   Z-ADD     *ZEROS        ZIA1
     C                   Z-ADD     *ZEROS        LOOP
     C                   Z-ADD     *ZEROS        Y
     C                   Z-ADD     *ZEROS        ZIN
 
      ** Interest is only calculated on an amount that exceeds the
      ** initial threshold balance
 
     C     ZIAMT         IFGT      ZITHR
 
      ** Find number of days to calculate interest according to calc. basis
 
     C     LOOP          DOWEQ     0
     C                   Z-ADD     ZIAMT1        ZIAMTR
 
     C     Z             IFEQ      11
     C                   Z-ADD     ZIAMTR        ZIA(Z)
     C                   Z-ADD     1             LOOP
 
     C                   ELSE
     C                   ADD       1             Y
     C                   ADD       1             Z
 
     C     ZIB(Z)        IFEQ      0
     C                   ADD       ZIAMTR        ZIA(Y)
     C                   Z-ADD     1             LOOP
 
     C                   ELSE
     C     ZIB(Z)        SUB       ZIB(Y)        ZBAL
     C     ZIAMTR        SUB       ZBAL          ZIAMT1
 
     C     ZIAMT1        IFLE      0
     C                   ADD       ZIAMTR        ZIA(Y)
     C                   Z-ADD     1             LOOP
 
     C                   ELSE
     C                   ADD       ZBAL          ZIA(Y)
 
     C                   END
 
     C                   END
 
     C                   END
 
     C                   END
 
      ** if the sub-type is from 50000 to 99999, calculate the interest
      ** on the amount exceeding the initial threshold. Otherwise, the
      ** interest is calculated on the whole balance whenever it exceeds
      ** the initial threshold.
 
     C     INST          IFGE      50000
     C                   Z-ADD     1             Z
     C     Z             DOWLT     12
     C     ZITHR         ANDGT     0
     C     ZIA(Z)        SUB       ZITHR         ZIA(Z)
     C     ZIA(Z)        IFLT      0
     C                   Z-SUB     ZIA(Z)        ZITHR
     C                   Z-ADD     0             ZIA(Z)
     C                   ELSE
     C                   Z-ADD     0             ZITHR
     C                   END
     C                   ADD       1             Z
     C                   END
     C                   END
 
      ** For calc basis 6, use the factored number of days
 
     C     ZIA           MULT      ZIR           ZIA1
     C     ZICALC        IFEQ      6
     C     ZIA1          MULT      INT6DY        ZIA1
 
     C                   ELSE
     C     ZIA1          MULT      ZDAYN2        ZIA1
     C                   ENDIF
 
     C     ZICALC        IFEQ      7
     C     ZICALC        OREQ      5
     C     ZICALC        OREQ      3
     C     ZICALC        OREQ      2
     C     ZIA1          DIV(H)    36000         ZIN
 
     C                   END
 
     C     ZICALC        IFEQ      4
     C     ZICALC        OREQ      1
     C     ZIA1          DIV(H)    36500         ZIN
 
     C                   END
 
     C     ZICALC        IFEQ      6
     C     ZIA1          DIV(H)    36600         ZIN
 
     C                   END
     C                   XFOOT     ZIN           ZINTR
 
     C                   END
     C/COPY WNCPYSRC,RE3666C009
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
 
      ** ZIC02 subroutine to calculate interest (type=02)
      **     Called by       INTCAL
      **     Calls           ZICD
 
     C     ZIC02         BEGSR
     C/COPY WNCPYSRC,RE3666C010
 
      ** Fill the end of the table with highval
 
     C                   Z-ADD     2             Z
     C     Z             DOWLE     11
     C     ZIB(Z)        IFEQ      *ZEROS
     C                   Z-ADD     *HIVAL        ZIB(Z)
     C                   END
     C                   ADD       1             Z
     C                   END
 
      ** Reverse sign of amount if it's negative
 
     C     ZIAMT         IFLT      0
     C                   Z-SUB     ZIAMT         ZIAMT
     C                   END
 
      ** Interest is only calculated on an amount that exceeds the
      ** initial threshold balance
 
     C     ZIAMT         IFGT      ZITHR
 
      ** Find number of days to calculate interest according to calc. basis
      ** Make sure the correct Rate is used when History balance has a
      ** matching threshold balance.
 
     C                   Z-ADD     1             Z
     C     ZIAMT         LOOKUP    ZIB(Z)                                 40
     C     *IN40         IFEQ      *OFF
     C                   Z-ADD     1             Z
     C     ZIAMT         LOOKUP    ZIB(Z)                               40
     C                   ENDIF
 
      ** if the sub-type is from 50000 to 99999, calculate the interest
      ** on the amount exceeding the initial threshold. Otherwise, the
      ** interest is calculated on the whole balance whenever it exceeds
      ** the initial threshold.
 
     C     INST          IFGE      50000
     C     ZIAMT         SUB       ZITHR         ZIAMT
     C                   END
 
      ** For calc basis 6, use the factored number of days
 
     C     ZIAMT         MULT      ZIR(Z)        ZIWRK1
     C     ZICALC        IFEQ      6
     C     ZIWRK1        MULT      INT6DY        ZIWRK2
 
     C                   ELSE
     C     ZIWRK1        MULT      ZDAYN2        ZIWRK2
     C                   ENDIF
 
     C     ZICALC        IFEQ      7
     C     ZICALC        OREQ      5
     C     ZICALC        OREQ      3
     C     ZICALC        OREQ      2
     C     ZIWRK2        DIV(H)    36000         ZINTR
 
     C                   END
 
     C     ZICALC        IFEQ      4
     C     ZICALC        OREQ      1
     C     ZIWRK2        DIV(H)    36500         ZINTR
 
     C                   END
 
     C     ZICALC        IFEQ      6
     C     ZIWRK2        DIV(H)    36600         ZINTR
 
     C                   END
 
     C/COPY WNCPYSRC,RE3666C022
     C/COPY WNCPYSRC,RE3666C023
     C                   END
     C/COPY WNCPYSRC,RE3666C011
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
 
      ** DRINIT subroutine for debit rates loading
      **     Called by       INTCAL
      **     Calls           DBSR
 
     C     DRINIT        BEGSR
 
     C                   Z-ADD     *ZEROS        ZIRD
     C                   Z-ADD     *ZEROS        ZIBD
     C                   Z-ADD     *ZERO         ZITHR
     C                   Z-ADD     *ZEROS        INTHD
 
      ** Chain to Debit Rate Changes file
 
     C                   Z-ADD     DRCD          KDATE
 
     C     DCKEY         CHAIN     REHRDJ                             99
 
      ** Error in REHRDJ
 
     C     *IN99         IFEQ      '1'
     C     DRIB          ANDEQ     *ZEROS
     C     DRIS          ANDEQ     *ZEROS
     C                   MOVE      '0'           *IN99
     C                   END
 
     C     *IN99         IFEQ      '1'
     C                   MOVE      *BLANKS       LFILE
     C                   Z-ADD     92            LDBNO
     C                   MOVEL     'REHRDJ'      LFILE
     C                   Z-ADD     KDATE         REHDAT
     C                   MOVE      *BLANKS       LKEY
     C                   MOVEL     REHKEY        LKEY
     C                   EXSR      DBSR
     C                   END
 
      ** Pick-up debit threshold balance
 
     C                   Z-ADD     INTHD         ZITHR
 
      ** Setup work debit fields with fields read
 
     C     RAT2          IFNE      *BLANKS
     C                   MOVEL     RAT2          WDRAT
     C                   END
 
     C     RAT3          IFNE      *BLANKS
     C                   MOVE      RAT3          WDRAT
     C                   END
 
     C     BAL2          IFNE      *BLANKS
     C                   MOVEL     BAL2          WDBAL
     C                   END
 
     C     BAL3          IFNE      *BLANKS
     C                   MOVE      BAL3          WDBAL
     C                   END
 
      ** Loading of debit interest rates and debit interest balances
 
     C                   Z-ADD     ZIRD          ZIR
     C                   Z-ADD     ZIBD          ZIB
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
 
      ** CRINIT subroutine for credit rates loading
      **     Called by       INTCAL
      **     Calls           DBSR
 
     C     CRINIT        BEGSR
 
     C                   Z-ADD     *ZEROS        ZIRC
     C                   Z-ADD     *ZEROS        ZIBC
     C                   Z-ADD     *ZERO         ZITHR
     C                   Z-ADD     *ZEROS        INTHC
 
      ** Chain to Credit Rate Changes file
 
     C                   Z-ADD     CRCD          KDATE
 
     C     DCKEY         CHAIN     REHRCJ                             99
 
      ** Error in REHRCJ
 
     C     *IN99         IFEQ      '1'
     C     CRIB          ANDEQ     *ZEROS
     C     CRIS          ANDEQ     *ZEROS
     C                   MOVE      '0'           *IN99
     C                   END
 
     C     *IN99         IFEQ      '1'
     C                   MOVE      *BLANKS       LFILE
     C                   Z-ADD     93            LDBNO
     C                   MOVEL     'REHRCJ'      LFILE
     C                   Z-ADD     KDATE         REHDAT
     C                   MOVE      *BLANKS       LKEY
     C                   MOVEL     REHKEY        LKEY
     C                   EXSR      DBSR
     C                   END
 
      ** Pick-up credit threshold balance
 
     C                   Z-ADD     INTHC         ZITHR
 
      ** setup work credit fields with fields read processing
 
     C     RAT2          IFNE      *BLANKS
     C                   MOVEL     RAT2          WCRAT
     C                   END
 
     C     RAT3          IFNE      *BLANKS
     C                   MOVE      RAT3          WCRAT
     C                   END
 
     C     BAL2          IFNE      *BLANKS
     C                   MOVEL     BAL2          WCBAL
     C                   END
 
     C     BAL3          IFNE      *BLANKS
     C                   MOVE      BAL3          WCBAL
     C                   END
 
      ** Loading of credit interest rates and credit interest balances
 
     C                   Z-ADD     ZIRC          ZIR
     C                   Z-ADD     ZIBC          ZIB
 
     C                   ENDSR
 
      *****************************************************************
     C/EJECT
      *****************************************************************
 
      ** DATEIN subroutine for date init processing
      **     Called by       INTCAL
      **     Calls           DBSR
 
     C     DATEIN        BEGSR
 
      ** Work Field init
 
     C                   Z-ADD     *ZEROS        ZLDTM
 
      ** Calculating date from day number (REACR histore date)
 
     C                   Z-ADD     RHISD         ZDAYNO
     C                   EXSR      ZDATE2
 
      ** Verify if error
 
     C     *IN99         IFNE      '0'
     C                   MOVE      *BLANKS       LFILE
     C                   Z-ADD     94            LDBNO
     C                   MOVEL     'ZDATE2'      LFILE
     C                   MOVE      ZERROR        ERRDAT
     C                   MOVE      *BLANKS       LKEY
     C                   MOVEL     ERRDAT        LKEY
     C                   MOVEA     '1'           *IN(89)
     C                   EXSR      DBSR
     C                   END
 
      ** Calculating first day of this month to calculate the last one
 
     C                   Z-ADD     ZDATE         RESULT
     C                   Z-ADD     1             ZDAY
     C                   Z-ADD     RESULT        ZDATE
     C                   EXSR      ZDATE1
 
      ** Verify if error
 
     C     *IN99         IFNE      '0'
     C                   MOVE      *BLANKS       LFILE
     C                   Z-ADD     95            LDBNO
     C                   MOVEL     'ZDATE1'      LFILE
     C                   MOVE      ZERROR        ERRDAT
     C                   MOVE      *BLANKS       LKEY
     C                   MOVEL     ERRDAT        LKEY
     C                   MOVEA     '1'           *IN(89)
     C                   EXSR      DBSR
     C                   END
 
     C     ZMTH          IFEQ      12
     C                   Z-ADD     1             ZMTH
     C                   ADD       1             ZYEAR
     C                   ELSE
     C                   ADD       1             ZMTH
     C                   END
 
     C                   Z-ADD     RESULT        ZDATE
     C                   EXSR      ZDATE1
 
      ** Verify if error
 
     C     *IN99         IFNE      '0'
     C                   MOVE      *BLANKS       LFILE
     C                   Z-ADD     96            LDBNO
     C                   MOVEL     'ZDATE1'      LFILE
     C                   MOVE      ZERROR        ERRDAT
     C                   MOVE      *BLANKS       LKEY
     C                   MOVEL     ERRDAT        LKEY
     C                   MOVEA     '1'           *IN(89)
     C                   EXSR      DBSR
     C                   END
 
     C     ZDAYNO        SUB       1             ZLDTM
 
     C                   ENDSR
 
      ********************************************************************
     C/EJECT
      ********************************************************************
      *   Subroutine SRPNAR determines the required narratives.          *
      ********************************************************************
     C     SRPNAR        BEGSR
 
      ** Define the data structure parameter:
 
     C     *LIKE         DEFINE    CGPNAR        ##PNAR
 
      ** Define the narrative fields:
 
     C                   MOVE      *BLANKS       O#PNAR           30
 
      ** If the facility is switched off or unavailable,
      ** or UDC is not installed, exit this subroutine:
 
     C     REPNAR        IFNE      'Y'
 
      **  Determine the current narrative and message id to use (*IN31
      **  signifies Retail Account Number.)
 
     C                   CLEAR                   DSPNAR
     C                   MOVE      I#TXT         D#TXT
     C     *IN31         IFEQ      *ON
     C                   MOVE      AACNO         D#ACNO
     C                   ELSE
     C                   MOVE      CNUM          D#CNUM
     C                   MOVE      CCY           D#CCY
     C                   MOVE      ACOD          D#ACOD
     C                   MOVE      ACSQ          D#ACSQ
     C                   MOVE      BRCA          D#BRCA
     C                   ENDIF
     C                   MOVE      DSPNAR        O#PNAR
 
     C                   GOTO      EXPNAR
     C                   ENDIF
 
      ** Determine the customer's name:
      ** OUTPUT CALLS SRPNAM and OUTPUT can be called many times for same
      ** customer. If this is the same customer as the last CHAIN then use
      ** the last information gathered rather than call AOCUSTR* again
 
     C                   MOVEL(P)  CNUM          ##KEY
 
     C     *LIKE         DEFINE    CNUM          ##LCUS
     C     *LIKE         DEFINE    BBCRNM        ##LCRN
     C     CNUM          IFEQ      ##LCUS
     C                   MOVEL     ##LCRN        BBCRNM
     C                   ELSE
     C                   CALL      'AOCUSTR0'
     C                   PARM                    ##RTN             7
     C                   PARM      '*KEY   '     ##OPT             7
     C                   PARM                    ##KEY            10
     C                   PARM                    ##STS             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     ##RTN         IFNE      *BLANKS
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   MOVEL     '101'         DBASE
     C                   MOVEL     ##KEY         DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVEL     CNUM          ##LCUS
     C                   MOVEL     BBCRNM        ##LCRN
     C                   ENDIF
     C                   ENDIF
      *****************************************************************
     C/EJECT
      *****************************************************************
 
      **  Determine the current narrative and message id to use (*IN31
      **  signifies Retail Account Number.)
 
     C                   CLEAR                   DSPNAR
     C                   MOVE      I#TXT         D#TXT
     C     *IN31         IFEQ      *ON
     C                   MOVE      AACNO         D#ACNO
     C                   MOVE      'GB00752'     ##MGID
     C                   ELSE
     C                   MOVE      CNUM          D#CNUM
     C                   MOVE      CCY           D#CCY
     C                   MOVE      ACOD          D#ACOD
     C                   MOVE      ACSQ          D#ACSQ
     C                   MOVE      BRCA          D#BRCA
     C                   MOVE      'GB00380'     ##MGID
     C                   ENDIF
     C                   MOVE      DSPNAR        ##NARR
 
      ** Determine the value for the first narrative using AOPNARR0:
 
     C                   CLEAR                   CGPNAR
     C                   CLEAR                   ##PRM1
 
     C                   MOVE      'RE'          MNMODI
     C                   MOVE      CNUM          MNCUST
     C                   MOVE      CCY           MNCYCD
     C                   MOVE      ACOD          MNACCD
     C                   MOVE      ACSQ          MNACSQ
     C                   MOVE      BRCA          MNBRCA
     C                   MOVE      AACNO         MNRACN
     C                   MOVE      BOKC          MNBOKC
     C                   MOVE      BBCRNM        MNCRNM
     C                   MOVEL(P)  ##NARR        MNNARR
     C                   MOVE      CNUM          MNASOC
     C/COPY WNCPYSRC,REH00406
 
     C                   CALL      'AOPNARR0'
     C                   PARM                    ##RTN
     C                   PARM                    ##MGID            7
     C                   PARM                    ##PRM1
     C     CGPNAR        PARM      CGPNAR        ##PNAR
     C                   PARM                    ##NARR           50
     C/COPY WNCPYSRC,REH00407
 
     C     ##RTN         IFNE      *BLANKS
     C                   MOVEL     'CGPNARPD'    DBFILE
     C                   MOVEL     '102'         DBASE
     C                   MOVEL     MNCUST        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVEL     ##NARR        O#PNAR
 
     C     EXPNAR        TAG
 
     C                   ENDSR
      *****************************************************************
     C/COPY WNCPYSRC,RE3666C007
     C/COPY ZSRSRC,ZDATE2Z2LE
     C/COPY ZSRSRC,ZDATE1Z2LE
      *****************************************************************
 
      ** Generated Entries
 
      ** Detail Record
 
     OGEIERPD   E    80
     O                                            1 'P'
 
     O/COPY WNCPYSRC,RE3666OOP1
 
     O                       BICN                 7
 
     O/COPY WNCPYSRC,RE3666OOP2
 
     O               38      CNUM                 7                                           CRE100
     O                       CCY                 10
     O                       QQACOD              14
     O/COPY WNCPYSRC,RE3666O003
     O                                           16 '01'
     O/COPY WNCPYSRC,RE3666O004
     O                                           32 '0000000000'
     O                       RNDT                35P
     O                       APDA                38P
     O                                           43 '91080'
     O              N65                          49 'ACCR. '
     O              N65N31   CNUM                55
     O              N65N31   CCY                 58
     O              N65N31   ACOD                68
     O              N65N31   ACSQ                70
     O              N65N31   BRCA                73
     O              N65 31   AACNO               63
     O               65      O#PNAR              73
     O                  83   PSTAD               80P
     O                  84   PSTAC               80P
     O                       DRCRGE              81
     O                       CNUM                87
     O                                           95 '00000000'
     O                                          102 'GE-IER'
     O                       BRCA               105
     O                                          106 '0'
     O                       ZERO03             108P
     O                       ZERO5              114P
     O                       ATYP               124
     O                       PRIN               128
     O                                          129 'I'
     O                                          130 '1'
     O              N70      PRFC               134
     O                       PTIM               140
     O                       VOIN               141
     O                       ACCS               146
     O                       LTAI               147
     O                       FACO               194
     O                       OTST               240
     O                       OTTP               250
     O                       SDCB               258P
     O                       SDLB               266P
     O                       BOKC               268
     O                       NITMS              271P
     O                       REBI               272
     O                       CHGA               279P
     O                       TRCCY              302
     O                       ORBR               309
     O                       XRFN               329
     O                       TRST               331
     O                       ACKEY              351
     O                       FEEFLG             352
     O                       FEEVAL             359P
     O                       FEEPCT             364
     O                       RORACT             384
     O                       RORCTY             386
     O                       RORBNK             406
     O                       RORCDE             417
     O                       PORACT             437
     O                       PORCTY             439
     O                       PORBNK             459
     O                       PORCDE             470
     O                       DSTACT             505
     O                       DSTCTY             507
     O                       DSTBNK             527
     O                       SETDAT             530P
     O                       TICKER             540
     O                       EXCHNG             560
     O                       NOMINL             573
     O                       FPTRID             589
     O                       ACODGE             599
     O                       OTRF               620
     O                       ORAMT              316P
 
      ** Blank Profit Centre if Profit Centre not used
 
     O               70                         134 '    '
 
      ** Monthly Accruals
 
      ** Detail Record
     O/COPY WNCPYSRC,RE3666O001
 
     OACRLAR    E    81
     O         OR    82
     O                                            1 'D'
     O                       BRCA                 4
     O                       CNUM                10
     O                       CCY                 13
     O                       ACSQ                19
     O                       AACNO               29
     O                       ZERO13              36P
     O                       ZERO13              43P
     O                       ZERO13              50P
     O                  81   DAID                36P
     O                  81   DAIL                43P
     O                  81   DAIP                50P
     O                       ZERO13              57P
     O                       ZERO13              64P
     O                       ZERO13              71P
     O                  82   CAID                57P
     O                  82   CAIL                64P
     O                  82   CAIP                71P
     O                       ACOD                90
     O                  81   DIAD1              100
     O                  81   DIAC1              110
     O                  82   CIAD1              100
     O                  82   CIAC1              110
     O/COPY WNCPYSRC,RE3666O002
 
      ** Trailer
 
     OREACRLZZ  T
     O                       NOREZ                3P
     OREGEIEZZ  T
     O                       NORE1
     O                       HRWN                13P
     O                       HRDC                15P
 
      ** REACR Detail
 
     OREACRDF   E    86
 
     O                       DAIC
     O                       CAIC
     O                       RHISD
     O/COPY WNCPYSRC,REH00154
 
      ** Account Master
 
     OACCNTABF  E    85
 
      ** Debit fields
 
     O                       LPAR
     O                       DIIE
 
      ** Credit fields
 
     O                       LPAP
     O                       CIIE
 
      ** Blank profit centre if Profit Centre not used
 
     O                       PRFC
 
      ** File Controls
 
     ORE3666AU  T    LR                     2 03
     O                                           22 'REFERENCE RE3666AU'
     O                       TITL                89
     O                                          104 'DATE'
     O                       RUNA               113
     O                                          122 'PAGE'
     O                       PAGE          Z    127
     O          T    LR                     1 08
     O                                           63 'POSTINGS TO INCOME'
     O                                           73 ' & EXPENSE'
     O                                           89 'RUN CONTROLS'
     O          T    LR                     3
     O                                           63 '------------------'
     O                                           73 '----------'
     O          T    LR                     3 24
     O                                           22 'FILE CONTROLS -'
     O          T    LRNU7                  1 35
     O                                           42 'GENERATED ENTRIES FILE'
     O          T    LRNU7                  2
     O                                           73 'NUMBER OF RECORDS WRITTE'
     O                                           74 'N'
     O                       RWGEI         3     89
     O          T    LRNU7                  1
     O                                           42 'MONTHLY ACCRUALS FILE'
     O          T    LRNU7                  3
     O                                           73 'NUMBER OF RECORDS WRITTE'
     O                                           74 'N'
     O                       RWACRL        3     89
 
      ** Database Error
 
     O          T    LR U7                    43
     O                                           58 'DATABASE ERROR '
     O                       DBASE               61
     O                                           75 'IN PROGRAM '
     O                       DBPGM               85
     O          T    LR U7               2
     O                                           48 'FILE '
     O                       DBFILE              56
     O                                           62 ', KEY '
     O                       DBKEY               91
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** CPY@   **      OBJECT COPYRIGHT
(c) Misys International Banking Systems Ltd. 2001
**   SVAL  -  SYSTEM VALUES ARRAY                                                             CRE100
RET_INTAC_CUST_LVL                                                                            CRE100
