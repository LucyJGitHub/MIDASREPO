      *****************************************************************
      *                                                               *                       LUC109
      *  Midas - Customer Lending ILE Module                          *                       LUC109
      *                                                               *                       LUC109
      *  LELOAMVAL - LE Loan amendment detail screen validation       *                       LUC109
      *                                                               *                       LUC109
      *  Function: This program validates a loan amendment input into *                       LUC109
      *            the Midas database.                                *                       LUC109
      *                                                               *                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *                       LUC109
      *  Last Amend No. LUC109             Date 23Aug16               *                       LUC109
      *                                                               *                       LUC109
      *---------------------------------------------------------------*                       LUC109
      *                                                               *                       LUC109
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                       LUC109
      *           Bypass check for PI date against last availablity   *                       LUC109
      *           date.                                               *                       LUC109
      *                                                               *                       LUC109
      *****************************************************************                       LUC109
      *                                                                                       LUC109
      *  If Switchable feature LUC109 is switched ON then check if                            LUC109
      *  the Facility is blocked. If the Facility is blocked then                             LUC109
      *  display warning message 'Facility is Blocked' and do not                             LUC109
      *  allow this transaction to proceed.                                                   LUC109
      *                                                                                       LUC109
     C     LUC109        IFEQ      'Y'                                                        LUC109
      *                                                                                       LUC109
      *                                                                                       LUC109
     C                   MOVE      FA_CANM       WFCNM                                        LUC109
     C                   Z-ADD     FA_CAFT       WFACT                                        LUC109
     C                   Z-ADD     FA_CAFN       WFNUM                                        LUC109
      *                                                                                       LUC109
     C     KEYFLA        CHAIN     FCLTYY0                            31                      LUC109
      *                                                                                       LUC109
     C     *IN31         IFEQ      *OFF                                                       LUC109
     C     LBFAC         ANDEQ     'Y'                                                        LUC109
     C                   ADD       1             Idx                                          LUC109
     C                   Eval      FldNameArr(Idx) = 'DDLOAN'                                 LUC109
     C                   Eval      MsgIdArr(Idx) = 'XXX0094'                                  LUC109
     C                   GOTO      EXVALI                                                     LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
     C                   ENDIF                                                                LUC109
