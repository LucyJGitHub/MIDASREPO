     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Extract ML Country Exposure')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPEXTMLXC - Extract ML Country Exposure                      *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI103B            Date 26Oct19               *
      *  Prev Amend No. DAI103             Date 25Jun19               *
      *                 NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI103B - ML Reporting to include Nostros & Forward FX       *
      *  DAI103 - Upgraded MPlus 121 NADC01 ML Extracts to FB 2.1     *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************
 
     FT_MLLIMIT IP   E             DISK    rename(T_MLLIMIT:T_MLLIMF)
     FGZSDBANKPDIF   E             DISK
     FT_GRINSTL IF   E           K DISK    rename(T_GRINSTL:T_GRINSTLF)
     FGPMLEXL0  UF   E           K DISK    PREFIX(S_)
     FGPMLXPPD  UF   E           K DISK    PREFIX(S_)
     FGPCTRYL0  IF   E           K DISK
     FGPMLXCPD  O    E           K DISK
     FQSYSPRT   O    F  132        PRINTER
 
     D INGRPID         S              5  0 DIM(99)
     D INSTR           S             10    DIM(99)
 
     D TOCPEXP_C       S             17  2 DIM(4)
     D TOCPINEXP_C     S             17  2 DIM(4)
     D TOINSTEXP_C     S             17  2 DIM(4)
 
     D TOPEXP_C        S             15  0 DIM(4)
     D TOPIEXP_C       S             15  0 DIM(4)
     D TOIEXP_C        S             15  0 DIM(4)
 
     C                   IF        LIUTSRTYPE = 3
     C                             AND LISTATUS <> 'E'
     C                   EXSR      RPT_LIMIT
     C                   ENDIF
 
     CLR                 Z-ADD     1             CHLINE
     CLR                 EXSR      PAG
     CLR                 EXCEPT    ENDRPT
      *****************************************************************
     C     RPT_LIMIT     BEGSR
 
      * COUNTRY
     C                   MOVEL     LIUTSRCODE    Country           2
 
      * INSTRUMENT
     C                   Z-ADD     LIINSTGRP     InstGroup         5 0
     C                   Z-ADD     1             #I
     C     InstGroup     LOOKUP    INGRPID(#I)                            99
     C                   MOVEL     INSTR(#I)     Instrument       10
                                                                                             DAI103B
      * Spot FX uses settlement limit. Forward FX uses credit limit                          DAI103B
                                                                                             DAI103B
     C                   IF        (Instrument = 'GLOBFX' and LITYPE <> 'S') OR              DAI103B
     C                             (Instrument = 'GLOBFW' and LITYPE <> 'C')                 DAI103B
     C                   GOTO      BYPASS                                                    DAI103B
     C                   ENDIF                                                               DAI103B
 
      * Total Cpty Exposure in USD
      * Total Cpty Inst Exp in USD
      * Total Instrument Exposure in USD
      * Country Exposure in USD
 
     C                   Z-ADD     0             TOCPEXP          17 2
     C                   Z-ADD     0             TOCPINEXP        17 2
     C                   Z-ADD     0             TOINSTEXP        17 2
     C                   Z-ADD     0             TOCPEXP_C
     C                   Z-ADD     0             TOCPINEXP_C
     C                   Z-ADD     0             TOINSTEXP_C
     C                   Z-ADD(H)  LIEXPOSURE    EXPOSURE         17 2
 
      * Total counterparty and instrument exposures
 
     C                   EXSR      TOT_Exp
 
      * Total Cpty Exposure in USD
      * Total Cpty Inst Exp in USD
      * Total Instrument Exposure in USD
      * Country Exposure in USD
 
     C                   Z-ADD(H)  TOCPEXP       TOPEXP           15 0
     C                   Z-ADD(H)  TOCPINEXP     TOPIEXP          15 0
     C                   Z-ADD(H)  TOINSTEXP     TOIEXP           15 0
     C                   Z-ADD(H)  TOCPEXP_C     TOPEXP_C
     C                   Z-ADD(H)  TOCPINEXP_C   TOPIEXP_C
     C                   Z-ADD(H)  TOINSTEXP_C   TOIEXP_C
     C                   Z-ADD(H)  EXPOSURE      EXP              15 0
      * Country Limit
     C                   Z-ADD     LIAMT         CTLIMIT          15 0
 
      * Compare country exposure v. total instrument exposure
 
     C     EXP           COMP      TOPIEXP                            5050
     C                   Z-ADD     1             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    TOTAL
 
      * Limit Defined
     C                   MOVE      'Y'           MELIMDEF
      * Limit ID
     C                   Z-ADD     LILIMITID     MELIMITID
      * Utilisor Type
      * Utilisor Code
     C                   Z-ADD     LIUTSRTYPE    MEUTSRTYPE
     C                   MOVEL     LIUTSRCODE    MEUTSRCODE
      * Booking Branch
     C                   MOVEL     LIENTYCODE    MEBRCA
      * Country
     C                   MOVEL     Country       MECNCD
     C                   MOVEL     *BLANK        A4CNNM
     C     MECNCD        CHAIN     GPCTRYD0                           99
     C                   EVAL      MECNCDNAM = MECNCD + ' ' + A4CNNM
      * Global Instrument Code
     C                   MOVEL     Instrument    MEINST
      * GL Category
     C                   MOVEL     '1 ON '       MEGLCAT
      * Total Cpty Exposure in USD
      * Total Cpty Inst Exp in USD
     C                   Z-ADD     TOPEXP_C(1)   METPEXUSD
     C                   Z-ADD     TOPIEXP_C(1)  METPIXUSD
      * Total Instrument Exposure in USD
     C                   Z-ADD     TOIEXP_C(1)   METIEXUSD
      * Country Exposure in USD
     C                   IF        TOPIEXP_C(1) <> 0
     C                   IF        TOPIEXP <> 0  AND TOPIEXP_C(1) <> TOPIEXP
     C     EXP           MULT      TOPIEXP_C(1)  WRK300           30 0
     C     WRK300        DIV(H)    TOPIEXP       MECEXPUSD
     C                   ELSE
     C                   Z-ADD     EXP           MECEXPUSD
     C                   Z-ADD     0             EXP
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             MECEXPUSD
     C                   ENDIF
      * Total Diff in USD
     C                   EXSR      CALC_DIFS
      * Country Limit in USD
     C                   Z-ADD     CTLIMIT       MELIMTUSD
      * Limit Expiry Date
     C                   MOVE      LIEXPDATE     MEEXPDATE
     C                   WRITE     GPMLXCD0
     C                   Z-ADD     0             MELIMTUSD
 
      * GL Category
     C                   MOVEL     '2 OFF'       MEGLCAT
      * Total Cpty Exposure in USD
      * Total Cpty Inst Exp in USD
     C                   Z-ADD     TOPEXP_C(2)   METPEXUSD
     C                   Z-ADD     TOPIEXP_C(2)  METPIXUSD
      * Total Instrument Exposure in USD
     C                   Z-ADD     TOIEXP_C(2)   METIEXUSD
      * Country Exposure in USD
     C                   IF        TOPIEXP_C(2) <> 0
     C                   IF        TOPIEXP <> 0  AND TOPIEXP_C(2) <> TOPIEXP
     C     EXP           MULT      TOPIEXP_C(2)  WRK300
     C     WRK300        DIV(H)    TOPIEXP       MECEXPUSD
     C                   ELSE
     C                   Z-ADD     EXP           MECEXPUSD
     C                   Z-ADD     0             EXP
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             MECEXPUSD
     C                   ENDIF
      * Total Diff in USD
     C                   EXSR      CALC_DIFS
     C                   IF        TOPEXP_C(2) <> 0 OR TOPIEXP_C(2) <> 0
     C                             OR TOIEXP_C(2) <> 0
     C                   WRITE     GPMLXCD0
     C                   ENDIF
      * GL Category
     C                   MOVEL     '3 MEM'       MEGLCAT
      * Total Cpty Exposure in USD
      * Total Cpty Inst Exp in USD
     C                   Z-ADD     TOPEXP_C(3)   METPEXUSD
     C                   Z-ADD     TOPIEXP_C(3)  METPIXUSD
      * Total Instrument Exposure in USD
     C                   Z-ADD     TOIEXP_C(3)   METIEXUSD
      * Country Exposure in USD
     C                   IF        TOPIEXP_C(3) <> 0
     C                   IF        TOPIEXP <> 0  AND TOPIEXP_C(3) <> TOPIEXP
     C     EXP           MULT      TOPIEXP_C(3)  WRK300
     C     WRK300        DIV(H)    TOPIEXP       MECEXPUSD
     C                   ELSE
     C                   Z-ADD     EXP           MECEXPUSD
     C                   Z-ADD     0             EXP
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             MECEXPUSD
     C                   ENDIF
      * Total Diff in USD
     C                   EXSR      CALC_DIFS
     C                   IF        TOPEXP_C(3) <> 0 OR TOPIEXP_C(3) <> 0
     C                             OR TOIEXP_C(3) <> 0
     C                   WRITE     GPMLXCD0
     C                   ENDIF
      * GL Category
     C                   MOVEL     '4 FWD'       MEGLCAT
      * Total Cpty Exposure in USD
      * Total Cpty Inst Exp in USD
     C                   Z-ADD     TOPEXP_C(4)   METPEXUSD
     C                   Z-ADD     TOPIEXP_C(4)  METPIXUSD
      * Total Instrument Exposure in USD
     C                   Z-ADD     TOIEXP_C(4)   METIEXUSD
      * Country Exposure in USD
     C                   IF        TOPIEXP_C(4) <> 0
     C                   IF        TOPIEXP <> 0  AND TOPIEXP_C(4) <> TOPIEXP
     C     EXP           MULT      TOPIEXP_C(4)  WRK300
     C     WRK300        DIV(H)    TOPIEXP       MECEXPUSD
     C                   ELSE
     C                   Z-ADD     EXP           MECEXPUSD
     C                   Z-ADD     0             EXP
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     0             MECEXPUSD
     C                   ENDIF
      * Total Diff in USD
     C                   EXSR      CALC_DIFS
     C                   IF        TOPEXP_C(4) <> 0 OR TOPIEXP_C(4) <> 0
     C                             OR TOIEXP_C(4) <> 0
     C                   WRITE     GPMLXCD0
     C                   ENDIF
      *
     C     BYPASS        ENDSR                                                               DAI103B
     C*********          ENDSR                                                               DAI103B
      *****************************************************************
     C     CALC_DIFS     BEGSR
     C     MECEXPUSD     SUB       METPEXUSD     METDI1USD
     C     MECEXPUSD     SUB       METPIXUSD     METDI2USD
     C     MECEXPUSD     SUB       METIEXUSD     METDI3USD
     C                   ENDSR
      *****************************************************************
     C     TOT_Exp       BEGSR
     C     GPMLXPKey     KLIST
     C                   KFLD                    Country
     C                   KFLD                    Instrument
 
      * Counterparty Exposure Summary
 
     C     GPMLXPKey     SETLL     GPMLXPD0
     C     GPMLXPKey     READE     GPMLXPD0                               99
     C     *IN99         DOWEQ     *OFF
 
     C                   IF        S_MEBRCA = LIENTYCODE
     C                   ADD       S_METIEXUSD   TOCPINEXP
     C                   ADD       S_MEPEXPUSD   TOCPEXP
     C                   IF        S_MEGLCAT = '1 ON '
     C                   ADD       S_METIEXUSD   TOCPINEXP_C(1)
     C                   ADD       S_MEPEXPUSD   TOCPEXP_C(1)
     C                   ELSE
     C                   IF        S_MEGLCAT = '2 OFF'
     C                   ADD       S_METIEXUSD   TOCPINEXP_C(2)
     C                   ADD       S_MEPEXPUSD   TOCPEXP_C(2)
     C                   ELSE
     C                   IF        S_MEGLCAT = '3 MEM'
     C                   ADD       S_METIEXUSD   TOCPINEXP_C(3)
     C                   ADD       S_MEPEXPUSD   TOCPEXP_C(3)
     C                   ELSE
     C                   ADD       S_METIEXUSD   TOCPINEXP_C(4)
     C                   ADD       S_MEPEXPUSD   TOCPEXP_C(4)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      'Y'           S_MELIMDEFX
     C                   ENDIF
     C                   EXCEPT    UPDMLXP
 
     C     GPMLXPKey     READE     GPMLXPD0                               99
     C                   ENDDO
 
      * Transaction (Instrument) Exposure
 
     C     GPMLXPKey     SETLL     GPMLEXD0
     C     GPMLXPKey     READE     GPMLEXD0                               99
     C     *IN99         DOWEQ     *OFF
 
     C                   IF        S_MEBRCA = LIENTYCODE
     C                   ADD       S_MEEXPINUSD  TOINSTEXP
     C                   IF        S_MEGLCAT = '1 ON '
     C                   ADD       S_MEEXPINUSD  TOINSTEXP_C(1)
     C                   ELSE
     C                   IF        S_MEGLCAT = '2 OFF'
     C                   ADD       S_MEEXPINUSD  TOINSTEXP_C(2)
     C                   ELSE
     C                   IF        S_MEGLCAT = '3 MEM'
     C                   ADD       S_MEEXPINUSD  TOINSTEXP_C(3)
     C                   ELSE
     C                   ADD       S_MEEXPINUSD  TOINSTEXP_C(4)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      'Y'           S_MELIMDEFX
     C                   ENDIF
     C                   EXCEPT    UPDMLEX
 
     C     GPMLXPKey     READE     GPMLEXD0                               99
     C                   ENDDO
 
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
     C     *INZSR        BEGSR
 
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
 
     C                   ENDSR
      *****************************************************************
     OQSYSPRT   E            PAGEHEAD        001002
     O                                           14 'REF. GPEXTMLXC'
     O                                           80 'COUNTRY LIMIT V. EXPOSURE +
     O                                              REPORT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                            7 'COUNTRY'
     O                                           20 'INSTRUMENT'
     O                                           70 'COUNTRY EXPOSURE'
     O                                          100 'INSTRUMENT EXPOSURE'
     O          E            TOTAL       1
     O                       Country              5
     O                       Instrument          20
     O                       EXPOSURE            70 '   ,   ,   ,   , 0 .  '
     O                       TOINSTEXP          100 '   ,   ,   ,   , 0 .  '
     O                     50                   116 '?? - Difference'
     O          E            ENDRPT      1
     O                                           70 '*END OF REPORT*'
     OGPMLEXD0  E            UPDMLEX
     O                       S_MELIMDEFX
     OGPMLXPD0  E            UPDMLXP
     O                       S_MELIMDEFX
