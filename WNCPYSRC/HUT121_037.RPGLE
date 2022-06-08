      *****************************************************************
      *                                                               *
      *  HUT121_037 -  Midas /COPY for SEPRCSRTV                      *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 07Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT121
     C                   CALL      'AOSARDR0'                                                 HUT121
     C                   PARM      *BLANKS       @RTCD                                        HUT121
     C                   PARM      '*VERIFY'     @OPTN                                        HUT121
     C                   PARM      'HUT121'      @SARD             6                          HUT121
      *                                                                                       HUT121
     C     @RTCD         IFEQ      *BLANKS                                                    HUT121
     C                   MOVE      'Y'           HUT121                                       HUT121
     C                   ELSE                                                                 HUT121
     C                   MOVE      'N'           HUT121                                       HUT121
     C                   ENDIF                                                                HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_037                                       *
      *****************************************************************
