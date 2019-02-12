      *****************************************************************
      *  Start of /COPY GL0340CCP1                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. LUC110  *Create    Date 23Jan19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *                                                               *
      *****************************************************************
      *                                                                                   LUC110
     C                   Call      'AOSARDR0'                                             LUC110
     C                   Parm      *BLANKS       @RTCD                                    LUC110
     C                   Parm      '*VERIFY'     @OPTN                                    LUC110
     C                   Parm      'LUC110'      @KEY              6                      LUC110
     C                   Parm                    DSFDY                                    LUC110
      *                                                                                   LUC110
     C     @RTCD         Ifeq      *BLANKS                                                LUC110
     C                   Move      'Y'           LUC110            1                      LUC110
     C                   Move      *On           *In24                                    LUC110
     C                   else                                                             LUC110
     C                   Move      'N'           LUC110                                   LUC110
     C                   Move      *Off          *In24                                    LUC110
     C                   Endif                                                            LUC110
      **                                                                                  LUC110
      *****************************************************************
      *  End of /COPY GL0340CCP1                                      *
      *****************************************************************
