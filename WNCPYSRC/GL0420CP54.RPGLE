      *****************************************************************
      *                                                               *
      *  Midas - General Ldeger Module                                *
      *                                                               *
      *  GL0420CP54 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  Last Amend No. LUC133  *CREATE    DATE 01Aug19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC133 - Amendments to Statement of Account feature SpA      *
      *                                                               *
      *****************************************************************
      */OMITEND
      *
     C     LUC133        IFEQ      'N'
     C     MATCH         SETLL     APOST
     C     MATCH         READE     APOST                                1515
     C                   ELSE
     C     MATCH         SETLL     APOSTVB
     C     MATCH         READE     APOSTVB                              1515
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL0420CP54                                       *
      *****************************************************************
