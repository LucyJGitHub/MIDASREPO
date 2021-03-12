      *****************************************************************
      *                                                               *
      *  Midas - General Ldeger Module                                *
      *                                                               *
      *  GL0420CP50 - BALANCE STATEMENTS (A/C FORMATS)                *
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
     C     MATCH         READE     APOST                                1515    LUC133
     C                   ELSE                                                         
     C     MATCH         READE     APOSTVB                              1515    LUC133
     C                   ENDIF                                                        
      *
      *****************************************************************
      * End of /COPY GL0420CP50                                       *
      *****************************************************************
