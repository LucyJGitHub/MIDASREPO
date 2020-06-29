      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL0420 - Balance Statements                                  *
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
     D*                                                                                       LRI100
     D SDACOD        E DS                  EXTNAME(SDACODPD)                                  LRI100
     D  QQACD3       E                     EXTFLD(QQACCD)                                     LRI100
     D** Account Code Details                                                                 LRI100
     D*                                                                                       LRI100
     D                 DS                                                                     LRI100
     D  ULRUNA                 1      7                                                       LRI100
     D  ULRNDD                 1      2                                                       LRI100
     D  ULRNMM                 3      5                                                       LRI100
     D  ULRNYY                 6      7                                                       LRI100
     D                 DS                                                                     LRI100
     D  PSTDA                  1      7                                                       LRI100
     D  ULPSDD                 1      2                                                       LRI100
     D  ULPSMM                 3      5                                                       LRI100
     D  ULPSYY                 6      7                                                       LRI100
     D                 DS                                                                     LRI100
     D  VALDA                  1      7                                                       LRI100
     D  ULVLDD                 1      2                                                       LRI100
     D  ULVLMM                 3      5                                                       LRI100
     D  ULVLYY                 6      7                                                       LRI100
     D                 DS                                                                     LRI100
     D  LSTDA                  1      7                                                       LRI100
     D  ULLSDD                 1      2                                                       LRI100
     D  ULLSMM                 3      5                                                       LRI100
     D  ULLSYY                 6      7                                                       LRI100
     D** Split Dates (DDMMMYY) into Days, Months & Years                                      LRI100
     D*                                                                                       LRI100
     D ULCRAC          C                   CONST('CURRENT ACCOUNT')                           LRI100
     D ULCLAC          C                   CONST('CALL ACCOUNT   ')                           LRI100
     D ULLNAC          C                   CONST('LOAN ACCOUNT   ')                           LRI100
     D** Named Constants for Account Types                                                    LRI100
     D*                                                                                       LRI100
     D XSPOS           DS                                                                     LRI100
     D  XBTNB                  1      3                                                       LRI100
     D  XBTIN                  4      6  0                                                    LRI100
     D** Split Batch Number and Batch Item Number                                             LRI100
     D*                                                                                       LRI100
     D                 DS                                                                     LRI100
     D  BAADI1                 1     65                                                       LRI100
     D  HAADI1                 1     65                                                       LRI100
     D  LNAR1                  1     25                                                       LRI100
     D  LNAR2                 26     50                                                       LRI100
     D  LNAR3                 51     65                                                       LRI100
     I** Data Structure to split Narrative Field                                              LRI100
     I*                                                                                       LRI100
