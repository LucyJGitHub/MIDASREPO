      *****************************************************************
      *  Start of /COPY FVT106_015                                    *
      *****************************************************************
      *                                                               *
      *  GLAMADRTV - GL Accounts Retrieve                             *
      *                                                               *
      *  Last Amend No. FVT106   *Create   Date 22Jul20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FVT106 - Automatic Account Closure and Account re-opening    *
      *                                                               *
      *****************************************************************
      * VALACO - VALIDATION OF ACTION CODE 'O'                                  FVT106
      *****************************************************************         FVT106
      *                                                                         FVT106
     C     VALACO        BEGSR                                                  FVT106
      *                                                                         FVT106
      * Access Account from the accounts file                                   FVT106
      *                                                                         FVT106
     C     CHKACC        Chain     ACCNTABF                           44        FVT106
      *                                                                         FVT106
      * Must reference an Account that exists and is Closed                     FVT106
     C     *IN44         Ifeq      '1'                                          FVT106
     C     *IN44         oreq      '0'                                          FVT106
     C     A1Acst        andne     'C'                                          FVT106
     C                   Movel     'N'           OKCNUM                         FVT106
     C                   Movel     'N'           OKCCY                          FVT106
     C                   Movel     'N'           OKACOD                         FVT106
     C                   Movel     'N'           OKACSQ                         FVT106
     C                   Movel     'N'           OKBRCA                         FVT106
     C                   Add       1             Ix                             FVT106
     C                   Movel     'DDACCN'      FldNameArr(Ix)                 FVT106
     C                   Movel     'XXX1063'     MsgIdArr(Ix)                   FVT106
     C                   Goto      EVALAO                                       FVT106
     C                   Endif                                                  FVT106
                                                                                FVT106
     C     EVALAO        ENDSR                                                  FVT106
      *                                                                         FVT106
      *****************************************************************
      ** End of hook FVT106_015
      *****************************************************************
