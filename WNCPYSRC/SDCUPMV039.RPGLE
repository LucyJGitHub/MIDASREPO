      *****************************************************************
      * Start of /COPY SDCUPMV039                                     *
      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  SDCUSDIVL - PM validation                                    *
      *                                                               *
      *  Last Amend No. MD056300  *Create  Date 16Jul20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD056300 - Missing HUT113 functionality                      *
      *   HUT113 - Full PB Functionality in FM                        *
      *            (Upgrade HUT026 to FM 2.1 SP22)                    *
      *                                                               *
      *****************************************************************
      *                                                                             MD056300
      ** Check if switchable feature HUT113 is switched on.                         MD056300
      *                                                                             MD056300
     C                   Call      'AOSARDR0'                                       MD056300
     C                   Parm      *BLANKS       @RTCD             7                MD056300
     C                   Parm      '*VERIFY'     @OPTN             7                MD056300
     C                   Parm      'HUT113'      @SARD             6                MD056300
      *                                                                             MD056300
     C     @Rtcd         Ifeq      *Blanks                                          MD056300
     C                   Move      'Y'           HUT113            1                MD056300
     C                   else                                                       MD056300
     C                   Move      'N'           HUT113                             MD056300
     C                   Endif                                                      MD056300
      *****************************************************************
      * End of /COPY SDCUPMV039                                       *
      *****************************************************************
