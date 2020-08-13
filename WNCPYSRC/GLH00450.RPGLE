      *****************************************************************
      *                                                               *
      *  Midas - GL Module                                            *
      *                                                               *
      *  GLH00450 - GLBITHVAL                                         *
      *                                                               *
      *  (C) Copyright Finastra Internatonal Limited 2020             *
      *                                                               *
      *  Last Amend No. JMI116 *CREATE     Date 21Jul20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI116 - Reserve Journal Entry Batch Numbers                 *
      *                                                               *
      *****************************************************************
      *                                                                                       JMI116
      ** Access the switchable features file, to see if the feature                           JMI116
      ** JMI116 is on.                                                                        JMI116
     C                   MOVE      'N'           JMI116            1                          JMI116
      *                                                                                       JMI116
     C                   CALL      'AOSARDR0'                                                 JMI116
     C                   PARM      *BLANKS       @RTCD9            7                          JMI116
     C                   PARM      '*VERIFY'     @OPTN             7                          JMI116
     C                   PARM      'JMI116'      @SARD             6                          JMI116
     C     SCSARD        PARM      SCSARD        DSFDY                                        JMI116
      *                                                                                       JMI116
     C                   IF        @RTCD9 = *BLANKS                                           JMI116
     C                   MOVE      'Y'           JMI116                                       JMI116
     C                   OPEN      XXRBNOL0                                                   JMI116
     C                   ELSE                                                                 JMI116
     C                   MOVE      'N'           JMI116                                       JMI116
     C                   ENDIF                                                                JMI116
      *                                                                                       JMI116
      ** End of /COPY GLH00450                                         *                      JMI116
      *                                                                                       JMI116
