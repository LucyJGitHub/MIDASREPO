      *****************************************************************                       HUT116
      *  Midas - Copy member for FT000199                             *                       HUT116
      *                                                               *                       HUT116
      *  HUT116_006 - SWIFT2020 to consider RTGS Messages             *                       HUT116
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
     C                   CALL      'AOSARDR0'                                                 HUT116
     C                   PARM      *BLANKS       @RTCD                                        HUT116
     C                   PARM      '*VERIFY'     @OPTN                                        HUT116
     C                   PARM      'HUT116'      @SARD                                        HUT116
     C     SCSARD        PARM      SCSARD        DSFDY                                        HUT116
                                                                                              HUT116
     C     @RTCD         IFEQ      *BLANKS                                                    HUT116
     C                   MOVEL     'Y'           HUT116                                       HUT116
     C                   ELSE                                                                 HUT116
     C                   MOVEL     'N'           HUT116            1                          HUT116
     C                   ENDIF                                                                HUT116
      *****************************************************************                       HUT116
      * End of /COPY HUT116_006                                       *                       HUT116
      *****************************************************************                       HUT116
