      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL04204C45 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
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
     C     LUC133        IFEQ      'Y'
     C   43
     CAN 22
     CANN04PSCR          ADD       PSTA          PSCR
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL04204C45                                       *
      *****************************************************************
