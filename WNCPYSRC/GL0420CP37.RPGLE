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
000118210908     C** If Statements File reset Available Lines                                             LRI100
000119210908     C     *IN01         IFEQ      *ON                                                        LRI100
000120210908     C                   Z-ADD     25            ULAVLN            2 0                        LRI100
000121210908     C                   ENDIF                                                                LRI100
000122210908     C*                                                                                       LRI100
