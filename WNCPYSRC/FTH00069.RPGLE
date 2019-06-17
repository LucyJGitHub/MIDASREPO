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
     C                   IF        JMI106 = 'Y'                                               JMI106
                                                                                              JMI106
     C                   Eval      UPSEQ = '00001'                                            JMI106
     C                   Move      @@P_Ref       DPSEQ                                        JMI106
                                                                                              JMI106
     C                   Call      'XXPREFV0'                                                 JMI106
     C                   Parm      'I'           @ACTN             1                          JMI106
     C                   Parm                    DATA2                                        JMI106
     C                   Parm                    DATAI                                        JMI106
     C                   Parm                    DATAF1                                       JMI106
     C                   Parm                    DATAF2                                       JMI106
     C                   Parm                    DATAF3                                       JMI106
     C                   Parm                    DATAF4                                       JMI106
     C                   Parm      *Blanks       @RETRN            7                          JMI106
                                                                                              JMI106
     C                   If        @RETRN <> *BLANKS                                          JMI106
     C                   Z-ADD     901           DBASE                                        JMI106
     C                   Movel     '*CALL  '     DBKEY                                        JMI106
     C                   Movel     'FTOPAY2RV'   DBFILE                                       JMI106
     C                   EXSR      *PSSR                                                      JMI106
     C                   EndIF                                                                JMI106
                                                                                              JMI106
     C                   Move      DPSEQ         @@P_Ref                                      JMI106
     C                   EndIF                                                                JMI106
                                                                                              JMI106
