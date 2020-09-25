      *****************************************************************
      *  Start of /COPY FVT106_021                                    *
      *****************************************************************
      *                                                               *
      *  GLAMADUPD - Update fields for 'O' action code                *
      *                                                               *
      *  Last Amend No. FVT106   *Create   Date 16Sep20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FVT106 - Automatic Account Closure and Account re-opening    *
      *                                                               *
      *****************************************************************
      *                                                                         FVT106
      ** Call AOSARDR0                                                          FVT106
      *                                                                         FVT106
     C                   Call      'AOSARDR0'                                   FVT106
     C                   Parm      '       '     @RTCD                          FVT106
     C                   Parm      '*VERIFY'     @OPTN                          FVT106
     C                   Parm      'FVT106'      @SARD                          FVT106
      *                                                                         FVT106
     C                   If        @Rtcd = *Blanks                              FVT106
     C                   Move      'Y'           FVT106            1            FVT106
     C                   Else                                                   FVT106
     C                   Move      'N'           FVT106                         FVT106
     C                   Endif                                                  FVT106
      *                                                                         FVT106
      *****************************************************************
      ** End of hook FVT106_021
      *****************************************************************
