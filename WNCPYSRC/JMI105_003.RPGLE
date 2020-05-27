      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  JMI105_003 - (/COPY Name)                                    *
      *                                                               *
      *  Last Amend No. JMI105   *CREATE   Date 12May20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI105 - Validate Subtype and Settle/Pay Ccy combination     *
      *                                                               *
      *****************************************************************
      ** Start of /COPY JMI105_003
      *****************************************************************
      *
      ** Validate Subtype and Settle/Pay CCY Combination                                      JMI105
      *                                                                                       JMI105
     C                   If        OKPyst <> 'N' and                                          JMI105
     C                             JMI105 = 'Y' and                                           JMI105
     C                             DDPYST <> *Blanks                                          JMI105
     C                   ExSr      VPCYCOM                                                    JMI105
     C                   EndIf                                                                JMI105
      *
      *****************************************************************
      ** End of /COPY JMI105_003
      *****************************************************************
