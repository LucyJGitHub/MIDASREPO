      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001425)                              *
      *                                                               *
      *  GLH00411 - Midas GL Retrieve Postings by Network Account     *
      *                                                               *
      *  Last Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
     C     KeySWPZS      KLIST                                                  UUC103
     C                   KFLD                    SWPXRFI           3            UUC103
     C                   KFLD                    SWPXRFN          10 0          UUC103
     C     UUC103        IFEQ      'Y'                                          UUC103
     C                   EVAL      SWPXRFI = 'ZS '                              UUC103
     C                   ENDIF                                                  UUC103

