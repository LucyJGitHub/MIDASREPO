      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTH00061   - Call XXPREFV0                                   *
      *                                                               *
      *  (C) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. JMI106 *Create     Date 14Feb20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI106 - Split FT Sequence Number based on Settlement Type   *
      *           (Upgrade to FB Midas)                               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                                                       JMI106
     C                   IF        JMI106 = 'Y'                                               JMI106
      *                                                                                       JMI106
     C                   Eval      UPSEQ = '00001'                                            JMI106
     C                   Eval      DPSEQ = PRNUM                                              JMI106
     C                   Move      SSTTP         DSTMT                                        JMI106
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
     C                   If        @Retrn <> *Blanks                                          JMI106
     C                   Movel     'XXPREFV0'    DBFILE                                       JMI106
     C                   Movel     '005'         DBASE                                        JMI106
     C                   Movel     '*CALL     '  DBKEY                                        JMI106
     C                   Exsr      *PSSR                                                      JMI106
     C                   Endif                                                                JMI106
                                                                                              JMI106
     C                   Eval      PRNUM = DPSEQ                                              JMI106
                                                                                              JMI106
     C                   Endif                                                                JMI106
      *                                                                                       JMI106
      *****************************************************************                       JMI106
      * End of /COPY FTH00061                                         *                       JMI106
      *****************************************************************                       JMI106
