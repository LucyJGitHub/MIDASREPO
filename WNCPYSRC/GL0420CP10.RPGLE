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
000117210908     C*                                                                                       LRI100
000118210908     C** Only print first 11 digits of amount fields                                          LRI100
000119210908     C   40              Z-ADD     PSTBAL        ULPSBF           11 0                        LRI100
000120210908     C*                                                                                       LRI100
000121210908     C*                                                                                       LRI100
000122210908     C* Determine if DR or CR                                                                 LRI100
000123210908     C*                                                                                       LRI100
000124210908     C     ULPSBL        IFGE      0                                                          LRI100
000125210908     C                   MOVE      'DR'          PSTDRL            2                          LRI100
000126210908     C                   ELSE                                                                 LRI100
000127210908     C                   MOVE      'CR'          PSTDRL                                       LRI100
000128210908     C                   END                                                                  LRI100
000129210908     C*                                                                                       LRI100
000130210908     C     ULPSBF        IFGE      0                                                          LRI100
000131210908     C                   MOVE      'DR'          PSTDRF            2                          LRI100
000132210908     C                   ELSE                                                                 LRI100
000133210908     C                   MOVE      'CR'          PSTDRF                                       LRI100
000134210908     C                   END                                                                  LRI100
