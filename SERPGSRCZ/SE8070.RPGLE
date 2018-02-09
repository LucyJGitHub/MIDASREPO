     H DEBUG
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Repo Coupon Claims Report')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SE8070 - Midas SE Repo Coupon Claims Report                  *
      *                                                               *
      *  Function:  This program runs in COB and produce a report     *
      *             with details of bonds.                            *
      *                                                               *
      *  Called By: SEC8070 - Midas SE Repo Coupon Claims Report      *
      *                                                               *
      *  (c) Finastra International Limited 2005                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8799            Date 15Feb05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSE070  *CREATE    Date 15Feb04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8799- CSE070 field is not switchable & in wrong place     *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSE070 - Repo Coupon Claims Report                           *
      *                                                               *
      *****************************************************************
     FSE8070AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
      ** Audit Report File
 
     FSE8070P1  O    E             PRINTER
     F                                     INFDS(SPOOL1)
      ** Report File
 
     FSERREQPD  O    E             DISK    INFSR(*pssr)
      ** Repo Claims
 
     FSERREQL0  IF   E           K DISK    INFSR(*pssr)
     F                                     RENAME(SERREQD0:SERREQD1)
      ** Repo Claims
 
     FSECTY     IF   E           K DISK    INFSR(*pssr)
      ** Securities detail
 
     FDPTMV     IF   E           K DISK    INFSR(*pssr)
     F                                     PREFIX(V_)
      ** Depot movements
 
     FTABTB11   IF   E             DISK    INFSR(*pssr)
      ** Table ICD Record 2
 
     FSDSECSL4  IF   E           K DISK    INFSR(*pssr)
      ** Securities Customer Details
 
     FINVTP     IF   E           K DISK    INFSR(*pssr)
      ** SE Investment Types
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *   37  - Multibranching ON                                     *
      *                                                               *
      *                                                               *
      *   84  - End of File of INVTP                                  *
      *   85  - End of File of SDSECSL4                               *
      *   86  - End of File of DPTMV                                  *
      *   87  - End of File of TABTB11                                *
      *   88  - End of File of SECTY                                  *
      *   89  - End of File of SERREQL0                               *
      *                                                               *
      *   98  - Date Format: DDMMYY (off); MMDDYY (on)                *
      * 90-99 - Used by Standard Subroutines                          *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  INIT   - Program Initialisation                              *
      *  COLLATE - Collate records to be written to SERREQPD          *
      *  COLPROC - Select and process records from SECTY              *
      *  ZEVCD - - Determine Event Control Date                       *
      *  PROCES - Detail Report Processing                            *
      *  TOTALS - Process Totals for change in customer or security.  *
      *  CHEKDAT - Check for working days between coupon due dates    *
      *  REPORT - Process Report Lines                                *
      *                                                               *
      *  WP1REC - Format and Write a Detail Record to the Report      *
      *  WP1END - Write End of Report                                 *
      *                                                               *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  *PSSR  - Program Error Processing Subroutine                 *
      *  RCFP1  - RCF Processing for P1 Report                        *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *                                                               *
      *****************************************************************
     D/EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Array containing Copyright statement
 
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
 
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Data Area giving Installation Control Details
 
     D PSDS           SDS
 
      ** Program Status Data Structure
 
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D SPOOL1          DS
      ***  File Information Data Structure for SE8070P1.
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D SPOOLU          DS
      ***  File Information Data Structure for SE8070AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ***  Data structure to define variables used in holiday sub-routines
 
     D ZVARS           DS
     D  HolInd                 1      1
     D  DateIn                 2      4P 0
     D  Currency               5      7
     D  Location               8     10
 
      ***  Dummy Data Structures used by Access Programs.
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External data structures for Bank Details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ***  External DS for Currency
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for Currency
 
     D SECTY1        E DS                  EXTNAME(SECTYD)
     D  CDArr                183    230
     D  CRArr                231    242
      ***  External data structures for Securities Details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***   Second DS for Access programs - long data structure
 
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ***  Perform Initialisation.
 
     C                   EXSR      INIT
 
      ***  Collate Records and Details to be Reported.
 
     C                   EXSR      COLLATE
 
      ***  Perform Detail Processing.
 
     C                   EXSR      PROCES
 
      ***  Output Audit Report and End Program.
 
     C                   EXSR      AUDIT
 
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  INIT   - Subroutine to do Program Initialisation.            *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  RCFAU  - RCF Processing for Audit Report                     *
      *  ZDAT   -
      *  ZDAT   -
      *  AOBANKR0 Access Program                                      *
      *                                                               *
      *****************************************************************
 
     C     INIT          BEGSR                                                  ***  INIT  ***
 
      ** Set up copyright parameter
 
     C                   MOVEA     CPY@          CPY2@            80
 
      ***  Receive Parameter List.
 
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ              5
 
      ***  Initialise LDA field.
 
     C                   MOVEL     'SE8070'      DBPGM
 
      ***  Call Access Program for Bank Details - Title, Run Date and
      ***  Run Day Number.
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSSDY
 
      ***  Handle Database Error.
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVE      'SDBANKPD'    DBFILE                         ***************
     C                   Z-ADD     001           DBASE                          * DB ERROR 01 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
 
      ***  Check System Date Format, DDMMYY (*IN98 off)
      ***                            MMDDYY (*IN98 on).
 
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
 
      **   Access RUNDAT for multibranching indicator
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
      *
     C     AGMBIN        IFEQ      'M'
     C                   SETON                                        37
     C                   END
 
      ***  RCF Processing for Audit File.
 
     C                   EXSR      RCFAU
     C                   EXSR      RCFP1
 
      ***  Report Work fields.
 
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
 
     C                   ENDSR
 
      *****************************************************************
      *                                                               *
      *  COLLATE - Subroutine to collate records to be reported.      *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  COLPROC -  Select and process records from SECTY.            *
      *                                                               *
      *****************************************************************
 
     C     COLLATE       BEGSR                                                  ** COLLATE  **
 
      ** Read through all records of SECTY
 
     C     *LOVAL        SETLL     SECTYDF
     C                   READ      SECTYDF                                88
     C     *IN88         DOWEQ     *Off
 
     ** Select and process records from SECTY.
 
     C                   EXSR      COLPROC
 
     C                   READ      SECTYDF                                88
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/COLPROC
      *****************************************************************
      *                                                               *
      *  COLPROC - Subroutine to select and process records from      *
      *            SECTY.                                             *
      *                                                               *
      *  Called By: COLLATE                                           *
      *  Calls:                                                       *
      *  ZNCD   - Determine next coupon day                           *
      *  ZACCZ  - Calculate estimated coupon                          *
      *  ZEVCD  - Determine Event Control Date                        *
      *                                                               *
      *****************************************************************
 
     C     COLPROC       BEGSR                                                  ** COLPROC ***
 
     ** Determine Event Control Date to be used in ZNCD
 
     C     1             SETLL     TABTB11F
     C                   READ      TABTB11F                               87
     C     *IN87         IFEQ      *Off
     C                   EVAL      ZZAPDT = APDA
     C                   EVAL      ZZDNWD = DNWD
     C                   EXSR      ZEVCD
 
     ** Determine next coupon date.
 
     C                   CALLB     'ZNCD'
      * INPUTS
      ** Security details
     C                   PARM                    ITLD
     C                   PARM                    FCPN
     C                   PARM                    MATY
     C                   PARM                    CDArr
     C                   PARM                    CRArr
     C                   PARM                    ECD                            Event Control Date
     C                   PARM                    BJDFIN                         Date Format
     C                   PARM                    NMCY              3            Nominal Currency
     C                   PARM                    SITP              3            Secu Investment Type
     C                   PARM                    BCNV              1            Eff on Hol on CouDat
     C                   PARM                    LCPN                           Last Coupon Date
     C                   PARM                    HCY1                                         CSE071
     C                   PARM                    HCY2                                         CSE071
     C                   PARM                    HCY3                                         CSE071
     C                   PARM                    HCY4                                         CSE071
     C                   PARM                    HCY5                                         CSE071
     C                   PARM                    HCY6                                         CSE071
     C                   PARM                    HCY7                                         CSE071
     C                   PARM                    HCY8                                         CSE071
     C                   PARM                    HCY9                                         CSE071
      * OUTPUTS
     C                   PARM                    NCDAT             5 0          Next Coupon Date
 
      ** Calculate 5 working days from Midas rundate.
 
     C                   CALLB     'ZFWDT'
     C                   PARM      BJRDNB        InputDay          5 0
     C                   PARM      5             DaysFwd           2 0
     C**********         PARM                    OutputDay         5 0                       BUG8799
     C                   PARM                    LastDay           5 0                       BUG8799
     C                   PARM      BJCYCD        Currency          3
     C                   PARM      BJSLCD        Location          3
 
      ** If Maturity date is not before Next Coupon Date and Next Coupon Date
      ** is within 5 working days from Midas rundate, access Depot Movements.
 
     C*****NCDAT         IFLE      OutputDay                                                 BUG8799
     C     NCDAT         IFLE      LastDay                                                   BUG8799
     C     NCDAT         ANDGE     BJRDNB
     C     MATY          ANDGE     NCDAT
 
     C     KDEPOT        KLIST
     C                   KFLD                    KDPSS            10
     C                   KFLD                    KDPRN             6
 
     C                   EVAL      KDPSS = SESN
     C                   Z-ADD     0             WDPRN             6 0
     C                   MOVE      WDPRN         KDPRN
 
     C     KDEPOT        SETLL     DPTMVDF
     C                   READ      DPTMVDF                                86
     C     *IN86         DOWEQ     *Off
     C     V_DPSS        ANDEQ     SESN
 
      ** If depot movement is a Live repo, Reverse repo, stock borrowing,
      ** or stock lending, access Securities Customer Details file.
 
     C                   IF        V_DPMV = 'RP' OR V_DPMV = 'RR'
     C                             OR V_DPMV = 'BB' OR V_DPMV = 'BL'
 
     C                   MOVE      V_DPID        WVDPID            6
     C     WVDPID        CHAIN     SDSECSD0                           85
 
      ** If securities details record is found and Repo Claims Required
      ** field is 'Y', write details to SERREQPD, for reporting later.
 
     C     *IN85         IFEQ      *Off
     C     BFRREQ        ANDEQ     'Y'
 
     C                   EVAL      SESN = SESN                                  Security Shortname
     C                   EVAL      ISNO = ISIN                                  ISIN No.
     C                   EVAL      SRPN = SRPN                                  Security Report Name
     C                   MOVE      NCDAT         DATE                           Coupon Due Date
     C                   EVAL      NMCY = NMCY                                  Currency
     C                   EVAL      CPNR = CPNR                                  Coupon Rate
 
     C                   MOVEL     V_DPID        @KEYC
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEYC            10
     C                   PARM      *Blanks       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @KEYC         DBKEY
     C                   MOVE      'SDCUSTPD'    DBFILE                         ***************
     C                   Z-ADD     002           DBASE                          * DB ERROR 02 *
     C                   EXSR      *PSSR                                        ***************
     C                   ELSE
     C                   EVAL      DPID = BBCSSN                                Customer Shortname
     C                   ENDIF
 
     C                   EVAL      DLNOR = *Blanks
     C                   IF        V_DPMV = 'RP' OR V_DPMV = 'RR'
     C                   MOVE      V_DPAD        WDPAD             6
     C     WDPAD         CAT       '/':0         WFLD1             7
     C     WFLD1         CAT       V_DPRN:0      DLNOR                          Deal Number Repo
     C                   ENDIF                                                  RP RR IF
 
     C                   IF        V_DPMV = 'BB' OR V_DPMV = 'BL'
     C                   MOVE      V_DPRN        DLNOR                          Deal Number Repo
     C                   ENDIF                                                  BB BL IF
 
     C                   EVAL      DPMV = V_DPMV                                Transaction Type
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    V_DPMD                         Movement Date In
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM                    ZADATE            7            Run-date in DDM
     C                   EVAL      DATIN = ZDATE                                Date In
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    V_DPDO                         Movement Date Out
     C                   PARM                    BJDFIN                         Date format ind
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM                    ZADATE            7            Run-date in DDM
     C                   EVAL      DATOUT = ZDATE                               Date Out
 
     C                   MOVEL     V_DPBN        @KEYC
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEYC            10
     C                   PARM      *Blanks       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @KEYC         DBKEY
     C                   MOVE      'SDCUSTPD'    DBFILE                         ***************
     C                   Z-ADD     003           DBASE                          * DB ERROR 03 *
     C                   EXSR      *PSSR                                        ***************
     C                   ELSE
     C                   EVAL      DPBN = BBCSSN                                Beneficiary Customer
     C                   ENDIF
 
     C                   EVAL      DPNA = V_DPNA                                Nominal Amount
 
      ** Get Nominal Currency's Decimal Places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      NMCY          @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     NMCY          DBKEY
     C                   MOVE      'SDCURRPD'    DBFILE                         ***************
     C                   Z-ADD     004           DBASE                          * DB ERROR 04 *
     C                   EXSR      *PSSR                                        ***************
     C                   ENDIF
 
      ** Get Processing Type (PROT)
 
     C     KINVTP        KLIST
     C                   KFLD                    KCCYI             3
     C                   KFLD                    KINVT             3
     C                   EVAL      KCCYI = NMCY
     C                   EVAL      KINVT = SITP
 
     C     KINVTP        CHAIN     INVTPDF                            84
     C     *IN84         IFEQ      *Off
 
     C                   CALLB     'ZACCZ'
     C                   PARM      V_DPNA        ZAMT             15 0
     C                   PARM      LCPN          ZDCSDT            5 0
     C                   PARM      NCDAT         ZDCEDT            5 0
      ** Security Details
      ** Interest days adjustment
      ** Next Coupon Date (5P 0)
      ** Nominal currency decimal places (1P 0)
      ** Processing Type (1A)
     C                   PARM                    SECTY1
     C                   PARM      *Blank        DADJN             1
     C                   PARM                    NCDAT
     C                   PARM      A6NBDP        NomCcyDec         1 0
     C                   PARM                    PROT
      ** System Date Format (1A)
     C                   PARM                    BJDFIN
      * OUTPUTS
      ** Accrued Interest  (13P 0)
      ** Accrued Interest  (15P 1)
      ** No. of days (ZDAYS output)
      ** No. of days in interest year (ZDYYR output)
     C                   PARM                    ZDCINT           13 0
     C                   PARM                    ZDXINT           15 1
     C                   PARM                    ZDDAYS            5 0
     C                   PARM                    ZINTDD            5 0
     C                   EVAL      ECOUP = ZDCINT                               Estimated Coupon
 
      ** Write details to temporary file SERREQPD
 
     C                   WRITE     SERREQD0
 
     C                   ENDIF                                                  *IN84 ENDIF
     C                   ENDIF                                                  *IN85 ENDIF
 
     C                   ENDIF                                                  V_DPMV  ENDIF
 
     C                   READ      DPTMVDF                                86
     C                   ENDDO                                                  *IN86 ENDDO
 
     C                   ENDIF                                                  NCDAT ENDIF
 
     C                   ENDIF                                                  *IN87 ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/ZEVCD
      *****************************************************************
      *                                                               *
      *  ZEVCD  - Determine Event Control Date                        *
      *                                                               *
      *  Called By: COLPROC                                           *
      *  Calls: None                                                  *
      *  Input - ZZAPDT - ACCRUALS/PROFIT DATE FROM SDGELRPD/TABTB11  *   S01117
      *          ZZDNWD - DATE OF NEXT WORKING DAY FROM SDBANKPD OR   *   S01117
      *                   TABTB11                                     *   S01117
      *  Output - ECD (5,0) - EVENT CONTROL DATE                      *
      *                                                               *
      *  NOTE: This subroutine has been copied completely from ZSRSRC *
      *        and converted to ILE to get ECD needed for ZNCD.       *
      *                                                               *
      *****************************************************************
 
     C     ZEVCD         BEGSR                                                  *** ZEVCD  ***
 
     C                   Z-ADD     ZZAPDT        ZZAPDT            5 0                         S0111
     C                   Z-ADD     ZZDNWD        ZZDNWD            5 0                         S0111
     C*                                                                   S01117
      * EVENT CONTROL DATE IS ECD
      * IF ACCRUALS/PROFIT DATE GE DATE OF NEXT WORKING DAY
     C***********APDA      IFGE DNWD                                      S01117
     C***********DNWD      SUB  1         ECD                             S01117
     C     ZZAPDT        IFGE      ZZDNWD                                                      S0111
     C     ZZDNWD        SUB       1             ECD                                           S0111
      *  ECD = DATE OF NEXT WORKING DAY - 1
      * OTHERWISE ECD = ACCRUALS/PROFIT DATE
     C                   ELSE
     C***********          Z-ADDAPDA      ECD     50                      S01117
     C                   Z-ADD     ZZAPDT        ECD               5 0                         S0111
     C                   END
      *
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/PROCES
      *****************************************************************
      *                                                               *
      *  PROCES - Subroutine to do the Detail Processing.             *
      *                                                               *
      *  Called By: Main Processing                                   *
      *  Calls:                                                       *
      *  AUDIT  - Produce Audit Report and End Program                *
      *  REPORT - Process Report Lines                                *
      *  WP1END - Write End of Report                                 *
      *                                                               *
      *****************************************************************
 
     C     PROCES        BEGSR                                                  *** PROCES ***
 
      ***  Initialize totals
 
     C                   Z-ADD     0             TCNOM            14 0
     C                   Z-ADD     0             TCECOU           15 0
     C                   Z-ADD     0             TSNOM            14 0
     C                   Z-ADD     0             TSECOU           15 0
 
      ***  Read first record from File.
 
     C     *LOVAL        SETLL     SERREQD1
     C                   READ      SERREQD1                               89
 
      ***  If End of Records, (*IN89), Perform: Audit Reporting (No
      ***  Records).
 
     C******IN89         IFEQ      *ON                                                       BUG8799
     C     *IN89         IFEQ      *OFF                                                      BUG8799
     C**********         EXSR      AUDIT                                                     BUG8799
     C**********         ELSE                                                                BUG8799
     C                   ADD       DPNA          TCNOM
     C                   ADD       ECOUP         TCECOU
                                                                                             BUG8799
      ** Add 1 working day from Midas rundate.                                               BUG8799
                                                                                             BUG8799
     C     BJRDNB        ADD       1             NextDay           5 0                       BUG8799
     C                   MOVE      DATE          FDATE             5 0                       BUG8799
                                                                                             BUG8799
      ** Generate 'No Details' pages if there are days in between                            BUG8799
      ** current rundate and 1st Coupon Due Date read.                                       BUG8799
                                                                                             BUG8799
     C                   DOW       NextDay < FDATE                                           BUG8799
                                                                                             BUG8799
     C                   CALLB     'ZDATE2'                                                  BUG8799
     C                   PARM                    NextDay                                     BUG8799
     C                   PARM                    BJDFIN                                      BUG8799
     C                   PARM                    ZDATE                                       BUG8799
     C                   PARM                    ZADATE                                      BUG8799
     C                   EVAL      SCDDAT = ZADATE                              Coupon Due DaBUG8799
                                                                                             BUG8799
      **  Write out "No Details" page.                                                       BUG8799
                                                                                             BUG8799
     C                   WRITE     HEADPY                                                    BUG8799
     C                   WRITE     NODETLS                                                   BUG8799
                                                                                             BUG8799
      ** Add 1 day from day printed.                                                         BUG8799
                                                                                             BUG8799
     C                   ADD       1             NextDay                                     BUG8799
                                                                                             BUG8799
     C                   ENDDO                                                               BUG8799
                                                                                             BUG8799
      ** Write header for 1st Record read.                                                   BUG8799
                                                                                             BUG8799
     C                   MOVE      DATE          WDATE             5 0                       BUG8799
     C                   CALLB     'ZDATE2'                                                  BUG8799
     C                   PARM                    WDATE                                       BUG8799
     C                   PARM                    BJDFIN                                      BUG8799
     C                   PARM                    ZDATE             6 0                       BUG8799
     C                   PARM                    ZADATE            7                         BUG8799
     C                   EVAL      SCDDAT = ZADATE                              Coupon Due DaBUG8799
     C                   WRITE     HEADPY                                                    BUG8799
                                                                                             BUG8799
     C                   ENDIF
 
      ***  Do Until End of File.
 
     C     *IN89         DOWEQ     *Off
 
      *** Save current Customer and Security being printed
 
     C                   MOVE      DPBN          ODPBN            10
     C                   MOVEL     SESN          OSESN            10
     C                   MOVE      DATE          ODATE             5
 
      ***  Count records read.
 
     C**********         ADD       1             RCOUNT            5 0                       BUG8799
 
      ***  Process Report Lines.
 
     C                   EXSR      REPORT
 
      ***  Read next record.
 
     C                   READ      SERREQD1                               89
 
      ***  Process totals if there's a change in Currency or Security
 
     C                   EXSR      TOTALS
 
      ***  Check if there's a working day in between Coupon Due Dates.
 
     C     DATE          IFNE      ODATE
     C                   EXSR      CHEKDAT
     C                   ENDIF
 
      ***  End of Do Until End of Valid Records.
 
     C                   ENDDO
 
      ***  Write final records and Totals to Report.
 
     C                   EXSR      WP1END
                                                                                             BUG8799
      ** Add 1 working day from last Coupon Due Date read.                                   BUG8799
                                                                                             BUG8799
     C                   MOVE      ODATE         NextDay                                     BUG8799
     C                   ADD       1             NextDay                                     BUG8799
                                                                                             BUG8799
      ** Generate 'No Details' pages if there are working days in                            BUG8799
      ** between last Coupon Due Date printed and last working day                           BUG8799
      ** for report.                                                                         BUG8799
                                                                                             BUG8799
     C                   DOW       NextDay <= LastDay                                        BUG8799
                                                                                             BUG8799
     C                   CALLB     'ZDATE2'                                                  BUG8799
     C                   PARM                    NextDay                                     BUG8799
     C                   PARM                    BJDFIN                                      BUG8799
     C                   PARM                    ZDATE                                       BUG8799
     C                   PARM                    ZADATE                                      BUG8799
     C                   EVAL      SCDDAT = ZADATE                              Coupon Due DaBUG8799
                                                                                             BUG8799
      **  Write out "No Details" page.                                                       BUG8799
                                                                                             BUG8799
     C                   WRITE     HEADPY                                                    BUG8799
     C                   WRITE     NODETLS                                                   BUG8799
                                                                                             BUG8799
      ** Add 1 working day from working day printed.                                         BUG8799
                                                                                             BUG8799
     C                   ADD       1             NextDay                                     BUG8799
                                                                                             BUG8799
     C                   ENDDO                                                               BUG8799
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/TOTALS
      *****************************************************************
      *                                                               *
      *  TOTALS - Process Totals for change in customer or security.  *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *  WP1REC - Format and Write a Detail Record to the Report      *
      *                                                               *
      *****************************************************************
 
     C     TOTALS        BEGSR                                                  *** TOTALS ***
 
      ***  Compute totals for customer
 
      ***  Add customer totals to security totals
 
     C     DPBN          IFNE      ODPBN
     C     SESN          ORNE      OSESN
     C     DATE          ORNE      ODATE
     C     *IN89         OREQ      *On
     C                   ADD       TCNOM         TSNOM
     C                   ADD       TCECOU        TSECOU
 
      ***  Format totals for printing
 
     C                   Z-ADD     TCNOM         SSTNOM                         Cust Tot Nominal Amt
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      NMCY          @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     TCECOU        @@IAMT
     C                   CALLB     'ZA1020'
     C                   PARM                    @@IAMT           15 0
     C                   PARM      21            @@CRET            2 0
     C                   PARM      A6NBDP        @@CDP             1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      ','           BNTHSP            1
     C                   PARM      *Blanks       @@ADSP           21
     C                   EVAL      SSTESC = @@ADSP                              Cust Tot Est Coupon
 
      ***  Write out the totals
 
     C                   Z-ADD     3             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
 
     C                   WRITE     SUBTOT
 
      ***  Initialize customer totals for new customer
 
     C                   Z-ADD     0             TCNOM
     C                   Z-ADD     0             TCECOU
 
      ***  Add to new customer's totals
 
     C                   ADD       DPNA          TCNOM
     C                   ADD       ECOUP         TCECOU
 
      ***  Accumulate totals for same beneficiary
 
     C                   ELSE
     C                   ADD       DPNA          TCNOM
     C                   ADD       ECOUP         TCECOU
     C                   ENDIF
 
      ***  Compute totals for security
 
     C     SESN          IFNE      OSESN
     C     DATE          ORNE      ODATE
     C     *IN89         OREQ      *On
 
      ***  Format totals for printing
 
     C                   Z-ADD     TSNOM         STTNOM                         Secu Tot Nominal Amt
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      NMCY          @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     TSECOU        @@IAMT
     C                   CALLB     'ZA1020'
     C                   PARM                    @@IAMT           15 0
     C                   PARM      21            @@CRET            2 0
     C                   PARM      A6NBDP        @@CDP             1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      ','           BNTHSP            1
     C                   PARM      *Blanks       @@ADSP           21
     C                   EVAL      STTESC = @@ADSP                              Secu Tot Est Coupon
 
      ***  Write out the totals
 
     C                   Z-ADD     2             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
 
     C                   WRITE     SECTOT
 
      ***  Initialize security totals for new security
 
     C                   Z-ADD     0             TSNOM
     C                   Z-ADD     0             TSECOU
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/CHEKDAT
      *****************************************************************
      *                                                               *
      *  CHEKDAT - Check for working day in between Coupon Due Dates  *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *  WP1REC - Format and Write a Detail Record to the Report      *
      *                                                               *
      *****************************************************************
 
     C     CHEKDAT       BEGSR                                                  **  CHEKDAT **
 
      ***  Print End of Report footer for due date previously read
 
     C                   MOVE      ODATE         WODATE            5 0
     C                   CALLB     'ZDATE2'
     C                   PARM                    WODATE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   EVAL      SDUDAT = ZDATE                               Old Coupon Due Date
 
     C                   Z-ADD     2             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
 
     C                   WRITE     TRAILPY
 
      ***  Print No Details page for each day in between Coupon
      ***  Due Dates read from file.
 
     C                   MOVE      DATE          WDATE             5 0
     C                   MOVE      ODATE         InputDay          5 0
 
     C     InputDay      ADD       1             OutputDay         5 0
 
     C                   DOW       OutputDay < WDATE
      ***  If next working day from old Coupon Due Date is not current
      ***  Coupon Due Date read, print No Details page for this working day
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    OutputDay
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   EVAL      SCDDAT = ZADATE                              Coupon Due Date
 
      ***  Write out header for Coupon Due Date with no records.
 
     C                   WRITE     HEADPY
     C                   WRITE     NODETLS
     C                   ADD       1             OutputDay
 
     C                   ENDDO
 
      ***  Print header for current Coupon Due Date read
 
     C                   IF        OutputDay = WDATE
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    OutputDay
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   EVAL      SCDDAT = ZADATE                              Coupon Due Date
 
     C                   WRITE     HEADPY
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/REPORT
      *****************************************************************
      *                                                               *
      *  REPORT - Process Report Lines.                               *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *  WP1REC - Format and Write a Detail Record to the Report      *
      *                                                               *
      *****************************************************************
 
     C     REPORT        BEGSR                                                  *** REPORT ***
 
      ***  Write out the record.
 
     C                   EXSR      WP1REC
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/WP1REC
      *****************************************************************
      *                                                               *
      *  WP1REC - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls:                                                       *
      *                                                               *
      *****************************************************************
 
     C     WP1REC        BEGSR                                                  *** WP1REC ***
 
      ** Perform any formatting before printing. Move SERREQL0 details to report fields.
 
     C                   MOVE      DATE          WDATE             5 0
     C                   CALLB     'ZDATE2'
     C                   PARM                    WDATE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   EVAL      SCDDAT = ZADATE                              Coupon Due Date
 
     C                   EVAL      SSESN = SESN                                 Security Shortname
     C                   EVAL      SISNO = ISNO                                 ISIN No.
     C                   EVAL      SSRPN = SRPN                                 Security Report Name
     C                   EVAL      SCCY  = NMCY                                 Currency
     C                   EVAL      SCRATE = CPNR                                Coupon Rate
     C                   EVAL      SDEPOS = DPID                                Customer Shortname
     C                   EVAL      SDLNO = DLNOR                                Deal Number Repo
 
     C                   SELECT                                                 Transaction Type
     C                   WHEN      DPMV = 'RR'
     C                   EVAL      STRTYP = 'Reverse Repo   '
     C                   WHEN      DPMV = 'RP'
     C                   EVAL      STRTYP = 'Live Repo      '
     C                   WHEN      DPMV = 'BB'
     C                   EVAL      STRTYP = 'Stock Borrowing'
     C                   WHEN      DPMV = 'BL'
     C                   EVAL      STRTYP = 'Stock Lending  '
     C                   ENDSL
 
      ** Convert Date In (6,0) to Midas day number (5,0) and then
      ** convert to DDMMMYY format
 
     C                   CALLB     'ZA0270'
     C                   PARM                    DATIN
     C                   PARM                    BJDFIN
     C                   PARM      *Blank        @@RTN             1
     C                   PARM                    @@DAYN            5 0
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    @@DAYN
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   EVAL      SDATIN =      ZADATE                         Date In
 
      ** Convert Date Out (6,0) to Midas day number (5,0) and then
      ** convert to DDMMMYY format
 
     C                   CALLB     'ZA0270'
     C                   PARM                    DATOUT
     C                   PARM                    BJDFIN
     C                   PARM      *Blank        @@RTN             1
     C                   PARM                    @@DAYN            5 0
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    @@DAYN
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   EVAL      SDATOU =      ZADATE                         Date Out
 
     C                   EVAL      SBENEF =      DPBN                           Beneficiary Customer
     C                   Z-ADD     DPNA          SNOAMT                         Nominal Amount
 
      ** Format Estimated Coupon with currency's number of decimal places
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      NMCY          @CCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   Z-ADD     ECOUP         @@IAMT
     C                   CALLB     'ZA1020'
     C                   PARM                    @@IAMT           15 0
     C                   PARM      21            @@CRET            2 0
     C                   PARM      A6NBDP        @@CDP             1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      ','           BNTHSP            1
     C                   PARM      *Blanks       @@ADSP           21
     C                   EVAL      SESTCO = @@ADSP                              Estimated Coupon
 
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
 
     C                   Z-ADD     3             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ***  Write out Detail Record.
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/WP1END
      *****************************************************************
      *                                                               *
      *  WP1END - Subroutine to Write End of Report.                  *
      *                                                               *
      *  Called By: PROCES                                            *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     WP1END        BEGSR                                                  *** WP1END ***
 
      ***  Print End of Report footer for last due date read
 
     C                   MOVE      DATE          WDATE             5 0
     C                   CALLB     'ZDATE2'
     C                   PARM                    WDATE
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   EVAL      SDUDAT = ZDATE                               Old Coupon Due Date
 
      ***  Check that sufficient lines remain for the Format. If not,
      ***  write out the Main Headings on a new page.
 
     C                   Z-ADD     2             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ***  Write out Total Format.
 
     C                   WRITE     TRAILPY
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/AUDIT
      *****************************************************************
      *                                                               *
      *  AUDIT  - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, PROCES, *PSSR                    *
      *  Calls: None.                                                 *
      *                                                               *
      *****************************************************************
 
     C     AUDIT         BEGSR                                                  *** AUDIT  ***
 
      ***  If there is a DB Error, Output the DB Error Information.                          BUG8799
                                                                                             BUG8799
     C     *INU7         IFEQ      *ON                                                       BUG8799
                                                                                             BUG8799
      ***  Output Report Header and File Controls.
 
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
     C                   WRITE     DBERROR
      **********                                                                             BUG8799
      ***  If there is a DB Error, Output the DB Error Information.                          BUG8799
      **********                                                                             BUG8799
     C******INU7         IFEQ      *ON                                                       BUG8799
     C**********         WRITE     DBERROR                                                   BUG8799
     C**********         ELSE                                                                BUG8799
 
      ***  Or, if no records read, Output "No Details" message.
 
     C*****RCOUNT        IFEQ      0                                                         BUG8799
     C**********         WRITE     NODTLS                                                    BUG8799
     C**********         ENDIF                                                               BUG8799
     C                   ENDIF
 
      ***  End Program and Return.
 
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR                                                  ** *PSSR **
 
      ***  Check to see that *PSSR has not already been called.
 
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
 
     C     *DTAARA       DEFINE    LDA           WLDA            256
     C     *LOCK         IN        WLDA
     C                   MOVEL     LDA           WLDA
     C                   OUT       WLDA
 
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   EXSR      AUDIT
     C                   ENDIF
 
      ***  If *PSSR already run, then just end the program here.
 
     C                   SETON                                        U7U8LR
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/RCFP1
      *****************************************************************
      *                                                               *
      *  RCFP1  - Subroutine to register the P1 Printer File via RCF. *
      *                                                               *
      *****************************************************************
 
     C     RCFP1         BEGSR                                                   *** RCFP1  ***
 
      ***  Ensure Report Spool File recorded by RCF.
 
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
 
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ               5
     C                   PARM                    SENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
 
      ***  If Error occurs during ZSFILE processing, then return to the
      ***  Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/RCFAU
      *****************************************************************
      *                                                               *
      *  RCFAU  - Subroutine to register the AU Printer File via RCF. *
      *                                                               *
      *****************************************************************
 
     C     RCFAU         BEGSR                                                   *** RCFAU  ***
 
      ***  Ensure Audit Spool File recorded by RCF.
 
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
 
     C                   CALL      'ZSFILE'
     C                   PARM      PSEQ          SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
 
      ***  If Error occurs during ZSFILE processing, then return to the
      ***  Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2005
