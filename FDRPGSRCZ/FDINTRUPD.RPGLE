     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FD MM Int. Rates Database Update')
      *****************************************************************
      *                                                               *
      *  Midas - Fixed Data Module                                    *
      *                                                               *
      *  FDINTRUPD - MM Interest Rates Database Update                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG14691           Date 28Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP058             Date 01May01               *
      *                 CSD006             Date 13Jul00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP005  *CREATE    Date 17Oct98               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG14691 - Looping problem occurs when A6MMSD is 0           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP058 - Full API for Money Market Interest Rates            *
      *  CSD006 - Market Data Feeds                                   *
      *  CAP005 - Conversion of Citydealer Rates upload to use APIs   *
      *                                                               *
      *****************************************************************
     FFDINTRLL  IF   E           K DISK
     FFDTTOTLL  UF   E           K DISK
     F                                     COMMIT
     FFDINTULL  UF A E           K DISK
     F                                     COMMIT
     F                                     RENAME(FDINTRP0:FDINTUP0)
     FSDMDFRL0  UF   E           K DISK    INFSR(*PSSR)                         CSD006
     F                                     COMMIT                               CSD006
     FSDMDFIL0  UF   E           K DISK    INFSR(*PSSR)                         CSD006
     F                                     COMMIT                               CSD006
     FSDMDFHPD  O    E             DISK    INFSR(*PSSR)                         CSD006
     F                                     COMMIT                               CSD006
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structure.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
                                                                                CAP058
      **---------------------------------------------------------------         CAP058
      ** The following /COPY line includes the definitions for error and        CAP058
      ** warning message arrays.                                                CAP058
     D/COPY ZACPYSRC,ERR_ARRAYS                                                 CAP058
      **---------------------------------------------------------------         CAP058
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
 
      **  Externally described data structure for valid MM Int. Rates record.
     D FDVINT        E DS                  EXTNAME(FDVINTRPD)
     D  @@BR                  31    156P 7
     D                                     DIM(21)
     D  @@LR                 157    282P 7
     D                                     DIM(21)
     D  @@EX                 283    366A                                        CAP058
     D                                     DIM(21)                              CAP058
                                                                                CAP058
      ** Interest Rate Detail data structure                                    CAP058
     D FDINTPP       E DS                  EXTNAME(FDINTRPP)                    CAP058
                                                                                CAP058
      ** Current Interest Rate in File Format (For Timestamp checking)          CAP058
     D ChkIRFilFmt   E DS                  EXTNAME(FDVINTRPD)                   CAP058
     D                                     PREFIX(C)                            CAP058
 
 
     D @@MTH           S              3    DIM(12) CTDATA PERRCD(12)            MONTH S/NAMES
     D @@PTP           S              1    DIM(24) CTDATA PERRCD(24)            PERIOD TYPES
     D @@PRD           S              2  0 DIM(24) CTDATA PERRCD(24)            PERIODS
     D @@PER           S              2  0 DIM(24) CTDATA PERRCD(24)            PERIOD
 
      *
      ** DATA AREA TO HOLD MIDAS RUN DATE IN DDMMMYY FORMAT
      *
     D                 DS
     D  UUMRDT                 1      7
     D  @@DD                   1      2  0
     D  @@MMM                  3      5
     D  @@YY                   6      7  0
      ** Data Structure to hold RUNDAY number formatted to                                  BUG14691
      ** CCYYMMDD                                                                           BUG14691
     D                 DS                                                                   BUG14691
     D  WRdate                 1      8  0                                                  BUG14691
     D  WRcc                   1      2  0                                                  BUG14691
     D  WRyy                   3      4  0                                                  BUG14691
     D  WRmm                   5      6  0                                                  BUG14691
     D  WRdd                   7      8  0                                                  BUG14691
      *
      ** DATA AREA TO HOLD LAST CHANGE DATE
      *
     D                 DS
     D  @@CHGD                 1      6  0
     D  @@CHGDY                1      2  0
     D  @@CHGMN                3      4  0
     D  @@CHGYR                5      6  0
 
                                                                                CAP058
      ** Interest Rates Validation Workfields                                   CAP058
     D ValWrkFlds    E DS                  EXTNAME(FDWINTRPD)                   CAP058
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                              CSC011
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC011
      ** External DS for Switchable Features                                                  CSC011
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
 
      ** Before image of the interest rate details                              CSD006
     D WBFRIMG         S            800A                                        CSD006
                                                                                CSD006
      ** Time Stamp                                                             CAP058
     D TimeStamp       S             26Z                                        CAP058
                                                                                CAP058
      ** Period Date expressed in YYYYMMDD                                      CAP058
     D PPERDT          S              8S 0                                      CAP058
                                                                                CAP058
      ** Period Date in Midas Day Number format                                 CAP058
     D PPERDN          S              5  0                                      CAP058
                                                                                CAP058
      ** Other work fields                                                      CAP058
     D WACTN           S              1A                                        CAP058
     D WCCY            S              3A                                        CAP058
     D OKACTION        S              1A                                        CAP058
     D OKCCY           S              1A                                        CAP058
                                                                                CAP058
      ** Index for arrays of error message ids etc                              CAP058
     D Idx             S              3P 0                                      CAP058
                                                                                              CSC011
      ** Defined fields for Enhancement CSC011                                                CSC011
                                                                                              CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D PTimeStamp      S             26A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D***PDealNum        S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PDealNum        S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
                                                                                CAP058
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
                                                                                CAP058
      ** Ensure transaction has not been updated by another workstation         CAP058
      ** if so, bypass updating and return to calling program                   CAP058
                                                                                CAP058
     C                   EXSR      SrCHKUPD                                     CAP058
      *
      * Access currency data
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      FYCCY         @KEYCY            3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      * Database error.
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     FYCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '001'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Access FDINTRLL to see if details already exist for currency
      *
     C     FYCCY         SETLL     FDINTRLL                               99
      *
      ** If details do not exist write records with new rates
      *
     C     *IN99         IFEQ      *OFF
     C                   EXSR      INTRINS
      *
      ** If details exist update with new rates
      *
     C                   ELSE
     C                   EXSR      INTRAMD
     C                   ENDIF
                                                                                CSD006
      ** Update Market Data Feed Tolerance Exceeded Indicator                   CSD006
                                                                                CSD006
     C                   IF        (CSD006 = 'Y') AND (FYTLEX = 'Y')            CSD006
     C                   EXSR      SrMDFUPD                                     CSD006
     C                   ENDIF                                                  CSD006
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   CALLB     'FDINTRLOG'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    FDVINT                                       CSC011
     C                   PARM                    ValWrkFlds                                   CSC011
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *Blanks                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'FDINTR'                                       CSC011
     C                   IF        WAPIT = 'B'                                                CSC011
     C                   EVAL      APFOTRANID = HWBOFR                                        CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      APFOTRANID = HWLEFR                                        CSC011
     C                   ENDIF                                                                CSC011
     C                   EVAL      APRPRLOCN  = HWREPA                                        CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
     C                   MOVEL     HWCCY         PDealNum                                     CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *Blanks       PTimestamp                                   CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      * Exit from program.
      *
     C                   RETURN
     C****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      * INTRINS - Insert new MM Interest Rates records.              *
      *                                                              *
      ****************************************************************
     C     INTRINS       BEGSR
      *
      ** Obtain header record for update
      *
     C                   MOVE      *BLANKS       FDTTOTK          12
     C                   MOVEL     'HW'          FDTTOTK
     C     FDTTOTK       CHAIN     FDTTOTLL                           97
      *
      ** Error if record not found
      *
     C     *IN97         IFEQ      *ON
     C                   MOVEL     FDTTOTK       DBKEY                          ** ERROR 05 **
     C                   MOVE      'FDTTOTLL'    DBFILE                         ** DATABASE **
     C                   MOVE      '002'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
                                                                                CAP058
      ** DB error when the action code is not 'Insert'                          CAP058
                                                                                CAP058
     C     FYCHTP        IFNE      'I'                                          CAP058
     C                   MOVEL     FYCCY         DBKEY                          CAP058
     C                   MOVEL     'FDINTDLL'    DBFILE                         CAP058
     C                   Z-ADD     7             DBASE                          CAP058
     C                   EXSR      SRERR                                        CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
      ** Generate Timestamp                                                     CAP058
                                                                                CAP058
     C                   CALLB     'ZAGENTMSTM'                                 CAP058
     C                   PARM                    TimeStamp                      CAP058
      *
      ** Output to interest rates file
      *
     C                   TIME                    UUTIME            6 0
     C                   Z-ADD     1             #X                2 0
     C     #X            DOWLT     22
                                                                                CSD006
      ** Clear before image of interest rate details for action insert          CSD006
                                                                                CSD006
     C                   MOVE      *BLANKS       WBFRIMG                        CSD006
      *
      ** Set up common fields
      *
     C                   MOVE      'HW'          HWRCID
     C                   MOVE      *BLANK        HWDLTF
     C                   Z-ADD     @@DD          HWDLUP
     C                   MOVE      @@MMM         HWMLUP
     C                   Z-ADD     @@YY          HWYLUP
     C                   Z-ADD     UUTIME        HWTLUP
     C***********        MOVE      'A'           HWCHTP                         CAP058
     C                   MOVE      FYCHTP        HWCHTP                         CAP058
     C                   Z-ADD     BJRDNB        HWLCD
     C                   MOVEL     PsUSER        HWLUSI
     C                   MOVE      @@PER(#X)     HWPRD
     C                   Z-ADD     @@LR(#X)      HWLDRT
     C                   Z-ADD     @@BR(#X)      HWBRRT
     C                   Z-ADD     @@CHGD        HWCHGD
     C                   MOVE      @@PTP(#X)     HWTPRD
     C***********        MOVE      *BLANKS       HWPRDX                         CAP058
     C                   MOVE      @@EX(#X)      HWPRDX                         CAP058
     C                   MOVE      FYCCY         HWCCY
      *
      * Populate Front office ID with the Front Office ID of SDCURRPD
     C                   MOVEL     A6BOID        HWBOFR                         CAP058
     C                   MOVEL     A6LEID        HWLEFR                         CAP058
      *
     C                   MOVEL     FYREPA        HWREPA                         CAP058
     C                   MOVEL     FYREPA        HWREPA                         CAP058
     C                   MOVEL     TimeStamp     HWTMESTMP                      CSD006
                                                                                CSD006
      ** Setup MDF fields                                                       CSD006
                                                                                CSD006
     C     CSD006        IFEQ      'Y'                                          CSD006
     C                   EXSR      SrSETMDF                                     CSD006
     C                   ELSE                                                   CSD006
                                                                                CSD006
      ** Clear MDF fields                                                       CSD006
                                                                                CAP058
     C                   CLEAR                   HWBOTM                         CAP058
     C                   CLEAR                   HWLETM                         CAP058
     C                   EVAL      HWBOAF = *BLANK                              CAP058
     C                   EVAL      HWBORP = *BLANK                              CAP058
     C                   EVAL      HWBOTS = *ZERO                               CAP058
     C                   EVAL      HWLEAF = *BLANK                              CAP058
     C                   EVAL      HWLERP = *BLANK                              CAP058
     C                   EVAL      HWLETS = *ZERO                               CAP058
     C                   ENDIF                                                  CAP058
      *
      ** Do period date calculation
      *
     C                   EXSR      MM1003
      *
     C                   Z-ADD     @@PDAT        HWPRDD
     C                   Z-ADD     PPERDN        HWPRDN                         CAP058
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        (HWBOFR = *BLANKS) AND                                     CSC011
     C                             (HWLEFR = *BLANKS)                                         CSC011
                                                                                              CSC011
     C                   IF        (A6BOID = *BLANKS) AND                                     CSC011
     C                             (A6LEID = *BLANKS)                                         CSC011
     C                   EVAL      HWBOFR = 'MD' + HWCCY                                      CSC011
     C                   EVAL      HWLEFR = 'MD' + HWCCY                                      CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      HWBOFR = A6BOID                                            CSC011
     C                   EVAL      HWLEFR = A6LEID                                            CSC011
     C                   ENDIF                                                                CSC011
     C                                                                                        CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      *
     C                   WRITE     FDINTUP0
                                                                                CSD006
      ** Update Market Data Feed Rate/Price History file                        CSD006
                                                                                CSD006
     C                   IF        (CSD006 = 'Y') AND (FYDTFR <> *BLANK)        CSD006
                                                                                CSD006
      ** Write history for borrow and lending requests                          CSD006
                                                                                CSD006
     C                   SELECT                                                 CSD006
     C     WAPIT         WHENEQ    'B'                                          CSD006
     C                   EXSR      SrHISBRW                                     CSD006
     C     WAPIT         WHENEQ    'L'                                          CSD006
     C     WAPIT         OREQ      *BLANKS                                      CSD006
     C                   EXSR      SrHISLND                                     CSD006
     C                   ENDSL                                                  CSD006
     C                   ENDIF                                                  CSD006
     C                   ADD       1             #X
     C                   ENDDO
      *
     C                   ADD       21            NINS
     C                   UPDATE    TABLETXF
      *
     C*******************                                                       CAP058
     C***Access*header*record                                                   CAP058
     C*******************MOVE      *BLANKS       FDTTOTK                        CAP058
     C*******************MOVEL     '20'          FDTTOTK                        CAP058
     C*****FDTTOTK*******CHAIN     FDTTOTLL                           97        CAP058
     C*******************                                                       CAP058
     C***Error*if*record*not found                                              CAP058
     C*******************                                                       CAP058
     C******IN97*********IFEQ      *ON                                          CAP058
     C*******************MOVEL     FDTTOTK       DBKEY          ***ERROR*06***  CAP058
     C*******************MOVE      'FDTTOTLL'    DBFILE         ***DATABASE***  CAP058
     C*******************MOVE      '003'         DBASE                          CAP058
     C*******************EXSR      SRERR                                        CAP058
     C*******************ENDIF                                                  CAP058
     C*******************                                                       CAP058
     C***Update*header***                                                       CAP058
     C*******************                                                       CAP058
     C*******************ADD       1             NAMD                           CAP058
     C*******************UPDATE    TABLETXF                                     CAP058
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* INTRAMD - Update existing MM Interest Rates records.         *
     C*                                                              *
     C****************************************************************
     C     INTRAMD       BEGSR
      *
      ** Obtain header record for update
      *
     C                   MOVE      *BLANKS       FDTTOTK          12
     C                   MOVEL     'HW'          FDTTOTK
     C     FDTTOTK       CHAIN     FDTTOTLL                           97
      *
      ** Error if record not found
      *
     C     *IN97         IFEQ      *ON
     C                   MOVEL     FDTTOTK       DBKEY                          ** ERROR 02 **
     C                   MOVE      'FDTTOTLL'    DBFILE                         ** DATABASE **
     C                   MOVE      '004'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Update interest rates file
      *
     C     FYCCY         SETLL     FDINTULL
     C     FYCCY         READE     FDINTULL                               98
                                                                                CAP058
      ** Generate Timestamp                                                     CAP058
                                                                                CAP058
     C                   CALLB     'ZAGENTMSTM'                                 CAP058
     C                   PARM                    TimeStamp                      CAP058
      *
     C                   TIME                    UUTIME
     C                   Z-ADD     1             #X
     C     #X            DOWLT     22
                                                                                CSD006
      ** Save before image of the interest rate details                         CSD006
                                                                                CSD006
     C                   MOVEL     FDINTPP       WBFRIMG                        CSD006
      *
      ** Error if record not found
      *
     C     *IN98         IFEQ      *ON
     C                   MOVEL     FYCCY         DBKEY                          ** ERROR 03 **
     C                   MOVE      'FDINTULL'    DBFILE                         ** DATABASE **
     C                   MOVE      '005'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
                                                                                CAP058
      ** DB error when the record found is still active and the                 CAP058
      ** action is 'Insert'                                                     CAP058
                                                                                CAP058
     C                   IF        (*IN98 = FALSE) AND (HWDLTF = *BLANK) AND    CAP058
     C                             (FYCHTP = 'I')                               CAP058
     C                   MOVEL     FYCCY         DBKEY                          CAP058
     C                   MOVEL     'FDINTULL'    DBFILE                         CAP058
     C                   Z-ADD     8             DBASE                          CAP058
     C                   EXSR      SRERR                                        CAP058
     C                   ENDIF                                                  CAP058
      *
      ** Set up common fields
      *
     C                   MOVE      'HW'          HWRCID
     C***********        MOVE      *BLANK        HWDLTF                         CAP058
     C     FYCHTP        IFEQ      'D'                                          CAP058
     C                   MOVE      '*'           HWDLTF                         CAP058
     C                   ELSE                                                   CAP058
     C                   MOVE      *BLANK        HWDLTF                         CAP058
     C                   ENDIF                                                  CAP058
     C                   Z-ADD     @@DD          HWDLUP
     C                   MOVE      @@MMM         HWMLUP
     C                   Z-ADD     @@YY          HWYLUP
     C                   Z-ADD     UUTIME        HWTLUP
     C***********        MOVE      'A'           HWCHTP                         CAP058
     C                   MOVE      FYCHTP        HWCHTP                         CAP058
     C                   Z-ADD     BJRDNB        HWLCD
     C                   MOVEL     PsUSER        HWLUSI
     C                   Z-ADD     @@LR(#X)      HWLDRT
     C                   Z-ADD     @@BR(#X)      HWBRRT
     C                   MOVEL     @@EX(#X)      HWPRDX                         CAP058
     C                   Z-ADD     @@CHGD        HWCHGD
     C                   MOVE      FYCCY         HWCCY
      *
      * Populate Front office ID with the Front Office ID of SDCURRPD
     C                   MOVEL     A6BOID        HWBOFR                         CAP058
     C                   MOVEL     A6LEID        HWLEFR                         CAP058
      *
     C                   MOVEL     FYREPA        HWREPA                         CAP058
     C                   MOVEL     TimeStamp     HWTMESTMP                      CAP058
                                                                                CAP058
      ** Setup MDF fields                                                       CAP058
                                                                                CSD006
     C     CSD006        IFEQ      'Y'                                          CSD006
     C                   EXSR      SrSETMDF                                     CSD006
     C                   ELSE                                                   CSD006
                                                                                CAP058
      ** Clear MDF fields                                                       CAP058
                                                                                CAP058
     C                   CLEAR                   HWBOTM                         CAP058
     C                   CLEAR                   HWLETM                         CAP058
     C                   EVAL      HWBOAF = *BLANK                              CAP058
     C                   EVAL      HWBORP = *BLANK                              CAP058
     C                   EVAL      HWBOTS = *ZERO                               CAP058
     C                   EVAL      HWLEAF = *BLANK                              CAP058
     C                   EVAL      HWLERP = *BLANK                              CAP058
     C                   EVAL      HWLETS = *ZERO                               CAP058
     C                   ENDIF                                                  CAP058
      *
      ** Do period date calculation
      *
     C                   EXSR      MM1003
      *
     C                   Z-ADD     @@PDAT        HWPRDD
     C                   Z-ADD     PPERDN        HWPRDN                         CAP058
      *
     C                   UPDATE    FDINTUP0
                                                                                CAP058
      ** Update Market Data Feed Rate/Price History file                        CAP058
                                                                                CAP058
     C                   IF        (CSD006 = 'Y') AND (FYDTFR <> *BLANK)        CSD006
                                                                                CSD006
      ** Write history for borrow and lending requests                          CSD006
                                                                                CSD006
     C                   SELECT                                                 CSD006
     C     WAPIT         WHENEQ    'B'                                          CSD006
     C                   EXSR      SrHISBRW                                     CSD006
     C     WAPIT         WHENEQ    'L'                                          CSD006
     C     WAPIT         OREQ      *BLANKS                                      CSD006
     C                   EXSR      SrHISLND                                     CSD006
     C                   ENDSL                                                  CSD006
     C                   ENDIF                                                  CSD006
     C     FYCCY         READE     FDINTULL                               98
     C                   ADD       1             #X
     C                   ENDDO
      *
     C     FYCHTP        IFEQ      'I'                                          CAP058
     C                   ADD       21            NINS                           CAP058
     C                   ENDIF                                                  CAP058
      *                                                                         CAP058
     C     FYCHTP        IFEQ      'D'                                          CAP058
     C                   ADD       21            NDEL                           CAP058
     C                   ENDIF                                                  CAP058
      *                                                                         CAP058
     C     FYCHTP        IFEQ      'A'                                          CAP058
     C                   ADD       21            NAMD
     C                   ENDIF                                                  CAP058
      *                                                                         CAP058
     C                   UPDATE    TABLETXF
      *
      ** Access header record
      *
     C                   MOVE      *BLANKS       FDTTOTK
     C                   MOVEL     '20'          FDTTOTK
     C     FDTTOTK       CHAIN     FDTTOTLL                           97
      *
      ** Error if record not found
      *
     C     *IN97         IFEQ      *ON
     C                   MOVEL     FDTTOTK       DBKEY                          ** ERROR 04 **
     C                   MOVE      'FDTTOTLL'    DBFILE                         ** DATABASE **
     C                   MOVE      '006'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ** Update header
      *
     C     FYCHTP        IFEQ      'A'                                          CAP058
     C                   ADD       1             NAMD
     C                   ENDIF                                                  CAP058
     C                                                                          CAP058
     C                   UPDATE    TABLETXF
      *
     C                   ENDSR
      *****************************************************************         CAP058
      /EJECT                                                                    CAP058
      *****************************************************************         CAP058
      *                                                               *         CAP058
      * SrCHKUPD  - Check for Update by another Workstation           *         CAP058
      *                                                               *         CAP058
      *****************************************************************         CAP058
     C     SrCHKUPD      BEGSR                                                  CAP058
                                                                                CAP058
      ** Determine whether program is running interactively or in batch         CAP058
      ** (0 = batch 1 = interactive)                                            CAP058
                                                                                CAP058
     C                   CALLB     'ZARTVJOBA'                                  CAP058
     C                   PARM                    PRETURN           6            CAP058
     C                   PARM                    PTYPE             1            CAP058
                                                                                CAP058
      ** Allow access to transaction record by Front-Office ID when in Repair   CAP058
      ** mode for inserts . Set  *RTV module  parameter ModeofOp to   *FRONT    CAP058
      ** if the pgm is:  a) running in Interactive mode - PTYPE = 1             CAP058
      **                 b) action code is Insert - 'I'                         CAP058
      **                 c) front office id not blank                           CAP058
                                                                                CAP058
     C                   IF        (PTYPE = '1') AND (FYCHTP = 'I') AND         CAP058
     C                             (FYBOFR <> *BLANK) OR                        CAP058
     C                             (PTYPE = '1') AND (FYCHTP = 'I') AND         CAP058
     C                             (FYLEFR <> *BLANK)                           CAP058
     C                   EVAL      ModeOfOp = '*FRONT'                          CAP058
     C                   ELSE                                                   CAP058
                                                                                CAP058
      ** Otherwise, if running in batch use Front-Office ID                     CAP058
      **           (if insert)                                                  CAP058
      **           else, use Midas Deal Number                                  CAP058
                                                                                CAP058
     C                   IF        (PTYPE = '0') AND (FYCHTP = 'I')             CAP058
     C                   EVAL      ModeOfOp = '*FRONT'                          CAP058
     C                   ELSE                                                   CAP058
     C                   EVAL      ModeOfOp = *BLANK                            CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
      ** Front Office Id is used, pass front office id                          CAP058
                                                                                CAP058
     C     ModeOfOp      IFEQ      '*FRONT'                                     CAP058
     C     WAPIT         IFEQ      'B'                                          CAP058
     C                   EVAL      PFOTRID = FYBOFR                             CAP058
     C                   ELSE                                                   CAP058
     C                   EVAL      PFOTRID = FYLEFR                             CAP058
     C                   ENDIF                                                  CAP058
     C                   ENDIF                                                  CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
      ** Set default action code work field to 'N' so that if action code       CAP058
      ** is blank it will not be defaulted to 'E'.                              CAP058
                                                                                CAP058
     C                   EVAL      WDFTAC = 'N'                                 CAP058
                                                                                CAP058
      ** Call Retrieve Module                                                   CAP058
                                                                                CAP058
     C                   CALLB     'FDINTRRTV'                                  CAP058
     C                   PARM      *BLANK        RetCodeOut                     CAP058
     C                   PARM                    ModeOfOp          6            CAP058
     C                   PARM                    RespMode          1            CAP058
     C                   PARM      FYCHTP        WACTN                          CAP058
     C                   PARM      FYCCY         WCCY                           CAP058
     C                   PARM                    DDCYNM           32            CAP058
     C                   PARM                    PFOTRID          20            CAP058
     C                   PARM                    ChkIRFilFmt                    CAP058
     C                   PARM                    OKACTION                       CAP058
     C                   PARM                    OKCCY                          CAP058
     C                   PARM                    FldNameArr                     CAP058
     C                   PARM                    MsgIdArr                       CAP058
     C                   PARM                    MsgDtaArr                      CAP058
     C                   PARM                    Idx                            CAP058
     C                   PARM                    ValWrkFlds                     CAP058
                                                                                CAP058
      ** Check whether the record has been updated by another workstation by    CAP058
      ** looking into timestamps.                                               CAP058
      ** Processing varies according to mode program is running in.             CAP058
      ** In interacive mode simply check whether the timestamp field            CAP058
      ** has been updated since the original Trade was fetched by this          CAP058
      ** program.                                                               CAP058
      ** In batch (API input) check return parameters from Retrieve             CAP058
      ** module for errors, and send message to system operator.                CAP058
                                                                                CAP058
     C     PTYPE         IFEQ      '1'                                          CAP058
  131C                   IF        (CFYTMESTMP <> FYTMESTMP)                    CAP058
     C                   EVAL      @@RTCD = '*RECUPD'                           CAP058
     C                   RETURN                                                 CAP058
     C                   ENDIF                                                  CAP058
     C                   ELSE                                                   CAP058
     C                   IF        (OKACTION = 'N') OR (OKCCY = 'N')            CAP058
     C                   EVAL      @@RTCD = '*RECUPD'                           CAP058
     C                   Z-ADD     1             C                 2 0          CAP058
                                                                                CAP058
     C     C             DOWLE     ArrayMax                                     CAP058
     C     FldNameArr(C) ANDNE     *BLANKS                                      CAP058
     C                   MOVEL     *BLANKS       DBError                        CAP058
     C                   MOVEL     MsgIDArr(C)   DBError                        CAP058
     C                   EVAL      DBerror = 'Update error: ' + PFOTRID         CAP058
     C                   CALLB     'ZAMSGTOOPR'                                 CAP058
     C                   PARM                    MsgSndRtn        10            CAP058
     C                   PARM                    DBError         132            CAP058
     C                   PARM                    DummyMsgID        7            CAP058
     C                   PARM                    DummyMsgF        10            CAP058
     C                   EVAL      C = C + 1                                    CAP058
     C                   ENDDO                                                  CAP058
     C                   RETURN                                                 CAP058
                                                                                CAP058
     C                   ENDIF                                                  CAP058
     C                   ENDIF                                                  CAP058
                                                                                CAP058
     C                   ENDSR                                                  CAP058
      *****************************************************************         CAP058
      /EJECT                                                                    CAP058
      *****************************************************************         CAP058
      *                                                               *         CSD006
      * SrSETMDF  - Setup MDF Fields for Insert/Update                *         CSD006
      *                                                               *         CSD006
      *****************************************************************         CSD006
     C     SrSETMDF      BEGSR                                                  CSD006
                                                                                CSD006
      ** MDF Borrowing Rate Fields                                              CSD006
                                                                                CSD006
     C                   EVAL      HWBOTS = FYBOTS                              CSD006
     C                   EVAL      HWBOFR = FYBOFR                              CSD006
     C                   EVAL      HWBOAF = FYBOAF                              CSD006
     C                   EVAL      HWBORP = FYBORP                              CSD006
                                                                                CSD006
      ** MDF Lending Rate Fields                                                CSD006
                                                                                CSD006
     C                   EVAL      HWLETS = FYLETS                              CSD006
     C                   EVAL      HWLEFR = FYLEFR                              CSD006
     C                   EVAL      HWLEAF = FYLEAF                              CSD006
     C                   EVAL      HWLERP = FYLERP                              CSD006
                                                                                CSD006
      ** Update timestamp for both rates                                        CSD006
                                                                                CSD006
     C                   SELECT                                                 CSD006
                                                                                CSD006
      ** Borrowing                                                              CSD006
                                                                                CSD006
     C     WAPIT         WHENEQ    'B'                                          CSD006
     C                   MOVEL     TimeStamp     HWBOTM                         CSD006
                                                                                CSD006
      ** If insert, clear out lending  timestamp                                CSD006
                                                                                CSD006
     C     FYCHTP        IFEQ      'I'                                          CSD006
     C                   CLEAR                   HWLETM                         CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** Lending                                                                CSD006
                                                                                CSD006
     C     WAPIT         WHENEQ    'L'                                          CSD006
     C                   MOVEL     TimeStamp     HWLETM                         CSD006
                                                                                CSD006
      ** If insert, clear out borrowing timestamp                               CSD006
                                                                                CSD006
     C     FYCHTP        IFEQ      'I'                                          CSD006
     C                   CLEAR                   HWBOTM                         CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
      ** Update both timestamp when Data Feed Request Id is not                 CSD006
      ** entered or not defined on file                                         CSD006
                                                                                CSD006
     C                   OTHER                                                  CSD006
     C                   MOVEL     TimeStamp     HWBOTM                         CSD006
     C                   MOVEL     TimeStamp     HWLETM                         CSD006
     C                   ENDSL                                                  CSD006
                                                                                CSD006
      ** MDF Data Request Identifier                                            CSD006
                                                                                CSD006
     C                   EVAL      HWDTFR = FYDTFR                              CSD006
                                                                                CSD006
      ** MDF Tolerance Exceeded Indicator                                       CSD006
                                                                                CSD006
     C                   EVAL      HWTLEX = *BLANK                              CSD006
                                                                                CSD006
     C                   ENDSR                                                  CSD006
      *****************************************************************         CSD006
      /EJECT                                                                    CSD006
      *****************************************************************         CSD006
      *                                                               *         CSD006
      * SrHISBRW  - Updates Market Data Feed Rate/Price History File  *         CSD006
      *             for Borrow Request                                *         CSD006
      *                                                               *         CSD006
      *****************************************************************         CSD006
     C     SrHISBRW      BEGSR                                                  CSD006
                                                                                CSD006
     C                   MOVEL     FYBOFR        RHTREF                         CSD006
     C                   MOVEL     FYBOTS        RHDFTS                         CSD006
     C                   MOVEL     FYCCY         RHDITM                         CSD006
     C                   MOVEL     FYDTFR        RHDFRI                         CSD006
     C                   MOVEL     FYTLEX        RHTLEX                         CSD006
     C                   MOVEL     *BLANK        RHAUDT                         CSD006
     C                   MOVEL     'FDINTRPP'    RHFILE                         CSD006
     C                   MOVEL     WBFRIMG       RHBIMG                         CSD006
     C                   MOVEL     FDINTPP       RHAIMG                         CSD006
     C                   Z-ADD     BJRDNB        RHPRCD                         CSD006
                                                                                CSD006
      ** Write to file                                                          CSD006
                                                                                CSD006
     C                   WRITE     SDMDFHD0                                     CSD006
                                                                                CSD006
     C                   ENDSR                                                  CSD006
      *****************************************************************         CSD006
      /EJECT                                                                    CSD006
      *****************************************************************         CSD006
      *                                                               *         CSD006
      * SrHISLND  - Updates Market Data Feed Rate/Price History File  *         CSD006
      *             for Borrow Request                                *         CSD006
      *                                                               *         CSD006
      *****************************************************************         CSD006
     C     SrHISLND      BEGSR                                                  CSD006
                                                                                CSD006
     C                   MOVEL     FYLEFR        RHTREF                         CSD006
     C                   MOVEL     FYLETS        RHDFTS                         CSD006
     C                   MOVEL     FYCCY         RHDITM                         CSD006
     C                   MOVEL     FYDTFR        RHDFRI                         CSD006
     C                   MOVEL     FYTLEX        RHTLEX                         CSD006
     C                   MOVEL     *BLANK        RHAUDT                         CSD006
     C                   MOVEL     'FDINTRPP'    RHFILE                         CSD006
     C                   MOVEL     WBFRIMG       RHBIMG                         CSD006
     C                   MOVEL     FDINTPP       RHAIMG                         CSD006
     C                   Z-ADD     BJRDNB        RHPRCD                         CSD006
                                                                                CSD006
      ** Write to file                                                          CSD006
                                                                                CSD006
     C                   WRITE     SDMDFHD0                                     CSD006
                                                                                CSD006
     C                   ENDSR                                                  CSD006
      *****************************************************************         CSD006
      /EJECT                                                                    CSD006
      *****************************************************************         CSD006
      *                                                               *         CSD006
      * SrMDFUPD  - Updates Market Data Feed Detail Files             *         CSD006
      *                                                               *         CSD006
      *****************************************************************         CSD006
     C     SrMDFUPD      BEGSR                                                  CSD006
                                                                                CSD006
      ** Update MDF tolerance exceed ind. when data feed request identifier     CSD006
      ** is not blank and the tolerance exceeded indicator received is set      CSD006
      ** to 'Y'                                                                 CSD006
     C                   MOVEL     FYCCY         WKYDFI                         CSD006
     C     KYFLDL        CHAIN     SDMDFIL0                                     CSD006
                                                                                CSD006
     C                   IF        %FOUND(SDMDFIL0)                             CSD006
     C                   EVAL      MITOLX = 'Y'                                 CSD006
     C                   UPDATE    SDMDFID0                                     CSD006
                                                                                CSD006
     C     FYDTFR        CHAIN     SDMDFRL0                                     CSD006
                                                                                CSD006
     C                   IF        %FOUND(SDMDFRL0)                             CSD006
     C                   EVAL      MRTOLX = 'Y'                                 CSD006
     C                   UPDATE    SDMDFRD0                                     CSD006
     C                   ELSE                                                   CSD006
     C                   UNLOCK    SDMDFRL0                                     CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
     C                   ELSE                                                   CSD006
     C                   UNLOCK    SDMDFIL0                                     CSD006
     C                   ENDIF                                                  CSD006
                                                                                CSD006
     C                   ENDSR                                                  CSD006
     C*****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* MM1003 - Period Date Calculation                             *
     C*                                                              *
     C****************************************************************
     C     MM1003        BEGSR
      *
      ** Load fields required by MM1003 for period date calculation
      *
     C                   IF        A6SPDY = 0                                               BUG14691
     C                   Z-ADD     WRdate        @@SPOT                                     BUG14691
     C                   ELSE                                                               BUG14691
     C                   Z-ADD     A6MMSD        @@SPOT
     C                   ENDIF                                                              BUG14691
     C     #X            IFEQ      1
     C                   Z-SUB     @@PRD(#X)     @@PNUM
     C                   ELSE
     C                   Z-ADD     @@PRD(#X)     @@PNUM
     C                   ENDIF
      *
     C                   CALLB     'MM1003'
 
      ** Outgoing return code (10A, returned to caller)
     C                   PARM                    RetCodeOut
 
      ** Spot date, currency, period number and period type
     C                   PARM                    @@SPOT            8 0
     C                   PARM      HWCCY         @@CCY             3
     C                   PARM                    @@PNUM            2 0
     C                   PARM      HWTPRD        @@PTYP            1
 
      * ICD
 
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
 
      * Period date (output)
 
     C                   PARM      *ZERO         @@PDAT            8 0
                                                                                CSD006
      ** Convert Period Date to Midas Day Number                                CSD006
                                                                                CSD006
     C                   Z-ADD     @@PDAT        PPERDT                         CSD006
     C                   CALLB     'ZDATE10'                                    CSD006
     C                   PARM                    PPERDT                         CSD006
     C                   PARM      *ZERO         PPERDN                         CSD006
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      * Entry parameters.
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    FDVINT
     C                   PARM                    ValWrkFlds                     CAP058
                                                                                CAP058
      ** Key lists                                                              CAP058
                                                                                CAP058
     C     KYFLDL        KLIST                                                  CAP058
     C                   KFLD                    FYDTFR                         CAP058
     C                   KFLD                    WKYDFI           20            CAP058
      *
      * Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error.
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '900'         DBASE
     C                   EXSR      SRERR
     C                   ENDIF
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 901                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      ** Convert month to numeric form
      *
     C                   MOVE      BJMRDT        UUMRDT
     C                   Z-ADD     1             #X                2 0
     C     @@MMM         LOOKUP    @@MTH(#X)                              99
     C                   MOVE      @@DD          @@CHGDY
     C                   Z-ADD     #X            @@CHGMN
     C                   MOVE      @@YY          @@CHGYR
     C                   Eval      WRdd = @@DD                                              BUG14691
     C                   Eval      WRmm = #X                                                BUG14691
     C                   Eval      WRyy = @@YY                                              BUG14691
     C                   IF        WRyy > 40                                                BUG14691
     C                   Z-ADD     19            WRcc                                       BUG14691
     C                   ELSE                                                               BUG14691
     C                   Z-ADD     20            WRcc                                       BUG14691
     C                   ENDIF                                                              BUG14691
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'FDINTRUPD'   DBPGM
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      *****************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** @@MTH ARRAY TO HOLD MONTHS NAMES FOR THE UPDATES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** @@PTP ARRAY FOR PERIOD TYPES
DDDWWWMMMMMYYYYYYYYYY
** @@PRD ARRAY FOR PERIOD LENGTH
010001010203010203060901020304050607080910000000
** @@PER ARRAY FOR PERIODS
010203010203010203060901020304050607080910000000
