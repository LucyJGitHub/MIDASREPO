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
      *  If Switchable feature LUC109 is switched ON and New Maturity                               
      *  Date is valid...                                                                           
      *                                                                                             
     C     LUC109        IFEQ      'Y'                                                              
      *                                                                                             
      *  Check whether the New Maturity Date is greater than the                                    
      *  Maximum End Date of Risk of the Facility. If it is, display                                
      *  a warning message 'Maturity is after Maximum End Date of                                   
      *  Risk'.                                                                                     
      *                                                                                             
     C     VNMDT         IFGT      LMEDR                                                            
     C                   ADD       1             WIdx                                               
     C                   EVAL      WFldNamArr(WIdx) = 'DDNMDTB'                                     
     C                   EVAL      WMsgIDArr(WIdx) = 'XXX0096'                                      
     C                   MOVE      'W'           DDNmdtOK                                           
     C                   ENDIF                                                                      
      *                                                                                             
      ** Calculate the Duration of Drawdown (New Maturity                                           
      *  Date - Rollover Date).                                                                     
      *                                                                                             
     C     VNMDT         SUB       VRLDT         ULDDAY            5 0                              
      *                                                                                             
      ** Calculate the Maximum number of days authorized by                                         
      *  Head Office.                                                                               
      *                                                                                             
      ** First determine what format the Maximum Tenor of Facility                                  
      *  is in.                                                                                     
      *                                                                                             
     C                   MOVE      LMAXT         ULMAXT            1                                
     C                   MOVEL     LMAXT         ULMXNN            2                                
     C                   MOVEL     ULMXNN        ULMAXN            2 0                              
      *                                                                                             
      ** If the Maximum Tenor of Facility is in the form 'nnM', the                                 
      *  maximum number of days authorized is nn x 31.                                              
      *  If the Maximum Tenor of Facility is in the form 'nnY', the                                 
      *  maximum number of days authorized is nn x 366.                                             
      *                                                                                             
     C     ULMAXT        IFEQ      'M'                                                              
     C     ULMAXN        MULT      31            ULMAXD            5 0                              
     C                   ENDIF                                                                      
      *                                                                                             
     C     ULMAXT        IFEQ      'Y'                                                              
     C     ULMAXN        MULT      366           ULMAXD                                             
     C                   ENDIF                                                                      
      *                                                                                             
      ** If the Duration of Drawdown is greater than the Maximum                                    
      *  Number of Days Authorised, display a warning message                                       
      *  'Duration of Drawdown is greater than number of days                                       
      *  authorised'.                                                                               
      *                                                                                             
     C     ULDDAY        IFGT      ULMAXD                                                           
     C                   ADD       1             WIdx                                               
     C                   EVAL      WFldNamArr(WIdx) = 'DDNMDTB'                                     
     C                   EVAL      WMsgIDArr(WIdx) = 'XXX0097'                                      
     C                   MOVE      'W'           DDNmdtOK                                           
     C                   ENDIF                                                                      
      *                                                                                             
     C                   ENDIF                                                                      
