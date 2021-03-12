      *****************************************************************
      *                                                               *                             
      *  Midas - Customer Lending ILE Module                          *                             
      *                                                               *                             
      *  LELOAMVAL - LE Loan amendment detail screen validation       *                             
      *                                                               *                             
      *  Function: This program validates a loan amendment input into *                             
      *            the Midas database.                                *                             
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
      *                                                                                             
      *  If Switchable feature LUC109 is switched ON then check if                                  
      *  the Facility is blocked. If the Facility is blocked then                                   
      *  display warning message 'Facility is Blocked' and do not                                   
      *  allow this transaction to proceed.                                                         
      *                                                                                             
     C     LUC109        IFEQ      'Y'                                                              
      *                                                                                             
      *                                                                                             
     C                   MOVE      FA_CANM       WFCNM                                              
     C                   Z-ADD     FA_CAFT       WFACT                                              
     C                   Z-ADD     FA_CAFN       WFNUM                                              
      *                                                                                             
     C     KEYFLA        CHAIN     FCLTYY0                            31                            
      *                                                                                             
     C     *IN31         IFEQ      *OFF                                                             
     C     LBFAC         ANDEQ     'Y'                                                              
     C                   ADD       1             Idx                                                
     C                   Eval      FldNameArr(Idx) = 'DDLOAN'                                       
     C                   Eval      MsgIdArr(Idx) = 'XXX0094'                                        
     C                   GOTO      EXVALI                                                           
     C                   ENDIF                                                                      
      *                                                                                             
     C                   ENDIF                                                                      
