      *****************************************************************
      *  Start of /COPY LUC123_002                                    *
      *****************************************************************
      *                                                               *
      *  LUC123_002 - GLVIMAC - Call AOSARDR0                         *
      *                                                               *
      *  Last Amend No. LUC123  *CREATE    Date 18Jun19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC123 - Extend Customer De-Activation (CSD025) to GL and LE *
      *                                                               *
      *****************************************************************
      *
     C                   MOVE      'N'           LUC123            1
     C                   CallB     'AOSARDR0'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*VERIFY '    POPTN
     C                   Parm      'LUC123'      PSARD             6
      *
     C     PRTCD         Ifeq      *Blank
     C                   Move      'Y'           LUC123
     C                   Endif
      *
      *****************************************************************
      *  End of /COPY LUC123_002                                      *
      *****************************************************************
