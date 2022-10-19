      *****************************************************************
      *                                                               *
      *  HUT121_039 - Midas /COPY for SEPRCSUPD                       *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 07Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day.          *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT121
     D XCHKPRCSFMT   E DS                  EXTNAME(XXPRICE)                                   HUT121
     D                                     PREFIX(XH)                                         HUT121
      ** Rename fields for Timestamp checking                                                 HUT121
                                                                                              HUT121
     D XX_PRICE      E DS                  EXTNAME(XXPRICE)                                   HUT121
     D                                     PREFIX(XX_)                                        HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_039                                       *
      *****************************************************************
