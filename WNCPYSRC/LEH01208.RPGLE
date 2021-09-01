      *****************************************************************                       LUC116
      *                                                               *                       LUC116
      *  Midas - Customer Lending Module.                             *                       LUC116
      *                                                               *                       LUC116
      *  LEFCIP1VL -  Facility First screen  Validation               *                       LUC116
      *                                                               *                       LUC116
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC116
      *                                                               *                       LUC116
      *  Last Amend No. LUC116             Date 21Jan19               *                       LUC116
      *                                                               *                       LUC116
      *---------------------------------------------------------------*                       LUC116
      *                                                               *                       LUC116
      *  LUC116 - Facility Expiry and Last Availability Dates -       *                       LUC116
      *             Until Further Notice                              *                       LUC116
      *                                                               *                       LUC116
      *****************************************************************                       LUC116
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
