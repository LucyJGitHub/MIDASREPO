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
      * Access SAR details file to determine if ERZ248 is on.                                 ERZ248
      *                                                                                       ERZ248
     C                   CALLB     'AOSARDR0'                                                 ERZ248
     C                   Parm      *BLANKS       @RTCD                                        ERZ248
     C                   Parm      '*VERIFY'     @OPTN                                        ERZ248
     C                   Parm      'ERZ248'      @SARD                                        ERZ248
     C     SCSARD        Parm      SCSARD        DSFDY                                        ERZ248
                                                                                              ERZ248
     C                   If        @RTCD = *Blanks                                            ERZ248
     C                   Movel     'Y'           ERZ248            1                          ERZ248
     C                   Else                                                                 ERZ248
     C                   Movel     'N'           ERZ248                                       ERZ248
     C                   End                                                                  ERZ248
      *
