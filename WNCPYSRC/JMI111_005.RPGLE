      *****************************************************************
      *                                                               *
      *  Midas - GL Module                                            *
      *                                                               *
      *  JMI111_005 - GLVIMAC                                         *
      *                                                               *
      *  (C) Copyright Finastra Internatonal Limited 2018             *
      *                                                               *
      *  Last Amend No. JMI111 *CREATE     Date 18May18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI111 - Midas-OPICS Interface. Upgrade to FBM 2.1           *
      *                                                               *
      *****************************************************************
      *                                                                                       JMI111
      ** Access the switchable features file, to see if the feature                           JMI111
      ** JMI111 is on.                                                                        JMI111
     C                   CALL      'AOSARDR0'                                                 JMI111
     C                   PARM      *BLANKS       PRTCD                                        JMI111
     C                   PARM      '*VERIFY'     POPTN                                        JMI111
     C                   PARM      'JMI111'      PSARD                                        JMI111
     C     SCSARD        PARM      SCSARD        DSFDY                                        JMI111
      *                                                                                       JMI111
     C                   IF        PRTCD = *BLANKS                                            JMI111
     C                   MOVE      'Y'           JMI111            1                          JMI111
     C                   ELSE                                                                 JMI111
     C                   MOVE      'N'           JMI111                                       JMI111
     C                   ENDIF                                                                JMI111
      *                                                                                       JMI111
      ** End of /COPY JMI111_005                                       *                      JMI111
      *                                                                                       JMI111
