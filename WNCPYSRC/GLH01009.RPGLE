      ****************************************************************
      *                                                              *
      *  Midas - /COPY Member (GLVIBAC)                              *
      *                                                              *
      *  GLH01009 - Validate International Bank Account Number       *
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
      ** Positions 15 - 20 of IBAN must be equal to the customer number
     C                   IF        LUC103 = 'Y' and
     C                             DDIBAN <> *BLANKS and
     C                             %SUBST(DDIBAN:15:6) <> DDCUSN
     C                   MOVE      'N'           DDIBANOK
     C                   ADD       1             IDX
     C                   MOVEL     'DDIBAN'      FldNamXAr(Idx)
     C                   MOVEL     'XX00001'     MsgIDXAr(Idx)
     C                   ENDIF
      ****************************************************************
      *    End of /COPY GLH01009                                     *
      ****************************************************************
