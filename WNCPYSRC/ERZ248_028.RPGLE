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
      *                                                                                       ERZ248
     C                   Call      'AOSARDR0'                                                 ERZ248
     C                   Parm      *Blanks       @RTCD                                        ERZ248
     C                   Parm      '*VERIFY'     @OPTN                                        ERZ248
     C                   Parm      'ERZ248'      @SARD                                        ERZ248
     C     SCSARD        Parm      SCSARD        DSFDY                                        ERZ248
                                                                                              ERZ248
     C                   If        @RTCD = *Blanks                                            ERZ248
     C                   Movel     'Y'           ERZ248            1                          ERZ248
     C                   Move      *On           *IN65                                        ERZ248
     C                   Else                                                                 ERZ248
     C                   Movel     'N'           ERZ248                                       ERZ248
     C                   Move      *Off          *IN65                                        ERZ248
     C                   EndIf                                                                ERZ248
      *
