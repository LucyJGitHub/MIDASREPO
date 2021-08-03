      *****************************************************************
      *  Start of /COPY FVT106_018                                    *
      *****************************************************************
      *                                                               *
      *  GLVBHCD01 - Validate branch                                  *
      *                                                               *
      *  Last Amend No. FVT106   *Create   Date 22Jul20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FVT106 - Automatic Account Closure and Account re-opening    *
      *                                                               *
      *****************************************************************
      *                                                                         FVT106
     C     DDACTN        Ifeq      'O'                                          FVT106
     C                   Move      'N'           DDBrcaOk                       FVT106
     C                   Add       1             Idx                            FVT106
     C                   Movel     'XXX1062'     MsgIDXAr(Idx)                  FVT106
     C                   Movel     'DDBRCA'      FldNamXAr(Idx)                 FVT106
     C                   Endif                                                  FVT106
      *****************************************************************
      ** End of hook FVT106_018
      *****************************************************************
