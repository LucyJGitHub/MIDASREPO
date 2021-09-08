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
000118210908     C** If Print Format '5'                                                                  LRI100
000119210908     C     *IN40         IFEQ      *ON                                                        LRI100
000120210908     C*                                                                                       LRI100
000121210908     C** Only Print Non-Blank Narrative                                                       LRI100
000122210908     C     ULNARR        IFEQ      'Y'                                                        LRI100
000123210908      *                                                                                       LRI100
000124210908     C     LNAR1         IFNE      *BLANKS                                                    LRI100
000125210908     C                   EXCEPT    DET1                                                       LRI100
000126210908     C                   ENDIF                                                                LRI100
000127210908      *                                                                                       LRI100
000128210908     C     LNAR2         IFNE      *BLANKS                                                    LRI100
000129210908     C                   EXCEPT    DET2                                                       LRI100
000130210908     C                   ENDIF                                                                LRI100
000131210908     C*                                                                                       LRI100
000132210908     C     LNAR3         IFNE      *BLANKS                                                    LRI100
000133210908     C                   EXCEPT    DET3                                                       LRI100
000134210908     C                   ENDIF                                                                LRI100
000135210908      *                                                                                       LRI100
000136210908     C                   ENDIF                                                                LRI100
000137210908     C                   ENDIF                                                                LRI100
000138210908     C*                                                                                       LRI100
