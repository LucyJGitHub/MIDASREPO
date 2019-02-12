      *****************************************************************
      *  Start of /COPY GL0600CCP3                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. LUC110  *Create    Date 24Jan19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *                                                               *
      *****************************************************************
      *                                                                                  LUC110
      ** Determine if feature LUC110 is installed.                                       LUC110
      *                                                                                  LUC110
     C                   MOVE      'N'           LUC110            1                     LUC110
     C                   CALL      'AOSARDR0'                                            LUC110
     C                   PARM      *BLANKS       @RTCD                                   LUC110
     C                   PARM      '*VERIFY'     @OPTN                                   LUC110
     C                   PARM      'LUC110'      WSARD                                   LUC110
     C     SCSARD        PARM      SCSARD        DSFDY                                   LUC110
                                                                                         LUC110
     C     @RTCD         IFEQ      *BLANK                                                LUC110
     C                   MOVE      'Y'           LUC110                                  LUC110
     C                   ENDIF                                                           LUC110
      *                                                                                  LUC110
      *****************************************************************
      *  End of /COPY GL0600CCP3                                      *
      *****************************************************************
