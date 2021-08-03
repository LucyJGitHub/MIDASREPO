      *****************************************************************
      *  Start of /COPY FVT106_005                                    *
      *****************************************************************
      *                                                               *
      *  GLVACCD - Validate action code                               *
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
      ** Prepare Re-open Authorisation                                          FVT106
      *                                                                         FVT106
     C     FVT106        Ifeq      'Y'                                          FVT106
     C                   Move      'O'           @ZACTN                         FVT106
     C     BJSBRC        Ifne      *BLANKS                                      FVT106
     C                   Exsr      #AUTH                                        FVT106
     C     @ERR          Ifeq      0                                            FVT106
     C                   Move      '1'           *IN43                          FVT106
     C                   Endif                                                  FVT106
     C                   Else                                                   FVT106
     C                   Move      '1'           *IN43                          FVT106
     C                   Endif                                                  FVT106
     C                   Endif                                                  FVT106
      *                                                                         FVT106
      *****************************************************************
      ** End of hook FVT106_005
      *****************************************************************
