      *****************************************************************
      *  Start of /COPY FVT106_004                                    *
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
     C     FVT106        Ifeq      'Y'                                          FVT106
     C     DDACTN        Ifeq      'O'                                          FVT106
     C     *IN81         andeq     '0'                                          FVT106
     C     ACST          andne     'C'                                          FVT106
     C     DDACTN        oreq      'O'                                          FVT106
     C     *IN81         andeq     '1'                                          FVT106
     C                   Move      'N'           DDACCNOk                       FVT106
     C                   Add       1             Idx                            FVT106
     C                   Movel     'DDACCN'      FldNamXAr(Idx)                 FVT106
     C                   Movel     'XXX1063'     MsgIDXAr(Idx)                  FVT106
     C                   Endif                                                  FVT106
     C                   Endif                                                  FVT106
      *****************************************************************
      ** End of hook FVT106_004
      *****************************************************************
