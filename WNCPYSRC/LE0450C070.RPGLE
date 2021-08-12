      *****************************************************************
      *                                                               *
      *  LE0450C070 - LE0450 - Call AOSARDR0                          *
      *                                                               *
      *  Last Amend No. LUC125   *Create   Date 14Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC125 - Make profit center pass through from transaction    *
      *           (Upgrade pf A66108)                                 *
      *                                                               *
      *****************************************************************
      *                                                                                       LUC125
     C                   CALL      'AOSARDR0'                                                 LUC125
     C                   PARM      *BLANKS       @RTCD                                        LUC125
     C                   PARM      '*VERIFY'     @OPTN                                        LUC125
     C                   PARM      'LUC125'      @SARD             6                          LUC125
     C     SCSARD        PARM      SCSARD        DSFDY                                        LUC125
      *                                                                                       LUC125
     C     @RTCD         IFEQ      *BLANKS                                                    LUC125
     C                   MOVEL     'Y'           LUC125            1                          LUC125
     C                   ELSE                                                                 LUC125
     C                   MOVE      'N'           LUC125                                       LUC125
     C                   ENDIF                                                                LUC125
      *                                                                                       LUC125
      *****************************************************************                       LUC125
      * End of /COPY LE0450C070                                       *                       LUC125
      *****************************************************************                       LUC125
      *                                                                                       LUC125
