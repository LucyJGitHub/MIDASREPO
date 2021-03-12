      *****************************************************************                             
      *                                                               *                             
      *  Midas - Customer Lending Module.                             *                             
      *                                                               *                             
      *  LEFAMDRTV - Facility Amendment Retrieve                      *                             
      *                                                               *                             
      *  (c) Finastra International Banking Systems Ltd. 2016         *                             
      *                                                               *                             
      *  Last Amend No. LUC109             Date 23Aug16               *                             
      *                                                               *                             
      *---------------------------------------------------------------*                             
      *                                                               *                             
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                             
      *           Allow reactivation of active facilities.            *                             
      *                                                               *                             
      *****************************************************************                             
      *                                                                                             
      ** Amendment Type FR is allowed after Expiry Date of Facility                               
      *                                                                                             
     C     S#FATP        IFEQ      'FR'                                                             
     C     FC_RECI       ANDEQ     'D'                                                              
     C     WAggregate    ANDNE     'Y'                                                              
     C     LUC109        ANDEQ     'Y'                                                              
     C     FC_DTEX       ANDGT     BJRDNB                                                           
     C     S#FATP        OREQ      'FR'                                                             
     C     AGFC_RECI     ANDEQ     'D'                                                              
     C     WAggregate    ANDEQ     'Y'                                                              
     C     LUC109        ANDEQ     'Y'                                                              
     C     AGFC_DTEX     ANDGT     BJRDNB                                                           
     C                   MOVE      'N'           S#FATPok                                           
     C                   ADD       1             Ix                                                 
     C                   MOVEL     'S#FATP    '  FldNameArr(Ix)                                     
     C                   MOVEL     'LEF9218'     MsgIdArr(Ix)                                       
     C                   ENDIF                                                                      
      *                                                                                             
