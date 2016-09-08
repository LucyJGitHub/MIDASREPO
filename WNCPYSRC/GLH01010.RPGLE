      ****************************************************************
      *                                                              *
      *  Midas - /COPY Member (GLVIBAC)                              *
      *                                                              *
      *  GLH01010 - Validate International Bank Account Number       *
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
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'LUC103'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSSDY
      *
     C                   IF        @RTCD = *BLANK
     C                   MOVEL     'Y'           LUC103            1
     C                   ELSE
     C                   MOVEL     'N'           LUC103
     C                   ENDIF
      ****************************************************************
      *    End of /COPY GLH01010                                     *
      ****************************************************************
