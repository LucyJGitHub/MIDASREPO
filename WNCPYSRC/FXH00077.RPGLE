      *****************************************************************
      *  Start of /COPY FXH00077                                      *
      *****************************************************************
      *                                                               *
      *  Last Amend No. LUC110  *CREATE    Date 07Feb19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC110 - Extended Narratives (Upgrade NUC002 to FBM 2.1)     *
      *                                                               *
      *****************************************************************
      *
     C                   MOVE      'N'           LUC110            1                  
     C                   CALLB     'AOSARDR0'                                         
     C                   PARM      *BLANKS       @RTCD                                
     C                   PARM      '*VERIFY '    @OPTN                                
     C                   PARM      'LUC110'      @SAR              6                  
     C     SCSARD        PARM      SCSARD        DSFDY                                
      *                                                                               
     C     @RTCD         IFEQ      *BLANK                                             
     C                   MOVE      'Y'           LUC110                               
     C                   ENDIF                                                        
      *
      *****************************************************************
      *  End of /COPY FXH00077                                        *
      *****************************************************************
