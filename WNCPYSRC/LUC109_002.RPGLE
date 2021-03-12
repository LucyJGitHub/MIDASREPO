      *****************************************************************                             
      *                                                               *                             
      *  Midas - Customer Lending ILE Module                          *                             
      *                                                               *                             
      *  LUC109_002 - Customer Loans screen 1 validations             *                             
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
     C     LUC109        ANDNE     'Y'                                                              
