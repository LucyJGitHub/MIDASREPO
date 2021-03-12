      *****************************************************************
      *  Start of /COPY GL0420CCP7                                    *
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
     C     APXKEY        KList                                                            
     C                   Kfld                    BRCA                                     
     C                   Kfld                    CNUM                                     
     C                   Kfld                    CCY                                      
     C                   Kfld                    ACOD                                     
     C                   Kfld                    ACSQ                                     
     C                   Kfld                    PSTD                                     
     C                   Kfld                    VALD                                     
     C                   Kfld                    UNQK                                     
      *                                                                                   
     C                   Move      *IN86         SAV86             1                      
     C                   Move      *BLANK        GNAR1                                    
     C                   Move      *BLANK        GNAR2                                    
     C                   Move      *BLANK        GNAR3                                    
      *                                                                                   
     C     ACNO          Ifne      0                                                      
     C     APXKEY        Chain     XXAPOSY1                           86                  
     C                   Endif                                                            
      *                                                                                   
     C                   Move      Sav86         *IN86                                    
      *                                                                                   
     C                   Endif                                                            
      **                                                                                  
      *****************************************************************
      *  End of /COPY GL0420CCP7                                      *
      *****************************************************************
