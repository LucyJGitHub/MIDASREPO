      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001432)                              *
      *                                                               *
      *  GLH00423 - Midas GL Format Posting details                   *
      *                                                               *
      *  Last Amend No. UUC103 *CREATE  Date 20Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC103 - Upgrade of CAR UUC061 to BF Midas 2.1               *
      *           UUC061 - SWIFT Statement Enhancement                *
      *                                                               *
      *****************************************************************
     C                   IF        UUC103 = 'Y'                                 UUC103
     C                   IF        WTYPE = 'BI'                                 UUC103
     C                             OR WTYPE = 'BO'                              UUC103
     C                             OR WTYPE = 'RI'                              UUC103
     C                             OR WTYPE = 'RO'                              UUC103
     C                   MOVE      GLOTTP        W1KPRT                         UUC103
     C                   ENDIF                                                  UUC103
     C                   ENDIF                                                  UUC103
