      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420CP45 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC133             Date 01Aug19               *
      *  Prev Amend No. LUC108   *CREATE   Date 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC133 - Amendments to Statement of Account feature SpA      *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      *
     C     LUC108        IFEQ      'Y'
     C   41
     CAN 22
     CANN04PSCR          ADD       PSTA          PSCR
     C                   ENDIF
      *
     C     LUC133        IFEQ      'Y'                                          LUC133
     C   43                                                                     LUC133
     CAN 22                                                                     LUC133
     CANN04PSCR          ADD       PSTA          PSCR                           LUC133
     C                   ENDIF                                                  LUC133
      *****************************************************************
      * End of /COPY GL0420CP45                                       *
      *****************************************************************
