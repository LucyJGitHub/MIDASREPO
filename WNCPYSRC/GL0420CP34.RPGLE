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
     C** Initialise Account Type                                                              LRI100
     C                   MOVEL     *BLANKS       ULACTP           15                          LRI100
     C*                                                                                       LRI100
     C** Current Account & Call Account                                                       LRI100
     C     ACOD          IFGE      3176000000                                                 LRI100
     C     ACOD          ANDLE     3184000000                                                 LRI100
     C     ACOD          ORGE      3201000000                                                 LRI100
     C     ACOD          ANDLE     3203000000                                                 LRI100
     C     ACOD          ORGE      3211000000                                                 LRI100
     C     ACOD          ANDLE     3213000000                                                 LRI100
     C*                                                                                       LRI100
     C     ACSQ          IFGE      1                                                          LRI100
     C     ACSQ          ANDLE     20                                                         LRI100
     C                   MOVEL     ULCRAC        ULACTP                                       LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
     C     ACSQ          IFGE      21                                                         LRI100
     C     ACSQ          ANDLE     35                                                         LRI100
     C                   MOVEL     ULCLAC        ULACTP                                       LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
     C** Loan Account                                                                         LRI100
     C     ACOD          IFGE      1401000000                                                 LRI100
     C     ACOD          ANDLE     1408000000                                                 LRI100
     C     ACOD          ORGE      1412000000                                                 LRI100
     C     ACOD          ANDLE     1417000000                                                 LRI100
     C*                                                                                       LRI100
     C     ACSQ          IFGE      1                                                          LRI100
     C     ACSQ          ANDLE     20                                                         LRI100
     C                   MOVEL     ULLNAC        ULACTP           15                          LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
     C** Reformat Run Date                                                                    LRI100
     C                   MOVEL     RUNA          ULRUNA                                       LRI100
     C*                                                                                       LRI100
