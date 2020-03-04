      *---------------------------------------------------------------*
      *                                                               *
      *  Last Amend No. JMI113             Date 19Feb20               *
      *  Prev Amend No. JMI106 *CREATE     Date 24May18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI113 - Midas-GCMS Interface. Upgrade to FBM 2.1            *
      *  JMI106 - Split FT Sequence Number based on Settlement Type   *
      *           (Upgrade to FB Midas)                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                                                       JMI106
      ** JMI106 - SWIFT Feature                                                               JMI106
      *                                                                                       JMI106
     C                   MOVE      'N'           JMI106            1                          JMI106
     C                   CALL      'AOSARDR0'                                                 JMI106
     C                   PARM      *BLANKS       PRtCd                                        JMI106
     C                   PARM      '*VERIFY'     POptn                                        JMI106
     C                   PARM      'JMI106'      PSard                                        JMI106
     C     SCSARD        PARM      SCSARD        DSFDY                                        JMI106
      *                                                                                       JMI106
      ** An NRF (No Record Found) return code is valid.                                       JMI106
      ** Issue database error only for error return codes.                                    JMI106
      *                                                                                       JMI106
     C                   IF        PRtCd <> *BLANKS AND                                       JMI106
     C                             PRtCd <> '*NRF   '                                         JMI106
     C                   EVAL      DBKEY = 'JMI106'                                           JMI106
     C                   EVAL      DBFILE = 'SCSARDPD'                                        JMI106
     C                   Z-ADD     907           DBASE                                        JMI106
     C                   EXSR      *PSSR                                                      JMI106
     C                   ENDIF                                                                JMI106
      *                                                                                       JMI106
     C                   IF        PRtCd = *BLANKS                                            JMI106
     C                   EVAL      JMI106 = 'Y'                                               JMI106
     C                   ENDIF                                                                JMI106
      *                                                                                       JMI106
      ** JMI113                                                                               JMI113
      *                                                                                       JMI113
     C                   MOVE      'N'           JMI113            1                          JMI113
     C                   CALL      'AOSARDR0'                                                 JMI113
     C                   PARM      *BLANKS       PRtCd                                        JMI113
     C                   PARM      '*VERIFY'     POptn                                        JMI113
     C                   PARM      'JMI113'      PSard                                        JMI113
     C     SCSARD        PARM      SCSARD        DSFDY                                        JMI113
      *                                                                                       JMI113
     C                   IF        PRtCd = *BLANKS                                            JMI113
     C                   EVAL      JMI113 = 'Y'                                               JMI113
     C                   ENDIF                                                                JMI113
