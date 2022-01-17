      *****************************************************************                       JMI113
      *                                                               *                       JMI113
      *  Midas - ME1100 - Copy member (RPGLE)                         *                       JMI113
      *                                                               *                       JMI113
      *  JMI113_016 - ME1100                                          *                       JMI113
      *                                                               *                       JMI113
      *  Last Amend No. JMI113  *Create    Date 22May18               *                       JMI113
      *                                                               *                       JMI113
      *---------------------------------------------------------------*                       JMI113
      *                                                               *                       JMI113
      *  JMI113 - Midas-GCMS Interface. Upgrade to FBM 2.1            *                       JMI113
      *                                                               *                       JMI113
      *****************************************************************                       JMI113
      *                                                                                       JMI113
     C     JMI113        WHENEQ    'Y'                                                        JMI113
     C     PRMDS         ANDEQ     'P20 '                                                     JMI113
     C                   MOVEL     DSTRAN        DSIN                                         JMI113
     C                   MOVEL     *BLANK        DSOUT                                        JMI113
     C                   MOVEL     P20           DSOUT                                        JMI113
     C                   EXSR      SRFILL                                                     JMI113
     C                   MOVEL     DSOUT         P20                                          JMI113
      *                                                                                       JMI113
      *****************************************************************                       JMI113
      * End of /COPY JMI113_016                                       *                       JMI113
      *****************************************************************                       JMI113
