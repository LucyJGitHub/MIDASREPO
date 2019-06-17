      *****************************************************************
      *                                                               *
      *  Midas - GL Module                                            *
      *                                                               *
      *  JMI111_002 - GLVIMAC                                         *
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
     C     JMI111        IFEQ      'Y'                                                        JMI111
      *                                                                                       JMI111
     C                   EVAL      UPSEQ = '00001'                                            JMI111
     C                   EVAL      UPMODE = %SUBST(APFOASOCID:1:5)                            JMI111
     C                   EVAL      D#ACTY= A5ACTY                                             JMI111
     C                   EVAL      P#NRF = PRTCD                                              JMI111
     C                   EVAL      DATAF1 = SDACCT                                            JMI111
      *                                                                                       JMI111
     C                   CALL      'XXVIMAC'                                                  JMI111
     C                   PARM      'I'           @ACTN             1                          JMI111
     C                   PARM                    DATA2                                        JMI111
     C                   PARM                    DATAI                                        JMI111
     C                   PARM                    DATAF1                                       JMI111
     C                   PARM                    DATAF2                                       JMI111
     C                   PARM                    DATAF3                                       JMI111
     C                   PARM                    DATAF4                                       JMI111
     C                   PARM      *BLANKS       @RETRN            7                          JMI111
      *                                                                                       JMI111
     C     UPMODE        IFEQ      'OPICS'                                                    JMI111
     C     P#NRF         ANDNE     *BLANKS                                                    JMI111
     C     D#ACTY        ANDNE     *BLANKS                                                    JMI111
     C     D#ACTY        ANDNE     'R'                                                        JMI111
     C                   Eval      DATAF1 = *BLANKS                                           JMI111
     C                   Eval      F1CLBL   = *ZEROS                                          JMI111
     C                   Eval      F1LDBL   = *ZEROS                                          JMI111
     C                   Eval      F1CCIR   = *ZEROS                                          JMI111
     C                   Eval      F1CDIR   = *ZEROS                                          JMI111
     C                   Eval      F1LMVD   = *ZEROS                                          JMI111
     C                   Eval      F1LTAC   = *ZEROS                                          JMI111
     C                   Eval      F1LTAS   = *ZEROS                                          JMI111
     C                   Eval      F1DITM   = *ZEROS                                          JMI111
     C                   Eval      F1CITM   = *ZEROS                                          JMI111
     C                   Eval      F1DAIC   = *ZEROS                                          JMI111
     C                   Eval      F1CAIC   = *ZEROS                                          JMI111
     C                   Eval      F1ENOC   = *ZEROS                                          JMI111
     C                   Eval      F1EPNO   = *ZEROS                                          JMI111
     C                   Eval      F1ECFB   = *ZEROS                                          JMI111
     C                   Eval      F1ACNO   = *ZEROS                                          JMI111
     C                   Eval      F1RRNM   = *ZEROS                                          JMI111
     C                   Eval      F1ADREF1 = 'B'                                             JMI111
     C                   Eval      F1ATYP   = A5ACTY                                          JMI111
     C                   Eval      DATAF1 = F1ACCT                                            JMI111
      *                                                                                       JMI111
     C                   CLEAR                   SDACCT                                       JMI111
     C                   MOVE      PKCUST        CNUM                                         JMI111
     C                   EVAL      CCY = PKCYCD                                               JMI111
     C                   MOVE      PKACCD        ACOD                                         JMI111
     C                   MOVE      PKACSN        ACSQ                                         JMI111
     C                   EVAL      BRCA = PKBRCD                                              JMI111
     C                   EVAL      CLBL = 0                                                   JMI111
     C                   EVAL      LDBL = 0                                                   JMI111
     C                   EVAL      CCIR = 0                                                   JMI111
     C                   EVAL      CDIR = 0                                                   JMI111
     C                   EVAL      LMVD = 0                                                   JMI111
     C                   EVAL      ADREF1 = *BLANKS                                           JMI111
     C                   EVAL      ADREF2 = *BLANKS                                           JMI111
     C                   MOVEL     'B'           ADREF1                                       JMI111
     C                   EVAL      ACST = ' '                                                 JMI111
     C                   EVAL      ATYP = A5ACTY                                              JMI111
     C                   EVAL      LTAC = 0                                                   JMI111
     C                   EVAL      LTAS = 0                                                   JMI111
     C                   EVAL      ORED = BJRDNB                                              JMI111
     C                   EVAL      DITM = 0                                                   JMI111
     C                   EVAL      CITM = 0                                                   JMI111
     C                   EVAL      DAIC = 0                                                   JMI111
     C                   EVAL      CAIC = 0                                                   JMI111
     C                   EVAL      ENOC = 0                                                   JMI111
     C                   EVAL      EPNO = 0                                                   JMI111
     C                   EVAL      ECFB = 0                                                   JMI111
     C                   EVAL      ACNO = 0                                                   JMI111
     C                   EVAL      RRNM = 0                                                   JMI111
     C                   EVAL      F1RRNM = *ZERO                                             JMI111
     C                   EVAL      F1DACO = *ZERO                                             JMI111
     C                   EVAL      F1LDID = *ZERO                                             JMI111
     C                   EVAL      F1LCID = *ZERO                                             JMI111
     C                   EVAL      STYP   = *BLANKS                                           JMI111
     C                   EVAL      PRTCD  = *BLANKS                                           JMI111
     C                   ENDIF                                                                JMI111
      *                                                                                       JMI111
     C                   ENDIF                                                                JMI111
      ** End of /COPY JMI111_002                                       *                      JMI111
      *                                                                                       JMI111
