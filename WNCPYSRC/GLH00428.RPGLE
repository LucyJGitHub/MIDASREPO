      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001432)                              *
      *                                                               *
      *  GLH00428 - Midas GL Format Posting details                   *
      *                                                               *
      *  Last Amend No. MD058751        Date 03Sep21                  *
      *  Prev Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058751 - Missing tag :86: on MT940s as not extracted by    *
      *             CAR UUC103. Alphanumeric batch numbers not        *
      *             checked correctly.                                *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
      *========================================================================*UUC103
      * $EXTNARR  : Retrieve Extended Narrative for subfield 8                 *UUC103
      *------------------------------------------------------------------------*UUC103
                                                                                UUC103
     C     EXTNARR       BEGSR                                                  UUC103
     C                   MOVEL     BTNB          NUM1              4 0          UUC103
     C                   MOVEL     BINB          NUM2              4 0          UUC103
     C                   MOVEL     NUM1          ALP1              3            UUC103
     C                   MOVEL     NUM2          ALP2              3            UUC103
                                                                                UUC103
     C                   IF        BTNB = ALP1                                  UUC103
     C                             AND BINN = ALP2                              UUC103
     C                             OR BINN = ALP2                                           MD058751
     C     KBTBI         SETLL     GLJENAP0                                     UUC103
     C     KBTBI         READE     GLJENAP0                               89    UUC103
                                                                                UUC103
     C                   DOW       *IN89 = '0'                                  UUC103
     C                   IF        ZAEXTP = '99'                                UUC103
     C                             and ZAEXSQ = 01                              UUC103
     C                   EVAL      MGSFD8 = '//' + ZAEXRF                       UUC103
     C                   ENDIF                                                  UUC103
     C     KBTBI         READE     GLJENAP0                               89    UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
     C                   ENDSR                                                  UUC103
