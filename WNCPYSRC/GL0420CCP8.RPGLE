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
     C*                                                                                       LRI100
     C** Only print first 11 digits of amount fields                                          LRI100
     C                   Z-ADD     PSTBF         ULPSBF           11 0                        LRI100
     C                   Z-ADD     PSTBAL        ULPSBL           11 0                        LRI100
     C*                                                                                       LRI100
     C* Determine if DR or CR                                                                 LRI100
     C*                                                                                       LRI100
     C     PSTBF         IFGE      0                                                          LRI100
     C                   MOVE      'DR'          PSTDRF            2                          LRI100
     C                   ELSE                                                                 LRI100
     C                   MOVE      'CR'          PSTDRF                                       LRI100
     C                   END                                                                  LRI100
     C*                                                                                       LRI100
     C     PSTBAL        IFGE      0                                                          LRI100
     C                   MOVE      'DR'          PSTDRL            2                          LRI100
     C                   ELSE                                                                 LRI100
     C                   MOVE      'CR'          PSTDRL                                       LRI100
     C                   END                                                                  LRI100
