      *****************************************************************                       LUC109
      *                                                               *                       LUC109
      *  Midas - Customer Lending Module.                             *                       LUC109
      *                                                               *                       LUC109
      *  LEFAMDRTV - Facility Amendment Retrieve                      *                       LUC109
      *                                                               *                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *                       LUC109
      *  Last Amend No. LUC109             Date 23Aug16               *                       LUC109
      *                                                               *                       LUC109
      *---------------------------------------------------------------*                       LUC109
      *                                                               *                       LUC109
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                       LUC109
      *           Allow reactivation of active facilities.            *                       LUC109
      *                                                               *                       LUC109
      *****************************************************************                       LUC109
      *                                                                                       LUC109
      ** Amendment Type FR is allowed after Expiry Date of Facility                         LUC109
      *                                                                                       LUC109
     C     S#FATP        IFEQ      'FR'                                                       LUC109
     C     FC_RECI       ANDEQ     'D'                                                        LUC109
     C     WAggregate    ANDNE     'Y'                                                        LUC109
     C     LUC109        ANDEQ     'Y'                                                        LUC109
     C     FC_DTEX       ANDGT     BJRDNB                                                     LUC109
     C     S#FATP        OREQ      'FR'                                                       LUC109
     C     AGFC_RECI     ANDEQ     'D'                                                        LUC109
     C     WAggregate    ANDEQ     'Y'                                                        LUC109
     C     LUC109        ANDEQ     'Y'                                                        LUC109
     C     AGFC_DTEX     ANDGT     BJRDNB                                                     LUC109
     C                   MOVE      'N'           S#FATPok                                     LUC109
     C                   ADD       1             Ix                                           LUC109
     C                   MOVEL     'S#FATP    '  FldNameArr(Ix)                               LUC109
     C                   MOVEL     'LEF9218'     MsgIdArr(Ix)                                 LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
