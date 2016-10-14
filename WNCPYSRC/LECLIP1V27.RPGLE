      *****************************************************************                       LUC109
      *                                                               *                       LUC109
      *  Midas - Customer Lending ILE Module                          *                       LUC109
      *                                                               *                       LUC109
      *  LECLIP1V27 - Customer Loans screen 1 validations             *                       LUC109
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
      ** Check switch LUC109.                                                                 LUC109
     C                   CALLB     'AOSARDR0'                                                 LUC109
     C                   Parm      *BLANKS       PRtCd                                        LUC109
     C                   Parm      '*VERIFY'     POptn                                        LUC109
     C                   Parm      'LUC109'      PSard                                        LUC109
      *                                                                                       LUC109
     C                   If        PRtCd = *BLANKS                                            LUC109
     C                   Move      'Y'           LUC109            1                          LUC109
     C                   Else                                                                 LUC109
     C                   Move      'N'           LUC109                                       LUC109
     C                   Endif                                                                LUC109
      *                                                                                       LUC109
