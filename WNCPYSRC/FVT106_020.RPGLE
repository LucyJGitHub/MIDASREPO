      *****************************************************************
      *  Start of /COPY FVT106_020                                    *
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
      ** Do not return error if DACC <> 0 but action code is 'R'                FVT106
      *                                                                         FVT106
     C     FVT106        ANDNE     'Y'                                          FVT106
     C     DACC          ORNE      0                                            FVT106
     C     DDActn        ANDNE     'O'                                          FVT106
     C     FVT106        ANDEQ     'Y'                                          FVT106
      *                                                                         FVT106
      *****************************************************************
      ** End of hook FVT106_020
      *****************************************************************
