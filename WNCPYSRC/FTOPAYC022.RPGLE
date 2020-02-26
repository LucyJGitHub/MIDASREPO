      *****************************************************************
      *                                                               *
      *  FTOPAYCTL - Midas FT Outgoing payments interface controller  *
      *                                                               *
      *  Last Amend No. ERZ248  *CREATE    Date 18Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ248 - SWIFT UETR via OPAY API                             *
      *                                                               *
      *---------------------------------------------------------------*
      *
      ** Access SAR file to determine if ERZ248 is installed                    ERZ248
      *                                                                         ERZ248
     C                   CALLB     'AOSARDR0'                                   ERZ248
     C                   PARM      *BLANKS       PRTCD                          ERZ248
     C                   PARM      '*VERIFY'     POPTN                          ERZ248
     C                   PARM      'ERZ248'      PSARD                          ERZ248
     C     SCSARD        PARM      SCSARD        DSFDY                          ERZ248
      *                                                                         ERZ248
     C     PRTCD         IFEQ      *BLANK                                       ERZ248
     C                   MOVEL     'Y'           ERZ248            1            ERZ248
     C                   ELSE                                                   ERZ248
     C                   MOVEL     'N'           ERZ248                         ERZ248
     C                   ENDIF                                                  ERZ248
      *                                                                         ERZ248
