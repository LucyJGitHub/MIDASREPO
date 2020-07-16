/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Generate Loan Events')                        *
     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MRGENLEVT - Generate Loan Events                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. MD055652           Date 02Jun20               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055652 - Dbase error occurs when generating MR event code  *
      *             for discount loan. Add event keys (63R1, 65R1 and *
      *             67R1), date code (R) and amount type (P) for      *
      *             principal repayment of discount loan in event     *
      *             arrays (#_ETYP, EVDC & EVAT). Pattern after fix   *
      *             MD047582A.                                        *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************

     FLVNTXEL   IP   F  363        DISK    INFSR(*PSSR)
     FMRTREVPD  O    E             DISK    INFSR(*PSSR)

     D*#_ETYP***       S              4    DIM(40) CTDATA PERRCD(1)                         MD055652
     D*EVDC*****       S              1    DIM(40) CTDATA PERRCD(1)                         MD055652
     D*EVAT*****       S              1    DIM(40) CTDATA PERRCD(1)                         MD055652
     D #_ETYP          S              4    DIM(43) CTDATA PERRCD(1)                         MD055652
     D EVDC            S              1    DIM(43) CTDATA PERRCD(1)                         MD055652
     D EVAT            S              1    DIM(43) CTDATA PERRCD(1)                         MD055652


     D X_EVCD          S              2    DIM(99)


     D POWER           S              8  0 DIM(8) CTDATA PERRCD(1)

     D                 DS
     D DayMonthYear            1      6  0
     D Day                     1      2  0
     D Month                   3      4  0
     D Year                    5      6  0

     D WkECDat         S              5  0
     D P_LNRF          S              6A                                                      CLE148

      ** Parameters for MRDATBID - Date Bucket Identification Module
     D PaDtSch         S              1  0
     D PaRepDt         S              5  0
     D PaSchDt         S              5  0
     D PaBuckCode      S              8

     D SDCURR        E DS                  EXTNAME(SDCURRPD)


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)

     ILVNTXEL   NS
     I**********                        2    7 0LNRF                                          CLE148
     I                                  2    7  LNRF                                          CLE148
     I                                 14   17  ETYP
     I                             P   18   20 0EDAT
     I                             P   21   27 0EAMT
     I                                 28   30  ECCY
     I                                231  231  INOI
     I                                363  363  IBRE


     C                   Z-ADD     1             X                 2 0
     C     ETYP          LOOKUP    #_ETYP(X)                              99
     C     *IN99         IFEQ      *ON
     C     EDAT          ANDNE     0
     C     EAMT          ANDNE     0
     C     IBRE          ANDNE     'Y'
     C                   EXSR      EXTRACT_EVENT
     C                   ENDIF

      /SPACE 5
     C**********************************************************************************
     C     EXTRACT_EVENT BEGSR

      * If new loan number, blank out event codes extracted

     C     LNRF          IFNE      P_LNRF
     C                   MOVE      *BLANK        X_EVCD
     C                   ENDIF
     C**********         Z-ADD     LNRF          P_LNRF            6 0                        CLE148
     C                   MOVEL     LNRF          P_LNRF                                       CLE148

      * Event codes extracted

     C                   Z-ADD     1             Y                 3 0
     C                   MOVE      ETYP          EventCode         2
     C     EventCode     LOOKUP    X_EVCD(Y)                              99
     C     *IN99         IFEQ      *OFF
     C     *BLANK        LOOKUP    X_EVCD(Y)                              99
     C                   MOVEL     EventCode     X_EVCD(Y)
     C                   ENDIF

      * Get Currency Details
     C                   CALL      'MR000101'
     C                   PARM      ECCY          I#CCY             3
     C                   PARM                    SDCURR
     C     A6NBDP        ADD       1             CA                1 0

      ** Set Extract Date
     C                   EVAL      EXTDAT = BJRDNB

      ** Set Event Control Date
     C                   EVAL      EXVCD = WkECDat

      ** Set Calendar/Financial
     C                   EVAL      EXCAFI = 'C'

      ** Set Period Type
     C                   EVAL      EXPERT = 'M'

      ** Set Calendar Year/Month
     C                   EVAL      EXCY = CalendarYear
     C                   EVAL      EXCM = CalendarMonth

      ** Set Module
     C                   EVAL      EXMOD = 'LE'

      ** Set Sub-Module
     C                   EVAL      EXSUB = 'LOAN'

      ** Set Transaction ID
     C                   MOVEL     LNRF          EXTRID

      ** Set Sequence Number
     C                   Z-ADD     0             EXSEQ

      ** Set Reconcile Event
     C                   MOVEL     *BLANK        EXREVT
     C     EVDC(X)       IFEQ      'M'
     C     EVAT(X)       ANDEQ     'P'
     C                   MOVEL     'Y'           EXREVT
     C                   ENDIF
     C     EVDC(X)       IFEQ      'M'
     C     EVAT(X)       ANDEQ     'I'
     C                   Z-ADD     1             Y
     C     'I2'          LOOKUP    X_EVCD(Y)                              99
     C     *IN99         IFEQ      *OFF
     C                   MOVEL     'Y'           EXREVT
     C                   ENDIF
     C                   ENDIF

      ** Set Midas Event Type
     C                   MOVEL     ETYP          EXMETP

      ** Set Event Date Code
     C                   MOVEL     EVDC(X)       EXEVDC

      ** Set Event Amount Type
     C                   MOVEL     EVAT(X)       EXEVAT

      ** Set Event Amount
     C     EAMT          DIV       POWER(CA)     EXEVAM

      ** Set In/Out indicator
     C                   MOVE      INOI          EXINOI

      ** Set Event Currency
     C                   MOVEL     ECCY          EXEVCY

      ** Set Event Date
     C                   Z-ADD     EDAT          EXEVDT

     C                   EVAL      PaRepDt = WkECDat
     C                   EVAL      PaSchDt = EXEVDT

      ** Set Event Date - Date schedule 0
     C                   EVAL      PaDtSch = 0
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXEVD0 = PaBuckCode

      ** Set Event Date - Date schedule 1
     C                   EVAL      PaDtSch = 1
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXEVD1 = PaBuckCode

      ** Set Event Date - Date schedule 2
     C                   EVAL      PaDtSch = 2
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXEVD2 = PaBuckCode

      ** Set Event Date - Date schedule 3
     C                   EVAL      PaDtSch = 3
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXEVD3 = PaBuckCode

      ** Set Event Date - Date schedule 4
     C                   EVAL      PaDtSch = 4
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXEVD4 = PaBuckCode

      ** Set Event Date - Date schedule 5
     C                   EVAL      PaDtSch = 5
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXEVD5 = PaBuckCode

      ** Set Event Date - Date schedule 6
     C                   EVAL      PaDtSch = 6
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXEVD6 = PaBuckCode

      ** Set Event Date - Date schedule 7
     C                   EVAL      PaDtSch = 7
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXEVD7 = PaBuckCode

      ** Set Event Date - Date schedule 8
     C                   EVAL      PaDtSch = 8
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXEVD8 = PaBuckCode

      ** Set Event Date - Date schedule 9
     C                   EVAL      PaDtSch = 9
     C                   EXSR      SRGetBuckCd
     C                   EVAL      EXEVD9 = PaBuckCode

     C                   WRITE     MRTREVD0
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
      *****************************************************************
     C     SRGetBuckCd   BEGSR

     C                   CALLB     'MRDATBID'
     C                   PARM                    PaDtSch
     C                   PARM                    PaRepDt
     C                   PARM                    PaSchDt
      ** Output
     C                   PARM                    PaBuckCode

     C                   ENDSR
      *****************************************************************
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
      /EJECT
     C*****************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C*****************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR

      * Access bank details

     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access General Ledger Details

     C                   CALL      'AOGELRR0'
     C                   PARM      '*DBERR  '    @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSFDY

      ** Set event control date to whichever is the lesser of the next
      ** working day and accrual profit date
     C                   EVAL      WkECDat = BJDNWD - 1
     C                   IF        BKAPDT < WkECDat
     C                   EVAL      WkECDat = BKAPDT
     C                   ENDIF

      * Convert run date to DD/MM/YY

     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZDATE         DayMonthYear

      * Calendar Year/Month

     C                   Z-ADD     Year          CalendarYear      2 0
     C                   Z-ADD     Month         CalendarMonth     2 0

     C                   MOVE      *BLANK        I#ERMS           50

     C                   ENDSR
     C**********************************************************************************
** #_ETYP - EVENT TYPES
61I2
61R1
61R2
61M1
61M2
62I2
62R1
62R2
62M1
62M2
63M1
63R5
64I2
64R1
64R2
64M1
64M2
65M1
66I2
66R1
66R2
66M1
66M2
67M1
68I2
68R1
68R2
68M1
68M2
69I2
69R1
69R2
69M1
69M2
70I2
70M1
70M2
72I2
72M1
72M2
63R1                                                                                        MD055652
65R1                                                                                        MD055652
67R1                                                                                        MD055652
** EVDC - EVENT DATE CODE
I
R
R
M
M
I
R
R
M
M
M
M
I
R
R
M
M
M
I
R
R
M
M
M
I
R
R
M
M
I
R
R
M
M
I
M
M
I
M
M
R                                                                                           MD055652
R                                                                                           MD055652
R                                                                                           MD055652
** EVAT - EVENT AMOUNT TYPE
I
P
I
P
I
I
P
I
P
I
P
I
I
P
I
P
I
P
I
P
I
P
I
P
I
P
I
P
I
I
P
I
P
I
I
P
I
I
P
I
P                                                                                           MD055652
P                                                                                           MD055652
P                                                                                           MD055652
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
