      *****************************************************************
      *                                                               *
      *  Midas - FT Module                                            *
      *                                                               *
      *  JMI111_014 - ZAGENBTCHN                                      *
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
     C                   EVAL      UPSEQ = '00002'                                            JMI111
     C                   EVAL      D#FRNT =  %SUBST(PFRNT:1:5)                                JMI111
     C                   EVAL      D#WIDX =  WIDX                                             JMI111
                                                                                              JMI111
     C                   CALL      'XXGENBTCHN'                                               JMI111
     C                   PARM      'I'           @ACTN             1                          JMI111
     C                   PARM                    DATA2                                        JMI111
     C                   PARM                    DATAI                                        JMI111
     C                   PARM                    DATAF1                                       JMI111
     C                   PARM                    DATAF2                                       JMI111
     C                   PARM                    DATAF3                                       JMI111
     C                   PARM                    DATAF4                                       JMI111
     C                   PARM      *BLANKS       @RETRN            7                          JMI111
                                                                                              JMI111
     C                   EVAL      WIDX   =  D#WIDX                                           JMI111
     C                   EVAL      WBTNB  =  D#WIDX                                           JMI111
     C                   EVAL      PERRORFLAG = @RETRN                                        JMI111
      *                                                                                       JMI111
      ** End of /COPY JMI111_014                                       *                      JMI111
      *                                                                                       JMI111
