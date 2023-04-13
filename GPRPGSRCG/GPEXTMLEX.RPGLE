     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Extract ML exposure')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPEXTMLEX - Extract ML Exposure                              *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. EML109  *CREATE    Date 08Feb20               *
      * Bank Fusion Midas 2.1 Base------------------------------------*
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EML109 - Upgrade of NAD1 to FB2.1 SP21                       *
      *           NADC01 - ML Extracts for Mizuho                     *
      *                                                               *
      *****************************************************************

     FGPTRAPL0  IP  AE           K DISK
     FTXMLTRNEXPIS  AE           K DISK
     FTXUCAPTRANIS  AE           K DISK
     FGPPOSNL0  IF   E           K DISK
     FGZSDBANKPDIF   E             DISK
     FGZSDCUSTL1IF   E           K DISK
     FI_GPMLCSI0IF   E           K DISK
     FGPMLEXPD  O    E             DISK     rename(GPMLEXD0:GPMLEXF)
     FQSYSPRT   O    F  132        PRINTER

     D ZYDY            S              4  0 DIM(4) CTDATA PERRCD(4)
     D ZMDY            S              3  0 DIM(13) CTDATA PERRCD(13)
     D ZMNM            S              3    DIM(12) CTDATA PERRCD(12)

     D GPML          E DS                  EXTNAME(GPMLEXPD)

     D ZDayNo          S              5P 0
     D ZDatfm          S              1A
     D ZADate          S              7A
     D ZDate           S              6P 0

     IGOTRAPD0      01
     I                                          T_ID          L1M1
     ITXMLTRNEXF    02
     I              TETRNIDX                    T_ID          L1M1
     ITXUCAPTRAF    03
     I              TRAN_IDX                    T_ID          L1M1

     C     *ENTRY        PLIST
     C                   PARM                    I#ZONE           10
     C   L1              CLEAR                   GPML

     C   01              ADD       1             Cnt_TRAP
     C   02              ADD       1             Cnt_TRNEXP
     C   03              ADD       1             Cnt_UCAPTRN

     CL1                 SELECT

      * Extract Exposures

     CL1                 WHEN      Cnt_TRAP = 1
     C                             AND Cnt_TRNEXP = 1
     CL1                 EXSR      EXT_MLEX

      * Extract Uncaptured Transactions

     CL1                 WHEN      Cnt_TRAP = 1
     C                             AND T_SMOD = 'FXDL'
     C                             AND T_ZONE = 'PARIS'
     C                             AND Cnt_TRNEXP = 0
     C                             OR Cnt_TRAP = 1
     C                             AND T_SMOD = 'SIRS'
     C                             AND T_ZONE = 'PARIS'
     C                             AND Cnt_TRNEXP = 0
     C                             OR Cnt_TRAP = 1
     C                             AND T_SMOD = 'LDNI'
     C                             AND T_ZONE = 'MOSCOW'
     C                             AND Cnt_TRNEXP = 0
     CL1                 EXSR      EXT_MLUT

      * Ignore non FX and non IRS and in other zones

     CL1                 WHEN      Cnt_TRAP = 1
     C                             AND T_SMOD <> 'FXDL'
     C                             AND T_SMOD <> 'SIRS'
     C                             AND T_ZONE =  'PARIS'
     C                             AND Cnt_TRNEXP = 0
     C                             AND Cnt_UCAPTRN= 0
     C                             OR Cnt_TRAP = 1
     C                             AND T_SMOD <> 'LDNI'
     C                             AND T_ZONE =  'MOSCOW'
     C                             AND Cnt_TRNEXP = 0
     C                             AND Cnt_UCAPTRN= 0
     C                             OR Cnt_TRAP = 1
     C                             AND T_ZONE <> 'PARIS' AND T_ZONE <> 'MOSCOW'
     C                             AND Cnt_TRNEXP = 0
     C                             AND Cnt_UCAPTRN= 0

      * Report discrepancies

     CL1                 OTHER
     CL1                 EXSR      RPT_DISC
     CL1                 ENDSL

     CL1                 Z-ADD     0             Cnt_TRAP          2 0
     CL1                 Z-ADD     0             Cnt_TRNEXP        2 0
     CL1                 Z-ADD     0             Cnt_UCAPTRN       2 0

     CLR                 Z-ADD     1             CHLINE
     CLR                 EXSR      PAG
     CLR                 EXCEPT    ENDRPT
      *****************************************************************
     C     RPT_DISC      BEGSR
     C                   Z-ADD     1             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    DETAIL
     C                   ENDSR
      *****************************************************************
     C     PAG           BEGSR
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   EXCEPT    PAGEHEAD
     C     2             ADD       CHLINE        LINENO
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
     C     EXT_MLEX      BEGSR

     C                   EXSR      GET_POSN
     C     *IN99         CABEQ     '1'           ENDMLEX

     C                   EXSR      SET_OUTPUT

     C                   EXSR      MKT_VALUE

     C                   EXSR      LIMITCCY_AMNTS

     C                   WRITE     GPMLEXF

     C     ENDMLEX       ENDSR
      *****************************************************************
     C     EXT_MLUT      BEGSR

     C                   EVAL      TEINST    = *BLANK
     C                   EVAL      TEEXPOSURE= *ZERO
     C                   EVAL      TEOFFSET  = *ZERO

     C                   EXSR      GET_POSN
     C     *IN99         CABEQ     '1'           ENDMLUT

     C                   EVAL      TEEXPCCY  = P_CCY
     C                   EVAL      TEOFFCCY  = P_OCCY

     C                   EXSR      SET_OUTPUT

     C                   EXSR      MKT_VALUE

     C                   EXSR      LIMITCCY_AMNTS

     C                   WRITE     GPMLEXF

     C     ENDMLUT       ENDSR
      *****************************************************************
     C     GET_POSN      BEGSR
     C     GPPOSNK       KLIST
     C                   KFLD                    P_ID
     C                   KFLD                    P_TVDI
     C                   KFLD                    P_PSTP
     C                   EVAL      P_ID = T_ID
     C                   EVAL      P_TVDI = 'T'
     C                   EVAL      P_PSTP = 'C'
     C     GPPOSNK       CHAIN     GOPOSND0                           99
     C                   ENDSR
      *****************************************************************
     C     SET_OUTPUT    BEGSR
     C                   MOVEL     T_CNUM        Customer          6
     C                   MOVEL     T_CUBR        CustBranch        3
     C     CustomerKey   KLIST
     C                   KFLD                    CustBranch
     C                   KFLD                    Customer
     C     CustomerKey   CHAIN     SDCUSTD0                           99
     C   99              MOVEL     Customer      BBCUST
     C   99              MOVEL     CustBranch    BBBRCD
     C   99              MOVEL     *BLANK        BBCRNM

      * Global Customer number
     C                   EVAL      MEGCUST = BBBRCD + '-' + BBCUST
      * Customer Name
     C                   EVAL      MECUSTNAME = BBCUST + '  ' + BBCRNM
      * Transaction Reference
     C                   EVAL      METREF    = T_TREF
      * Booking Branch
     C                   EVAL      MEBRCA    = T_BRCA
      * Global Instrument Code
     C                   EVAL      MEINST    = TEINST

      * Transaction Date DDMMMYY
     C                   Z-ADD     T_TDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   EVAL      MERTDAT   = ZADATE
      * Start Date DDMMMYY
     C                   Z-ADD     T_SDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   EVAL      MERSDAT   = ZADATE
      * End Date DDMMMYY
     C                   Z-ADD     T_EDAT        ZDAYNO
     C                   EXSR      ZDATE2
     C                   EVAL      MEREDAT   = ZADATE
      * Nominal
     C                   IF        P_CCY <> 'JPY'
     C                   EVAL      MENOMINAL= P_NOML/100
     C                   ELSE
     C                   EVAL      MENOMINAL= P_NOML
     C                   ENDIF
      * Nominal Currency
     C                   EVAL      MENOMCCY  = P_CCY
      * Other Nominal
     C                   IF        P_OCCY <> 'JPY'
     C                   EVAL      MEOTHNOM = P_ONOM/100
     C                   ELSE
     C                   EVAL      MEOTHNOM = P_ONOM
     C                   ENDIF
      * Other Currency
     C                   EVAL      MEOTHCCY  = P_OCCY
      * Exposure
     C                   IF        TEEXPCCY <> 'JPY'
     C                   Z-ADD(H)  TEEXPOSURE    wrk172           17 2
     C                   EVAL      MEEXPOSURE= wrk172
     C                   ELSE
     C                   Z-ADD(H)  TEEXPOSURE    wrk150           15 0
     C                   EVAL      MEEXPOSURE= wrk150
     C                   ENDIF
      * Exposure Currency
     C                   EVAL      MEEXPCCY  = TEEXPCCY
      * Offset
     C                   IF        TEOFFCCY <> 'JPY'
     C                   Z-ADD(H)  TEOFFSET      wrk172
     C                   EVAL      MEOFFSET  = wrk172
     C                   ELSE
     C                   Z-ADD(H)  TEOFFSET      wrk150
     C                   EVAL      MEOFFSET  = wrk150
     C                   ENDIF
      * Offset Currency
     C                   EVAL      MEOFFCCY  = TEOFFCCY
      * % Weighting
     C                   IF        P_CCY <> 'JPY'
     C                   EVAL(H)   MEWEIGHT =  TEEXPOSURE/P_NOML *10000
     C                   ELSE
     C                   EVAL(H)   MEWEIGHT =  TEEXPOSURE/P_NOML *100
     C                   ENDIF
      * Customer number
     C                   EVAL      MECUST = BBCUST
      * Transaction ID
     C                   EVAL      MEID      = T_ID
      * Sub-Module
     C                   EVAL      MESMOD    = T_SMOD
      * Transaction Type
     C                   EVAL      METRTP    = T_TRTP
      * Transaction Sub Type
     C                   EVAL      METRST    = T_TRST
      * Transaction Date
     C                   EVAL      METDAT    = T_TDAT
      * Start Date
     C                   EVAL      MESDAT    = T_SDAT
      * End Date
     C                   EVAL      MEEDAT    = T_EDAT

     C                   ENDSR
      *****************************************************************
     C     MKT_VALUE     BEGSR
      * Market value
     C                   IF        T_VCCY  <> 'JPY'
     C                   EVAL      MEMKTVAL = T_MKVL/100
     C                   ELSE
     C                   EVAL      MEMKTVAL = T_MKVL
     C                   ENDIF
      * Market value currency
     C                   EVAL      MEMKTCCY = T_VCCY
     C                   ENDSR
      *****************************************************************
     C     LIMITCCY_AMNTSBEGSR
      * Zone
     C                   MOVEL     T_ZONE        ZONE

      * Limit currency
     C                   IF        ZONE = 'PARIS'
     C                   MOVE      'USD'         TCCY              3
     C                   ELSE
     C                   MOVE      'RUB'         TCCY
     C                   ENDIF

      * Nominal in Limit Ccy
     C                   MOVE      P_CCY         FCCY              3
     C                   Z-ADD     MENOMINAL     INAMT            17 2
     C                   Z-ADD     0             OTAMT            17 2
     C                   EXSR      CONV
     C                   EVAL      MENOMINLMC = OTAMT
      * Exposure in Limit Ccy
     C                   MOVE      P_CCY         FCCY              3
     C                   Z-ADD     MEEXPOSURE    INAMT            17 2
     C                   Z-ADD     0             OTAMT            17 2
     C                   EXSR      CONV
     C                   EVAL      MEEXPINLMC = OTAMT
      * Other Nominal in Limit Ccy
     C                   IF        P_OCCY <> '    '
     C                   MOVE      P_OCCY        FCCY              3
     C                   Z-ADD     MEOTHNOM      INAMT            17 2
     C                   Z-ADD     0             OTAMT            17 2
     C                   EXSR      CONV
     C                   EVAL      MEONMINLMC = OTAMT
     C                   ELSE
     C                   EVAL      MEONMINLMC = 0
     C                   ENDIF
      * Offset in Limit Ccy
     C                   IF        P_OCCY <> '    '
     C                   MOVE      P_OCCY        FCCY              3
     C                   Z-ADD     MEOFFSET      INAMT            17 2
     C                   Z-ADD     0             OTAMT            17 2
     C                   EXSR      CONV
     C                   EVAL      MEOFFINLMC = OTAMT
     C                   ELSE
     C                   EVAL      MEOFFINLMC = 0
     C                   ENDIF
      * Market Value in Limit Ccy
     C                   IF        T_VCCY <> '    '
     C                   MOVE      T_VCCY        FCCY              3
     C                   Z-ADD     MEMKTVAL      INAMT            17 2
     C                   Z-ADD     0             OTAMT            17 2
     C                   EXSR      CONV
     C                   EVAL      MEMKTINLMC = OTAMT
     C                   ELSE
     C                   EVAL      MEMKTINLMC = 0
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
     C     CONV          BEGSR

     C                   SELECT

     C                   WHEN      ZONE = 'PARIS' and FCCY = 'USD'
     C                   EVAL      OTAMT = INAMT

     C                   WHEN      ZONE = 'PARIS' and FCCY = 'EUR'
     C                   MOVE      TCCY          CCY
     C     KEY           CHAIN     GPMLCSPD                           99
     C   99              EVAL      CCYSRATE = 1
     C   99              Z-ADD     1             #ERROR            3 0
     C   99              DUMP
     C                   EVAL(H)   OTAMT = INAMT / CCYSRATE

     C                   WHEN      ZONE = 'MOSCOW' and FCCY = 'RUB'
     C                   EVAL      OTAMT = INAMT

     C                   OTHER
     C                   MOVE      FCCY          CCY
     C     KEY           CHAIN     GPMLCSPD                           99
     C   99              EVAL      CCYSRATE = 1
     C   99              Z-ADD     2             #ERROR
     C   99              DUMP
     C                   EVAL(H)   OTAMT = INAMT * CCYSRATE
     C                   MOVE      TCCY          CCY
     C     KEY           CHAIN     GPMLCSPD                           99
     C   99              EVAL      CCYSRATE = 1
     C   99              Z-ADD     3             #ERROR
     C   99              DUMP
     C                   EVAL(H)   OTAMT = OTAMT / CCYSRATE
     C                   ENDSL

     C     KEY           KLIST
     C                   KFLD                    CCY               3
     C                   KFLD                    ZONE             10

     C                   ENDSR
      *****************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM      BJDFIN        ZDatfm
     C                   PARM                    ZDate
     C                   PARM                    ZADate
     C                   ENDSR
      *****************************************************************
     C     *INZSR        BEGSR

     C                   READ      GZSDBANKPD                             H1
     C                   DOW       BJZONE <> I#ZONE
     C                   READ      GZSDBANKPD                             H1
     C                   ENDDO
     C   H1              DUMP

     C                   Z-ADD     99            LINENO            3 0
     C                   Z-ADD     0             PAGNUM            5 0
     C                   EXSR      PAG

     C                   ENDSR
      *****************************************************************
     OQSYSPRT   E            PAGEHEAD        001002
     O                                           14 'REF. GPEXTMLEX'
     O                                           68 'EXPOSURE DISCEPANCY REPORT'
     O                                           70 '-'
     O                       I#ZONE              81
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                           15 'TRANSACTION ID'
     O                                           40 'TRAP Count'
     O                                           60 'TRNEXP Count'
     O                                           80 'UCAPTRN Count'
     O          E            DETAIL      1
     O                       T_ID                15
     O                       Cnt_TRAP            40 '0 '
     O                       Cnt_TRNEXP          60 '0 '
     O                       Cnt_UCAPTRN         80 '0 '
     O          E            ENDRPT      1
     O                                           70 '*END OF REPORT*'
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
