      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001432)                              *
      *                                                               *
      *  GLH00424 - Midas GL Format Posting details                   *
      *                                                               *
      *  Last Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
     C                   IF        UUC103 = 'Y'                                          UUC103
     C                   WHEN      GLCHQN <> 0                                           UUC103
     C                   EVAL      %SUBST(MGSFD6:2:3) = 'CHK'                   Cheques  UUC103
     C                   ENDIF                                                           UUC103
