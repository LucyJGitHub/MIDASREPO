      *****************************************************************                       LUC109
      *                                                               *                       LUC109
      *  Midas - Customer Lending Module.                             *                       LUC109
      *                                                               *                       LUC109
      *  LEFCIP1VL -  Facility First screen  Validation               *                       LUC109
      *                                                               *                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *                       LUC109
      *  Last Amend No. LUC116             Date 21Jan19               *                       LUC109
      *  Last Amend No. LUC109             Date 23Aug16               *                       LUC109
      *                                                               *                       LUC109
      *---------------------------------------------------------------*                       LUC109
      *                                                               *                       LUC109
      *  LUC116 - Facility Expiry and Last Availability Dates -       *                       LUC116
      *             Until Further Notice                              *                       LUC116
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                       LUC109
      *           Allow reactivation of active facilities.            *                       LUC109
      *                                                               *                       LUC109
      *****************************************************************                       LUC109
      ** Check switch LUC109.                                                                 LUC109
     C                   MOVE      'N'           LUC109            1                          LUC109
     C                   CALLB     'AOSARDR0'                                                 LUC109
     C                   PARM      *BLANKS       @RTCD                                        LUC109
     C                   PARM      '*VERIFY '    @OPTN                                        LUC109
     C                   PARM      'LUC109'      @SARD                                        LUC109
     C     SCSARD        PARM      SCSARD        DSFDY                                        LUC109
      *                                                                                       LUC109
     C                   IF        @RTCD = *BLANKS                                            LUC109
     C                   EVAL      LUC109 = 'Y'                                               LUC109
     C                   ELSE                                                                 LUC109
     C                   EVAL      LUC109 = 'N'                                               LUC109
     C                   ENDIF                                                                LUC109
      **                                                                                      LUC116
      ** Check switch LUC116.                                                                 LUC116
     C                   MOVE      'N'           LUC116            1                          LUC116
     C                   CALLB     'AOSARDR0'                                                 LUC116
     C                   PARM      *BLANKS       @RTCD                                        LUC116
     C                   PARM      '*VERIFY '    @OPTN                                        LUC116
     C                   PARM      'LUC116'      @SARD                                        LUC116
     C     SCSARD        PARM      SCSARD        DSFDY                                        LUC116
      *                                                                                       LUC116
     C                   IF        @RTCD = *BLANKS                                            LUC116
     C                   EVAL      LUC116 = 'Y'                                               LUC116
     C                   ELSE                                                                 LUC116
     C                   EVAL      LUC116 = 'N'                                               LUC116
     C                   ENDIF                                                                LUC116
      *****************************************************************                       LUC116
      * End of /COPY LEH01208                                         *                       LUC116
      *****************************************************************                       LUC116
