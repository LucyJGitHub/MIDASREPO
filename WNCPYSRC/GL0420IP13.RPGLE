000100210908      *****************************************************************
000101210908      *                                                               *
000102210908      *  Midas - General Ledger                                       *
000103210908      *                                                               *
000104210908      *  GL0420 - Balance Statements                                  *
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
000119210908     D*                                                                                       LRI100
000120210908     D SDACOD        E DS                  EXTNAME(SDACODPD)                                  LRI100
000121210908     D  QQACD3       E                     EXTFLD(QQACCD)                                     LRI100
000122210908     D** Account Code Details                                                                 LRI100
000123210908     D*                                                                                       LRI100
000124210908     D                 DS                                                                     LRI100
000125210908     D  ULRUNA                 1      7                                                       LRI100
000126210908     D  ULRNDD                 1      2                                                       LRI100
000127210908     D  ULRNMM                 3      5                                                       LRI100
000128210908     D  ULRNYY                 6      7                                                       LRI100
000129210908     D                 DS                                                                     LRI100
000130210908     D  PSTDA                  1      7                                                       LRI100
000131210908     D  ULPSDD                 1      2                                                       LRI100
000132210908     D  ULPSMM                 3      5                                                       LRI100
000133210908     D  ULPSYY                 6      7                                                       LRI100
000134210908     D                 DS                                                                     LRI100
000135210908     D  VALDA                  1      7                                                       LRI100
000136210908     D  ULVLDD                 1      2                                                       LRI100
000137210908     D  ULVLMM                 3      5                                                       LRI100
000138210908     D  ULVLYY                 6      7                                                       LRI100
000139210908     D                 DS                                                                     LRI100
000140210908     D  LSTDA                  1      7                                                       LRI100
000141210908     D  ULLSDD                 1      2                                                       LRI100
000142210908     D  ULLSMM                 3      5                                                       LRI100
000143210908     D  ULLSYY                 6      7                                                       LRI100
000144210908     D** Split Dates (DDMMMYY) into Days, Months & Years                                      LRI100
000145210908     D*                                                                                       LRI100
000146210908     D ULCRAC          C                   CONST('CURRENT ACCOUNT')                           LRI100
000147210908     D ULCLAC          C                   CONST('CALL ACCOUNT   ')                           LRI100
000148210908     D ULLNAC          C                   CONST('LOAN ACCOUNT   ')                           LRI100
000149210908     D** Named Constants for Account Types                                                    LRI100
000150210908     D*                                                                                       LRI100
000151210908     D XSPOS           DS                                                                     LRI100
000152210908     D  XBTNB                  1      3                                                       LRI100
000153210908     D  XBTIN                  4      6  0                                                    LRI100
000154210908     D** Split Batch Number and Batch Item Number                                             LRI100
000155210908     D*                                                                                       LRI100
000156210908     D                 DS                                                                     LRI100
000157210908     D  BAADI1                 1     65                                                       LRI100
000158210908     D  HAADI1                 1     65                                                       LRI100
000159210908     D  LNAR1                  1     25                                                       LRI100
000160210908     D  LNAR2                 26     50                                                       LRI100
000161210908     D  LNAR3                 51     65                                                       LRI100
000162210908     I** Data Structure to split Narrative Field                                              LRI100
000163210908     I*                                                                                       LRI100
