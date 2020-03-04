      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAYRC05 - Call AOSARDR0                                   *
      *                                                               *
      *  (C) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. JMI106 *Create     Date 14Feb20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI106 - Split FT Sequence Number based on Settlement Type   *
      *           (Upgrade to FB Midas)                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                                                       JMI106
     C                   Move      'N'           JMI106            1                          JMI106
     C                   Call      'AOSARDR0'                                                 JMI106
     C                   Parm      *Blanks       @RtCd                                        JMI106
     C                   Parm      '*VERIFY'     @Optn                                        JMI106
     C                   Parm      'JMI106'      @Sard                                        JMI106
     C     SCSARD        Parm      SCSARD        DSFDY                                        JMI106
      *                                                                                       JMI106
     C                   If        PRtCd = *Blanks                                            JMI106
     C                   Eval      JMI106 = 'Y'                                               JMI106
     C                   Endif                                                                JMI106
      *                                                                                       JMI106
      *****************************************************************                       JMI106
      * End of /COPY FTOPAYRC05                                       *                       JMI106
      *****************************************************************                       JMI106
