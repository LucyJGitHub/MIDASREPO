     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*XBI *  OVRDBF MMFDUMLL MMFLQULL                                     *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Update liquidity exposures file')
     F*****************************************************************
     F*                                                               *
     F*  Midas  -  Internal Contracts & Arbitrage Dealing
     F*                                                               *
     F*    AB0290 - Update Liquidity Exposures file                   *
     F*                                                               *
     F*   Function:   This program rebuilds the Money Market liquidity*
     F*   (I/C)       file (MMFLIQPP) during I/C initiation and I/C.  *
     F*   (I/C INIT)                                                  *
     F*                                                               *
     F*     Called by: AB0330  - AB Back office Internal Contracts    *
     F*                          maintenance.              (I/C)      *
     F*                AB8010  - AB Daily deals update and start of   *
     F*                          day reorganisation.       (I/C INIT) *
     F*                                                               *
     F*     Calls    : ZA0270  - Convert date to Midas day number.    *
     F*                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
     F*                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Last Amend No. 240334             Date 17Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CAP084             Date 06Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP004             Date 08Sep98               *
      *                 CAC001             Date 01Feb96               *
     F*                 E20774             Date 15Mar90               *
     F*                 S01117             Date 31Jan90               *
     F*                  S01194             Date 31JAN90              *
     F*                  S01195             Date 31JAN90              *
     F*                  E17063             DATE 05/05/89             *
     F*                  AB0150             DATE 12/04/88             *
     F*                  AB0151             DATE 12/04/88             *
     F*                  AB0074             DATE 02/02/88             *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
      *  240334 - Recompile over changes in ZACCHLE.                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAP084 - Convert to ILE.                                     *
     F*  CAP004 - API's Phase 3.                                      *
     F*  CAC001 - Profit Centre Accounting Development:               *
     F*           Recompiled only.                                    *
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
     F*  AB0150 - MUST REMOVE KIGNORES CAN SCREW UP OTHER PGMS        *
     F*                                                               *
     F*  AB0151 - ARRAY INDEX X NOT INITIALISED                       *
     F*                                                               *
     F*  AB0074 - ONLY PROCESS LAST PARM IF IT IS PASSED              *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  CREATION PARAMETERS                                          *
     F*                                                               *
*****F** SNPDUMP(*NONE) CODELIST(*NONE) IGNDECERR(*NO)              : *   E17063
     F*                                                               *
     F*****************************************************************
      *                                                              *
      *   Special Note: To Compile this program                      *
      *                                                              *
      *                 OVRDBF    MMFDUMLL    MMFLQULL               *
      *                                                              *
     F****************************************************************
     F* ID F  C  H  L    FUNCTION OF INDICATORS
     F*       60         Chain to currency file failed
     F*       63         No record for currency on liquidities file
     F*       80         Chain to installation file failed
     F*       81         Input currency is in the array
     F*       U6         Program exception/error condition has occurred
     F*       U7         Set on with U8 to signify file handling error.
     F*       U8         Set on with U7 to signify file handling error.
     F*FDICDRLLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
     F************TABTB20F                          KIGNORE               AB0150
     F*FDTABJLLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
     F*FDCCYTLLIF*E***********K        DISK         KINFSR INFSR      UC  S01194
     FMMFLQULL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     COMMIT
     FMMFDUMLL  UF A E           K DISK    INFSR(INFSR)
     F                                     USROPN
     F                                     RENAME(MMFLIQP0:MMFDUMP0)
     D*
     D**  ARRAY TO HOLD COPYRIGHT STATEMENT
     D*
     D**  USED BY SR. ZA0830 - CURRENCY RECORDS
     D*
     D**  ARRAY FOR SR. ZA0710 - CUMULATIVE DAYS IN YEAR FOR 4 YEAR PERIOD
     D @YD             S              5  0 DIM(4) CTDATA PERRCD(4) ASCEND
     D*
     D**  ARRAY FOR SR. ZA0710 - CUMULATIVE DAYS IN YEAR PER MONTH
     D @MD             S              5  0 DIM(13) CTDATA PERRCD(13) ASCEND
     D*
     D**  ARRAY OF PERIOD DATES CALCULATED
     D @PR             S              5  0 DIM(10)
     D*
     D**  ARRAY OF LIQUIDITY VALUES FROM FILE
     D @L1             S             15  0 DIM(10)
     D @L2             S             15  0 DIM(9)
     D @L3             S             15  0 DIM(10)
     D***Command*used*on*call*to*QCAEXEC                                  E20774
     D** Command used on call to QCMDEXC                                  E20774
     D @CMD            S             30    DIM(1) CTDATA PERRCD(1)
     D*
     D @CPYRT          DS
     D*
     D**  DATA STRUCTURE FOR COMPILATION - COPYRIGHT INSERTION
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
     D*
     D**  DATA STRUCTURE FOR SR. ZA0710 - FIELD IS @@Z71Y
     D @Z71Y           DS
     D  @@Z71Y                 1      4  0
     D  @@SSY1                 1      1  0
     D  @@SSY2                 2      2  0
     D  @@SSY3                 3      3  0
     D  @@SSY4                 4      4  0
     D*
     D**  DATA STRUCTURE FOR SR. ZA0710 - FIELD IS @@VDT
     D @VDT            DS
     D  @@VDT                  1      8  0
     D  @@YR                   1      4  0
     D  @@Z71M                 5      6  0
     D  @@Z71D                 7      8  0
     D*
     D**  USED BY SR. ZA0830 - ARRAY DATA STRUCTURE
     D**  DATA STRUCTURE FOR SR. ZA0680 - DATE INPUT TO SUBROUTINE
     D @CURR           DS
     D  @CY                    1    150
     D                                     DIM(50)
     D  @@CY1                  1     75
     D  @@CY2                 76    150
     D*
     D**  DATASTRUCTURE FOR DATE IN TO CHANGE FORMAT
     D @DTIN           DS
     D  @@DTIN                 1      8  0
     D  @@YYYY                 1      4  0
     D  @@YY                   3      4  0
     D  @@YYY                  3      4  0
     D  @@MM                   5      6  0
     D  @@CC                   1      2  0
     D  @@MTH                  5      6  0
     D  @@DAY                  7      8  0
     D  @@DD                   7      8  0
     D*
     D**  DATASTRUCTURE TO CHANGE FORMAT TO MMDDYY / DDMMYY
     D @DTOU           DS
     D  @@DTOU                 1      6  0
     D  @@DAT1                 1      2  0
     D  @@DAT2                 3      4  0
     D  @@YYYO                 5      6  0
     D*
     D*
     D**  DATA STRUCTURE HOLDING STARTING POINT DATE
     D @STRT           DS
     D  @@STRT                 1      8  0
     D  @@STYR                 1      4  0
     D  @@STMT                 5      6  0
     D  @@STDY                 7      8  0
     D*
     D**  DATA STRUCTURE HOLDING SPOT DATE
     D @SPDD           DS
     D  @@SPDD                 1      8  0
     D  @@SPYR                 1      4  0
     D  @@SPMT                 5      6  0
     D  @@SPDY                 7      8  0
     D*
     D**  DATA STRUCTURE DAYS FOR DATE FORMAT DDMMYY
     D @DATE           DS
     D  @@DATE                 1      6  0
     D  @@DAY2                 1      2  0
     D*
     D***Key*to*access*currencies*file*FDCCYTLL                           S01194
     D*@CKEY******DS                                                      S01194
     D****************************************1  12 @KEY                  S01194
     D****************************************9  11 @CUR                  S01194
     D*
     D** Split input run date.
     D @RUNA           DS
     D  RUNA                   1      7
     D  @DLUP                  1      2  0
     D  @MLUP                  3      5
     D  @YLUP                  6      7  0
     D*
     D** Combine input maturity date fields
     D @MDAT           DS
     D  @MATD                  1      8  0
     D  I@MDYY                 1      4  0
     D  I@MD                   5      6  0
     D  I@MDDD                 7      8  0
     D*
     D** Combine input value date fields
     D @VDAT           DS
     D  @START                 1      8  0
     D  I@VDYY                 1      4  0
     D  I@VDMM                 5      6  0
     D  I@VDDD                 7      8  0
     D*
     D** Combine input interest date fields
     D @IDAT           DS
     D  @SLINT                 1      8  0
     D  I@SLYY                 1      4  0
     D  I@SLMM                 5      6  0
     D  I@SLDD                 7      8  0
     D*
     D** Combine input next interest date fields
     D @NXID           DS
     D  @NXINT                 1      8  0
     D  I@NIYY                 1      4  0
     D  I@NIMM                 5      6  0
     D  I@NIDD                 7      8  0
     D*
     D** Combine input deal done date fields
     D @IDLDT          DS
     D  @DEALD                 1      8  0
     D  I@DDYY                 1      4  0
     D  I@DDMM                 5      6  0
     D  I@DDDD                 7      8  0
     D*
     D** Combine related deal done date fields
     D @RDLDT          DS
     D  @DEALR                 1      8  0
     D  HKDDYY                 1      4  0
     D  HKDDMM                 5      6  0
     D  HKDDDD                 7      8  0
     D*
     D**  Data structure with the format of the Standard Deals file.
     D @STDD         E DS                  EXTNAME(ABSTDDPP)
     D*
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    S01194
      ** BANK DETAILS ACCESSED VIA ACCESS PROGRAM                         S01194
     D  RUND                  34     36P 0                                      S01194
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    S01194
      ** CURRENCY DETAILS ACCESSED VIA ACCESS PROGRAM                     S01194
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)                       S01194
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE                S01194
     D*                                                                   S01117
     D DSSDY         E DS                  EXTNAME(DSSDY)                       S01194
     D* SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE                S01194
     D*
     D*
     D PSDS           SDS
     D*
     D  @NOPMS                37     39  0
     D**  Program status data structure.
     D**  Field containing program in use.
     D  @FILE                201    208
     D**  Field containing workstation  ID.
     D  @JOB                 244    253
     D**  Field containing user ID.
     D  @USER                254    263
     D*
     D                UDS
     D**  Local data area for data base errors.
     D**  Field containing name of database file in error.
     D  DBFILE               134    141
     D**  Field containing key value causing database error.
     D  DBKEY                142    170
     D**  Field containing name of program causing database error.
     D  DBPGM                171    180
     D**  Field containing number of database error.
     D  DBASE                181    183
      *
      /COPY ZSRSRC,ZHOLILE                                                S01195
      *                                                                   S01195
     I/EJECT
      *
      /COPY ZSRSRC,ZHOLELE                                                S01195
     I*
     I** Load liquidities array by renaming fields
     IMMFLIQP0
     I*
     I              HQLTCE                      @L1(1)
     I              HQLTD1                      @L1(2)
     I              HQLTD2                      @L1(3)
     I              HQLTD3                      @L1(4)
     I              HQLTD4                      @L1(5)
     I              HQLTW1                      @L1(6)
     I              HQLTM1                      @L1(7)
     I              HQLTM2                      @L1(8)
     I              HQLTM3                      @L1(9)
     I              HQLTRM                      @L1(10)
     I*
     I              HQLPCE                      @L3(1)
     I              HQLPD1                      @L3(2)
     I              HQLPD2                      @L3(3)
     I              HQLPD3                      @L3(4)
     I              HQLPD4                      @L3(5)
     I              HQLPW1                      @L3(6)
     I              HQLPM1                      @L3(7)
     I              HQLPM2                      @L3(8)
     I              HQLPM3                      @L3(9)
     I              HQLPRM                      @L3(10)
     I*
     I              HQCFIX                      @L2(1)
     I              HQFXD1                      @L2(2)
     I              HQFXD2                      @L2(3)
     I              HQFXD3                      @L2(4)
     I              HQFXD4                      @L2(5)
     I              HQFXW1                      @L2(6)
     I              HQFXM1                      @L2(7)
     I              HQFXM2                      @L2(8)
     I              HQFXM3                      @L2(9)
     I*
     I              HQPDTD                      @PR(1)
     I              HQPDD1                      @PR(2)
     I              HQPDD2                      @PR(3)
     I              HQPDD3                      @PR(4)
     I              HQPDD4                      @PR(5)
     I              HQPDW1                      @PR(6)
     I              HQPDM1                      @PR(7)
     I              HQPDM2                      @PR(8)
     I              HQPDM3                      @PR(9)
     IMMFDUMP0
     I*
     I              HQLTCE                      @L1(1)
     I              HQLTD1                      @L1(2)
     I              HQLTD2                      @L1(3)
     I              HQLTD3                      @L1(4)
     I              HQLTD4                      @L1(5)
     I              HQLTW1                      @L1(6)
     I              HQLTM1                      @L1(7)
     I              HQLTM2                      @L1(8)
     I              HQLTM3                      @L1(9)
     I              HQLTRM                      @L1(10)
     I*
     I              HQLPCE                      @L3(1)
     I              HQLPD1                      @L3(2)
     I              HQLPD2                      @L3(3)
     I              HQLPD3                      @L3(4)
     I              HQLPD4                      @L3(5)
     I              HQLPW1                      @L3(6)
     I              HQLPM1                      @L3(7)
     I              HQLPM2                      @L3(8)
     I              HQLPM3                      @L3(9)
     I              HQLPRM                      @L3(10)
     I*
     I              HQCFIX                      @L2(1)
     I              HQFXD1                      @L2(2)
     I              HQFXD2                      @L2(3)
     I              HQFXD3                      @L2(4)
     I              HQFXD4                      @L2(5)
     I              HQFXW1                      @L2(6)
     I              HQFXM1                      @L2(7)
     I              HQFXM2                      @L2(8)
     I              HQFXM3                      @L2(9)
     I*
     I              HQPDTD                      @PR(1)
     I              HQPDD1                      @PR(2)
     I              HQPDD2                      @PR(3)
     I              HQPDD3                      @PR(4)
     I              HQPDD4                      @PR(5)
     I              HQPDW1                      @PR(6)
     I              HQPDM1                      @PR(7)
     I              HQPDM2                      @PR(8)
     I              HQPDM3                      @PR(9)
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN     - Controls processing                                *
     C*                                                               *
     C* CALLS    #A       - Initial processing                        *
     C*          #B       - Main processing                           *
     C*          #C       - Final processing                          *
     C*                                                               *
     C* CALLED BY         -                                           *
     C*                                                               *
     C* FLDS USED  @TERM  - Termination parameter                     *
     C*                                                               *
     C*****************************************************************
     C*
     C     @TERM         IFNE      'T'                                          B1
     C                   EXSR      #A                                           *1
     C                   END                                                    E1
     C*
     C     @TERM         IFNE      'T'                                          B1
     C     @TERM         ANDNE     'E'                                          *1
     C     *INU7         ANDNE     '1'                                          *1
     C                   MOVE      JUDFCY        @CCY              3            *1
     C                   MOVE      JUNDA1        @NDA             15 0          *1
     C                   MOVE      JUFDA1        @FDA             15 0          *1
     C                   EXSR      #B                                           *1
     C     *INU7         IFNE      '1'                                          B2
     C                   MOVE      JUDSCY        @CCY                           *2
     C                   MOVE      JUNDA2        @NDA                           *2
     C                   MOVE      JUFDA2        @FDA                           *2
     C                   EXSR      #B                                           *2
     C                   END                                                    E2
     C                   END                                                    E1
     C*
     C                   EXSR      #C
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C* SUBROUTINES USED                                              *
     C*                                                               *
     C*  01  #B       - Main processing                               *
     C*  02  #BA      - Load period dates array                       *
     C*  03  #BB      - Calculate liquidity exp fixed                 *
     C***04**ZA0830***-*Find if a day is a holiday for a currency     *   S01195
     C*  05  ZA0730   - Determine next working day                    *
     C*  06  ZA1290   - Calculate a period date                       *
     C*  07  ZA0770   - Convert an 8 0 date to 6 0 format             *
     C*  08  ZA0680   - Convert YYYYMMDD to a midas day number        *
     C*  09  ZA0710   - Convert midas day no. to YYYYMMDD format      *
     C*  10  #A       - Initial processing                            *
     C*  11  #C       - Final processing                              *
     C*  12  ZA0150   - Access installation file                      *
     C*  13  INFSR    - Unmonitored file error                        *
     C*  14  *PSSR    - Unmonitored program error                     *
     C*                                                               *
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #B       - Main processing                                    *
     C*                                                               *
     C* CALLS    #BA      - Load period dates array                   *
     C*                                                               *
     C* CALLED BY  MAIN   - Controls program                          *
     C*                                                               *
     C* FLDS USED  @COFF2 - Commitment control ON/OFF field           *
     C*            @CCY   - Currency                                  *
     C*            @DLUP  - Day of last update                        *
     C*            @MLUP  - Month of last update                      *
     C*            @YLUP  - Year of last update                       *
     C*            @USER  - User i.d.                                 *
     C*                                                               *
     C*****************************************************************
     C     #B            BEGSR
     C*
     C**********************************
     C* Access & update liquidity file *
     C**********************************
     C*
     C** Access liquidity file for currency
     C     @COFF2        IFEQ      'Y'
     C     @CCY          CHAIN     MMFDUMLL                           63
     C                   ELSE
     C     @CCY          CHAIN     MMFLQULL                           63
     C                   END
     C*
     C     *IN63         IFEQ      '1'                                          B1
     C     HQDLTF        OREQ      '*'                                          *1
     C*
     C** If record does not exist for currency then add a record
     C                   MOVE      @CCY          HQCCY                          *1          ***
     C                   MOVE      'HQ'          HQRCID                         *1
     C                   MOVE      ' '           HQDLTF                         *1
     C*
     C**  Set date of last update to zeroes to ensure that period dates
     C**  will be calculated
     C                   Z-ADD     0             HQDLUP                         *1
     C                   MOVE      *BLANKS       HQMLUP                         *1
     C                   Z-ADD     0             HQYLUP                         *1
     C                   Z-ADD     0             HQTLUP                         *1
     C                   MOVE      'I'           HQCHTP                         *1
     C                   Z-ADD     0             @L1                            *1
     C                   Z-ADD     0             @L2                            *1
     C                   Z-ADD     0             @L3                            *1
     C                   Z-ADD     0             @PR                            *1
     C                   ELSE                                                   X1
     C                   MOVE      'A'           HQCHTP                         *1
     C                   END                                                    E1
     C*
     C** If period dates for this currency have not yet been calculated
     C** today then calculate them & load into the liquidities file.
     C     HQDLUP        IFNE      @DLUP                                        B1
     C     HQMLUP        ORNE      @MLUP                                        *1
     C     HQYLUP        ORNE      @YLUP                                        *1
     C                   EXSR      #BA                                          *1
     C     *INU7         IFEQ      '1'                                          B*2
     C                   GOTO      #B9                                          **2
     C                   END                                                    E*2
     C                   END                                                    E1
     C*
     C                   EXSR      #BB
     C*
     C** Load date & time of last update fields
     C                   TIME                    HQTLUP
     C                   Z-ADD     RUND          HQLCD
     C                   MOVE      @USER         HQLUID
     C                   Z-ADD     @DLUP         HQDLUP
     C                   MOVE      @MLUP         HQMLUP
     C                   Z-ADD     @YLUP         HQYLUP
     C*
     C** If record did not exist on liquidities file for this currency
     C** before this call to program add record
     C     *IN63         IFEQ      '1'                                          B1
     C     @COFF2        IFEQ      'Y'
     C                   WRITE     MMFDUMP0                                     *1
     C                   ELSE
     C                   WRITE     MMFLIQP0                                     *1
     C                   END
     C                   ELSE                                                   X1
     C*
     C     @COFF2        IFEQ      'Y'                                          B*2
     C                   UPDATE    MMFDUMP0                                     **2
     C                   ELSE                                                   X*2
     C                   UPDATE    MMFLIQP0                                     *1
     C                   END                                                    E*2
     C                   END                                                    E1
     C*
     C     #B9           ENDSR                                                  **#B9**
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BA      - Load period dates array                            *
     C*                                                               *
     C* CALLS    ZA0710   - Convert midas day no. to YYYYMMDD format  *
     C*          ZA0730   - Determine next working day                *
     C*          ZA1290   - Calculate a period date                   *
     C*          ZA0680   - Convert YYYYMMDD to a midas day number    *
     C*                                                               *
     C* CALLED BY  #B     - Main processing                           *
     C*                                                               *
     C* FLDS USED  @CCY   - Currency                                  *
     C*            @CUR   - Field in key to access currencies file    *
     C*            @KEY   - Key to currencies file                    *
     C*            @@SPOT - MM spot date YYYYMMDD                     *
     C*            @@RUND - Run date YYYYMMDD                         *
     C*            @@DAYN - Midas day number                          *
     C*            @@VDT  - Date output from ZA0710                   *
     C*            @@DTIN - Input date                                *
     C*            @@CCY  - Currency                                  *
     C*            @@MDNO - Midas day number workfield                *
     C*            @PR    - Period dates array                        *
     C*            @@PNUM - Period number                             *
     C*            @@PTYP - Period type                               *
     C*            @@PDAT - Period date                               *
     C*                                                               *
     C*****************************************************************
     C     #BA           BEGSR
     C*
     C***Determine*spot*Date*by*accessing*FDCCYTLL for this currency      S01194
     C*********************MOVE @CCY      @CUR                            S01194
     C***********@KEY******CHAINFDCCYTLL             60                   S01194
     C*********************                                               S01194
     C***DEAL*WITH*DATA*BASE ERROR                                        S01194
     C********** *IN60*****IFEQ '1'                        ***************S01194
     C                   CALL      'AOCURRR0'                                                  S0119
     C                   PARM      *BLANKS       @RTCD             7                           S0119
     C                   PARM      '*KEY   '     @OPTN             7                           S0119
     C                   PARM      @CCY          @AJCD             3                           S0119
     C     SDCURR        PARM      SDCURR        DSSDY                                         S0119
     C     @RTCD         IFNE      *BLANKS                                      B1             S0119
     C*********************MOVEL'FDCCYTLL'DBFILE           *             *S01194
     C                   MOVEL     'SDCURRPD'    DBFILE                                        S0119
     C                   MOVEL     '002'         DBASE                          * DBERROR 002 *
     C                   MOVEL     @OPTN         DBOPTN            7                           S0119
     C*********************MOVEL@KEY      DBKEY            *             *S01194
     C                   MOVEL     @CCY          DBKEY                          **2            S0119
     C                   MOVE      '1'           *INU7                          ***************
     C                   MOVE      '1'           *INU8                          *1
     C                   GOTO      #BA9                                         *1
     C                   END                                                    E1
     C*
     C*********************MOVE MSPD      @@SPOT                          S01194
     C                   MOVE      A6MMSD        @@SPOT                                        S0119
     C*
     C** If period dates have not been calculated for this currency,
     C** then load period dates array
     C     @@RUND        IFEQ      *ZERO                                        B1
     C                   Z-ADD     RUND          @@DAYN                         *1
     C                   EXSR      ZA0710                                       *1
     C                   Z-ADD     @@VDT         @@RUND                         *1
     C                   END                                                    E1
     C*
     C** Calculate today period date.
     C                   Z-ADD     @@RUND        @@DTIN
     C                   MOVE      @CCY          @@CCY
     C                   EXSR      ZA0730
     C     @@MDNO        SUB       1             @PR(1)
     C*
     C** Calculate D1 period date.
     C                   Z-ADD     @@VDT         @@DTIN
     C                   EXSR      ZA0730
     C     @@MDNO        SUB       1             @PR(2)
     C*
     C** Calculate D2 period date.
     C                   Z-ADD     @@VDT         @@DTIN
     C                   EXSR      ZA0730
     C     @@MDNO        SUB       1             @PR(3)
     C*
     C** Calculate D3 period date.
     C                   Z-ADD     @@VDT         @@DTIN
     C                   EXSR      ZA0730
     C     @@MDNO        SUB       1             @PR(4)
     C*
     C** Calculate D4 period date.
     C                   Z-ADD     @@VDT         @@DTIN
     C                   EXSR      ZA0730
     C     @@MDNO        SUB       1             @PR(5)
     C*
     C** Calculate W1 period date.
     C                   Z-ADD     1             @@PNUM            1 0
     C                   MOVE      'W'           @@PTYP
     C                   EXSR      ZA1290
     C                   Z-ADD     @@PDAT        @@DTIN
     C                   EXSR      ZA0680
     C     @@MDNO        SUB       1             @PR(6)
     C*
     C** Calculate M1 period date.
     C                   Z-ADD     1             @@PNUM
     C                   MOVE      'M'           @@PTYP
     C                   EXSR      ZA1290
     C                   Z-ADD     @@PDAT        @@DTIN
     C                   EXSR      ZA0680
     C     @@MDNO        SUB       1             @PR(7)
     C*
     C** Calculate M2 period date.
     C*********************MOVE MSPD      @@SPOT                          S01194
     C                   MOVE      A6MMSD        @@SPOT                                        S0119
     C                   Z-ADD     2             @@PNUM
     C                   MOVE      'M'           @@PTYP
     C                   EXSR      ZA1290
     C                   Z-ADD     @@PDAT        @@DTIN
     C                   EXSR      ZA0680
     C     @@MDNO        SUB       1             @PR(8)
     C*
     C** Calculate M3 period date.
     C*********************MOVE MSPD      @@SPOT                          S01194
     C                   MOVE      A6MMSD        @@SPOT                                        S0119
     C                   Z-ADD     3             @@PNUM
     C                   MOVE      'M'           @@PTYP
     C                   EXSR      ZA1290
     C                   Z-ADD     @@PDAT        @@DTIN
     C                   EXSR      ZA0680
     C     @@MDNO        SUB       1             @PR(9)
     C*
     C     #BA9          ENDSR                                                  **#BA9**
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #BB      - CALCULATE LIQUIDITY EXP FIXED                      *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  #B     - Main processing                           *
     C*                                                               *
     C* FLDS USED  @PR    - PERIOD DATES ARRAY                        *
     C*            @NDA   - NEAR DATE AMOUNT                          *
     C*            @FDA   - FAR DATE AMOUNT                           *
     C*                                                               *
     C*****************************************************************
     C     #BB           BEGSR
     C*
     C     JUNDAT        IFGE      RUND                                         B1
     C                   Z-ADD     1             X                 2 0          *1
     C*
     C     X             DOUGE     10                                           B2
     C*
     C     @PR(X)        IFGE      JUNDAT                                       B3
     C*
     C     JULACT        IFEQ      'I'                                          B4
     C                   SUB       @NDA          @L2(X)                         *4
     C                   END                                                    E4
     C     JULACT        IFEQ      'D'                                          B4
     C                   ADD       @NDA          @L2(X)                         *4
     C                   END                                                    E4
     C*
     C                   Z-ADD     10            X                 2 0          *3
     C                   END                                                    E3
     C*
     C                   ADD       1             X                              *2
     C*
     C                   END                                                    E2
     C*
     C                   Z-ADD     1             X                              *1
     C*
     C                   END                                                    E1
     C*
     C     JUFDAT        IFGE      RUND                                         B1
     C*
     C                   Z-ADD     1             X                 2 0          *1             AB015
     C*
     C     X             DOUGE     10                                           B2
     C*
     C     @PR(X)        IFGE      JUFDAT                                       B3
     C*
     C     JULACT        IFEQ      'I'                                          B4
     C                   ADD       @FDA          @L2(X)                         *4
     C                   END                                                    E4
     C     JULACT        IFEQ      'D'                                          B4
     C                   SUB       @FDA          @L2(X)                         *4
     C                   END                                                    E4
     C*
     C                   Z-ADD     10            X                 2 0          *3
     C                   END                                                    E3
     C*
     C                   ADD       1             X                              *2
     C*
     C                   END                                                    E2
     C*
     C                   END                                                    E1
     C*
     C     #BB9          ENDSR                                                  **#BB9**
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                                     *
     C**ZA0830*-*THIS*SUBROUTINE FINDS OUT WHETHER A PARTICULAR DAY       S01195
     C***********IS*A*HOLIDAY IN A PARTICULAR CURRENCY                    S01195
     C****************                                                    S01195
     C**CALLED*BY*:*ZA0730                                                S01195
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
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*       TITLE:  ZA0730 - DETERMINE NEXT WORKING DAY.            *
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
     C*          @@MNO  MIDAS DAY NO USED BY SR ZA0830                *
     C*          @@HIND HOLIDAY IND.RETURNED BY ZA0830                *
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
      *****************************************************************
      /EJECT
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
     C*  CALLED BY    - #BA                                           *
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
     C*********************EXSR ZA0830                     *1             S01195
     C                   Z-ADD     @@MNO         ZDAYNO                                        CAP00
     C                   MOVEL     @@CCY         ZCCY                                          CAP00
     C                   EXSR      ZCHKH                                        *1             S0119
     C***********@@HIND****DOWEQ'H'                        B*2            S01195
     C     ZIND          DOWEQ     'H'                                          B*2            S0119
     C                   ADD       1             @@MNO                          **2
     C*********************EXSR ZA0830                     **2            S01195
     C                   Z-ADD     @@MNO         ZDAYNO                                        CAP00
     C                   MOVEL     @@CCY         ZCCY                                          CAP00
     C                   EXSR      ZCHKH                                        **2            S0119
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
     C***********@@HIND****IFEQ 'H'                        B*2
     C     ZIND          IFEQ      'H'                                          B*2            S0119
     C                   Z-ADD     @@STRT        @@DTIN                         **2            S0119
     C                   EXSR      ZA0730                                       **2
     C*
     C     @@STMT        IFNE      @@Z71M                                       B**3
     C***********@@HIND****DOUEQ'W'                        B***4          S01195
     C     ZIND          DOUEQ     'W'                                          B***4          S0119
     C                   SUB       1             @@MNO                          ****4
     C*********************EXSR ZA0830                     ****4          S01195
     C                   Z-ADD     @@MNO         ZDAYNO                                        CAP00
     C                   MOVEL     @@CCY         ZCCY                                          CAP00
     C                   EXSR      ZCHKH                                        ****4          S0119
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
     C*  SUBROUTINE ZA0770 - THIS SUBROUTINE RECEIVES A 8/0 INPUT     *
     C*                      DATE - FORMAT YYYYMMDD AND OUTPUTS A     *
     C*                      6/0 DATE. IF FIELD DATF ON TABTB10 =     *
     C*                      'M' OUTPUT FORMAT MMDDYY. IF FIELD       *
     C*                      DATF = 'D' OUTPUT FORMAT DDMMYY.         *
     C*                                                               *
     C*  CALLED BY   : ZA1290                                         *
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
     C     ZA0770        BEGSR
     C*
     C**  DATF = 'D' CONVERT TO MMDDYY FORMAT
     C***********DATF******IFEQ 'D'                        B1             S01194
     C     BJDFIN        IFEQ      'D'                                          B1             S0119
     C                   Z-ADD     @@DD          @@DAT1                         *1
     C                   Z-ADD     @@MM          @@DAT2                         *1
     C                   END                                                    E1
     C*
     C*
     C**  DATF = 'M' CONVERT TO MMDDYY FORMAT                             S01194
     C***********DATF******IFEQ 'M'                        B1             S01194
     C     BJDFIN        IFEQ      'M'                                          B1             S0119
     C                   Z-ADD     @@DD          @@DAT2                         *1
     C                   Z-ADD     @@MM          @@DAT1                         *1
     C                   END                                                    E1
     C*
     C                   Z-ADD     @@YYY         @@YYYO
     C*
     C     ZA0779        ENDSR                                                  ***ZA0779***
     C/EJECT
     C*******************************************************************
     C*
     C* ZA0680 - THIS SUBROUTINE CONVERTS YYYYMMDD FORMAT DATE TO
     C*          MIDAS DAY NUMBER FORMAT (NO. DAYS FROM 31/12/71)
     C*
     C* CALLED BY : #BA
     C*             ZA1290
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
     C**   ORIGINAL VALUE BEFORE CONTINUING WITH NORMAL CALCULATIONS.
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
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TITLE- ZA0710-CALCULATE MIDAS DAY NO. TO DRS (YYYYMMDD) FORMAT*
      *                                                               *
      *       SUBROUTINE ZA0710 EXPECTS FIELD '@@DAYN' TO BE          *
      *       PASSED TO IT IN 5,0 FORMAT.IF THE ABOVE FIELD IS LESS   *
      *       THAN 1 IT RETURNS 1 IN FIELD '@@RTN'.THE MAIN PROGRAM   *
      *       SHOULD CHECK FOR THIS CONDITION AND DO THE NECESSARY.   *
      *       IF '@@RTN' IS NOT EQUAL TO 1 IT RETURNS THE FIELD       *
      *       '@@VDT'  IN 'YYYYMMDD' FORMAT.                          *
      *                                                               *
      * NOTE: FIELD TO BE DEFINED BY EXTERNAL ROUTINE IS
      *                                                               *
      *       1) @@DAYN   LENGTH 5,0.                                 *
      *                                                               *
      *       FIELDS USED AND ALREADY DEFINED IN THE ROUTINE ARE:     *
      *                                                               *
      *       1) @@VDT    LENGTH 8,0 DEFINED BY A DS.                 *
      *       2) @@RTN    LENGTH 1,0.                                 *
      *       3) @@I      LENGTH 2,0 USED TO ACCESS ARRAY @YD         *
      *       4) @@J      LENGTH 2,0 USED TO ACCESS ARRAY @MD         *
      *       5) @@Z71Y   LENGTH 4,0 DEFINED BY A DS.                 *
      *       6) @@RDAY   LENGTH 5,0.                                 *
      *       7) @@LEAP   LENGTH 1,0.
      *                                                               *
      *       INDICATORS USED ARE:                                    *
      *                                                               *
      *       1) 80       CHECK FOR LOW AND EQUAL ON ARRAY @YD        *
      *       2) 81       CHECK FOR LOW ON ARRAY @MD.                 *
      *                                                               *
      * INPUT FIELD:       @@DAYN                                     *
      *                                                               *
      * OUTPUT FIELD:      @@VDT                                      *
      *                                                               *
      * WORK FIELDS:       @@RTN                                      *
      *                    @@Z71Y                                     *
      *                    @@RDAY                                     *
      *                    @@LEAP                                     *
      *                    @@I                                        *
      *                    @@J                                        *
      *                                                               *
      * ARRAYS USED:       @YD COMPILE TIME ARRAY.                    *
      *                    @MD COMPILE TIME ARRAY.                    *
      *                                                               *
      *****************************************************************
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
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #A       - Initial processing                                 *
     C*                                                               *
     C* CALLS    ZA0150   - Access installation file                  *
     C*          ZA0710   - Convert midas day no. to YYYYMMDD format  *
     C*                                                               *
     C* CALLED BY  MAIN   - Controls program                          *
     C*                                                               *
     C* FLDS USED  @TERM  - Termination parameter                     *
     C*            @STDD  - Deal format passed to program             *
     C*            @FIRST - Program has been called before indicator  *
     C*            @@RUND - Run date YYYYMMDD                         *
     C*            @KEY   - Key to currencies file                    *
     C*            @@DAYN - Midas day number                          *
     C*            @@VDT  - Date output from ZA0710                   *
     C*            @DNWD  - Date of next working day                  *
     C*                                                               *
     C*****************************************************************
     C     #A            BEGSR
     C*
     C**  Parameter list .
     C     *ENTRY        PLIST
     C                   PARM                    @TERM             1
     C                   PARM                    @STDD
     C                   PARM                    @CMT              1
     C*
     C**  Move program name into *LDA field.
     C                   MOVEL     'AB0290'      DBPGM
     C*
     C** INITIALISE INDICATORS & WORKFIELDS
     C*
     C                   MOVE      '0'           *IN60
     C                   MOVE      '0'           *IN63
     C*
     C                   Z-ADD     0             @SLINT
     C                   Z-ADD     0             @NXINT
     C                   Z-ADD     0             @MATD
     C                   Z-ADD     0             @START
     C                   MOVE      *BLANKS       @CCY
     C*
     C**  Open files if first run
     C     @FIRST        IFNE      'Y'                                          B1
     C                   MOVE      'Y'           @FIRST            1            *1
     C                   Z-ADD     0             @@RUND            8 0
      *
      * If Commitment Control Off Parameter was sent move it to testable
      *    field
     C     @NOPMS        IFGT      2                                                           AB007
     C                   MOVE      @CMT          @COFF2            1
     C                   END                                                                   AB007
      *
     C*********************OPEN FDICDRLL                   *1             S01194
     C*********************OPEN FDCCYTLL                   *1             S01194
     C     @COFF2        IFEQ      'Y'
      *  Override Dummy Files to real files.
     C                   Z-ADD     30            @LNTH            15 5
     C*********************CALL 'QCAEXEC'                                 E20774
     C                   CALL      'QCMDEXC'                                                   E2077
     C                   PARM                    @CMD(1)
     C                   PARM                    @LNTH
     C                   OPEN      MMFDUMLL                                     *1
     C                   ELSE
     C                   OPEN      MMFLQULL                                     *1
     C                   END
     C*
     C***ACCESS*TABTB10****                                               S01194
     C*********************                                               S01194
     C*********************EXSR ZA0150                     *1             S01194
     C*********************                                               S01194
     C***SKIP*TO*END*OF*SUBROUTINE IF DBERROR OCCURRED IN ZA0150          S01194
     C*********************                                               S01194
     C********** *INU7*****IFEQ '1'                                       S01194
     C*********************GOTO #A9                                       S01194
     C*********************END                                            S01194
     C*********************                                               S01194
     C****Read*file*FDICDRLL, format TABTB11.                             S01194
     C*********************MOVE *BLANKS   @KEY                            S01194
     C*********************MOVEL'01'      @KEY                            S01194
     C*********************MOVE '11'      @KEY                            S01194
     C***********@KEY******CHAINFDICDRLL             60                   S01194
     C*********************                                               S01194
     C****If*the*chain*fails or RECI is not 'D' then it is a data base    S01194
     C****error.***********                                               S01194
     C********** *IN60*****IFEQ '1'                        B1             S01194
     C***********RECI******ORNE 'D'                        *1             S01194
     C                   CALL      'AOBANKR0'                                                  S0119
     C                   PARM      *BLANKS       @RTCD                                         S0119
     C                   PARM      '*FIRST '     @OPTN                                         S0119
     C     SDBANK        PARM      SDBANK        DSFDY                                         S0119
     C     @RTCD         IFNE      *BLANKS                                      B*2            S0119
     C                   MOVE      '1'           *INU7                          *1
     C                   MOVE      '1'           *INU8                          ***************
     C*********************MOVEL'FDICDRLL'DBFILE           * DBERROR 001 *S01194
     C                   MOVEL     'SDBANKPD'    DBFILE                                        S0119
     C*********************MOVEL@KEY      DBKEY            ***************S01194
     C                   MOVEL     @OPTN         DBOPTN            7                           S0119
     C                   MOVE      '001'         DBASE                          *1
     C                   MOVE      '1'           *INLR                          *1
     C                   MOVE      '1'           *INKC                          *1
     C*
     C                   GOTO      #A9                                          *1
     C                   END                                                    E1
     C*
     C** Convert date of next working day to DDMMYYYY format
     C** for comparison with other dates
     C*********************Z-ADDDNWD      @@DAYN                          S01194
     C                   Z-ADD     BJDNWD        @@DAYN                                        S0119
     C                   EXSR      ZA0710
     C                   Z-ADD     @@VDT         @DNWD             8 0
     C*
     C***Load*key*used*to*access currencies file.                         S01194
     C*********************MOVE *BLANKS   @KEY             *1             S01194
     C*********************MOVEL'20'      @KEY             *1             S01194
     C*********************MOVE '1'       @KEY             *1             S01194
     C                   END                                                    E1
     C*
     C     #A9           ENDSR                                                  **#A9**
     C*
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* #C       - Final processing                                   *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY  MAIN   - Controls program                          *
     C*                                                               *
     C* FLDS USED  @TERM  - Termination parameter                     *
     C*                                                               *
     C*****************************************************************
     C     #C            BEGSR
     C*
     C** Set on LR & exit if termination parmater is 'T'
     C     @TERM         IFEQ      'T'                                          B1
     C                   MOVE      '1'           *INLR                          *1
     C                   RETURN
     C                   GOTO      #C9                                          *1
     C                   END                                                    E1
     C*
     C**  If a data base error has occurred in one of the called
     C**  programs return without setting on
     C**  *INLR or closing the files.
     C     @TERM         IFEQ      'E'                                          B1
     C                   RETURN                                                 *1
     C                   END                                                    E1
     C*
     C**  If a data base error has occurred in the program, set
     C**  termination parameter to 'E' & exit program
     C**  setting on *inLR
     C     *INU7         IFEQ      '1'                                          B1
     C                   MOVE      'E'           @TERM                          *1
     C                   MOVE      '1'           *INLR                          *1
     C                   RETURN                                                 *1
     C                   GOTO      #C9                                          *1
     C                   END                                                    E1
     C*
     C                   RETURN
     C*
     C     #C9           ENDSR                                                  **#C9**
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C********                                                        *   S01194
     C********SUBROUTINE ZA0150 - THIS SUBROUTINE CHAINS TO FILE LF/  *   S01194
     C********FDICDRLL TO GET THE INSTALLATION CONTROL DETAILS RECORD *   S01194
     C********1 (HELD ON PF/TABTB10)                                  *   S01194
     C********INDICATOR 80 IS SET ON IF THE CHAIN FAILS OR THE RECORD *   S01194
     C********IS FLAGGED FOR DELETION.                                *   S01194
     C********IF INDICATOR 80 IS SET ON DETAILS OF THE ATTEMPTED      *   S01194
     C********ACCESS ARE PLACED IN THE LDA.                           *   S01194
     C********                                                        *   S01194
     C********FIELDS USED : SS0150 - KEY USED TO ACCESS FDICDRLL      *   S01194
     C********                                                        *   S01194
     C*****************************************************************   S01194
     C*********************                                               S01194
     C***********ZA0150****BEGSR                                          S01194
     C*********************                                               S01194
     C***SET*UP*KEY*TO*OBTAIN FORMAT TABTB10F '01        10'              S01194
     C*********************MOVEL'01'      SS0150 12                       S01194
     C*********************MOVE '10'      SS0150                          S01194
     C*********************                                               S01194
     C***CHAIN*TO*FILE*FDICDRLL                                           S01194
     C***********SS0150****CHAINFDICDRLL             80                   S01194
     C***********RECI******IFNE 'D'                        B1             S01194
     C*********************MOVE '1'       *IN80            *1             S01194
     C*********************END                             E1             S01194
     C*********************                                               S01194
     C***DEAL*WITH*DATA*BASE ERROR                                        S01194
     C********** *IN80*****IFEQ '1'                        ***************S01194
     C*********************MOVEL'FDICDRLL'DBFILE           *             *S01194
     C*********************MOVEL'900'     DBASE            * DBERROR 900 *S01194
     C*********************MOVELSS0150    DBKEY            *             *S01194
     C*********************MOVE '1'       *INU7            ***************S01194
     C*********************MOVE '1'       *INU8            *1             S01194
     C*********************END                             E1             S01194
     C*********************                                               S01194
     C***********ZA0159****ENDSR                                          S01194
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* INFSR    - Unmonitored file error                             *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY         -                                           *
     C*                                                               *
     C* FLDS USED  @ERR2  - Error routine performed indicator         *
     C*            @TERM  - Termination parameter                     *
     C*            @FILE  - File in error                             *
     C*                                                               *
     C*****************************************************************
     C     INFSR         BEGSR
     C*
     C**  Set @ERR2 to 'Y' to prevent looping if further errors occur.
     C     @ERR2         IFNE      'Y'                                          B1
     C*
     C                   MOVE      'Y'           @ERR2             1            *1
     C                   MOVE      '1'           *INU7                          *1
     C                   MOVE      '1'           *INU8                          *1
     C                   MOVE      'E'           @TERM                          *1
     C*
     C**  Set up fields in local data area.
     C                   MOVEL     @FILE         DBFILE                         *1
     C                   MOVEL     'AB0290'      DBPGM                          *1
     C                   MOVEL     '992'         DBASE                          *1
     C                   DUMP                                                   *1
     C*
     C                   END                                                    E1
     C*
     C**  Terminate processing immediately.
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C     INFSR9        ENDSR                                                  **INFSR9**
     C*****************************************************************
     C/EJECT
     C*****************************************************************
     C*                                                               *
     C* *PSSR    - Unmonitored program error                          *
     C*                                                               *
     C* CALLS             -                                           *
     C*                                                               *
     C* CALLED BY         -                                           *
     C*                                                               *
     C* FLDS USED  @ERR1  - Error routine performed indicator         *
     C*            @TERM  - Termination parameter                     *
     C*                                                               *
     C*****************************************************************
     C     *PSSR         BEGSR
     C*
     C**  Set @ERR1 to 'Y' to prevent looping if further errors occur.
     C     @ERR1         IFNE      'Y'                                          B1
     C*
     C                   MOVE      'Y'           @ERR1             1            *1
     C                   MOVE      '1'           *INU6                          *1
     C                   MOVE      'E'           @TERM                          *1
     C*
     C**  Set up fields in local data area.
     C                   MOVEL     'AB0290'      DBPGM                          *1
     C                   MOVEL     '991'         DBASE                          *1
     C                   DUMP                                                   *1
     C*
     C                   END                                                    E1
     C*
     C**  Terminate processing immediately.
     C                   MOVE      '1'           *INLR
     C*
     C                   RETURN
     C*
     C     #PSSR9        ENDSR                                                   ***PSSR9**
     C*
     C/EJECT
      *
      /COPY ZSRSRC,ZACCHLE                                                S01195
      *
      /COPY ZSRSRC,ZCHKHLE                                                S01195
**CTDATA CPY@
(c) Misys International Banking Systems Ltd. 2001
**CTDATA @YD
00366007310109601461
**CTDATA @MD
00000000310005900090001200015100181002120024300273003040033400365
**CTDATA @CMD
OVRDBF  MMFDUMLL    MMFLQULL
