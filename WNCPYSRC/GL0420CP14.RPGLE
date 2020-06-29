      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL0420CP14 - Balance Statements                              *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last amend No. LRI100  *AMEND     Date 05May20               *
      *  Prev amend No. LRI100  *CREATE    Date 17Mar20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LRI100 - Additional info. entries not statemented since      *
      *           exist on history file                               *
      *  LRI100 - Statement Format Changes                            *
      *         - Upgrade CARs LRI009/LRI010 to FB Midas.             *
      *                                                               *
      *****************************************************************
     C* if posting is to print,                                                               LRI100
     C     *IN40         IFEQ      *ON                                                        LRI100
     C     *IN51         ANDEQ     *ON                                                        LRI100
     C     *IN04         ANDEQ     *OFF                                                       LRI100
     C     *IN84         ANDEQ     *ON                                                        LRI100
     C*                                                                                       LRI100
     C** Key Field for Journal Entry Extension File                                           LRI100
     C     KEY           KLIST                                                                LRI100
     C                   KFLD                    XPSDT                                        LRI100
     C                   KFLD                    XBTNB                                        LRI100
     C                   KFLD                    XBTIN                                        LRI100
     C*                                                                                       LRI100
     C     *LIKE         DEFINE    PSTD          XPSDT                                        LRI100
     C*                                                                                       LRI100
     C                   MOVE      PSTD          XPSDT                                        LRI100
     C                   MOVEL     SPOS          XSPOS                                        LRI100
     C*                                                                                       LRI100
     C     KEY           CHAIN     GLJENXL1                           24                      LRI100
     C     *IN24         IFEQ      *ON                                                        LRI100
     C     KEY           CHAIN     GLJEHXL2                           24                      LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
     C** Only Print Non-Blank Narrative                                                       LRI100
     C     *IN24         IFEQ      *OFF                                                       LRI100
     C                   MOVEL     'Y'           ULNARR            1                          LRI100
     C                   ELSE                                                                 LRI100
     C                   MOVEL     'N'           ULNARR                                       LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
     C** If Narrative Exists subtract neccessary lines from Available                         LRI100
     C** Lines                                                                                LRI100
     C     ULNARR        IFEQ      'Y'                                                        LRI100
     C     LNAR1         IFNE      *BLANKS                                                    LRI100
     C                   SUB       1             ULAVLN                                       LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
     C     LNAR2         IFNE      *BLANKS                                                    LRI100
     C                   SUB       1             ULAVLN                                       LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
     C     LNAR3         IFNE      *BLANKS                                                    LRI100
     C                   SUB       1             ULAVLN                                       LRI100
     C                   ENDIF                                                                LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
     C** Subtract 2 for double spaced posting record.                                         LRI100
     C                   SUB       2             ULAVLN                                       LRI100
     C*                                                                                       LRI100
     C** When 'overflow' occurs, update Available Lines for New Page                          LRI100
     C** and write End of Page                                                                LRI100
     C     ULAVLN        IFLE      0                                                          LRI100
      *                                                                                       LRI100
      ** Save current value of balance                                                        LRI100
     C                   Z-ADD     ULPSBL        ULBLSV           11 0                        LRI100
      *                                                                                       LRI100
      ** Reduce Balance Carried forward by amount of posting                                  LRI100
      ** (Posting appears on next page and should not be included                             LRI100
      **  in running total.)                                                                  LRI100
     C   22PSTBAL        ADD       PSTA          ULPSBL                                       LRI100
     C   23PSTBAL        SUB       PSTA          ULPSBL                                       LRI100
      *                                                                                       LRI100
      ** Determine if 'DR' needs to be printed                                                LRI100
     C     ULPSBL        IFGT      0                                                          LRI100
     C                   MOVE      'DR'          PSTDRL            2                          LRI100
     C                   ELSE                                                                 LRI100
     C                   MOVE      'CR'          PSTDRL                                       LRI100
     C                   END                                                                  LRI100
      *                                                                                       LRI100
     C                   ADD       1             STPA                                         LRI100
     C                   ADD       24            ULAVLN                                       LRI100
     C                   MOVEL     *ON           *IN45                                        LRI100
     C                   EXCEPT    ENDPG                                                      LRI100
     C                   MOVE      *ON           *IN87                                        LRI100
     C                   MOVE      *ON           *IN84                                        LRI100
     C                   EXCEPT                                                               LRI100
     C                   MOVEL     *OFF          *IN45                                        LRI100
      *                                                                                       LRI100
      ** Reset balance                                                                        LRI100
     C                   Z-ADD     ULBLSV        ULPSBL                                       LRI100
      *                                                                                       LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
