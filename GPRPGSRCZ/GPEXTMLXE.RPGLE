     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Extract ML Country Exposure (No CP Limit)')   *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPEXTMLXE - Extract ML Country Exposure (No CP Limit)        *
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
 
     FGPMLXPPD  IP   E           K DISK
     FGZSDBANKPDIF   E             DISK
     FQSYSPRT   O    F  132        PRINTER
     FGPCTRYL0  IF   E           K DISK
     FGPMLXCPD  O    E             DISK
 
     IGPMLXPD0
     I                                          MECNCD        L1
     I                                          MEINST        L1
     I                                          MEGLCAT       L1
 
     C   L1              Z-ADD     0             TOCPEXP          17 2
     C   L1              Z-ADD     0             TOCPINEXP        17 2
 
     C                   IF            MELIMDEFX <> 'Y'
     C                                 AND MEUTSRTYPE = 1
     C                   EXSR      EXT_LIMIT
     C                   ENDIF
 
     CL1                 IF        TOCPEXP <> 0 OR TOCPINEXP <> 0
     CL1                 MOVE      'N'           MELIMDEF
     CL1                 Z-ADD     0             MELIMITID
     CL1                 Z-ADD     3             MEUTSRTYPE
     CL1                 MOVEL     *BLANK        MEUTSRCODE
     CL1                 MOVEL     MECNCD        MEUTSRCODE
     CL1                 MOVEL     MEBRCA        MEBRCA
     CL1                 MOVEL     MECNCD        MECNCD
     CL1                 MOVEL     *BLANK        A4CNNM
     CL1   MECNCD        CHAIN     GPCTRYD0                           99
     CL1                 EVAL      MECNCDNAM = MECNCD + ' ' + A4CNNM
     CL1                 MOVEL     MEINST        MEINST
     CL1                 MOVEL     MEGLCAT       MEGLCAT
     CL1                 Z-ADD(H)  TOCPEXP       METPEXUSD
     CL1                 Z-ADD(H)  TOCPINEXP     METPIXUSD
     CL1                 Z-ADD     0             METIEXUSD
     CL1                 Z-ADD(H)  TOCPINEXP     MECEXPUSD
     CL1   MECEXPUSD     SUB       METPEXUSD     METDI1USD
     CL1   MECEXPUSD     SUB       METPIXUSD     METDI2USD
     CL1   MECEXPUSD     SUB       METIEXUSD     METDI3USD
     CL1                 Z-ADD     0             MELIMTUSD
     CL1                 MOVE      *BLANK        MEEXPDATE
     CL1                 WRITE     GPMLXCD0
     CL1                 ADD       1             NORECS            5 0
     CL1                 ENDIF
 
     CLR                 Z-ADD     4             CHLINE            2 0
     CLR                 EXSR      PAG
     CLR                 EXCEPT    ENDRPT
      *****************************************************************
     C     EXT_LIMIT     BEGSR
 
     C                   ADD       METIEXUSD     TOCPINEXP
     C                   ADD       MEPEXPUSD     TOCPEXP
 
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
     O                                           14 'REF. GPEXTMLXE'
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
