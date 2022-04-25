      *****************************************************************
      *                                                               *
      *  Midas - FT Module                                            *
      *                                                               *
      *  JMI111_013 - ZAGENBTCHN                                      *
      *                                                               *
      *  (C) Copyright Finastra Internatonal Limited 2018             *
      *                                                               *
      *  Last Amend No. MD058332           Date 19Apr22               *
      *  Prev Amend No. JMI111 *CREATE     Date 18May18               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058332 - OPICS transactions could not be inserted in       *
      *             FBM as the batch number reached # 999.            *
      *             Amend to prevent looping and pass return code     *
      *             properly.                                         *
      *  JMI111 - Midas-OPICS Interface. Upgrade to FBM 2.1           *
      *                                                               *
      *****************************************************************
      *                                                                                       JMI111
     C                   EVAL      UPSEQ = '00001'                                            JMI111
     C                   EVAL      D#FRNT =  %SUBST(PFRNT:1:5)                                JMI111
     C                   EVAL      D#BTNB =  WBTNB                                            JMI111
     C     XBTNB         IFEQ      999                                                      MD058332
     C     WBTNB         ANDEQ     *ZERO                                                    MD058332
     C                   EVAL      D#BTNB =  XBTNB                                          MD058332
     C                   ENDIF                                                              MD058332
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
     C     D#BTNB        IFNE      XBTNB                                                    MD058332
     C     WBTNB         ANDEQ     *ZERO                                                    MD058332
     C                   EVAL      WBTNB  =  D#BTNB                                           JMI111
     C                   ENDIF                                                              MD058332
     C                   EVAL      PERRORFLAG = @RETRN                                      MD058332
      *                                                                                       JMI111
      ** End of /COPY JMI111_013                                       *                      JMI111
      *                                                                                       JMI111
