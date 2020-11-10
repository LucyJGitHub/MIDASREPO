      *****************************************************************                       HUT116
      *  Midas - Copy member for FT000199                             *                       HUT116
      *                                                               *                       HUT116
      *  HUT116_001 - SWIFT2020 to consider RTGS Messages             *                       HUT116
      *                                                               *                       HUT116
      *  Last Amend No. HUT116 *CREATE     Date 06Nov20               *                       HUT116
      * FBMidas 2.1 ---- Base ----------------------------------------*                       HUT116
      *                                                               *                       HUT116
      *---------------------------------------------------------------*                       HUT116
      *                                                               *                       HUT116
      *  HUT116 - RTGS Messages are formatted into MT103 format but   *                       HUT116
      *           these don't have field :121: and should not generate*                       HUT116
      *           MT199                                               *                       HUT116
      *                                                               *                       HUT116
      *****************************************************************                       HUT116
      *                                                                                       HUT116
      ** If no field :121: found then don't generate MT199 message details                    HUT116
      ** just udpate MT199 flag on MEINFTPD to be 'O'                                         HUT116
      *                                                                                       HUT116
     C                   IF        NoFld121 = 'Y'                                             UUC108
     C                             and HUT116 = 'Y'                                           UUC108
     C                   EVAL      FTM199 = 'O'                                               UUC108
     C                   ELSE                                                                 UUC108
      *                                                                                       HUT116
      *****************************************************************                       HUT116
      * End of /COPY HUT116_001                                       *                       HUT116
      *****************************************************************                       HUT116
