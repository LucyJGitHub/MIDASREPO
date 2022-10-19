      *****************************************************************
      *                                                               *
      *  HUT121_047 -  Midas /COPY for SEPRCSUPD                      *
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
     C                             AND HUT121 = 'N'  OR                                       HUT121
     C**********                   NOT %FOUND(XXPRICE) AND                            HUT121 HUT121C
     C**********                   HUT121 = 'Y'                                       HUT121 HUT121C
     C                             HUT121 = 'Y' AND                                          HUT121C
     C                             ZIND = 'H'                                                HUT121C
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_047                                       *
      *****************************************************************
