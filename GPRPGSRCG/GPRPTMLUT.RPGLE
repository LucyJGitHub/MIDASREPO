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

     FGPMLEXPD  IP   E           K DISK
     FGZSDBANKPDIF   E             DISK
     FQSYSPRT   O    F  132        PRINTER


     C     *ENTRY        PLIST
     C                   PARM                    I#ZONE           10
     C                   IF        I#ZONE = 'PARIS ' and MEBRCA = 'PA1' or
     C                             I#ZONE = 'MOSCOW' and MEBRCA = 'MO1'
     C                   IF        METENX = 'Y'
     C                             OR MELIMTID = 0
     C                   EXSR      RPT_LIMIT
     C                   ENDIF
     C                   ENDIF

     CLR                 Z-ADD     1             CHLINE
     CLR                 EXSR      PAG
     CLR                 EXCEPT    ENDRPT
      *****************************************************************
     C     RPT_LIMIT     BEGSR

     C                   IF        METENX = 'Y'
     C                   MOVEL     'YES'         RTENX             3
     C                   ELSE
     C                   MOVEL     *BLANK        RTENX
     C                   ENDIF

     C                   IF        MELIMTID = 0
     C                   MOVEL     'YES'         RNOLI             3
     C                   ELSE
     C                   MOVEL     *BLANK        RNOLI
     C                   ENDIF

     C                   Z-ADD     1             CHLINE            2 0
     C                   EXSR      PAG
     C                   EXCEPT    TRNEXP

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
     C                   DOW       BJZONE <> I#ZONE
     C                   READ      GZSDBANKPD                             H1
     C                   ENDDO

     C                   Z-ADD     99            LINENO            3 0
     C                   Z-ADD     0             PAGNUM            5 0
     C                   EXSR      PAG

     C                   ENDSR
      *****************************************************************
     OQSYSPRT   E            PAGEHEAD        001002
     O                                           14 'REF. GPRPTMLUT'
     O                                           70 'UNCAPTURED TRANSACTIONS -
     O                                              REPORT -'
     O                       I#ZONE              81
     O                                          107 'DATE:'
     O                       BJMRDT             114
     O                                          120 'PAGE:'
     O                       PAGNUM             125 '   0 '
     O          E            PAGEHEAD    1
     O                                           10 'CUSTOMER'
     O                                           49 'TRANS.ID'
     O                                           59 'TRANS.REF'
     O                                           80 'EXPOSURE'
     O                                           90 'MAT DAT'
     O                                          102 'INSTRUMENT'
     O                                          120 'TENOR EXCEEDED'
     O                                          130 'NO LIMIT'
     O          E            TRNEXP      1
     O                       MECUSTNAME          28
     O                       METREF              71
     O                       MEID          Z     49
     O                       MEEXPINLMC          80 '   ,   ,   ,   , 0 .  '
     O                       MEREDAT             90
     O                       MESMOD             101
     O                       RTENX              115
     O                       RNOLI              128
     O          E            ENDRPT      1
     O                                           70 '*END OF REPORT*'
