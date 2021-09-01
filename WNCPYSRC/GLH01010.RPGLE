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
      ** Check if LUC013 is enabled in System
     C                   CALLB     'AOSARDR0'                                                 LUC103
     C                   PARM      *BLANKS       @RTCD             7                          LUC103
     C                   PARM      '*VERIFY'     @OPTN             7                          LUC103
     C                   PARM      'LUC103'      @SARD             6                          LUC103
     C     SCSARD        PARM      SCSARD        DSSDY                                        LUC103
      *                                                                                       LUC103
     C                   IF        @RTCD = *BLANK                                             LUC103
     C                   MOVEL     'Y'           LUC103            1                          LUC103
     C                   ELSE                                                                 LUC103
     C                   MOVEL     'N'           LUC103                                       LUC103
     C                   ENDIF                                                                LUC103
      ****************************************************************
      *    End of /COPY GLH01010                                     *
      ****************************************************************
