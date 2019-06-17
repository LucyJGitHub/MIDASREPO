      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. JMI106 *CREATE     Date 24May18               *
      *  Prev Amend No. nnnnnn             Date ddmmmnn               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI106 - Split FT Sequence Number based on Settlement Type   *
      *           (Upgrade to FB Midas)                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                                                       JMI106
      ** JMI106 - SWIFT Feature                                                               JMI106
      *                                                                                       JMI106
     C                   Move      'N'           JMI106            1                          JMI106
     C                   Call      'AOSARDR0'                                                 JMI106
     C                   Parm      *BLANKS       @RTCD                                        JMI106
     C                   Parm      '*VERIFY'     @OPTN                                        JMI106
     C                   Parm      'JMI106'      @SARD                                        JMI106
     C     SCSARD        Parm      SCSARD        DSFDY                                        JMI106
      *                                                                                       JMI106
     C                   IF        @RTCD = *BLANKS                                            JMI106
     C                   Eval      JMI106 = 'Y'                                               JMI106
     C                   EndIF                                                                JMI106
      *                                                                                       JMI106
