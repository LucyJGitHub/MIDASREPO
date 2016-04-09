      *****************************************************************
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2008')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD DST Maintenance')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001006 - Midas SD DST Code Maintenance Subfile             *
      *                                                               *
      *  Function:  This program display the records from the         *
      *             DST Code file                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2008            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG21289           Date 13Oct08               *
      *  Prev Amend No. BUG20628           Date 18Aug08               *
      *                 BUG20226           Date 15Aug08               *
      *                 BUG20610           Date 11Aug08               *
      *                 BUG19524A          Date 07Jul08               *
      *                 BUG19522           Date 25Jun08               *
      *                 BUG19793           Date 03Jul08               *
      *                 BUG19524           Date 27Jun08               *
      *                 BUG19314           Date 18Jun08               *
      *                 BUG19250           Date 16Jun08               *
      *                 BUG19244           Date 16Jun08               *
      *                 BUG19157           Date 11Jun08               *
      *                 BUG19156           Date 11Jun08               *
      *                 BUG19135           Date 10Jun08               *
      *                 BUG19134           Date 10Jun08               *
      *                 CSW208  *CREATE    Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG21289 - Various Timezone and DST errors. Applied fixes    *
      *             21232, 21207, 21208, 20945A, 20945                *
      *             (Recompile)                                       *
      *  BUG21232 - Branch details not in line with time zone at      *
      *             Branch level (Recompile)                          *
      *  BUG21207 - DST - Error in COPY of record without rule        *
      *             (Recompile)                                       *
      *  BUG21208 - DST Listview not correct when rules not set       *
      *             (Recompile)                                       *
      *  BUG20945A - When resetting DST Start/End information to      *
      *             blanks, error is encountered (Reopen) (Recompile) *
      *  BUG20945 - When resetting DST Start/End information to       *
      *             blanks, error is encountered (Recompile)          *
      *  BUG20628 - Various errors.                                   *
      *  BUG20226 - Database error occurred during "Copy" mode        *
      *             (Recompile)                                       *
      *  BUG20610 - Enquire is missing (Recompile)                    *
      *  BUG19524A - Various Errors.(Reopened)                        *
      *  BUG19522 - DST Start and End Time format in error            *
      *  BUG19793 - Warning message still appears in the list view    *
      *  BUG19524 - Various Errors.                                   *
      *  BUG19314 - The system prompted a warning message when it     *
      *             fact the DST End Date was computed by the system  *
      *             based on the rule                                 *
      *  BUG19250 - Move validation of DST rule to front              *
      *  BUG19244 - Warning message should be issued by the system if *
      *             DST End Date does not match with rule defined on  *
      *             the system                                        *
      *  BUG19157 - Error prompted by the system is misleading/       *
      *             incorrect                                         *
      *  BUG19156 - Warning message should be issued by the system if *
      *             DST Start Date does not match with rule defined   *
      *             on the system                                     *
      *  BUG19135 - Did not accept single digit                       *
      *  BUG19134 - Offset Time should be defaulted to 60 if no       *
      *             value was inserted                                *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    20         No Data to Display                              *
      *    27         RollUp                                          *
      *    29         Protect fields                                  *
      *    30         SFLDSP                                          *
      *    31         Clear Subfile(SFLCLR)                           *
      *    32         Message Subfile End (SFLEND)                    *
      *    33         SFLEND                                          *
      *    34         SFLNXTCHG                                       *
      *    35         Reverse Image                                   *
      *    40         Non-display fields                              *
      *    42         Enquiry Mode                                    *
      *    70         DST Code Already Exist                          *
      *    71         Invalid DST Year                                *
      *    72         Description is mandatory                        *
      *    73         Offset time is mandatory                        *
      *    74         Invalid Start Date                              *
      *    75         Invalid End Date                                *
      *    76         Start Time is mandatory                         *
      *    77         End Time is mandatory                           *
      *    78         Start Month is mandatory                        *
      *    79         End Month is mandatory                          *
      *    80         Start Week is mandatory                         *
      *    81         End Week is mandatory                           *
      *    82         Start Day is mandatory                          *
      *    83         End Day is mandatory                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *  SRBldSfl  - Build the Subfile                                *
      *  SRLoadSfl - Load the Subfile                                 *
      *  SRDspSfl  - Display the Subfile                              *
      *  SRPrSfl   - Process the Subfile Functions                    *
      *  SRReset   - Reset the Fields                                 *
      *  SRReset2  - Reset the Fields                                 *
      *  SRClrSfl  - Clear the Subfile                                *
      *  SRErrDta  - Output Error Message With Data                   *
      *  SRAmend   - Display Amend Screen                             *
      *  SRCopy    - Display Copy Screen                              *
      *  SRDelete  - Display Delete Screen                            *
      *  SRInsert  - Display Insert Screen                            *
      *  SRScreen2 - Display Second Screen                            *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Initialise                                       *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** DST Code Update File
     FSDDSTCL0  Uf A E           K DISK    INFSR(*PSSR)
      *
      ** DST Code Retrieval File
     FSDDSTCL1  If   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDDSTCD0:@DSTCL1)
      *
      ** Time Zone History File by DST Code
     FSDTIZHL2  Uf A E           K DISK    INFSR(*PSSR)
      *
      ** Market Identification Code File
     FSDMICCL1  If   E           K DISK    INFSR(*PSSR)
      *
      ** Time Zone Retrieval File
     FSDTIZOL2  If   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDTIZOD0:SDTIZOD2)
     F                                     Prefix(V_)
      *
      ** Time Zone by DST Code, TimeZone and Year
     FSDTIZOL7  If   E           K DISK    INFSR(*PSSR)
      *
      ** Time Zone Level Code File
     FSDTZLVL4  If   E           K DISK    INFSR(*PSSR)
      *
      ** Branch Code Update
     FSDBRCHL0  Uf   E           K DISK    INFSR(*PSSR)
      *
      ** DST Code Maintenance Display File
     FSD001006DFCF   E             WORKSTN
     F                                     SFILE(SD001006S0:RRN0)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
     D SflPag          C                   CONST(14)
      *
      * Action Codes
     D Amend           C                   CONST('A')
     D Copy            C                   CONST('C')
     D Delete          C                   CONST('D')
     D Enquire         C                   CONST('E')
     D Insert          C                   CONST('I')
     D DSTCodeChg      C                   CONST('C')
     D MICCodeLvl      C                   CONST('M')
     D TIMZoneLvl      C                   CONST('T')
     D BrchLvl         C                   CONST('B')
     D SysLvl          C                   CONST('S')
      *
      ** Numeric values
     D Digits          C                   Const('0123456789')
      *
      * Invalid Characters for DST Code.                                                    BUG20628
     D InvalidChar     C                   '!@#$%¢&*()+_-=?<>,;:{}|\/"''`~'                 BUG20628
      ** DST Week
     D DSTWk           C                   Const('12349')
     D WSwTime         S               T   INZ(*SYS)                                        BUG21232
     D                                     TIMFMT(*ISO)                                     BUG21232
     D WCwTime         S              6A                                                    BUG21232
      *
      ** The following /COPY line includes (among others) the LDA
      ** Layout and the Following Named Constants:
      ** True       Logical = *ON (For Indcator Processing)
      ** False      Logical = *OFF (For Indcator Processing)
      ** DBErrCtl   10A     = 'DBERRCTL' (The Name Of The Database
      **                       Error Handler)
      ** and the Following Variables:
      ** RunBefore  1A (For The PSSR)
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the rogram Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      *
     D DSTMon          S              2    DIM(12) CTDATA PERRCD(12)
      *
     D DSTDay          S              2    DIM(7) CTDATA PERRCD(7)
      *
     D Month           S              3    DIM(12) CTDATA PERRCD(12)
      *
     D Week            S              6    DIM(5) CTDATA PERRCD(1)
      *
     D Day             S              3    DIM(7) CTDATA PERRCD(7)
      *
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Define a Data Structure to Access Default Branch
     D ZMUser          DS            17
     D  PBrc                  11     13A
      *
      ** Indicator Data Structure
     D Indicators      DS                  BASED(IndPointer)
     D  F3                    03     03
     D  Refresh               05     05
     D  Add                   09     09
     D  F12                   12     12
     D  RollUp                27     27
     D  SflDsp                30     30
     D  SflClr                31     31
     D  SflEnd                33     33
     D  NoData                20     20
     D  ActnErr               35     35
      *
      ** Data-structure for Time field
     D WTimeDS         DS
     D  WHour                  1      2A
     D  WMin                   3      4A
     D  WSec                   5      6A
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D IndPointer      S               *   Inz(%Addr(*in))
     D RRN0            S              4  0
     D WLstRrn         S              4  0
     D WSelYEAR        S              1A
     D WSelOFFS        S              1A
     D WSelDSDT        S              1A
     D WSelDSED        S              1A
     D WError          S              1A   Inz('N')
     D WCtr            S              2  0
      *
      ** Work Variable
     D Exit            S              1A   Inz('N')
     D @Year           S              4S 0
     D @Offs           S              3A
     D WkNo            S              1S 0
     D WMsgId          S              7A
     D WMsgDta         S             45A
     D WRun            S              1A
     D WIdx            S              3P 0
     D WTmpOffset      S              4S 0
     D OffSign         S              1A
     D CurrYr          S              2S 0
     D DateYr          S              2S 0
     D NextYr          S              2S 0
     D PrevTZone       S                   LIKE(TZTZCD)
     D WTZYear         S              4A
     D WTZYearN        S              4S 0
     D Timestamp       S             26Z
     D WTime           S               T   TIMFMT(*Hms)
     D WTime1          S              6A
     D WTmp            S              6A
     D WOfSt           S              3S 0 Inz(*ZEROS)
     D ZALIGNok        S              1A                                                    BUG19135
     D ZFIELD          S             16A                                                    BUG19135
     D ZADEC           S              1P 0                                                  BUG19135
     D ZADIG           S              2P 0                                                  BUG19135
     D StartDate       S                   LIKE(PZDayNo)
     D EndDate         S                   LIKE(PZDayNo)
     D WCDscd          S                   LIKE(M1DSCDS)
     D WCYear          S                   LIKE(M1YEARS)
     D WCOffs          S                   LIKE(M1OFFSS)
     D WCDsdt          S                   LIKE(M1DSDTS)
     D WCDsed          S                   LIKE(M1DSEDS)
     D D@OFFS          S                   LIKE(DDOFFS)
     D D@DSDT          S                   LIKE(DDDSDT)
     D D@DSDH          S                   LIKE(DDDSDH)
     D D@DSTM          S                   LIKE(DDDSTM)
     D D@DSTW          S                   LIKE(DDDSTW)
     D D@DSTD          S                   LIKE(DDDSTD)
     D D@DSED          S                   LIKE(DDDSED)
     D D@DENH          S                   LIKE(DDDENH)
     D D@DENM          S                   LIKE(DDDENM)
     D D@DENW          S                   LIKE(DDDENW)
     D D@DEND          S                   LIKE(DDDEND)
     D KTZLC           S                   LIKE(TLTZLC)
     D KZONE           S                   LIKE(TLZONE)
     D KBRCA           S                   LIKE(TLBRCA)
     D KMICC           S                   LIKE(MICCOD)
     D KTZCD           S                   LIKE(TZTZCD)
     D KYEAR           S                   LIKE(TZYEAR)
     D KDSTC           S                   LIKE(TZDSTC)
     D KDSCD           S                   LIKE(DSLCD)
     D S@DSDT          S                   LIKE(DDDSDT)                                     BUG21207
     D S@DSED          S                   LIKE(DDDSED)                                     BUG21207
     D nStrDate        S                   LIKE(PZDayno)                                    BUG21232
     D nEndDate        S                   LIKE(PZDayno)                                    BUG21232
      *
      ** Entry Parameters
     D PRetCode        S              3A
     D PDscd           S             10A
     D PYear           S              4A
      *
      ** Parameters for ZVACTBU/ZVACTU
     D PZbr            S              3A
     D PErr            S              1P 0
      *
      ** Parameters for ZFINDDATE
     D PDateFmt        S              3A
     D POutDate5       S              5S 0
     D POutDate6       S              6A
      *
      ** Parameter for 'AOBANKR0'
     D PRtCd           S              7A
     D POptn           S              7A
      *
      ** Parameter for 'QCLSCAN'
     D PLenDta         S              3P 0
     D PStart          S              3P 0 INZ(1)
     D PLenSrc         S              3P 0
     D PTranslate      S              1A   INZ('1')
     D PTrim           S              1A   INZ('1')
     D PWild           S              1A   INZ('1')
     D PResult         S              3P 0
      *
      ** Variable to determine the position of "?"
     D WPos            S              2S 0
     D NPos            S              2S 0
      *
      ** Parameter for ZA0350
     D PZMsgFile       S             10A   INZ('GBSDUSRMSG')
     D PZMsgId         S             10A
     D PZMsgData       S             45A
      *
     D PMode           S              1A
     D Y2Lsno          S              7  0
     D Selection       S             20A
      *
     D PZDate          S              6A
     D PZDayNo         S              5P 0
     D PErrorFlag      S              1A
      *
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *                                                                                     BUG21207
      ** ZM0065 Parameters                                                                  BUG21207
     D ZMDAY           S              5P 0                                                  BUG21207
     D ZSDATE          S              6A                                                    BUG21207
     D ZSDATC          S              8A                                                    BUG21207
      *****************************************************************
      /EJECT
      *****************************************************************
      ** MAIN - Processing
      *****************************************************************
      *
      ** Build The Subfile
      *
     C                   EXSR      SRBldSfl
      *
      ** Display the Screen Until F12 or F3 Is Pressed
      *
     C                   DOW       Exit = 'N'
      *
      ** Display And Process the Subfile
      *
     C                   EXSR      SRDspSfl
      *
      ** Process the Subfile
      *
     C                   EXSR      SRProcess
      *
     C                   ENDDO
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on Program Activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *Entry        PLIST
     C                   PARM                    PMode
      *
      ** Key List
      *
     C     Key1          KLIST
     C                   KFLD                    M1DSCD
     C                   KFLD                    M1YEAR
      *
     C     Key2          KLIST
     C                   KFLD                    DDDSCD
     C                   KFLD                    DDYEAR
      *
     C     Key3          KLIST
     C                   KFLD                    DDDSCD
      *
     C     Key4          KLIST
     C                   KFLD                    TZTZCD
     C                   KFLD                    TZYEAR
      *
     C     KeyHst        KLIST
     C                   KFLD                    KDSTC
     C                   KFLD                    KTZCD
     C                   KFLD                    KYEAR
      *
     C     KeyTZLV       KLIST
     C                   KFLD                    KTZLC
     C                   KFLD                    KTZCD
     C                   KFLD                    KYEAR
      *
      ** Check if in Enquiry Mode
      *
     C                   IF        PMode = 'E'
     C                   EVAL      *IN42 = *ON
     C                   ELSE
     C                   EVAL      *IN42 = *OFF
     C                   ENDIF
      *
      ** Call The Access Object - AOBANKR0
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Check the Return Parameter
      *
     C                   IF        PRtCd <> *BLANKS
      *
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE  = 001
     C                   EXSR      *PSSR
      *
     C                   ENDIF
      *
      ** Get ZMUser To Access Default Branch
      *
     C     *DTAARA       DEFINE                  ZMUser
     C                   IN        ZMUser
     C                   UNLOCK    ZMUser
      *
      ** Populate WorkStation ID
      *
     C                   EVAL      D0WID = PSJobName
      *
      ** Populate User
      *
     C                   EVAL      D0USER = PSUser
      *
      ** Populate Midas Run Date
      *
     C                   EVAL      D0MRDT = BJMRDT
      *
      ** Initialise Subfile Program Queue and Message File
      *
     C                   EVAL      D1PGMQ = '*'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
      *
      ** Message Subfile Indicator
      *
     C                   EVAL      *IN32 = *ON
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate1 - Validate & Convert Date to a Day Number           *
      *                                                               *
      *  Called by: SRInsert, SRAmend, SRCopy, SRFldVal               *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRZDate1      BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDate
     C                   PARM                    PZDayNo
     C                   PARM                    BJDFIN
     C                   PARM                    PErrorFlag
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate2 - Convert Midas Date to DDMMYY or MMDDYY            *
      *                                                               *
      *  Called by: SRSetScr2, SRloadSfl                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SRZDate2      BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDateIn
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PDateOut
     C                   PARM      *BLANKS       PADateOut
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl - Build the Subfile                                 *
      *                                                               *
      *  Called by: MAIN Processing, SRProcess                        *
      *                                                               *
      *  Calls: SRClrSfl, SRLoadSfl                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSfl      BEGSR
      *
      ** Clear the Subfile
      *
     C                   EXSR      SRClrSfl
      *
      ** Load the Subfile
      *
     C                   EXSR      SRLoadSfl
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDspSfl - Display the Subfile                               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDspSfl      BEGSR
      *
     C                   TIME                    D0TIME
      *
      ** Write the Footer
      *
     C                   WRITE     SD001006F0
      *
      ** Write the Message Subfile Control Format
      *
     C                   WRITE     SD001006C1
      *
      ** Display the Subfile
      *
     C                   EXFMT     SD001006C0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Process the Subfile                              *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRReset, SRBldSfl, SRLoadSfl, SRPrSfl                 *
      *                                                               *
      *****************************************************************
      *
     C     SRProcess     BEGSR
      *
      ** Reset the Fields and the Program Message Queue
      *
     C                   EXSR      SRReset
      *
     C                   IF        M1DSCDS = *BLANKS
     C                   EVAL      WCDscd = *BLANKS
     C                   ENDIF
      *
     C                   IF        M1YEARS = *BLANKS
     C                   EVAL      WCYear = *BLANKS
     C                   ENDIF
      *
     C                   IF        M1OFFSS = *BLANKS
     C                   EVAL      WCOffs = *BLANKS
     C                   ENDIF
      *
     C                   IF        M1DSDTS = *BLANKS
     C                   EVAL      WCDsdt = *BLANKS
     C                   ENDIF
      *
     C                   IF        M1DSEDS = *BLANKS
     C                   EVAL      WCDsed = *BLANKS
     C                   ENDIF
      *
     C                   SELECT
      *
      ** When F3 Is Pressed
      *
     C                   WHEN      F3 = *ON
      *
     C                   EVAL      Exit = 'Y'
     C                   LEAVESR
      *
      ** When F5 Is Pressed
      *
     C                   WHEN      Refresh = *ON
      *
      ** Reset and Build
      *
     C                   EXSR      SRReset
     C                   EXSR      SRBldSfl
      *
      ** When Page Down Is Pressed
      *
     C                   WHEN      RollUp = *ON
      *
      ** Load the Next Page
      *
     C                   EXSR      SRLoadSfl
      *
      ** When F9 Is Pressed And DST Code And Other
      ** Filters Are Not Changed
      *
     C                   WHEN      Add = *ON  AND
     C                             (M1DSCDS =  WCDscd) AND
     C                             (M1YEARS =  WCYear) AND
     C                             (M1OFFSS =  WCOffs) AND
     C                             (M1DSDTS =  WCDsdt) AND
     C                             (M1DSEDS =  WCDsed)
      *
      ** Process the Function Keys and the Values Entered On the
      ** Screen
      *
     C                   EXSR      SRPrSfl
      *
      ** Call the Input Screen
      *
     C                   IF        WIdx = 0
      *
     C                   EVAL      M1ActD = Insert
     C                   EXSR      SRScreen2
      *
      ** When 'F3' is Pressed, Go To Main Menu
      *
     C                   IF        PRetCode = 'F3'
     C                   EVAL      Exit = 'Y'
     C                   LEAVESR
     C                   ENDIF
      *
      ** Load Subfile again
      *
     C                   EXSR      SRBldSfl
     C                   ENDIF
      *
      ** When no change in DST Code and Other Filters Fields
      *
     C                   WHEN      (M1DSCDS =  WCDscd) AND
     C                             (M1YEARS =  WCYear) AND
     C                             (M1OFFSS =  WCOffs) AND
     C                             (M1DSDTS =  WCDsdt) AND
     C                             (M1DSEDS =  WCDsed) AND
     C                             (Add = *OFF)
      *
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError <> 'Y'
      *
      ** Reset Program Message Queue and Fields
      *
     C                   EXSR      SRReset
      *
      ** Build the Subfile
      *
     C                   EXSR      SRBldSfl
      *
     C                   ENDIF
      *
     C                   WHEN      (M1DSCDS <> *BLANKS) OR
     C                             (M1YEARS <> *BLANKS) OR
     C                             (M1OFFSS <> *BLANKS) OR
     C                             (M1DSDTS <> *BLANKS) OR
     C                             (M1DSEDS <> *BLANKS)
      *
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError = 'N'
     C                   EVAL      WCDscd = M1DSCDS
     C                   EVAL      WCYear = M1YEARS
     C                   EVAL      WCOffs = M1OFFSS
     C                   EVAL      WCDsdt = M1DSDTS
     C                   EVAL      WCDsed = M1DSEDS
      *
      ** Build the Subfile With the Selection Criteria
      *
     C                   EXSR      SRBldSfl
     C                   ENDIF
      *
     C                   OTHER
      *
     C                   EXSR      SRPrSfl
      *
     C                   IF        WError <> 'Y'
      *
      ** Reset Program Queue and Fields
      *
     C                   EXSR      SRReset
      *
      ** Load the Subfile
      *
     C                   EXSR      SRBldSfl
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset - Reset the Fields                                   *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReset       BEGSR
      *
      ** Clear Program Queue And Message File
      *
     C                   CALL      'ZA0250'
      *
     C                   EVAL      WIdx = 0
     C                   EVAL      PZMsgId = *BLANKS                                        BUG19793
     C                   EVAL      PZMsgData = *BLANKS                                      BUG19793
      *
     C                   IF        Refresh = *ON
      *
      ** Reset Search Fields
      *
     C                   EVAL      M1DsCdS = *BLANKS
     C                   EVAL      M1YearS = *BLANKS
     C                   EVAL      M1OffsS = *BLANKS
     C                   EVAL      M1DsdtS = *BLANKS
     C                   EVAL      M1DsedS = *BLANKS
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReset2 - Reset the Fields                                  *
      *                                                               *
      *  Called by: SRSetScr2, SRInsert, SRAmend, SRCopy              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRReset2      BEGSR
      *
      ** Clear Program Queue And Message File
      *
     C                   CALL      'ZA0250'
      *
      ** Reset Error Indicator
      *
     C                   MOVEA     '0000000000'  *IN(70)
     C                   MOVEA     '0000'        *IN(80)
      *
      ** Clear Error Fields
      *
     C                   EVAL      PZMsgId = *BLANKS
     C                   EVAL      PZMsgData = *BLANKS
     C                   EVAL      WIdx = *ZEROS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScreen2 - Maintenance Screen                               *
      *                                                               *
      *  Called by: SRProcess, SRPrSfl                                *
      *                                                               *
      *  Calls: SRAmend, SRCopy, SRDelete, SRInsert                   *
      *                                                               *
      *****************************************************************
      *
     C     SRScreen2     BEGSR
      *
     C                   EXSR      SRSetScr2
      *
      ** If F3 And F12 Not Active
      *
     C                   DOW       (F3 = *OFF) AND
     C                             (F12 = *OFF)
      *
      ** If Amendment, Set Required Indicators
      *
     C                   EVAL      *IN45 = *OFF                                            BUG19524A
     C                   IF        M1Actd = Amend
      *
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      *IN59 = *ON
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      *IN40 = *OFF
      *
      ** If Copy, Set Required Indicators
      *
     C                   ELSEIF    M1Actd = Copy
      *
     C                   EVAL      *IN29 = *ON
     C                   EVAL      *IN59 = *OFF
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      *IN40 = *ON
      *
      ** If Enquire, Set Required Indicators
      *
     C                   ELSEIF    M1Actd = Enquire
      *
     C                   EVAL      *IN29 = *ON
     C                   EVAL      *IN59 = *ON
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN42 = *ON                                             BUG19524A
     C                   EVAL      *IN44 = *OFF
      *
      ** If Delete, Set Required Indicators
      *
     C                   ELSEIF    M1Actd = Delete
      *
     C                   EVAL      *IN29 = *ON
     C                   EVAL      *IN59 = *ON
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN44 = *ON
     C**********         EVAL      *IN42 = *ON                                              BUG19524
     C                   EVAL      *IN42 = *OFF                                             BUG19524
     C                   EVAL      *IN45 = *ON                                             BUG19524A
      *
      ** If Insert, Set Required Indicators
      *
     C                   ELSEIF    M1Actd = Insert
      *
     C                   EVAL      *IN29 = *ON
     C                   EVAL      *IN59 = *OFF
     C                   EVAL      *IN31 = *ON
     C                   EVAL      *IN44 = *OFF
     C                   EVAL      *IN40 = *ON
      *
     C                   ENDIF
      *
      ** Populate The Time Field
      *
     C                   TIME                    D0TIME
      *
      ** Footer Of The Screen With Function Keys
      *
     C                   WRITE     SD001006F0
      *
      ** Write the Message Subfile Control Format
      *
     C                   WRITE     SD001006C1
      *
      ** Screen Format
      *
     C                   EXFMT     SD001006R0
      *
     C                   SELECT
      *
      ** Process Based On the Function Key Pressed
      *
     C                   WHEN      F3 = *ON
     C                   EVAL      PRetCode = 'F3'
      *
     C                   WHEN      F12 = *ON
     C                   EVAL      PRetCode = 'F12'
      *
      ** Clear Program Queue And Message File
      *
     C                   CALL      'ZA0250'
      *
      ** Amend The Record
      *
     C                   WHEN      M1Actd = Amend
     C                   EXSR      SRAmend
      *
      ** Copy The Record
      *
     C                   WHEN      M1Actd = Copy
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN29 = *OFF
     C                   EVAL      S@DSDT  =  DDDSDT                                        BUG21207
     C                   EVAL      S@DSED  =  DDDSED                                        BUG21207
     C                   EVAL      DDDSDT = *BLANKS                                         BUG19524
     C                   EVAL      DDDSED = *BLANKS                                         BUG19524
     C                   EXSR      SRCopy
      *
      ** Delete The Record
      *
     C                   WHEN      M1Actd = Delete
     C                   EXSR      SRDelete
      *
      ** Insert The Record
      *
     C                   WHEN      M1Actd = Insert
     C                   EVAL      *IN40 = *OFF
     C                   EVAL      *IN29 = *OFF
     C                   EXSR      SRInsert
      *
      ** Enquire The Record
      *
     C                   WHEN      M1Actd = Enquire
     C                   EVAL      F12 = *ON
     C                   EVAL      *IN29 = *OFF
      *
     C                   ENDSL
      *
     C                   ENDDO
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetScr2 - Set Screen Field 2                               *
      *                                                               *
      *  Called by: SRScreen2                                         *
      *                                                               *
      *  Calls: SRReset2, SRZDate2                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRSetScr2     BEGSR
      *
     C                   EVAL      F3 = *OFF
     C                   EVAL      F12 = *OFF
     C                   EVAL      *IN31 = *ON
     C                   EXSR      SRReset2
      *
      ** Populate The Screen Field
      *
     C                   IF        (M1Actd = Amend)   OR
     C                             (M1Actd = Enquire) OR
     C                             (M1Actd = Copy)    OR
     C                             (M1Actd = Delete)
      *
      ** If found, Then Populate the Screen Fields
      *
     C     Key1          CHAIN     SDDSTCL0
     C                   IF        %FOUND(SDDSTCL0)
      *
     C                   IF        M1Actd = Copy
     C**********         EVAL      DDDSCD = *BLANKS                                         BUG19524
     C**********         EVAL      DDYEAR = *BLANKS                                         BUG19524
     C                   EVAL      DDDSCD = M1DSCD                                          BUG19524
     C                   EVAL      DDYEAR = M1YEAR                                          BUG19524
     C                   ELSE
     C                   EVAL      DDDSCD = DSDSCD
     C                   EVAL      DDYEAR = DSYEAR
     C                   ENDIF
      *
     C                   EVAL      DDDESC = DSDESC
     C                   EVALR     DDOFFS = %CHAR(DSOFFS)
     C                   EVALR     D@OFFS = %CHAR(DSOFFS)
      *
      ** Start Date
      *
     C                   IF        DSDSDT = *ZEROS
     C                   EVAL      DDDSDT = *BLANKS
     C                   ELSE
     C                   EVAL      PDateIn = DSDSDT
     C                   EXSR      SRZDate2
     C                   MOVE      PDateOut      DDDSDT
     C                   MOVE      PDateOut      D@DSDT
     C                   ENDIF
      *
      ** End Date
      *
     C                   IF        DSDSED = *ZEROS
     C                   EVAL      DDDSED = *BLANKS
     C                   ELSE
     C                   EVAL      PDateIn = DSDSED
     C                   EXSR      SRZDate2
     C                   MOVE      PDateOut      DDDSED
     C                   MOVE      PDateOut      D@DSED
     C                   ENDIF
      *
     C                   MOVE      DSDSDH        DDDSDH
     C                   MOVE      DSDSDH        D@DSDH
     C                   IF        DSDSTM = 0                                              BUG20945A
     C                   MOVE      *BLANKS       DDDSTM                                    BUG20945A
     C                   MOVE      *BLANKS       DDDSTW                                    BUG20945A
     C                   MOVE      *BLANKS       DDDSTD                                    BUG20945A
     C                   MOVE      *BLANKS       DDDENM                                    BUG20945A
     C                   MOVE      *BLANKS       DDDENW                                    BUG20945A
     C                   MOVE      *BLANKS       DDDEND                                    BUG20945A
     C                   ELSE                                                              BUG20945A
     C                   MOVE      DSDSTW        DDDSTW                                    BUG20945A
     C                   MOVE      DSDSTM        DDDSTM
     C                   MOVE      DSDSTD        DDDSTD                                    BUG20945A
     C                   MOVE      DSDENM        DDDENM                                    BUG20945A
     C                   MOVE      DSDENW        DDDENW                                    BUG20945A
     C                   MOVE      DSDEND        DDDEND                                    BUG20945A
     C                   ENDIF                                                             BUG20945A
     C                   MOVE      DSDSTM        D@DSTM
     C**********         MOVE      DSDSTW        DDDSTW                                    BUG20945A
     C                   MOVE      DSDSTW        D@DSTW
     C**********         MOVE      DSDSTD        DDDSTD                                    BUG20945A
     C                   MOVE      DSDSTD        D@DSTD
     C                   MOVE      DSDENH        DDDENH
     C                   MOVE      DSDENH        D@DENH
     C**********         MOVE      DSDENM        DDDENM                                    BUG20945A
     C                   MOVE      DSDENM        D@DENM
     C**********         MOVE      DSDENW        DDDENW                                    BUG20945A
     C                   MOVE      DSDENW        D@DENW
     C**********         MOVE      DSDEND        DDDEND                                    BUG20945A
     C                   MOVE      DSDEND        D@DEND
      *
     C                   ENDIF
      *
      ** If Not found, Then Set The Blank Value.
      *
     C                   ELSE
      *
     C                   EVAL      DDDSCD = *BLANKS
     C                   EVAL      DDYEAR = *BLANKS
     C                   EVAL      DDDESC = *BLANKS
     C                   EVAL      DDOFFS = *BLANKS
     C                   EVAL      DDDSDT = *BLANKS
     C**********         EVAL      DDDSDH = *BLANKS                                         BUG19522
     C                   EVAL      DDDSDH = *ZEROS                                          BUG19522
     C                   EVAL      DDDSTM = *BLANKS
     C                   EVAL      DDDSTW = *BLANKS
     C                   EVAL      DDDSTD = *BLANKS
     C                   EVAL      DDDSED = *BLANKS
     C**********         EVAL      DDDENH = *BLANKS                                         BUG19522
     C                   EVAL      DDDENH = *ZEROS                                          BUG19522
     C                   EVAL      DDDENM = *BLANKS
     C                   EVAL      DDDENW = *BLANKS
     C                   EVAL      DDDEND = *BLANKS
      *
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClrSfl - Clear the Subfile                                 *
      *                                                               *
      *  Called by: SRBldSfl                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRClrSfl      BEGSR
      *                                                                                     BUG19793
      ** Reset the Fields and the Program Message Queue                                     BUG19793
      *                                                                                     BUG19793
     C                   EXSR      SRReset                                                  BUG19793
      *
      ** Set Pointer to First Record of Database
      *
     C     *LOVAL        SETLL     SDDSTCL1
      *
      ** Check if in Enquiry Mode
      *
     C                   IF        PMode = 'E'
     C                   EVAL      *IN42 = *ON
     C                   ELSE
     C                   EVAL      *IN42 = *OFF
     C                   ENDIF
      *
      ** Intialise Fields
      *
     C                   EVAL      WError = 'N'
     C                   EVAL      RRN0  = *ZEROS
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      WLstRrn = *ZEROS
     C                   EVAL      M1Actd = *BLANKS
     C                   EVAL      NoData = *OFF
     C                   EVAL      ActnErr = *OFF
     C                   EVAL      SflClr = *ON
     C                   EVAL      SflEnd = *OFF
      *
     C                   WRITE     SD001006C0
      *
     C                   EVAL      SflClr = *OFF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRloadSfl - Load the Subfile                                 *
      *                                                               *
      *  Called by: SRBldSfl, SRProcess                               *
      *                                                               *
      *  Calls: SRErrDta, SRZDate2                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRloadSfl     BEGSR
      *
      ** Intialise Filter Flags - No Search Criteria
      *
     C                   EVAL      WSelYEAR = 'Y'
     C                   EVAL      WSelOFFS = 'Y'
     C                   EVAL      WSelDSDT = 'Y'
     C                   EVAL      WSelDSED = 'Y'
      *
      ** If Relative Record Number of the Last Record Loaded in the
      ** Subfile is Greater than Zero
      *
     C                   IF        WLstRrn > *ZEROS
      *
     C                   EVAL      RRN0  = WLstRrn
     C                   EVAL      WLstRrn = D0SFRN
      *
     C                   ENDIF
      *
      ** If Position field - DST Code is not blank,
      ** Set the Pointer To the Entered DST Code
      *
     C                   IF        (M1DSCDS <> *BLANKS) AND
     C                             RollUp = *OFF AND
     C                             NOT %EOF(SDDSTCL1)
      *
     C     M1DSCDS       SETLL     SDDSTCL1
      *
     C                   ENDIF
      *
      ** Reset Counter
      *
     C                   EVAL      WCtr = 0
      *
      ** Loading Records to Subfile
      *
     C                   DoW       WCtr < SflPag AND
     C                             NOT %EOF(SDDSTCL1)
      *
      ** Read the Database File
      *
     C                   READ      SDDSTCL1
      *
     C                   IF        %EOF(SDDSTCL1)
     C                   LEAVE
     C                   ENDIF
      *
     C                   IF        NOT %EOF(SDDSTCL1)
      *
      ** DST Code
      *
     C                   EVAL      M1DSCD = DSDSCD
      *
      ** DST Year
      *
     C                   EVAL      M1YEAR = DSYEAR
      *
      ** DST Offset
      *
     C                   EVALR     M1OFFS = %CHAR(DSOFFS)
      *
      ** DST Start Date
      *
     C                   IF        DSDSDT = *ZEROS
     C                   EVAL      M1DSDT = *BLANKS
     C                   ELSE
     C                   EVAL      PDateIn = DSDSDT
     C                   EXSR      SRZDate2
     C                   MOVE      PDateOut      M1DSDT
     C                   ENDIF
      *
      ** DST Rule
      *
     C                   IF        DSDSTW = 9
     C                   EVAL      WkNo = 5
     C                   ELSE
     C                   EVAL      WkNo = DSDSTW
     C                   ENDIF
      *
     C                   IF        DSDSTD <> 0                                              BUG20945
     C                   EVAL      M1DSTR = %TRIM(Week(WkNo)) + ' ' +
     C                                      %TRIM(Day(DSDSTD)) + ' of ' +
     C                                      %TRIM(Month(DSDSTM))
     C                   ELSE                                                               BUG21208
     C                   EVAL      M1DSTR = *BLANKS                                         BUG21208
     C                   ENDIF                                                              BUG20945
      *
      ** End Date
      *
     C                   IF        DSDSED = *ZEROS
     C                   EVAL      M1DSED = *BLANKS
     C                   ELSE
     C                   EVAL      PDateIn = DSDSED
     C                   EXSR      SRZDate2
     C                   MOVE      PDateOut      M1DSED
     C                   ENDIF
      *
      ** DST Rule - End
      *
     C                   IF        DSDENW = 9
     C                   EVAL      WkNo = 5
     C                   ELSE
     C                   EVAL      WkNo = DSDENW
     C                   ENDIF
     C                   IF        DSDEND <> 0                                              BUG20945
     C                   EVAL      M1DENR = %TRIM(Week(WkNo)) + ' ' +
     C                                      %TRIM(Day(DSDEND)) + ' of ' +
     C                                      %TRIM(Month(DSDENM))
     C                   ELSE                                                               BUG21208
     C                   EVAL      M1DENR = *BLANKS                                         BUG21208
     C                   ENDIF                                                              BUG20945
      *
      ** Search - DST Year
      *
     C                   IF        M1YEARS <> *BLANKS
     C                   EVAL      PLenDta = %LEN(DSYEAR)
     C                   EVAL      PLenSrc = %LEN(M1YEARS)
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    DSYEAR
     C                   PARM                    PLenDta
     C                   PARM                    PStart
     C                   PARM                    M1YEARS
     C                   PARM                    PLenSrc
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelYEAR = 'N'
      *
      ** If Present Display That Record
      *
     C                   ELSE
     C                   EVAL      WSelYEAR = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Search - Offset
      *
     C                   IF        M1OFFSS <> *BLANKS
     C                   MOVEl     DSOFFS        @Offs
     C                   EVAL      PLenDta = %LEN(DSOFFS)
     C                   EVAL      PLenSrc = %LEN(M1OFFSS)
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    @OFFS
     C                   PARM                    PLenDta
     C                   PARM                    PStart
     C                   PARM                    M1OFFSS
     C                   PARM                    PLenSrc
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelOFFS = 'N'
      *
      ** If Present Display That Record
      *
     C                   ELSE
     C                   EVAL      WSelOFFS = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Search - DST Start
      *
     C                   IF        M1DSDTS <> *BLANKS
      *
      ** Convert DST Start Date to Date Format
      *
     C                   EVAL      PDateIn = DSDSDT
     C                   EXSR      SRZDate2
     C                   MOVE      PDateOut      DDDSDT
      *
     C                   EVAL      PLenDta = %LEN(DDDSDT)
     C                   EVAL      PLenSrc = %LEN(M1DSDTS)
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    DDDSDT
     C                   PARM                    PLenDta
     C                   PARM                    PStart
     C                   PARM                    M1DSDTS
     C                   PARM                    PLenSrc
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelDSDT = 'N'
      *
      ** If Present Display That Record
      *
     C                   ELSE
     C                   EVAL      WSelDSDT = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Search - End Date
      *
     C                   IF        M1DSEDS <> *BLANKS
      *
      ** Convert DST End Date to Date Format
      *
     C                   EVAL      PDateIn = DSDSED
     C                   EXSR      SRZDate2
     C                   MOVE      PDateOut      DDDSED
      *
     C                   EVAL      PLenDta = %LEN(DDDSED)
     C                   EVAL      PLenSrc = %LEN(M1DSEDS)
      *
      ** Scan Database Field With the Search Argument
      *
     C                   CALL      'QCLSCAN'
     C                   PARM                    DDDSED
     C                   PARM                    PLenDta
     C                   PARM                    PStart
     C                   PARM                    M1DSEDS
     C                   PARM                    PLenSrc
     C                   PARM                    PTranslate
     C                   PARM                    PTrim
     C                   PARM                    PWild
     C                   PARM                    PResult
      *
      ** If Not Present,Blank Out Screen Field
      *
     C                   IF        PResult < 1
     C                   EVAL      WSelDSED = 'N'
      *
      ** If Present Display That Record
      *
     C                   ELSE
     C                   EVAL      WSelDSED = 'Y'
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** WRITE the SELECTed Records
      *
     C                   IF        (WSelYEAR = 'Y') AND
     C                             (WSelOFFS = 'Y') AND
     C                             (WSelDSDT = 'Y') AND
     C                             (WSelDSED = 'Y')
     C                   EVAL      RRN0  = RRN0  + 1
     C                   EVAL      WCtr = WCtr + 1
     C                   EVAL      D0SFRN = RRN0
     C                   EVAL      M1ACTD = *BLANKS
     C                   EVAL      *IN35 = *OFF
      *
     C                   WRITE     SD001006S0
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   EVAL      WLstRrn = D0SFRN
      *
      ** If Last Record, Turn on the 'SFLEND' indicator
      *
     C                   READ      SDDSTCL1
     C                   IF        %EOF(SDDSTCL1)
     C                   EVAL      SflEnd = *ON
     C                   ELSE
     C                   READP     SDDSTCL1
     C                   EVAL      SflEnd = *OFF
     C                   ENDIF
      *
      ** Check If Records Were Written into the Subfile
      *
     C                   IF        WLstRrn <> *ZEROS
     C                   EVAL      SflDsp = *ON
     C                   ELSE
      *
      ** If No Records Exists, then show 'No Data to Display' Message
      *
     C                   EVAL      SflDsp = *OFF
     C                   EVAL      NoData = *ON
     C                   EVAL      PZMsgId = 'ASM0001'
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrSfl - Process the Subfile                                *
      *                                                               *
      *  Called by: SRProcess                                         *
      *                                                               *
      *  Calls: SRErrDta, SRScreen2                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRPrSfl       BEGSR
      *
     C                   IF        WLstRrn > *ZEROS
      *
      ** Reset Error Flag
      *
     C                   EVAL      WError = 'N'
     C                   READC     SD001006S0
     C                   DOW       NOT %EOF
      *
     C                   EVAL      WIdx = *ZEROS
      *
      ** Validation for Invalid Action Code
      ** in case of maintenance mode
      *
     C                   IF        (M1Actd <> Amend)   AND
     C                             (M1Actd <> Copy)    AND
     C                             (M1Actd <> Enquire) AND
     C                             (M1Actd <> Delete)  AND
     C                             (M1Actd <> *BLANKS) AND
     C                             (PMode = 'M')
      *
     C                   EVAL      PZMsgId = 'SWF0019'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
      ** Validation for Action code - in case of Enquire mode
      *
     C                   ELSEIF    (M1Actd <> Enquire) AND
     C                             (M1Actd <> *BLANKS) AND
     C                             (PMode = 'E')
      *
     C                   EVAL      PZMsgId = 'SWF0019'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
      ** Cannot delete DST Code if in use by Time Zone File
      *
     C                   ELSEIF    (M1Actd = Delete)
     C     M1DSCD        CHAIN     SDTIZOL2
     C                   IF        %FOUND(SDTIZOL2)
     C                   EVAL      PZMsgId = 'SWF0038'
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      *
      ** If User doesn't have required authority
      *
     C                   IF        WIdx > *ZEROS
     C                   EVAL      WError = 'Y'
     C                   EVAL      ActnErr = *ON
     C                   EVAL      D0SFRN = RRN0
     C                   ELSE
     C                   EVAL      ActnErr = *OFF
     C                   ENDIF
      *
     C                   EVAL      *IN34 = *ON
     C                   UPDATE    SD001006S0
      *
     C                   READC     SD001006S0
      *
     C                   ENDDO
      *
     C                   EVAL      *IN34 = *OFF
      *
      ** If Error, Stop Processing Further
      *
     C                   IF        ((WError = 'Y') OR
     C                             ((WError = 'N') AND
     C                             (M1DSCDS <> WCDscd OR
     C                              M1YEARS <> WCYear OR
     C                              M1OFFSS <> WCOffs OR
     C                              M1DSDTS <> WCDsdt OR
     C                              M1DSEDS <> WCDsed)) OR
     C                             Add = *ON)
     C                   LEAVESR
     C                   ENDIF
      *
     C                   READC     SD001006S0
      *
     C                   DOW       NOT %EOF
      *
      ** Call the Maintenance Program In Amend Mode
      *
     C                   IF        M1ACTD <> *BLANKS
      *
      ** Display Maintenance Screen
      *
     C                   EXSR      SRScreen2
      *
      ** When 'F3' is Pressed, Return to Main Menu
      *
     C                   IF        PRetCode = 'F3'
     C                   EVAL      Exit = 'Y'
     C                   EVAL      WError = 'Y'
     C                   LEAVE
     C                   ENDIF
      *
     C                   EVAL      M1ACTD = *BLANKS
      *
     C                   Update    SD001006S0
      *
     C                   ENDIF
     C                   READC     SD001006S0
      *
     C                   ENDDo
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInsert - Insert A New Record In The File                   *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: SRReset2, SRDSTVal, SRFldVal, SRZDate1                *
      *                                                               *
      *****************************************************************
      *
     C     SRInsert      BEGSR
      *
     C                   EXSR      SRReset2
      *
     C                   EXSR      SRDSTVal
      *
     C                   IF        WIdx = 0
     C                   EXSR      SRReset2
     C                   EVAL      *IN59 = *ON
     C                   EVAL      *IN40 = *OFF
      *
     C                   DOW       F3 = *OFF AND
     C                             F12 = *OFF
 
     C                   WRITE     SD001006F0
     C                   WRITE     SD001006C1
     C                   EXFMT     SD001006R0
      *
     C                   EXSR      SRReset2
     C                   EXSR      SRFldVal
      *
     C                   SELECT
      *
     C                   WHEN      F3 = *ON
     C                   EVAL      PRetCode = 'F3'
      *
     C                   WHEN      Refresh = *ON
     C                   EVAL      DDDESC = *BLANKS
     C                   EVAL      DDOFFS = *BLANKS
     C                   EVAL      DDDSDT = *BLANKS
     C**********         EVAL      DDDSDH = *BLANKS                                         BUG19522
     C                   EVAL      DDDSDH = *ZEROS                                          BUG19522
     C                   EVAL      DDDSTM = *BLANKS
     C                   EVAL      DDDSTW = *BLANKS
     C                   EVAL      DDDSTD = *BLANKS
     C                   EVAL      DDDSED = *BLANKS
     C**********         EVAL      DDDENH = *BLANKS                                         BUG19522
     C                   EVAL      DDDENH = *ZEROS                                          BUG19522
     C                   EVAL      DDDENM = *BLANKS
     C                   EVAL      DDDENW = *BLANKS
     C                   EVAL      DDDEND = *BLANKS
      *
     C                   WHEN      F12 = *ON
     C                   EVAL      PRetCode = 'F12'
      *
      ** Clear Program Queue And Message File
      *
     C                   CALL      'ZA0250'
 
     C                   OTHER
     C                   IF        WIdx = 0
      *
     C                   EVAL      DSRECI = 'D'
     C                   EVAL      DSDSCD = DDDSCD
     C                   EVAL      DSYEAR = DDYEAR
     C                   EVAL      DSDESC = DDDESC
     C                   MOVE      DDOFFS        DSOFFS
      *
      ** Start Date
      *
     C                   EVAL      PZDate = DDDSDT
     C                   EXSR      SRZDate1
     C                   Z-ADD     PZDayNo       DSDSDT
      *
     C                   MOVE      DDDSDH        DSDSDH
     C                   MOVE      DDDSTM        DSDSTM
     C                   MOVE      DDDSTW        DSDSTW
     C                   MOVE      DDDSTD        DSDSTD
      *
      ** End Date
      *
     C                   EVAL      PZDate = DDDSED
     C                   EXSR      SRZDate1
     C                   Z-ADD     PZDayNo       DSDSED
      *
     C                   MOVE      DDDENH        DSDENH
     C                   MOVE      DDDENM        DSDENM
     C                   MOVE      DDDENW        DSDENW
     C                   MOVE      DDDEND        DSDEND
     C                   EVAL      DSUSER =     D0USER
      *
     C                   Z-ADD     BJRDNB        DSLCD
     C                   EVAL      DSLCT = Insert
      *
      ** Write record to the DST Code file
      *
     C                   WRITE     SDDSTCD0
      *
     C                   EVAL      F12 = *ON
      *
     C                   ENDIF
     C                   ENDSL
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAmend - Amend The Record Subroutine                        *
      *                                                               *
      *  Called by: SRScreen2                                         *
      *                                                               *
      *  Calls: SRReset, SRFldVal, SRZDate1, SRTimZonHst              *
      *                                                               *
      *****************************************************************
      *
     C     SRAmend       BEGSR
      *
     C                   EXSR      SRReset2
      *
     C                   EXSR      SRFldVal
      *
     C                   IF        WIdx = 0
      *
     C                   IF        D@OFFS <> DDOFFS OR
     C                             D@DSDT <> DDDSDT OR
     C                             D@DSDH <> DDDSDH OR
     C                             D@DSTM <> DDDSTM OR
     C                             D@DSTW <> DDDSTW OR
     C                             D@DSED <> DDDSED OR
     C                             D@DENH <> DDDENH OR
     C                             D@DENM <> DDDENM OR
     C                             D@DENW <> DDDENW OR
     C                             D@DEND <> DDDEND
      *
      ** Update Time Zone History File
      *
     C                   EXSR      SRTimZonHst
     C                   ENDIF
      *
      ** If Valid, Update Database
      *
     C                   EVAL      DSRECI = 'D'
     C                   EVAL      DSDSCD = DDDSCD
     C                   EVAL      DSYEAR = DDYEAR
     C                   EVAL      DSDESC = DDDESC
     C                   MOVE      DDOFFS        DSOFFS
      *
      ** Start Date
      *
     C                   EVAL      PZDate = DDDSDT
     C                   EXSR      SRZDate1
     C                   EVAL      DSDSDT = PZDayNo
      *
     C                   MOVE      DDDSDH        DSDSDH
     C                   MOVE      DDDSTM        DSDSTM
     C                   MOVE      DDDSTW        DSDSTW
     C                   MOVE      DDDSTD        DSDSTD
      *
      ** End Date
      *
     C                   EVAL      PZDate = DDDSED
     C                   EXSR      SRZDate1
     C                   EVAL      DSDSED = PZDayNo
      *
     C                   MOVE      DDDENH        DSDENH
     C                   MOVE      DDDENM        DSDENM
     C                   MOVE      DDDENW        DSDENW
     C                   MOVE      DDDEND        DSDEND
     C                   EVAL      DSUSER = D0USER
      *
     C                   Z-ADD     BJRDNB        DSLCD
     C                   EVAL      DSLCT = Amend
      *
      ** Update the DST Code file
      *
     C                   UPDATE    SDDSTCD0
      *
     C                   EVAL      F12 = *ON
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCopy - Copy The Record Subroutine                          *
      *                                                               *
      *  Called by: SRScreen2                                         *
      *                                                               *
      *  Calls: SRReset2, SRDSTVal, SRFldVal, SRZDate1                *
      *                                                               *
      *****************************************************************
      *
     C     SRCopy        BEGSR
      *
     C                   EXSR      SRReset2
      *
     C                   EXSR      SRDSTVal
     C                   EXSR      SRFldVal                                                 BUG19524
      *
     C                   IF        WIdx = 0
     C                   EXSR      SRReset2
     C                   EVAL      *IN59 = *ON
     C                   EVAL      *IN40 = *OFF
      *
     C                   DOW       F3 = *OFF AND
     C                             F12 = *OFF
 
     C                   WRITE     SD001006F0
     C                   WRITE     SD001006C1
     C                   EXFMT     SD001006R0
      *
     C                   EXSR      SRReset2
     C                   EXSR      SRFldVal
      *
     C                   SELECT
      *
      ** Exit
      *
     C                   WHEN      F3 = *ON
     C                   EVAL      PRetCode = 'F3'
      *
      **  Refresh Screen
      *
     C                   WHEN      Refresh = *ON
     C                   EVAL      DDDESC = *BLANKS
     C                   EVAL      DDOFFS = *BLANKS
     C                   EVAL      DDDSDT = *BLANKS
     C**********         EVAL      DDDSDH = *BLANKS                                         BUG19522
     C                   EVAL      DDDSDH = *ZEROS                                          BUG19522
     C                   EVAL      DDDSTM = *BLANKS
     C                   EVAL      DDDSTW = *BLANKS
     C                   EVAL      DDDSTD = *BLANKS
     C                   EVAL      DDDSED = *BLANKS
     C**********         EVAL      DDDENH = *BLANKS                                         BUG19522
     C                   EVAL      DDDENH = *ZEROS                                          BUG19522
     C                   EVAL      DDDENM = *BLANKS
     C                   EVAL      DDDENW = *BLANKS
     C                   EVAL      DDDEND = *BLANKS
      *
     C                   WHEN      F12 = *ON
     C                   EVAL      PRetCode = 'F12'
 
     C                   OTHER
     C                   IF        WIdx = 0
      *
      ** If all field are valid, copy record to the database
      *
     C                   EVAL      DSRECI = 'D'
     C                   EVAL      DSDSCD = DDDSCD
     C                   EVAL      DSYEAR = DDYEAR
     C                   EVAL      DSDESC = DDDESC
     C                   MOVE      DDOFFS        DSOFFS
      *
      ** Start Date
      *
     C                   EVAL      PZDate = DDDSDT
     C                   EXSR      SRZDate1
     C                   EVAL      DSDSDT = PZDayNo
      *
     C                   MOVE      DDDSDH        DSDSDH
     C                   MOVE      DDDSTM        DSDSTM
     C                   MOVE      DDDSTW        DSDSTW
     C                   MOVE      DDDSTD        DSDSTD
      *
      ** End Date
      *
     C                   EVAL      PZDate = DDDSED
     C                   EXSR      SRZDate1
     C                   EVAL      DSDSED = PZDayNo
      *
     C                   MOVE      DDDENH        DSDENH
     C                   MOVE      DDDENM        DSDENM
     C                   MOVE      DDDENW        DSDENW
     C                   MOVE      DDDEND        DSDEND
     C                   EVAL      DSUSER = D0USER
      *
     C                   Z-ADD     BJRDNB        DSLCD
     C                   EVAL      DSLCT = Insert
      *
      ** Write to DST Code file
      *
     C                   WRITE     SDDSTCD0
      *
     C                   EVAL      F12 = *ON
      *
     C                   ENDIF
     C                   ENDSL
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRDelete - Delete The Select Record                          *
      *                                                               *
      *  Called by: SRScreen2                                         *
      *                                                               *
      *  Calls: SRTimZonHst, SRErrDta                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRDelete      BEGSR
      *
     C                   IF        *IN10 = *ON
     C                   EVAL      DSRECI = '*'
     C                   EVAL      DSLCT  = Delete
     C                   UPDATE    SDDSTCD0
     C                   EVAL      F12 = *ON
      *
      ** Write deleted record in the Time Zone History File.
      *
     C                   EXSR      SRTimZonHst
      *
     C                   ELSE
     C                   EVAL      WIdx = *ZEROS
      *
      ** Clear Program Message Queue
      *
     C                   CALL      'ZA0250'
      *
     C                   EVAL      PZMsgId = 'ASM0028'
     C                   EVAL      WIdx = WIdx
     C                   EXSR      SRErrDta
      *
     C                   ENDIF
      *
     C                   EVAL      *IN42 = *OFF
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTimZonHst - Every record changed in DST Code write it in   *
      *                the Time Zone History File                     *
      *                                                               *
      *  Called by: SRAmend\SRDelete                                  *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRTimZonHst   BEGSR
      *
      ** Get Time Zone Detail Record by DST Code and Year
      *
     C     Key3          SETLL     SDTIZOL2
     C     Key3          READE     SDTIZOL2
     C                   DOW       NOT %EOF(SDTIZOL2)
      *
      ** Get MIC Code
      *
     C                   IF        V_TZTZCD <> PrevTZone
     C*
     C                   EVAL      PrevTZone = V_TZTZCD
     C                   EVAL      KDSTC = DSDSCD
     C                   EVAL      KTZCD = V_TZTZCD
     C                   EVAL      KYEAR = DSYEAR
     C     KeyHST        CHAIN     SDTIZOL7
     C                   IF        %FOUND(SDTIZOL7)
     C                   EXSR      SRUpdate
     C                   ELSE
     C                   EVAL      KYEAR = *BLANKS
     C     KeyHST        CHAIN     SDTIZOL7
     C                   IF        %FOUND(SDTIZOL7)
     C                   EXSR      SRUpdate
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     Key3          READE     SDTIZOL2
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Save DST changes in Tim Zone History File         *
      *                                                               *
      *  Called by: SRUpdate                                          *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdate      BEGSR
      *
      ** Check for Branch Level
      *
     C                   EVAL      KTZLC = BrchLvl
     C                   EVAL      KTZCD = TZTZCD
     C                   EVAL      KYEAR = TZYEAR
     C                   EVAL      PZDate = DDDSDT                                          BUG21232
     C                   EXSR      SRZDate1                                                 BUG21232
     C                   Z-ADD     PZDayNo       nStrDate                                   BUG21232
     C                   EVAL      PZDate = DDDSED                                          BUG21232
     C                   EXSR      SRZDate1                                                 BUG21232
     C                   Z-ADD     PZDayNo       nEndDate                                   BUG21232
     C     KeyTZLV       CHAIN     SDTZLVL4
     C                   IF        %FOUND(SDTZLVL4)
     C                   DOW       Not %Eof(SDTZLVL4) AND                                   BUG21232
     C                             TLTZCD = KTZCD     AND                                   BUG21232
     C                             TLYEAR = KYEAR     AND                                   BUG21232
     C                             TLTZLC = KTZLC                                           BUG21232
      *                                                                                     BUG21232
     C                   EVAL      PBrc = TLBRCA                                            BUG21232
     C                   EXSR      SRChkDSTFlag                                             BUG21232
     C     TLBRCA        CHAIN     SDBRCHL0
     C                   IF        %FOUND(SDBRCHL0)
      *
      ** Branch Offset
      *
     C**********         IF        BJRDNB >= DSDSDT AND                                     BUG21232
     C**********                   BJRDNB <= DSDSED                                         BUG21232
     C                   EVAL      WTmpOffset = TZGMT                                       BUG21232
     C                   EVAL      OffSign = TZGMTS                                         BUG21232
     C                   IF        cDSTFlag = 'Y'                                           BUG21232
     C**********         EVAL      WOfSt = DSOFFS                                           BUG21232
     C                   MOVE      DDOFFS        WOfSt                                      BUG21232
     C                   EVAL      DSOFFS  =  WOfSt                                         BUG21232
     C**********         EVAL      WTmpOffset = A8TMOF                                      BUG21232
     C**********         EVAL      OffSign = A8SIGN                                         BUG21232
     C                   EXSR      SRCalcOff
     C                   MOVEL     WTime1        A8TMOF
     C                   ELSE                                                               BUG21232
     C                   MOVE      TZGMT         A8TMOF                                     BUG21232
     C                   ENDIF
     C                   UPDATE    @A8REB1
     C                   ENDIF
     C                   READ      SDTZLVL4                                                 BUG21232
     C                   ENDDO                                                              BUG21232
     C                   ENDIF
      *
      ** Check for System Level
      *
     C                   EVAL      KTZLC = SysLvl
     C                   EXSR      SRChkDSTFlag                                             BUG21232
     C                   EVAL      KTZCD = TZTZCD
     C                   EVAL      KYEAR = TZYEAR
     C     KeyTZLV       CHAIN     SDTZLVL4
     C                   IF        %FOUND(SDTZLVL4)
     C     TLBRCA        CHAIN     SDBRCHL0
     C                   IF        %FOUND(SDBRCHL0)
      *
      ** System Offset
      *
      **********         IF        BJRDNB >= DSDSDT AND                                     BUG21232
     C**********                   BJRDNB <= DSDSED                                         BUG21232
     C                   EVAL      WTmpOffset = TZGMT                                       BUG21232
     C                   EVAL      OffSign = TZGMTS                                         BUG21232
     C                   IF        cDSTFlag = 'Y'                                           BUG21232
     C**********         EVAL      WOfSt = DSOFFS                                           BUG21232
     C                   MOVE      DDOFFS        WOfSt                                      BUG21232
     C                   EVAL      DSOFFS  =  WOfSt                                         BUG21232
     C**********         EVAL      WTmpOffset = A8STOF                                      BUG21232
     C**********         EVAL      OffSign = A8SSIN                                         BUG21232
     C                   EXSR      SRCalcOff
     C                   MOVEL     WTime1        A8STOF
     C                   ELSE                                                               BUG21232
     C                   MOVEL     TZGMT         A8STOF                                     BUG21232
     C                   ENDIF
     C                   UPDATE    @A8REB1
     C                   ENDIF
     C                   ENDIF
     C*
     C                   EVAL      KDSTC = DSDSCD
     C                   EVAL      KTZCD = TZTZCD
     C                   EVAL      KYEAR = DDYEAR
     C     KEYHST        CHAIN     SDTIZHL2
     C                   IF        %FOUND(SDTIZHL2) AND
     C                             THEFFD = BJRDNB
      *
      ** If record already exist, Update Database
      *
     C                   EVAL      THRECI = '*'
      *
      ** Get TimeStamp
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      THTMST = TimeStamp
      *
      ** Update Time Zone History file
      *
     C                   UPDATE    SDTIZHD0
      *
     C                   ENDIF
      *
      ** Write New Record to the Zone History file
      *
     C                   EXSR      SRUpdHst
      *
     C                   WRITE     SDTIZHD0
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdHst - Save DST changes in Tim Zone History File         *
      *                                                               *
      *  Called by: SRTimZonHst                                       *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdHst      BEGSR
      *
      ** Record ID
      *
     C                   EVAL      THRECI = 'D'
      *
      ** Time Zone Code
      *
     C                   EVAL      THTZCD = TZTZCD
      *
      ** Year
      *
     C                   EVAL      THYEAR = DDYEAR
      *
      ** Effective Date
      *
     C                   Z-ADD     BJRDNB        THEFFD
      *
      ** DST Code
      *
     C                   EVAL      THDSTC = DDDSCD
      *
      ** DST Flag
      *
     C                   EVAL      THDSTF = TZDSTF
      *
      ** GMT Offset
      *
     C                   EVAL      THGMTO = TZGMT
      *
      ** GMT Offset Sign
      *
     C                   EVAL      THGMTS = TZGMTS
      *
      ** DST Start Date
      *
     C                   EVAL      THDSTS = DSDSDT
      *
      ** DST Start Time
      *
     C                   EVAL      THSTIM = DSDSDH
      *
      ** DST End Date
      *
     C                   EVAL      THDSTE = DSDSED
      *
      ** DST End Time
      *
     C                   EVAL      THETIM = DSDENH
      *
      ** DST Offset
      *
     C                   EVAL      THDSTO = DSOFFS
      *
      ** TimeStamp
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      THTMST = TimeStamp
      *
      ** Effective Offset
      *
     C                   IF        BJRDNB >= DSDSDT AND
     C                             BJRDNB <= DSDSED
     C                   EVAL      WOfSt = DSOFFS
     C                   EVAL      WTmpOffset = TZGMT
     C                   EVAL      OffSign = TZGMTS
     C                   EXSR      SRCalcOff
     C                   MOVEL     WTime1        THEFFO
     C                   ELSE
     C                   EVAL      THEFFO = TZGMT
     C                   ENDIF
      *
      ** Effective Offset Sign
      *
     C                   EVAL      THEFFS = TZGMTS
      *
      ** Type Of Change
      *
     C                   EVAL      THTYLC = DSTCodeChg
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCalcOff - Calculate Offset                                  *
      *                                                               *
      * Called by: SRUpdHst                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCalcOff     BEGSR
      *
      ** Calculate Effective Offset
      *
     C                   MOVEL     '000000'      WTmp
     C                   MOVEL     WTmpOffset    WTmp
     C                   EVAL      WTime = %TIME(WTmp:*HMS0)
     C                   IF        (OffSign = '+')
     C                   ADDDUR    WOfSt:*MN     WTime
     C                   ELSE
     C                   SUBDUR    WOfSt:*MN     WTime
     C                   ENDIF
     C                   EVAL      WTime1  = %Char(WTime:*Hms0)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFldVal - Validate The Data Of The Fields                   *
      *                                                               *
      *  Called by: SRInsert, SRAmend, SRCopy                         *
      *                                                               *
      *  Calls: SRErrDta, SRZDate1                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRFldVal      BEGSR
     C
     C                   MOVE      DDYEAR        CurrYr
     C                   MOVE      *ZEROS        WarnIdx           3 0                      BUG19156
      *
      ** Description must not be blanks
      *
     C                   IF        DDDESC = *BLANKS
     C                   EVAL      PZMsgId = 'SWF0003'
     C                   EVAL      *IN72 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      **********                                                                            BUG19134
      ***Offset*time*is*mandatory*                                                          BUG19134
      **********                                                                            BUG19134
     C                   EVAL      ZFIELD = DDOFFS                                          BUG19135
     C                   EVAL      ZADIG = 3                                                BUG19135
     C                   EXSR      SrZalign                                                 BUG19135
     C                   IF        ZALIGNok= 'Y'                                            BUG19135
     C                   EVALR     DDOFFS = ZFIELD                                          BUG19135
     C                   ENDIF                                                              BUG19135
     C                   IF        DDOFFS = *BLANKS OR
     C                             DDOFFS = *ZEROS
     C**********         EVAL      PZMsgId = 'SWF0004'                                      BUG19134
     C**********         EVAL      *IN73 = *ON                                              BUG19134
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19134
     C**********         EXSR      SRErrDta                                                 BUG19134
     C                   MOVE      '060'         DDOFFS                                     BUG19134
     C                   ELSE
      *
      ** Offset should be numeric.
      *
     C                   IF        %CHECK(Digits: %TRIM(DDOFFS)) <> 0
     C                   EVAL      PZMsgID = 'SWF0005'
     C                   EVAL      *IN73 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      *                                                                                     BUG20945
     C                   IF        DDDSTM <> *BLANKS OR                                     BUG20945
     C                             DDDENM <> *BLANKS OR                                     BUG20945
     C                             DDDSTD <> *BLANKS OR                                     BUG20945
     C                             DDDEND <> *BLANKS OR                                     BUG20945
     C                             DDDSTW <> *BLANKS OR                                     BUG20945
     C                             DDDENW <> *BLANKS                                        BUG20945
      *                                                                                     BUG19250
      ** DST Start Month                                                                    BUG19250
      *                                                                                     BUG19250
     C                   IF        DDDSTM = *BLANKS                                         BUG19250
     C                   EVAL      PZMsgId = 'SWF0010'                                      BUG19250
     C                   EVAL      *IN78 = *ON                                              BUG19250
     C                   EVAL      WIdx = WIdx + 1                                          BUG19250
     C                   EXSR      SRErrDta                                                 BUG19250
     C                   ELSE                                                               BUG19250
     C                   EVAL      WPos = %SCAN('?':DDDSTM)                                 BUG19250
     C                   IF        WPos <> *ZEROS                                           BUG19250
     C                   CALL      'Y2VLLSR'                                                BUG19250
     C                   PARM                    PrtCd                                      BUG19250
     C                   PARM      1105001       Y2Lsno                                     BUG19250
     C     DDDSTM        PARM                    Selection                                  BUG19250
     C                   ELSE                                                               BUG19250
                                                                                            BUG19250
     C                   EVAL      ZFIELD = DDDSTM                                          BUG19250
     C                   EVAL      ZADIG = 2                                                BUG19250
     C                   EXSR      SrZalign                                                 BUG19250
                                                                                            BUG19250
     C                   IF        ZALIGNok= 'Y'                                            BUG19250
     C                   EVALR     DDDSTM = ZFIELD                                          BUG19250
     C                   ENDIF                                                              BUG19250
                                                                                            BUG19250
     C                   EVAL      NPos = %LOOKUP(DDDSTM:DSTMON)                            BUG19250
     C                   IF        NPos = 0                                                 BUG19250
     C                   EVAL      PZMsgId = 'SWF0016'                                      BUG19250
     C                   EVAL      *IN78 = *ON                                              BUG19250
     C                   EVAL      WIdx = WIdx + 1                                          BUG19250
     C                   EXSR      SRErrDta                                                 BUG19250
     C                   ENDIF                                                              BUG19250
     C                   ENDIF                                                              BUG19250
     C                   ENDIF                                                              BUG19250
      *                                                                                     BUG19250
      ** DST End Month                                                                      BUG19250
      *                                                                                     BUG19250
     C                   IF        DDDENM = *BLANKS                                         BUG19250
     C                   EVAL      PZMsgId = 'SWF0015'                                      BUG19250
     C                   EVAL      *IN79 = *ON                                              BUG19250
     C                   EVAL      WIdx = WIdx + 1                                          BUG19250
     C                   EXSR      SRErrDta                                                 BUG19250
     C                   ELSE                                                               BUG19250
     C                   EVAL      WPos = %SCAN('?':DDDENM)                                 BUG19250
     C                   IF        WPos <> *ZEROS                                           BUG19250
     C                   CALL      'Y2VLLSR'                                                BUG19250
     C                   PARM                    PrtCd                                      BUG19250
     C                   PARM      1105001       Y2Lsno                                     BUG19250
     C     DDDENM        PARM                    Selection                                  BUG19250
     C                   ELSE                                                               BUG19250
                                                                                            BUG19250
     C                   EVAL      ZFIELD = DDDENM                                          BUG19250
     C                   EVAL      ZADIG = 2                                                BUG19250
     C                   EXSR      SrZalign                                                 BUG19250
                                                                                            BUG19250
     C                   IF        ZALIGNok= 'Y'                                            BUG19250
     C                   EVALR     DDDENM = ZFIELD                                          BUG19250
     C                   ENDIF                                                              BUG19250
                                                                                            BUG19250
     C                   EVAL      NPos = %LOOKUP(DDDENM:DSTMON)                            BUG19250
     C                   IF        NPos = 0                                                 BUG19250
     C                   EVAL      PZMsgId = 'SWF0016'                                      BUG19250
     C                   EVAL      *IN79 = *ON                                              BUG19250
     C                   EVAL      WIdx = WIdx + 1                                          BUG19250
     C                   EXSR      SRErrDta                                                 BUG19250
     C                   ENDIF                                                              BUG19250
     C                   ENDIF                                                              BUG19250
     C                   ENDIF                                                              BUG19250
      *                                                                                     BUG19250
      ** DST Start Week                                                                     BUG19250
      *                                                                                     BUG19250
     C                   IF        DDDSTW = *BLANKS                                         BUG19250
     C                   EVAL      PZMsgId = 'SWF0010'                                      BUG19250
     C                   EVAL      *IN80 = *ON                                              BUG19250
     C                   EVAL      WIdx = WIdx + 1                                          BUG19250
     C                   EXSR      SRErrDta                                                 BUG19250
     C                   ELSE                                                               BUG19250
     C                   EVAL      WPos = %SCAN('?':DDDSTW)                                 BUG19250
     C                   IF        WPos <> *ZEROS                                           BUG19250
     C                   CALL      'Y2VLLSR'                                                BUG19250
     C                   PARM                    PrtCd                                      BUG19250
     C                   PARM      1105002       Y2Lsno                                     BUG19250
     C     DDDSTW        PARM                    Selection                                  BUG19250
     C                   ELSE                                                               BUG19250
     C                   IF        %CHECK(DSTWk:DDDSTW) <> 0                                BUG19250
     C                   EVAL      PZMsgId = 'SWF0017'                                      BUG19250
     C                   EVAL      *IN80 = *ON                                              BUG19250
     C                   EVAL      WIdx = WIdx + 1                                          BUG19250
     C                   EXSR      SRErrDta                                                 BUG19250
     C                   ENDIF                                                              BUG19250
     C                   ENDIF                                                              BUG19250
     C                   ENDIF                                                              BUG19250
      *                                                                                     BUG19250
      ** DST End Week                                                                       BUG19250
      *                                                                                     BUG19250
     C                   IF        DDDENW = *BLANKS                                         BUG19250
     C                   EVAL      PZMsgId = 'SWF0015'                                      BUG19250
     C                   EVAL      *IN81 = *ON                                              BUG19250
     C                   EVAL      WIdx = WIdx + 1                                          BUG19250
     C                   EXSR      SRErrDta                                                 BUG19250
     C                   ELSE                                                               BUG19250
     C                   EVAL      WPos = %SCAN('?':DDDENW)                                 BUG19250
     C                   IF        WPos <> *ZEROS                                           BUG19250
     C                   Call      'Y2VLLSR'                                                BUG19250
     C                   PARM                    PrtCd                                      BUG19250
     C                   PARM      1105002       Y2Lsno                                     BUG19250
     C     DDDENW        PARM                    Selection                                  BUG19250
     C                   ELSE                                                               BUG19250
     C                   IF        %CHECK(DSTWk:DDDENW) <> 0                                BUG19250
     C                   EVAL      PZMsgId = 'SWF0017'                                      BUG19250
     C                   EVAL      *IN81 = *ON                                              BUG19250
     C                   EVAL      WIdx = WIdx + 1                                          BUG19250
     C                   EXSR      SRErrDta                                                 BUG19250
     C                   ENDIF                                                              BUG19250
     C                   ENDIF                                                              BUG19250
     C                   ENDIF                                                              BUG19250
      *                                                                                     BUG19250
      ** DST Start Day                                                                      BUG19250
      *                                                                                     BUG19250
     C                   IF        DDDSTD = *BLANKS                                         BUG19250
     C                   EVAL      PZMsgId = 'SWF0010'                                      BUG19250
     C                   EVAL      *IN82 = *ON                                              BUG19250
     C                   EVAL      WIdx = WIdx + 1                                          BUG19250
     C                   EXSR      SRErrDta                                                 BUG19250
     C                   ELSE                                                               BUG19250
     C                   EVAL      WPos = %SCAN('?':DDDSTD)                                 BUG19250
     C                   IF        WPos <> *ZEROS                                           BUG19250
     C                   CALL      'Y2VLLSR'                                                BUG19250
     C                   PARM                    PrtCd                                      BUG19250
     C                   PARM      1105003       Y2Lsno                                     BUG19250
     C     DDDSTD        PARM                    Selection                                  BUG19250
     C                   ELSE                                                               BUG19250
                                                                                            BUG19250
     C                   EVAL      ZFIELD = DDDSTD                                          BUG19250
     C                   EVAL      ZADIG = 2                                                BUG19250
     C                   EXSR      SrZalign                                                 BUG19250
                                                                                            BUG19250
     C                   IF        ZALIGNok= 'Y'                                            BUG19250
     C                   EVALR     DDDSTD = ZFIELD                                          BUG19250
     C                   ENDIF                                                              BUG19250
                                                                                            BUG19250
     C                   EVAL      NPos = %LOOKUP(DDDSTD:DSTDay)                            BUG19250
     C                   IF        NPos = 0                                                 BUG19250
     C                   EVAL      PZMsgId = 'SWF0018'                                      BUG19250
     C                   EVAL      *IN82 = *ON                                              BUG19250
     C                   EVAL      WIdx = WIdx + 1                                          BUG19250
     C                   EXSR      SRErrDta                                                 BUG19250
     C                   ENDIF                                                              BUG19250
     C                   ENDIF                                                              BUG19250
     C                   ENDIF                                                              BUG19250
      *                                                                                     BUG19250
      ** DST End Day                                                                        BUG19250
      *                                                                                     BUG19250
     C                   IF        DDDEND = *BLANKS                                         BUG19250
     C                   EVAL      PZMsgId = 'SWF0015'                                      BUG19250
     C                   EVAL      *IN83 = *ON                                              BUG19250
     C                   EVAL      WIdx = WIdx + 1                                          BUG19250
     C                   EXSR      SRErrDta                                                 BUG19250
     C                   ELSE                                                               BUG19250
     C                   EVAL      WPos = %SCAN('?':DDDEND)                                 BUG19250
     C                   IF        WPos <> *ZEROS                                           BUG19250
     C                   CALL      'Y2VLLSR'                                                BUG19250
     C                   PARM                    PrtCd                                      BUG19250
     C                   PARM      1105003       Y2Lsno                                     BUG19250
     C     DDDEND        PARM                    Selection                                  BUG19250
     C                   ELSE                                                               BUG19250
                                                                                            BUG19250
     C                   EVAL      ZFIELD = DDDEND                                          BUG19250
     C                   EVAL      ZADIG = 2                                                BUG19250
     C                   EXSR      SrZalign                                                 BUG19250
                                                                                            BUG19250
     C                   IF        ZALIGNok= 'Y'                                            BUG19250
     C                   EVALR     DDDEND = ZFIELD                                          BUG19250
     C                   ENDIF                                                              BUG19250
                                                                                            BUG19250
     C                   EVAL      NPos = %LOOKUP(DDDEND:DSTDAY)                            BUG19250
     C                   IF        NPos = 0                                                 BUG19250
     C                   EVAL      PZMsgId = 'SWF0018'                                      BUG19250
     C                   EVAL      *IN83 = *ON                                              BUG19250
     C                   EVAL      WIdx = WIdx + 1                                          BUG19250
     C                   EXSR      SRErrDta                                                 BUG19250
     C                   ENDIF                                                              BUG19250
     C                   ENDIF                                                              BUG19250
     C                   ENDIF                                                              BUG19250
      *
      ** If DST Start Date is blank, populate it from Start Month, Day and Year entered
      *
     C                   IF        DDDSDT = *BLANKS AND
     C                             WIdx = 0 AND                                             BUG20628
     C                             DDDSTD <> *BLANKS AND
     C                             DDDSTW <> *BLANKS AND
     C                             DDDSTM <> *BLANKS
      *
     C                   CALLB     'ZFINDDATE'
     C                   PARM                    DDDSTD
     C                   PARM                    DDDSTW
     C                   PARM                    DDDSTM
     C                   PARM                    DDYEAR
     C                   PARM      BJDFIN        PDateFmt
     C                   PARM                    POutDate5
     C                   PARM                    POutDate6
      *
     C                   EVAL      DDDSDT = POutDate6
      *
     C                   ELSE
      *
     C                   MOVE      DDDSDT        DateYR
     C                   IF        DateYr <> CurrYr
     C                   EVAL      PZMsgId = 'SWF0039'
     C                   EVAL      *IN74 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ELSE
     C                   EVAL      PZDate = DDDSDT
     C                   EXSR      SRZDate1
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      PZMsgId = 'USR1040'
     C                   EVAL      *IN74 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If End Month is less than Start Month, add 1 to the year
      *
     C                   IF        DDDENM < DDDSTM
     C                   MOVE      DDYEAR        @Year
     C                   EVAL      @Year = @Year + 1
     C                   MOVEL     @Year         WTZYear
     C                   MOVE      WTZYear       NextYR
     C                   ELSE
     C                   MOVE      DDYEAR        WTZYear
     C                   ENDIF
      *
      ** If DST End Date is blank, populate it from End Month, Day and Year entered
      *
     C                   IF        DDDSED = *BLANKS AND
     C                             Widx = 0         AND                                     BUG21232
     C                             DDDEND <> *BLANKS AND
     C                             DDDENW <> *BLANKS AND
     C                             DDDENM <> *BLANKS
      *
     C                   CALLB     'ZFINDDATE'
     C                   PARM                    DDDEND
     C                   PARM                    DDDENW
     C                   PARM                    DDDENM
     C                   PARM                    WTZYear
     C                   PARM      BJDFIN        PDateFmt
     C                   PARM                    POutDate5
     C                   PARM                    POutDate6
      *
     C                   EVAL      DDDSED = POutDate6
      *
     C                   ELSE
     C                   IF        DDDEND <> *BLANKS AND                                    BUG19157
     C                             DDDENW <> *BLANKS AND                                    BUG19157
     C                             DDDENM <> *BLANKS                                        BUG19157
     C                   MOVE      DDDSED        DateYR
     C                   SELECT
     C                   WHEN      DDDENM >= DDDSTM AND
     C                             DateYr <> CurrYr
     C                   EVAL      PZMsgId = 'SWF0040'
     C                   EVAL      *IN75 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   WHEN      DDDENM < DDDSTM AND
     C                             DateYr <> NextYr
     C                   EVAL      PZMsgId = 'SWF0041'
     C                   EVAL      *IN75 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   OTHER
     C                   EVAL      PZDate  = DDDSED
     C                   EXSR      SRZDate1
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      PZMsgId = 'USR1040'
     C                   EVAL      *IN75 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF                                                              BUG19157
     C                   ELSE                                                               BUG21207
     C                   IF        M1Actd = Copy                                            BUG21207
     C                   EXSR      SRGetYearVal                                             BUG21207
     C                   EVAL      DDDSDT = S@DSDT                                          BUG21207
     C                   EVAL      DDDSED = S@DSED                                          BUG21207
     C                   ENDIF                                                              BUG21207
     C                   ENDIF                                                              BUG21207
      *
      ** DST Start Date should always be less than DST End Date
      *
     C                   IF        DDDSDT <> *BLANKS AND
     C                             DDDSED <> *BLANKS
      *
     C                   EVAL      PZDate = DDDSDT
     C                   EXSR      SRZDate1
     C                   IF        PErrorFlag = 'N'
     C                   EVAL      StartDate = PZDayno
     C                   ENDIF
      *
     C                   EVAL      PZDate = DDDSED
     C                   EXSR      SRZDate1
     C                   IF        PErrorFlag = 'N'
     C                   EVAL      EndDate = PZDayno
     C                   ENDIF
      *
     C                   IF        StartDate >= EndDate
     C                   EVAL      PZMsgId = 'SWF0031'
     C                   EVAL      *IN74 = *ON
     C                   EVAL      *IN75 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      *
      ** DST Start Time is mandatory
      *
     C**********         IF        DDDSDH = *BLANKS                                         BUG19522
     C                   IF        DDDSDH = *ZEROS                                          BUG19522
     C                   EVAL      PZMsgId = 'SWF0008'
     C                   EVAL      *IN76 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ELSE
     C**********         EVAL      WTimeDS = DDDSDH                                         BUG19522
     C                   MOVEL     DDDSDH        WTimeDS                                    BUG19522
     C                   IF        %CHECK(Digits : WTimeDS) <> 0 OR
     C                             WHour < *ZEROS   OR
     C                             WHour > '23'     OR
     C                             WMin  < *ZEROS   OR
     C                             WMin  > '59'     OR
     C                             WSec  < *ZEROS   OR
     C                             WSec  > '59'
     C                   EVAL      PZMsgId = 'SWF0009'
     C                   EVAL      *IN76 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
      *
      ** DST End Time is mandatory
      *
     C**********         IF        DDDENH = *BLANKS                                         BUG19522
     C                   IF        DDDENH = *ZEROS                                          BUG19522
     C                   EVAL      PZMsgId = 'SWF0013'
     C                   EVAL      *IN77 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ELSE
     C**********         EVAL      WTimeDS = DDDENH                                         BUG19522
     C                   MOVEL     DDDENH        WTimeDS                                    BUG19522
     C                   IF        %CHECK(Digits : WTimeDS) <> 0 OR
     C                             WHour < *ZEROS   OR
     C                             WHour > '23'     OR
     C                             WMin  < *ZEROS   OR
     C                             WMin  > '59'     OR
     C                             WSec  < *ZEROS   OR
     C                             WSec  > '59'
     C                   EVAL      PZMsgId = 'SWF0014'
     C                   EVAL      *IN77 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
     ******************************************************************                     BUG19250
     ****DST*Start*Month***********************************************                     BUG19250
     ******************************************************************                     BUG19250
     C**********         IF        DDDSTM = *BLANKS                                         BUG19250
     C**********         EVAL      PZMsgId = 'SWF0010'                                      BUG19250
     C**********         EVAL      *IN78 = *ON                                              BUG19250
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19250
     C**********         EXSR      SRErrDta                                                 BUG19250
     C**********         ELSE                                                               BUG19250
     C**********         EVAL      WPos = %SCAN('?':DDDSTM)                                 BUG19250
     C**********         IF        WPos <> *ZEROS                                           BUG19250
     C**********         CALL      'Y2VLLSR'                                                BUG19250
     C**********         PARM                    PrtCd                                      BUG19250
     C**********         PARM      1105001       Y2Lsno                                     BUG19250
     C*****DDDSTM        PARM                    Selection                                  BUG19250
     C**********         ELSE                                                               BUG19250
                                                                                            BUG19250
     C**********         EVAL      ZFIELD = DDDSTM                                 BUG19135 BUG19250
     C**********         EVAL      ZADIG = 2                                       BUG19135 BUG19250
     C**********         EXSR      SrZalign                                        BUG19135 BUG19250
                                                                                            BUG19250
     C**********         IF        ZALIGNok= 'Y'                                   BUG19135 BUG19250
     C**********         EVALR     DDDSTM = ZFIELD                                 BUG19135 BUG19250
     C**********         ENDIF                                                     BUG19135 BUG19250
                                                                                            BUG19250
     C**********         EVAL      NPos = %LOOKUP(DDDSTM:DSTMON)                            BUG19250
     C**********         IF        NPos = 0                                                 BUG19250
     C**********         EVAL      PZMsgId = 'SWF0016'                                      BUG19250
     C**********         EVAL      *IN78 = *ON                                              BUG19250
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19250
     C**********         EXSR      SRErrDta                                                 BUG19250
     C**********         ENDIF                                                              BUG19250
     C**********         ENDIF                                                              BUG19250
     C**********         ENDIF                                                              BUG19250
     ******************************************************************                     BUG19250
     ****DST*End*Month*************************************************                     BUG19250
     ******************************************************************                     BUG19250
     C**********         IF        DDDENM = *BLANKS                                         BUG19250
     C**********         EVAL      PZMsgId = 'SWF0015'                                      BUG19250
     C**********         EVAL      *IN79 = *ON                                              BUG19250
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19250
     C**********         EXSR      SRErrDta                                                 BUG19250
     C**********         ELSE                                                               BUG19250
     C**********         EVAL      WPos = %SCAN('?':DDDENM)                                 BUG19250
     C**********         IF        WPos <> *ZEROS                                           BUG19250
     C**********         CALL      'Y2VLLSR'                                                BUG19250
     C**********         PARM                    PrtCd                                      BUG19250
     C**********         PARM      1105001       Y2Lsno                                     BUG19250
     C*****DDDENM        PARM                    Selection                                  BUG19250
     C**********         ELSE                                                               BUG19250
                                                                                            BUG19250
     C**********         EVAL      ZFIELD = DDDENM                                 BUG19135 BUG19250
     C**********         EVAL      ZADIG = 2                                       BUG19135 BUG19250
     C**********         EXSR      SrZalign                                        BUG19135 BUG19250
                                                                                            BUG19250
     C**********         IF        ZALIGNok= 'Y'                                   BUG19135 BUG19250
     C**********         EVALR     DDDENM = ZFIELD                                 BUG19135 BUG19250
     C**********         ENDIF                                                     BUG19135 BUG19250
                                                                                            BUG19250
     C**********         EVAL      NPos = %LOOKUP(DDDENM:DSTMON)                            BUG19250
     C**********         IF        NPos = 0                                                 BUG19250
     C**********         EVAL      PZMsgId = 'SWF0016'                                      BUG19250
     C**********         EVAL      *IN79 = *ON                                              BUG19250
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19250
     C**********         EXSR      SRErrDta                                                 BUG19250
     C**********         ENDIF                                                              BUG19250
     C**********         ENDIF                                                              BUG19250
     C**********         ENDIF                                                              BUG19250
     ******************************************************************                     BUG19250
     ****DST*Start*Week************************************************                     BUG19250
     ******************************************************************                     BUG19250
     C**********         IF        DDDSTW = *BLANKS                                         BUG19250
     C**********         EVAL      PZMsgId = 'SWF0010'                                      BUG19250
     C**********         EVAL      *IN80 = *ON                                              BUG19250
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19250
     C**********         EXSR      SRErrDta                                                 BUG19250
     C**********         ELSE                                                               BUG19250
     C**********         EVAL      WPos = %SCAN('?':DDDSTW)                                 BUG19250
     C**********         IF        WPos <> *ZEROS                                           BUG19250
     C**********         CALL      'Y2VLLSR'                                                BUG19250
     C**********         PARM                    PrtCd                                      BUG19250
     C**********         PARM      1105002       Y2Lsno                                     BUG19250
     C*****DDDSTW        PARM                    Selection                                  BUG19250
     C**********         ELSE                                                               BUG19250
     C**********         IF        %CHECK(DSTWk:DDDSTW) <> 0                                BUG19250
     C**********         EVAL      PZMsgId = 'SWF0017'                                      BUG19250
     C**********         EVAL      *IN80 = *ON                                              BUG19250
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19250
     C**********         EXSR      SRErrDta                                                 BUG19250
     C**********         ENDIF                                                              BUG19250
     C**********         ENDIF                                                              BUG19250
     C**********         ENDIF                                                              BUG19250
     ******************************************************************                     BUG19250
     ****DST*End*Week**************************************************                     BUG19250
     ******************************************************************                     BUG19250
     C**********         IF        DDDENW = *BLANKS                                         BUG19250
     C**********         EVAL      PZMsgId = 'SWF0015'                                      BUG19250
     C**********         EVAL      *IN81 = *ON                                              BUG19250
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19250
     C**********         EXSR      SRErrDta                                                 BUG19250
     C**********         ELSE                                                               BUG19250
     C**********         EVAL      WPos = %SCAN('?':DDDENW)                                 BUG19250
     C**********         IF        WPos <> *ZEROS                                           BUG19250
     C**********         Call      'Y2VLLSR'                                                BUG19250
     C**********         PARM                    PrtCd                                      BUG19250
     C**********         PARM      1105002       Y2Lsno                                     BUG19250
     C*****DDDENW        PARM                    Selection                                  BUG19250
     C**********         ELSE                                                               BUG19250
     C**********         IF        %CHECK(DSTWk:DDDENW) <> 0                                BUG19250
     C**********         EVAL      PZMsgId = 'SWF0017'                                      BUG19250
     C**********         EVAL      *IN81 = *ON                                              BUG19250
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19250
     C**********         EXSR      SRErrDta                                                 BUG19250
     C**********         ENDIF                                                              BUG19250
     C**********         ENDIF                                                              BUG19250
     C**********         ENDIF                                                              BUG19250
     ******************************************************************                     BUG19250
     ****DST*Start*Day*************************************************                     BUG19250
     ******************************************************************                     BUG19250
     C**********         IF        DDDSTD = *BLANKS                                         BUG19250
     C**********         EVAL      PZMsgId = 'SWF0010'                                      BUG19250
     C**********         EVAL      *IN82 = *ON                                              BUG19250
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19250
     C**********         EXSR      SRErrDta                                                 BUG19250
     C**********         ELSE                                                               BUG19250
     C**********         EVAL      WPos = %SCAN('?':DDDSTD)                                 BUG19250
     C**********         IF        WPos <> *ZEROS                                           BUG19250
     C**********         CALL      'Y2VLLSR'                                                BUG19250
     C**********         PARM                    PrtCd                                      BUG19250
     C**********         PARM      1105003       Y2Lsno                                     BUG19250
     C*****DDDSTD        PARM                    Selection                                  BUG19250
     C**********         ELSE                                                               BUG19250
                                                                                            BUG19250
     C**********         EVAL      ZFIELD = DDDSTD                                 BUG19135 BUG19250
     C**********         EVAL      ZADIG = 2                                       BUG19135 BUG19250
     C**********         EXSR      SrZalign                                        BUG19135 BUG19250
                                                                                            BUG19250
     C**********         IF        ZALIGNok= 'Y'                                   BUG19135 BUG19250
     C**********         EVALR     DDDSTD = ZFIELD                                 BUG19135 BUG19250
     C**********         ENDIF                                                     BUG19135 BUG19250
                                                                                            BUG19250
     C**********         EVAL      NPos = %LOOKUP(DDDSTD:DSTDay)                            BUG19250
     C**********         IF        NPos = 0                                                 BUG19250
     C**********         EVAL      PZMsgId = 'SWF0018'                                      BUG19250
     C**********         EVAL      *IN82 = *ON                                              BUG19250
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19250
     C**********         EXSR      SRErrDta                                                 BUG19250
     C**********         ENDIF                                                              BUG19250
     C**********         ENDIF                                                              BUG19250
     C**********         ENDIF                                                              BUG19250
     ******************************************************************                     BUG19250
     ****DST*End*Day***************************************************                     BUG19250
     ******************************************************************                     BUG19250
     C**********         IF        DDDEND = *BLANKS                                         BUG19250
     C**********         EVAL      PZMsgId = 'SWF0015'                                      BUG19250
     C**********         EVAL      *IN83 = *ON                                              BUG19250
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19250
     C**********         EXSR      SRErrDta                                                 BUG19250
     C**********         ELSE                                                               BUG19250
     C**********         EVAL      WPos = %SCAN('?':DDDEND)                                 BUG19250
     C**********         IF        WPos <> *ZEROS                                           BUG19250
     C**********         CALL      'Y2VLLSR'                                                BUG19250
     C**********         PARM                    PrtCd                                      BUG19250
     C**********         PARM      1105003       Y2Lsno                                     BUG19250
     C*****DDDEND        PARM                    Selection                                  BUG19250
     C**********         ELSE                                                               BUG19250
                                                                                            BUG19250
     C**********         EVAL      ZFIELD = DDDEND                                 BUG19135 BUG19250
     C**********         EVAL      ZADIG = 2                                       BUG19135 BUG19250
     C**********         EXSR      SrZalign                                        BUG19135 BUG19250
                                                                                            BUG19250
     C**********         IF        ZALIGNok= 'Y'                                   BUG19135 BUG19250
     C**********         EVALR     DDDEND = ZFIELD                                 BUG19135 BUG19250
     C**********         ENDIF                                                     BUG19135 BUG19250
                                                                                            BUG19250
     C**********         EVAL      NPos = %LOOKUP(DDDEND:DSTDAY)                            BUG19250
     C**********         IF        NPos = 0                                                 BUG19250
     C**********         EVAL      PZMsgId = 'SWF0018'                                      BUG19250
     C**********         EVAL      *IN83 = *ON                                              BUG19250
     C**********         EVAL      WIdx = WIdx + 1                                          BUG19250
     C**********         EXSR      SRErrDta                                                 BUG19250
     C**********         ENDIF                                                              BUG19250
     C**********         ENDIF                                                              BUG19250
     C**********         ENDIF                                                              BUG19250
      *
      ** DST Start Month, DST Start Week and DST Start day should be entered together
      *
     C                   IF        DDDSTD <> *BLANKS AND
     C                             (DDDSTM = *BLANKS OR
     C                              DDDSTW = *BLANKS)
     C                   EVAL      PZMsgId = 'SWF0010'
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN80 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** DST Start Month, DST Start Week and DST Start day should be entered together
      *
     C                   IF        DDDSTM <> *BLANKS AND
     C                             (DDDSTW = *BLANKS OR
     C                              DDDSTD = *BLANKS)
     C                   EVAL      PZMsgId = 'SWF0010'
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN80 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** DST Start Month, DST Start Week and DST Start day should be entered together
      *
     C                   IF        DDDSTW <> *BLANKS AND
     C                             (DDDSTM = *BLANKS OR
     C                              DDDSTD = *BLANKS)
     C                   EVAL      PZMsgId = 'SWF0010'
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN80 = *ON
     C                   EVAL      *IN82 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** DST End Month, DST End Week and DST End day should be entered together
      *
     C                   IF        DDDENM <> *BLANKS AND
     C                             (DDDENW = *BLANKS OR
     C                              DDDEND = *BLANKS)
     C                   EVAL      PZMsgId = 'SWF0015'
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** DST End Month, DST End Week and DST End day should be entered together
      *
     C                   IF        DDDENW <> *BLANKS AND
     C                             (DDDENM = *BLANKS OR
     C                              DDDEND = *BLANKS)
     C                   EVAL      PZMsgId = 'SWF0015'
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
      ** DST End Month, DST End Week and DST End day should be entered together
      *
     C                   IF        DDDEND <> *BLANKS AND
     C                             (DDDENM = *BLANKS OR
     C                              DDDENW = *BLANKS)
     C                   EVAL      PZMsgId = 'SWF0015'
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN81 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   IF        Widx = 0                                                 BUG19156
     C                   EXSR      SRValDSTRule                                             BUG19156
     C                   EXSR      SRValDSTERule                                            BUG19244
     C                   ENDIF                                                              BUG19156
      *                                                                                     BUG19156
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRErrDta - Output Error Message With Data                    *
      *                                                               *
      *  Called by: SRPrSfl, SRloadSfl, SRInsert, SRDelete            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRErrDta      BEGSR
      *
     C                   CALL      'ZA0350'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgId
     C                   PARM      *BLANKS       PZMsgData
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SRDSTVal - Validate DST Code                                 *
      *                                                               *
      *  Called by: SRInsert, SRCopy                                  *
      *                                                               *
      *  Calls: SRErrDta, *PSSR                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRDSTVal      BEGSR
     C
     C                   IF        (M1Actd = Insert  OR
     C                              M1Actd = Copy)   AND
     C                              DDDSCD = *BLANKS
      *
      ** DST Code is mandatory
      *
     C                   EVAL      PZMsgId = 'SWF0001'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ELSEIF    (M1Actd = Insert  OR
     C                              M1Actd = Copy)   AND
     C                              DDDSCD <> *BLANKS
      *
      ** Perform Chain Operation With DST Code On The File SDDSTCL1
      ** DST Code Should Be Unique In the File
      *
     C     Key2          CHAIN     SDDSTCL1
     C                   IF        %FOUND(SDDSTCL1)
     C                   EVAL      PZMsgId = 'SWF0020'
     C                   EVAL      *IN70 = *ON
     C                   EVAL      *IN71 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Validate if Invalid Character was used in DST Code                                 BUG20628
     C                   IF        DDDSCD <> *Blanks                                        BUG20628
     C                   Z-ADD     1             nCtr              2 0                      BUG20628
     C                   DOW       nCtr <= %Len(%Trim(DDDSCD))                              BUG20628
     C                   IF        %SCAN(%Subst(DDDSCD:nCtr:1):InvalidChar) > 0             BUG20628
     C                   EVAL      PZMsgId = 'SWF0053'                                      BUG20628
     C                   EVAL      *In70 = True                                             BUG20628
     C                   EVAL      WIdx = WIdx + 1                                          BUG20628
     C                   EXSR      SRErrDta                                                 BUG20628
     C                   LEAVESR                                                            BUG20628
     C                   ENDIF                                                              BUG20628
     C                   EVAL      nCtr = nCtr + 1                                          BUG20628
     C                   ENDDO                                                              BUG20628
     C                   ENDIF                                                              BUG20628
      *                                                                                     BUG20628
      ***Select*DST*Code*                                                                   BUG20628
      **********                                                                            BUG20628
     C**********         EVAL      WPos = %SCAN('?':DDDSCD)                                 BUG20628
     C**********         IF        WPos <> *ZEROS                                           BUG20628
     C**********         CALL      'SD001006S'                                              BUG20628
     C**********         PARM                    PrtCd                                      BUG20628
     C**********         PARM                    PDscd                                      BUG20628
     C**********         PARM                    PYear                                      BUG20628
      **********                                                                            BUG20628
     C**********         EVAL      DDDSCD = PDscd                                           BUG20628
     C**********         EVAL      DDYEAR = PYear                                           BUG20628
     C**********         ENDIF                                                              BUG20628
      *
      ** Year is mandatory and must be a valid value between 1900 and 2100.
      *
     C                   IF        DDYEAR = *BLANKS
     C                   EVAL      PZMsgID = 'SWF0037'
     C                   EVAL      *IN71 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ELSE
     C                   IF        %CHECK(Digits:DDYEAR) <> 0
     C                   EVAL      PZMsgID = 'SWF0002'
     C                   EVAL      *IN71 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
      *
     C                   ELSE
     C                   MOVE      DDYEAR        @Year
     C                   IF        (@YEAR < 1900 OR
     C                              @YEAR > 2100)
     C                   EVAL      PZMsgId = 'SWF0002'
     C                   EVAL      *IN71 = *ON
     C                   EVAL      WIdx = WIdx + 1
     C                   EXSR      SRErrDta
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDSR
      *
      *****************************************************************                     BUG19135
      /EJECT                                                                                BUG19135
      *****************************************************************                     BUG19135
      *                                                               *                     BUG19135
      *  SrZalign - Align field to the right with padded zeroes       *                     BUG19135
      *                                                               *                     BUG19135
      *  Called by: SRVALFLD                                          *                     BUG19135
      *                                                               *                     BUG19135
      *  Calls: None                                                  *                     BUG19135
      *                                                               *                     BUG19135
      *****************************************************************                     BUG19135
      *                                                                                     BUG19135
     C     SrZalign      BEGSR                                                              BUG19135
      *                                                                                     BUG19135
     C                   CALLB     'ZALIGN'                                                 BUG19135
     C                   PARM      'Y'           ZALIGNok                                   BUG19135
     C                   PARM                    ZFIELD                                     BUG19135
     C                   PARM      0             ZADEC                                      BUG19135
     C                   PARM                    ZADIG                                      BUG19135
      *                                                                                     BUG19135
     C                   ENDSR                                                              BUG19135
      *                                                                                     BUG19156
      *****************************************************************                     BUG19156
      /EJECT                                                                                BUG19156
      *****************************************************************                     BUG19156
      *                                                               *                     BUG19156
      *  SRValDSTRule - Validate if Start Date is same with DST Rule  *                     BUG19156
      *                                                               *                     BUG19156
      *  Called by: SRFldVal                                          *                     BUG19156
      *                                                               *                     BUG19156
      *  Calls: ZFINDDATE                                             *                     BUG19156
      *                                                               *                     BUG19156
      *****************************************************************                     BUG19156
      *                                                                                     BUG19156
     C     SRValDSTRule  BEGSR                                                              BUG19156
      *                                                                                     BUG19156
      ** Check DST Start Date is equal to converted value of Start Month/Day/Year entered.  BUG19156
      *                                                                                     BUG19156
     C                   IF        DDDSDT <> *BLANKS AND                                    BUG19156
     C                             DDDSTD <> *BLANKS AND                                    BUG19156
     C                             DDDSTW <> *BLANKS AND                                    BUG19156
     C                             DDDSTM <> *BLANKS                                        BUG19156
      *                                                                                     BUG19156
     C                   CALLB     'ZFINDDATE'                                              BUG19156
     C                   PARM                    DDDSTD                                     BUG19156
     C                   PARM                    DDDSTW                                     BUG19156
     C                   PARM                    DDDSTM                                     BUG19156
     C                   PARM                    DDYEAR                                     BUG19156
     C                   PARM      BJDFIN        PDateFmt                                   BUG19156
     C                   PARM                    POutDate5                                  BUG19156
     C                   PARM                    POutDate6                                  BUG19156
      *                                                                                     BUG19156
      ** If Result is not equal, issue warning message.                                     BUG19156
      *                                                                                     BUG19156
     C                   IF        DDDSDT <> POutDate6                                      BUG19156
     C                   EVAL      PZMsgId = 'SWF0043'                                      BUG19156
     C                   EVAL      WarnIdx = WarnIdx + 1                                    BUG19156
     C                   EXSR      SRErrDta                                                 BUG19156
     C                   ENDIF                                                              BUG19156
     C                   ENDIF                                                              BUG19156
      *                                                                                     BUG19156
      ** Check if start date is not the same with DST Rule. Protect fields if WarnIdx > 0   BUG19156
      *                                                                                     BUG19156
     C                   IF        WarnIDX > 0                                              BUG19156
     C                   EVAL      *IN29 = *ON                                              BUG19156
     C                   EVAL      *IN59 = *ON                                              BUG19156
     C                   EVAL      *IN31 = *ON                                              BUG19156
     C                   EVAL      *IN44 = *OFF                                             BUG19156
     C                   WRITE     SD001006F0                                               BUG19156
     C                   WRITE     SD001006C1                                               BUG19156
     C                   EXFMT     SD001006R0                                               BUG19156
     C                   IF        F12 = *ON OR F3 = *ON                                    BUG19156
     C                   EVAL      Widx = 1                                                 BUG19156
     C                   ENDIF                                                              BUG19156
     C                   ENDIF                                                              BUG19156
      *                                                                                     BUG19156
     C                   ENDSR                                                              BUG19156
      *                                                                                     BUG19156
      *                                                                                     BUG19244
      *****************************************************************                     BUG19244
      /EJECT                                                                                BUG19244
      *****************************************************************                     BUG19244
      *                                                               *                     BUG19244
      *  SRValDSTERule - Validate if End Date is same with DST Rule   *                     BUG19244
      *                                                               *                     BUG19244
      *  Called by: SRFldVal                                          *                     BUG19244
      *                                                               *                     BUG19244
      *  Calls: ZFINDDATE                                             *                     BUG19244
      *                                                               *                     BUG19244
      *****************************************************************                     BUG19244
      *                                                                                     BUG19244
     C     SRValDSTERule BEGSR                                                              BUG19244
      *                                                                                     BUG19244
      ** Check DST End Date is equal to converted value of Start Month/Day/Year entered.    BUG19244
      *                                                                                     BUG19244
     C                   IF        DDDSED <> *BLANKS AND                                    BUG19244
     C                             DDDEND <> *BLANKS AND                                    BUG19244
     C                             DDDENW <> *BLANKS AND                                    BUG19244
     C                             DDDENM <> *BLANKS                                        BUG19244
      *                                                                                     BUG19244
     C                   IF        DDDENM < DDDSTM                                          BUG19314
     C                   MOVE      DDYEAR        @Year                                      BUG19314
     C                   EVAL      @Year = @Year + 1                                        BUG19314
     C                   MOVEL     @Year         WTZYear                                    BUG19314
     C                   ELSE                                                               BUG19314
     C                   MOVE      DDYEAR        WTZYear                                    BUG19314
     C                   ENDIF                                                              BUG19314
      *                                                                                     BUG19314
     C                   CALLB     'ZFINDDATE'                                              BUG19244
     C                   PARM                    DDDEND                                     BUG19244
     C                   PARM                    DDDENW                                     BUG19244
     C                   PARM                    DDDENM                                     BUG19244
     C**********         PARM                    DDYEAR                            BUG19244 BUG19314
     C                   PARM                    WTZYear                                    BUG19314
     C                   PARM      BJDFIN        PDateFmt                                   BUG19244
     C                   PARM                    POutDate5                                  BUG19244
     C                   PARM                    POutDate6                                  BUG19244
      *                                                                                     BUG19244
      ** If Result is not equal, issue warning message.                                     BUG19244
      *                                                                                     BUG19244
     C                   IF        DDDSED <> POutDate6                                      BUG19244
     C                   EVAL      PZMsgId = 'SWF0046'                                      BUG19244
     C                   EVAL      WarnIdx = WarnIdx + 1                                    BUG19244
     C                   EXSR      SRErrDta                                                 BUG19244
     C                   ENDIF                                                              BUG19244
     C                   ENDIF                                                              BUG19244
      *                                                                                     BUG19244
      ** Check if end date is not the same with DST Rule. Protect fields if WarnIdx > 0     BUG19244
      *                                                                                     BUG19244
     C                   IF        WarnIDX > 0                                              BUG19244
     C                   EVAL      *IN29 = *ON                                              BUG19244
     C                   EVAL      *IN59 = *ON                                              BUG19244
     C                   EVAL      *IN31 = *ON                                              BUG19244
     C                   EVAL      *IN44 = *OFF                                             BUG19244
     C                   WRITE     SD001006F0                                               BUG19244
     C                   WRITE     SD001006C1                                               BUG19244
     C                   EXFMT     SD001006R0                                               BUG19244
     C                   IF        F12 = *ON OR F3 = *ON                                    BUG19244
     C                   EVAL      Widx = 1                                                 BUG19244
     C                   ENDIF                                                              BUG19244
     C                   ENDIF                                                              BUG19244
      *                                                                                     BUG19244
     C                   ENDSR                                                              BUG19244
      *                                                                                     BUG19244
      *****************************************************************                     BUG21207
      /EJECT                                                                                BUG21207
      *****************************************************************                     BUG21207
      *                                                               *                     BUG21207
      *  SRGetYearVal  - Compute year to be displayed if no  details  *                     BUG21207
      *                  available.                                   *                     BUG21207
      *                                                               *                     BUG21207
      *  Called by: SRCopy                                            *                     BUG21207
      *                                                               *                     BUG21207
      *  Calls:                                                       *                     BUG21207
      *                                                               *                     BUG21207
      *****************************************************************                     BUG21207
      *                                                                                     BUG21207
     C     SRGetYearVal  BEGSR                                                              BUG21207
      *                                                                                     BUG21207
     C                   EVAL      ZMDAY   =  DSDSDT                                        BUG21207
     C                   EXSR      SRGetYear                                                BUG21207
     C                   MOVEL     ZSDATC        nYear1            4 0                      BUG21207
     C                   EVAL      S@DSDT  = %Subst(S@DSDT:1:4) +                           BUG21207
     C                                       %Subst(DDYEAR:3:2)                             BUG21207
     C                   EVAL      ZMDAY   =  DSDSED                                        BUG21207
     C                   EXSR      SRGetYear                                                BUG21207
     C                   MOVEL     ZSDATC        nYear2            4 0                      BUG21207
     C                   MOVE      *Zeros        nYearDiff         2 0                      BUG21207
     C                   MOVE      DDYEAR        nEndYear          4 0                      BUG21207
     C                   EVAL      nEndYear = nEndYear + (nYear2 - nYear1)                  BUG21207
     C                   EVAL      S@DSED  = %Subst(S@DSED:1:4) +                           BUG21207
     C                                       %Subst(%Char(nEndYear):3:2)                    BUG21207
      *                                                                                     BUG21207
     C                   ENDSR                                                              BUG21207
      *                                                                                     BUG21207
      *****************************************************************                     BUG21207
      /EJECT                                                                                BUG21207
      *****************************************************************                     BUG21207
      *                                                                                     BUG21207
      *  SRGetYear - Get equivalent year value base on day number     *                     BUG21207
      *                                                               *                     BUG21207
      *  Called by: SRGetYearVal                                      *                     BUG21207
      *                                                               *                     BUG21207
      *  Calls:  ZM0065                                               *                     BUG21207
      *                                                               *                     BUG21207
      *****************************************************************                     BUG21207
      *                                                                                     BUG21207
     C     SRGetYear     BEGSR                                                              BUG21207
      *                                                                                     BUG21207
      ** Extract Year in CCYYMMDD Format                                                    BUG21207
      *                                                                                     BUG21207
     C                   CALL      'ZM0065'                                                 BUG21207
     C                   PARM                    ZMDAY                                      BUG21207
     C                   PARM      *Blanks       ZSDATE                                     BUG21207
     C                   PARM      *Blanks       ZSDATC                                     BUG21207
      *                                                                                     BUG21207
     C                   ENDSR                                                              BUG21207
      *                                                                                     BUG21232
      *****************************************************************                     BUG21232
      /EJECT                                                                                BUG21232
      *****************************************************************                     BUG21232
      *                                                               *                     BUG21232
      *  SRChkDSTFlag - Check if DST is On or Off                     *                     BUG21232
      *                                                               *                     BUG21232
      *  Called by: SRGetYearVal                                      *                     BUG21232
      *                                                               *                     BUG21232
      *  Calls:                                                       *                     BUG21232
      *                                                               *                     BUG21232
      *****************************************************************                     BUG21232
      *                                                                                     BUG21232
     C     SRChkDSTFlag  BEGSR                                                              BUG21232
      *                                                                                     BUG21232
      ** Check if DST On. Start Date must be greater than or equal to trans. date           BUG21232
      ** and End date must be less than trans. date.                                        BUG21232
      *                                                                                     BUG21232
      *                                                                                     BUG21232
     C                   MOVE      'N'           cDSTFlag          1                        BUG21232
      *                                                                                     BUG21232
     C                   IF        BJRDNB >= nStrDate And                                   BUG21232
     C                             BJRDNB < nEndDate                                        BUG21232
     C                   MOVE      'Y'           cDSTFlag                                   BUG21232
     C                   ELSE                                                               BUG21232
     C                   MOVE      'N'           cDSTFlag                                   BUG21232
     C                   ENDIF                                                              BUG21232
      *                                                                                     BUG21232
     C                   ENDSR                                                              BUG21232
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically If a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
      *
     C                   EVAL      WRun = 'Y'
     C                   DUMP
      *
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2008
** DSTMON
010203040506070809101112
** DSTDAY
01020304050607
** MONTH
JanFebMarAprMayJunJulAugSepOctNovDec
** WEEK
First
Second
Third
Fourth
Last
** DAY
MonTueWedThuFriSatSun
