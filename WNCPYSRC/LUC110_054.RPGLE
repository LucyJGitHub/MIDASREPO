      *****************************************************************
      *  Start of /COPY LUC110_054                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. LUC110  *CREATE    Date 23Jan19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *                                                               *
      *****************************************************************
      *                                                                                         
     C     LUC110        Ifeq      'Y'                                                          
     C                   Move      *Blanks       GNAR1                                          
     C                   Move      *Blanks       GNAR2                                          
     C                   Move      *Blanks       GNAR3                                          
     C                   Movel     PNAR          GNAR1                                          
      *                                                                                         
      *   Setup key to access LF/XXACP1Y1 for extended narratives.                              
     C                   Movel     BRCDJ         BRCDJ1                                         
     C                   Movel     CNUMJ         CNUMJ1                                         
     C                   Movel     CCYJ          CCYJ1                                          
     C                   Movel     ACODJ         ACODJ1                                         
     C                   Movel     ACSQJ         ACSQJ1                                         
     C                   Z-Add     PSTD          PSTDJ1                                         
     C                   Z-Add     VALD          VALDJ1                                         
     C                   Movel     UNQK          UNQKJ1                                         
      *                                                                                         
     C                   Move      *IN99         SAVE99            1                            
     C     ACJKY         Chain     XXACP1Y1                           99                        
     C     *IN99         Ifeq      '0'                                                          
     C     GNAR1         Ifeq      *Blanks                                                      
     C                   Movel     PNAR          GNAR1                                          
     C                   Endif                                                                  
     C                   Endif                                                                  
     C                   Move      SAVE99        *IN99                                          
      **                                                                                        
     C                   Endif                                                                  
      **                                                                                        
      *****************************************************************
      *  End of /COPY LUC110_054                                      *
      *****************************************************************
