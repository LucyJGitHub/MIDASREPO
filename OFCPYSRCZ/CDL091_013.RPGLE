      *****************************************************************                       CDL091
      *                                                               *                       CDL091
      *  Midas - /COPY Member (RPG)                                   *                       CDL091
      *                                                               *                       CDL091
      *  CDL091_013 - /Copy for FXFXDLVAL (C-Specs)                   *                       CDL091
      *                                                               *                       CDL091
      *  Last Amend No. CDL091    *CREATE  Date 12Dec12               *                       CDL091
      *                                                               *                       CDL091
      *---------------------------------------------------------------*                       CDL091
      *                                                               *                       CDL091
      *  CDL091 - FX Auto Calculation (GIB016)                        *                       CDL091
      *                                                               *                       CDL091
      *****************************************************************                       CDL091
     C                   IF        CDL091 = 'Y'                                               CDL091
     C                   IF        DDBAMT = *BLANKS                                           CDL091
      *                                                                                       CDL091
     C                   CALLB     'ZA0920'                                                   CDL091
     C                   PARM      *BLANK        @@RETC           10                          CDL091
     C                   PARM      F3DAM1        @@AMTW           13 0                        CDL091
     C                   PARM      @CDP1         @@QECN            1 0                        CDL091
     C                   PARM                    BNDCSP            1                          CDL091
     C                   PARM      *BLANK        @@AMTD           14                          CDL091
      *                                                                                       CDL091
     C                   EVAL      DDBAMT = @@AMTD                                            CDL091
      *                                                                                       CDL091
     C                   ENDIF                                                                CDL091
     C                   IF        DDSAMT = *BLANKS                                           CDL091
      *                                                                                       CDL091
     C                   CALLB     'ZA0920'                                                   CDL091
     C                   PARM      *BLANK        @@RETC           10                          CDL091
     C                   PARM      F3DAM2        @@AMTW           13 0                        CDL091
     C                   PARM      @CDP2         @@QECN            1 0                        CDL091
     C                   PARM                    BNDCSP            1                          CDL091
     C                   PARM      *BLANK        @@AMTD           14                          CDL091
      *                                                                                       CDL091
     C                   EVAL      DDSAMT = @@AMTD                                            CDL091
      *                                                                                       CDL091
     C                   ENDIF                                                                CDL091
     C                   ENDIF                                                                CDL091
                                                                                              CDL091
      *****************************************************************                       CDL091
      * End of /COPY CDL091_013                                                               CDL091
      *****************************************************************                       CDL091
