      *****************************************************************
      *                                                               *
      *  HUT121_136 - Midas /COPY for SEPRCSUPD                       *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 09Mar22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day.          *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT121
     C                   Z-Add     V_PRPVDT      ZDAYNO                                       HUT121
     C                   CALLB     'ZDATE2'                                                   HUT121
     C                   PARM                    ZDAYNO            5 0                        HUT121
     C                   PARM                    BJDFIN                                       HUT121
     C                   PARM                    ZDATE             6 0                        HUT121
     C                   PARM                    ZADATE            7                          HUT121
      *                                                                                       HUT121
     C                   MOVEL     ZDATE         WPVDT             6                          HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_136                                       *
      *****************************************************************
