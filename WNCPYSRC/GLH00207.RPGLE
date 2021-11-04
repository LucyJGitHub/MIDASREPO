      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001432)                              *
      *                                                               *
      *  GLH00207 - Midas GL Format Posting details                   *
      *                                                               *
      *  Last Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
      *                                                                         UUC103
     C     UUC103        IFEQ      'Y'                                          UUC103
      *                                                                         UUC103
      ** Leading '-' or ':' not accepted by Swift: replace by '.'               UUC103
      *                                                                         UUC103
     C     MGADI1        IFNE      *BLANKS                                      UUC103
     C                   MOVEL     MGADI1        CHAR1             1            UUC103
     C     CHAR1         IFEQ      '-'                                          UUC103
     C     CHAR1         OREQ      ':'                                          UUC103
     C     CHAR1         OREQ      ' '                                          UUC103
     C     CHAR1         OREQ      '~'                                          UUC103
     C     CHAR1         OREQ      'ò'                                          UUC103
     C     CHAR1         OREQ      '_'                                          UUC103
     C                   MOVEL     '.'           MGADI1                         UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
     C     MGADI2        IFNE      *BLANKS                                      UUC103
     C                   MOVEL     MGADI2        CHAR1                          UUC103
     C     CHAR1         IFEQ      '-'                                          UUC103
     C     CHAR1         OREQ      ':'                                          UUC103
     C     CHAR1         OREQ      ' '                                          UUC103
     C     CHAR1         OREQ      '~'                                          UUC103
     C     CHAR1         OREQ      'ò'                                          UUC103
     C     CHAR1         OREQ      '_'                                          UUC103
     C                   MOVEL     '.'           MGADI2                         UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
     C     MGADI3        IFNE      *BLANKS                                      UUC103
     C                   MOVEL     MGADI3        CHAR1                          UUC103
     C     CHAR1         IFEQ      '-'                                          UUC103
     C     CHAR1         OREQ      ':'                                          UUC103
     C     CHAR1         OREQ      ' '                                          UUC103
     C     CHAR1         OREQ      '~'                                          UUC103
     C     CHAR1         OREQ      'ò'                                          UUC103
     C     CHAR1         OREQ      '_'                                          UUC103
     C                   MOVEL     '.'           MGADI3                         UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
     C     MGADI4        IFNE      *BLANKS                                      UUC103
     C                   MOVEL     MGADI4        CHAR1                          UUC103
     C     CHAR1         IFEQ      '-'                                          UUC103
     C     CHAR1         OREQ      ':'                                          UUC103
     C     CHAR1         OREQ      ' '                                          UUC103
     C     CHAR1         OREQ      '~'                                          UUC103
     C     CHAR1         OREQ      'ò'                                          UUC103
     C     CHAR1         OREQ      '_'                                          UUC103
     C                   MOVEL     '.'           MGADI4                         UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
     C     MGADI5        IFNE      *BLANKS                                      UUC103
     C                   MOVEL     MGADI5        CHAR1                          UUC103
     C     CHAR1         IFEQ      '-'                                          UUC103
     C     CHAR1         OREQ      ':'                                          UUC103
     C     CHAR1         OREQ      ' '                                          UUC103
     C     CHAR1         OREQ      '~'                                          UUC103
     C     CHAR1         OREQ      'ò'                                          UUC103
     C     CHAR1         OREQ      '_'                                          UUC103
     C                   MOVEL     '.'           MGADI5                         UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
     C     MGADI6        IFNE      *BLANKS                                      UUC103
     C                   MOVEL     MGADI6        CHAR1                          UUC103
     C     CHAR1         IFEQ      '-'                                          UUC103
     C     CHAR1         OREQ      ':'                                          UUC103
     C     CHAR1         OREQ      ' '                                          UUC103
     C     CHAR1         OREQ      '~'                                          UUC103
     C     CHAR1         OREQ      'ò'                                          UUC103
     C     CHAR1         OREQ      '_'                                          UUC103
     C                   MOVEL     '.'           MGADI6                         UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
      *                                                                         UUC103
     C                   END                                                    UUC103
      *                                                                         UUC103
