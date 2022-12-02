      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001425)                              *
      *                                                               *
      *  GLH00408 - Midas GL Retrieve Postings by Network Account     *
      *                                                               *
      *  Last Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
      ** If GA posting has related ZS (sweep) posting, fill MT940 tag 61        UUC103
      ** and 86 data                                                            UUC103
      ** from that posting.                                                     UUC103
                                                                                UUC103
b1   C                   If        UUC103 = 'Y'                                 UUC103
                                                                                UUC103
b2   C                   If        AGZSXR <> 0                                  UUC103
     C                   EVAL      SWPXRFN = AGZSXR                             UUC103
     C     KeySWPZS      Chain     GLAPSZSL0                          29        UUC103
b3   C                   If        *IN29 = *Off                                 UUC103
     C                   EVAL      MGZ616 = AZF616                              UUC103
     C                   EVAL      MGZ617 = AZF617                              UUC103
     C                   EVAL      MGZ618 = AZF618                              UUC103
     C                   EVAL      MGZ619 = AZF619                              UUC103
     C                   EVAL      MGZ861 = AZF861                              UUC103
     C                   EVAL      MGZ862 = AZF862                              UUC103
     C                   EVAL      MGZ863 = AZF863                              UUC103
     C                   EVAL      MGZ865 = AZF864                              UUC103
     C                   EVAL      MGZ865 = AZF865                              UUC103
     C                   EVAL      MGZ866 = AZF866                              UUC103
e3   C                   Endif                                                  UUC103
e2   C                   Endif                                                  UUC103
e1   C                   Endif                                                  UUC103
                                                                                UUC103
