      *****************************************************************
      *                                                               *
      *  FTOPAYUPC - Midas FT Outgoing payment dbase update controller*
      *                                                               *
      *  Last Amend No. ERZ248  *CREATE    Date 18Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ248 - SWIFT UETR via OPAY API                             *
      *                                                               *
      *---------------------------------------------------------------*
      *
      ** Access SAR details file to see if ERZ248 is installed.                               ERZ248
      *                                                                                       ERZ248
     C                   CALLB     'AOSARDR0'                                                 ERZ248
     C                   PARM      *BLANKS       PRTCD                                        ERZ248
     C                   PARM      '*VERIFY'     POPTN                                        ERZ248
     C                   PARM      'ERZ248'      PSARD                                        ERZ248
     C     SCSARD        PARM      SCSARD        DSFDY                                        ERZ248
      *                                                                                       ERZ248
     C                   IF        PRTCD = *BLANKS                                            ERZ248
     C                   move      'Y'           ERZ248            1                          ERZ248
     C                   ELSE                                                                 ERZ248
     C                   EVAL      ERZ248 = 'N'                                               ERZ248
     C                   ENDIF                                                                ERZ248
      *
