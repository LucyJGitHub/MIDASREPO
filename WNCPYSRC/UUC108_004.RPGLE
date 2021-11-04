      *****************************************************************                       UUC108
      *  Midas - Copy member for FT000199                             *                       UUC108
      *                                                               *                       UUC108
      *  UUC108_004 - SWIFT2020 to consider FED Messages              *                       UUC108
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
      * We are in this part of the code if no field :121: has been found                      UUC108
      * Flag this as being the case and then go to end of subroutine                          UUC108
     C                   IF        UUC108 = 'Y'                                               UUC108
     C                   MOVE      'Y'           NoFld121          1                          UUC108
     C                   GOTO      EndExtract                                                 UUC108
     C                   ENDIF                                                                UUC108
      *****************************************************************                       UUC108
      * End of /COPY UUC108_004                                       *                       UUC108
      *****************************************************************                       UUC108
