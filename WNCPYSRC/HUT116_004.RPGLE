      *****************************************************************                       HUT116
      *  Midas - Copy member for FT000199                             *                       HUT116
      *                                                               *                       HUT116
      *  HUT116_004 - SWIFT2020 to consider RTGS Messages             *                       HUT116
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
      * We are in this part of the code if no field :121: has been found                      HUT116
      * Flag this as being the case and then go to end of subroutine                          HUT116
     C                   IF        HUT116 = 'Y'                                               HUT116
     C                   MOVE      'Y'           NoFld121          1                          HUT116
     C                   GOTO      EndExtract                                                 HUT116
     C                   ENDIF                                                                HUT116
      *****************************************************************                       HUT116
      * End of /COPY HUT116_004                                       *                       HUT116
      *****************************************************************                       HUT116
