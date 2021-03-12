      *****************************************************************
      *  Start of /COPY GL0600CCP3                                    *
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
      ** Determine if feature LUC110 is installed.                                             
      *                                                                                        
     C                   MOVE      'N'           LUC110            1                           
     C                   CALL      'AOSARDR0'                                                  
     C                   PARM      *BLANKS       @RTCD                                         
     C                   PARM      '*VERIFY'     @OPTN                                         
     C                   PARM      'LUC110'      WSARD                                         
     C     SCSARD        PARM      SCSARD        DSFDY                                         
                                                                                               
     C     @RTCD         IFEQ      *BLANK                                                      
     C                   MOVE      'Y'           LUC110                                        
     C                   ENDIF                                                                 
      *                                                                                        
      *****************************************************************
      *  End of /COPY GL0600CCP3                                      *
      *****************************************************************
