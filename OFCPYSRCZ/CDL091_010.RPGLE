      *****************************************************************                       CDL091
      *                                                               *                       CDL091
      *  Midas - /COPY Member (RPG)                                   *                       CDL091
      *                                                               *                       CDL091
      *  CDL091_010 - /Copy for FXVEXCHVAM (C-Specs)                  *                       CDL091
      *                                                               *                       CDL091
      *  Last Amend No. CDL091    *CREATE  Date 12Dec12               *                       CDL091
      *                                                               *                       CDL091
      *---------------------------------------------------------------*                       CDL091
      *                                                               *                       CDL091
      *  CDL091 - FX Auto Calculation (GIB016)                        *                       CDL091
      *                                                               *                       CDL091
      *****************************************************************                       CDL091
     C                   IF        CDL091 = 'Y' AND                                           CDL091
     C                             (F3DAM1 = 0 OR F3DAM2 = 0)                                 CDL091
                                                                                              CDL091
     C                   IF        @@MDF1 = 'D'                                               CDL091
     C                   EVAL      WSPOT1 = 1/@SPOT1                                          CDL091
     C                   ELSE                                                                 CDL091
     C                   EVAL      WSPOT1 = @SPOT1                                            CDL091
     C                   ENDIF                                                                CDL091
     C                   IF        @@MDF2 = 'D'                                               CDL091
     C                   EVAL      WSPOT2 = 1/@SPOT2                                          CDL091
     C                   ELSE                                                                 CDL091
     C                   EVAL      WSPOT2 = @SPOT2                                            CDL091
     C                   ENDIF                                                                CDL091
                                                                                              CDL091
     C                   IF        F3DAM1 = 0                                                 CDL091
                                                                                              CDL091
      ** Determine Mult/Div Indicator for conversion                                          CDL091
                                                                                              CDL091
     C                   IF        WSPOT1 > WSPOT2                                            CDL091
     C                   IF        W@INRT < 1                                                 CDL091
     C                   MOVE      'M'           MDFLG             1                          CDL091
     C                   ELSE                                                                 CDL091
     C                   MOVE      'D'           MDFLG                                        CDL091
     C                   ENDIF                                                                CDL091
     C                   ELSE                                                                 CDL091
     C                   IF        W@INRT < 1                                                 CDL091
     C                   MOVE      'D'           MDFLG                                        CDL091
     C                   ELSE                                                                 CDL091
     C                   MOVE      'M'           MDFLG                                        CDL091
     C                   ENDIF                                                                CDL091
     C                   ENDIF                                                                CDL091
                                                                                              CDL091
      ** Call ZCONVZ1 to convert amount                                                       CDL091
                                                                                              CDL091
     C                   CALLB     'ZCONVZ1'                                                  CDL091
     C                   PARM      F3DAM2        InputAmnt        15 0                        CDL091
     C                   PARM      W@INRT        ExchRate         13 8                        CDL091
     C                   PARM      MDFLG         MultDivInd        1                          CDL091
     C                   PARM      DDSCCY        FrCurrency        3                          CDL091
     C                   PARM      DDBCCY        ToCurrency        3                          CDL091
     C                   PARM      @CDP2         FrDecPlace        1 0                        CDL091
     C                   PARM      @CDP1         ToDecPlace        1 0                        CDL091
     C                   PARM      *ZERO         OutputAmnt       15 0                        CDL091
                                                                                              CDL091
     C                   EVAL      F3DAM1 = %abs(OutputAmnt)                                  CDL091
                                                                                              CDL091
     C                   ELSEIF    F3DAM2 = 0                                                 CDL091
                                                                                              CDL091
     C                   IF        WSPOT1 > WSPOT2                                            CDL091
     C                   IF        W@INRT < 1                                                 CDL091
     C                   MOVE      'D'           MDFLG                                        CDL091
     C                   ELSE                                                                 CDL091
     C                   MOVE      'M'           MDFLG                                        CDL091
     C                   ENDIF                                                                CDL091
     C                   ELSE                                                                 CDL091
     C                   IF        W@INRT < 1                                                 CDL091
     C                   MOVE      'M'           MDFLG                                        CDL091
     c                   ELSE                                                                 CDL091
     C                   MOVE      'D'           MDFLG                                        CDL091
     C                   ENDIF                                                                CDL091
     C                   ENDIF                                                                CDL091
                                                                                              CDL091
     C                   CALLB     'ZCONVZ1'                                                  CDL091
     C                   PARM      F3DAM1        InputAmnt                                    CDL091
     C                   PARM      W@INRT        ExchRate                                     CDL091
     C                   PARM      MDFLG         MultDivInd                                   CDL091
     C                   PARM      DDBCCY        FrCurrency                                   CDL091
     C                   PARM      DDSCCY        ToCurrency                                   CDL091
     C                   PARM      @CDP1         FrDecPlace                                   CDL091
     C                   PARM      @CDP2         ToDecPlace                                   CDL091
     C                   PARM      *ZERO         OutputAmnt                                   CDL091
                                                                                              CDL091
     C                   EVAL      F3DAM2 = OutputAmnt                                        CDL091
                                                                                              CDL091
     C                   ENDIF                                                                CDL091
                                                                                              CDL091
     C                   GOTO      #ZID9                                                      CDL091
                                                                                              CDL091
     C                   ENDIF                                                                CDL091
      *                                                                                       CDL091
      *****************************************************************                       CDL091
      * End of /COPY CDL091_010                                                               CDL091
      *****************************************************************                       CDL091
