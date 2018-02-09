     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ER Bundesbank Cashflow Extract Process')         *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000194 - Midas ER Cashflow Extract Process                 *
      *                                                               *
      *  Function: This program creates Cashflow extract files        *
      *            for GRI reporting                                  *
      *                                                               *
      *  (c) Finastra International Limited 2009                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. MD030247           Date 26Jan15               *
      *                 CER070             Date 19Aug14               *
      *                 CER059             Date 19Jul10               *
      *                 BUG26896           Date 15Jan10               *
      *                 BUG26740           Date 13Nov09               *
      *                 BUG26712           Date 13Nov09               *
      *                 CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD030247 - Increase GSRE to 21.                              *
      *             Applied for MD032081 (Recompile)                  *
      *  CER070 - BuBa Reporting / BAIS V.1.16.0                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *         - LT062: Changed Customer No. to alphanumeric         *
      *           (Recompile)                                         *
      *  BUG26896 - Cash Flow Extracted amounts sign must be in       *
      *             reverse  ('+' to '-' and '-' to '+')              *
      *  BUG26740 - Cash Flow Extract includes future and back value  *
      *             dated transactions                                *
      *  BUG26712 - No cashflow extract for transactions with start   *
      *             date starting today and maturity date within      *
      *             one month period.                                 *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Main Processing                                  *
      *  SRCalcTimeB - Calculate Time Bands amounts                   *
      *  SRPeriodDate - Define Period dates                           *
      *  SRAudit - Write audit report                                 *
      *  SRCvtDate - Convert Midas date to YYYYMMDD format            *
      *  SRZDate1 - Convert Date to Midas Day Number                  *
      *  SRZDate2 - Convert Midas Day Number to Date Format           *
      *  *INZSR  - Initialise                                         *
      *  *PSSR   - Error processing                                   *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas ER GRI Master Account/Transaction File
 
     FERGSTIL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas ER GRI Cash Flows
 
     FERKGLIPD  O    E           K DISK    INFSR(*PSSR)
 
      ** Midas ER Bundesbank Cash Flow Extract Audit
 
     FER000194AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Array containing Copyright statement
 
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Local data area for database error details
 
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** The following fields are defined in the external file:
      **                                    134 141 DBFile
      **                                    142 170 DBKey
      **                                    171 180 DBPgm
      **                                    181 1830DBase
      **                                    184 193 DBMod
      **                                    194 203 DBProc
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
 
     D/COPY ZACPYSRC,PSDS
 
      ** Externally described DS for bank details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for currency details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for System Values
 
     D SDSVAL        E DS                  EXTNAME(SDSVALPD)
 
      ** DS for access objects - short data structure
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - long data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** File Information Data Structure for ER000194AU
 
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
 
      ** Constants
 
     D WKeySysVal1     C                   CONST('BundClientId')
     D WMidasplus      C                   CONST('MIDAS PLUS')
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
 
      ** Parameters for ZDATE1 and ZDATE2
 
     D PDayNo          S              5P 0
     D PDayNoAlpha     S              5A
     D PDateFormat     S              1A
     D PDate           S              6P 0
     D PDateChar       S              7A
     D PError          S              7A
 
      ** Parameters for access object programs
 
     D PRtcd           S              7A
     D POptn           S              7A
     D PFDate          S               D   DATFMT(*ISO)
     D PWDate          S             10A
     D PZone           S             10A
     D PModule         S              4A
     D PCDate          S              5P 0
     D PTranRef        S              6A
     D PIO             S              1A
     D PAmnt           S             15P 0
     D PCurr           S              3A
 
     D PSValK1         S             20A
     D PSVal1          S            200A
     D PSValK2         S             20A
     D PSVal2          S            200A
     D PSValK3         S             20A
     D PSVal3          S            200A
     D PSValK4         S             20A
     D PSVal4          S            200A
     D PSValK5         S             20A
     D PSVal5          S            200A
     D PSValK6         S             20A
     D PSVal6          S            200A
     D PSValK7         S             20A
     D PSVal7          S            200A
     D PSValK8         S             20A
     D PSVal8          S            200A
     D PSValK9         S             20A
     D PSVal9          S            200A
     D PSValK0         S             20A
     D PSVal0          S            200A
 
     D PErrMsg         S             50A
     D PFullChk        S              1A
     D PShtc           S              4A
     D PRdnb           S              5P 0
     D PDnwd           S              5P 0
     D PBCcy           S              3A
     D PNJob           S              1P 0
 
      ** Work fields for period dates
 
     D WRundate        S               D   DATFMT(*ISO)
     D WOutdate        S               D   DATFMT(*ISO)
     D W1Month         S              5P 0
     D W3Months        S              5P 0
     D W6Months        S              5P 0
     D W1Year          S              5P 0
     D W5Years         S              5P 0
 
      ** Other fields used
 
 
     D WFound          S              1A
     D WRun            S              1A
     D W6LB1G          S                   LIKE(B6LB1G)
     D W6LB2G          S                   LIKE(B6LB2G)
     D W6LB3G          S                   LIKE(B6LB3G)
     D W6LB4G          S                   LIKE(B6LB4G)
     D W6LB5G          S                   LIKE(B6LB5G)
     D W6LB1B          S                   LIKE(B6LB1B)
     D W6LB2B          S                   LIKE(B6LB2B)
     D W6LB3B          S                   LIKE(B6LB3B)
     D W6LB4B          S                   LIKE(B6LB4B)
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRProcess
     C                   EVAL      *INLR  = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Processing subroutine                            *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Process Account/Transaction Extract file
      ** Set file pointer to first record and do initial read
 
     C     *LOVAL        SETLL     ERGSTIL0
     C                   READ      ERGSTIL0
 
     C                   DOW       NOT %EOF(ERGSTIL0)
 
     C                   IF        B3MODU = 'KR' OR
     C                             B3MODU = 'GH'
 
      ** Initialise Time Bands amounts
 
     C                   Z-ADD     0             W6LB1G
     C                   Z-ADD     0             W6LB2G
     C                   Z-ADD     0             W6LB3G
     C                   Z-ADD     0             W6LB4G
     C                   Z-ADD     0             W6LB5G
     C                   Z-ADD     0             W6LB1B
     C                   Z-ADD     0             W6LB2B
     C                   Z-ADD     0             W6LB3B
     C                   Z-ADD     0             W6LB4B
 
     C                   EVAL      B6MODU = B3MODU
     C                   EVAL      B6KDNR = B3KDNR
     C                   EVAL      B6KTON = B3KTON
     C                   EVAL      B6GSRE = B3GSRE
     C                   EVAL      B6DLDT = B3DLDT                                            CER070
 
      ** Get Number of decimal places for the Currency
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      B3WHIS        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY  = PCurr
     C                   EVAL      DBPGM  = 'ER000194'
     C                   EVAL      DBASE  = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      B6NBDP = A6NBDP
 
      ** Setup parameter list for GPAOTRAPR0
 
     C                   IF        B3MODU = 'KR'
     C                   EVAL      PModule = 'LOAN'
     C                   ELSE
     C                   EVAL      PModule = 'LDNI'
     C                   ENDIF
     C                   EVAL      PTranRef = B3GSRE
 
     C                   EVAL      WFound = 'N'
 
      ** Call access program for cashflows
 
     C                   CALL      'GPAOTRAPR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PZone
     C                   PARM                    PModule
     C                   PARM                    PTranRef
     C                   PARM                    PCDate
     C                   PARM                    PIO
     C                   PARM                    PAmnt
 
     C                   DOW       Prtcd = *BLANKS
 
     C                   EVAL      WFound = 'Y'
     C                   EXSR      SRCalcTimeB
 
     C                   CALL      'GPAOTRAPR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*NEXT  '     POptn
     C                   PARM                    PZone
     C                   PARM                    PModule
     C                   PARM                    PTranRef
     C                   PARM                    PCDate
     C                   PARM                    PIO
     C                   PARM                    PAmnt
 
     C                   ENDDO
 
      ** Write to Cashflow extract file
 
     C                   IF        WFound = 'Y'
     C                             AND B6DXLG >= B3DXVN                                     BUG26740
     C                   IF        W6LB1G <> 0 OR                                           BUG26712
     C                             W6LB2G <> 0 OR                                           BUG26712
     C                             W6LB3G <> 0 OR                                           BUG26712
     C                             W6LB4G <> 0 OR                                           BUG26712
     C                             W6LB5G <> 0 OR                                           BUG26712
     C                             W6LB1B <> 0 OR                                           BUG26712
     C                             W6LB2B <> 0 OR                                           BUG26712
     C                             W6LB3B <> 0 OR                                           BUG26712
     C                             W6LB4B <> 0                                              BUG26712
     C                   Z-ADD     W6LB1G        B6LB1G
     C                   Z-ADD     W6LB2G        B6LB2G
     C                   Z-ADD     W6LB3G        B6LB3G
     C                   Z-ADD     W6LB4G        B6LB4G
     C                   Z-ADD     W6LB5G        B6LB5G
     C                   Z-ADD     W6LB1B        B6LB1B
     C                   Z-ADD     W6LB2B        B6LB2B
     C                   Z-ADD     W6LB3B        B6LB3B
     C                   Z-ADD     W6LB4B        B6LB4B
     C                   WRITE     ERKGLID0
     C                   ENDIF                                                              BUG26712
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      ERGSTIL0
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalcTimeB - Calculate Time Bands amounts                   *
      *                                                               *
      *****************************************************************
 
     C     SRCalcTimeB   BEGSR
 
      ** Time Bands Set 1
 
     C                   SELECT
 
     C                   WHEN      PCDate > W1Year
     C**********         IF        PIO  = 'I'                                               BUG26896
     C                   IF        PIO  = 'O'                                               BUG26896
     C                   ADD       PAmnt         W6LB5G
     C                   ELSE
     C                   SUB       PAmnt         W6LB5G
     C                   ENDIF
 
     C                   WHEN      W6Months <  PCDate AND
     C                               PCDate <= W1Year
     C**********         IF        PIO  = 'I'                                               BUG26896
     C                   IF        PIO  = 'O'                                               BUG26896
     C                   ADD       PAmnt         W6LB4G
     C                   ELSE
     C                   SUB       PAmnt         W6LB4G
     C                   ENDIF
 
     C                   WHEN      W3Months <  PCDate AND
     C                               PCDate <= W6Months
     C**********         IF        PIO  = 'I'                                               BUG26896
     C                   IF        PIO  = 'O'                                               BUG26896
     C                   ADD       PAmnt         W6LB3G
     C                   ELSE
     C                   SUB       PAmnt         W6LB3G
     C                   ENDIF
 
     C                   WHEN      W1Month  <  PCDate AND
     C                               PCDate <= W3Months
     C**********         IF        PIO  = 'I'                                               BUG26896
     C                   IF        PIO  = 'O'                                               BUG26896
     C                   ADD       PAmnt         W6LB2G
     C                   ELSE
     C                   SUB       PAmnt         W6LB2G
     C                   ENDIF
 
     C                   WHEN      PCDate <= W1Month
     C**********         IF        PIO  = 'I'                                               BUG26896
     C                   IF        PIO  = 'O'                                               BUG26896
     C                   ADD       PAmnt         W6LB1G
     C                   ELSE
     C                   SUB       PAmnt         W6LB1G
     C                   ENDIF
 
     C                   ENDSL
 
      ** Time Bands Set 2
 
     C                   SELECT
 
     C                   WHEN      PCDate   >  W5Years
     C**********         IF        PIO  = 'I'                                               BUG26896
     C                   IF        PIO  = 'O'                                               BUG26896
     C                   ADD       PAmnt         W6LB4B
     C                   ELSE
     C                   SUB       PAmnt         W6LB4B
     C                   ENDIF
 
     C                   WHEN      W1Year   <  PCDate AND
     C                               PCDate <= W5Years
     C**********         IF        PIO  = 'I'                                               BUG26896
     C                   IF        PIO  = 'O'                                               BUG26896
     C                   ADD       PAmnt         W6LB3B
     C                   ELSE
     C                   SUB       PAmnt         W6LB3B
     C                   ENDIF
 
     C                   WHEN      W3Months <  PCDate AND
     C                               PCDate <= W1Year
     C**********         IF        PIO  = 'I'                                               BUG26896
     C                   IF        PIO  = 'O'                                               BUG26896
     C                   ADD       PAmnt         W6LB2B
     C                   ELSE
     C                   SUB       PAmnt         W6LB2B
     C                   ENDIF
 
     C                   WHEN      PCDate <= W3Months
     C**********         IF        PIO  = 'I'                                               BUG26896
     C                   IF        PIO  = 'O'                                               BUG26896
     C                   ADD       PAmnt         W6LB1B
     C                   ELSE
     C                   SUB       PAmnt         W6LB1B
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPeriodDate - Define Period dates                           *
      *                                                               *
      *****************************************************************
 
     C     SRPeriodDate  BEGSR
 
      ** Convert Midas run day to date format (DDMMYY) for duration
      ** calculation and convert the date back to Midas day number
 
     C                   EVAL      PDayNo = BJRDNB
     C                   EVAL      PDateformat = 'D'
     C                   EXSR      SRZDate2
     C     *DMY          MOVE      PDate         WRunDate
 
      ** 1 month from today's date
 
     C     WRundate      ADDDUR    1:*MONTHS     WOutDate
     C     *DMY          MOVE      WOutDate      PDate
     C                   EXSR      SRZDate1
     C                   EVAL      W1Month = PDayNo
 
      ** 3 months from today's date
 
     C     WRundate      ADDDUR    3:*MONTHS     WOutDate
     C     *DMY          MOVE      WOutDate      PDate
     C                   EXSR      SRZDate1
     C                   EVAL      W3Months = PDayNo
 
      ** 6 months from today's date
 
     C     WRundate      ADDDUR    6:*MONTHS     WOutDate
     C     *DMY          MOVE      WOutDate      PDate
     C                   EXSR      SRZDate1
     C                   EVAL      W6Months = PDayNo
 
      ** 1 year from today's date
 
     C     WRundate      ADDDUR    1:*YEARS      WOutDate
     C     *DMY          MOVE      WOutDate      PDate
     C                   EXSR      SRZDate1
     C                   EVAL      W1Year = PDayNo
 
      ** 5 years from today's date
 
     C     WRundate      ADDDUR    5:*YEARS      WOutDate
     C     *DMY          MOVE      WOutDate      PDate
     C                   EXSR      SRZDate1
     C                   EVAL      W5Years = PDayNo
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAudit - Write audit report                                 *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
     C                   IF        *INU7   = *ON
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C                   WRITE     DBERROR
 
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtDate - Convert Midas date to YYYYMMDD format            *
      *                                                               *
      *****************************************************************
 
     C     SRCvtDate     BEGSR
 
     C                   CALL      'ZACVTDATE'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM                    PDayNoAlpha
     C                   PARM                    PFDate
     C                   PARM      *BLANKS       PWDate
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate1 - Convert Date to Midas Day Number                  *
      *                                                               *
      *****************************************************************
 
     C     SRZDate1      BEGSR
 
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PError
     C                   PARM                    PDate
     C                   PARM                    PDateFormat
     C                   PARM                    PDayNo
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate2 - Convert Midas Day Number to Date Format           *
      *                                                               *
      *****************************************************************
 
     C     SRZDate2      BEGSR
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM                    PDateFormat
     C                   PARM                    PDate
     C                   PARM                    PDateChar
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *DTAARA       DEFINE                  LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   OUT       LDA
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *Blanks       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error
 
     C                   IF        PRtcd <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve system values
 
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      WKeySysVal1   PSValK1
     C                   PARM                    PSVal1
     C                   PARM                    PSValK2
     C                   PARM                    PSVal2
     C                   PARM                    PSValK3
     C                   PARM                    PSVal3
     C                   PARM                    PSValK4
     C                   PARM                    PSVal4
     C                   PARM                    PSValK5
     C                   PARM                    PSVal5
     C                   PARM                    PSValK6
     C                   PARM                    PSVal6
     C                   PARM                    PSValK7
     C                   PARM                    PSVal7
     C                   PARM                    PSValK8
     C                   PARM                    PSVal8
     C                   PARM                    PSValK9
     C                   PARM                    PSVal9
     C                   PARM                    PSValK0
     C                   PARM                    PSVal0
 
      ** If the system value is not found then issue a database error
 
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDSVALPD'
     C                   EVAL      DBase = 002
     C                   EVAL      DBKey = PSValK1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Liquidity Regulation Calculation Date
      ** Client Shortcut
      ** Residual Maturities Calculation Date
      ** Interface Name
 
     C                   MOVE      BJRDNB        PDayNoAlpha
     C                   EXSR      SRCvtDate
     C                   MOVE      PFDate        B6DXLG
     C                   EVAL      B6MDAN = PSVal1
     C                   EVAL      B6DXBI = 0
     C                   EVAL      B6IFNA = WMidasplus
 
      ** Get the current zone
 
     C                   CALL      'GOGETZONE'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      *BLANKS       PErrMsg
     C                   PARM      'N'           PFullChk
     C                   PARM                    PZone
     C                   PARM                    PShtc
     C                   PARM                    PRdnb
     C                   PARM                    PDnwd
     C                   PARM                    PBCcy
     C                   PARM                    PNJob
 
     C                   IF        PRtcd <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      DBase  = 003
     C                   EVAL      DBFile = 'GPZONEPD'
     C                   EVAL      DBKey  = PZone
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PZone  = PZone
 
      ** Define the Period dates
 
     C                   EXSR      SRPeriodDate
 
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        WRun = *Blank
     C                   EVAL      WRun = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2009
