      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420CP47 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Finastra International Limited 2016                      *
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
     CAN 23
     CANN04PSDR          ADD       PSTA          PSDR
     C                   ENDIF
      *
     C     LUC133        IFEQ      'Y'
     C   43
     CAN 23
     CANN04PSDR          ADD       PSTA          PSDR
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL0420CP47                                       *
      *****************************************************************
