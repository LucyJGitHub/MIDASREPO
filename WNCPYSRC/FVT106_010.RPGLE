      *****************************************************************
      *  Start of /COPY FVT106_010                                    *
      *****************************************************************
      *                                                               *
      *  GLAMADVU - Midas GL Accounts Validate and Update             *
      *                                                               *
      *  Last Amend No. FVT106   *Create   Date 20Jul20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FVT106 - Automatic Account Closure and Account re-opening    *
      *                                                               *
      *****************************************************************
      *                                                                         FVT106
      * Set Valid file field(s) needed for Action code 'O'                      FVT106
     C                   If        FVT106 = 'Y'                                 FVT106
     C                             and DDACTN = 'O'                             FVT106
      *                                                                         FVT106
     C                   Eval      V_AMCHTP = 'A'                               FVT106
     C                   Eval      V_AMRECI = 'D'                               FVT106
     C                   Eval      V_AMDACC = 0                                 FVT106
     C                   Eval      V_AMACST = *Blanks                           FVT106
      *                                                                         FVT106
     C                   If        V_AMNSTD < BJRdnb                            FVT106
     C                             and V_AMNSTD <> 0                            FVT106
      *                                                                         FVT106
     C     V_AMStFq      Ifeq      'D'                                          FVT106
     C     CGL184        Andeq     'N'                                          FVT106
     C     V_AMStFq      Orne      'D'                                          FVT106
     C     V_AMStFq      Andne     'K'                                          FVT106
     C     CGL184        Andeq     'Y'                                          FVT106
     C                   Movel     V_AMSTDY      ZMDAY                          FVT106
     C                   Else                                                   FVT106
     C                   Z-add     *zeros        ZMDAY                          FVT106
     C                   Endif                                                  FVT106
                                                                                FVT106
     C                   CallB     'ZFREQB'                                     FVT106
     C                   Parm      *blanks       RetCodeIn                      FVT106
     C                   Parm      V_AMStFq      ZFREQ             1            FVT106
     C                   Parm      BJRdnb        ZDAYNO            5 0          FVT106
     C                   Parm      V_AMCcy       ZCCY              3            FVT106
     C                   Parm      *Blanks       ZLOC              3            FVT106
     C                   Parm                    ZMDAY             2 0          FVT106
     C                   Parm                    BJDFIN                         FVT106
     C                   Parm      SDGELR        SDGELR                         FVT106
                                                                                FVT106
     C     RetCodeIn     Ifeq      *blanks                                      FVT106
     C     ZdayNo        Andne     *zeros                                       FVT106
     C                   Z-add     ZDayNo        V_AMNSTD                       FVT106
     C                   Endif                                                  FVT106
                                                                                FVT106
     C                   Endif                                                  FVT106
     C                   Endif                                                  FVT106
      *                                                                         FVT106
      *****************************************************************
      ** End of hook FVT106_010
      *****************************************************************
