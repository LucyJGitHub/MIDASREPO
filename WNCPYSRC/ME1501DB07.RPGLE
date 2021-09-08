      *****************************************************************
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                  ESL038                 Date 01Oct2004        *
      *                  EEE058 *Create         Date 05Mar2003        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level      *
      *  ESL038 - ING STP Development                                 *
      *  EEE058 - Incoming STP                                        *
      *                                                               *
      *****************************************************************
      *                                                                                       EEE058
      *  Output to debug file                                                                 EEE058
     C                   MOVEL     GDMTPY        SDMTPY                                       EEE058
     C                   Z-ADD     GDMSET        SDMSET                                       EEE058
     C                   MOVEL     GDMTAG        SDMTAG                                       EEE058
     C                   MOVEL     WUFUNC        SDFUNC                                       EEE058
     C                   MOVEL     WUORIG        SDORIG                                       EEE058
     C                   MOVEL     WUMATH        SDMATH                                       EEE058
     C                   MOVEL     WUACCO        SDACCO                                       EEE058
     C                   MOVEL     WUCRIT        SDCRIT                                       EEE058
     C                   WRITE     @STPDP0                                                    EEE058
      *                                                                                       EEE058
      *
      *****************************************************************
      * End of ME1501DB07                                             *
      *****************************************************************
