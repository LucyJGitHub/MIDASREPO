     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GP Copy Spool Item to File')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Global Processing Module                             *
      *                                                               *
      *  GPCPYSPIT - Copy Spool Item to File                          *
      *                                                               *
      *  (c) Finastra Systems Technology, Inc. 2019                   *
      *                                                               *
      *  Last Amend No. DAI103             Date 25Jun19               *
      *  Prev Amend No. FRAIMP             Date 16Apr13               *
      *                 NADC02             Date 12Jun12               *
      *                 NADC01  *CREATE    Date 17Nov09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI103 - Upgraded MPlus 121 NADC01, NADC02 and FRAIMP ML     *
      *           Extracts to FB 2.1                                  *
      *  FRAIMP - ML Reporting to include FRA                         *
      *  NADC02 - ML REPORTING TO INCLUDE IRS                         *
      *  NADC01 - ML EXTRACTS FOR MIZUHO                              *
      *                                                               *
      *****************************************************************
     F*NADI******IP   F  352        DISK                                                      NADC02
     F*NAD*******O    F  352        DISK                                                      NADC02
     F*NADI****  IP   F  382        DISK                                               NADC02 FRAIMP
     F*NAD*****  O    F  382        DISK                                               NADC02 FRAIMP
     FNADI      IP   F  412        DISK                                                       FRAIMP
     FNAD       O    F  412        DISK                                                       FRAIMP
     INADI      NS  01
     I                                  1    3  JUMP
     I                                  4    4 0SPCB
     I**********************************5  352  TEXT                                          NADC02
     I*********                         5  382  TEXT                                   NADC02 FRAIMP
     I                                  5  412  TEXT                                          FRAIMP
 
     C                   SELECT
      *
     C     JUMP          WHENEQ    '062'
      *
     C     JUMP          WHENEQ    '001'
     C     LINCNT        DOWLT     62
     C                   ADD       1             LINCNT            2 0
     C                   EXCEPT    EMPTY
     C                   ENDDO
     C     LINCNT        IFGT      62
     C                   DUMP
     C                   ENDIF
     C   02              EXCEPT    EMPTY
     C                   Z-ADD     1             LINCNT
     C                   EXCEPT    LINE
     C                   SETON                                        02
      *
     C     SPCB          WHENNE    0
     C     SPCB          DOWGT     1
     C     LINCNT        ANDLT     62
     C                   SUB       1             SPCB
     C                   ADD       1             LINCNT
     C                   EXCEPT    EMPTY
     C                   ENDDO
     C                   IF        LINCNT < 62
     C                   ADD       1             LINCNT
     C                   EXCEPT    LINE
     C                   ENDIF
      *
     C                   OTHER
     C                   DUMP
     C                   ENDSL
     C     *INZSR        BEGSR
     C                   Z-ADD     62            LINCNT
     C                   ENDSR
     ONAD       E            EMPTY
     O                                            8 '        '
     O          E            LINE
     O***********************TEXT               352                                           NADC02
     O*********              TEXT               382                                    NADC02 FRAIMP
     O                       TEXT               412                                           FRAIMP
