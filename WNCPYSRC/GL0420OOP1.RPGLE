000100210908      *****************************************************************
000101210908      *                                                               *
000102210908      *  Midas - General Ledger                                       *
000103210908      *                                                               *
000104210908      *  GL0420 - Balance Statements                                  *
000105210908      *                                                               *
000106210908      *  (c) Finastra International Limited 2020                      *
000107210908      *                                                               *
000108210908      *  Last amend No. LRI100  *CREATE    Date 17Mar20               *
000109210908      *  Prev Amend No. XXXXXX             Date DDMMMYY               *
000110210908      *                                                               *
000111210908      *---------------------------------------------------------------*
000112210908      *                                                               *
000113210908      *  LRI100 - Statement Format Changes.                           *
000114210908      *         - Upgrade CARs LRI009/LRI010 to FB Midas.             *
000115210908      *                                                               *
000116210908      *****************************************************************
000117210908     O*                                                                                       LRI100
000118210908     O*/OMITEND                                                                               LRI100
000119210908     O*                                                                                       LRI100
000120210908     OGL0420P1  E    87 84                    01                                              LRI100
000121210908     O*                                                                                       LRI100
000122210908     O** Heading                                                                              LRI100
000123210908     O          E    87 84                    14                                              LRI100
000124210908     O                  36   @WCNA1              44                                           LRI100
000125210908     O                                           55 'DATE:'                                   LRI100
000126210908     O                       ULRNDD              66                                           LRI100
000127210908     O                                           67 '-'                                       LRI100
000128210908     O                       ULRNMM              70                                           LRI100
000129210908     O                                           71 '-'                                       LRI100
000130210908     O                       ULRNYY              73                                           LRI100
000131210908     O*                                                                                       LRI100
000132210908     O          E    87 84                    15                                              LRI100
000133210908     O                     36@WCNA2              44                                           LRI100
000134210908     O*                                                                                       LRI100
000135210908     O          E    87 84                    16                                              LRI100
000136210908     O                     36@WCNA3              44                                           LRI100
000137210908     O                                           58 'PAGE NO:'                                LRI100
000138210908     O                       STPA          3     67                                           LRI100
000139210908     O*                                                                                       LRI100
000140210908     O          E    87 84                    17                                              LRI100
000141210908     O                     36@WCNA4              44                                           LRI100
000142210908     O*                                                                                       LRI100
000143210908     O          E    87 84                    18                                              LRI100
000144210908     O                                           61 'ACCOUNT NO:'                             LRI100
000145210908     O                       ACNO                83                                           LRI100
000146210908     O*                                                                                       LRI100
000147210908     O*                                                                                       LRI100
000148210908     O          E    87 84                    20                                              LRI100
000149210908     O                                           63 'ACCOUNT TYPE:'                           LRI100
000150210908     O                       ULACTP              79                                           LRI100
000151210908     O*                                                                                       LRI100
000152210908     O          E    87 84                    22                                              LRI100
000153210908     O                                           59 'CURRENCY:'                               LRI100
000154210908     O                       CCY                 67                                           LRI100
000155210908     O*                                                                                       LRI100
000156210908     O          E    87 84                    23                                              LRI100
000157210908     O                       CCNM                78                                           LRI100
000158210908     O*                                                                                       LRI100
000159210908     O** Brought Forward Line                                                                 LRI100
000160210908     O          E    87 84                    27                                              LRI100
000161210908     O              N45      ULLSDD               2                                           LRI100
000162210908     O              N45                           3 '-'                                       LRI100
000163210908     O              N45      ULLSMM               6                                           LRI100
000164210908     O              N45                           7 '-'                                       LRI100
000165210908     O              N45      ULLSYY               9                                           LRI100
000166210908     O               45                           6 'CONTD.'                                  LRI100
000167210908     O                                           44 'BALANCE BROUGHT FORWARD'                 LRI100
000168210908     O                     70ULPSBF              92 '  ,   ,   , 0 CR'                        LRI100
000169210908     O                     71ULPSBF              92 ' ,   ,   , 0 . CR'                       LRI100
000170210908     O                     72ULPSBF              92 '   ,   , 0 .  CR'                        LRI100
000171210908     O                     73ULPSBF              92 '  ,   , 0 .   CR'                        LRI100
000172210908     O                       PSTDRF              92                                           LRI100
000173210908     O*                                                                                       LRI100
000174210908     O** Detail Line                                                                          LRI100
000175210908     O          E    40 51N04DET         2                                                    LRI100
000176210908     O         AND   84                                                                       LRI100
000177210908     O*                                                                                       LRI100
000178210908     O** Posting Date                                                                         LRI100
000179210908     O                       ULPSDD               2                                           LRI100
000180210908     O                                            3 '-'                                       LRI100
000181210908     O                       ULPSMM               6                                           LRI100
000182210908     O                                            7 '-'                                       LRI100
000183210908     O                       ULPSYY               9                                           LRI100
000184210908     O*                                                                                       LRI100
000185210908     O** Value Date                                                                           LRI100
000186210908     O                       ULVLDD              13                                           LRI100
000187210908     O                                           14 '-'                                       LRI100
000188210908     O                       ULVLMM              17                                           LRI100
000189210908     O                                           18 '-'                                       LRI100
000190210908     O                       ULVLYY              20                                           LRI100
000191210908     O*                                                                                       LRI100
000192210908     O** Narrative                                                                            LRI100
000193210908     O                       ULPNAR              46                                           LRI100
000194210908     O*                                                                                       LRI100
000195210908     O** Debits                                                                               LRI100
000196210908     O                  23 70ULPSTA              61 '  ,   ,   , 0 '                          LRI100
000197210908     O                  23 71ULPSTA              61 ' ,   ,   , 0 . '                         LRI100
000198210908     O                  23 72ULPSTA              61 '   ,   , 0 .  '                          LRI100
000199210908     O                  23 73ULPSTA              61 '  ,   , 0 .   '                          LRI100
000200210908     O*                                                                                       LRI100
000201210908     O** Credits                                                                              LRI100
000202210908     O                  22 70ULPSTA              75 '  ,   ,   , 0 '                          LRI100
000203210908     O                  22 71ULPSTA              75 ' ,   ,   , 0 . '                         LRI100
000204210908     O                  22 72ULPSTA              75 '   ,   , 0 .  '                          LRI100
000205210908     O                  22 73ULPSTA              75 '  ,   , 0 .   '                          LRI100
000206210908     O*                                                                                       LRI100
000207210908     O** Balance for this Posting Date                                                        LRI100
000208210908     O          E    L1 40 49BAL         0  0                                                 LRI100
000209210908     O         AND  N52 51 84                                                                 LRI100
000210210908     O                     70ULPSBL              92 '  ,   ,   , 0 CR'                        LRI100
000211210908     O                     71ULPSBL              92 ' ,   ,   , 0 . CR'                       LRI100
000212210908     O                     72ULPSBL              92 '   ,   , 0 .  CR'                        LRI100
000213210908     O                     73ULPSBL              92 '  ,   , 0 .   CR'                        LRI100
000214210908     O                       PSTDRL              92                                           LRI100
000215210908     O*                                                                                       LRI100
000216210908     O** Additional Narrative Lines                                                           LRI100
000217210908     O          E    40 51N04DET1        1                                                    LRI100
000218210908     O         AND   84                                                                       LRI100
000219210908     O                       LNAR1               46                                           LRI100
000220210908     O*                                                                                       LRI100
000221210908     O          E    40 51N04DET2        1                                                    LRI100
000222210908     O         AND   84                                                                       LRI100
000223210908     O                       LNAR2               46                                           LRI100
000224210908     O*                                                                                       LRI100
000225210908     O          E    40 51N04DET3        1                                                    LRI100
000226210908     O         AND   84                                                                       LRI100
000227210908     O                       LNAR3               36                                           LRI100
000228210908     O*                                                                                       LRI100
000229210908     O** Carried Forward Line                                                                 LRI100
000230210908     O          E    84 40 18TOT         2                                                    LRI100
000231210908     O         AND  N33                                                                       LRI100
000232210908     O                                           44 'BALANCE CARRIED FORWARD'                 LRI100
000233210908     O                     70ULPSBL              92 '  ,   ,   , 0 CR'                        LRI100
000234210908     O                     71ULPSBL              92 ' ,   ,   , 0 . CR'                       LRI100
000235210908     O                     72ULPSBL              92 '   ,   , 0 .  CR'                        LRI100
000236210908     O                     73ULPSBL              92 '  ,   , 0 .   CR'                        LRI100
000237210908     O                       PSTDRL              92                                           LRI100
000238210908     O*                                                                                       LRI100
000239210908     O** Total Time Heading                                                                   LRI100
000240210908     O          E    84 40 18TOT              14                                              LRI100
000241210908     O         AND  N33                                                                       LRI100
000242210908     O                  36   @WCNA1              44                                           LRI100
000243210908     O                                           55 'DATE:'                                   LRI100
000244210908     O                       ULRNDD              66                                           LRI100
000245210908     O                                           67 '-'                                       LRI100
000246210908     O                       ULRNMM              70                                           LRI100
000247210908     O                                           71 '-'                                       LRI100
000248210908     O                       ULRNYY              73                                           LRI100
000249210908     O*                                                                                       LRI100
000250210908     O          E    84 40 18TOT              15                                              LRI100
000251210908     O         AND  N33                                                                       LRI100
000252210908     O                     36@WCNA2              44                                           LRI100
000253210908     O*                                                                                       LRI100
000254210908     O          E    84 40 18TOT              16                                              LRI100
000255210908     O         AND  N33                                                                       LRI100
000256210908     O                     36@WCNA3              44                                           LRI100
000257210908     O                                           58 'PAGE NO:'                                LRI100
000258210908     O                       STPA          3     67                                           LRI100
000259210908     O*                                                                                       LRI100
000260210908     O          E    84 40 18TOT              17                                              LRI100
000261210908     O         AND  N33                                                                       LRI100
000262210908     O                     36@WCNA4              44                                           LRI100
000263210908     O*                                                                                       LRI100
000264210908     O          E    84 40 18TOT              18                                              LRI100
000265210908     O         AND  N33                                                                       LRI100
000266210908     O                                           61 'ACCOUNT NO:'                             LRI100
000267210908     O                       ACNO                83                                           LRI100
000268210908     O*                                                                                       LRI100
000269210908     O*                                                                                       LRI100
000270210908     O          E    84 40 18                 20                                              LRI100
000271210908     O         AND  N33                                                                       LRI100
000272210908     O                                           63 'ACCOUNT TYPE:'                           LRI100
000273210908     O                       ULACTP              79                                           LRI100
000274210908     O*                                                                                       LRI100
000275210908     O          E    84 40 18TOT              22                                              LRI100
000276210908     O         AND  N33                                                                       LRI100
000277210908     O                                           59 'CURRENCY:'                               LRI100
000278210908     O                       CCY                 67                                           LRI100
000279210908     O*                                                                                       LRI100
000280210908     O** Total Time Brought Forward Line                                                      LRI100
000281210908     O          E    84 40 18TOT              27                                              LRI100
000282210908     O         AND  N33                                                                       LRI100
000283210908     O              N45      ULLSDD               2                                           LRI100
000284210908     O              N45                           3 '-'                                       LRI100
000285210908     O              N45      ULLSMM               6                                           LRI100
000286210908     O              N45                           7 '-'                                       LRI100
000287210908     O              N45      ULLSYY               9                                           LRI100
000288210908     O               45                           6 'CONTD.'                                  LRI100
000289210908     O                                           44 'BALANCE BROUGHT FORWARD'                 LRI100
000290210908     O                     70ULPSBF              92 '  ,   ,   , 0 CR'                        LRI100
000291210908     O                     71ULPSBF              92 ' ,   ,   , 0 . CR'                       LRI100
000292210908     O                     72ULPSBF              92 '   ,   , 0 .  CR'                        LRI100
000293210908     O                     73ULPSBF              92 '  ,   , 0 .   CR'                        LRI100
000294210908     O                       PSTDRF              92                                           LRI100
000295210908     O*                                                                                       LRI100
000296210908     O** End of Page Carried Forward Line                                                     LRI100
000297210908     O          E    84 40 45ENDPG       2                                                    LRI100
000298210908     O         AND  N33                                                                       LRI100
000299210908     O                                           44 'BALANCE CARRIED FORWARD'                 LRI100
000300210908     O                     70ULPSBL              92 '  ,   ,   , 0 CR'                        LRI100
000301210908     O                     71ULPSBL              92 ' ,   ,   , 0 . CR'                       LRI100
000302210908     O                     72ULPSBL              92 '   ,   , 0 .  CR'                        LRI100
000303210908     O                     73ULPSBL              92 '  ,   , 0 .   CR'                        LRI100
000304210908     O                       PSTDRL              92                                           LRI100
000305210908     O*                                                                                       LRI100
000306210908     O** Total Time Carried Forward Line                                                      LRI100
000307210908     O          E    84 40 52TOT         2                                                    LRI100
000308210908     O         AND  N33                                                                       LRI100
000309210908     O                                           44 'BALANCE CARRIED FORWARD'                 LRI100
000310210908     O                     70ULPSBL              92 '  ,   ,   , 0 CR'                        LRI100
000311210908     O                     71ULPSBL              92 ' ,   ,   , 0 . CR'                       LRI100
000312210908     O                     72ULPSBL              92 '   ,   , 0 .  CR'                        LRI100
000313210908     O                     73ULPSBL              92 '  ,   , 0 .   CR'                        LRI100
000314210908     O                       PSTDRL              92                                           LRI100
000315210908     O*                                                                                       LRI100
000316210908     O          E            ERPT1       2    03                                              LRI100
000317210908     O                                           66 '*** END OF REPORT '                      LRI100
000318210908     O               58                          77 'FOR BRANCH '                             LRI100
000319210908     O               58      BRCASV              80                                           LRI100
000320210908     O               58                          84 ' ***'                                    LRI100
000321210908     O              N58                          69 '***'                                     LRI100
000322210908     O*                                                                                       LRI100
