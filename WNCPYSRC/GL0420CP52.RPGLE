      *****************************************************************
      *                                                               *
      *  Midas - General Ldeger Module                                *
      *                                                               *
      *  GL0420CP52 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  Last Amend No. LUC133  *CREATE    DATE 01Aug19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC133 - Amendments to Statement of Account feature SpA      *
      *                                                               *
      *****************************************************************
      */OMITEND                                                                 LUC133
      *                                                                         LUC133
     C     LUC133        IFEQ      'N'                                          LUC133
     C     MATCH         SETLL     APOST                                        LUC133
     C                   ELSE                                                   LUC133
     C     MATCH         SETLL     APOSTVB                                      LUC133
     C                   ENDIF                                                  LUC133
      *
      *****************************************************************
      * End of /COPY GL0420CP52                                       *
      *****************************************************************
