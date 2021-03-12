      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP1V25 - Customer Loans screen 1 validations             *
      *                                                               *
      *  (c) Finastra International Banking Systems Ltd. 2016         *
      *                                                               *
      *  Last Amend No. LUC109             Date 23Aug16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC109 - HO Reporting (Upgrade to FB Midas 2.1)              *
      *         - bypass check if maturity date of loan is greater    *
      *           than expiry date of facility.                       *
      *         - bypass check if value date of the loan is greater   *
      *           than the last availability date of facility.        *
      *****************************************************************
      *
      *  If Switchable feature LUC109 is switched ON then check if
      *  the Facility is blocked. If the Facility is blocked then
      *  display error message 'Facility is Blocked' and do not
      *  allow this transaction to proceed.
      *
     C     LUC109        IFEQ      'Y'
      *
     C     WKPRM         CHAIN     FCLTYY0                            89
      *
     C     *IN89         IFEQ      *OFF
      *
     C     LBFAC         IFEQ      'Y'
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   MOVEL     'XXX0094'     MsgIDXAr(Idx)
     C                   ELSE
      *
      *  Check whether the Loan Value Date is greater than the Expiry
      *  Date of the Facility.  If it is, display a warning message
      *  'Value Date is after the Facility Expire Date'.
      *
     C     WSVVD         IFGT      DTEXF
     C                   MOVE      'W'           DDFCUSOK
     C                   ADD       1             WId
     C                   EVAL      WFldNmXAr(WId) = 'DDFCUS'
     C                   EVAL      WMsgIDXAr(WId) = 'XXX0095'
     C                   ENDIF
     C                   ENDIF
      *
      *
      ** Check whether the Loan Maturity Date is greater than the
      *  Maximum End Date of Risk of the Facility. If it is, display
      *  a warning message ' Maturity is after Maximum End Date of
      *  Risk'.
      *
     C     WSVMD         IFGT      LMEDR
     C                   MOVE      'W'           DDFCUSOK
     C                   ADD       1             WId
     C                   EVAL      WFldNmXAr(WId) = 'DDFCUS'
     C                   EVAL      WMsgIDXAr(WId) = 'XXX0096'
     C                   ENDIF
     C                   ENDIF
      *
      ** Calculate the Duration of Drawdown (Loan Maturity
      *  Date - Loan Value Date).
      *
     C     WSVMD         sub       WSVVD         ULDDAY            5 0
      *
      *
      ** Calculate the Maximum number of days authorized by
      *  Head Office.
      *
      ** First determine what format the Maximum Tenor of Facility
      *  is in.
      *
     C                   MOVE      LMAXT         ULMAXT            1
     C                   MOVEL     LMAXT         ULMXNN            2        Obtain nn
     C                   MOVEL     ULMXNN        ULMAXN            2 0      Convert n
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
     C                   MOVE      'W'           DDFCUSOK
     C                   ADD       1             WId
     C                   EVAL      WFldNmXAr(WId) = 'DDFCUS'
     C                   EVAL      WMsgIDXAr(WId) = 'XXX0097'
     C                   ENDIF
      *
     C                   ENDIF
      *
