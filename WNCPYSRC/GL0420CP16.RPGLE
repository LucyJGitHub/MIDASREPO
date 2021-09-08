000100210908      *****************************************************************
000101210908      *                                                               *
000102210908      *  Midas - General Ledger                                       *
000103210908      *                                                               *
000104210908      *  GL0420CP16 - Balance Statements                              *
000105210908      *                                                               *
000106210908      *  Last amend No. LRI100  *CREATE    Date 17Mar20               *
000107210908      *  Prev Amend No. XXXXXX             Date DDMMMYY               *
000108210908      *                                                               *
000109210908      *---------------------------------------------------------------*
000110210908      *                                                               *
000111210908      *  LRI100 - Statement Format Changes.                           *
000112210908      *         - Upgrade CARs LRI009/LRI010 to FB Midas.             *
000113210908      *                                                               *
000114210908      *****************************************************************
000115210908     C*                                                                                       LRI100
000116210908     C** Only print first 11 digits of amount fields                                          LRI100
000117210908     C   40              Z-ADD     PSTBAL        ULPSBL                                       LRI100
000118210908     C*                                                                                       LRI100
000119210908     C* Determine if DR or CR                                                                 LRI100
000120210908     C*                                                                                       LRI100
000121210908     C     ULPSBL        IFGE      0                                                          LRI100
000122210908     C                   MOVE      'DR'          PSTDRL            2                          LRI100
000123210908     C                   ELSE                                                                 LRI100
000124210908     C                   MOVE      'CR'          PSTDRL                                       LRI100
000125210908     C                   END                                                                  LRI100
