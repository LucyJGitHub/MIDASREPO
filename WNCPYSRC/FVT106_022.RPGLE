      *****************************************************************
      *  Start of /COPY FVT106_022                                    *
      *****************************************************************
      *                                                               *
      *  GLAMADUPD - Midas GL Accounts update                         *
      *                                                               *
      *  Last Amend No. FVT106   *Create   Date 16Sep20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FVT106 - Automatic Account Closure and Account re-opening    *
      *                                                               *
      *****************************************************************
      *                                                                         FVT106
      * Ensure fields needed for Action code 'O' are updated                    FVT106
     C                   If        FVT106 = 'Y'                                 FVT106
      *                                                                         FVT106
     C                   If        BA_ACST = 'C' and AMACST <> 'C'              FVT106
     C                   Eval      AC_RECI = AMRECI                             FVT106
     C                   Eval      AC_DACC = AMDACC                             FVT106
     C                   Eval      AC_ACST = AMACST                             FVT106
     C                   Endif                                                  FVT106
      *                                                                         FVT106
     C                   Endif                                                  FVT106
      *                                                                         FVT106
      *****************************************************************
      ** End of hook FVT106_022
      *****************************************************************
