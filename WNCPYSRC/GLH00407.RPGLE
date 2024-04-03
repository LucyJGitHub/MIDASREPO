      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001425)                              *
      *                                                               *
      *  GLH00407 - Midas GL Retrieve Postings by Network Account     *
      *                                                               *
      *  Last Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
      *========================================================================*UUC103
      * ACTION    : Fill in extended narrative                                 *UUC103
      *------------------------------------------------------------------------*UUC103
                                                                                UUC103
     C     ACTION        BEGSR                                                  UUC103
      *    ----------    -----                                                  UUC103
     C*                                                                         UUC103
     C* Set up field 86                                                         UUC103
     C*                                                                         UUC103
     C                   IF        TOTL < 7                                     UUC103
     C                   MOVEL     ZAEXRF        WFLD              1            UUC103
     C                   IF        WFLD = '-'                                   UUC103
     C                             OR WFLD = ':'                                UUC103
     C                   MOVE      ZAEXRF        WAEXRF           34            UUC103
     C                   MOVE      *BLANKS       ZAEXRF                         UUC103
     C                   MOVE      WAEXRF        ZAEXRF                         UUC103
     C                   END                                                    UUC103
     C                   IF        ZAEXRF <> *BLANKS                            UUC103
     C                   EXSR      FLD86                                        UUC103
     C                   ADD       1             TOTL                           UUC103
     C                   END                                                    UUC103
     C                   END                                                    UUC103
                                                                                UUC103
     C                   ENDSR                                                  UUC103
      *========================================================================*UUC103
      * FLD86     : Fill field 86                                              *UUC103
      *------------------------------------------------------------------------*UUC103
     C     FLD86         BEGSR                                                  UUC103
      *    ------        -----                                                  UUC103
                                                                                UUC103
     C                   IF        TOTL = 1                                     UUC103
     C                   EVAL      MGADI1 = ZAEXRF                              UUC103
     C                   END                                                    UUC103
     C                   IF        TOTL = 2                                     UUC103
     C                   EVAL      MGADI2 = ZAEXRF                              UUC103
     C                   END                                                    UUC103
     C                   IF        TOTL = 3                                     UUC103
     C                   EVAL      MGADI3 = ZAEXRF                              UUC103
     C                   END                                                    UUC103
     C                   IF        TOTL = 4                                     UUC103
     C                   EVAL      MGADI4 = ZAEXRF                              UUC103
     C                   END                                                    UUC103
     C                   IF        TOTL = 5                                     UUC103
     C                   EVAL      MGADI5 = ZAEXRF                              UUC103
     C                   END                                                    UUC103
     C                   IF        TOTL = 6                                     UUC103
     C                   EVAL      MGADI6 = ZAEXRF                              UUC103
     C                   END                                                    UUC103
     C*                                                                         UUC103
     C                   ENDSR                                                  UUC103
