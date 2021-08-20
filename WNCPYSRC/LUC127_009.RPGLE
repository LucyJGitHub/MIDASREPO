      *****************************************************************
      *                                                               *
      *  LUC127_009 - ZAVPROFITC - Call AOSARDR0                      *
      *                                                               *
      *  Last Amend No. LUC127   *Create   Date 14Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC127 - Output PRFC in all cases                            *
      *                                                               *
      *****************************************************************
      *                                                                                       LUC127
      ** Check if switchable feature LUC127 is installed                                      LUC127
      *                                                                                       LUC127
     C                   MOVE      'N'           LUC127            1                          LUC127
      *                                                                                       LUC127
     C                   CALLB     'AOSARDR0'                                                 LUC127
     C                   PARM      *BLANKS       PRtCd             7                          LUC127
     C                   PARM      '*VERIFY'     POptn             7                          LUC127
     C                   PARM      'LUC127'      PSard             6                          LUC127
     C     SCSARD        PARM      SCSARD        DSFDY                                        LUC127
      *                                                                                       LUC127
     C                   IF        PRtCd = *BLANKS                                            LUC127
     C                   EVAL      LUC127 = 'Y'                                               LUC127
     C                   ENDIF                                                                LUC127
      *                                                                                       LUC127
      *****************************************************************                       LUC127
      * End of /COPY LUC127_009                                       *                       LUC127
      *****************************************************************                       LUC127
