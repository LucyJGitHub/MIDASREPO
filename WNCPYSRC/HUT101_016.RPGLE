      *****************************************************************                       HUT101
      *  Midas - Copy member for FTIPAYUPD                            *                       HUT101
      *                                                               *                       HUT101
      *  HUT101_016 - Auto-Authorise FT Payments                      *                       HUT101
      *                                                               *                       HUT101
      *  Last Amend No. HUT101CC1 *CREATE     Date 06Nov20            *                       HUT101
      * FBMidas 2.1 ---- Base ----------------------------------------*                       HUT101
      *                                                               *                       HUT101
      *---------------------------------------------------------------*                       HUT101
      *                                                               *                       HUT101
      *  HUT101CC1 - Copy CSW220 processing from FT0060 here          *                       HUT101
      *           so that SWIFT works in line with HUT101 feature     *                       HUT101
      *                                                               *                       HUT101
      *****************************************************************                       HUT101
      ** Update MT199 flag if Incoming payment and MT103                                      HUT101
      *                                                                                       HUT101
     C     CSW220        IFEQ      'Y'                                                        HUT101
     C     HUT101        ANDEQ     'Y'                                                        HUT101
     C     INMTPY        ANDEQ     '103'                                                      HUT101
     C     INMSGR        ANDNE     *ZEROS                                                     HUT101
     C     AUIN          ANDEQ     'Y'                                                        HUT101
     C     ACBT          IFEQ      *BLANK                                                     HUT101
     C                   MOVEL     'A'           FTM199                                       HUT101
     C                   ELSE                                                                 HUT101
      *                                                                                       HUT101
      ** If Account with Bank is Not Blank and OPIN is 'Y', do nothing                        HUT101
      *                                                                                       HUT101
     C     OPIN          IFEQ      'Y'                                                        HUT101
     C                   MOVEL     'Z'           FTM199                                       HUT101
      *                                                                                       HUT101
      ** If OPIN is 'N', Send MT199 Transferred through IPAY                                  HUT101
      *                                                                                       HUT101
     C                   ELSE                                                                 HUT101
     C                   MOVEL     'I'           FTM199                                       HUT101
     C                   ENDIF                                                                HUT101
     C                   ENDIF                                                                HUT101
                                                                                              HUT101
     C                   ENDIF                                                                HUT101
      *                                                                                       HUT101
      *****************************************************************                       HUT101
      * End of /COPY HUT101_016                                       *                       HUT101
      *****************************************************************                       HUT101
