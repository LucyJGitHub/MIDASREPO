      *****************************************************************
      *                                                               *
      *  HUT121_018 - Midas /COPY for SEPRCSRED                       *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 07Feb22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day.          *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT121
     C     XPRICEK       KLIST                                                                HUT121
     C                   KFLD                    DDPSSN                                       HUT121
     C                   KFLD                    @@PCNM                                       HUT121
     C                   KFLD                    DDPMKT                                       HUT121
     C                   KFLD                    DDPBRA                                       HUT121
     C                   KFLD                    DDPBOK                                       HUT121
     C                   KFLD                    DDPPRT                                       HUT121
     C                   KFLD                    DDPTFR                                       HUT121
     C                   KFLD                    @@PVDT            5 0                        HUT121
      *                                                                                       HUT121
      ***  Check if HUT121 is on                                                              HUT121
      *                                                                                       HUT121
     C                   CALL      'AOSARDR0'                                                 HUT121
     C                   PARM      *BLANKS       @RTCD                                        HUT121
     C                   PARM      '*VERIFY'     @OPTN                                        HUT121
     C                   PARM      'HUT121'      @SARD             6                          HUT121
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT121
      *                                                                                       HUT121
     C     @RTCD         IFEQ      *BLANKS                                                    HUT121
     C                   MOVE      'Y'           HUT121            1                          HUT121
     C                   ELSE                                                                 HUT121
     C                   MOVE      'N'           HUT121            1                          HUT121
     C                   ENDIF                                                                HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_018                                       *
      *****************************************************************
