      *****************************************************************                       CDL091
      *                                                               *                       CDL091
      *  Midas - /COPY Member (RPG)                                   *                       CDL091
      *                                                               *                       CDL091
      *  CDL091_008 - /Copy for FXVEXCHVAM (C-Specs)                  *                       CDL091
      *                                                               *                       CDL091
      *  Last Amend No. CDL091    *CREATE  Date 12Dec12               *                       CDL091
      *                                                               *                       CDL091
      *---------------------------------------------------------------*                       CDL091
      *                                                               *                       CDL091
      *  CDL091 - FX Auto Calculation (GIB016)                        *                       CDL091
      *                                                               *                       CDL091
      *****************************************************************                       CDL091
     C                   IF        CDL091 = 'Y'                                               CDL091
     C     W@INRT        IFEQ      *ZERO                                                      CDL091
     C     @@INRT        OREQ      *ZERO                                                      CDL091
     C     @SPOT1        OREQ      *ZERO                                                      CDL091
     C     @SPOT2        OREQ      *ZERO                                                      CDL091
     C                   RETURN                                                               CDL091
     C                   ENDIF                                                                CDL091
                                                                                              CDL091
     C                   ELSE                                                                 CDL091
                                                                                              CDL091
      *****************************************************************                       CDL091
      * End of /COPY CDL091_008                                                               CDL091
      *****************************************************************                       CDL091
