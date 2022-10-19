      *****************************************************************
      *                                                               *
      *  HUT121_049 -  Midas /COPY for SEPRCSUPD                      *
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
      ***********                                                                     HUT121 HUT121C
     C***********        ELSE                                                         HUT121 HUT121C
     C***********        IF        HUT121 = 'Y'                                       HUT121 HUT121C
      ***********                                                                     HUT121 HUT121C
     C***********        IF        NOT %FOUND(XXPRICE)                                HUT121 HUT121C
     C***********        WRITE     XPRICEDF                                           HUT121 HUT121C
     C***********        ELSE                                                         HUT121 HUT121C
     C***********        UPDATE    XPRICEDF                                           HUT121 HUT121C
     C***********        ENDIF                                                        HUT121 HUT121C
     C***********        ENDIF                                                        HUT121 HUT121C
     C***********        ENDIF                                                        HUT121 HUT121C
      ***********                                                                     HUT121 HUT121C
      *****************************************************************
      * End of /COPY HUT121_049                                       *
      *****************************************************************
