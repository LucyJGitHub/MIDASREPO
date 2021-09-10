      *****************************************************************
      *                                                               *
      *  Last Amend No. MD031937           Date 13Jan15               *
      *  Prev Amend No. AR856737           Date 13Sep11               *
      *                 EEE065             Date 26Aug03               *
      *                 EEE056             Date 22Oct02               *
      *                 EEE046  *Create    Date 11Apr01               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD031937 - Upgrade STP enhancements to BF Midas 2.1          *
      *  AR856737 - Upgrade STP enhancements to Midas Plus level      *
      *  EEE065 - Polish Features Upgrade R4                          *
      *  EEE056 - Polish Clearing Tax Payment                         *
      *  EEE046 - Polish Clearing Enhancement                         *
      *                                                               *
      *****************************************************************
      *================================================================
      ** START of /COPY ME1540C006
      *================================================================
      *                                                                                       EEE046
      ** Translate Settlement Types from File to Screen                                       EEE046
      *                                                                                       EEE046
     C     EEE046        IFEQ      'Y'                                                        EEE046
     C     GNSETT        IFEQ      91                                                         EEE046
     C                   MOVE      'EC'          #1SETT                                       EEE046
     C                   ENDIF                                                                EEE046
     C     GNSETT        IFEQ      92                                                         EEE046
     C                   MOVE      'ED'          #1SETT                                       EEE046
     C                   ENDIF                                                                EEE046
     C     GNSETT        IFEQ      93                                                         EEE046
     C                   MOVE      'SC'          #1SETT                                       EEE046
     C                   ENDIF                                                                EEE046
     C     GNSETT        IFEQ      94                                                         EEE046
     C                   MOVE      'ER'          #1SETT                                       EEE046
     C                   ENDIF                                                                EEE046
     C     GNSETT        IFEQ      95                                                         EEE046
     C                   MOVE      'ZC'          #1SETT                                       EEE046
     C                   ENDIF                                                                EEE046
     C     GNSETT        IFEQ      96                                                         EEE046
     C                   MOVE      'ET'          #1SETT                                       EEE046
     C                   ENDIF                                                                EEE046
     C     GNSETT        IFEQ      97                                                         EEE056
     C                   MOVE      'TP'          #1SETT                                       EEE056
     C                   ENDIF                                                                EEE056
     C                   ENDIF                                                                EEE046
      *                                                                                       EEE046
      *================================================================
      ** END of /COPY ME1540C006
      *================================================================
