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
      ** Delete record being processed when update is successful                ERZ248
                                                                                ERZ248
     C                   If        ERZ248 = 'Y'                                 ERZ248
     C                   Delete    FTVOPAYXF                            98      ERZ248
     C                   If        *IN98 = True                                 ERZ248
     C                   RolBk                                                  ERZ248
     C                   Movel     'FTVOPAYXD'   DBFILE                         ERZ248
     C                   Movel     '033'         DBASE                          ERZ248
     C                   Movel     *Blanks       DBKEY                          ERZ248
     C                   Movel     OTPREF        DBKEY                          ERZ248
     C                   ExSr      *PSSR                                        ERZ248
     C                   EndIf                                                  ERZ248
     C                   EndIf                                                  ERZ248
      *
