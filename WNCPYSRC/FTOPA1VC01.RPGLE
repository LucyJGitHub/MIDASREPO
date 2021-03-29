      *****************************************************************
      *                                                               *
      *  FTOPAY1VL - Midas FT Outgoing payments validation control 1  *
      *                                                               *
      *  Last Amend No. ERZ248  *CREATE    Date 18Nov19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ248 - SWIFT UETR via OPAY API                             *
      *                                                               *
      *---------------------------------------------------------------*
      *
      * Validate Unique End-to-End Transaction Reference                        ERZ248
     C                   IF        ERZ248 = 'Y'                                 ERZ248
     C                   EXSR      VUETR                                        ERZ248
     C                   ENDIF                                                  ERZ248
      *
