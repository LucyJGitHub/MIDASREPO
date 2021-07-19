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
      ** Always clear extension fields to ensure blank data if no record                      FVT101
      ** found or not Batch; If Journal entry, retrieve SWITI Fields.                         FVT101
      *                                                                                       FVT101
     C                   CLEAR                   #GLJEND6                                     FVT101
     C                   EVAL      BTSBF6  = *BLANKS                                          FVT101
     C                   EVAL      BTSBF7  = *BLANKS                                          FVT101
     C                   EVAL      BTSBF8  = *BLANKS                                          FVT101
     C                   EVAL      BTSBF9  = *BLANKS                                          FVT101
     C     FVT101        IFEQ      'Y'                                                        FVT101
     C                   IF        WkModuleID = 'BA'                                          FVT101
     C                   MOVE      GLSPOS        GLSPOSX                                      FVT101
     C     KeyAddInf     CHAIN     GLJENPY1                           99                      FVT101
     C                   ENDIF                                                                FVT101
     C                   ENDIF                                                                FVT101
      *                                                                                       FVT101
