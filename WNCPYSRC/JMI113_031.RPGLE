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
     C                   MOVE      PNWRK         DNWRK                                        JMI113
     C                   MOVE      '00003'       UPSEQ3                                       JMI113
      *                                                                                       JMI113
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
     C                   Move      DNWRK         PNWRK                                        JMI113
      *                                                                                       JMI113
     C                   Endif                                                                JMI113
      *                                                                                       JMI113
      *****************************************************************                       JMI113
      * End of /COPY JMI113_031                                       *                       JMI113
      *****************************************************************                       JMI113
      *                                                                                       JMI113
