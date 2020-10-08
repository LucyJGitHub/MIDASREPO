      *****************************************************************                     MD056352
      *                                                               *                     MD056352
      *  ERZ247_022 - Midas FT /COPY for FTVSCHG                      *                     MD056352
      *                                                               *                     MD056352
      *  Last Amend No. MD056352 *CREATE   Date 20Aug20               *                     MD056352
      *                                                               *                     MD056352
      *---------------------------------------------------------------*                     MD056352
      *                                                               *                     MD056352
      *  MD056352 - ERZ247: Our commission is not displayed for       *                     MD056352
      *             incoming messages                                                       MD056352
      *                                                               *                     MD056352
      *---------------------------------------------------------------*                     MD056352
                                                                                            MD056352
     C                   MOVEL     *BLANKS       WPREFM1                                    MD056352
     C                   MOVEL     SPREF         WPREFM1                                    MD056352
     C                   IF        WPREFM1 <> WPREFM2                                       MD056352
     C                   MOVEL     'N'           WALREADY                                   MD056352
     C                   ENDIF                                                              MD056352
