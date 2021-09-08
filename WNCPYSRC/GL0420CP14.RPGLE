000100210908      *****************************************************************
000101210908      *                                                               *
000102210908      *  Midas - General Ledger                                       *
000103210908      *                                                               *
000104210908      *  GL0420CP14 - Balance Statements                              *
000105210908      *                                                               *
000106210908      *  (c) Finastra International Limited 2020                      *
000107210908      *                                                               *
000108210908      *  Last amend No. LRI100  *AMEND     Date 05May20               *
000109210908      *  Prev amend No. LRI100  *CREATE    Date 17Mar20               *
000110210908      *                                                               *
000111210908      *---------------------------------------------------------------*
000112210908      *                                                               *
000113210908      *  LRI100 - Additional info. entries not statemented since      *
000114210908      *           exist on history file                               *
000115210908      *  LRI100 - Statement Format Changes                            *
000116210908      *         - Upgrade CARs LRI009/LRI010 to FB Midas.             *
000117210908      *                                                               *
000118210908      *****************************************************************
000119210908     C* if posting is to print,                                                               LRI100
000120210908     C     *IN40         IFEQ      *ON                                                        LRI100
000121210908     C     *IN51         ANDEQ     *ON                                                        LRI100
000122210908     C     *IN04         ANDEQ     *OFF                                                       LRI100
000123210908     C     *IN84         ANDEQ     *ON                                                        LRI100
000124210908     C*                                                                                       LRI100
000125210908     C** Key Field for Journal Entry Extension File                                           LRI100
000126210908     C     KEY           KLIST                                                                LRI100
000127210908     C                   KFLD                    XPSDT                                        LRI100
000128210908     C                   KFLD                    XBTNB                                        LRI100
000129210908     C                   KFLD                    XBTIN                                        LRI100
000130210908     C*                                                                                       LRI100
000131210908     C     *LIKE         DEFINE    PSTD          XPSDT                                        LRI100
000132210908     C*                                                                                       LRI100
000133210908     C                   MOVE      PSTD          XPSDT                                        LRI100
000134210908     C                   MOVEL     SPOS          XSPOS                                        LRI100
000135210908     C*                                                                                       LRI100
000136210908     C     KEY           CHAIN     GLJENXL1                           24                      LRI100
000137210908     C     *IN24         IFEQ      *ON                                                        LRI100
000138210908     C     KEY           CHAIN     GLJEHXL2                           24                      LRI100
000139210908     C                   ENDIF                                                                LRI100
000140210908     C*                                                                                       LRI100
000141210908     C** Only Print Non-Blank Narrative                                                       LRI100
000142210908     C     *IN24         IFEQ      *OFF                                                       LRI100
000143210908     C                   MOVEL     'Y'           ULNARR            1                          LRI100
000144210908     C                   ELSE                                                                 LRI100
000145210908     C                   MOVEL     'N'           ULNARR                                       LRI100
000146210908     C                   ENDIF                                                                LRI100
000147210908     C*                                                                                       LRI100
000148210908     C** If Narrative Exists subtract neccessary lines from Available                         LRI100
000149210908     C** Lines                                                                                LRI100
000150210908     C     ULNARR        IFEQ      'Y'                                                        LRI100
000151210908     C     LNAR1         IFNE      *BLANKS                                                    LRI100
000152210908     C                   SUB       1             ULAVLN                                       LRI100
000153210908     C                   ENDIF                                                                LRI100
000154210908     C*                                                                                       LRI100
000155210908     C     LNAR2         IFNE      *BLANKS                                                    LRI100
000156210908     C                   SUB       1             ULAVLN                                       LRI100
000157210908     C                   ENDIF                                                                LRI100
000158210908     C*                                                                                       LRI100
000159210908     C     LNAR3         IFNE      *BLANKS                                                    LRI100
000160210908     C                   SUB       1             ULAVLN                                       LRI100
000161210908     C                   ENDIF                                                                LRI100
000162210908     C                   ENDIF                                                                LRI100
000163210908     C*                                                                                       LRI100
000164210908     C** Subtract 2 for double spaced posting record.                                         LRI100
000165210908     C                   SUB       2             ULAVLN                                       LRI100
000166210908     C*                                                                                       LRI100
000167210908     C** When 'overflow' occurs, update Available Lines for New Page                          LRI100
000168210908     C** and write End of Page                                                                LRI100
000169210908     C     ULAVLN        IFLE      0                                                          LRI100
000170210908      *                                                                                       LRI100
000171210908      ** Save current value of balance                                                        LRI100
000172210908     C                   Z-ADD     ULPSBL        ULBLSV           11 0                        LRI100
000173210908      *                                                                                       LRI100
000174210908      ** Reduce Balance Carried forward by amount of posting                                  LRI100
000175210908      ** (Posting appears on next page and should not be included                             LRI100
000176210908      **  in running total.)                                                                  LRI100
000177210908     C   22PSTBAL        ADD       PSTA          ULPSBL                                       LRI100
000178210908     C   23PSTBAL        SUB       PSTA          ULPSBL                                       LRI100
000179210908      *                                                                                       LRI100
000180210908      ** Determine if 'DR' needs to be printed                                                LRI100
000181210908     C     ULPSBL        IFGT      0                                                          LRI100
000182210908     C                   MOVE      'DR'          PSTDRL            2                          LRI100
000183210908     C                   ELSE                                                                 LRI100
000184210908     C                   MOVE      'CR'          PSTDRL                                       LRI100
000185210908     C                   END                                                                  LRI100
000186210908      *                                                                                       LRI100
000187210908     C                   ADD       1             STPA                                         LRI100
000188210908     C                   ADD       24            ULAVLN                                       LRI100
000189210908     C                   MOVEL     *ON           *IN45                                        LRI100
000190210908     C                   EXCEPT    ENDPG                                                      LRI100
000191210908     C                   MOVE      *ON           *IN87                                        LRI100
000192210908     C                   MOVE      *ON           *IN84                                        LRI100
000193210908     C                   EXCEPT                                                               LRI100
000194210908     C                   MOVEL     *OFF          *IN45                                        LRI100
000195210908      *                                                                                       LRI100
000196210908      ** Reset balance                                                                        LRI100
000197210908     C                   Z-ADD     ULBLSV        ULPSBL                                       LRI100
000198210908      *                                                                                       LRI100
000199210908     C                   ENDIF                                                                LRI100
000200210908     C*                                                                                       LRI100
000201210908     C                   ENDIF                                                                LRI100
000202210908     C*                                                                                       LRI100
