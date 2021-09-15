      *****************************************************************
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 EEE065             Date 26Aug03               *
      *                 EEE046  *Create    Date 11Apr01               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level      *
      *  EEE065 - Polish Features Upgrade R4                          *
      *  EEE046 - Polish Clearing                                     *
      *                                                               *
      *****************************************************************
      *================================================================
      ** START of /COPY ME1540C008
      *================================================================
      *                                                                                       EEE046
      ** If Invalid Sett Type, check against additional Sett Types.                           EEE046
      *                                                                                       EEE046
     C     EEE046        IFEQ      'Y'                                                        EEE046
     C     *IN65         IFEQ      '0'                                                        EEE046
     C     #1SETT        LOOKUP    HKST2                                  66                  EEE046
     C     *IN66         IFEQ      '1'                                                        EEE046
     C                   SETON                                        65                      EEE046
     C                   ENDIF                                                                EEE046
     C                   ENDIF                                                                EEE046
     C                   ENDIF                                                                EEE046
      *                                                                                       EEE046
      *================================================================
      ** END of /COPY ME1540C008
      *================================================================
