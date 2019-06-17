      *****************************************************************
      *                                                               *
      *  Midas - FT Module                                            *
      *                                                               *
      *  FTH00379 -                                                   *
      *                                                               *
      *  (C) Copyright Midas-Kapiti International Ltd. 2018           *
      *                                                               *
      *  Last Amend No. JMI107 *CREATE     Date 14May18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI107 - JMI025 upgrade. RTS Bank Code Enhancement           *
      *                                                               *
      *****************************************************************

      *                                                                                       JMI107
     C                   Eval      JMI107 = 'N'                                               JMI107
      *                                                                                       JMI107
     C                   CALLB     'AOSARDR0'                                                 JMI107
     C                   Parm      *BLANKS       @RTCD                                        JMI107
     C                   Parm      '*VERIFY'     @OPTN                                        JMI107
     C                   Parm      'JMI107'      @SARD                                        JMI107
     C     SCSARD        Parm      SCSARD        DSFDY                                        JMI107
      *                                                                                       JMI107
     C                   If        @RTCD <> *Blanks and                                       JMI107
     C                             @RTCD <> '*NRF   '                                         JMI107
     C     *LOCK         In        LDA                                                        JMI107
     C                   Movel     'SCSARDPD'    DBFILE                                       JMI107
     C                   Movel     '905'         DBASE                                        JMI107
     C                   Movel     'JMI107'      DBKEY                                        JMI107
     C                   Out       LDA                                                        JMI107
     C                   Exsr      *PSSR                                                      JMI107
     C                   EndIf                                                                JMI107
      *                                                                                       JMI107
     C                   If        @RTCD = *Blanks                                            JMI107
     C                   Eval      JMI107 = 'Y'                                               JMI107
     C                   EndIf                                                                JMI107

