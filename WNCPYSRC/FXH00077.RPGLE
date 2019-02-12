      *****************************************************************
      *  Start of /COPY FXH00077                                      *
      *****************************************************************
      *                                                               *
      *  Last Amend No. LUC110  *Create    Date 07Feb19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *                                                               *
      *****************************************************************
      *
     C                   MOVE      'N'           LUC110            1            LUC110
     C                   CALLB     'AOSARDR0'                                   LUC110
     C                   PARM      *BLANKS       @RTCD                          LUC110
     C                   PARM      '*VERIFY '    @OPTN                          LUC110
     C                   PARM      'LUC110'      @SAR              6            LUC110
     C     SCSARD        PARM      SCSARD        DSFDY                          LUC110
      *                                                                         LUC110
     C     @RTCD         IFEQ      *BLANK                                       LUC110
     C                   MOVE      'Y'           LUC110                         LUC110
     C                   ENDIF                                                  LUC110
      *
      *****************************************************************
      *  End of /COPY FXH00077                                        *
      *****************************************************************
