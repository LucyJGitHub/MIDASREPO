     H DEBUG
     H ALWNULL(*INPUTONLY)
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Report ML Uncaptured Transactions')           *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPRPTMLUT - Report ML Uncaptured Transactions                *
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
     FGPMLXPPD  O    E             DISK
 
     D CTRY            S              2    DIM(10)
     D CTRYTOT         S             17  2 DIM(10)
 
     IGPMLEXD0
     I                                          MEINST        L1
     I                                          MEGLCAT       L1
     I                                          MEBRCA        L1
     I                                          MECBRC        L1
     I                                          MECUST        L1
 
     C   L1              Z-ADD     1             #CT               2 0
     C   L1              MOVEL     *BLANK        CTRY
     C   L1              Z-ADD     *ZERO         CTRYTOT
 
     C                   IF        I#CUPA = 'C'
     C                   IF        MELIMITIDC = 0
     C                   EXSR      RPT_LIMIT
     C                   ENDIF
     C                   ELSE
     C                   IF            MELIMITIDP = 0
     C                   EXSR      RPT_LIMIT
     C                   ENDIF
     C                   ENDIF
 
     CL1                 IF        I#CUPA = 'C'
     CL1                 Z-ADD     1             #CT
     CL1   CTRY(#CT)     DOWNE     *BLANK
     CL1                 IF        CTRYTOT(#CT) <> 0
     CL1                 MOVE      'N'           MELIMDEF
     CL1                 Z-ADD     0             MELIMITID
     CL1                 Z-ADD     1             MEUTSRTYPE
     CL1                 MOVEL     MEGCUST       MEUTSRCODE
     CL1                 MOVEL     MECUSTNAME    MECUSTNAME
     CL1                 MOVEL     MEBRCA        MEBRCA
     CL1                 MOVEL     CTRY(#CT)     MECNCD
     CL1                 MOVEL     *BLANK        A4CNNM
     CL1   MECNCD        CHAIN     GPCTRYD0                           99
     CL1                 EVAL      MECNCDNAM = MECNCD + ' ' + A4CNNM
     CL1                 MOVEL     MEINST        MEINST
     CL1                 MOVEL     MEGLCAT       MEGLCAT
     CL1                 Z-ADD(H)  CTRYTOT(#CT)  METIEXUSD
     CL1                 Z-ADD(H)  CTRYTOT(#CT)  MEPEXPUSD
     CL1   MEPEXPUSD     SUB       METIEXUSD     METDIFUSD
     CL1                 MOVE      'N'           MELIMDEFX
     CL1                 WRITE     GPMLXPD0
     CL1                 ENDIF
     CL1                 ADD       1             #CT
     CL1                 ENDDO
     CL1                 ENDIF
 
     CLR                 Z-ADD     1             CHLINE
     CLR                 EXSR      PAG
     CLR                 EXCEPT    ENDRPT
      *****************************************************************
     C     RPT_LIMIT     BEGSR
 
     C                   Z-ADD     MEID          RMEID             8 0
 
     C                   IF        METENX = 'Y'
     C                   MOVEL     'YES'         RTENX             3
     C                   ELSE
     C                   MOVEL     *BLANK        RTENX
     C                   ENDIF
 
     C                   IF        MELIMITIDC=0
     C                             AND MELIMITIDP=0
     C                   MOVEL     'YES'         RNOLI             3
     C                   ELSE
     C                   MOVEL     *BLANK        RNOLI
     C                   ENDIF
 
     C                   Z-ADD     1             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    TRNEXP
 
     C                   IF        I#CUPA = 'C'
     C                   Z-ADD     1             #CT
     C     MECNCD        LOOKUP    CTRY(#CT)                              99
     C  N99*BLANK        LOOKUP    CTRY(#CT)                              99
     C                   MOVEL     MECNCD        CTRY(#CT)
     C                   ADD       MEEXPINUSD    CTRYTOT(#CT)
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
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    I#CUPA            1
 
     C                   READ      GZSDBANKPD                             H1
 
     C                   Z-ADD     99            LINENO            3 0
     C                   Z-ADD     0             PAGNUM            5 0
     C                   EXSR      PAG
 
     C                   ENDSR
      *****************************************************************
     OQSYSPRT   E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMLUT'
     O                                           70 'UNCAPTURED TRANSACTIONS -
     O                                              REPORT'
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                           10 'CUSTOMER'
     O                                           38 'TRANS.REF'
     O                                           79 'TRANS.ID'
     O                                          100 'EXPOSURE'
     O                                          110 'MAT DAT'
     O                                          116 'INST'
     O                                          116 'BRCA'
     O                                          128 'NOLIM'
     O          E            TRNEXP      1
     O                       MECUSTNAME          28
     O                       MEEXPINUSD         100 '   ,   ,   ,   , 0 .  -'
     O                       MESNAM              79
     O                       RMEID         Z     79
     O                       MEREDAT            110
     O                       MESMOD             116
     O                       MEBRCA             121
     O                       RNOLI              127
     O          E            ENDRPT      1
     O                                           70 '*END OF REPORT*'
