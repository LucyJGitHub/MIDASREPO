      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001416)                              *
      *                                                               *
      *  GLH00401 - Midas GL Retrieve Shadow Post. by Network Account *
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
     C                   EVAL      SWPXRFI = 'ZS '                              UUC103
                                                                                UUC103
      *-------------------------------------------------------------------------UUC103
      * Check for new SAR UUC103.                                               UUC103
      *-------------------------------------------------------------------------UUC103
     C                   CALLB     'AOSARDR0'                                   UUC103
     C                   PARM      *BLANKS       P@RTCD                         UUC103
     C                   PARM      '*VERIFY'     P@OPTN                         UUC103
     C                   PARM      'UUC103'      P@SARD                         UUC103
      *                                                                         UUC103
     C                   IF        P@RTCD = *Blanks                             UUC103
     C                   EVAL      UUC103 = 'Y'                                 UUC103
     C                   OPEN      GLJENAPD                                     UUC103
     C                   ELSE                                                   UUC103
     C                   EVAL      UUC103 = 'N'                                 UUC103
     C                   ENDIF                                                  UUC103
                                                                                UUC103
