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
      *                                                               *                       HUT113
      * SRERR - EXCEPTION ERRORS                                      *                       HUT113
      *                                                               *                       HUT113
      *****************************************************************                       HUT113
     C     SRERR         BEGSR                                                                HUT113
      *                                                                                       HUT113
     C                   MOVEL     'SDVCSDT'     DBPGM                                        HUT113
     C                   MOVE      '1'           *INU7                                        HUT113
     C                   MOVE      '1'           *INU8                                        HUT113
     C                   MOVE      '1'           *INLR                                        HUT113
     C                   DUMP                                                                 HUT113
      *                                                                                       HUT113
      **  Terminte the program                                                                HUT113
      *                                                                                       HUT113
     C                   RETURN                                                               HUT113
      *                                                                                       HUT113
     C                   ENDSR                                                                HUT113
     C*                                                                                       HUT113
      *****************************************************************
      * End of /COPY HUT113_071                                       *
      *****************************************************************
