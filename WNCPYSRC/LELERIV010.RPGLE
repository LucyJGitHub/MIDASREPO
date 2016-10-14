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
      *  If Switchable feature LUC109 is switched ON then check if                            LUC109
      *  the Facility is blocked. If the Facility is blocked then                             LUC109
      *  display error message 'Facility is Blocked' and do not                               LUC109
      *  allow this transaction to proceed.                                                   LUC109
      *                                                                                       LUC109
     C     LUC109        IFEQ      'Y'                                                        LUC109
      *                                                                                       LUC109
     C                   MOVE      F_CNUM        WFCNUM                                       LUC109
     C                   MOVE      F_FACT        WFFACT                                       LUC109
     C                   MOVE      F_FCNO        WFFCNO                                       LUC109
      *                                                                                       LUC109
     C     WFCLT         CHAIN     FCLTYY0                            89                      LUC109
      *                                                                                       LUC109
     C     *IN89         IFEQ      *OFF                                                       LUC109
     C     LBFAC         ANDEQ     'Y'                                                        LUC109
     C                   ADD       1             Idx                                          LUC109
     C                   EVAL      FldNameArr(Idx) = 'DDLNRF'                                 LUC109
     C                   EVAL      MsgIDArr(Idx) = 'XXX0094'                                  LUC109
     C                   MOVEL     @WLNNO        MsgDtaArr(Idx)                               LUC109
     C                   MOVE      'N'           DDNdamOK                                     LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
      * Set Facility Expiry Date to *HIVAL in order to bypass                                 LUC109
      * validation of Rollover Date, Next Rollover Date,                                      LUC109
      * New Interest Payment Date, New Maturity Date.-                                        LUC109
      *                                                                                       LUC109
     C                   Z-ADD     *HIVAL        F_DTEX                                       LUC109
      *                                                                                       LUC109
     C                   ENDIF                                                                LUC109
