      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL0420CP16 - Balance Statements                              *
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
     C   40              Z-ADD     PSTBAL        ULPSBL                                       LRI100
     C*                                                                                       LRI100
     C* Determine if DR or CR                                                                 LRI100
     C*                                                                                       LRI100
     C     ULPSBL        IFGE      0                                                          LRI100
     C                   MOVE      'DR'          PSTDRL            2                          LRI100
     C                   ELSE                                                                 LRI100
     C                   MOVE      'CR'          PSTDRL                                       LRI100
     C                   END                                                                  LRI100
