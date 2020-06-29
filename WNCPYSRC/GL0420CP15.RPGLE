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
     C** If Print Format '5'                                                                  LRI100
     C     *IN40         IFEQ      *ON                                                        LRI100
     C*                                                                                       LRI100
     C** Only Print Non-Blank Narrative                                                       LRI100
     C     ULNARR        IFEQ      'Y'                                                        LRI100
      *                                                                                       LRI100
     C     LNAR1         IFNE      *BLANKS                                                    LRI100
     C                   EXCEPT    DET1                                                       LRI100
     C                   ENDIF                                                                LRI100
      *                                                                                       LRI100
     C     LNAR2         IFNE      *BLANKS                                                    LRI100
     C                   EXCEPT    DET2                                                       LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
     C     LNAR3         IFNE      *BLANKS                                                    LRI100
     C                   EXCEPT    DET3                                                       LRI100
     C                   ENDIF                                                                LRI100
      *                                                                                       LRI100
     C                   ENDIF                                                                LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
