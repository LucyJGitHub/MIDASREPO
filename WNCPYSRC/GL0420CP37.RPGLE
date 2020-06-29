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
     C** If Statements File reset Available Lines                                             LRI100
     C     *IN01         IFEQ      *ON                                                        LRI100
     C                   Z-ADD     25            ULAVLN            2 0                        LRI100
     C                   ENDIF                                                                LRI100
     C*                                                                                       LRI100
