      *---------------------------------------------------------------*
      *   Last Amend No. MD031937           Date 13Jan15              *
      *   Prev Amend No. AR856737           Date 13Sep11              *
      *                  ESL038             Date 01Oct2004            *
      *                  EEE058   *Create   Date 05Feb2003            *
      *---------------------------------------------------------------*
      *                                                               *
      *   MD031937 - Upgrade STP enhancements to BF Midas 2.1         *
      *   AR856737 - Upgrade STP enhancements to Midas Plus level     *
      *   ESL038 - ING STP Development                                *
      *   EEE058 - Incoming STP                                       *
      *                                                               *
      *---------------------------------------------------------------*
      *
     C     GDOPER        IFEQ      'CT'                                                       EEE058
     C     WUCRIT        SCAN      WUORIG                                 90                  EEE058
     C     *IN90         IFEQ      *OFF                                                       EEE058
     C                   MOVE      'Y'           WUMATH                                       EEE058
     C                   ENDIF                                                                EEE058
     C                   ENDIF                                                                EEE058
      *
      *---------------------------------------------------------------*
      * copy hook end ME1540DB01                                      *
      *---------------------------------------------------------------*
