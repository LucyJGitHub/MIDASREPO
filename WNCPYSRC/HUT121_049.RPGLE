      *****************************************************************
      *                                                               *
      *  HUT121_049 -  Midas /COPY for SEPRCSUPD                      *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 07Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT121
     C                   ELSE                                                                 HUT121
     C                   IF        HUT121 = 'Y'                                               HUT121
      *                                                                                       HUT121
     C                   IF        NOT %FOUND(XXPRICE)                                        HUT121
     C                   WRITE     XPRICEDF                                                   HUT121
     C                   ELSE                                                                 HUT121
     C                   UPDATE    XPRICEDF                                                   HUT121
     C                   ENDIF                                                                HUT121
     C                   ENDIF                                                                HUT121
     C                   ENDIF                                                                HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_049                                       *
      *****************************************************************
