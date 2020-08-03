      *****************************************************************
      *                                                               *
      *  FTOPAY1DP - Midas FT Outgoing payments level one display     *
      *                                                               *
      *  Last Amend No. ERZ248  *CREATE    Date 18Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ248 - SWIFT UETR via OPAY API                             *
      *                                                               *
      *---------------------------------------------------------------*
      * If UETR is invalid, then set on IN63                                    ERZ248
     C                   If        ERZ248 = 'Y' and OKUETR = 'N'                ERZ248
     C                   Move      *On           *IN63                          ERZ248
     C                   EndIf                                                  ERZ248
     C                   If        ERZ248 = 'Y'                                 ERZ248
     C                   Move      *On           *IN65                          ERZ248
     C                   EndIf                                                  ERZ248
      *
