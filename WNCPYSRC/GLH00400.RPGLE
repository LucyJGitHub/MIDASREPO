      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001416)                              *
      *                                                               *
      *  GLH00400 - Midas GL Retrieve Shadow Post. by Network Account *
      *                                                               *
      *  Last Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
                                                                                              UUC103
      ** If GA posting has related ZS (sweep) posting, fill MT940 tag 61 and 86 data          UUC103
      ** from that posting.                                                                   UUC103
                                                                                              UUC103
     C                   If        UUC103 = 'Y'                                               UUC103
      *                                                                                       UUC103
     C                   If        AGZSXR <> 0                                                UUC103
     C                   EVAL      SWPXRFN = AGZSXR                                           UUC103
     C     KeySWPZS      Chain     GLPSTZSL0                          29                      UUC103
     C                   If        *IN29 = *Off                                               UUC103
     C                   EVAL      GLMGZ616 = AZF616                                          UUC103
     C                   EVAL      GLMGZ617 = AZF617                                          UUC103
     C                   EVAL      GLMGZ618 = AZF618                                          UUC103
     C                   EVAL      GLMGZ619 = AZF619                                          UUC103
     C                   EVAL      GLMGZ861 = AZF861                                          UUC103
     C                   EVAL      GLMGZ862 = AZF862                                          UUC103
     C                   EVAL      GLMGZ863 = AZF863                                          UUC103
     C                   EVAL      GLMGZ865 = AZF864                                          UUC103
     C                   EVAL      GLMGZ865 = AZF865                                          UUC103
     C                   EVAL      GLMGZ866 = AZF866                                          UUC103
     C                   Endif                                                                UUC103
     C                   Endif                                                                UUC103
      *                                                                                       UUC103
     C                   Endif                                                                UUC103
