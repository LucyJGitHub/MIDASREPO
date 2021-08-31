      ****************************************************************
      *                                                              *
      *   Midas - General Ledger Module                              *
      *                                                              *
      *   GLVIBAC - Validate International Bank Account Number       *
      *                                                              *
      *   (c) Misys International Banking Systems Ltd. 2014          *
      *                                                              *
      *   Last Amend No. LUC103  *CREATE    Date 17Dec14             *
      *                                                              *
      ****************************************************************
      *                                                              *
      *   LUC103 - IBAN Extra Validation                             *
      *                                                              *
      ****************************************************************
      ** Positions 15 - 20 of IBAN must be equal to the customer number                       LUC103
     C                   IF        LUC103 = 'Y' and                                           LUC103
     C                             DDIBAN <> *BLANKS and                                      LUC103
     C                             %SUBST(DDIBAN:15:6) <> DDCUSN                              LUC103
     C                   MOVE      'N'           DDIBANOK                                     LUC103
     C                   ADD       1             IDX                                          LUC103
     C                   MOVEL     'DDIBAN'      FldNamXAr(Idx)                               LUC103
     C                   MOVEL     'XX00001'     MsgIDXAr(Idx)                                LUC103
     C                   ENDIF                                                                LUC103
      ****************************************************************
      *    End of /COPY GLH01009                                     *
      ****************************************************************
