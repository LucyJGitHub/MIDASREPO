      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member FTOPAY1VL                               *
      *                                                               *
      *  FTOPA1VC14 - Midas FT Check Enhancement                      *
      *                                                               *
      *  Last Amend No. HUT106  *CREATE    Date 06Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  HUT106 - Upgrade HUT012 to FBM 2.1 SP22                      *
      *           Allow FISC Bank Reference to be entered in SWIFT    *
      *           ID Field.                                           *
      *                                                               *
      *****************************************************************
      *                                                                                       HUT106
     C                   CALL      'AOSARDR0'                                                 HUT106
     C                   PARM      *BLANKS       PRTCD                                        HUT106
     C                   PARM      '*VERIFY'     POPTN             7                          HUT106
     C                   PARM      'HUT106'      PSARD             6                          HUT106
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT106
      *                                                                                       HUT106
     C                   MOVE      ' '           HUT106            1                          HUT106
     C     PRTCD         IFEQ      *BLANKS                                                    HUT106
     C                   MOVE      'Y'           HUT106                                       HUT106
     C                   ENDIF                                                                HUT106
      *                                                                                       HUT106
      *****************************************************************
      * End of /COPY FTOPA1VC14                                       *
      *****************************************************************
