      *****************************************************************
      *                                                               *
      *  Midas - General Ldeger Module                                *
      *                                                               *
      *  GL0420C089 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  Last Amend No. LUC133  *CREATE    DATE 01Aug19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC133 - Amendments to Statement of Account feature SpA      *
      *                                                               *
      *****************************************************************
      */OMITEND                                                                               LUC133
      *                                                                                       LUC133
     C     LUC133        IFEQ      'N'                                                        LUC133
     C                   READP     APOST                                1515                  LUC133
     C                   ELSE                                                                 LUC133
     C                   READP     APOSTVB                              1515                  LUC133
     C                   ENDIF                                                                LUC133
      *
      *****************************************************************
      * End of /COPY GL0420C089                                       *
      *****************************************************************
