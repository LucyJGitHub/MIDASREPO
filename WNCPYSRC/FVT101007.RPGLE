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
     C     FVT101        IFEQ      'Y'                                                        FVT101
      *                                                                                       FVT101
      ** Batch input                                                                          FVT101
     C                   SELECT                                                               FVT101
      *                                                                                       FVT101
     C                   WHEN      WkModuleID = 'BA'                                          FVT101
      *                                                                                       FVT101
     C     BTSBF6        IFNE      *BLANK                                                     FVT101
     C     BTSBF7        ANDNE     *BLANK                                                     FVT101
     C     BTSBF8        ANDNE     *BLANK                                                     FVT101
     C                   MOVEL     BTSBF7        MGSFD7                                       FVT101
     C                   ENDIF                                                                FVT101
      *                                                                                       FVT101
     C                   ENDSL                                                                FVT101
     C                   ENDIF                                                                FVT101
      *                                                                                       FVT101
