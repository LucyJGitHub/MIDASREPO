      *****************************************************************
      *                                                               *
      *  HUT121_038 - Midas /COPY for SEPRCSUPD                       *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 07Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day.          *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT121
     FXXPRICE   UF A E           K DISK                                                       HUT121
     F                                     COMMIT                                             HUT121
     F                                     INCLUDE(PRICEDF)                                   HUT121
     F                                     RENAME(PRICEDF:XPRICEDF)                           HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_038                                       *
      *****************************************************************
