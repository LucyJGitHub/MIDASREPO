      *****************************************************************                       UUC108
      *  Midas - Copy member for FT000199                             *                       UUC108
      *                                                               *                       UUC108
      *  UUC108_001 - SWIFT2020 to consider FED Messages              *                       UUC108
      *                                                               *                       UUC108
      *  Last Amend No. UUC108 *CREATE     Date 06Nov20               *                       UUC108
      * FBMidas 2.1 ---- Base ----------------------------------------*                       UUC108
      *                                                               *                       UUC108
      *---------------------------------------------------------------*                       UUC108
      *                                                               *                       UUC108
      *  UUC108 - FED Messages are formatted into MT103 format but    *                       UUC108
      *           these don't have field :121: and should not generate*                       UUC108
      *           MT199                                               *                       UUC108
      *                                                               *                       UUC108
      *****************************************************************                       UUC108
      *                                                                                       UUC108
      ** If no field :121: found then don't generate MT199 message details                    UUC108
      ** just udpate MT199 flag on MEINFTPD to be 'O'                                         UUC108
      *                                                                                       UUC108
     C                   IF        NoFld121 = 'Y'                                             UUC108
     C                             and UUC108 = 'Y'                                           UUC108
     C                   EVAL      FTM199 = 'O'                                               UUC108
     C                   ELSE                                                                 UUC108
      *                                                                                       UUC108
      *****************************************************************                       UUC108
      * End of /COPY UUC108_001                                       *                       UUC108
      *****************************************************************                       UUC108
