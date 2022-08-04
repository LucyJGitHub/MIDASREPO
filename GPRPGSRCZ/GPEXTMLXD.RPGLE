     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Extract ML Country Exposure (No IN Limit)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPEXTMLXD - Extract ML Country Exposure (No IN limit)        *
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
 
     FGPMLEXPD  IP   E           K DISK
     FGZSDBANKPDIF   E             DISK
     FQSYSPRT   O    F  132        PRINTER
     FGPCTRYL0  IF   E           K DISK
     FGPMLXCPD  O    E             DISK
 
     D CTRY            S              2    DIM(99)
     D CTRYTOT         S             17  2 DIM(99)
 
     IGPMLEXD0
     I                                          MEINST        L1
     I                                          MEGLCAT       L1
 
     C   L1              Z-ADD     1             #CT               2 0
     C   L1              MOVEL     *BLANK        CTRY
     C   L1              Z-ADD     *ZERO         CTRYTOT
 
     C                   IF            MELIMDEFX <> 'Y'
     C                   EXSR      EXT_LIMIT
     C                   ENDIF
 
     CL1                 Z-ADD     1             #CT
     CL1   CTRY(#CT)     DOWNE     *BLANK
     CL1                 IF        CTRYTOT(#CT) <> 0
     CL1                 MOVE      'N'           MELIMDEF
     CL1                 Z-ADD     0             MELIMITID
     CL1                 Z-ADD     3             MEUTSRTYPE
     CL1                 MOVEL     CTRY(#CT)     MEUTSRCODE
     CL1                 MOVEL     MEBRCA        MEBRCA
     CL1                 MOVEL     CTRY(#CT)     MECNCD
     CL1                 MOVEL     *BLANK        A4CNNM
     CL1   MECNCD        CHAIN     GPCTRYD0                           99
     CL1                 EVAL      MECNCDNAM = MECNCD + ' ' + A4CNNM
     CL1                 MOVEL     MEINST        MEINST
     CL1                 MOVEL     MEGLCAT       MEGLCAT
     CL1                 Z-ADD     0             METPEXUSD
     CL1                 Z-ADD     0             METPIXUSD
     CL1                 Z-ADD(H)  CTRYTOT(#CT)  METIEXUSD
     CL1                 Z-ADD     0             MECEXPUSD
     CL1   MECEXPUSD     SUB       METPEXUSD     METDI1USD
     CL1   MECEXPUSD     SUB       METPIXUSD     METDI2USD
     CL1   MECEXPUSD     SUB       METIEXUSD     METDI3USD
     CL1                 Z-ADD     0             MELIMTUSD
     CL1                 MOVE      *BLANK        MEEXPDATE
     CL1                 WRITE     GPMLXCD0
     CL1                 ADD       1             NORECS            5 0
     CL1                 ENDIF
     CL1                 ADD       1             #CT
     CL1                 ENDDO
 
     CLR                 Z-ADD     4             CHLINE            2 0
     CLR                 EXSR      PAG
     CLR                 EXCEPT    ENDRPT
      *****************************************************************
     C     EXT_LIMIT     BEGSR
 
     C                   Z-ADD     1             #CT
     C     MECNCD        LOOKUP    CTRY(#CT)                              99
     C  N99*BLANK        LOOKUP    CTRY(#CT)                              99
     C                   MOVEL     MECNCD        CTRY(#CT)
     C                   ADD       MEEXPINUSD    CTRYTOT(#CT)
 
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
 
     C                   ENDSR
      *****************************************************************
     OQSYSPRT   E            PAGEHEAD        001002
     O                                           14 'REF. GPEXTMLXD'
     O                                           80 'COUNTRY LIMIT V. EXPOSURE +
     O                                              EXTRACT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            ENDRPT      3
     O                                           70 'NUMBER OF RECORDS:'
     O                       NORECS              75 '   0 '
     O          E            ENDRPT      1
     O                                           70 '*END OF REPORT*'
