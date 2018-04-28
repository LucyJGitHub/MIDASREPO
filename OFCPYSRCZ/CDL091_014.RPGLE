      *****************************************************************                       CDL091
      *                                                               *                       CDL091
      *  Midas - /COPY Member (RPG)                                   *                       CDL091
      *                                                               *                       CDL091
      *  CDL091_014 - /Copy for FXFXDLVAL (C-Specs)                   *                       CDL091
      *                                                               *                       CDL091
      *  Last Amend No. CDL091    *CREATE  Date 12Dec12               *                       CDL091
      *                                                               *                       CDL091
      *---------------------------------------------------------------*                       CDL091
      *                                                               *                       CDL091
      *  CDL091 - FX Auto Calculation (GIB016)                        *                       CDL091
      *                                                               *                       CDL091
      *****************************************************************                       CDL091
                                                                                              CDL091
      ** Check if CDL091 is installed                                                         CDL091
                                                                                              CDL091
     C                   CALLB     'AOSARDR0'                                                 CDL091
     C                   PARM      *BLANKS       PRTCD             7                          CDL091
     C                   PARM      '*VERIFY'     POPTN             7                          CDL091
     C                   PARM      'CDL091'      PSARD             6                          CDL091
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL091
                                                                                              CDL091
     C                   IF        PRTCD = *BLANKS                                            CDL091
     C                   EVAL      CDL091 = 'Y'                                               CDL091
     C                   ELSE                                                                 CDL091
     C                   EVAL      CDL091 = 'N'                                               CDL091
     C                   ENDIF                                                                CDL091
      *****************************************************************                       CDL091
      * End of /COPY CDL091_014                                                               CDL091
      *****************************************************************                       CDL091
