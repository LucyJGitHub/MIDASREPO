      *****************************************************************                       LUC109
      *                                                               *                       LUC109
      *  Midas - Customer Lending ILE Module                          *                       LUC109
      *                                                               *                       LUC109
      *  LUC109_001 - Customer Loans screen 1 validations             *                       LUC109
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
     C     LUC109        ANDNE     'Y'                                                        LUC109
