      *****************************************************************                       CDL091
      *                                                               *                       CDL091
      *  Midas - /COPY Member (RPG)                                   *                       CDL091
      *                                                               *                       CDL091
      *  CDL091_005 - /Copy for FXVBSAMTS  (C-Specs)                  *                       CDL091
      *                                                               *                       CDL091
      *  Last Amend No. CDL091    *CREATE  Date 12Dec12               *                       CDL091
      *                                                               *                       CDL091
      *---------------------------------------------------------------*                       CDL091
      *                                                               *                       CDL091
      *  CDL091 - FX Auto Calculation (GIB016)                        *                       CDL091
      *                                                               *                       CDL091
      *****************************************************************                       CDL091
                                                                                              CDL091
     C                   ENDIF                                                                CDL091
                                                                                              CDL091
     C                   IF        (CDL091 = 'Y') AND                                         CDL091
     C                             (DDBAMT = *BLANKS) AND                                     CDL091
     C                             (DDSAMT = *BLANKS)                                         CDL091
     C                   MOVE      'N'           DDBamtOK                                     CDL091
     C                   MOVE      'N'           DDSamtOK                                     CDL091
     C                   ADD       1             Idx                                          CDL091
     C                   MOVEL     'DDBAMT'      FldNamXAr(Idx)                               CDL091
     C                   MOVEL     'FXG0001'     MsgIdXAr(Idx)                                CDL091
     C                   ENDIF                                                                CDL091
                                                                                              CDL091
      *****************************************************************                       CDL091
      * End of /COPY CDL091_005                                                               CDL091
      *****************************************************************                       CDL091
