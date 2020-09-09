     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Report ML Limits')                            *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPRPTMLEX - Report ML Exposure                               *
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
      *           Apply fix AR726025                                  *
      *           AR726025 - Include checking if Tenor period falls on*
      *                 invalid date, if invalid date, adjust to the  *
      *                 valid date prior. (Child: AR726026)           *
      *                                                               *
      *****************************************************************

     FT_MLLIMIT IP   E             DISK    rename(T_MLLIMIT:T_MLLIMF)
     FGZSDBANKPDIF   E             DISK
     FGZSDCUSTL1IF   E           K DISK
     FI_MLTENOR0IF   E           K DISK
     FT_GRINSTL IF   E           K DISK    rename(T_GRINSTL:T_GRINSTLF)
     FI_GRCUSTL0IF   E           K DISK    rename(T_GRCUSTL:T_GRCUSTLF)
     FT_GRCUSTG IF   E           K DISK    rename(T_GRCUSTG:T_GRCUSTGF)
     FGPMLEXPD  UF   E           K DISK
     FQSYSPRT   O    F  132        PRINTER

     D INGRPID         S              5  0 DIM(99)
     D INSTR           S             10    DIM(99)
     D INSTRUL         S             10    DIM(99)
     D CUGRPID         S              5  0 DIM(99)
     D CUGRPNM         S             20    DIM(99)
     D CUSTR           S            200    DIM(99)
     D CUSTRArr        S             10    DIM(20)

     D PRtCd           S              7A
     D PFldIn          S             16A
     D PDecPlace       S              1  0
     D PDigits         S              2  0
     D PFldOut         S             16A

     D ZDayNo          S              5P 0
     D ZDatfm          S              1A
     D ZADate          S              7A
     D ZDate           S              6P 0

     D                 DS
     D ZDATE_DS                1      6  0
     D  ZDD                    1      2  0
     D  ZMM                    3      4  0
     D  ZYY                    5      6  0

      *                                                                                     AR726025
      ** Working Variables                                                                  AR726025
      *                                                                                     AR726025
     D ZLYR            S              2  0                                                  AR726025
     D ZLY             S              1  0                                                  AR726025
      *                                                                                     AR726025
     D                 DS                                                                   AR726025
     D ZWDATE_DS               1      6  0                                                  AR726025
     D  ZWDD                   1      2  0                                                  AR726025
     D  ZWMM                   3      4  0                                                  AR726025
     D  ZWYY                   5      6  0                                                  AR726025
      *                                                                                     AR726025
     C     *ENTRY        PLIST
     C                   PARM                    I#ZONE           10

     C                   IF        I#ZONE = 'PARIS ' and LIENTYCODE = 'PA1' or
     C                             I#ZONE = 'MOSCOW' and LIENTYCODE = 'MO1'
     C                   EXSR      RPT_LIMIT
     C                   ENDIF

     CLR                 Z-ADD     1             CHLINE
     CLR                 EXSR      PAG
     CLR                 EXCEPT    ENDRPT
      *****************************************************************
     C     RPT_LIMIT     BEGSR

      * INSTRUMENT
     C                   Z-ADD     LIINSTGRP     InstGroup         5 0
     C                   Z-ADD     1             #I
     C                   Z-ADD     1             #IU               3 0
     C                   MOVEL     *BLANK        INSTRUL
     C     InstGroup     LOOKUP    INGRPID(#I)                            99
     C                   MOVEL     INSTR(#I)     Instrument       10
     C                   MOVEL     INSTR(#I)     INSTRUL(#IU)
     C                   DOW       *IN99 = *ON
     C                   ADD       1             #I
     C     InstGroup     LOOKUP    INGRPID(#I)                            99
     C   99              ADD       1             #IU
     C   99              MOVEL     INSTR(#I)     INSTRUL(#IU)
     C                   ENDDO

      * TENOR
     C                   Z-ADD     LITENOR       TENORNO           3 0
     C                   Z-ADD     LITENOR       TID
     C     TID           CHAIN     I_MLTENOR0                         99
     C   99              MOVEL     *BLANK        TFROM
     C   99              MOVEL     *BLANK        TTO

     C                   Z-ADD(H)  LIEXPOSURE    EXPOSURE         17 2
     C                   Z-ADD     0             TOEXPOSURE       17 2

      * CUSTOMER
     C                   MOVEL     *BLANK        BBCRNM
     C                   IF        LIUTSRTYPE = 1
     C                   MOVE      LIUTSRCODE    Customer          6
     C                   MOVEL     LIUTSRCODE    CustBranch        3
     C     CustomerKey   KLIST
     C                   KFLD                    CustBranch
     C                   KFLD                    Customer
     C     CustomerKey   CHAIN     SDCUSTD0                           99
     C                   ENDIF

      * CUSTOMER GROUP
     C                   IF        LIUTSRTYPE = 2
     C                   MOVEL     LIUTSRCODE    PFldIn
     C                   EXSR      ZALIGN
     C                   MOVE      PFldOut       GroupNo           5 0
     C                   Z-ADD     1             #I
     C     GroupNo       LOOKUP    CUGRPID(#I)                            98
     C                   MOVEA     CUSTR(#I)     CUSTRArr
     C                   MOVEL     CUGRPNM(#I)   BBCRNM
     C                   ENDIF

      * Limit
     C                   Z-ADD     2             CHLINE            2 0
     C                   EXSR      PAG
     C                   MOVEL     Instrument    LIM_Instrument
     C                   IF        %SubSt(LIM_Instrument:1:2) = 'MM'
     C                   MOVEL     'MM (All)  '  Lim_Instrument   10
     C                   ENDIF
     C                   EXCEPT    LIMIT

      * Report transactions

     C                   IF        LIUTSRTYPE = 1
     C                   EXSR      RPT_CUST_Trans
     C                   ENDIF
     C                   IF        LIUTSRTYPE = 2
     C                   EXSR      RPT_CGRP_Trans
     C                   ENDIF

      * Total Exposure

     C                   Z-ADD(H)  TOEXPOSURE    TOEXP            15 0
     C                   Z-ADD(H)  EXPOSURE      EXP              15 0
      * Limit
     C     LIAMT         MULT      100           TOLIMIT          15 0
     C     TOEXP         COMP      EXP                                5050
     C                   Z-ADD     2             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    TOTAL
     C                   ENDSR
      *****************************************************************
     C     RPT_CUST_TransBEGSR

     C                   EVAL      MEGCUST = LIUTSRCODE
     C     GPMLEXKey     KLIST
     C                   KFLD                    MEGCUST

      * Exposure

     C     GPMLEXKey     SETLL     GPMLEXD0
     C     GPMLEXKey     READE     GPMLEXD0                               99
     C     *IN99         DOWEQ     *OFF

      * If instrument on limit

     C                   Z-ADD     1             #IU
     C     MEINST        LOOKUP    INSTRUL(#IU)                           99
     C                   IF        *IN99 = *ON and MEINST <> *BLANK
     C                   EXSR      INCL_EXP

     C                   Z-ADD     1             CHLINE            2 0
     C                   EXSR      PAG
     C  N40
     CANN41              EXCEPT    TRNEXP
     C  N40
     CANN41              ADD       MEEXPINLMC    TOEXPOSURE
      * UPDATE GPMLEXPD
     C   41              DELETE    GPMLEXD0
     C  N41              EXCEPT    UPDMLEX
     C                   ENDIF

     C     GPMLEXKey     READE     GPMLEXD0                               99
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
     C     RPT_CGRP_TransBEGSR

     C                   Z-ADD     1             #C
     C     CUSTRArr(#C)  DOWNE     *BLANK

     C                   EVAL      MEGCUST = CUSTRArr(#C)

      * Exposure

     C     GPMLEXKey     SETLL     GPMLEXD0
     C     GPMLEXKey     READE     GPMLEXD0                               99
     C     *IN99         DOWEQ     *OFF

      * If instrument on limit

     C                   Z-ADD     1             #IU
     C     MEINST        LOOKUP    INSTRUL(#IU)                           99
     C                   IF        *IN99 = *ON and MEINST <> *BLANK
     C                   EXSR      INCL_EXP

     C                   Z-ADD     1             CHLINE            2 0
     C                   EXSR      PAG
     C  N40
     CANN41              EXCEPT    TRNEXP
     C  N40
     CANN41              ADD       MEEXPINLMC    TOEXPOSURE
      * UPDATE GPMLEXPD
     C   41              DELETE    GPMLEXD0
     C  N41              EXCEPT    UPDMLEX
     C                   ENDIF

     C     GPMLEXKey     READE     GPMLEXD0                               99
     C                   ENDDO

     C                   ADD       1             #C
     C                   ENDDO

     C                   ENDSR
      *****************************************************************
     C     INCL_EXP      BEGSR

     C                   MOVE      *BLANK        METENX

     C                   Z-ADD     *HIVAL        W_CDAT            5 0
     C                   Z-ADD     BJRDNB        ZDAYNO                 98
     C                   EXSR      ZDATE2

     C                   SELECT
      * 16D
     C     TTO           WHENEQ    '16D'
     C                   EVAL      W_CDAT = BJRDNB + 16
      * 3M
     C     TTO           WHENEQ    '3M '
     C                   ADD       3             ZMM
     C     ZMM           IFGT      12
     C                   SUB       12            ZMM
     C                   ADD       1             ZYY
     C                   ENDIF
     C                   EXSR      ZDATE1
     C                   EVAL      W_CDAT = PMidasDayNo
      * 6M
     C     TTO           WHENEQ    '6M '
     C                   ADD       6             ZMM
     C     ZMM           IFGT      12
     C                   SUB       12            ZMM
     C                   ADD       1             ZYY
     C                   ENDIF
     C                   EXSR      ZDATE1
     C                   EVAL      W_CDAT = PMidasDayNo
      * 1Y
     C     TTO           WHENEQ    '1Y '
     C                   ADD       1             ZYY
     C                   EXSR      ZDATE1
     C                   EVAL      W_CDAT = PMidasDayNo
      * 2Y
     C     TTO           WHENEQ    '2Y '
     C                   ADD       2             ZYY
     C                   EXSR      ZDATE1
     C                   EVAL      W_CDAT = PMidasDayNo
      * 3Y
     C     TTO           WHENEQ    '3Y '
     C                   ADD       3             ZYY
     C                   EXSR      ZDATE1
     C                   EVAL      W_CDAT = PMidasDayNo
      * 5Y
     C     TTO           WHENEQ    '5Y '
     C                   ADD       5             ZYY
     C                   EXSR      ZDATE1
     C                   EVAL      W_CDAT = PMidasDayNo
      * 10Y
     C     TTO           WHENEQ    '10Y'
     C                   ADD       10            ZYY
     C                   EXSR      ZDATE1
     C                   EVAL      W_CDAT = PMidasDayNo
     C                   ENDSL

      *                                                                                     AR726025
      ** Check result date, if invalid or Return code is '*ERROR'                           AR726025
      ** adjust date                                                                        AR726025
      *                                                                                     AR726025
     C                   IF        W_CDAT = 0 OR PRtcd = '*ERROR'                           AR726025
     C                   EXSR      CHECK_DATE                                               AR726025
     C                   ENDIF                                                              AR726025
      *                                                                                     AR726025
      * TENOR DETAILS

     C                   MOVE      TFROM         MEFROM
     C                   MOVE      TTO           METO

     C                   SETOFF                                       4041
      * TENOR EXCEEDED
     C     MEEDAT        IFGT      W_CDAT
     C                   SETON                                        40
     C                   MOVE      'Y'           METENX
     C                   ENDIF
      * MATURED
     C     MEEDAT        IFLT      BJRDNB
     C                   SETON                                        41
     C                   ENDIF
      * NO EXPOSURE
     C     MEEXPINLMC    IFEQ      0
     C                   SETON                                        41
     C                   ENDIF
      * LIMIT ID
     C                   EVAL      MELIMTID = LILIMITID

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
     C     ZALIGN        BEGSR                                                  *** ZALIGN ***
     C                   CALL      'ZALIGN'
     C                   PARM                    PRtCd
     C                   PARM                    PFldIn
     C                   PARM      0             PDecPlace
     C                   PARM      5             PDigits
     C                   PARM                    PFldOut
     C                   ENDSR
      *****************************************************************
     C     ZDATE1        BEGSR                                                  *** ZDATE1 ***
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PRtcd             7
     C                   PARM      ZDATE_DS      PMMDDYY           6 0
     C                   PARM      'D'           PDateFmt          1
     C                   PARM      *ZEROS        PMidasDayNo       5 0
     C                   ENDSR
      *****************************************************************
     C     ZDATE2        BEGSR                                                  *** ZDATE2 ***
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDayNo
     C                   PARM      BJDFIN        ZDatfm
     C                   PARM                    ZDate
     C                   PARM                    ZADate
     C                   Z-ADD     ZDATE         ZDATE_DS
     C                   ENDSR
      *****************************************************************
     C     *INZSR        BEGSR

     C                   READ      GZSDBANKPD                             H1
     C                   DOW       BJZONE <> I#ZONE
     C                   READ      GZSDBANKPD                             H1
     C                   ENDDO

     C                   Z-ADD     99            LINENO            3 0
     C                   Z-ADD     0             PAGNUM            5 0
     C                   EXSR      PAG

      * LOAD INSTRUMENT GROUPS

     C                   Z-ADD     0             #I                2 0
     C                   READ      T_GRINSTLF                             99
     C     *IN99         DOWEQ     *OFF
     C                   IF        NLPARENT  <> 0
     C                   ADD       1             #I
     C                   EVAL      INGRPID(#I) = NLPARENT
     C                   EVAL      INSTR(#I)   = NLINSTCODE
     C                   ENDIF
     C                   READ      T_GRINSTLF                             99
     C                   ENDDO

      * LOAD CUSTOMER GROUPS

     C                   Z-ADD     0             #I                2 0
     C                   READ      T_GRCUSTLF                             99
     C     *IN99         DOWEQ     *OFF
     C                   IF        CLLEVEL = 1
     C                   ADD       1             #I
     C                   EVAL      CUGRPID(#I) = CLGRPID
     C                   EVAL      CGID        = CLGRPID
     C     CGID          CHAIN     T_GRCUSTGF                         99
     C                   MOVEL     CGNAME        CUGRPNM(#I)
     C                   MOVE      *BLANK        CUSTRArr
     C                   Z-ADD     0             #C                2 0
     C                   ENDIF
     C                   IF        CLLEVEL = 2
     C                   ADD       1             #C
     C                   EVAL      CUSTRArr(#C) = CLCUSTCODE
     C                   MOVEA     CUSTRArr      CUSTR(#I)
     C                   ENDIF
     C                   READ      T_GRCUSTLF                             99
     C                   ENDDO

     C                   ENDSR
      *                                                                                     AR726025
      /EJECT                                                                                AR726025
      **********************************************************************                AR726025
      *                                                                    *                AR726025
      *  CHECK_DATE - Validates and adjust the date                        *                AR726025
      *                                                                    *                AR726025
      **********************************************************************                AR726025
     C     CHECK_DATE    BEGSR                                                              AR726025
      *                                                                                     AR726025
      ** If April, June, September and November and day is greater                          AR726025
      ** than 30, just change the day to 30.                                                AR726025
      *                                                                                     AR726025
     C                   MOVE      ZDATE_DS      ZWDATE_DS                                  AR726025
     C                   SELECT                                                             AR726025
     C                   WHEN      ZWMM = 4 OR                                              AR726025
     C                             ZWMM = 6 OR                                              AR726025
     C                             ZWMM = 9 OR                                              AR726025
     C                             ZWMM = 11                                                AR726025
      *                                                                                     AR726025
     C                   IF        ZWDD > 30                                                AR726025
     C                   Z-ADD     30            ZWDD                                       AR726025
     C                   ENDIF                                                              AR726025
      *                                                                                     AR726025
      ** If February, check for leap year; remainder is zero                                AR726025
      ** if leap year                                                                       AR726025
      *                                                                                     AR726025
     C                   WHEN      ZWMM  = 2                                                AR726025
     C     ZWYY          DIV       4             ZLYR                                       AR726025
     C                   MVR                     ZLY                                        AR726025
      *                                                                                     AR726025
     C                   IF        ZLY > 0 AND                                              AR726025
     C                             ZWDD > 28                                                AR726025
     C                   Z-ADD     28            ZWDD                                       AR726025
     C                   ENDIF                                                              AR726025
      *                                                                                     AR726025
     C                   IF        ZLY = 0 AND                                              AR726025
     C                             ZWDD > 29                                                AR726025
     C                   Z-ADD     29            ZWDD                                       AR726025
     C                   ENDIF                                                              AR726025
      *                                                                                     AR726025
     C                   ENDSL                                                              AR726025
      *                                                                                     AR726025
     C                   MOVE      ZWDATE_DS     ZDATE_DS                                   AR726025
     C                   EXSR      ZDATE1                                                   AR726025
     C                   EVAL      W_CDAT = PMidasDayNo                                     AR726025
      *                                                                                     AR726025
     C                   ENDSR                                                              AR726025
      *****************************************************************
     OQSYSPRT   E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMLEX'
     O                                           70 'LIMIT V. EXPOSURE REPORT -'
     O                       I#ZONE              81
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                           10 'CUSTOMER'
     O                                           26 'TRANS.ID'
     O                                           37 'TRANS.REF'
     O                                           70 'EXPOSURE'
     O                                           80 'MAT DAT'
     O                                          101 'INSTRUMENT'
     O          E            LIMIT       1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O          E            LIMIT       1
     O                       LIUTSRCODE          10
     O                       BBCRNM              31
     O                       EXPOSURE            70 '   ,   ,   ,   , 0 .  '
     O                       LIM_Instrument     101
     O                                          110 'TENOR:'
     O                       TFROM              125
     O                       TTO                132
     O                                          120 '-'
     O          E            TRNEXP      1
     O                       MEID          Z     26
     O                       METREF              47
     O                       MEEXPINLMC          70 '   ,   ,   ,   , 0 .  '
     O                       MEREDAT             80
     O                       MESMOD              90
     O                       MEINST             101
     O          E            TOTAL       1
     O                                           48 'EXPOSURE->'
     O                       TOEXPOSURE          70 '   ,   ,   ,   , 0 .  '
     O                     50                    86 '?? - Difference'
     O          E            TOTAL       1
     O                                           48 'LIMIT---->'
     O                       TOLIMIT             70 '   ,   ,   ,   , 0 .  '
     O          E            ENDRPT      1
     O                                           70 '*END OF REPORT*'
     OGPMLEXD0  E            UPDMLEX
     O                       MEFROM
     O                       METO
     O                       METENX
     O                       MELIMTID
