      *****************************************************************
      *                                                               *
      *  Midas - General Ldeger Module                                *
      *                                                               *
      *  GL0420CP56 - BALANCE STATEMENTS (A/C FORMATS)                *
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
     C     LUC133        IFEQ      'N'                                                        LUC133
     C     MATCH         SETGT     APOST                                                      LUC133
     C                   SETOFF                                         11                    LUC133
     C                   READP     APOST                                1515                  LUC133
     C                   ELSE
     C     MATCH         SETGT     APOSTVB                                                    LUC133
     C                   SETOFF                                         11                    LUC133
     C                   READP     APOSTVB                              1515                  LUC133
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL0420CP56                                       *
      *****************************************************************
