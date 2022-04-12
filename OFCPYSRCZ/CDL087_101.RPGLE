      *****************************************************************                     MD059723
      *                                                               *                     MD059723
      *  Midas - /COPY Member (RPG)                                   *                     MD059723
      *                                                               *                     MD059723
      *  CDL087_101 - /COPY FOR GL008900                              *                     MD059723
      *                                                               *                     MD059723
      *   (c) Finastra International Limited 2022                     *                     MD059723
      *                                                               *                     MD059723
      *  Last Amend No. MD059723           Date 29Mar22               *                     MD059723
      *  Prev Amend No. AR1093845 *CREATE  Date 06Mar13               *                     MD059723
      *                                                               *                     MD059723
      *---------------------------------------------------------------*                     MD059723
      *                                                               *                     MD059723
      *  MD059723 - Changes for FM 2.1 upgrade.                       *                     MD059723
      *  AR1093845 - Incorporate CDL087 Changes                       *                     MD059723
      *              Applied for MD059723.                            *                     MD059723
      *                                                               *                     MD059723
      *****************************************************************                     MD059723
      *                                                                                    AR1093845
      ** If enhancement indicator flag is on, access branch extension                      AR1093845
      ** file for transfer flag and branch local base currency.                            AR1093845
     C                   IF        CDL087 = 'Y'                                            AR1093845
     C                   EXSR      #GLBDT                                                  AR1093845
     C                   ENDIF                                                             AR1093845
      *                                                                                    AR1093845
     C                   IF        CDL087 = 'Y'                                            AR1093845
                                                                                           AR1093845
      ** For each corrective batch that post to foreign ccy income or                      AR1093845
      ** expense & booking date is the previous accrual date or earlier                    AR1093845
                                                                                           AR1093845
     C************       IF        BTCYCD <> GLBCY                                AR1093845 MD059723
     C                   IF        BTCYCD <> X0GLBCY                                        MD059723
                                                                                           AR1093845
     C                   IF        HQBDTE <= PzDayNo AND                                   AR1093845
     C                             BTPTAM <> *ZERO                                         AR1093845
     C                   EXSR      SRFrgnCY2                                               AR1093845
     C                   ENDIF                                                             AR1093845
     C                   IF        HQBDTE <= BJPEYD AND                                    AR1093845
     C                             BTPTAM <> *ZERO                                         AR1093845
     C                   EXSR      SRBaseCY2                                               AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   ELSE                                                              AR1093845
                                                                                           AR1093845
      ** For each corrective batch that posts to a base ccy income or                      AR1093845
      ** expense & booking date is the previous end of year or earlier                     AR1093845
                                                                                           AR1093845
     C                   IF        HQBDTE <= BJPEYD AND                                    AR1093845
     C                             BTPTAM <> *ZERO                                         AR1093845
     C                   EXSR      SRBaseCY2                                               AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
     C                   ENDIF                                                             AR1093845
                                                                                           AR1093845
      ** Else (CDL087 is OFF) then do core processing                                      AR1093845
     C                   ELSE                                                              AR1093845
                                                                                           AR1093845
      *****************************************************************                    AR1093845
      * End of /COPY CDL087_101                                                            AR1093845
