      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP1V27 - Customer Loans screen 1 validations             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. DAI104             Date 29Jul19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  DAI104 - Extend Customer De-Activation (CSD025) to LE        *
      *                                                               *
      *****************************************************************
      *
      ** Check switch DAI104                                                                  DAI104
      *                                                                                       DAI104
     C                   CALLB     'AOSARDR0'                                                 DAI104
     C                   Parm      *BLANKS       PRtCd                                        DAI104
     C                   Parm      '*VERIFY'     POptn                                        DAI104
     C                   Parm      'DAI104'      PSard                                        DAI104
      *                                                                                       DAI104
     C                   If        PRtCd = *BLANKS                                            DAI104
     C                   Move      'Y'           DAI104            1                          DAI104
     C                   Else                                                                 DAI104
     C                   Move      'N'           DAI104                                       DAI104
     C                   Endif                                                                DAI104
      *****************************************************************
      *  End of /COPY LECLIP1V27                                      *
      *****************************************************************
