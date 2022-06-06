      *****************************************************************
      *                                                               *
      *  HUT121_127 - Midas /COPY for SEVVLDT01                       *
      *                                                               *
      *  Last Amend No. HUT121  *CREATE    Date 09Mar22               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT121 -  Allow SE Price Input for Non-working day           *
      *                                                               *
      *****************************************************************
     C                   Move      'N'           HUT121            1                          HUT121
     C                   CALLB     'AOSARDR0'                                                 HUT121
     C                   PARM      *BLANKS       PRtCd                                        HUT121
     C                   PARM      '*VERIFY'     POptn                                        HUT121
     C                   PARM      'HUT121'      PSard                                        HUT121
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT121
     C                   IF        PRtCd = *Blanks                                            HUT121
     C                   Eval      HUT121 = 'Y'                                               HUT121
     C                   IN        JNSTAT                                                     HUT121
     C                   Endif                                                                HUT121
      *                                                                                       HUT121
      *****************************************************************
      * End of /COPY HUT121_127                                       *
      *****************************************************************
