      *****************************************************************
      * Start of /COPY SDCUDPV048                                     *
      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  SDCUSD2VL - PM validation                                    *
      *                                                               *
      *  Last Amend No. MD056981  *Create  Date 12Oct20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056981  - HUT113                                           *
      *  Customer Maintenance: Private Banking Error Encountered      *
      *  During input                                                 *
      *                                                               *
      *****************************************************************
      *                                                                                     MD056981
     C     BGN4ST        Ifeq      'Y'                                                      MD056981
     C     HUT113        andeq     'Y'                                                      MD056981
     C     DDPRBA        andeq     *BLANK                                                   MD056981
     C                   Move      'N'           DDPRBA                                     MD056981
     C                   Endif                                                              MD056981
      *****************************************************************
      * End of /COPY SDCUDPV048                                       *
      *****************************************************************
