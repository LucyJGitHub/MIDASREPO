      *****************************************************************
      *                                                               *
      *  Midas - GL Module                                            *
      *                                                               *
      *  JMI116_002 - GLBITHVAL                                       *
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
     C                   IF        JMI116 = 'Y'                                               JMI116
      *                                                                                       JMI116
     C     *LOVAL        SETLL     XXRBNOL0                                                   JMI116
     C                   READ      XXRBNOL0                               01                  JMI116
      *                                                                                       JMI116
     C     *IN01         DOWEQ     *OFF                                                       JMI116
      *                                                                                       JMI116
     C                   CALL      'XX116003'                                                 JMI116
     C                   PARM      DDBTNB        WBTNB             3                          JMI116
     C                   PARM      XSBTNB        WSBTNB            3                          JMI116
     C                   PARM      XEBTNB        WEBTNB            3                          JMI116
     C                   PARM      ' '           WRANGEOK          1                          JMI116
      *                                                                                       JMI116
B1   C     WRANGEOK      IFEQ      'Y'                                                        JMI116
     C     XENABL        ANDEQ     'ENABLED'                                                  JMI116
      *                                                                                       JMI116
      * Front Office                                                                          JMI116
     C                   MOVE      ' '           XFOIDOK           1                          JMI116
      *                                                                                       JMI116
      * If not empty and FOID is not populated, reject                                        JMI116
      * This covers manual batch input - XFOID must be blank                                  JMI116
B2   C     XFOID         IFNE      *BLANKS                                                    JMI116
     C     FOTRID        ANDEQ     *BLANKS                                                    JMI116
     C                   MOVE      'N'           XFOIDOK                                      JMI116
E2   C                   ENDIF                                                                JMI116
      *                                                                                       JMI116
      * If empty and FOID is populated, reject                                                JMI116
      * This covers API input - XFOID must not be blank                                       JMI116
B2   C     XFOID         IFEQ      *BLANKS                                                    JMI116
     C     FOTRID        ANDNE     *BLANKS                                                    JMI116
     C                   MOVE      'N'           XFOIDOK                                      JMI116
E2   C                   ENDIF                                                                JMI116
      *                                                                                       JMI116
      * If not empty and FOID is populated, check value matches that allowed                  JMI116
B2   C     XFOID         IFNE      *BLANKS                                                    JMI116
     C     FOTRID        ANDNE     *BLANKS                                                    JMI116
      *                                                                                       JMI116
      * If *ANY, accept anything                                                              JMI116
B3   C     XFOID         IFEQ      '*ANY'                                                     JMI116
     C                   MOVE      'Y'           XFOIDOK                                      JMI116
E3   C                   ENDIF                                                                JMI116
      *                                                                                       JMI116
      * If a criterion is set, search for it                                                  JMI116
     C                   Z-ADD     0             WIDX                                         JMI116
B3   C     XFOID         IFNE      '*ANY'                                                     JMI116
      *                                                                                       JMI116
     C                   CALL      'XX116002'                                                 JMI116
     C                   PARM      XFOID         WSRCH            20                          JMI116
     C                   PARM      FOTRID        WSTRN            20                          JMI116
     C                   PARM      0             WIDX                                         JMI116
B4   C     WIDX          IFEQ      1                                                          JMI116
     C                   MOVE      'Y'           XFOIDOK                                      JMI116
     C                   ELSE                                                                 JMI116
     C                   MOVE      'N'           XFOIDOK                                      JMI116
E4   C                   ENDIF                                                                JMI116
      *                                                                                       JMI116
E3   C                   ENDIF                                                                JMI116
     C                                                                                        JMI116
E2   C                   ENDIF                                                                JMI116
      *                                                                                       JMI116
      * Department                                                                            JMI116
      *                                                                                       JMI116
     C                   MOVE      ' '           XDEPTOK           1                          JMI116
      *                                                                                       JMI116
      * If *ANY, accept anything                                                              JMI116
B2   C     XDEPT         IFEQ      '*ANY'                                                     JMI116
     C                   MOVE      'Y'           XDEPTOK                                      JMI116
E2   C                   ENDIF                                                                JMI116
      *                                                                                       JMI116
      * If a criterion is set, search for it                                                  JMI116
     C                   Z-ADD     0             WIDX                                         JMI116
B3   C     XDEPT         IFNE      *BLANKS                                                    JMI116
     C     XDEPT         ANDNE     '*ANY'                                                     JMI116
      *                                                                                       JMI116
     C                   CALL      'XX116002'                                                 JMI116
     C                   PARM      XDEPT         WSRCH                                        JMI116
     C                   PARM      DDDPCD        WSTRN                                        JMI116
     C                   PARM      0             WIDX                                         JMI116
B4   C     WIDX          IFEQ      1                                                          JMI116
     C                   MOVE      'Y'           XDEPTOK                                      JMI116
     C                   ELSE                                                                 JMI116
     C                   MOVE      'N'           XDEPTOK                                      JMI116
E4   C                   ENDIF                                                                JMI116
      *                                                                                       JMI116
E3   C                   ENDIF                                                                JMI116
      *                                                                                       JMI116
B3   C     XFOIDOK       IFEQ      'N'                                                        JMI116
     C                   ADD       1             Idx                                          JMI116
     C                   MOVEL     'DDBTNB'      FldNamXAr(Idx)                               JMI116
     C                   IF        FOTRID = *BLANKS                                           JMI116
     C                   MOVEL     'GLX0512'     MsgIdXAr(Idx)                                JMI116
     C                   ELSE                                                                 JMI116
     C                   MOVEL     'GLX0514'     MsgIdXAr(Idx)                                JMI116
     C                   ENDIF                                                                JMI116
     C                   EXSR      SRUPDERR                                                   JMI116
E3   C                   ENDIF                                                                JMI116
     C                                                                                        JMI116
B3   C     XDEPTOK       IFEQ      'N'                                                        JMI116
     C                   ADD       1             Idx                                          JMI116
     C                   MOVEL     'DDBTNB'      FldNamXAr(Idx)                               JMI116
     C                   MOVEL     'GLX0513'     MsgIdXAr(Idx)                                JMI116
     C                   EXSR      SRUPDERR                                                   JMI116
E3   C                   ENDIF                                                                JMI116
      *                                                                                       JMI116
     C                   LEAVE                                                                JMI116
      *                                                                                       JMI116
B2   C                   ENDIF                                                                JMI116
      *                                                                                       JMI116
     C                   READ      XXRBNOL0                               01                  JMI116
     C                   ENDDO                                                                JMI116
      *                                                                                       JMI116
B1   C                   ENDIF                                                                JMI116
      *                                                                                       JMI116
      ** End of /COPY JMI116_002                                       *                      JMI116
      *                                                                                       JMI116
