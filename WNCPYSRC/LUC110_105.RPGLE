      *****************************************************************
      *  Start of /COPY LUC110_105                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. MD055854 *CREATE   Date 15Jun20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055854 - When deleting a batch or batch item from frontend *
      *             the narratives in XXJENPX0 file is not deleted    *
      *             Amend to delete corresponding rec in XXJENPX0.    *
      *                                                               *
      *****************************************************************
      *                                                                                             
      ** Delete batch items in extension file                                                       
      *                                                                                             
     C     LUC110        IFEQ      'Y'                                                              
     C                   SETOFF                                       9899                          
     C     BRBTNB        SETLL     XXJENPY1                           99                            
     C     *IN99         IFEQ      *OFF                                                             
     C     BRBTNB        READE     XXJENPY1                               98                        
      *                                                                                             
     C     *IN98         DOWEQ     *OFF                                                             
     C                   DELETE    XXJENPY1                                                         
     C     BRBTNB        READE     XXJENPY1                               98                        
     C                   ENDDO                                                                      
      *                                                                                             
     C                   ENDIF                                                                      
     C                   SETOFF                                       9899                          
     C                   ENDIF                                                                      
      *                                                                                             
      *****************************************************************
      *  End of /COPY LUC110_105                                      *
      *****************************************************************
