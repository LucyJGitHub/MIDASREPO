      *****************************************************************                       FVT101
      *                                                               *                       FVT101
      *  Midas - General Ledger Module                                *                       FVT101
      *                                                               *                       FVT101
      *  GL001432 - Midas GL Format Posting details                   *                       FVT101
      *                                                               *                       FVT101
      *  (c) Finastra International Limited 2019                      *                       FVT101
      *                                                               *                       FVT101
      *  Last Amend No. FVT101  *CREATE    Date 07Oct16               *                       FVT101
      *                                                               *                       FVT101
      *---------------------------------------------------------------*                       FVT101
      *                                                               *                       FVT101
      *  FVT101 - Field 61 Enhancement on SWIFT Statement Messages    *                       FVT101
      *                                                               *                       FVT101
      *---------------------------------------------------------------*                       FVT101
      *                                                                                       FVT101
      ** Check if FVT101 feature is enabled                                                   FVT101
      *                                                                                       FVT101
     C                   MOVE      'N'           FVT101            1                          FVT101
      *                                                                                       FVT101
     C                   CALLB     'AOSARDR0'                                                 FVT101
     C                   PARM      *BLANKS       P@RTCD                                       FVT101
     C                   PARM      '*VERIFY'     P@OPTN                                       FVT101
     C                   PARM      'FVT101 '     P@SARD                                       FVT101
     C     SCSARD        PARM      SCSARD        DSFDY                                        FVT101
      *                                                                                       FVT101
     C                   IF        P@RTCD = *BLANKS                                           FVT101
     C                   EVAL      FVT101 = 'Y'                                               FVT101
     C                   ENDIF                                                                FVT101
      *
