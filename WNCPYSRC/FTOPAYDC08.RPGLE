      *****************************************************************
      *                                                               *
      *  FTOPAYUPD - Midas FT Outgoing payments database update       *
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
     C                   PARM      *BLANKS       C#RTCD                                       ERZ248
     C                   PARM      '*VERIFY'     POPTN             7                          ERZ248
     C                   PARM      'ERZ248'      PSARD             6                          ERZ248
     C     SCSARD        PARM      SCSARD        DSFDY                                        ERZ248
      *                                                                                       ERZ248
     C                   IF        C#RTCD= *BLANKS                                            ERZ248
     C                   MOVE      'Y'           ERZ248            1                          ERZ248
     C                   ELSE                                                                 ERZ248
     C                   EVAL      ERZ248 = 'N'                                               ERZ248
     C                   ENDIF                                                                ERZ248
      *
