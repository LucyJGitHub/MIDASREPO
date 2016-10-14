      *****************************************************************                       LUC109
      *                                                               *                       LUC109
      *  Midas - Customer Lending ILE Module                          *                       LUC109
      *                                                               *                       LUC109
      *  LELERIVAL - LE Rollover Instructions Validation              *                       LUC109
      *                                                               *                       LUC109
      *  Function: This Program Validates LE Rollover Input into      *                       LUC109
      *            the Midas database.                                *                       LUC109
      *                                                               *                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *                       LUC109
      *  Last Amend No. LUC109             Date 23Aug16               *                       LUC109
      *                                                               *                       LUC109
      *---------------------------------------------------------------*                       LUC109
      *                                                               *                       LUC109
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                       LUC109
      *           Issue error message if facility is blocked.         *                       LUC109
      *                                                               *                       LUC109
      *****************************************************************                       LUC109
      *                                                                                       LUC109
      *  If Switchable feature LUC109 is switched ON and New Maturity                         LUC109
      *  Date is valid...                                                                     LUC109
      *                                                                                       LUC109
     C     LUC109        IFEQ      'Y'                                                        LUC109
      *                                                                                       LUC109
      *  Check whether the New Maturity Date is greater than the                              LUC109
      *  Maximum End Date of Risk of the Facility. If it is, display                          LUC109
      *  a warning message 'Maturity is after Maximum End Date of                             LUC109
      *  Risk'.                                                                               LUC109
      *                                                                                       LUC109
     C     VNMDT         IFGT      LMEDR                                                      LUC109
     C                   ADD       1             WIdx                                         LUC109
     C                   EVAL      WFldNamArr(WIdx) = 'DDNMDTB'                               LUC109
     C                   EVAL      WMsgIDArr(WIdx) = 'XXX0096'                                LUC109
     C                   MOVE      'W'           DDNmdtOK                                     LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
      ** Calculate the Duration of Drawdown (New Maturity                                     LUC109
      *  Date - Rollover Date).                                                               LUC109
      *                                                                                       LUC109
     C     VNMDT         SUB       VRLDT         ULDDAY            5 0                        LUC109
      *                                                                                       LUC109
      ** Calculate the Maximum number of days authorized by                                   LUC109
      *  Head Office.                                                                         LUC109
      *                                                                                       LUC109
      ** First determine what format the Maximum Tenor of Facility                            LUC109
      *  is in.                                                                               LUC109
      *                                                                                       LUC109
     C                   MOVE      LMAXT         ULMAXT            1                          LUC109
     C                   MOVEL     LMAXT         ULMXNN            2                          LUC109
     C                   MOVEL     ULMXNN        ULMAXN            2 0                        LUC109
      *                                                                                       LUC109
      ** If the Maximum Tenor of Facility is in the form 'nnM', the                           LUC109
      *  maximum number of days authorized is nn x 31.                                        LUC109
      *  If the Maximum Tenor of Facility is in the form 'nnY', the                           LUC109
      *  maximum number of days authorized is nn x 366.                                       LUC109
      *                                                                                       LUC109
     C     ULMAXT        IFEQ      'M'                                                        LUC109
     C     ULMAXN        MULT      31            ULMAXD            5 0                        LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
     C     ULMAXT        IFEQ      'Y'                                                        LUC109
     C     ULMAXN        MULT      366           ULMAXD                                       LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
      ** If the Duration of Drawdown is greater than the Maximum                              LUC109
      *  Number of Days Authorised, display a warning message                                 LUC109
      *  'Duration of Drawdown is greater than number of days                                 LUC109
      *  authorised'.                                                                         LUC109
      *                                                                                       LUC109
     C     ULDDAY        IFGT      ULMAXD                                                     LUC109
     C                   ADD       1             WIdx                                         LUC109
     C                   EVAL      WFldNamArr(WIdx) = 'DDNMDTB'                               LUC109
     C                   EVAL      WMsgIDArr(WIdx) = 'XXX0097'                                LUC109
     C                   MOVE      'W'           DDNmdtOK                                     LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
     C                   ENDIF                                                                LUC109
