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
000118210908     C** Initialise Account Type                                                              LRI100
000119210908     C                   MOVEL     *BLANKS       ULACTP           15                          LRI100
000120210908     C*                                                                                       LRI100
000121210908     C** Current Account & Call Account                                                       LRI100
000122210908     C     ACOD          IFGE      3176000000                                                 LRI100
000123210908     C     ACOD          ANDLE     3184000000                                                 LRI100
000124210908     C     ACOD          ORGE      3201000000                                                 LRI100
000125210908     C     ACOD          ANDLE     3203000000                                                 LRI100
000126210908     C     ACOD          ORGE      3211000000                                                 LRI100
000127210908     C     ACOD          ANDLE     3213000000                                                 LRI100
000128210908     C*                                                                                       LRI100
000129210908     C     ACSQ          IFGE      1                                                          LRI100
000130210908     C     ACSQ          ANDLE     20                                                         LRI100
000131210908     C                   MOVEL     ULCRAC        ULACTP                                       LRI100
000132210908     C                   ENDIF                                                                LRI100
000133210908     C*                                                                                       LRI100
000134210908     C     ACSQ          IFGE      21                                                         LRI100
000135210908     C     ACSQ          ANDLE     35                                                         LRI100
000136210908     C                   MOVEL     ULCLAC        ULACTP                                       LRI100
000137210908     C                   ENDIF                                                                LRI100
000138210908     C*                                                                                       LRI100
000139210908     C                   ENDIF                                                                LRI100
000140210908     C*                                                                                       LRI100
000141210908     C** Loan Account                                                                         LRI100
000142210908     C     ACOD          IFGE      1401000000                                                 LRI100
000143210908     C     ACOD          ANDLE     1408000000                                                 LRI100
000144210908     C     ACOD          ORGE      1412000000                                                 LRI100
000145210908     C     ACOD          ANDLE     1417000000                                                 LRI100
000146210908     C*                                                                                       LRI100
000147210908     C     ACSQ          IFGE      1                                                          LRI100
000148210908     C     ACSQ          ANDLE     20                                                         LRI100
000149210908     C                   MOVEL     ULLNAC        ULACTP           15                          LRI100
000150210908     C                   ENDIF                                                                LRI100
000151210908     C*                                                                                       LRI100
000152210908     C                   ENDIF                                                                LRI100
000153210908     C*                                                                                       LRI100
000154210908     C** Reformat Run Date                                                                    LRI100
000155210908     C                   MOVEL     RUNA          ULRUNA                                       LRI100
000156210908     C*                                                                                       LRI100
