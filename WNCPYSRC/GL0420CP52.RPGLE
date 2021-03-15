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
      */OMITEND                                                                       
      *                                                                               
     C     LUC133        IFEQ      'N'                                                
     C     MATCH         SETLL     APOST                                              
     C                   ELSE                                                         
     C     MATCH         SETLL     APOSTVB                                            
     C                   ENDIF                                                        
      *
      *****************************************************************
      * End of /COPY GL0420CP52                                       *
      *****************************************************************
