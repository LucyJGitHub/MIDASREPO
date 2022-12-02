      *****************************************************************                       UUC108
      *  Midas - Copy member for FT000199                             *                       UUC108
      *                                                               *                       UUC108
      *  UUC108_006 - SWIFT2020 to consider FED Messages              *                       UUC108
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
     C                   CALL      'AOSARDR0'                                                 UUC108
     C                   PARM      *BLANKS       @RTCD                                        UUC108
     C                   PARM      '*VERIFY'     @OPTN                                        UUC108
     C                   PARM      'UUC108'      @SARD                                        UUC108
     C     SCSARD        PARM      SCSARD        DSFDY                                        UUC108
                                                                                              UUC108
     C     @RTCD         IFEQ      *BLANKS                                                    UUC108
     C                   MOVEL     'Y'           UUC108                                       UUC108
     C                   ELSE                                                                 UUC108
     C                   MOVEL     'N'           UUC108            1                          UUC108
     C                   ENDIF                                                                UUC108
      *****************************************************************                       UUC108
      * End of /COPY UUC108_006                                       *                       UUC108
      *****************************************************************                       UUC108
