      *****************************************************************
      *  Start of /COPY GL0420CP59                                    *
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
      *                                                                                             
      *  For Posting records (*IN06 *ON), output up to                                              
      *  three lines for the 35 character Extended Narratives                                       
      *  if they are present on the Extension file.                                                 
      *                                                                                             
      *  For Rate Change records (*IN04 *ON), output only the                                       
      *  standard one line 30 character posting narrative (PNAR).                                   
      *                                                                                             
     C                   Move      *IN86         SAV86             1                                
     C                   Setoff                                           86                        
      *                                                                                             
     C     ACNO          Ifne      0                                                                
     C     APXKEY        Chain     XXAPOSY1                           86                            
     C                   Endif                                                                      
      *                                                                                             
B1   C     *In86         Ifeq      '0'                                                              
      *                                                                                             
      *  Narrative Line 1. ----------------------------------------------                           
      *                                                                                             
B2   C     *In06         Ifeq      '1'                                                              
B3   C     PNAR          Ifeq      *Blanks                                                          
     C                   Movel     GNAR1         PNAR                                               
E3   C                   Endif                                                                      
B3   C     GNAR1         Ifeq      *Blanks                                                          
     C                   Movel     PNAR          GNAR1                                              
E3   C                   Endif                                                                      
E2   C                   Endif                                                                      
      *                                                                                             
B2   C     *IN04         Ifeq      '1'                                                              
     C                   Movel     PNAR          GNAR1                                              
     C                   Move      '     '       GNAR1                                              
E2   C                   Endif                                                                      
      *                                                                                             
     C                   Setoff                                       0953                          
      *                                                                                             
      *  Narrative Line 2 (for Posting Details only.) -------------------                           
      *                                                                                             
B2   C     *IN06         Ifeq      '1'                                                              
     C     GNAR2         andne     *Blanks                                                          
     C                   Move      '1'           *In53                                              
E2   C                   Endif                                                                      
      *                                                                                             
      *  Narrative Line 3 (for Posting Details only.) -------------------                           
      *                                                                                             
B2   C     *IN06         Ifeq      '1'                                                              
     C     GNAR3         andne     *Blanks                                                          
     C                   Move      '1'           *In09                                              
E2   C                   Endif                                                                      
      *                                                                                             
X1   C                   Else                                                                       
      *                                                                                             
     C                   Setoff                                       0953                          
      *                                                                                             
      * SETOF 09 53 to not print 2nd and 3rd lines if no extended                                   
      * narratives exist.                                                                           
     C                   Move      *Blanks       GNAR1                                              
     C                   Movel     PNAR          GNAR1                                              
     C                   Move      *Blanks       GNAR2                                              
     C                   Move      *Blanks       GNAR3                                              
E1   C                   Endif                                                                      
      **                                                                                            
     C                   Move      Sav86         *In86                                              
     C                   Endif                                                                      
      **                                                                                            
      *****************************************************************
      *  End of /COPY GL0420CP59                                      *
      *****************************************************************
