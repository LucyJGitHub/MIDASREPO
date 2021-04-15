     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Extract ML Counterparty Exposure')            *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPEXTMLXP - Extract ML Counterparty Exposure                 *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI103             Date 25Jun19               *
      *  Prev Amend No. NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI103 - Upgraded MPlus 121 NADC01 ML Extracts to FB 2.1     *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************
 
     FT_MLLIMIT IP   E             DISK    rename(T_MLLIMIT:T_MLLIMF)
     FGZSDBANKPDIF   E             DISK
     FGZSDCUSTL1IF   E           K DISK
     FGPCUSTL0  IF   E           K DISK
     FGPCUSTXL2 IF   E           K DISK
     FI_MLTENOR0IF   E           K DISK
     FT_GRINSTL IF   E           K DISK    rename(T_GRINSTL:T_GRINSTLF)
     FI_GRCUSTL0IF   E           K DISK    rename(T_GRCUSTL:T_GRCUSTLF)
     FT_GRCUSTG IF   E           K DISK    rename(T_GRCUSTG:T_GRCUSTGF)
     FGPMLEXPD  UF   E           K DISK
     FGPCTRYL0  IF   E           K DISK
     FGPMLXPPD  O    E           K DISK
     FQSYSPRT   O    F  132        PRINTER
 
      **   JNSTAT DATA AREA
     D JNSTAT         UDS           200
     D  PRUN                 103    105P 0
 
     D INGRPID         S              5  0 DIM(99)
     D INSTR           S             10    DIM(99)
     D CUGRPID         S              5  0 DIM(9999)
     D CUGRPNM         S             20    DIM(9999)
     D CUSTR           S            200    DIM(9999)
     D CUSTRArr        S             10    DIM(20)
 
     D CTRY            S              7    DIM(30)
     D CTRYTOT         S             17  2 DIM(30)
 
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
 
     D                 DS
     D MECNCD_GLCAT            1      7
     D MECNCD                  1      2
     D MEGLCAT                 3      7
 
     C                   IF        LIUTSRTYPE = 1
     C                             AND LISTATUS <> 'E'
     C                             AND I#CUPA = 'C'
     C                             OR LIUTSRTYPE = 2
     C                             AND LISTATUS <> 'E'
     C                             AND I#CUPA <> 'C'
     C                   EXSR      RPT_LIMIT
     C                   ADD       1             Count_LIM         5 0
     C                   ENDIF
 
     CLR                 Z-ADD     1             CHLINE
     CLR                 EXSR      PAG
     CLR                 EXCEPT    ENDRPT
      *****************************************************************
     C     RPT_LIMIT     BEGSR
 
      * INSTRUMENT
     C                   Z-ADD     LIINSTGRP     InstGroup         5 0
     C                   Z-ADD     1             #I
     C     InstGroup     LOOKUP    INGRPID(#I)                            99
     C                   MOVEL     INSTR(#I)     Instrument       10
 
      * TENOR
     C                   Z-ADD     LITENOR       TENORNO           3 0
     C                   Z-ADD     LITENOR       TID
     C     TID           CHAIN     I_MLTENOR0                         99
     C   99              MOVEL     *BLANK        TFROM
     C   99              MOVEL     *BLANK        TTO
 
      * Counterparty Exposure
      * Total Instrument Exposure
 
     C                   Z-ADD     1             #CT               2 0
     C                   MOVEL     *BLANK        CTRY
     C                   Z-ADD     *ZERO         CTRYTOT
     C                   Z-ADD(H)  LIEXPOSURE    EXPOSURE         17 2
     C                   Z-ADD     0             TOEXPOSURE       17 2
 
      * CUSTOMER
     C                   MOVEL     *BLANK        CUCNCZ
     C                   MOVEL     *BLANK        CUCOLC
     C                   MOVEL     *BLANK        CUCRNM
     C                   IF        LIUTSRTYPE = 1
     C                   MOVEL     LIUTSRCODE    Customer         10
     C     CustomerKey   KLIST
     C                   KFLD                    Customer         10
     C     CustomerKey   CHAIN     GPCUSTD0                           99
     C                   ENDIF
 
      * CUSTOMER GROUP
     C                   IF        LIUTSRTYPE = 2
     C                   MOVEL     *BLANK        PFldIn
     C                   MOVEL     LIUTSRCODE    PFldIn
     C                   EXSR      ZALIGN
     C                   MOVE      PFldOut       GroupNo           5 0
     C                   Z-ADD     1             #I
     C     GroupNo       LOOKUP    CUGRPID(#I)                            98
     C                   MOVEA     CUSTR(#I)     CUSTRArr
     C                   MOVEL     CUGRPNM(#I)   CUCRNM
     C                   ENDIF
 
      * Limit
     C                   Z-ADD     2             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    LIMIT
 
      * Report transactions
 
     C                   IF        LIUTSRTYPE = 1
     C                   EXSR      RPT_CUST_Trans
     C                   ENDIF
     C                   IF        LIUTSRTYPE = 2
     C                   EXSR      RPT_CGRP_Trans
     C                   ENDIF
 
      * Counterparty Exposure
      * Total Instrument Exposure
 
     C                   Z-ADD(H)  EXPOSURE      EXP              15 0
     C                   Z-ADD(H)  TOEXPOSURE    TOEXP            15 0
      * Counterparty Limit
     C                   Z-ADD     LIAMT         CPLIMIT          15 0
 
      * Compare counterparty exposure v. total instrument exposure
 
     C     EXP           COMP      TOEXP                              5050
     C   50              ADD       1             Count_LIMINV      5 0
     C                   Z-ADD     2             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    TOTAL
 
     C                   Z-ADD     1             #CT
     C     CTRY(#CT)     DOUEQ     *BLANK
      * Limit Defined
     C                   MOVE      'Y'           MELIMDEF
      * Limit ID
     C                   Z-ADD     LILIMITID     MELIMITID
      * Utilisor Type
      * Utilisor Code
     C                   Z-ADD     LIUTSRTYPE    MEUTSRTYPE
     C                   MOVEL     LIUTSRCODE    MEUTSRCODE
      * Customer & Report Name
     C                   IF        LIUTSRTYPE = 1
     C                   EVAL      MECUSTNAME = BBCUST + '  ' + BBCRNM
     C                   ELSE
     C                   MOVEL     LIUTSRCODE    WGRP              6
     C                   EVAL      MECUSTNAME = WGRP   + '  ' + CUCRNM
     C                   ENDIF
      * Booking Branch
     C                   MOVEL     LIENTYCODE    MEBRCA
      * Country
     C                   IF        Instrument='GLOBFX'
     C                   MOVE      '2 OFF'       MEGLCAT
     C                   ELSE
     C                   MOVE      '1 ON '       MEGLCAT
     C                   ENDIF
     C                   IF        LIUTSRTYPE = 1
     C                   IF        CTRY(#CT) <> *BLANK
     C                   MOVEL     CTRY(#CT)     MECNCD
     C                   MOVE      CTRY(#CT)     MEGLCAT
     C                   ELSE
     C                   IF        Instrument='GLOBLE' OR Instrument='GLOBSE'
     C                   MOVEL     CUCNCZ        MECNCD
     C                   ELSE
     C                   MOVEL     CUCOLC        MECNCD
     C                   ENDIF
     C                   ENDIF
     C                   MOVEL     *BLANK        A4CNNM
     C     MECNCD        CHAIN     GPCTRYD0                           99
     C                   EVAL      MECNCDNAM = MECNCD + ' ' + A4CNNM
     C                   ELSE
     C                   EVAL      MECNCD    = *BLANK
     C                   EVAL      MECNCDNAM = *BLANK
     C                   ENDIF
      * Global Instrument Code
     C                   MOVEL     Instrument    MEINST
      * Total Instrument Exposure in USD
     C                   Z-ADD(H)  CTRYTOT(#CT)  METIEXUSD
      * Counterparty Exposure in USD
     C                   IF        CTRYTOT(#CT) = EXP  OR TOEXP = 0
     C                   Z-ADD     EXP           MEPEXPUSD
     C                   Z-ADD     0             EXP
     C                   ELSE
     C     EXP           MULT      CTRYTOT(#CT)  WRK300           30 0
     C     WRK300        DIV(H)    TOEXP         MEPEXPUSD
     C                   ENDIF
      * Total Diff in USD
     C     MEPEXPUSD     SUB       METIEXUSD     METDIFUSD
      * Limit in USD
     C                   Z-ADD     CPLIMIT       MELIMTUSD
      * Limit Expiry Date
     C                   MOVE      LIEXPDATE     MEEXPDATE
      * Limit Defined - Country
     C                   MOVE      'N'           MELIMDEFX
     C                   WRITE     GPMLXPD0
     C                   Z-ADD     0             CPLIMIT
      *
     C                   ADD       1             #CT
      *
     C                   ENDDO
      *
     C                   ENDSR
      *****************************************************************
     C     RPT_CUST_TransBEGSR
 
     C     GPCUSTXKey    KLIST
     C                   KFLD                    Customer
     C                   EVAL      Customer= LIUTSRCODE
     C                   MOVE      *BLANK        CUBRCD
     C                   MOVE      *BLANK        CUCUST
     C     GPCUSTXKey    CHAIN     GPCUSTXD0                          99
     C     GPMLEXKey     CHAIN     SDCUSTD0                           99
     C   99              MOVEL     CUCUST        BBCUST
     C   99              MOVEL     CUBRCD        BBBRCD
     C   99              MOVEL     *BLANK        BBCRNM
     C     GPMLEXKey     KLIST
     C                   KFLD                    CUBRCD
     C                   KFLD                    CUCUST
 
      * Exposure
 
     C     GPMLEXKey     SETLL     GPMLEXD0
     C     GPMLEXKey     READE     GPMLEXD0                               99
     C     *IN99         DOWEQ     *OFF
 
      * If instrument on limit
 
     C                   IF        MEINST = Instrument
     C                             AND MEBRCA = LIENTYCODE
     C                   EXSR      INCL_EXP
 
     C                   MOVE      *BLANK        TREF             40
     C                   IF        MESNAM <> *BLANK
     C                   MOVEL     MESNAM        TREF
     C                   ELSE
     C                   MOVEL     METREF        TREF
     C                   ENDIF
 
     C                   Z-ADD     1             CHLINE            2 0
     C                   EXSR      PAG
     C  N40
     CANN41
     CANN42              EXCEPT    TRNEXP
     C  N40
     CANN41
     CANN42              ADD       MEEXPINUSD    TOEXPOSURE
     C  N40
     CANN41
     CANN42              DO
     C                   Z-ADD     1             #CT
     C     MECNCD_GLCAT  LOOKUP    CTRY(#CT)                              99
     C  N99*BLANK        LOOKUP    CTRY(#CT)                              99
     C                   MOVEL     MECNCD_GLCAT  CTRY(#CT)
     C                   ADD       MEEXPINUSD    CTRYTOT(#CT)
     C                   ENDDO
      * UPDATE GPMLEXPD
     C   41
     COR 42              DELETE    GPMLEXD0
     C  N41
     CANN42              EXCEPT    UPDMLEX
     C                   ENDIF
 
     C     GPMLEXKey     READE     GPMLEXD0                               99
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
     C     RPT_CGRP_TransBEGSR
 
     C                   Z-ADD     1             #C
     C     CUSTRArr(#C)  DOWNE     *BLANK
 
     C                   EVAL      Customer= CUSTRArr(#C)
     C                   MOVE      *BLANK        CUBRCD
     C                   MOVE      *BLANK        CUCUST
     C     GPCUSTXKey    CHAIN     GPCUSTXD0                          99
 
      * Exposure
 
     C     GPMLEXKey     SETLL     GPMLEXD0
     C     GPMLEXKey     READE     GPMLEXD0                               99
     C     *IN99         DOWEQ     *OFF
 
      * If instrument on limit
 
     C                   IF        MEINST = Instrument
     C                             AND MEBRCA = LIENTYCODE
     C                   EXSR      INCL_EXP
 
     C                   MOVE      *BLANK        TREF             40
     C                   IF        MESNAM <> *BLANK
     C                   MOVEL     MESNAM        TREF
     C                   ELSE
     C                   MOVEL     METREF        TREF
     C                   ENDIF
 
     C                   Z-ADD     1             CHLINE            2 0
     C                   EXSR      PAG
     C  N40
     CANN41
     CANN42              EXCEPT    TRNEXP
     C  N40
     CANN41
     CANN42              ADD       MEEXPINUSD    TOEXPOSURE
     C  N40
     CANN41
     CANN42              DO
     C                   Z-ADD     1             #CT
     C     MECNCD_GLCAT  LOOKUP    CTRY(#CT)                              99
     C  N99*BLANK        LOOKUP    CTRY(#CT)                              99
     C                   MOVEL     MECNCD_GLCAT  CTRY(#CT)
     C                   ADD       MEEXPINUSD    CTRYTOT(#CT)
     C                   ENDDO
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
 
      * TENOR DETAILS
 
     C                   MOVE      TFROM         MEFROM
     C                   MOVE      TTO           METO
 
     C                   SETOFF                                       404142
      * TENOR EXCEEDED
     C     MEEDAT        IFGT      W_CDAT
     C                   SETON                                        40
     C                   MOVE      'Y'           METENX
     C                   ENDIF
      * MATURED
     C     MEEDAT        IFLE      PRUN
     C     MEEDAT        ANDNE     0
     C**??               SETON                                        41
     C                   ENDIF
      * LIMIT ID
     C                   IF        I#CUPA = 'C'
     C                   EVAL      MELIMDEFC  = 'Y'
     C                   EVAL      MELIMITIDC= LILIMITID
     C                   EVAL      MEUTSRCODC= LIUTSRCODE
     C                   ELSE
     C                   EVAL      MELIMDEFP  = 'Y'
     C                   EVAL      MELIMITIDP= LILIMITID
     C                   EVAL      MEUTSRCODP= LIUTSRCODE
     C                   ENDIF
 
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
     C     *DTAARA       DEFINE                  JNSTAT
     C     *ENTRY        PLIST
     C                   PARM                    I#CUPA            1
 
     C                   READ      GZSDBANKPD                             H1
 
     C                   Z-ADD     99            LINENO            3 0
     C                   Z-ADD     0             PAGNUM            5 0
     C                   EXSR      PAG
 
      * LOAD INSTRUMENT GROUPS
 
     C                   Z-ADD     0             #I                4 0
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
 
     C                   Z-ADD     0             #I                4 0
     C                   READ      T_GRCUSTLF                             99
     C     *IN99         DOWEQ     *OFF
     C                   IF        CLLEVEL = 1
     C                   ADD       1             #I
     C                   EVAL      CUGRPID(#I) = CLGRPID
     C                   EVAL      CGID        = CLGRPID
     C     CGID          CHAIN     T_GRCUSTGF                         99
     C                   MOVEL     CGNAME        CUGRPNM(#I)
     C                   MOVE      *BLANK        CUSTRArr
     C                   Z-ADD     0             #C                4 0
     C                   ENDIF
     C                   IF        CLLEVEL = 2
     C                   ADD       1             #C
     C                   EVAL      CUSTRArr(#C) = CLCUSTCODE
     C                   MOVEA     CUSTRArr      CUSTR(#I)
     C                   ENDIF
     C                   READ      T_GRCUSTLF                             99
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
     OQSYSPRT   E            PAGEHEAD        001002
     O                                           14 'REF. GPEXTMLXP'
     O                                           80 'COUNTERPARTY LIMIT V. EXPO+
     O                                              SURE REPORT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                           10 'CUSTOMER'
     O                                           21 'TRANS.REF'
     O                                           70 'EXPOSURE'
     O                                           80 'MAT DAT'
     O                                          101 'INSTRUMENT'
     O                                          120 'NOMINAL'
     O          E            LIMIT       1
     O                                           26 '--------------------------'
     O                                           52 '--------------------------'
     O                                           78 '--------------------------'
     O                                          104 '--------------------------'
     O                                          130 '--------------------------'
     O          E            LIMIT       1
     O                       LIUTSRCODE          10
     O                       CUCRNM              31
     O                       LIEXPDATE           42
     O                       EXPOSURE            70 '   ,   ,   ,   , 0 .  '
     O                       Instrument         101
     O                                          110 'TENOR:'
     O                       TFROM              125
     O                       TTO                132
     O                                          120 '-'
     O                       LIREPORT           130
     O          E            TRNEXP      1
     O                       MEEXPINUSD          71 '   ,   ,   ,   , 0 .  -'
     O                       TREF                51
     O                       MEREDAT             80
     O                       MESMOD              90
     O                       MEID          Z    130
     O                       MENOMINAL          120 '  ,   ,   ,   , 0 .   '
     O                       MENOMCCY           124
     O                       MEINST             101
     O          E            TOTAL       1
     O                                           48 'EXPOSURE->'
     O                       TOEXPOSURE          70 '   ,   ,   ,   , 0 .  '
     O                     50                    86 '?? - Difference'
     O          E            TOTAL       1
     O                                           48 'LIMIT---->'
     O                       CPLIMIT             70 '   ,   ,   ,   , 0 .  '
     O          E            ENDRPT      1
     O                                           70 '*END OF REPORT*'
     O                       Count_LIMINV       125 '   0 '
     O                       Count_LIM          130 '   0 '
     OGPMLEXD0  E            UPDMLEX
     O                       MEFROM
     O                       METO
     O                       METENX
     O                       MELIMDEFC
     O                       MELIMITIDC
     O                       MEUTSRCODC
     O                       MELIMDEFP
     O                       MELIMITIDP
     O                       MEUTSRCODP
