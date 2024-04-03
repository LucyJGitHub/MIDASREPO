      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL001432)                              *
      *                                                               *
      *  GLH00208 - Midas GL Format Posting details                   *
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
     C     KBTBI         KLIST                                                  UUC103
     C                   KFLD                    BTNB                           UUC103
     C                   KFLD                    BINB                           UUC103
     C                   KFLD                    GLPSTD                         UUC103
                                                                                UUC103
      *-------------------------------------------------------------------------UUC103
     C                   EVAL      UUC103 = 'N'                                 UUC103
     C                   CALLB     'AOSARDR0'                                   UUC103
     C                   PARM      *BLANKS       P@RTCD                         UUC103
     C                   PARM      '*VERIFY'     P@OPTN                         UUC103
     C                   PARM      'UUC103 '     P@SARD                         UUC103
     C     SCSARD        PARM      SCSARD        DSFDY                          UUC103
                                                                                UUC103
     C                   IF        P@RTCD = *BLANKS                             UUC103
     C                   EVAL      UUC103 = 'Y'                                 UUC103
     C                   OPEN      GLJENAPD                                     UUC103
     C                   ENDIF                                                  UUC103
                                                                                UUC103
