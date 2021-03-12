      *****************************************************************                             
      *                                                               *                             
      *  Midas - Customer Lending Module.                             *                             
      *                                                               *                             
      *  LELOAMVAL - LE Loan amendment detail screen validation       *                             
      *                                                               *                             
      *  (c) Finastra International Banking Systems Ltd. 2016         *                             
      *                                                               *                             
      *  Last Amend No. LUC109             Date 23Aug16               *                             
      *                                                               *                             
      *---------------------------------------------------------------*                             
      *                                                               *                             
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                             
      *           Bypass check for PI date against last availablity   *                             
      *           date.                                               *                             
      *                                                               *                             
      *****************************************************************                             
      ** Check switch LUC109.                                                                       
     C                   MOVE      'N'           LUC109            1                                
     C                   CALLB     'AOSARDR0'                                                       
     C                   PARM      *BLANKS       @RTCD                                              
     C                   PARM      '*VERIFY '    @OPTN                                              
     C                   PARM      'LUC109'      @SARD                                              
     C     SCSARD        PARM      SCSARD        DSFDY                                              
      *                                                                                             
     C                   IF        @RTCD = *BLANKS                                                  
     C                   EVAL      LUC109 = 'Y'                                                     
     C                   ELSE                                                                       
     C                   EVAL      LUC109 = 'N'                                                     
     C                   ENDIF                                                                      
