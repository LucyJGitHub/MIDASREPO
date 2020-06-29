      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL0420 - Balance Statements                                  *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last amend No. LRI100  *CREATE    Date 17Mar20               *
      *  Prev Amend No. XXXXXX             Date DDMMMYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LRI100 - Statement Format Changes.                           *
      *         - Upgrade CARs LRI009/LRI010 to FB Midas.             *
      *                                                               *
      *****************************************************************
     O*                                                                                       LRI100
     O*/OMITEND                                                                               LRI100
     O*                                                                                       LRI100
     OGL0420P1  E    87 84                    01                                              LRI100
     O*                                                                                       LRI100
     O** Heading                                                                              LRI100
     O          E    87 84                    14                                              LRI100
     O                  36   @WCNA1              44                                           LRI100
     O                                           55 'DATE:'                                   LRI100
     O                       ULRNDD              66                                           LRI100
     O                                           67 '-'                                       LRI100
     O                       ULRNMM              70                                           LRI100
     O                                           71 '-'                                       LRI100
     O                       ULRNYY              73                                           LRI100
     O*                                                                                       LRI100
     O          E    87 84                    15                                              LRI100
     O                     36@WCNA2              44                                           LRI100
     O*                                                                                       LRI100
     O          E    87 84                    16                                              LRI100
     O                     36@WCNA3              44                                           LRI100
     O                                           58 'PAGE NO:'                                LRI100
     O                       STPA          3     67                                           LRI100
     O*                                                                                       LRI100
     O          E    87 84                    17                                              LRI100
     O                     36@WCNA4              44                                           LRI100
     O*                                                                                       LRI100
     O          E    87 84                    18                                              LRI100
     O                                           61 'ACCOUNT NO:'                             LRI100
     O                       ACNO                83                                           LRI100
     O*                                                                                       LRI100
     O*                                                                                       LRI100
     O          E    87 84                    20                                              LRI100
     O                                           63 'ACCOUNT TYPE:'                           LRI100
     O                       ULACTP              79                                           LRI100
     O*                                                                                       LRI100
     O          E    87 84                    22                                              LRI100
     O                                           59 'CURRENCY:'                               LRI100
     O                       CCY                 67                                           LRI100
     O*                                                                                       LRI100
     O          E    87 84                    23                                              LRI100
     O                       CCNM                78                                           LRI100
     O*                                                                                       LRI100
     O** Brought Forward Line                                                                 LRI100
     O          E    87 84                    27                                              LRI100
     O              N45      ULLSDD               2                                           LRI100
     O              N45                           3 '-'                                       LRI100
     O              N45      ULLSMM               6                                           LRI100
     O              N45                           7 '-'                                       LRI100
     O              N45      ULLSYY               9                                           LRI100
     O               45                           6 'CONTD.'                                  LRI100
     O                                           44 'BALANCE BROUGHT FORWARD'                 LRI100
     O                     70ULPSBF              92 '  ,   ,   , 0 CR'                        LRI100
     O                     71ULPSBF              92 ' ,   ,   , 0 . CR'                       LRI100
     O                     72ULPSBF              92 '   ,   , 0 .  CR'                        LRI100
     O                     73ULPSBF              92 '  ,   , 0 .   CR'                        LRI100
     O                       PSTDRF              92                                           LRI100
     O*                                                                                       LRI100
     O** Detail Line                                                                          LRI100
     O          E    40 51N04DET         2                                                    LRI100
     O         AND   84                                                                       LRI100
     O*                                                                                       LRI100
     O** Posting Date                                                                         LRI100
     O                       ULPSDD               2                                           LRI100
     O                                            3 '-'                                       LRI100
     O                       ULPSMM               6                                           LRI100
     O                                            7 '-'                                       LRI100
     O                       ULPSYY               9                                           LRI100
     O*                                                                                       LRI100
     O** Value Date                                                                           LRI100
     O                       ULVLDD              13                                           LRI100
     O                                           14 '-'                                       LRI100
     O                       ULVLMM              17                                           LRI100
     O                                           18 '-'                                       LRI100
     O                       ULVLYY              20                                           LRI100
     O*                                                                                       LRI100
     O** Narrative                                                                            LRI100
     O                       ULPNAR              46                                           LRI100
     O*                                                                                       LRI100
     O** Debits                                                                               LRI100
     O                  23 70ULPSTA              61 '  ,   ,   , 0 '                          LRI100
     O                  23 71ULPSTA              61 ' ,   ,   , 0 . '                         LRI100
     O                  23 72ULPSTA              61 '   ,   , 0 .  '                          LRI100
     O                  23 73ULPSTA              61 '  ,   , 0 .   '                          LRI100
     O*                                                                                       LRI100
     O** Credits                                                                              LRI100
     O                  22 70ULPSTA              75 '  ,   ,   , 0 '                          LRI100
     O                  22 71ULPSTA              75 ' ,   ,   , 0 . '                         LRI100
     O                  22 72ULPSTA              75 '   ,   , 0 .  '                          LRI100
     O                  22 73ULPSTA              75 '  ,   , 0 .   '                          LRI100
     O*                                                                                       LRI100
     O** Balance for this Posting Date                                                        LRI100
     O          E    L1 40 49BAL         0  0                                                 LRI100
     O         AND  N52 51 84                                                                 LRI100
     O                     70ULPSBL              92 '  ,   ,   , 0 CR'                        LRI100
     O                     71ULPSBL              92 ' ,   ,   , 0 . CR'                       LRI100
     O                     72ULPSBL              92 '   ,   , 0 .  CR'                        LRI100
     O                     73ULPSBL              92 '  ,   , 0 .   CR'                        LRI100
     O                       PSTDRL              92                                           LRI100
     O*                                                                                       LRI100
     O** Additional Narrative Lines                                                           LRI100
     O          E    40 51N04DET1        1                                                    LRI100
     O         AND   84                                                                       LRI100
     O                       LNAR1               46                                           LRI100
     O*                                                                                       LRI100
     O          E    40 51N04DET2        1                                                    LRI100
     O         AND   84                                                                       LRI100
     O                       LNAR2               46                                           LRI100
     O*                                                                                       LRI100
     O          E    40 51N04DET3        1                                                    LRI100
     O         AND   84                                                                       LRI100
     O                       LNAR3               36                                           LRI100
     O*                                                                                       LRI100
     O** Carried Forward Line                                                                 LRI100
     O          E    84 40 18TOT         2                                                    LRI100
     O         AND  N33                                                                       LRI100
     O                                           44 'BALANCE CARRIED FORWARD'                 LRI100
     O                     70ULPSBL              92 '  ,   ,   , 0 CR'                        LRI100
     O                     71ULPSBL              92 ' ,   ,   , 0 . CR'                       LRI100
     O                     72ULPSBL              92 '   ,   , 0 .  CR'                        LRI100
     O                     73ULPSBL              92 '  ,   , 0 .   CR'                        LRI100
     O                       PSTDRL              92                                           LRI100
     O*                                                                                       LRI100
     O** Total Time Heading                                                                   LRI100
     O          E    84 40 18TOT              14                                              LRI100
     O         AND  N33                                                                       LRI100
     O                  36   @WCNA1              44                                           LRI100
     O                                           55 'DATE:'                                   LRI100
     O                       ULRNDD              66                                           LRI100
     O                                           67 '-'                                       LRI100
     O                       ULRNMM              70                                           LRI100
     O                                           71 '-'                                       LRI100
     O                       ULRNYY              73                                           LRI100
     O*                                                                                       LRI100
     O          E    84 40 18TOT              15                                              LRI100
     O         AND  N33                                                                       LRI100
     O                     36@WCNA2              44                                           LRI100
     O*                                                                                       LRI100
     O          E    84 40 18TOT              16                                              LRI100
     O         AND  N33                                                                       LRI100
     O                     36@WCNA3              44                                           LRI100
     O                                           58 'PAGE NO:'                                LRI100
     O                       STPA          3     67                                           LRI100
     O*                                                                                       LRI100
     O          E    84 40 18TOT              17                                              LRI100
     O         AND  N33                                                                       LRI100
     O                     36@WCNA4              44                                           LRI100
     O*                                                                                       LRI100
     O          E    84 40 18TOT              18                                              LRI100
     O         AND  N33                                                                       LRI100
     O                                           61 'ACCOUNT NO:'                             LRI100
     O                       ACNO                83                                           LRI100
     O*                                                                                       LRI100
     O*                                                                                       LRI100
     O          E    84 40 18                 20                                              LRI100
     O         AND  N33                                                                       LRI100
     O                                           63 'ACCOUNT TYPE:'                           LRI100
     O                       ULACTP              79                                           LRI100
     O*                                                                                       LRI100
     O          E    84 40 18TOT              22                                              LRI100
     O         AND  N33                                                                       LRI100
     O                                           59 'CURRENCY:'                               LRI100
     O                       CCY                 67                                           LRI100
     O*                                                                                       LRI100
     O** Total Time Brought Forward Line                                                      LRI100
     O          E    84 40 18TOT              27                                              LRI100
     O         AND  N33                                                                       LRI100
     O              N45      ULLSDD               2                                           LRI100
     O              N45                           3 '-'                                       LRI100
     O              N45      ULLSMM               6                                           LRI100
     O              N45                           7 '-'                                       LRI100
     O              N45      ULLSYY               9                                           LRI100
     O               45                           6 'CONTD.'                                  LRI100
     O                                           44 'BALANCE BROUGHT FORWARD'                 LRI100
     O                     70ULPSBF              92 '  ,   ,   , 0 CR'                        LRI100
     O                     71ULPSBF              92 ' ,   ,   , 0 . CR'                       LRI100
     O                     72ULPSBF              92 '   ,   , 0 .  CR'                        LRI100
     O                     73ULPSBF              92 '  ,   , 0 .   CR'                        LRI100
     O                       PSTDRF              92                                           LRI100
     O*                                                                                       LRI100
     O** End of Page Carried Forward Line                                                     LRI100
     O          E    84 40 45ENDPG       2                                                    LRI100
     O         AND  N33                                                                       LRI100
     O                                           44 'BALANCE CARRIED FORWARD'                 LRI100
     O                     70ULPSBL              92 '  ,   ,   , 0 CR'                        LRI100
     O                     71ULPSBL              92 ' ,   ,   , 0 . CR'                       LRI100
     O                     72ULPSBL              92 '   ,   , 0 .  CR'                        LRI100
     O                     73ULPSBL              92 '  ,   , 0 .   CR'                        LRI100
     O                       PSTDRL              92                                           LRI100
     O*                                                                                       LRI100
     O** Total Time Carried Forward Line                                                      LRI100
     O          E    84 40 52TOT         2                                                    LRI100
     O         AND  N33                                                                       LRI100
     O                                           44 'BALANCE CARRIED FORWARD'                 LRI100
     O                     70ULPSBL              92 '  ,   ,   , 0 CR'                        LRI100
     O                     71ULPSBL              92 ' ,   ,   , 0 . CR'                       LRI100
     O                     72ULPSBL              92 '   ,   , 0 .  CR'                        LRI100
     O                     73ULPSBL              92 '  ,   , 0 .   CR'                        LRI100
     O                       PSTDRL              92                                           LRI100
     O*                                                                                       LRI100
     O          E            ERPT1       2    03                                              LRI100
     O                                           66 '*** END OF REPORT '                      LRI100
     O               58                          77 'FOR BRANCH '                             LRI100
     O               58      BRCASV              80                                           LRI100
     O               58                          84 ' ***'                                    LRI100
     O              N58                          69 '***'                                     LRI100
     O*                                                                                       LRI100
