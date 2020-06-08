      *****************************************************************                       HUT101
      *  Midas - Copy member for FTOPAYUPD                            *                       HUT101
      *                                                               *                       HUT101
      *  FTH00109 - Payment Authorisation for Funds Transfer          *                       HUT101
      *                                                               *                       HUT101
      *  Last Amend No. HUT101 *CREATE     Date 27Mar20               *                       HUT101
      * FBMidas 2.1 ---- Base ----------------------------------------*                       HUT101
      *                                                               *                       HUT101
      *---------------------------------------------------------------*                       HUT101
      *                                                               *                       HUT101
      *  HUT101 - Upgrade CFT129 to FBM 2.1 SP22                      *                       HUT101
      *           Payment Authorisation for Funds Transfer            *                       HUT101
      *                                                                                       HUT101
      *****************************************************************                       HUT101
      *                                                                                       HUT101
      ** Check if HUT101 feature is installed                                                 HUT101
                                                                                              HUT101
     C                   MOVE      'N'           HUT101            1                          HUT101
     C                   CALL      'AOSARDR0'                                                 HUT101
     C                   PARM      *BLANKS       PRTCD                                        HUT101
     C                   PARM      '*VERIFY'     POPTN                                        HUT101
     C                   PARM      'HUT101'      PSARD                                        HUT101
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT101
     C                   IF        PRTCD <> *Blanks  and                                      HUT101
     C                             PRTCD <> '*NRF'                                            HUT101
     C     *LOCK         IN        LDA                                                        HUT101
     C                   EVAL      DBKey = 'HUT101'                                           HUT101
     C                   EVAL      DBFile = 'SCSARDPD'                                        HUT101
     C                   EVAL      DBase = 20                                                 HUT101
     C                   EXSR      *PSSR                                                      HUT101
     C                   ENDIF                                                                HUT101
                                                                                              HUT101
     C                   IF        PRTCD = *BLANKS                                            HUT101
     C                   EVAL      HUT101 = 'Y'                                               HUT101
     C                   ENDIF                                                                HUT101
                                                                                              HUT101
      *****************************************************************                       HUT101
      * End of /COPY FTH00109                                         *                       HUT101
      *****************************************************************                       HUT101
