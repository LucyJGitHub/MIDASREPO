      *****************************************************************
      *                                                               *
      *  FTOPAYRTV - Midas FT Outgoing pmnts retr+act/deal validation *
      *                                                               *
      *  Last Amend No. ERZ248  *CREATE    Date 18Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ248 - SWIFT UETR via OPAY API                             *
      *                                                               *
      *---------------------------------------------------------------*
      *
     C                   IF        ERZ248 = 'Y'                                 ERZ248
     C     SPREF         CHAIN     OTPAYQL0                           38        ERZ248
                                                                                ERZ248
     C                   If        *IN38 = True                                 ERZ248
     C                   Movel     *BLANKS       SUETR                          ERZ248
     C                   Else                                                   ERZ248
     C                   If        SUETR = *Blanks                              ERZ248
     C                   Movel     OTUETR        SUETR                          ERZ248
     C                   EndIf                                                  ERZ248
     C                   EndIf                                                  ERZ248
     C                   EndIf                                                  ERZ248
      *
