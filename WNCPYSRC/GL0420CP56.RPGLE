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
     C     LUC133        IFEQ      'N'                                                              
     C     MATCH         SETGT     APOST                                                            
     C                   SETOFF                                         11                          
     C                   READP     APOST                                1515                        
     C                   ELSE
     C     MATCH         SETGT     APOSTVB                                                          
     C                   SETOFF                                         11                          
     C                   READP     APOSTVB                              1515                        
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL0420CP56                                       *
      *****************************************************************
