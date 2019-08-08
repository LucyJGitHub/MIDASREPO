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
     C     LUC108        IFEQ      'Y'                                          LUC108
     C   41                                                                     LUC108
     CAN 22                                                                     LUC108
     CANN04PSCR          ADD       PSTA          PSCR                           LUC108
     C                   ENDIF                                                  LUC108
      *
     C     LUC133        IFEQ      'Y'                                          LUC133
     C   43                                                                     LUC133
     CAN 22                                                                     LUC133
     CANN04PSCR          ADD       PSTA          PSCR                           LUC133
     C                   ENDIF                                                  LUC133
      *
      *****************************************************************
      * End of /COPY GL04204C45                                       *
      *****************************************************************
