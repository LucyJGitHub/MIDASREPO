     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')                     CAP084
      *****************************************************************
/*XBIA*  OVRDBF MMEDUMLL MMEPOULL                                     *
/*XBIB*  OVRDBF MMFDUMLL MMFNRULL                                     *
/*STD *  RPGBASEMOD                                                   *         CAP084
/*EXI *  TEXT('Midas AB Upd MM Pos & Profits & Near Dates')
/*S******RPGBASE*******************************************************         CAP084
     F*****************************************************************
     F*  Midas  -  Internal Contracts & Arbitrage Dealing
     F*                                                               *
     F*    AB0280 - Update MM Positions & Profits & Near Dates Summary*
     F*                                                               *
     F*   Function:   This program rebuilds the Money Market near     *
     F*   (I/C)       dates file (MMFNRDPP) and the ccy positions     *
     F*   (I/C INIT)  file (MMEPOSPP) during I/C initiation and I/C.  *
     F*                                                               *
     F*     Called by: AB0330  - AB Back office Internal Contracts    *
     F*                          maintenance.              (I/C)      *
     F*                AB8010  - AB Daily deals update and start of   *
     F*                          day reorganisation.       (I/C INIT) *
     F*                                                               *
     F*     Calls    : ZA0270  - Convert date to Midas day number.    *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                              *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. 240334             Date 17Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12923           Date 18Dec06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAP084             Date 06Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 08Sep98               *
     F*                 CAC001             Date 01FEB96               *
     F*                 099756             Date 23MAY96               *
     F*                 S01319             Date 03DEC91               *
     F*                 DT0198             Date 29MAY91               *
     F*                  E20774             DATE 15MAR90             *
     F*                  S01117             Date 31JAN90             *
     F*                  S01194             Date 31JAN90             *
     F*                  S01195             Date 31JAN90             *
     F*                  E17063             DATE 05/05/89            *
     F*                  AB0324             DATE 13/06/88            *
     F*                  AB0322             DATE 13/06/88            *
     F*                  AB0147             DATE 18/04/88            *
     F*                  AB0153             DATE 12/04/88            *
     F*                  AB0150             DATE 12/04/88            *
     F*                  AB0109             DATE 04/03/88            *
     F*                                                              *
     F*****************************************************************
     F*                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  240334 - Recompile over changes in ZACCHLE.                  *
      *  BUG12923 - SCC0411 looping issue                             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAP084 - Convert to ILE.                                     *
     F*  CAP004 - API's Phase 3.                                      *
     F*  CAC001 - Profit Centre Accounting Development:               *
     F*           Recompiled only.                                    *
     F*  099756 - Fix to stop array index error. Taken from MM0073.   *
     F*  S01319 - Changes for Project Harry.  ABSTDDLL redundant.     *
     F*  DT0198 - ACCESS TO FIND MM SPOT DATE IN SUBROUTINE #BB NEEDS *
     F*           TO BE REPLACED TO PREVENT ARRAY INDEX ERROR         *
     F*                                                               *
     F*  E20774 - REPLACE QCAEXEC WITH QCMDEXC                        *
     F*                                                               *
     F*  S01195 - NEW STANDING DATA - HOLIDAY PROCESSING              *
     F*                                                               *
     F*  S01194 - NEW STANDING DATA                                   *
     F*                                                               *
     F*  S01117 - MULTI-BRANCHING.                                    *
     F*                                                               *
     F*  E17063 - Recompiled using IGNDECERR(*YES).                   *
     F*                                                               *
     F*  AB0324 - ACCRUED INTEREST SHOULD BE ON PRINCIPAL AMOUNT      *   AB0109
     F*           NOT INTEREST AMOUNT.                                *   AB0109
     F*                                                               *   AB0109
     F*  AB0322 - BALANCES ON FILE HAVE INCORRECT SIGNS               *   AB0109
     F*                                                               *   AB0109
     F*  AB0147 - #BA SPLIT UP SO THAT MMEPOULL & MMFNRULL CAN BE     *   AB0109
     F*           INITIALISED IF THE FIRST CHAIN IS NOT SUCCESSFUL    *   AB0109
     F*           THE SECOND IS NOT.                                  *   AB0109
     F*                                                               *
     F*  AB0153 - @TERM SHOULD BE CHECKED BEFORE @FCYC                *   AB0109
     F*                                                               *
     F*  AB0150 - COMMENT OUT KIGNORES                                *   AB0109
     F*                                                               *
     F*  AB0109 - CCYS MUST BE PROCESSED IN ALPHABETIC ORDER SO AS    *   AB0109
     F*           TO AVOID A DEADLY EMBRACE BETWEEN TWO TERMINALS.    *   AB0109
     F*****************************************************************
     F*                                                               *
     F*  CREATION PARAMETERS                                          *
     F*                                                               *
*****F** SNPDUMP(*NONE) CODELIST(*NONE) IGNDECERR(*NO)              : *   E17063
     F*                                                               *
     F*****************************************************************
     F****************************************************************    MMCOFF
     F*                                                              *    MMCOFF
     F*   Special Note: To Compile this program                      *    MMCOFF
     F*                                                              *    MMCOFF
     F*                 OVRDBF    MMEDUMLL    MMEPOULL               *    MMCOFF
     F*                 OVRDBF    MMFDUMLL    MMFNRULL               *    MMCOFF
     F*                                                              *
     F****************************************************************    MMCOFF
      /EJECT
     F****************************************************************
     F*
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*
     F*       76         READ/CHAIN FAIL
     F*
     F*       U6         PROGRAM ERROR
     F*       U7         DATA BASE OR EXCEPTION ERROR
     F*       U8         DATA BASE OR EXCEPTION ERROR
     F*
     F*****************************************************************
      /EJECT
     F*FDICDRLLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
     F******      TABTB11F                          KIGNORE               AB0150
     F******      TABTB20F                          KIGNORE               AB0150
     F*FDCCYTLLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
     FMMEPOULL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     COMMIT                               MMCOFF
     FMMEDUMLL  UF A E           K DISK    INFSR(INFSR)                         MMCOFF
     F                                     USROPN
     F                                     RENAME(MMEPOSP0:MMEDUMP0)            MMCOFF
     FMMFNRULL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     COMMIT
     FMMFDUMLL  UF A E           K DISK    INFSR(INFSR)                         MMCOFF
     F                                     USROPN
     F                                     RENAME(MMFNRDP0:MMFDUMP0)            MMCOFF
     F*FDTABJLLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
      /EJECT
     D*
     D**  ARRAY TO HOLD COPYRIGHT STATEMENT
     D*
     D** Array of period start day numbers.
     D @S              S              5  0 DIM(10)
     D*
     D** Array of period end day numbers.
     D*
     D** Array of number of days in period.
     D*
     D** Array of net balances.
     D*
     D** Array of net interest accrued.
     D*
     D**  ARRAY FOR SR. ZA0680 - CUMULATIVE DAYS IN YEAR FOR 4 YEAR PERIOD
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D*
     D**  ARRAY FOR SR. ZA0680 - CUMULATIVE DAYS IN YEAR PER MONTH
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
     D*
     D**  USED BY SR. ZA0830 - CURRENCY RECORDS
     D***Command*used*on*call*to*QCAEXEC                                  E20774
     D** Command used on call to QCMDEXC                                  E20774
     D @CMD            S             30    DIM(2) CTDATA PERRCD(1)                               MMC
      *
      **OPY ZSRSRC,ZHOLE                                                  S01195CAP084
      /COPY ZSRSRC,ZHOLELE                                                      CAP084
      /EJECT
     D @CPYRT          DS
     D*
     D**  DATA STRUCTURE FOR COMPILATION - COPYRIGHT INSERTION
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D*
     D** Data structure of standard deal.
     D*@STDD*****E*DSABSTDDLL                                             S01319
     D @STDD         E DS                  EXTNAME(ABSTDDPP)                    S01319
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01194
      ** BANK DETAILS ACCESSED VIA ACCESS PROGRAM                         S01194
     D  RUND                  34     36P 0                                      S01194
      *                                                                   S01194
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    S01194
      ** CURRENCY DETAILS ACCESSED VIA ACCESS PROGRAM                     S01194
      *                                                                   S01194
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
     D*                                                                   S01194
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                S01194
     D*
     D** Define arrays across MMFNRULL & MMEPOULL fields.
     D @AIPE           DS
     D** Net balances.
     D  @A                     1    150  0
     D                                     DIM(10)
     D  HRNBTD                 1     15  0
     D  HRNBD1                16     30  0
     D  HRNBD2                31     45  0
     D  HRNBD3                46     60  0
     D  HRNBD4                61     75  0
     D  HRNBW1                76     90  0
     D  HRNBM1                91    105  0
     D  HRNBM2               106    120  0
     D  HRNBM3               121    135  0
     D  H2NBSP               136    150  0
     D** Net interest accrued.
     D  @I                   151    300  0
     D                                     DIM(10)
     D  HRIATD               151    165  0
     D  HRIAD1               166    180  0
     D  HRIAD2               181    195  0
     D  HRIAD3               196    210  0
     D  HRIAD4               211    225  0
     D  HRIAW1               226    240  0
     D  HRIAM1               241    255  0
     D  HRIAM2               256    270  0
     D  HRIAM3               271    285  0
     D  H2NIAS               286    300  0
     D** Number of days in period.
     D  @P                   301    330  0
     D                                     DIM(10)
     D  HRDPTD               301    303  0
     D  HRDPD1               304    306  0
     D  HRDPD2               307    309  0
     D  HRDPD3               310    312  0
     D  HRDPD4               313    315  0
     D  HRDPW1               316    318  0
     D  HRDPM1               319    321  0
     D  HRDPM2               322    324  0
     D  HRDPM3               325    327  0
     D  H2NDPD               328    330  0
     D* Period end dates.
     D  @E                   331    380  0
     D                                     DIM(10)
     D  HRPDTD               331    335  0
     D  HRPDD1               336    340  0
     D  HRPDD2               341    345  0
     D  HRPDD3               346    350  0
     D  HRPDD4               351    355  0
     D  HRPDW1               356    360  0
     D  HRPDM1               361    365  0
     D  HRPDM2               366    370  0
     D  HRPDM3               371    375  0
     D  H2SPPD               376    380  0
     D*
     D**  Data structure to concatenate dates.
     D @DDATE          DS
     D  @NDAT                  1      8  0
     D  @NDYY                  1      4  0
     D  @NDMM                  5      6  0
     D  @NDDD                  7      8  0
     D  @FDAT                  9     16  0
     D  @FDYY                  9     12  0
     D  @FDMM                 13     14  0
     D  @FDDD                 15     16  0
     D  @DMVD                 33     40  0
     D  HNVDYY                33     36  0
     D  HNVDMM                37     38  0
     D  HNVDDD                39     40  0
     D*
     D**  Program status data structure.
     D PSDS           SDS
     D  @NOPMS                37     39  0                                      MMCOFF
     D  @FILE                201    208
     D  @JOB                 244    253
     D  @USER                254    263
     D*
     D**  Local data area for data base error.
     D                UDS
     D  DBFILE               134    141
     D  DBKEY                142    170
     D  DBPGM                171    180
     D  DBASE                181    183
     D*
     D**  DATA STRUCTURE FOR SR. ZA0680 - DATE INPUT TO SUBROUTINE
     D @@DDTN          DS
     D  @@DTIN                 1      8  0
     D  @@YYYY                 1      4  0
     D  @@YY                   3      4  0
     D  @@CC                   1      2  0
     D  @@MTH                  5      6  0
     D  @@DAY                  7      8  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
     D*
     D**  DATA STRUCTURE FOR SR. ZA0710 - FIELD IS @@Z71Y
     D @@DZ7Y          DS
     D  @@Z71Y                 1      4  0
     D  @@SSY1                 1      1  0
     D  @@SSY2                 2      2  0
     D  @@SSY3                 3      3  0
     D  @@SSY4                 4      4  0
     D*
     D**  DATA STRUCTURE FOR SR. ZA0710 - FIELD IS @@VDT
     D @@DVDT          DS
     D  @@VDT                  1      8  0
     D  @@YR                   1      4  0
     D  @@Z71M                 5      6  0
     D  @@Z71D                 7      8  0
     D*
     D**  DATASTRUCTURE TO CHANGE FORMAT TO MMDDYY / DDMMYY
     D @@DDTO          DS             6
     D  @@DTOU                 1      6  0
     D  @@DAT1                 1      2  0
     D  @@DAT2                 3      4  0
     D  @@YYY                  5      6  0
     D*
     D**  USED BY SR. ZA0830 - ARRAY DATA STRUCTURE
     D @DCY            DS
     D  @CY                    1    150
     D                                     DIM(50)
     D  @@CY1                  1     75
     D  @@CY2                 76    150
     D*
     D**  DATA STRUCTURE HOLDING STARTING POINT DATE
     D @@DSTR          DS
     D  @@STRT                 1      8  0
     D  @@STYR                 1      4  0
     D  @@STMT                 5      6  0
     D  @@STDY                 7      8  0
     D*
     D**  DATA STRUCTURE HOLDING SPOT DATE
     D @@DSPD          DS
     D  @@SPDD                 1      8  0
     D  @@SPYR                 1      4  0
     D  @@SPMT                 5      6  0
     D  @@SPDY                 7      8  0
     D*
     D**  DATA STRUCTURE DAYS FOR DATE FORMAT DDMMYY
     D @@DDAT          DS
     D  @@DATE                 1      6  0
     D  @@DAY2                 1      2  0
     D*
     D**  DATA STRUCTURE FOR SR. M1009 - DATE FIELD YYYYMMDD
     D @@DDTA          DS
     D  @@DATA                 1      8  0
     D  @@YY1                  1      4  0
     D  @@MM1                  5      6  0
     D  @@DD1                  7      8  0
     D*
     D**  DATA STRUCTURE FOR SR. M1009 - DATE FIELD YYYYMMDD
     D @@DDTB          DS
     D  @@DATB                 1      8  0
     D  @@YY2                  1      4  0
     D  @@MM2                  5      6  0
     D  @@DD2                  7      8  0
     D*
     D**  DATA STRUCTURE TO MOVE RUNA TO DATE FIELD ON MMEPOULL
     D RUNA            DS             7
     D  @DRD                   1      2  0
     D  @MRD                   3      5
     D  @YRD                   6      7  0
      *
     DDSCNJAN          C                   CONST('JAN')                                     BUG12923
     DDSCNFEB          C                   CONST('FEB')                                     BUG12923
     DDSCNMAR          C                   CONST('MAR')                                     BUG12923
     DDSCNAPR          C                   CONST('APR')                                     BUG12923
     DDSCNMAY          C                   CONST('MAY')                                     BUG12923
     DDSCNJUN          C                   CONST('JUN')                                     BUG12923
     DDSCNJUL          C                   CONST('JUL')                                     BUG12923
     DDSCNAUG          C                   CONST('AUG')                                     BUG12923
     DDSCNSEP          C                   CONST('SEP')                                     BUG12923
     DDSCNOCT          C                   CONST('OCT')                                     BUG12923
     DDSCNNOV          C                   CONST('NOV')                                     BUG12923
     DDSCNDEC          C                   CONST('DEC')                                     BUG12923
      *                                                                                     BUG12923
     DDSMGRDT          DS                                                                   BUG12923
     DDSMGRDD                  1      2  0                                                  BUG12923
     DDSMGRMMA                 3      5                                                     BUG12923
     DDSMGRYY                  6      7  0                                                  BUG12923
      *                                                                                     BUG12923
     DDSRUNd           DS                                                                   BUG12923
     DDSRUNDDT                 1      8  0                                                  BUG12923
     DDSRUNDCC                 1      2  0                                                  BUG12923
     DDSRUNDYY                 3      4  0                                                  BUG12923
     DDSRUNDMM                 5      6  0                                                  BUG12923
     DDSRUNDDD                 7      8  0                                                  BUG12923
      *                                                                                     BUG12923
      **OPY ZSRSRC,ZHOLI                                                  S01195CAP084
      /COPY ZSRSRC,ZHOLILE                                                      CAP084
      *                                                                   S01195
      /EJECT
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN     - Main Line process                                  *
     C*                                                               *
     C* CALLS    #A       - Initial Processing                        *
     C*          #B       - Control main processing                   *
     C*          #C       - Termination processing                    *
     C*                                                               *
     C* CALLED BY         -                                           *
     C*                                                               *
     C* FLDS USED         -                                           *
     C*                                                               *
     C*****************************************************************
     C*
     C**  Initial processing.
     C                   EXSR      #A                                           *1
     C*
     C**  Main processing.
     C     @TERM         IFNE      'T'                                          B1             AB015
     C     JUDFCY        IFLT      JUDSCY                                       B*2            AB010
     C                   MOVE      JUDFCY        @CCY                           **2            AB010
     C                   MOVE      JUNDA1        @AMNT                          **2            AB010
     C                   MOVE      @AMNT         @AMTSV                         **2            AB032
     C                   MOVE      JUINA1        @AMNP                          **2            AB010
     C                   MOVE      JUICM1        @ICMT                          **2            AB010
     C                   MOVE      JUIRT1        @INTR                          **2            AB010
     C                   EXSR      #B                                           **2            AB010
     C*                                                                   AB0109
     C                   MOVE      JUDSCY        @CCY                           **2            AB010
     C                   MOVE      JUNDA2        @AMNT                          **2            AB010
     C                   MOVE      @AMNT         @AMTSV                         **2            AB032
     C                   MOVE      JUINA2        @AMNP                          **2            AB010
     C                   MOVE      JUICM2        @ICMT                          **2            AB010
     C                   MOVE      JUIRT2        @INTR                          **2            AB010
     C                   EXSR      #B                                           **2            AB010
     C*                                                                   AB0109
     C                   ELSE                                                   X*2            AB010
     C*                                                                   AB0109
     C                   MOVE      JUDSCY        @CCY                           **2            AB010
     C                   MOVE      JUNDA2        @AMNT                          **2
     C                   MOVE      @AMNT         @AMTSV                         **2            AB032
     C                   MOVE      JUINA2        @AMNP                          **2
     C                   MOVE      JUICM2        @ICMT                          **2
     C                   MOVE      JUIRT2        @INTR                          **2
     C                   EXSR      #B                                           **2
     C*
     C                   MOVE      JUDFCY        @CCY                           **2
     C                   MOVE      JUNDA1        @AMNT                          **2
     C                   MOVE      @AMNT         @AMTSV                         **2            AB032
     C                   MOVE      JUINA1        @AMNP                          **2
     C                   MOVE      JUICM1        @ICMT                          **2
     C                   MOVE      JUIRT1        @INTR                          **2
     C                   EXSR      #B                                           **2            AB010
     C*                                                                   AB0109
     C                   END                                                    E*2            AB010
     C                   END                                                    E1             AB010
     C*                                                                   AB0153
     C**  Final processing.
     C                   EXSR      #C
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C* SUBROUTINES USED                                              *
     C*                                                               *
     C*  01  #A       - Initial Processing                            *
     C*  02  #B       - Control main processing                       *
     C*  03  #BA      - Initialise new records                        *
     C*  04  #BB      - Initialise period start date array            *
     C*  05  #BC      - Update time loans/deposits balances           *
     C*  06  #C       - Termination processing                        *
     C*  07  #ZA      - Calculate number of days in period            *
     C*  08  #ZB      - Update balance array                          *
     C*  09  #ZC      - Update accrued interest array                 *
     C*  09  ZA0680   - Convert date format to midas day number       *
     C*  10  ZA0710   - Convert midas day no to date format           *
     C*  11  ZA0730   - Determine next working day                    *
     C*  12  ZA0770   - Format date field                             *
     C***13**ZA0830***-*Determine if day is a working day             *   S01195
     C*  14  ZA1290   - Calculate period date                         *
     C*  15  *PSSR    - Program error handling subroutine             *
     C*  16  INFSR    - File Exception/error subroutine               *
     C*                                                               *
     C*                                                               *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #A       - Initial Processing                                 *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  MAIN   - Main Line process                         *
     C*                                                               *
     C* FLDS USED  @FCYC  - Work field for first cycle processing     *
     C*            @TERM  - Termination parameter                     *
     C*            @DCAT  - Work field for Format read                *
     C*            @STDL  - Data structure for loan/deposit record    *
     C*            @STDB  - Data structure for NAB record             *
     C*            @STDS  - Data structure for NAS record             *
     C*            @STDA  - Data structure for DEAMs record           *
     C*            @MPHAS - Data structure status of system           *
     C*            @CCY   - Work field for currency                   *
     C*            @LACT  - Work field for action code                *
     C*            @AMNT  - Work field for amount                     *
     C*            @INTR  - Work field for interest rate              *
     C*            @ICMT  - Work field for Cal Method                 *
     C*            @ORMT  - Work field for our receive method         *
     C*            @OPMT  - Work field for our pay method             *
     C*            @VDYY  - Work field for near Year                  *
     C*            @VDMM  - Work field for near month                 *
     C*            @VDDD  - Work field for near day                   *
     C*            @MDYY  - Work field for far year                   *
     C*            @MDMM  - Work field for far month                  *
     C*            @MDDD  - Work field for far Day                    *
     C*            @SLYY  - Work field for Start last int year        *
     C*            @SLMM  - Work field for Start last Int month       *
     C*            @SLDD  - Work field for Start last int day         *
     C*                                                               *
     C*****************************************************************
     C     #A            BEGSR
     C*                                                                   AB0153
     C**  If termination parameter is 'T', no further processing.         AB0153
     C     @TERM         CABEQ     'T'           #A9                                           AB015
     C*
     C     @FCYC         IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @FCYC             1            *1
     C*
     C**  Receive input parameters.
     C     *ENTRY        PLIST                                                  *1
     C                   PARM                    @TERM             1            *1
     C                   PARM                    @STDD                          *1
     C                   PARM                    @COFF             1            *1             MMCOF
     C*
     C**  Set up program name in *LDA in case of database error.
     C                   MOVEL     'AB0280'      DBPGM                          *1
     C*                                                                   MMCOFF
     C* If Commitment Control Off Parameter was sent move it to testable  MMCOFF
     C*    field
     C     @NOPMS        IFGT      2                                                           MMCOF
     C                   MOVE      @COFF         @COFF2            1                           MMCOF
     C                   END                                                                   MMCOF
     C*
     C**  Open files.
     C*********************OPEN FDICDRLL                   *1             S01194
     C*********************OPEN FDCCYTLL                   *1             S01194
     C     @COFF2        IFEQ      'Y'                                                         MMCOF
     C*  Override Dummy Files to real files.                              MMCOFF
     C                   Z-ADD     30            @LNTH            15 5                         MMCOF
     C*********************CALL 'QCAEXEC'                                 E20774
     C                   CALL      'QCMDEXC'                                                   E2077
     C                   PARM                    @CMD(1)                                       MMCOF
     C                   PARM                    @LNTH                                         MMCOF
     C*********************CALL 'QCAEXEC'                                 E20774
     C                   CALL      'QCMDEXC'                                                   E2077
     C                   PARM                    @CMD(2)                                       MMCOF
     C                   PARM                    @LNTH                                         MMCOF
     C                   OPEN      MMEDUMLL                                                    MMCOF
     C                   OPEN      MMFDUMLL                                                    MMCOF
     C                   ELSE                                                                  MMCOF
     C                   OPEN      MMEPOULL                                                    MMCOF
     C                   OPEN      MMFNRULL                                                    MMCOF
     C                   END                                                                   MMCOF
     C*
     C****Access*FDICDRLL*to*get*MIDAS run date.                          S01194
     C*********************MOVE *BLANKS   KEY              *1             S01194
     C*********************MOVEL'01'      KEY    12        *1             S01194
     C*********************MOVE '10'      KEY              *1             S01194
     C***********KEY*******CHAINFDICDRLL             60    *1             S01194
     C*********************                                               S01194
     C********** *IN60*****IFEQ '1'                        B*2            S01194
     C                   CALL      'AOBANKR0'                                                  S0119
     C                   PARM      *BLANKS       @RTCD                                         S0119
     C                   PARM      '*FIRST '     @OPTN                                         S0119
     C     SDBANK        PARM      SDBANK        DSFDY                                         S0119
     C     @RTCD         IFNE      *BLANKS                                      B*2            S0119
     C                   MOVE      '001'         DBASE                          ***************
     C*********************MOVEL'FDICDRLL'DBFILE           *             *S01194
     C                   MOVEL     'SDBANKPD'    DBFILE                                        S0119
     C*********************MOVELKEY       DBKEY            * DBERROR 001 *S01194
     C                   MOVEL     @OPTN         DBOPTN            7                           S0119
     C                   MOVE      '1'           *INU7                          *             *
     C                   MOVE      '1'           *INU8                          ***************
     C                   GOTO      #A9                                          **2
     C                   END                                                    E*2
     C*
     C**  Extract file fields.
     C     *LIKE         DEFINE    JUDFCY        @CCY                           *1
     C     *LIKE         DEFINE    JULACT        @LACT                          *1
     C     *LIKE         DEFINE    JUNDA1        @AMNT                          *1
     C     *LIKE         DEFINE    JUNDA1        @AMTSV                         *1             AB032
     C     *LIKE         DEFINE    JUIRT1        @INTR                          *1
     C     *LIKE         DEFINE    JUICM1        @ICMT                          *1
     C     *LIKE         DEFINE    JUINA1        @AMNP                          *1
     C*
      ** Setup rundate to YYYYMMDD                                                          BUG12923
      *                                                                                     BUG12923
     C                   EXSR      SRRUNDAT                                                 BUG12923
      *                                                                                     BUG12923
     C                   END                                                    E1
     C*
     C                   Z-ADD     JUNDDD        @NDDD
     C                   Z-ADD     JUNDMM        @NDMM
     C                   Z-ADD     JUNDYY        @NDYY
     C                   Z-ADD     JUFDDD        @FDDD
     C                   Z-ADD     JUFDMM        @FDMM
     C                   Z-ADD     JUFDYY        @FDYY
     C*
     C                   MOVE      JULACT        @LACT
     C*
     C     #A9           ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #B       - Control main processing                            *
     C*                                                               *
     C* CALLS    #BA      - Initialise new MMEPOULL record            *
     C*          #BB      - Initialise period start date array        *
     C*          ZA0680   - Convert date format to midas day number   *
     C*          #BC      - Update time loans/deposits balances       *
     C*          #BD      - Initialise new MMFNRULL record            *
     C*                                                               *
     C* CALLED BY  MAIN   - Main Line process                         *
     C*                                                               *
     C* FLDS USED  @TERM  - Termination parameter                     *
     C*            @DCAT  - Work field for Format read                *
     C*            @CCY   - Work field for currency                   *
     C*            @NDAT  - Work filed for Deal near date             *
     C*            @@DTIN - Data structure to hold date               *
     C*            @@MDNO - Work field for number of days in month    *
     C*            @NDAT5 - Work field for near date                  *
     C*            @FDAT  - Work field for far date                   *
     C*            @FDAT5 - Work field for far date                   *
     C*            @RVDT5 - Work field for related near date          *
     C*            @RMTD5 - Work field for related far date           *
     C*            @RLID5 - Work field for related start last date    *
     C*            @RNID5 - Work field for related next int date      *
     C*            @MPHAS - Data structure status of system           *
     C*                                                               *
     C*****************************************************************
     C     #B            BEGSR
     C*
     C**  If termination parameter set to 'T', no further processing.
     C     @TERM         CABEQ     'T'           #B9
     C     *INU7         CABEQ     '1'           #B9
     C*
     C**  Access update files via currency.
     C     @COFF2        IFEQ      'Y'                                                         MMCOF
     C     @CCY          CHAIN     MMFDUMLL                           60                       MMCOF
     C*****      @CCY      CHAINMMEDUMLL             60                   AB0147
     C     @CCY          CHAIN     MMEDUMLL                           70                       AB014
     C                   ELSE                                                                  MMCOF
     C     @CCY          CHAIN     MMFNRULL                           60
     C*****      @CCY      CHAINMMEPOULL             60                   AB0147
     C     @CCY          CHAIN     MMEPOULL                           70                       AB014
     C                   END                                                                   MMCOF
     C*****                                                               AB0147
     C*****nitialise new records.                                         AB0147
     C*****      *IN60     IFEQ '1'                        B1             AB0147
     C*****                EXSR #BA                        *1             AB0147
     C*****      @COFF2    IFEQ 'Y'                                       AB0147
     C*****      @CCY      CHAINMMFDUMLL             60    *1             AB0147
     C*****      @CCY      CHAINMMEDUMLL             60    *1             AB0147
     C*****                ELSE                                           AB0147
     C*****      @CCY      CHAINMMFNRULL             60    *1             AB0147
     C*****      @CCY      CHAINMMEPOULL             60    *1             AB0147
     C*****                END                                            AB0147
     C*****                END                             E1             AB0147
     C*                                                                   AB0147
     C**  Initialise new MMFNRULL Record                                  AB0147
     C     *IN60         IFEQ      '1'                                          B1             AB014
     C                   EXSR      #BD                                          *1             AB014
     C     @COFF2        IFEQ      'Y'                                                         AB014
     C     @CCY          CHAIN     MMFDUMLL                           60        *1             AB014
     C                   ELSE                                                                  AB014
     C     @CCY          CHAIN     MMFNRULL                           60        *1             AB014
     C                   END                                                                   AB014
     C                   END                                                    E1             AB014
     C*                                                                   AB0147
     C     *INU7         CABEQ     '1'           #B9                                           AB014
     C*                                                                   AB0147
     C**  Initialise new MMEPOULL Record                                  AB0147
     C     *IN70         IFEQ      '1'                                          B1             AB014
     C                   EXSR      #BA                                          *1             AB014
     C     @COFF2        IFEQ      'Y'                                                         AB014
     C     @CCY          CHAIN     MMEDUMLL                           70        *1             AB014
     C                   ELSE                                                                  AB014
     C     @CCY          CHAIN     MMEPOULL                           70        *1             AB014
     C                   END                                                                   AB014
     C                   END                                                    E1             AB014
     C*
     C     *INU7         CABEQ     '1'           #B9
     C*
     C**  Initialise periods start dates arrays.
     C                   EXSR      #BB
     C*
     C**  Convert date fields from file YYYYMMDD to MIDAS day numbers.
     C     @NDAT         IFNE      *ZEROS                                       B1
     C                   Z-ADD     @NDAT         @@DTIN                         *1
     C                   EXSR      ZA0680                                       *1
     C                   Z-ADD     @@MDNO        @NDAT5            5 0          *1
     C                   END                                                    E1
     C*
     C     @FDAT         IFNE      *ZEROS                                       B1
     C                   Z-ADD     @FDAT         @@DTIN                         *1
     C                   EXSR      ZA0680                                       *1
     C                   Z-ADD     @@MDNO        @FDAT5            5 0          *1
     C                   END                                                    E1
     C*
     C*
     C**  Update balances and interest accruals.
     C                   EXSR      #BC
     C*
     C**  Update files.
     C     @COFF2        IFEQ      'Y'                                                         MMCOF
     C                   UPDATE    MMFDUMP0                                                    MMCOF
     C                   UPDATE    MMEDUMP0                                                    MMCOF
     C                   ELSE                                                                  MMCOF
     C                   UPDATE    MMFNRDP0
     C                   UPDATE    MMEPOSP0
     C                   END                                                                   MMCOF
     C*
     C     #B9           ENDSR
     C*****************************************************************
     C*****T                                                              AB0147
     C*****************************************************************   AB0147
     C*****                                                           *   AB0147
     C*****      - Initialise new records                             *   AB0147
     C*****                                                           *   AB0147
     C*****LS    ZA0730   - Determine next working day                *   AB0147
     C*****      ZA0680   - Convert date format to midas day number   *   AB0147
     C*****      ZA0710   - Convert midas day number to date format   *   AB0147
     C*****      ZA1290   - Calculate period date                     *   AB0147
     C*****                                                           *   AB0147
     C*****LED BY  BB     - Main processing                           *   AB0147
     C*****                                                           *   AB0147
     C*****S USED  @USER  - work field for user                       *   AB0147
     C*****        @CCY   - Work field for currency                   *   AB0147
     C*****        @@DTIN - Data structure to hold date               *   AB0147
     C*****        @@CCY  - work field for currency                   *   AB0147
     C*****        @@MDNO - Work field for number of days in month    *   AB0147
     C*****        @A     - Array to hold net balances                *   AB0147
     C*****        @I     - Array for net Interest accrued            *   AB0147
     C*****        @@DAYN - Work field for day number                 *   AB0147
     C*****        @@VDT  - Work field for period date                *   AB0147
     C*****        @@SPOT - Work field for spot date                  *   AB0147
     C*****        @@PNUM - Work field for period number (1,2,3 etc)  *   AB0147
     C*****        @@PTYP - Work field for period type (D, M or W)    *   AB0147
     C*****        @@PDAT - Work field for period end date            *   AB0147
     C*****                                                           *   AB0147
     C*****************************************************************   AB0147
     C*****      #BA       BEGSR                                          AB0147
     C*****                                                               AB0147
     C*****reate new record on MMEPOULL.                                  AB0147
     C*****                MOVE 'H2'      H2RCID                          AB0147
     C*****                MOVE *BLANKS   H2DLTF                          AB0147
     C*****                Z-ADD@DRD      H2DLUP                          AB0147
     C*****                MOVE @MRD      H2MLUP                          AB0147
     C*****                Z-ADD@YRD      H2YLUP                          AB0147
     C*****                TIME           H2TLUP                          AB0147
     C*****                MOVE 'I'       H2CHTP                          AB0147
     C*****                Z-ADDRUND      H2LCD                           AB0147
     C*****                MOVEL@USER     H2LUID                          AB0147
     C*****                MOVE @CCY      H2CCY                           AB0147
     C*****                                                               AB0147
     C*****ccess FDCCYTLL to get default interest calculation method.     AB0147
     C*****                MOVE *BLANKS   KEY                             AB0147
     C*****                MOVEL'20'      KEY                             AB0147
     C*****                MOVEL@CCY      KEY912  4                       AB0147
     C*****                MOVE '1'       KEY912                          AB0147
     C*****                MOVE KEY912    KEY                             AB0147
     C*****      KEY       CHAINFDCCYTLL             60                   AB0147
     C*****                                                               AB0147
     C*****      *IN60     IFEQ '1'                        B1             AB0147
     C*****                MOVE '003'     DBASE            ***************AB0147
     C*****                MOVEL'FDCCYTLL'DBFILE           *             *AB0147
     C*****                MOVELKEY       DBKEY            * DBERROR 003 *AB0147
     C*****                MOVE '1'       *INU7            *             *AB0147
     C*****                MOVE '1'       *INU8            ***************AB0147
     C*****                GOTO #BA9                       *1             AB0147
     C*****                END                             E1             AB0147
     C*****                                                               AB0147
     C*****                Z-ADDDICM      H2DICM                          AB0147
     C*****                Z-ADD*ZEROS    H2NBSP                          AB0147
     C*****                Z-ADD*ZEROS    H2NIAS                          AB0147
     C*****                Z-ADD*ZEROS    H2CCPL                          AB0147
     C*****                Z-ADDMSPD      H2SPDT                          AB0147
     C*****                                                               AB0147
     C*****lculate spot date period date.                                 AB0147
     C*****                Z-ADDMSPD      @@DTIN                          AB0147
     C*****                MOVE @CCY      @@CCY   3                       AB0147
     C*****                EXSR ZA0730                                    AB0147
     C*****      @@MDNO    SUB  1         H2SPPD                          AB0147
     C*****                                                               AB0147
     C*****lculate number of days in period.                              AB0147
     C*****                Z-ADDMSPD      @@DTIN                          AB0147
     C*****                EXSR ZA0680                                    AB0147
     C*****      H2SPPD    SUB  @@MDNO    H2NDPD                          AB0147
     C*****                ADD  1         H2NDPD                          AB0147
     C*****                                                               AB0147
     C*****      @COFF2    IFEQ 'Y'                                       AB0147
     C*****                WRITEMMEDUMP0                                  AB0147
     C*****                ELSE                                           AB0147
     C*****                WRITEMMEPOSP0                                  AB0147
     C*****                END                                            AB0147
     C*****                                                               AB0147
     C*****reate new record on MMFNRULL.                                  AB0147
     C*****                MOVE 'HR'      HRRCID                          AB0147
     C*****                MOVE *BLANKS   HRDLTF                          AB0147
     C*****                Z-ADD@DRD      HRDLUP                          AB0147
     C*****                MOVE @MRD      HRMLUP                          AB0147
     C*****                Z-ADD@YRD      HRYLUP                          AB0147
     C*****                TIME           HRTLUP                          AB0147
     C*****                MOVE 'I'       HRCHTP                          AB0147
     C*****                Z-ADDRUND      HRLCD                           AB0147
     C*****                MOVEL@USER     HRLUID                          AB0147
     C*****                MOVE @CCY      HRCCY                           AB0147
     C*****                Z-ADDDICM      HRDICM                          AB0147
     C*****                Z-ADD*ZEROS    HRNOSN                          AB0147
     C*****                Z-ADD*ZEROS    @A                              AB0147
     C*****                Z-ADD*ZEROS    @I                              AB0147
     C*****                                                               AB0147
     C*****lculate today period date.                                     AB0147
     C*****                Z-ADDRUND      @@DAYN                          AB0147
     C*****                EXSR ZA0710                                    AB0147
     C*****                Z-ADD@@VDT     @@DTIN                          AB0147
     C*****                MOVE @CCY      @@CCY                           AB0147
     C*****                EXSR ZA0730                                    AB0147
     C*****      @@MDNO    SUB  1         HRPDTD                          AB0147
     C*****                                                               AB0147
     C*****lculate D1 period date.                                        AB0147
     C*****                Z-ADD@@MDNO    @@DAYN                          AB0147
     C*****                EXSR ZA0710                                    AB0147
     C*****                Z-ADD@@VDT     @@DTIN                          AB0147
     C*****                EXSR ZA0730                                    AB0147
     C*****      @@MDNO    SUB  1         HRPDD1                          AB0147
     C*****                                                               AB0147
     C*****lculate D2 period date.                                        AB0147
     C*****                Z-ADD@@MDNO    @@DAYN                          AB0147
     C*****                EXSR ZA0710                                    AB0147
     C*****                Z-ADD@@VDT     @@DTIN                          AB0147
     C*****                EXSR ZA0730                                    AB0147
     C*****      @@MDNO    SUB  1         HRPDD2                          AB0147
     C*****                                                               AB0147
     C*****lculate D3 period date.                                        AB0147
     C*****                Z-ADD@@MDNO    @@DAYN                          AB0147
     C*****                EXSR ZA0710                                    AB0147
     C*****                Z-ADD@@VDT     @@DTIN                          AB0147
     C*****                EXSR ZA0730                                    AB0147
     C*****      @@MDNO    SUB  1         HRPDD3                          AB0147
     C*****                                                               AB0147
     C*****lculate D4 period date.                                        AB0147
     C*****                Z-ADD@@MDNO    @@DAYN                          AB0147
     C*****                EXSR ZA0710                                    AB0147
     C*****                Z-ADD@@VDT     @@DTIN                          AB0147
     C*****                EXSR ZA0730                                    AB0147
     C*****      @@MDNO    SUB  1         HRPDD4                          AB0147
     C*****                                                               AB0147
     C*****lculate W1 period date.                                        AB0147
     C*****                MOVE @CCY      @@CCY                           AB0147
     C*****                MOVE MSPD      @@SPOT                          AB0147
     C*****                Z-ADD1         @@PNUM                          AB0147
     C*****                MOVE 'W'       @@PTYP                          AB0147
     C*****                EXSR ZA1290                                    AB0147
     C*****                Z-ADD@@PDAT    @@DTIN                          AB0147
     C*****                EXSR ZA0680                                    AB0147
     C*****      @@MDNO    SUB  1         HRPDW1                          AB0147
     C*****                                                               AB0147
     C*****lculate M1 period date.                                        AB0147
     C*****                MOVE MSPD      @@SPOT                          AB0147
     C*****                Z-ADD1         @@PNUM                          AB0147
     C*****                MOVE 'M'       @@PTYP                          AB0147
     C*****                EXSR ZA1290                                    AB0147
     C*****                Z-ADD@@PDAT    @@DTIN                          AB0147
     C*****                EXSR ZA0680                                    AB0147
     C*****      @@MDNO    SUB  1         HRPDM1                          AB0147
     C*****                                                               AB0147
     C*****lculate M2 period date.                                        AB0147
     C*****                MOVE MSPD      @@SPOT                          AB0147
     C*****                Z-ADD2         @@PNUM                          AB0147
     C*****                MOVE 'M'       @@PTYP                          AB0147
     C*****                EXSR ZA1290                                    AB0147
     C*****                Z-ADD@@PDAT    @@DTIN                          AB0147
     C*****                EXSR ZA0680                                    AB0147
     C*****      @@MDNO    SUB  1         HRPDM2                          AB0147
     C*****                                                               AB0147
     C***** culate M3 period date.                                        AB0147
     C*****                MOVE MSPD      @@SPOT                          AB0147
     C*****                Z-ADD3         @@PNUM                          AB0147
     C*****                MOVE 'M'       @@PTYP                          AB0147
     C*****                EXSR ZA1290                                    AB0147
     C*****                Z-ADD@@PDAT    @@DTIN                          AB0147
     C*****                EXSR ZA0680                                    AB0147
     C*****      @@MDNO    SUB  1         HRPDM3                          AB0147
     C*****                                                               AB0147
     C***** culate number of days in periods.                             AB0147
     C*****      HRPDTD    SUB  RUND      HRDPTD                          AB0147
     C*****                ADD  1         HRDPTD                          AB0147
     C*****      HRPDD1    SUB  HRPDTD    HRDPD1                          AB0147
     C*****      HRPDD2    SUB  HRPDD1    HRDPD2                          AB0147
     C*****      HRPDD3    SUB  HRPDD2    HRDPD3                          AB0147
     C*****      HRPDD4    SUB  HRPDD3    HRDPD4                          AB0147
     C*****      HRPDW1    SUB  HRPDD4    HRDPW1                          AB0147
     C*****      HRPDM1    SUB  HRPDW1    HRDPM1                          AB0147
     C*****      HRPDM2    SUB  HRPDM1    HRDPM2                          AB0147
     C*****      HRPDM3    SUB  HRPDM2    HRDPM3                          AB0147
     C*****                                                               AB0147
     C*****      @COFF2    IFEQ 'Y'                                       AB0147
     C*****                WRITEMMFDUMP0                                  AB0147
     C*****                ELSE                                           AB0147
     C*****                WRITEMMFNRDP0                                  AB0147
     C*****                END                                            AB0147
     C*****                                                               AB0147
     C*****      #BA9      ENDSR                                          AB0147
     C*****************************************************************   AB0147
     C/EJECT                                                              AB0147
     C*****************************************************************   AB0147
     C*                                                               *   AB0147
     C* #BA      - Initialise new MMEPOULL Record                     *   AB0147
     C*                                                               *   AB0147
     C* CALLS    ZA0730   - Determine next working day                *   AB0147
     C*          ZA0680   - Convert date format to midas day number   *   AB0147
     C*                                                               *   AB0147
     C* CALLED BY  BB     - Main processing                           *   AB0147
     C*                                                               *   AB0147
     C* FLDS USED  @USER  - work field for user                       *   AB0147
     C*            @CCY   - Work field for currency                   *   AB0147
     C*            @@DTIN - Data structure to hold date               *   AB0147
     C*            @@MDNO - Work field for number of days in month    *   AB0147
     C*                                                               *   AB0147
     C*****************************************************************   AB0147
     C     #BA           BEGSR                                                                 AB014
     C*                                                                   AB0147
     C**  Create new record on MMEPOULL.                                  AB0147
     C                   MOVE      'H2'          H2RCID                                        AB014
     C                   MOVE      *BLANKS       H2DLTF                                        AB014
     C                   Z-ADD     @DRD          H2DLUP                                        AB014
     C                   MOVE      @MRD          H2MLUP                                        AB014
     C                   Z-ADD     @YRD          H2YLUP                                        AB014
     C                   TIME                    H2TLUP                                        AB014
     C                   MOVE      'I'           H2CHTP                                        AB014
     C                   Z-ADD     RUND          H2LCD                                         AB014
     C                   MOVEL     @USER         H2LUID                                        AB014
     C                   MOVE      @CCY          H2CCY                                         AB014
     C*                                                                   S01194
     C****Access*FDCCYTLL*to*get*default*interest calculation method.     S01194
     C*********************MOVE *BLANKS   KEY                             S01194
     C*********************MOVEL'20'      KEY                             S01194
     C*********************MOVEL@CCY      KEY912  4                       S01194
     C*********************MOVE '1'       KEY912                          S01194
     C*********************MOVE KEY912    KEY                             S01194
     C***********KEY*******CHAINFDCCYTLL             60                   S01194
     C*********************                                               S01194
     C********** *IN60*****IFEQ '1'                        B1             S01194
     C                   CALL      'AOCURRR0'                                                  S0119
     C                   PARM      *BLANKS       @RTCD             7                           S0119
     C                   PARM      '*KEY   '     @OPTN             7                           S0119
     C                   PARM      @CCY          @AJCD             3                           S0119
     C     SDCURR        PARM      SDCURR        DSSDY                                         S0119
     C     @RTCD         IFNE      *BLANKS                                      B1             S0119
     C                   MOVE      '003'         DBASE                          ***************
     C*********************MOVEL'FDCCYTLL'DBFILE           *             *S01194
     C                   MOVEL     'SDCURRPD'    DBFILE                                        S0119
     C                   MOVEL     @OPTN         DBOPTN                                        S0119
     C*********************MOVELKEY       DBKEY            * DBERROR 003 *S01194
     C                   MOVEL     @CCY          DBKEY                          **2            S0119
     C                   MOVE      '1'           *INU7                          *             *
     C                   MOVE      '1'           *INU8                          ***************
     C                   GOTO      #BA9                                         *1
     C                   END                                                    E1
     C*                                                                   AB0147
     C*********************Z-ADDDICM      H2DICM                          S01194
     C                   MOVE      A6DICB        H2DICM                                        S0119
     C                   Z-ADD     *ZEROS        H2NBSP                                        AB014
     C                   Z-ADD     *ZEROS        H2NIAS                                        AB014
     C                   Z-ADD     *ZEROS        H2CCPL                                        AB014
     C*********************Z-ADDMSPD      H2SPDT                          S01194
      *                                                                                     BUG12923
     C                   IF        A6SPDY = 0                                               BUG12923
     C                   Z-ADD     DSRUNDDT      H2SPDT                                     BUG12923
     C                   ELSE                                                               BUG12923
     C                   Z-ADD     A6MMSD        H2SPDT                                        S0119
     C                   ENDIF                                                              BUG12923
     C*                                                                   AB0147
     C** Calculate spot date period date.                                 AB0147
     C*********************Z-ADDMSPD      @@DTIN                          S01194
      *                                                                                     BUG12923
     C                   IF        A6SPDY = 0                                               BUG12923
     C                   Z-ADD     DSRUNDDT      @@DTIN                                     BUG12923
     C                   ELSE                                                               BUG12923
     C                   Z-ADD     A6MMSD        @@DTIN                                        S0119
     C                   ENDIF                                                              BUG12923
      *                                                                                     BUG12923
     C                   MOVE      @CCY          @@CCY             3                           AB014
     C                   EXSR      ZA0730                                                      AB014
     C     @@MDNO        SUB       1             H2SPPD                                        AB014
     C*                                                                   AB0147
     C** Calculate number of days in period.                              AB0147
     C*********************Z-ADDMSPD      @@DTIN                          S01194
      *                                                                                     BUG12923
     C                   IF        A6SPDY = 0                                               BUG12923
     C                   Z-ADD     DSRUNDDT      @@DTIN                                     BUG12923
     C                   ELSE                                                               BUG12923
     C                   Z-ADD     A6MMSD        @@DTIN                                        S0119
     C                   ENDIF                                                              BUG12923
      *                                                                                     BUG12923
     C                   EXSR      ZA0680                                                      AB014
     C     H2SPPD        SUB       @@MDNO        H2NDPD                                        AB014
     C                   ADD       1             H2NDPD                                        AB014
     C*                                                                   AB0147
     C     @COFF2        IFEQ      'Y'                                                         AB014
     C                   WRITE     MMEDUMP0                                                    AB014
     C                   ELSE                                                                  AB014
     C                   WRITE     MMEPOSP0                                                    AB014
     C                   END                                                                   AB014
     C*                                                                   AB0147
     C     #BA9          ENDSR                                                                 AB014
     C*****************************************************************   AB0147
     C/EJECT                                                              AB0147
     C*****************************************************************   AB0147
     C*                                                               *   AB0147
     C* #BD      - Initialise new MMFNRULL Record                     *   AB0147
     C*                                                               *   AB0147
     C* CALLS    ZA0730   - Determine next working day                *   AB0147
     C*          ZA0680   - Convert date format to midas day number   *   AB0147
     C*          ZA0710   - Convert midas day number to date format   *   AB0147
     C*          ZA1290   - Calculate period date                     *   AB0147
     C*                                                               *   AB0147
     C* CALLED BY  BB     - Main processing                           *   AB0147
     C*                                                               *   AB0147
     C* FLDS USED  @USER  - work field for user                       *   AB0147
     C*            @CCY   - Work field for currency                   *   AB0147
     C*            @@DTIN - Data structure to hold date               *   AB0147
     C*            @@CCY  - work field for currency                   *   AB0147
     C*            @@MDNO - Work field for number of days in month    *   AB0147
     C*            @A     - Array to hold net balances                *   AB0147
     C*            @I     - Array for net Interest accrued            *   AB0147
     C*            @@DAYN - Work field for day number                 *   AB0147
     C*            @@VDT  - Work field for period date                *   AB0147
     C*            @@SPOT - Work field for spot date                  *   AB0147
     C*            @@PNUM - Work field for period number (1,2,3 etc)  *   AB0147
     C*            @@PTYP - Work field for period type (D, M or W)    *   AB0147
     C*            @@PDAT - Work field for period end date            *   AB0147
     C*                                                               *   AB0147
     C*****************************************************************   AB0147
     C*                                                                   AB0147
     C     #BD           BEGSR                                                                 AB014
     C*                                                                   AB0147
     C**  Create new record on MMFNRULL.                                  AB0147
     C                   MOVE      'HR'          HRRCID                                        AB014
     C                   MOVE      *BLANKS       HRDLTF                                        AB014
     C                   Z-ADD     @DRD          HRDLUP                                        AB014
     C                   MOVE      @MRD          HRMLUP                                        AB014
     C                   Z-ADD     @YRD          HRYLUP                                        AB014
     C                   TIME                    HRTLUP                                        AB014
     C                   MOVE      'I'           HRCHTP                                        AB014
     C                   Z-ADD     RUND          HRLCD                                         AB014
     C                   MOVEL     @USER         HRLUID                                        AB014
     C                   MOVE      @CCY          HRCCY                                         AB014
     C*********************Z-ADDDICM      HRDICM                          S01194
     C                   MOVE      A6DICB        HRDICM                                        S0119
     C                   Z-ADD     *ZEROS        HRNOSN                                        AB014
     C                   Z-ADD     *ZEROS        @A                                            AB014
     C                   Z-ADD     *ZEROS        @I                                            AB014
     C*                                                                   AB0147
     C** Calculate today period date.                                     AB0147
     C                   Z-ADD     RUND          @@DAYN                                        AB014
     C                   EXSR      ZA0710                                                      AB014
     C                   Z-ADD     @@VDT         @@DTIN                                        AB014
     C                   MOVE      @CCY          @@CCY                                         AB014
     C                   EXSR      ZA0730                                                      AB014
     C     @@MDNO        SUB       1             HRPDTD                                        AB014
     C*                                                                   AB0147
     C** Calculate D1 period date.                                        AB0147
     C                   Z-ADD     @@MDNO        @@DAYN                                        AB014
     C                   EXSR      ZA0710                                                      AB014
     C                   Z-ADD     @@VDT         @@DTIN                                        AB014
     C                   EXSR      ZA0730                                                      AB014
     C     @@MDNO        SUB       1             HRPDD1                                        AB014
     C*                                                                   AB0147
     C** Calculate D2 period date.                                        AB0147
     C                   Z-ADD     @@MDNO        @@DAYN                                        AB014
     C                   EXSR      ZA0710                                                      AB014
     C                   Z-ADD     @@VDT         @@DTIN                                        AB014
     C                   EXSR      ZA0730                                                      AB014
     C     @@MDNO        SUB       1             HRPDD2                                        AB014
     C*                                                                   AB0147
     C** Calculate D3 period date.                                        AB0147
     C                   Z-ADD     @@MDNO        @@DAYN                                        AB014
     C                   EXSR      ZA0710                                                      AB014
     C                   Z-ADD     @@VDT         @@DTIN                                        AB014
     C                   EXSR      ZA0730                                                      AB014
     C     @@MDNO        SUB       1             HRPDD3                                        AB014
     C*                                                                   AB1047
     C** Calculate D4 period date.                                        AB0147
     C                   Z-ADD     @@MDNO        @@DAYN                                        AB014
     C                   EXSR      ZA0710                                                      AB014
     C                   Z-ADD     @@VDT         @@DTIN                                        AB014
     C                   EXSR      ZA0730                                                      AB014
     C     @@MDNO        SUB       1             HRPDD4                                        AB014
     C*                                                                   AB0147
     C****Access*FDCCYTLL*to*get*MM spot date.                            S01194
     C*********************MOVE *BLANKS   KEY                             S01194
     C*********************MOVEL'20'      KEY                             S01194
     C*********************MOVEL@CCY      KEY912  4                       S01194
     C*********************MOVE '1'       KEY912                          S01194
     C*********************MOVE KEY912    KEY                             S01194
     C***********KEY*******CHAINFDCCYTLL             60                   S01194
     C*********************                                               S01194
     C********** *IN60*****IFEQ '1'                        B1             S01194
     C                   CALL      'AOCURRR0'                                                  S0119
     C                   PARM      *BLANKS       @RTCD             7                           S0119
     C                   PARM      '*KEY   '     @OPTN             7                           S0119
     C                   PARM      @CCY          @AJCD             3                           S0119
     C     SDCURR        PARM      SDCURR        DSSDY                                         S0119
     C     @RTCD         IFNE      *BLANKS                                      B1             S0119
     C                   MOVE      '004'         DBASE                          ***************
     C*********************MOVEL'FDCCYTLL'DBFILE           *             *S01194
     C                   MOVEL     'SDCURRPD'    DBFILE                                        S0119
     C                   MOVEL     @OPTN         DBOPTN                                        S0119
     C*********************MOVELKEY       DBKEY            * DBERROR 004 *S01194
     C                   MOVEL     @CCY          DBKEY                          **2            S0119
     C                   MOVE      '1'           *INU7                          *             *
     C                   MOVE      '1'           *INU8                          ***************
     C                   GOTO      #BD9                                         *1
     C                   END                                                    E1
     C*                                                                   AB0147
     C** Calculate W1 period date.                                        AB0147
     C                   MOVE      @CCY          @@CCY                                         AB014
     C*********************MOVE MSPD      @@SPOT                          S01194
      *                                                                                     BUG12923
     C                   IF        A6SPDY = 0                                               BUG12923
     C                   Z-ADD     DSRUNDDT      @@SPOT                                     BUG12923
     C                   ELSE                                                               BUG12923
     C                   MOVE      A6MMSD        @@SPOT                                        S0119
     C                   ENDIF                                                              BUG12923
      *                                                                                     BUG12923
     C                   Z-ADD     1             @@PNUM                                        AB014
     C                   MOVE      'W'           @@PTYP                                        AB014
     C                   EXSR      ZA1290                                                      AB014
     C                   Z-ADD     @@PDAT        @@DTIN                                        AB014
     C                   EXSR      ZA0680                                                      AB014
     C     @@MDNO        SUB       1             HRPDW1                                        AB014
     C*                                                                   AB0147
     C** Calculate M1 period date.                                        AB0147
     C*********************MOVE MSPD      @@SPOT                          S01194
      *                                                                                     BUG12923
     C                   IF        A6SPDY = 0                                               BUG12923
     C                   Z-ADD     DSRUNDDT      @@SPOT                                     BUG12923
     C                   ELSE                                                               BUG12923
     C                   MOVE      A6MMSD        @@SPOT                                        S0119
     C                   ENDIF                                                              BUG12923
      *                                                                                     BUG12923
     C                   Z-ADD     1             @@PNUM                                        AB014
     C                   MOVE      'M'           @@PTYP                                        AB014
     C                   EXSR      ZA1290                                                      AB014
     C                   Z-ADD     @@PDAT        @@DTIN                                        AB014
     C                   EXSR      ZA0680                                                      AB014
     C     @@MDNO        SUB       1             HRPDM1                                        AB014
     C*                                                                   AB0147
     C** Calculate M2 period date.                                        AB0147
     C*********************MOVE MSPD      @@SPOT                          S01194
      *                                                                                     BUG12923
     C                   IF        A6SPDY = 0                                               BUG12923
     C                   Z-ADD     DSRUNDDT      @@SPOT                                     BUG12923
     C                   ELSE                                                               BUG12923
     C                   MOVE      A6MMSD        @@SPOT                                        S0119
     C                   ENDIF                                                              BUG12923
      *                                                                                     BUG12923
     C                   Z-ADD     2             @@PNUM                                        AB014
     C                   MOVE      'M'           @@PTYP                                        AB014
     C                   EXSR      ZA1290                                                      AB014
     C                   Z-ADD     @@PDAT        @@DTIN                                        AB014
     C                   EXSR      ZA0680                                                      AB014
     C     @@MDNO        SUB       1             HRPDM2                                        AB014
     C*                                                                   AB0147
     C** Calculate M3 period date.                                        AB0147
     C*********************MOVE MSPD      @@SPOT                          S01194
      *                                                                                     BUG12923
     C                   IF        A6SPDY = 0                                               BUG12923
     C                   Z-ADD     DSRUNDDT      @@SPOT                                     BUG12923
     C                   ELSE                                                               BUG12923
     C                   MOVE      A6MMSD        @@SPOT                                        S0119
     C                   ENDIF                                                              BUG12923
      *                                                                                     BUG12923
     C                   Z-ADD     3             @@PNUM                                        AB014
     C                   MOVE      'M'           @@PTYP                                        AB014
     C                   EXSR      ZA1290                                                      AB014
     C                   Z-ADD     @@PDAT        @@DTIN                                        AB014
     C                   EXSR      ZA0680                                                      AB014
     C     @@MDNO        SUB       1             HRPDM3                                        AB014
     C*                                                                   AB0147
     C** Calculate number of days in periods.                             AB0147
     C     HRPDTD        SUB       RUND          HRDPTD                                        AB014
     C                   ADD       1             HRDPTD                                        AB014
     C     HRPDD1        SUB       HRPDTD        HRDPD1                                        AB014
     C     HRPDD2        SUB       HRPDD1        HRDPD2                                        AB014
     C     HRPDD3        SUB       HRPDD2        HRDPD3                                        AB014
     C     HRPDD4        SUB       HRPDD3        HRDPD4                                        AB014
     C     HRPDW1        SUB       HRPDD4        HRDPW1                                        AB014
     C     HRPDM1        SUB       HRPDW1        HRDPM1                                        AB014
     C     HRPDM2        SUB       HRPDM1        HRDPM2                                        AB014
     C     HRPDM3        SUB       HRPDM2        HRDPM3                                        AB014
     C*                                                                   AB0147
     C     @COFF2        IFEQ      'Y'                                                         AB014
     C                   WRITE     MMFDUMP0                                                    AB014
     C                   ELSE                                                                  AB014
     C                   WRITE     MMFNRDP0                                                    AB014
     C                   END                                                                   AB014
     C*                                                                   AB0147
     C     #BD9          ENDSR                                                                 AB014
     C*****************************************************************   AB0147
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BB      - Initialise period start date array                 *
     C*                                                               *
     C* CALLS    ZA0680   -  Convert date format to midas day number  *
     C*                                                               *
     C* CALLED BY  BB     -  Main processing                          *
     C*                                                               *
     C* FLDS USED  @S     - Array to hold period start dates          *
     C*            @CCY   - Work field for currency                   *
     C*            @@DTIN - Data structure to hold date               *
     C*            @@MDNO - Work field for number of days in month    *
     C*                                                               *
     C*****************************************************************
     C     #BB           BEGSR
     C*
     C     HRPDTD        SUB       HRDPTD        @S(1)
     C                   ADD       1             @S(1)
     C     HRPDD1        SUB       HRDPD1        @S(2)
     C                   ADD       1             @S(2)
     C     HRPDD2        SUB       HRDPD2        @S(3)
     C                   ADD       1             @S(3)
     C     HRPDD3        SUB       HRDPD3        @S(4)
     C                   ADD       1             @S(4)
     C     HRPDD4        SUB       HRDPD4        @S(5)
     C                   ADD       1             @S(5)
     C     HRPDW1        SUB       HRDPW1        @S(6)
     C                   ADD       1             @S(6)
     C     HRPDM1        SUB       HRDPM1        @S(7)
     C                   ADD       1             @S(7)
     C     HRPDM2        SUB       HRDPM2        @S(8)
     C                   ADD       1             @S(8)
     C     HRPDM3        SUB       HRDPM3        @S(9)
     C                   ADD       1             @S(9)
     C*****                                                               AB0147
     C*****ccess FDCCYTLL to get MM spot date.                            AB0147
     C*****                MOVE *BLANKS   KEY                             AB0147
     C*****                MOVEL'20'      KEY                             AB0147
     C*****                MOVEL@CCY      KEY912  4                       AB0147
     C*****                MOVE '1'       KEY912                          AB0147
     C*****                MOVE KEY912    KEY                             AB0147
     C*****      KEY       CHAINFDCCYTLL             60                   AB0147
     C*****                                                               AB0147
     C*****      *IN60     IFEQ '1'                        B1             AB0147
     C*****                MOVE '003'     DBASE            ***************AB0147
     C*****                MOVEL'FDCCYTLL'DBFILE           *             *AB0147
     C*****                MOVELKEY       DBKEY            * DBERROR 003 *AB0147
     C*****                MOVE '1'       *INU7            *             *AB0147
     C*****                MOVE '1'       *INU8            ***************AB0147
     C*****                GOTO #BB9                       *1             AB0147
     C*****                END                             E1             AB0147
     C                   CALL      'AOCURRR0'                                                  DT019
     C                   PARM      *BLANKS       @RTCD                                         DT019
     C                   PARM      '*KEY   '     @OPTN                                         DT019
     C                   PARM      @CCY          @AJCD                                         DT019
     C     SDCURR        PARM      SDCURR        DSSDY                                         DT019
     C     @RTCD         IFNE      *BLANKS                                                     DT019
     C                   MOVE      '003'         DBASE                          ***************DT019
     C                   MOVEL     'SDCURRPD'    DBFILE                         *             *DT019
     C                   MOVEL     @CCY          DBKEY                          * DBERROR 003 *DT019
     C                   SETON                                        U7U8      *             *DT019
     C                   GOTO      #BB9                                         ***************DT019
     C                   END                                                                   DT019
     C*
     C*********************Z-ADDMSPD      @@DTIN                          S01194
      *                                                                                     BUG12923
     C                   IF        A6SPDY = 0                                               BUG12923
     C                   Z-ADD     DSRUNDDT      @@DTIN                                     BUG12923
     C                   ELSE                                                               BUG12923
     C                   Z-ADD     A6MMSD        @@DTIN                                        S0119
     C                   ENDIF                                                              BUG12923
      *                                                                                     BUG12923
     C                   EXSR      ZA0680
     C                   Z-ADD     @@MDNO        @S(10)
     C*
     C     #BB9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BC      - Update time loans/deposits balances                *
     C*                                                               *
     C* CALLS    #ZB      - Update balance array                      *
     C*          ZA0680   - Convert date formate to midas day number  *
     C*          #ZC      - Update interest accruals array            *
     C*                                                               *
     C* CALLED BY  BB     -  Main processing                          *
     C*                                                               *
     C* FLDS USED  @FLAG  - Work field for update operation           *
     C*            @NDAT  - Work filed for Deal near date             *
     C*            @FDAT  - Work field for far date                   *
     C*            @NDAT5 - Work field for near date                  *
     C*            @SDAT  - Period Start date                         *
     C*            @FDAT5 - Work field for far date                   *
     C*            @EDAT  - Period end date                           *
     C*            @AMNT  - Work field for amount                     *
     C*            @ADSUB - Work field for add or sub operation       *
     C*            @CHG   - Work field to check for changes if AMEND  *
     C*            @@BEG  - Work field for start date                 *
     C*            @@END  - work field for End date                   *
     C*            @ICMT  - Work field for Cal Method                 *
     C*            @@AMT  - Work field for amount                     *
     C*            @INTR  - Work field for interest rate              *
     C*            @BIRT  - Work field for Before int rate            *
     C*            @DMVD  - Work field for deam near date             *
     C*            @@DTIN - Data structure to hold date               *
     C*            @@MDNO - Work field for number of days in month    *
     C*            @DMVD5 - Work field for deam near date             *
     C*            @RATE  - work field for interest rate              *
     C*                                                               *
     C*****************************************************************
     C     #BC           BEGSR
     C*
     C**  Update balances with deal amount.
     C                   Z-ADD     *ZEROS        @FLAG             1 0
     C*
     C     @NDAT         IFNE      *ZEROS                                       B1
     C     @FDAT         ANDNE     *ZEROS                                       X1
     C                   Z-ADD     @NDAT5        @SDAT             5 0          *1
     C     @FDAT5        SUB       1             @EDAT             5 0          *1
     C                   Z-ADD     1             @FLAG                          *1
     C                   END                                                    E1
     C*
     C**  Insert, so add amount.
     C     JULACT        IFEQ      'I'                                          B1
     C     @FLAG         ANDEQ     1                                            X1
     C                   MOVE      '+'           @ADSUB            1            *1
     C                   EXSR      #ZB                                          *1
     C                   END                                                    E1
     C*
     C**  Deletion, so remove amount.
     C     JULACT        IFEQ      'D'                                          B1
     C     @FLAG         ANDEQ     1                                            X1
     C                   MOVE      '-'           @ADSUB                         *1
     C                   EXSR      #ZB                                          *1
     C                   END                                                    E1
     C                   Z-ADD     *ZEROS        @FLAG
     C*
     C**  Update balances with interest due at far date.
     C     @FDAT         IFNE      *ZEROS
     C                   Z-SUB     @AMNP         @AMNT
     C                   Z-ADD     @FDAT5        @SDAT
     C                   Z-ADD     99999         @EDAT
     C                   Z-ADD     1             @FLAG
     C                   END
     C*
     C**  Insert, so add interest due.
     C     JULACT        IFEQ      'I'                                          B1
     C     @FLAG         ANDEQ     1                                            X1
     C                   MOVE      '+'           @ADSUB                         *1
     C                   EXSR      #ZB                                          *1
     C                   END                                                    E1
     C*
     C**  Deletion, so remove interest due.
     C     JULACT        IFEQ      'D'                                          B1
     C     @FLAG         ANDEQ     1                                            X1
     C                   MOVE      '-'           @ADSUB                         *1
     C                   EXSR      #ZB                                          *1
     C                   END                                                    E1
     C*
     C**  Update balances with interest accrued.
     C                   Z-ADD     *ZEROS        @FLAG
     C*
     C     @NDAT         IFNE      *ZEROS                                       B1
     C     @FDAT         ANDNE     *ZEROS                                       X1
     C                   Z-ADD     @NDAT5        @SDAT                          *1
     C                   Z-ADD     @FDAT5        @EDAT
     C                   MOVE      @ICMT         @CALC             1            *1
     C*                                                                   AB0324
     C**  Principal used in interst accrual calc.                         AB0324
     C********             Z-ADD@AMNP     @AMNT            *1             AB0324
     C                   Z-ADD     @AMTSV        @AMNT                          *1             AB032
     C                   Z-ADD     @INTR         @RATE            11 7          *1
     C                   Z-ADD     1             @FLAG                          *1
     C                   END                                                    E1
     C*
     C**  Insert, so add interest accrued.
     C     JULACT        IFEQ      'I'                                          B1
     C     @FLAG         ANDEQ     1                                            X1
     C                   MOVE      '+'           @ADSUB                         *1
     C                   EXSR      #ZC                                          *1
     C                   END                                                    E1
     C*
     C**  Deletion, so remove interest accrued.
     C     JULACT        IFEQ      'D'                                          B1
     C     @FLAG         ANDEQ     1                                            X1
     C                   MOVE      '-'           @ADSUB                         *1
     C                   EXSR      #ZC                                          *1
     C                   END                                                    E1
     C     #BC9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #C       - Termination processing                             *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  MAIN   - Main Line process                         *
     C*                                                               *
     C* FLDS USED  @TERM  - Termination parameter                     *
     C*                                                               *
     C*****************************************************************
     C     #C            BEGSR
     C*
     C**  If termination parameter set to 'T', terminate program.
     C     @TERM         IFEQ      'T'                                          B1
     C                   MOVE      '1'           *INLR                          *1
     C                   GOTO      #C9                                          *1
     C                   END                                                    E1
     C*
     C**  If database error, terminate program.
     C     *INU7         IFEQ      '1'                                          B1
     C                   MOVE      'E'           @TERM                          *1
     C                   MOVE      '1'           *INLR                          *1
     C                   GOTO      #C9                                          *1
     C                   END                                                    E1
     C*
     C**  Return to calling program.
     C                   RETURN
     C*
     C     #C9           ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #ZA      - Calculate number of days in period                 *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  #ZB    - Update balance array                      *
     C*            #ZC    - Update interest accruals array            *
     C*                                                               *
     C* FLDS USED  @P     - Array to hold number of days in period    *
     C*            @DIPA  - number of active days for deal in period  *
     C*            @SDAT  - Period Start date                         *
     C*            @S     - Array to hold period start dates          *
     C*            @WK50  - work field for active days in period      *
     C*            @EDAT  - Period end date                           *
     C*            @E     - Array to hold period end dates            *
     C*****************************************************************
     C     #ZA           BEGSR
     C*
     C**  Initialise with number of days in entire period.
     C                   Z-ADD     @P(X)         @DIPA             3 0
     C*
     C**  If start date after period start date, subtract difference.
     C     @SDAT         IFGT      @S(X)                                        B1
     C     @SDAT         SUB       @S(X)         @WK50             5 0          *1
     C     @DIPA         SUB       @WK50         @DIPA                          *1
     C                   END                                                    E1
     C*
     C**  If end date before period end date, subtract difference.
     C     @EDAT         IFLT      @E(X)                                        B1
     C     @E(X)         SUB       @EDAT         @WK50                          *1
     C     @DIPA         SUB       @WK50         @DIPA                          *1
     C                   END                                                    E1
     C*
     C     #ZA9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #ZB      - Update balance array                               *
     C*                                                               *
     C* CALLS    #ZA      - Calculate number of days in period        *
     C*                                                               *
     C* CALLED BY  #ZD    - Check for change if amendments            *
     C*            #B     - Control main processing                   *
     C*            #BB    - Initialise period start date array        *
     C*            #BC    - Update time loans/deposits balances       *
     C*                                                               *
     C* FLDS USED  @SDAT  - Period Start date                         *
     C*            @E     - Array to hold period end dates            *
     C*            @EDAT  - Period end date                           *
     C*            @S     - Array to hold period start dates          *
     C*            @AMNT  - Work field for amount                     *
     C*            @DIPA  - number of active days for deal in period  *
     C*            @WK150 - Work field for balance                    *
     C*            @P     - Array to hold number of days in period    *
     C*            @ADSUB - Work field for add or sub operation       *
     C*            @A     - Array to hold net balances                *
     C*                                                               *
     C*****************************************************************
     C     #ZB           BEGSR
     C*
     C                   DO        10            X                 3 0          B1
     C*
     C**  If deal active in this period...
     C     @SDAT         IFLE      @E(X)                                        B*2
     C     @EDAT         ANDGE     @S(X)                                        X*2
     C*
     C**  ...calculate number of days active...
     C                   EXSR      #ZA                                          **2
     C*
     C**  ...and update balances array.
     C     @AMNT         MULT      @DIPA         @WK150           15 0          **2
     C     @P(X)         IFGT      0                                                           09975
     C     @WK150        DIV(H)    @P(X)         @WK150                         **2
     C                   ELSE                                                                  09975
     C                   Z-ADD     0             @WK150                                        09975
     C                   END                                                                   09975
     C**  ...reverse the sign before assigning to file                    AB0322
     C                   Z-SUB     @WK150        @WK150                         **2            AB032
     C     @ADSUB        IFEQ      '+'                                          B**3
     C                   ADD       @WK150        @A(X)                          ***3
     C                   ELSE                                                   X**3
     C                   SUB       @WK150        @A(X)                          ***3
     C                   END                                                    E**3
     C*
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     #ZB9          ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #ZC      - Update interest accruals array                     *
     C*                                                               *
     C* CALLS    #ZA      - Calculate number of days in period        *
     C*                                                               *
     C* CALLED BY  #B     - Control main processing                   *
     C*            #BB    - Initialise period start date array        *
     C*            #BC    - Update time loans/deposits balances       *
     C*                                                               *
     C* FLDS USED  @SDAT  - Period Start date                         *
     C*            @E     - Array to hold period end dates            *
     C*            @EDAT  - Period end date                           *
     C*            @S     - Array to hold period start dates          *
     C*            @CALC  - Work field for interest cal method        *
     C*            @DAYS  - Work field for days in year               *
     C*            @AMNT  - Work field for amount                     *
     C*            @RATE  - work field for interest rate              *
     C*            @WK152 - Work field for balance                    *   ME2110
     C*            @DIPA  - number of active days for deal in period  *
     C*            @ADSUB - Work field for add or sub operation       *
     C*            @I     - Array for net Interest accrued            *
     C*                                                               *
     C*****************************************************************
     C     #ZC           BEGSR
     C*
     C                   DO        10            X                              B1
     C*
     C**  If deal active in this period...
     C     @SDAT         IFLE      @E(X)                                        B*2
     C     @EDAT         ANDGT     @S(X)                                        X*2            ME206
     C*
     C**  ...determine divisor dependent on interest calculation method
     C     @CALC         IFEQ      '1'                                          B**3
     C     @CALC         OREQ      '4'                                          X**3
     C                   Z-ADD     365           @DAYS             3 0          ***3
     C                   END                                                    E**3
     C*
     C     @CALC         IFEQ      '2'                                          B**3
     C     @CALC         OREQ      '3'                                          X**3
     C     @CALC         OREQ      '5'                                          X**3
     C                   Z-ADD     360           @DAYS                          ***3
     C                   END                                                    E**3
     C*
     C     @CALC         IFEQ      '6'                                          B**3
     C                   Z-ADD     366           @DAYS                          ***3
     C                   END                                                    E**3
     C*
     C**  ...calculate number of days active...
     C                   EXSR      #ZA                                          **2
     C*
     C**  ...and update balances array.
     C     @AMNT         MULT      @RATE         @WK152           15 2          **2            ME211
     C                   MULT      @DIPA         @WK152                         **2            ME211
     C                   DIV(H)    @DAYS         @WK152                         **2            ME211
     C*********            MULT -1        @WK152           **2            AB0324
     C*
     C     @ADSUB        IFEQ      '+'                                          B**3
     C*                                                                   AB0324
     C                   ADD(H)    @WK152        @I(X)                          ***3           AB032
     C                   ELSE                                                   X**3
     C*                                                                   AB0324
     C                   SUB(H)    @WK152        @I(X)                          ***3           AB032
     C                   END                                                    E**3
     C*
     C                   END                                                    E*2
     C*
     C                   END                                                    E1
     C*
     C     #ZC9          ENDSR
      /EJECT
     C*******************************************************************
     C*
     C* ZA0680 - THIS SUBROUTINE CONVERTS YYYYMMDD FORMAT DATE TO
     C*          MIDAS DAY NUMBER FORMAT (NO. DAYS FROM 31/12/71)
     C*
     C* CALLED BY :
     C*
     C* CALLS :
     C*
     C* INPUT  : @@DTIN DATE (YYYYMMDD) - IN DATA STRUCTURE (SIZE : 8N)
     C*
     C* OUTPUT : @@MDNO MIDAS DAY NUMBER  (SIZE : 5N)
     C*
     C* USES :   @@CC   NUMBER OF CENTURIES IN DATE
     C*          @@DAY  DAY NUMBER
     C*          @@REM  REMAINDER FROM DIVIDE
     C*          @@MTH  MONTH NUMBER
     C*          @MD    COMPILATION TIME ARRAY FOR CUMULATIVE DAYS IN
     C*                 MONTH
     C*          @@WK2  WORK FIELD (2,0)
     C*          @@WK5  WORK FIELD (5,0)
     C*          @@YYYY YEAR (4 CHARACTER)
     C*          @@YY   YEAR (2 CHARACTER)
     C*          @YD    COMPILATION TIME ARRAY FOR CUMULATIVE DAYS IN
     C*                 A FOUR YEAR PERIOD
     C*
     C*******************************************************************
     C*
     C     ZA0680        BEGSR
     C*
     C**  CLEAR OUT ANY 'OLD' DATA IN FIELD
     C                   Z-ADD     0             @@MDNO            5 0
     C*
     C     @@DTIN        CABEQ     0             ZA0689
     C*
     C**   IF DATE GREATER THAN 31/12/2071 NEED EXTRA PROCESSING
     C**   WORK OUT THE NUMBER OF CENTURIES PASSED SINCE 1971,
     C**   BY SUBTRACTING 1972 FROM THE YEAR FIELD.
     C     @@YYYY        IFGE      2072                                         B1
     C     @@YYYY        SUB       1972          @@YYYY                         *1
     C*
     C**   MULTIPLY BY NUMBER OF DAYS IN CENTURY (SINCE 1971)
     C**   THEN RESTORE THE YEAR WHICH WAS INPUT BACK TO THE
     C**   ORIGINAL NEAR BEFORE CONTINUING WITH NORMAL CALCULATIONS.
     C**
     C     @@CC          MULT      36524         @@MDNO                         *1
     C     @@YYYY        ADD       1972          @@YYYY                         *1
     C                   END                                                    E1
     C*
     C     @@YYYY        ADD       28            @@WK2             2 0
     C*
     C     @@WK2         DIV       4             @@WK2
     C                   MVR                     @@REM             1 0
     C*
     C**    MULTIPLY BY NUMBER OF DAYS IN FOUR YEAR PERIOD
     C     @@WK2         MULT      1461          @@WK5             5 0
     C                   ADD       @@WK5         @@MDNO
     C*
     C**  CHECK REMAINDER AND MONTH NUMBER
     C     @@REM         IFEQ      0                                            B1
     C     @@MTH         ANDGT     2                                            B1
     C                   ADD       1             @@MDNO                         *1
     C                   END                                                    E1
     C*
     C**  YEAR NOT LEAP YEAR,  ADD CUMULATIVE DAYS FOR YEAR
     C     @@REM         IFNE      0                                            B1
     C                   ADD       @YD(@@REM)    @@MDNO                         *1
     C                   END                                                    E1
     C*
     C**  ADD MONTHS THIS YEAR
     C                   ADD       @MD(@@MTH)    @@MDNO
     C*
     C**  ADD DAYS THIS MONTH
     C                   ADD       @@DAY         @@MDNO
     C*
     C     ZA0689        ENDSR                                                  **ZA0689 TAG**
     C*****************************************************************
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*       TITLE:CALCULATE MIDAS DAY NO. TO DRS (YYYYMMDD) FORMAT. *
     C*                                                               *
     C*       SUBROUTINE ZA0710 EXPECTS FIELD '@@DAYN' TO BE          *
     C*       PASSED TO IT IN 5,0 FORMAT.IF THE ABOVE FIELD IS LESS   *
     C*       THAN 1 IT RETURNS 1 IN FIELD '@@RTN'.THE MAIN PROGRAM   *
     C*       SHOULD CHECK FOR THIS CONDITION AND DO THE NECESSARY.   *
     C*       IF '@@RTN' IS NOT EQUAL TO 1 IT RETURNS THE FIELD       *
     C*       '@@VDT'  IN 'YYYYMMDD' FORMAT.                          *
     C*                                                               *
     C* NOTE: FIELD TO BE DEFINED BY EXTERNAL ROUTINE IS
     C*                                                               *
     C*       1) @@DAYN   LENGTH 5,0.                                 *
     C*                                                               *
     C*       FIELDS USED AND ALREADY DEFINED IN THE ROUTINE ARE:     *
     C*                                                               *
     C*       1) @@VDT    LENGTH 8,0 DEFINED BY A DS.                 *
     C*       2) @@RTN    LENGTH 1,0.                                 *
     C*       3) @@I      LENGTH 2,0 USED TO ACCESS ARRAY @YD         *
     C*       4) @@J      LENGTH 2,0 USED TO ACCESS ARRAY @MD         *
     C*       5) @@Z71Y   LENGTH 4,0 DEFINED BY A DS.                 *
     C*       6) @@RDAY   LENGTH 5,0.                                 *
     C*       7) @@LEAP   LENGTH 1,0.
     C*                                                               *
     C*       INDICATORS USED ARE:                                    *
     C*                                                               *
     C*       1) 80       CHECK FOR LOW AND EQUAL ON ARRAY @YD        *
     C*       2) 81       CHECK FOR LOW ON ARRAY @MD.                 *
     C*                                                               *
     C* INPUT FIELD:       @@DAYN                                     *
     C*                                                               *
     C* OUTPUT FIELD:      @@VDT                                      *
     C*                                                               *
     C* WORK FIELDS:       @@RTN                                      *
     C*                    @@Z71Y                                     *
     C*                    @@RDAY                                     *
     C*                    @@LEAP                                     *
     C*                    @@I                                        *
     C*                    @@J                                        *
     C*                                                               *
     C* ARRAYS USED:       @YD COMPILE TIME ARRAY.
     C*                    @MD COMPILE TIME ARRAY.
     C*
     C*****************************************************************
     C*
     C     ZA0710        BEGSR
     C*
     C                   SETOFF                                       8081
     C                   Z-ADD     0             @@RTN             1 0
     C                   Z-ADD     0             @@VDT
     C                   Z-ADD     1             @@I               2 0
     C                   Z-ADD     1             @@J               2 0
     C                   Z-ADD     1             @@LEAP            1 0
     C*
     C     @@DAYN        CABEQ     0             ZA0719
     C*
     C     @@DAYN        IFLT      1
     C                   Z-ADD     1             @@RTN
     C                   GOTO      ZA0719
     C                   END
     C*
     C* DIVISION TO DETERMINE WETHER LEAP YEAR.
     C*
     C     @@DAYN        DIV       1461          @@Z71Y
     C                   MVR                     @@RDAY            5 0
     C*
     C* CALCULATING YEAR.
     C*
     C     @@Z71Y        MULT      4             @@Z71Y
     C                   ADD       1972          @@Z71Y
     C*
     C* CHECKING IF YEAR IS GREATER THAN OR EQUAL TO 2100
     C*
     C     @@Z71Y        IFGE      2100
     C                   ADD       @@SSY2        @@RDAY
     C                   END
     C*
     C* LOKUP ARRAY @YD TO SEE HOW MANY YEARS OF A FOUR YEAR CYCLE
     C* HAVE PASSED.
     C*
     C     @@RDAY        LOOKUP    @YD(@@I)                             8080
     C*
     C* IF YEAR IS A LEAP YEAR SSLEAP IS SET TO ZERO.
     C*
     C     *IN80         IFEQ      '0'
     C                   Z-ADD     0             @@LEAP
     C                   END
     C*
     C* ADD INDEX TO YEAR TO GIVE CORRECT YEAR AND ADJUST '@@RDAY'.
     C*
     C     @@LEAP        IFEQ      1
     C     @@RDAY        SUB       @YD(@@I)      @@RDAY
     C                   ADD       @@I           @@Z71Y
     C                   END
     C*
     C* PROCESSING FOR A LEAP YEAR.
     C*
     C     @@LEAP        IFEQ      0
     C*
     C* IF '@@RDAY' = 60 DATE MUST BE 29TH OF FEBRUARY.
     C*
     C     @@RDAY        IFEQ      60
     C                   Z-ADD     29            @@Z71D
     C                   Z-ADD     2             @@Z71M
     C                   GOTO      ZA0711
     C                   END
     C*
     C* IF '@@RDAY' > 60 DATE IS AFTER 29TH OF FEBRUARY,CONVERSION CAN
     C* PROCEED AS USUAL AFTER SUBTRACTING THE EXTRA DAY FOR THE LEAP
     C* YEAR. NOTE : '@@RDAY' < 60 CONVERSION PROCEEDS AS USUAL.
     C*
     C     @@RDAY        IFGT      60
     C     @@RDAY        SUB       1             @@RDAY
     C                   END
     C*
     C                   END
     C*
     C* IF DAY '@@DAYN' IS EXACTLY DIVISIBLE BY 1461 (NUMBER OF DAYS
     C* IN 4 YEARS) THEN DATE MUST BE LAST DAY OF PREVIOUS FOUR YEAR
     C* GROUP.
     C*
     C     @@RDAY        IFEQ      0
     C                   Z-ADD     31            @@Z71D
     C                   Z-ADD     12            @@Z71M
     C                   SUB       1             @@Z71Y
     C                   GOTO      ZA0711
     C                   END
     C*
     C* LOOK UP ARRAY ARRAY @MD TO DETERMINE WHICH MONTH '@@RDAY'
     C* OCCURS IN
     C*
     C     @@RDAY        LOOKUP    @MD(@@J)                             81
     C                   Z-ADD     @@J           @@Z71M
     C     @@RDAY        SUB       @MD(@@J)      @@Z71D
     C*
     C* DS @@VDT  IS RETURNED IN YYYYMMDD FORMAT
     C*
     C     ZA0711        TAG
     C*
     C                   MOVE      @@Z71Y        @@YR
     C*
     C     ZA0719        ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*       TITLE:DETERMINE NEXT WORKING DAY.                       *
     C*                                                               *
     C*       SUBROUTINE ZA0730 EXPECTS FIELD '@@DTIN' TO BE          *
     C*       PASSED TO IT IN 'YYYYMMDD' FORMAT.IT THEN DETERMINES    *
     C*       THE NEXT WORKING DAY AND RETURNS.                       *
     C*                                                               *
     C* INPUT  :@@DTIN DATE (YYYYMMDD) - IN DATA STRUCTURE (SIZE : 8N)*
     C*         @@CCY  CURRENCY CODE   - IN FORMAT(3A)                *
     C*                                                               *
     C* OUTPUT :@@VDT  DATE (YYYYMMDD) - IN DATA STRUCTURE (SIZE : 8N)*
     C*                                                               *
     C* USES :   @@MDNO MIDAS DAY NO USED BY SR ZA0680                *
     C*          @@DAYN MIDAS DAY NO USED BY SR ZA0710                *
     C***********@@MNO  MIDAS DAY NO USED BY SR ZA0830                *   S01195
     C***********@@HIND HOLIDAY IND.RETURNED BY ZA0830                *   S01195
     C*                                                               *
     C*****************************************************************
     C     ZA0730        BEGSR
     C*
     C* CONVERT YYYYMMDD FORMAT TO MIDAS DAY NO.
     C*
     C                   EXSR      ZA0680
     C*
     C     ZA0731        TAG
     C*
     C                   ADD       1             @@MDNO            5 0
     C*
     C* CHECK IF DAY NO. IS A HOLIDAY          .
     C*
     C                   Z-ADD     @@MDNO        @@MNO             5 0
     C*
     C*********************EXSR ZA0830                                    S01195
     C                   Z-ADD     @@MNO         ZDAYNO                                        CAP00
     C                   MOVEL     @@CCY         ZCCY                                          CAP00
     C                   EXSR      ZCHKH                                          <Check H'day>S0119
     C*
     C***********@@HIND****IFEQ 'H'                                       S01195
     C     ZIND          IFEQ      'H'                                          IF HOLIDAY     S0119
     C                   GOTO      ZA0731
     C                   END
     C*
     C* CONVERT MIDAS DAY NO. TO YYYYMMDD FORMAT.
     C*
     C                   Z-ADD     @@MDNO        @@DAYN            5 0
     C*
     C                   EXSR      ZA0710
     C*
     C     ZA0739        ENDSR                                                              **
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*  SUBROUTINE ZA0770 - THIS SUBROUTINE RECEIVES A 8/0 INPUT     *
     C*                      DATE - FORMAT YYYYMMDD AND OUTPUTS A     *
     C*                      6/0 DATE. IF FIELD DATF ON TABTB10 =     *
     C*                      'M' OUTPUT FORMAT MMDDYY. IF FIELD       *
     C*                      DATF = 'D' OUTPUT FORMAT DDMMYY.         *
     C*                                                               *
     C*  CALLED BY   :                                                *
     C*                                                               *
     C*  INPUT       : @@DTIN  - DATE INPUT (8,0)                     *
     C*  OUTPUT      : @@DTOU  - DATE OUTPUT (6,0)                    *
     C*                                                               *
     C*  WORK FIELDS : @@YYY   - YEAR IN (2,0)                        *
     C*              : @@MM    - MONTH IN (2,0)                       *
     C*              : @@DD    - DAY IN (2,0)                         *
     C*                                                               *
     C*              : @@DAT1  - IF DATE DD/MM/YY DAY ELSE MONTH (2,0)*
     C*              : @@DAT2  - IF DATE DD/MM/YY MONTH ELSE DAY (2,0)*
     C*                                                               *
     C*****************************************************************
     C/EJECT
     C     ZA0770        BEGSR
     C*
     C                   Z-ADD     @@YY          @@YYY
     C*
     C**  DATF = 'D' CONVERT TO MMDDYY FORMAT
     C***********DATF******IFEQ 'D'                        B1             S01194
     C     BJDFIN        IFEQ      'D'                                          B1             S0119
     C                   Z-ADD     @@DD          @@DAT1                         *1
     C                   Z-ADD     @@MM          @@DAT2                         *1
     C                   END                                                    E1
     C*
     C*
     C**  DATF = 'M' CONVERT TO MMDDYY FORMAT
     C***********DATF******IFEQ 'M'                        B1             S01194
     C     BJDFIN        IFEQ      'M'                                          B1             S0119
     C                   Z-ADD     @@DD          @@DAT2                         *1
     C                   Z-ADD     @@MM          @@DAT1                         *1
     C                   END                                                    E1
     C*
     C**  MOVE YEAR PART OF DATA STRUCTURE
     C                   MOVE      @@YYY         @@YY
     C*
     C     ZA0779        ENDSR                                                  ***ZA0779***
     C***********************************************************************
      /EJECT
     C***********************************************************************
     C****************                                                    S01195
     C**ZA0830*-*THIS*SUBROUTINE FINDS OUT WHETHER A PARTICULAR DAY       S01195
     C***********IS*A*HOLIDAY IN A PARTICULAR CURRENCY                    S01195
     C****************                                                    S01195
     C**CALLED*BY*:***                                                    S01195
     C****************                                                    S01195
     C**CALLS*:*******                                                    S01195
     C****************                                                    S01195
     C**INPUT**:*@@MNO  MIDAS DAY NUMBER 5N                               S01195
     C***********@@CCY  CURRENCY CODE 3A                                  S01195
     C****************                                                    S01195
     C**OUTPUT*:*@@HIND HOLIDAY/WORKING DAY INDICATOR 1A                  S01195
     C****************                                                    S01195
     C**USES*:***@@MNO  MIDAS DAY NUMBER                                  S01195
     C***********@@CCY  CURRENCY CODE                                     S01195
     C***********@@ONCE FIRST TIME THROUGH INDICATOR                      S01195
     C***********@@CY1  FIRST HALF OF CURRENCY ARRAY                      S01195
     C***********@@CY2  SECOND HALF OF CURRENCY ARRAY                     S01195
     C***********@@MNO6 MIDAS NUMBER WITH TRAILING BLANK                  S01195
     C***********@@HIND HOLIDAY/WORKING DAY INDICATOR                     S01195
     C***********@@INEX INCLUDE/EXCLUDE INDICATOR                         S01195
     C***********                                                         S01195
     C***********INDICATORS                                               S01195
     C***********80 RECORD NOT FOUND                                      S01195
     C***********81 CURRENCY NOT FOUND ON RECORD                          S01195
     C***********                                                         S01195
     C********************************************************************S01195
     C***********ZA0830****BEGSR                                          S01195
     C*********************                                               S01195
     C***OPEN*CURRENCY/HOLIDAY FILE IF FIRST TIME THROUGH                 S01195
     C***********@@ONCE****IFNE 'Y'                        B1             S01195
     C*********************OPEN FDTABJLL                   *1             S01195
     C*********************MOVE 'Y'       @@ONCE  1        *1             S01195
     C*********************END                             E1             S01195
     C*********************                                               S01195
     C***BLANK*OUT*ARRAY***                                               S01195
     C*********************MOVE *BLANKS   @@CY1                           S01195
     C*********************MOVE *BLANKS   @@CY2                           S01195
     C*********************                                               S01195
     C***ACCESS*TABLE*ON*FIRST KEY                                        S01195
     C*********************MOVEL@@MNO     @@MNO6  6                       S01195
     C*********************MOVE @@MNO6    @@0830 12                       S01195
     C*********************MOVEL'22    '  @@0830                          S01195
     C*********************MOVE '1'       @@0830                          S01195
     C***********@@0830****CHAINTABLETJF             80                   S01195
     C*********************                                               S01195
     C***IF*RECORD*NOT*FOUND OR DELETED                                   S01195
     C********** *IN80*****IFEQ '1'                        B1             S01195
     C***********RECI******OREQ '*'                        *1             S01195
     C*********************MOVE 'W'       @@HIND           *1             S01195
     C*********************GOTO ZA0839                     *1             S01195
     C*********************END                             E1             S01195
     C*********************                                               S01195
     C***MOVE*FIRST*25*CURRENCIES TO ARRAY                                S01195
     C*********************MOVE HCCY      @@CY1                           S01195
     C*********************                                               S01195
     C***ACCESS*TABLE*ON*SECOND KEY                                       S01195
     C*********************MOVE '2'       @@0830                          S01195
     C***********@@0830****CHAINTABLETJF             80                   S01195
     C*********************                                               S01195
     C***IF*SECOND*RECORD*FOUND AND NOT DELETED                           S01195
     C********** *IN80*****IFEQ '0'                        B1             S01195
     C***********RECI******ANDNE'*'                        *1             S01195
     C*********************MOVE HCCY      @@CY2            *1             S01195
     C*********************END                             E1             S01195
     C*********************                                               S01195
     C***SEARCH*ARRAY*FOR*INPUT CURRENCY                                  S01195
     C***********@@CCY*****LOKUP@CY                      81               S01195
     C*********************                                               S01195
     C***IF*INPUT*CURRENCY*IS IN ARRAY                                    S01195
     C********** *IN81*****IFEQ '1'                        B1             S01195
     C*********************                                               S01195
     C***IF*INCLUDE/EXCLUDE*INDICATOR EQ 'E'                              S01195
     C***********INEX******IFEQ 'E'                        B*2            S01195
     C*********************MOVE 'W'       @@HIND  1        **2            S01195
     C*********************ELSE                            X*2            S01195
     C*********************MOVE 'H'       @@HIND           **2            S01195
     C*********************END                              *2            S01195
     C*********************END                             E1             S01195
     C*********************                                               S01195
     C***IF*INPUT*CURRENCY*IS NOT IN ARRAY                                S01195
     C********** *IN81*****IFEQ '0'                        B1             S01195
     C*********************                                               S01195
     C***IF*INCLUDE/EXCLUDE*INDICATOR EQ 'I'                              S01195
     C***********INEX******IFEQ 'I'                        B*2            S01195
     C*********************MOVE 'W'       @@HIND           **2            S01195
     C*********************ELSE                            X*2            S01195
     C*********************MOVE 'H'       @@HIND           **2            S01195
     C*********************END                              *2            S01195
     C*********************END                             E1             S01195
     C***********ZA0839****ENDSR                                          S01195
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*   ZA1290 - CALCULATE A PERIOD DATE                            *
     C*                                                               *
     C*   PERIOD DATES ARE CALCULATED FOR THE FOLLOWING PERIODS       *
     C*      PERIOD TYPE       PERIOD NUMBER     PERIOD SHORTNAME     *
     C*           D                 -1             OVERNIGHT          *
     C*           D                  0             TOMORROW / NEXT    *
     C*           D                  1             SPOT / NEXT        *
     C*           W                  1             1 WEEK             *
     C*           W                  2             2 WEEK             *
     C*           W                  3             3 WEEK             *
     C*           M                  1             1 MONTH            *
     C*           M                  2             2 MONTH            *
     C*           M                  3             3 MONTH            *
     C*           M                  6             6 MONTH            *
     C*           M                  9             9 MONTH            *
     C*           Y                  1             1 YEAR             *
     C*                                                               *
     C*  CALLED BY    -                                               *
     C*                                                               *
     C*  AB0280       - UPDATE MMEPOSLL AND MMFNRDLL FILES            *
     C*  AB0290       - UPDATE LIQUIDITY EXPOSURE DETAILS             *
     C*                                                               *
     C*  CALLS        -                                               *
     C*                                                               *
     C*  ZA0770       - CONVERT DATE YYYYMMDD TO DDMMYY               *
     C*  ZA0830       - CHECK IF DAY IS A WORKING DAY                 *
     C*  ZA0730       - FIND NEXT WORKING DAY                         *
     C*  ZA0710       - CONVERT MIDAS DAY NO TO YYYYMMDD              *
     C*  ZA0680       - CONVERT DATE TO MIDAS DAY NUMBER              *
     C*                                                               *
     C*  CALLS PROGRAM ZA0270 CONVERT DATE TO MIDAS DAY NUMBER WITH   *
     C*                VALIDATION CHECK                               *
     C*                                                               *
     C*  FIELDS INPUT -                                               *
     C*                                                               *
     C*  @@CCY   3    - CURRENCY                                      *
     C*  @@SPOT  8,0  - MONEY MARKET SPOT DATE                        *
     C*  @@PNUM  1,0  - PERIOD NUMBER                                 *
     C*  @@PTYP  1    - PERIOD TYPE                                   *
     C*                                                               *
     C*  FIELDS OUTPUT                                                *
     C*                                                               *
     C*  @@PDAT  8,0  - PERIOD DATE                                   *
     C*                                                               *
     C*  WORK FIELDS                                                  *
     C*                                                               *
     C*  @@DTIN  8,0  - DATE INPUT TO ZA0770 IN YYYYMMDD FORMAT       *
     C*  @@DFMT  1    - DATE FORMAT                                   *
     C*  @@RTNC  1    - RETURN INDICATOR FROM ZA0270                  *
     C*  @@DAYN  5,0  - MIDAS DAY NUMBER                              *
     C*  @@MNO   5,0  - MIDAS DAY NUMBER                              *
     C*  @@HIND  1    - HOLIDAY INDICATOR H OR W                      *
     C*  @@ADD   3,0  - CALCULATION WORK FIELD                        *
     C*  @@VDT   8,0  - DATE OUTPUT FROM ZA0710                       *
     C*  @@RUND  8    - RUN DATE IN YYYYMMDD FORMAT                   *
     C*                                                               *
     C*****************************************************************
     C*
     C     ZA1290        BEGSR
     C*
     C                   Z-ADD     *ZERO         @@STRT
     C                   Z-ADD     *ZERO         @@DTIN
     C                   Z-ADD     *ZERO         @@SPDD
     C                   Z-ADD     *ZERO         @@DATE
     C                   Z-ADD     *ZERO         @@DTOU
     C                   Z-ADD     *ZERO         @@Z71Y
     C                   Z-ADD     *ZERO         @@VDT
     C*
     C                   ADD       @@SPOT        @@SPDD
     C**  SET UP STARTING POINT DATE AS SPOT DATE
     C                   Z-ADD     @@SPDD        @@STRT
     C*
     C**  ADD PERIOD NUMBERS TO DATE
     C     @@PTYP        IFEQ      'M'                                          B1
     C                   ADD       @@PNUM        @@STMT                         *1
     C     @@STMT        IFGT      12                                           B*2
     C                   SUB       12            @@STMT                         **2
     C                   ADD       1             @@STYR                         **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C*
     C     @@PTYP        IFEQ      'Y'                                          B1
     C                   ADD       1             @@STYR                         *1
     C                   END                                                    E1
     C*
     C**  CONVERT DATE FORMAT FROM YYYYMMDD TO DDMMYY
     C                   Z-ADD     @@STRT        @@DTIN
     C                   EXSR      ZA0770
     C                   Z-ADD     @@DTOU        @@DATE
     C*
     C*
     C                   MOVEL     'D'           @@DFMT            1
     C                   MOVE      @@DATE        @@DATC            6 0
     C*
     C**  CONVERT STARTING DATE TO MIDAS DAY NUMBER FORMAT
     C     @@RTNC        DOUEQ     '0'                                          B1
     C                   CALL      'ZA0270'                                     *1
     C                   PARM                    @@DATC                         *1
     C*********************PARM           DATF             *1             S01194
     C                   PARM                    BJDFIN                         *1             S0119
     C     @@RTNC        PARM                    @@RTNC            1            *1
     C     @@DAYN        PARM                    @@DAYN            5 0          *1
     C*
     C                   SUB       1             @@DAY2                         *1
     C                   MOVE      @@DATE        @@DATC                         *1
     C*
     C                   END                                                    E1
     C*
     C                   Z-ADD     @@DAYN        @@MNO
     C                   MOVEL     @@RTNC        @@RTN
     C*
     C**  RESET STARTING POINT
     C                   EXSR      ZA0710
     C                   Z-ADD     @@VDT         @@STRT
     C*
     C**  PROCESS PERIOD TYPE 'W'
     C     @@PTYP        IFEQ      'W'                                          B1
     C*
     C**  INCREMENT DAY NUMBER
     C     @@PNUM        MULT      7             @@ADD             3 0          *1
     C                   ADD       @@ADD         @@MNO                          *1
     C*
     C**  FIND NEXT WORKING DAY
     C*********************EXSR ZA0830                       <Check H'day>S01195
     C                   Z-ADD     @@MNO         ZDAYNO                                        CAP00
     C                   MOVEL     @@CCY         ZCCY                                          CAP00
     C                   EXSR      ZCHKH                                          <Check H'day>S0119
     C***********@@HIND****DOWEQ'H'                        IF HOLIDAY     S01195
     C     ZIND          DOWEQ     'H'                                          IF HOLIDAY     S0119
     C                   ADD       1             @@MNO                          **2
     C*********************EXSR ZA0830                       <Check H'day>S01195
     C                   Z-ADD     @@MNO         ZDAYNO                                        CAP00
     C                   MOVEL     @@CCY         ZCCY                                          CAP00
     C                   EXSR      ZCHKH                                          <Check H'day>S0119
     C                   END                                                    E*2
     C                   END                                                    E1
     C*
     C**  PROCESS PERIOD TYPE 'M' OR 'Y'
     C     @@PTYP        IFEQ      'M'                                          B1
     C     @@PTYP        OREQ      'Y'                                          *1
     C*
     C**  IS SPOT LAST WORKING DAY IN MONTH
     C                   Z-ADD     @@SPDD        @@DTIN                         *1
     C                   EXSR      ZA0730                                       *1
     C     @@SPMT        IFNE      @@Z71M                                       B*2
     C                   Z-ADD     1             @@STDY                         **2
     C     @@STMT        IFEQ      12                                           B**3
     C                   Z-ADD     1             @@STMT                         ***3
     C                   ADD       1             @@STYR                         ***3
     C                   ELSE                                                   X**3
     C                   ADD       1             @@STMT                         ***3
     C                   END                                                    E**3
     C*
     C**  CONVERT STARTING DATE TO MIDAS DAY NUMBER FORMAT
     C                   Z-ADD     @@STRT        @@DTIN                         **2
     C                   EXSR      ZA0680                                       **2
     C                   Z-ADD     @@MDNO        @@MNO                          **2
     C***********@@HIND****DOUEQ'W'                        B**3           S01195
     C     ZIND          DOUEQ     'W'                                          B**3           S0119
     C                   SUB       1             @@MNO                          ***3
     C*********************EXSR ZA0830                     ***3           S01195
     C                   Z-ADD     @@MNO         ZDAYNO                                        CAP00
     C                   MOVEL     @@CCY         ZCCY                                          CAP00
     C                   EXSR      ZCHKH                                        ***3           S0119
     C                   END                                                    E**3
     C                   GOTO      Z12908                                       **2
     C                   END                                                    E*2
     C*
     C**  IF THE STARTING POINT DAY IS A NON WORKING DAY AND THE NEXT
     C**  WORKING DAY FALLS IN THE NEXT MONTH  FIND LAST WORKING DAY
     C**  IN STARTING MONTH.
     C                   Z-ADD     @@STRT        @@DTIN                         *1
     C                   EXSR      ZA0680                                       *1
     C                   Z-ADD     @@MDNO        @@MNO                          *1
     C*********************EXSR ZA0830                     *1             S01195
     C                   Z-ADD     @@MNO         ZDAYNO                                        CAP00
     C                   MOVEL     @@CCY         ZCCY                                          CAP00
     C                   EXSR      ZCHKH                                        *1             S0119
     C***********@@HIND****IFEQ 'H'                        B*2            S01195
     C     ZIND          IFEQ      'H'                                          B*2            S0119
     C                   Z-ADD     @@STRT        @@DTIN                         **2
     C                   EXSR      ZA0730                                       **2
     C*
     C     @@STMT        IFNE      @@Z71M                                       B**3
     C***********@@HIND****DOUEQ'W'                        B***4          S01195
     C     ZIND          DOUEQ     'W'                                          B***4          S0119
     C                   SUB       1             @@MNO                          ****4
     C*********************EXSR ZA0830                       <Check H'day>S01195
     C                   Z-ADD     @@MNO         ZDAYNO                                        CAP00
     C                   MOVEL     @@CCY         ZCCY                                          CAP00
     C                   EXSR      ZCHKH                                          <Check H'day>S0119
     C                   END                                                    E***4
     C                   END                                                    E**3
     C                   GOTO      Z12908                                       ***3
     C                   END                                                    E*2
     C*
     C**  IF STARTING DATE IS A WORKING DAY IN CURRENCY & SPOT DATE
     C**  IS NOT LAST WORKING DAY IN MONTH PERIOD DATE IS STARTING DAY
     C                   Z-ADD     @@STRT        @@PDAT                         *1
     C                   GOTO      Z12909                                       *1
     C*
     C                   END                                                    E1
     C*
     C     Z12908        TAG
     C*
     C**  CONVERT DATE TO YYYYMMDD FORMAT
     C                   Z-ADD     @@MNO         @@DAYN
     C                   EXSR      ZA0710
     C                   Z-ADD     @@VDT         @@PDAT            8 0
     C*
     C                   GOTO      Z12909
     C                   ADD       0             @@SPOT            8 0
     C                   MOVE      *BLANKS       @@CCY             3
     C                   ADD       0             @@PNUM            1 0
     C                   MOVE      *BLANKS       @@PTYP            1
     C*
     C     Z12909        ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* *PSSR    - Program error handling subroutine                  *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY         -                                           *
     C*                                                               *
     C* FLDS USED  @ERR1  - Work field for error to prevent looping   *
     C*            @TERM  - Termination parameter                     *
     C*                                                               *
     C*****************************************************************
     C     *PSSR         BEGSR
     C*
     C** SET @ERR1 TO 'Y' TO PREVENT LOOPING IF FURTHER ERRORS
     C     @ERR1         IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @ERR1             1            *1
     C                   MOVE      '1'           *INU6                          *1
     C*                                                    *1
     C** SET UP FIELDS IN LOCAL DATA AREA                  *1
     C                   MOVEL     'AB0280'      DBPGM                          *1
     C                   MOVE      '991'         DBASE                          *1
     C*                                                    *1
     C** DUMP THE PROGRAM                                  *1
     C                   DUMP                                                   *1
     C                   MOVE      'E'           @TERM
     C                   END                                                    E1
     C*
     C** TERMINATE THE PROGRAM
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C*
     C                   ENDSR
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* INFSR    - File Exception/error subroutine                    *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY         -                                           *
     C*                                                               *
     C* FLDS USED  @ERR2  - Work field for error 2                    *
     C*            @FILE  - Work field for file processed             *
     C*            @TERM  - Termination parameter                     *
     C*                                                               *
     C*****************************************************************
     C     INFSR         BEGSR
     C*
     C** SET @ERR2 TO 'Y' TO PREVENT LOOPING IF FURTHER ERRORS
     C     @ERR2         IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @ERR2             1            *1
     C                   MOVE      '1'           *INU7                          *1
     C                   MOVE      '1'           *INU8                          *1
     C*                                                    *1
     C** SET UP FIELDS IN LOCAL DATA AREA                  *1
     C                   MOVEL     @FILE         DBFILE                         *1
     C                   MOVE      '992'         DBASE                          *1
     C*                                                    *1
     C** DUMP THE PROGRAM                                  *1
     C                   DUMP                                                   *1
     C                   MOVE      'E'           @TERM
     C                   END                                                    E1
     C*
     C** TERMINATE THE PROGRAM
     C                   MOVE      '1'           *INLR
     C                   RETURN
     C*
     C                   ENDSR
     C*
     C*****************************************************************
      /EJECT                                                                                BUG12923
      *****************************************************************                     BUG12923
     C     SRRUNDAT      BEGSR                                                              BUG12923
      *                                                                                     BUG12923
      ** Move proper rundate values to field                                                BUG12923
      *                                                                                     BUG12923
     C                   MOVEL     BJMRDT        DSMGRDT                                    BUG12923
     C                   Z-ADD     DSMGRDD       DSRUNDDD                                   BUG12923
      *                                                                                     BUG12923
     C                   SELECT                                                             BUG12923
     C                   WHEN      DSMGRMMA = DSCNJAN                                       BUG12923
     C                   Z-ADD     1             DSRUNDMM                                   BUG12923
     C                   WHEN      DSMGRMMA = DSCNFEB                                       BUG12923
     C                   Z-ADD     2             DSRUNDMM                                   BUG12923
     C                   WHEN      DSMGRMMA = DSCNMAR                                       BUG12923
     C                   Z-ADD     3             DSRUNDMM                                   BUG12923
     C                   WHEN      DSMGRMMA = DSCNAPR                                       BUG12923
     C                   Z-ADD     4             DSRUNDMM                                   BUG12923
     C                   WHEN      DSMGRMMA = DSCNMAY                                       BUG12923
     C                   Z-ADD     5             DSRUNDMM                                   BUG12923
     C                   WHEN      DSMGRMMA = DSCNJUN                                       BUG12923
     C                   Z-ADD     6             DSRUNDMM                                   BUG12923
     C                   WHEN      DSMGRMMA = DSCNJUL                                       BUG12923
     C                   Z-ADD     7             DSRUNDMM                                   BUG12923
     C                   WHEN      DSMGRMMA = DSCNAUG                                       BUG12923
     C                   Z-ADD     8             DSRUNDMM                                   BUG12923
     C                   WHEN      DSMGRMMA = DSCNSEP                                       BUG12923
     C                   Z-ADD     9             DSRUNDMM                                   BUG12923
     C                   WHEN      DSMGRMMA = DSCNOCT                                       BUG12923
     C                   Z-ADD     10            DSRUNDMM                                   BUG12923
     C                   WHEN      DSMGRMMA = DSCNNOV                                       BUG12923
     C                   Z-ADD     11            DSRUNDMM                                   BUG12923
     C                   WHEN      DSMGRMMA = DSCNDEC                                       BUG12923
     C                   Z-ADD     12            DSRUNDMM                                   BUG12923
     C                   ENDSL                                                              BUG12923
      *                                                                                     BUG12923
      ** Move cc to ccyy                                                                    BUG12923
      *                                                                                     BUG12923
     C                   IF        DSMGRYY > 40                                             BUG12923
     C                   Z-ADD     19            DSRUNDCC                                   BUG12923
     C                   Z-ADD     DSMGRYY       DSRUNDYY                                   BUG12923
     C                   ELSE                                                               BUG12923
     C                   Z-ADD     20            DSRUNDCC                                   BUG12923
     C                   Z-ADD     DSMGRYY       DSRUNDYY                                   BUG12923
     C                   ENDIF                                                              BUG12923
      *                                                                                     BUG12923
     C                   ENDSR                                                              BUG12923
      *****************************************************************                     BUG12923
      /EJECT                                                                                BUG12923
      *****************************************************************                     BUG12923
      *
      ***PY ZSRSRC,ZACCH                                                  S01195CAP084
      *
      ***PY ZSRSRC,ZCHKH                                                  S01195CAP084
      /COPY ZSRSRC,ZACCHLE                                                      CAP084
      *                                                                         CAP084
      /COPY ZSRSRC,ZCHKHLE                                                      CAP084
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA @YD
00366007310109601461
**CTDATA @MD
00000000310005900090001200015100181002120024300273003040033400365
**CTDATA @CMD
OVRDBF  MMEDUMLL   MMEPOULL                                               MMCOFF
OVRDBF  MMFDUMLL   MMFNRULL                                               MMCOFF
