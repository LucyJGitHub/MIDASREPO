      *****************************************************************
      *                                                               *
      *  Midas - Midas/SWIFT Meridian communications                  *
      *                                                               *
      *  MS6110MC05 -  MPM Mapping Extensions                         *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. UUC104             Date 12Oct20               *
      *  Prev Amend No. xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  UUC104 - MPM Integration (Upgrade of 1.4.11.06 CAR UUC069)   *
      *                                                               *
      *****************************************************************
     C                   CALLB     'AOSARDR0'                                                 UUC104
     C                   PARM      *BLANKS       @RTCD                                        UUC104
     C                   PARM      '*VERIFY'     @OPTN                                        UUC104
     C                   PARM      'UUC104'      @SARD                                        UUC104
     C     SCSARD        PARM      SCSARD        DSFDY                                        UUC104
     C     @RTCD         IFEQ      *BLANKS                                                    UUC104
     C                   MOVE      'Y'           UUC104            1                          UUC104
     C                   ELSE                                                                 UUC104
     C                   MOVE      'N'           UUC104                                       UUC104
     C                   ENDIF                                                                UUC104
      *****************************************************************
