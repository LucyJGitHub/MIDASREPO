      *****************************************************************
      *                                                               *
      *  HUT121_045 -  Midas /COPY for SEPRCSUPD                      *
      *                                                               *
      *  Last Amend No. HUT121C            Date 04May22               *
      *  Prev Amend No. HUT121  *CREATE    Date 07Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121C - Changes to allow SE Price Input for Non-working day*
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT121
     C                   Z-ADD     V_PRPVDT      @PVDT                                        HUT121
     C                   Move      ' '           ZIND              1                         HUT121C
     C                                                                                       HUT121C
     C     HUT121        IFEQ      'Y'                                                       HUT121C
      *                                                                                      HUT121C
      ** check if value date is Working Day                                                  HUT121C
      *                                                                                      HUT121C
     C                   CALLB     'ZCHKH'                                                   HUT121C
     C                   PARM                    @PVDT                                       HUT121C
     C                   PARM      BJLCCY        ZCCY              3                         HUT121C
     C                   PARM                    BJSLCD                                      HUT121C
     C                   PARM                    ZIND              1                         HUT121C
     C                   ENDIF                                                               HUT121C
      *                                                                                       HUT121
     C     HUT121        IFEQ      'N'                                                        HUT121
     C     HUT121        OREQ      'Y'                                                       HUT121C
     C     ZIND          ANDEQ     'W'                                                       HUT121C
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_045                                       *
      *****************************************************************
