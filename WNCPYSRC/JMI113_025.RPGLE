      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. JMI113 *Create     Date 19Feb20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI113 - Midas-GCMS Interface. Upgrade to FBM 2.1            *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                                                       JMI113
     C     JMI113        Ifeq      'Y'                                                        JMI113
      *                                                                                       JMI113
      * Related Pay Reference                                                                 JMI113
      *                                                                                       JMI113
     C                   Move      PNWRK         DNWRK                                        JMI113
     C                   Move      PMTPY         DMTPY                                        JMI113
     C                   Move      '00006'       UPSEQ3                                       JMI113
      *                                                                                       JMI113
     C                   Eval      DP20 = P20                                                 JMI113
     C                   CALL      'XXOPAY1SV0'                                               JMI113
     C                   Parm      'I'           @ACTN                                        JMI113
     C                   Parm                    DATA3                                        JMI113
     C                   Parm                    DATAI                                        JMI113
     C                   Parm                    DATAF1                                       JMI113
     C                   Parm                    DATAF2                                       JMI113
     C                   Parm                    DATAF3                                       JMI113
     C                   Parm                    DATAF4                                       JMI113
     C                   Parm      *Blanks       @RETRN                                       JMI113
                                                                                              JMI113
     C                   Move      DSRLPR        SRLPR                                        JMI113
      *                                                                                       JMI113
     C                   Endif                                                                JMI113
      *                                                                                       JMI113
      *****************************************************************                       JMI113
      * End of /COPY JMI113_025                                       *                       JMI113
      *****************************************************************                       JMI113
      *                                                                                       JMI113
