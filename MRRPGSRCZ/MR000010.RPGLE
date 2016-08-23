/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Extract Postings')                            *
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR000010 -  Extract Postings                                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FAPOSTPD   IP   E             DISK    INFSR(*PSSR)
     FACPO      IS   F  620    24AIDISK    KEYLOC(2)  INFSR(*PSSR)
     FMRRPRMPD  IF   E             DISK    INFSR(*PSSR)
     FMRPOSTPD  O    E             DISK    INFSR(*PSSR)
     FMRPCMXPD  O    E             DISK    INFSR(*PSSR)
 
     D POWER           S              8  0 DIM(8) CTDATA PERRCD(1)
 
     D SDCUHS        E DS                  EXTNAME(SDCUHSPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     D                 DS
     D ddmmmyy                 1      7
     D dd                      1      2
     D mmm                     3      5
     D yy                      6      7
 
     D                 DS
     D DayMonthYear            1      6  0
     D Day                     1      2  0
     D Month                   3      4  0
     D Year                    5      6  0
 
 
      * Posting
     D I_POSTING     E DS                  EXTNAME(APOSTPD)
 
     IAPOSTPDF      01
     IACPO      NS  02
     I                                  1  620  INREC
 
     C   02              MOVEL     INREC         I_POSTING
     C     RECI          CABNE     'P'           IGNORE
 
      * If posting prior to limit date
      * then ignore it
 
     C     PSTD          CABLT     LimitDate     IGNORE
 
      * Convert posting date to DD/MM/YY
 
     C     PSTD          IFNE      P_PSTD
     C                   Z-ADD     PSTD          ZDAYNO
     C                   EXSR      ZDATE2
     C                   ENDIF
     C                   Z-ADD     PSTD          P_PSTD            5 0
 
      * Year/Month in alpha format   (e.g. 04SEP = Sept 2004)
 
     C                   MOVEL     ZADATE        ddmmmyy
     C                   MOVEL     yy            YRMN
     C                   MOVE      mmm           YRMN
 
      * Calendar Year/Month
 
     C                   MOVEL     ZDATE         DayMonthYear
     C                   MOVEL     Year          CY
     C                   MOVEL     Month         CM
 
     C                   Z-ADD     Month         BaseMonth         2 0
 
      * Calendar Quarter
     C                   EXSR      DET_Quarter
     C                   Z-ADD     Quarter       CQ
 
      * Calendar Half-Year
     C                   EXSR      DET_Halfyear
     C                   Z-ADD     HalfYear      CH
 
      * Financial Year/Month (3 months prior to calendar year/month)
 
     C                   Z-ADD     CY            FY
     C                   Z-ADD     CM            FM
     C                   SUB       3             FM                     9999
     C   99              SUB       1             FY
     C   99              ADD       12            FM
 
     C                   Z-ADD     FM            BaseMonth
 
      * Financial Quarter
     C                   EXSR      DET_Quarter
     C                   Z-ADD     Quarter       FQ
 
      * Financial Half-Year
     C                   EXSR      DET_Halfyear
     C                   Z-ADD     HalfYear      FH
 
      * Get Account Currency Details
     C                   CALL      'MR000101'
     C                   PARM      CCY           I#CCY
     C                   PARM                    SDCURR
     C                   Z-ADD     A6NBDP        AcctCDP           1 0
 
      * Get Historic Rates (Account Currency, Reporting Currency 1, Reporting Currency 2)
 
     C                   Z-ADD     PSTD          HistDate          5 0
     C                   EXSR      GETHistRATES
 
      * Determine Cross Rates from Account Currency -> Reporting Currency 1 and 2
 
     C                   EXSR      DETCrossRATES
 
      * Sign posting amount
 
     C     DRCR          IFEQ      1
     C                   Z-SUB     PSTA          PSTA
     C                   ENDIF
 
      * Convert posting amount amount to account currency (i.e adjust for d.p.)
 
     C                   Z-ADD     PSTA          PSTAAC
     C                   EVAL      CA = AcctCDP + 1
     C                   EVAL      PSTAAC = PSTAAC / POWER(CA)
 
      * Convert account currency amount to base currency
 
     C                   EXSR      CONV_AC2BS
     C                   Z-ADD     ZAMTCO        PSTABS
     C                   EVAL      CA = BaseCDP + 1
     C                   EVAL      PSTABS = PSTABS / POWER(CA)
 
      * Convert account currency amount to reporting currency 1
 
     C                   EXSR      CONV_AC2R1
     C                   Z-ADD     ZAMTCO        PSTAR1
     C                   EVAL      CA = RpC1CDP + 1
     C                   EVAL      PSTAR1 = PSTAR1 / POWER(CA)
 
      * Convert account currency amount to reporting currency 2
 
     C                   EXSR      CONV_AC2R2
     C                   Z-ADD     ZAMTCO        PSTAR2
     C                   EVAL      CA = RpC2CDP + 1
     C                   EVAL      PSTAR2 = PSTAR2 / POWER(CA)
 
      * Write a posting to the extract file
 
     C                   WRITE     MRPOSTD0
 
     C     IGNORE        TAG
      /SPACE 5
      **********************************************************************************
      * Get Historic Rates (Account Currency, Reporting Currency 1, Reporting Currency 2)
      **********************************************************************************
     C     GETHistRATES  BEGSR
 
      * Get Account Currency Historic Rate
     C                   MOVEL     CCY           I#CCY
     C                   Z-ADD     HistDate      I#DATE
     C                   EXSR      GET_RATE
     C                   Z-ADD     G2SPRT        AcctSPRT         13 8
     C                   MOVEL     G2MDIN        AcctMDIN          1
 
      * Get Reporting Currency 1 Historic Rate
     C                   MOVEL     RepCurrency1  I#CCY
     C                   Z-ADD     HistDate      I#DATE
     C                   EXSR      GET_RATE
     C                   Z-ADD     G2SPRT        RpC1SPRT         13 8
     C                   MOVEL     G2MDIN        RpC1MDIN          1
 
      * Get Reporting Currency 2 Historic Rate
     C                   MOVEL     RepCurrency2  I#CCY
     C                   Z-ADD     HistDate      I#DATE
     C                   EXSR      GET_RATE
     C                   Z-ADD     G2SPRT        RpC2SPRT         13 8
     C                   MOVEL     G2MDIN        RpC2MDIN          1
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      **********************************************************************************
      * Determine Cross Rates from Account Currency -> Reporting Currency 1 and 2
      **********************************************************************************
     C     DETCrossRATES BEGSR
 
      * Determine cross rate from Account Currency -> Reporting Currency 1
 
     C                   Z-ADD     AcctSPRT      ZRATE1
     C                   MOVE      AcctMDIN      ZMDI1
     C                   Z-ADD     RpC1SPRT      ZRATE2
     C                   MOVE      RpC1MDIN      ZMDI2
     C                   EXSR      CROSS_RATE
     C                   Z-ADD     ZRATEX        RepC1XRATE       13 8
     C                   MOVEL     ZMDIX         RepC1XMDIN        1
 
      * Determine cross rate from Account Currency -> Reporting Currency 2
 
     C                   Z-ADD     AcctSPRT      ZRATE1
     C                   MOVE      AcctMDIN      ZMDI1
     C                   Z-ADD     RpC2SPRT      ZRATE2
     C                   MOVE      RpC2MDIN      ZMDI2
     C                   EXSR      CROSS_RATE
     C                   Z-ADD     ZRATEX        RepC2XRATE       13 8
     C                   MOVEL     ZMDIX         RepC2XMDIN        1
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CONV_AC2BS    BEGSR
     C                   Z-ADD     PSTA          ZAMTCI
     C                   Z-ADD     AcctSPRT      ZEXCH
     C                   MOVE      AcctMDIN      ZMD
     C                   MOVE      CCY           ZCCYI
     C                   MOVE      BaseCurrency  ZCCYO
     C                   Z-ADD     AcctCDP       ZCDPI
     C                   Z-ADD     BaseCDP       ZCDPO
     C                   EXSR      CONVERT
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CONV_AC2R1    BEGSR
     C                   Z-ADD     PSTA          ZAMTCI
     C                   Z-ADD     RepC1XRATE    ZEXCH
     C                   MOVE      RepC1XMDIN    ZMD
     C                   MOVE      CCY           ZCCYI
     C                   MOVE      RepCurrency1  ZCCYO
     C                   Z-ADD     AcctCDP       ZCDPI
     C                   Z-ADD     RpC1CDP       ZCDPO
     C                   EXSR      CONVERT
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CONV_AC2R2    BEGSR
     C                   Z-ADD     PSTA          ZAMTCI
     C                   Z-ADD     RepC2XRATE    ZEXCH
     C                   MOVE      RepC2XMDIN    ZMD
     C                   MOVE      CCY           ZCCYI
     C                   MOVE      RepCurrency2  ZCCYO
     C                   Z-ADD     AcctCDP       ZCDPI
     C                   Z-ADD     RpC2CDP       ZCDPO
     C                   EXSR      CONVERT
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     GET_RATE      BEGSR
     C                   CALL      'MR000100'
     C                   PARM                    I#CCY             3
     C                   PARM                    I#DATE            5 0
     C                   PARM                    SDCUHS
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CONVERT       BEGSR
     C                   CALL      'ZCONVZ1'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     CROSS_RATE    BEGSR
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     ZDATE1        BEGSR
     C                   CALL      'ZDATE1'
     C                   PARM      *blank        ZERR              7            error code
     C                   PARM                    ZDATE             6 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDAYNO            5 0          Value date
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     DET_Quarter   BEGSR
     C                   SELECT
     C     BaseMonth     WHENGT    9
     C                   Z-ADD     4             Quarter           2 0
     C     BaseMonth     WHENGT    6
     C                   Z-ADD     3             Quarter
     C     BaseMonth     WHENGT    3
     C                   Z-ADD     2             Quarter
     C                   OTHER
     C                   Z-ADD     1             Quarter
     C                   ENDSL
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     DET_HalfYear  BEGSR
     C                   SELECT
     C     BaseMonth     WHENGT    6
     C                   Z-ADD     2             HalfYear          2 0
     C                   OTHER
     C                   Z-ADD     1             HalfYear
     C                   ENDSL
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *PSSR         BEGSR
 
     C     W#RUN         IFEQ      *BLANKS
 
     C                   MOVE      'Y'           W#RUN             1
 
     C                   MOVEL     '*ERROR'      I#RTCD            7
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
 
     C                   DUMP
      *
      * If no identified cause of error
      *
     C     I#ERMS        IFEQ      *BLANK
     C                   EVAL      I#ERMS = 'UNEXPECTED ERROR'
     C                   ENDIF
      *
      * Log an error on the error log
      *
     C                   CLEAR                   BUFFER
     C                   EVAL      BUFFER = I#ERMS
     C                   CALL      'GPWRTELOG'
     C                   PARM                    BUFFER         4000
 
     C                   SETON                                        LRU7U8
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    I#FILE            1
 
      * Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Access reporting parameters
 
     C     1             SETLL     MRRPRMPD
     C                   READ      MRRPRMPD                               99
      * Missing MRRPRMPD record
     C     *IN99         IFEQ      *ON
     C                   EVAL      I#ERMS = 'Missing Reporting Parameters'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   MOVE      BJCYCD        BaseCurrency      3
     C                   MOVE      RPCCY1        RepCurrency1      3
     C                   MOVE      RPCCY2        RepCurrency2      3
      * Base CDP
     C                   CALL      'MR000101'
     C                   PARM      BaseCurrency  I#CCY             3
     C                   PARM                    SDCURR
     C                   Z-ADD     A6NBDP        BaseCDP           1 0
      * RpC1 CDP
     C                   CALL      'MR000101'
     C                   PARM      RepCurrency1  I#CCY
     C                   PARM                    SDCURR
     C                   Z-ADD     A6NBDP        RpC1CDP           1 0
      * Missing currency
     C     A6SPRT        IFEQ      *ZERO
     C                   EVAL      I#ERMS = 'Bad Reporting Currency:' + I#CCY
     C                   EXSR      *PSSR
     C                   ENDIF
      * RpC2 CDP
     C                   CALL      'MR000101'
     C                   PARM      RepCurrency2  I#CCY
     C                   PARM                    SDCURR
     C                   Z-ADD     A6NBDP        RpC2CDP           1 0
      * Missing currency
     C     A6SPRT        IFEQ      *ZERO
     C                   EVAL      I#ERMS = 'Bad Reporting Currency:' + I#CCY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Z-add     0             CA                1 0
 
      * Convert run date to DD/MM/YY
 
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DayMonthYear
 
      * Write to Posting Calendar Months Extracted file
 
     C     I#FILE        IFEQ      'A'
     C                   Z-ADD     Year          CY
     C                   Z-ADD     Month         CM
     C                   Z-ADD     1             Day
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        CSMDAT
     C                   MOVEL     'Y'           CURRMN
     C                   WRITE     MRPCMXD0
     C                   ENDIF
 
      * Postings are extracted up to 12 whole months prior to run date
      * (including month of run date)
 
     C                   DO        11
     C                   SUB       1             Month                  9999
     C   99              ADD       12            Month
     C   99              SUB       1             Year
 
      * Write to Posting Calendar Months Extracted file
 
     C     I#FILE        IFEQ      'A'
     C                   Z-ADD     Year          CY
     C                   Z-ADD     Month         CM
     C                   Z-ADD     1             Day
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        CSMDAT
     C                   WRITE     MRPCMXD0
     C                   MOVEL     *BLANK        CURRMN
     C                   ENDIF
     C                   ENDDO
 
     C                   Z-ADD     1             Day
     C                   MOVEL     DayMonthYear  ZDATE
     C                   EXSR      ZDATE1
     C                   Z-ADD     ZDAYNO        LimitDate         5 0
 
     C                   MOVE      *BLANK        I#ERMS           50
     C                   ENDSR
     C**********************************************************************************
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
