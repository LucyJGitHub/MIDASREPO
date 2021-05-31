      *****************************************************************
      * Start of /COPY SDCUDPV051                                     *
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
      ** Check if switchable feature HUT113 is switched on.                                 MD056981
      *                                                                                     MD056981
     C                   Call      'AOSARDR0'                                               MD056981
     C                   Parm      *BLANKS       @RTCD             7                        MD056981
     C                   Parm      '*VERIFY'     @OPTN             7                        MD056981
     C                   Parm      'HUT113'      @SARD             6                        MD056981
      *                                                                                     MD056981
     C     @Rtcd         Ifeq      *Blanks                                                  MD056981
     C                   Move      'Y'           HUT113            1                        MD056981
     C                   else                                                               MD056981
     C                   Move      'N'           HUT113                                     MD056981
     C                   Endif                                                              MD056981
      *****************************************************************
      * End of /COPY  SDCUDPV051                                      *
      *****************************************************************
