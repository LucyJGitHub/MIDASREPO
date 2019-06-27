      *****************************************************************
      *  Start of /COPY LUC123_002                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_002 - GLVIMAC - Call AOSARDR0                         *
      *                                                               *
      *  Last Amend No. LUC123  *Create    Date 18Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC123 - Extend Customer De-Activation (CSD025) to GL and LE *
      *                                                               *
      *****************************************************************
      *
     C                   MOVE      'N'           LUC123            1            LUC123
     C                   CallB     'AOSARDR0'                                   LUC123
     C                   Parm      *BLANKS       PRTCD                          LUC123
     C                   Parm      '*VERIFY '    POPTN                          LUC123
     C                   Parm      'LUC123'      PSARD             6            LUC123
      *                                                                         LUC123
     C     PRTCD         Ifeq      *Blank                                       LUC123
     C                   Move      'Y'           LUC123                         LUC123
     C                   Endif                                                  LUC123
      *
      *****************************************************************
      *  End of /COPY LUC123_002                                      *
      *****************************************************************
