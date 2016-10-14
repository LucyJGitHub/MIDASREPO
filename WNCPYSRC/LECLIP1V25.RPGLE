      *****************************************************************                       LUC109
      *                                                               *                       LUC109
      *  Midas - Customer Lending ILE Module                          *                       LUC109
      *                                                               *                       LUC109
      *  LECLIP1V25 - Customer Loans screen 1 validations             *                       LUC109
      *                                                               *                       LUC109
      *  (c) Misys International Banking Systems Ltd. 2016            *                       LUC109
      *                                                               *                       LUC109
      *  Last Amend No. LUC109             Date 23Aug16               *                       LUC109
      *                                                               *                       LUC109
      *---------------------------------------------------------------*                       LUC109
      *                                                               *                       LUC109
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *                       LUC109
      *         - bypass check if maturity date of loan is greater    *                       LUC109
      *           than expiry date of facility.                       *                       LUC109
      *         - bypass check if value date of the loan is greater   *                       LUC109
      *           than the last availability date of facility.        *                       LUC109
      *****************************************************************                       LUC109
      *                                                                                       LUC109
      *  If Switchable feature LUC109 is switched ON then check if                            LUC109
      *  the Facility is blocked. If the Facility is blocked then                             LUC109
      *  display error message 'Facility is Blocked' and do not                               LUC109
      *  allow this transaction to proceed.                                                   LUC109
      *                                                                                       LUC109
     C     LUC109        IFEQ      'Y'                                                        LUC109
      *                                                                                       LUC109
     C     WKPRM         CHAIN     FCLTYY0                            89                      LUC109
      *                                                                                       LUC109
     C     *IN89         IFEQ      *OFF                                                       LUC109
      *                                                                                       LUC109
     C     LBFAC         IFEQ      'Y'                                                        LUC109
     C                   MOVE      'N'           DDFCUSOK                                     LUC109
     C                   ADD       1             Idx                                          LUC109
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)                               LUC109
     C                   MOVEL     'XXX0094'     MsgIDXAr(Idx)                                LUC109
     C                   ELSE                                                                 LUC109
      *                                                                                       LUC109
      *  Check whether the Loan Value Date is greater than the Expiry                         LUC109
      *  Date of the Facility.  If it is, display a warning message                           LUC109
      *  'Value Date is after the Facility Expire Date'.                                      LUC109
      *                                                                                       LUC109
     C     WSVVD         IFGT      DTEXF                                                      LUC109
     C                   MOVE      'W'           DDFCUSOK                                     LUC109
     C                   ADD       1             WId                                          LUC109
     C                   EVAL      WFldNmXAr(WId) = 'DDFCUS'                                  LUC109
     C                   EVAL      WMsgIDXAr(WId) = 'XXX0095'                                 LUC109
     C                   ENDIF                                                                LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
      *                                                                                       LUC109
      ** Check whether the Loan Maturity Date is greater than the                             LUC109
      *  Maximum End Date of Risk of the Facility. If it is, display                          LUC109
      *  a warning message ' Maturity is after Maximum End Date of                            LUC109
      *  Risk'.                                                                               LUC109
      *                                                                                       LUC109
     C     WSVMD         IFGT      LMEDR                                                      LUC109
     C                   MOVE      'W'           DDFCUSOK                                     LUC109
     C                   ADD       1             WId                                          LUC109
     C                   EVAL      WFldNmXAr(WId) = 'DDFCUS'                                  LUC109
     C                   EVAL      WMsgIDXAr(WId) = 'XXX0096'                                 LUC109
     C                   ENDIF                                                                LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
      ** Calculate the Duration of Drawdown (Loan Maturity                                    LUC109
      *  Date - Loan Value Date).                                                             LUC109
      *                                                                                       LUC109
     C     WSVMD         sub       WSVVD         ULDDAY            5 0                        LUC109
      *                                                                                       LUC109
      *                                                                                       LUC109
      ** Calculate the Maximum number of days authorized by                                   LUC109
      *  Head Office.                                                                         LUC109
      *                                                                                       LUC109
      ** First determine what format the Maximum Tenor of Facility                            LUC109
      *  is in.                                                                               LUC109
      *                                                                                       LUC109
     C                   MOVE      LMAXT         ULMAXT            1                          LUC109
     C                   MOVEL     LMAXT         ULMXNN            2        Obtain nn         LUC109
     C                   MOVEL     ULMXNN        ULMAXN            2 0      Convert n         LUC109
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
     C                   MOVE      'W'           DDFCUSOK                                     LUC109
     C                   ADD       1             WId                                          LUC109
     C                   EVAL      WFldNmXAr(WId) = 'DDFCUS'                                  LUC109
     C                   EVAL      WMsgIDXAr(WId) = 'XXX0097'                                 LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
     C                   ENDIF                                                                LUC109
      *                                                                                       LUC109
