      *****************************************************************                       LUC109
      *                                                               *                       LUC109
      *  Midas - Customer Lending Module.                             *                       LUC109
      *                                                               *                       LUC109
      *  LELOAMVAL - LE Loan amendment detail screen validation       *                       LUC109
      *                                                               *                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *                       LUC109
      *  Last Amend No. LUC109             Date 23Aug16               *                       LUC109
      *                                                               *                       LUC109
      *---------------------------------------------------------------*                       LUC109
      *                                                               *                       LUC109
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                       LUC109
      *           Bypass check for PI date against last availablity   *                       LUC109
      *           date.                                               *                       LUC109
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
