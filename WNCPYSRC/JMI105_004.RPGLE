      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  JMI105_004 - (/COPY Name)                                    *
      *                                                               *
      *  Last Amend No. JMI105   *CREATE   Date 12May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI105 - Validate Subtype and Settle/Pay Ccy combination     *
      *                                                               *
      *****************************************************************
      ** Start of /COPY JMI105_004
      *****************************************************************
      *
      *****************************************************************                       JMI105
      /EJECT                                                                                  JMI105
      *****************************************************************                       JMI105
      * VPCYCOM - Validate Subtype and Settle/Pay CCY Combination                             JMI105
      *****************************************************************                       JMI105
     C     VPCYCOM       BEGSR                                                                JMI105
      *                                                                                       JMI105
     C                   If        DDSMCY <> *blanks or                                       JMI105
     C                             DDPCCY <> *blanks                                          JMI105
      *                                                                                       JMI105
     C                   If        DDSMCY <> DDPCCY and                                       JMI105
     C                             DDPYST = 'NE'  or                                          JMI105
     C                             DDSMCY = DDPCCY and                                        JMI105
     C                             DDPYST = 'EX'                                              JMI105
     C                   Eval      OKPyst = 'N'                                               JMI105
     C                   Eval      Idx = Idx + 1                                              JMI105
     C                   Eval      FldNamXAr(Idx) = 'DDPYST'                                  JMI105
     C                   Eval      MsgIdXAr(Idx) = 'XXX9010'                                  JMI105
     C                   EndIf                                                                JMI105
      *                                                                                       JMI105
     C                   EndIf                                                                JMI105
      *                                                                                       JMI105
     C                   EndSr                                                                JMI105
      *
      *****************************************************************
      ** End of /COPY JMI105_004
      *****************************************************************
