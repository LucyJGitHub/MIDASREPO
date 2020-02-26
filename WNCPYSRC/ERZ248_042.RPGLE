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
      ** Re-access OP extension file and write the record on error file         ERZ248
                                                                                ERZ248
     C                   If        ERZ248 = 'Y'                                 ERZ248
     C     *Loval        Setll     FTVOPAYY0                                    ERZ248
                                                                                ERZ248
     C     KOTPREF       Chain     FTVOPAYY0                          89        ERZ248
     C                   Write     FTVOPAYXFE                           98      ERZ248
                                                                                ERZ248
      ** Error writing record                                                   ERZ248
                                                                                ERZ248
     C                   If        *IN98 = True                                 ERZ248
     C                   Movel     'FTVOPAYXDE'  DBFILE                         ERZ248
     C                   Movel     '034'         DBASE                          ERZ248
     C                   Movel     *Blanks       DBKEY                          ERZ248
     C                   Movel     OTPREF        DBKEY                          ERZ248
     C                   ExSr      *PSSR                                        ERZ248
     C                   EndIf                                                  ERZ248
                                                                                ERZ248
      ** Delete record on extension file                                        ERZ248
                                                                                ERZ248
     C                   Delete    FTVOPAYXF                            98      ERZ248
                                                                                RRZ242
      ** Error deleting record                                                  ERZ248
                                                                                ERZ248
     C                   If        *IN98 = True                                 ERZ248
     C                   Movel     'FTVOPAYXD'   DBFILE                         ERZ248
     C                   Movel     '035'         DBASE                          ERZ248
     C                   Movel     *Blanks       DBKEY                          ERZ248
     C                   Movel     OTPREF        DBKEY                          ERZ248
     C                   ExSr      *PSSR                                        ERZ248
     C                   EndIf                                                  ERZ248
     C                   EndIf                                                  ERZ248
      *
