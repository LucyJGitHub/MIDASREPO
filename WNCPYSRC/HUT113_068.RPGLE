      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (DSPF)                                  *
      *                                                               *
      *  SDVCFDT                                                      *
      *                                                               *
      *  Last Amend No. HUT113    *CREATE  Date 01Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT113 - Upgrade HUT026 to FBM 2.1 SP 22                     *
      *         - Full Private Banking Functionality in Midas         *
      *         - Allow Portfolio Definitions Input in Midas          *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT113
      * Check if Numeric Input only                                                           HUT113
     C     HUT113        IFEQ      'Y'                                                        HUT113
     C                   TESTN                   DDPBST               01                      HUT113
     C     *IN01         IFEQ      *OFF                                                       HUT113
     C                   EVAL      DDPBSTOK = 'N'                                             HUT113
     C                   ADD       1             Idx                                          HUT113
     C                   EVAL      FldNamXAr(Idx) = 'DDPBST'                                  HUT113
     C                   EVAL      MsgIdXAr(Idx) = 'USR3862'                                  HUT113
     C                   GOTO      ENDVAL                                                     HUT113
     C                   ENDIF                                                                HUT113
     C                   ENDIF                                                                HUT113
      *****************************************************************
      * End of /COPY HUT113_068                                       *
      *****************************************************************
