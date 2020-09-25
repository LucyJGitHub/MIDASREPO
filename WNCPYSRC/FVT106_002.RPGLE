      *****************************************************************
      *  Start of /COPY FVT106_002                                    *
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
      ** Test if authorised to re-open                                          FVT106
      *                                                                         FVT106
     C     FVT106        Ifeq      'Y'                                          FVT106
     C     DDACTN        Ifeq      'O'                                          FVT106
     C     *IN43         andne     '1'                                          FVT106
     C                   Move      'N'           DDACTNOk                       FVT106
     C                   Add       1             Idx                            FVT106
     C                   Movel     'DDACTN'      FldNamXAr(Idx)                 FVT106
     C                   Movel     'XXX1061'     MsgIDXAr(Idx)                  FVT106
     C                   Endif                                                  FVT106
     C                   Endif                                                  FVT106
      *****************************************************************
      ** End of hook FVT106_002
      *****************************************************************
