      *****************************************************************
      *  Start of /COPY GL0600CP22                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. LUC110  *CREATE    Date 24Jan19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *                                                               *
      *****************************************************************
      *                                                                                   
     C     LUC110        Ifeq      'Y'                                                    
      *                                                                                   
     C                   Move      BRCDP         GBRCA                                    
     C                   Move      CNUM          GCNUM                                    
     C                   Move      CCY           GCCY                                     
     C                   Move      ACOD          GACOD                                    
     C                   Move      ACSQ          GACSQ                                    
     C                   Move      PSTD          GPSTD                                    
     C                   Move      VALD          GVALD                                    
     C                   Move      ZZ009         GUNQK                                    
      *                                                                                   
     C                   Move      *BLANK        GNAR1                                    
     C                   Move      *BLANK        GNAR2                                    
     C                   Move      *BLANK        GNAR3                                    
      *                                                                                   
     C     *IN88         Ifeq      '1'                                                    
     C     GEKEY         Chain     SACPOX                             15                  
     C   88                                                                               
     CAN U5              Except    EXCPT4X                                                
     C                   Endif                                                            
      *                                                                                   
     C                   Endif                                                            
      *                                                                                   
      *****************************************************************
      *  End of /COPY GL0600CP22                                      *
      *****************************************************************
