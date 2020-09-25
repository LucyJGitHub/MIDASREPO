      *****************************************************************
      *  Start of /COPY FVT106_019                                    *
      *****************************************************************
      *                                                               *
      *  GLVRLAC - Validate GL & Retail Account Number                *
      *                                                               *
      *  Last Amend No. FVT106   *Create   Date 20Jul20               *
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
     C                   Parm      '       '     @RTCD             7            FVT106
     C                   Parm      '*VERIFY'     @OPTN             7            FVT106
     C                   Parm      'FVT106'      @SARD             6            FVT106
      *                                                                         FVT106
     C                   If        @Rtcd = *Blanks                              FVT106
     C                   Move      'Y'           FVT106            1            FVT106
     C                   Else                                                   FVT106
     C                   Move      'N'           FVT106                         FVT106
     C                   Endif                                                  FVT106
      *                                                                         FVT106
      *****************************************************************
      ** End of hook FVT106_019
      *****************************************************************
