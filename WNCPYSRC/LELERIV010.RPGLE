      *****************************************************************                             
      *                                                               *                             
      *  Midas - Customer Lending ILE Module                          *                             
      *                                                               *                             
      *  LELERIVAL - LE Rollover Instructions Validation              *                             
      *                                                               *                             
      *  Function: This Program Validates LE Rollover Input into      *                             
      *            the Midas database.                                *                             
      *                                                               *                             
      *  (c) Finastra International Banking Systems Ltd. 2016         *                             
      *                                                               *                             
      *  Last Amend No. LUC109             Date 23Aug16               *                             
      *                                                               *                             
      *---------------------------------------------------------------*                             
      *                                                               *                             
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                             
      *           Issue error message if facility is blocked.         *                             
      *                                                               *                             
      *****************************************************************                             
      *                                                                                             
      *  If Switchable feature LUC109 is switched ON then check if                                  
      *  the Facility is blocked. If the Facility is blocked then                                   
      *  display error message 'Facility is Blocked' and do not                                     
      *  allow this transaction to proceed.                                                         
      *                                                                                             
     C     LUC109        IFEQ      'Y'                                                              
      *                                                                                             
     C                   MOVE      F_CNUM        WFCNUM                                             
     C                   MOVE      F_FACT        WFFACT                                             
     C                   MOVE      F_FCNO        WFFCNO                                             
      *                                                                                             
     C     WFCLT         CHAIN     FCLTYY0                            89                            
      *                                                                                             
     C     *IN89         IFEQ      *OFF                                                             
     C     LBFAC         ANDEQ     'Y'                                                              
     C                   ADD       1             Idx                                                
     C                   EVAL      FldNameArr(Idx) = 'DDLNRF'                                       
     C                   EVAL      MsgIDArr(Idx) = 'XXX0094'                                        
     C                   MOVEL     @WLNNO        MsgDtaArr(Idx)                                     
     C                   MOVE      'N'           DDNdamOK                                           
     C                   ENDIF                                                                      
      *                                                                                             
      * Set Facility Expiry Date to *HIVAL in order to bypass                                       
      * validation of Rollover Date, Next Rollover Date,                                            
      * New Interest Payment Date, New Maturity Date.-                                              
      *                                                                                             
     C                   Z-ADD     *HIVAL        F_DTEX                                             
      *                                                                                             
     C                   ENDIF                                                                      
