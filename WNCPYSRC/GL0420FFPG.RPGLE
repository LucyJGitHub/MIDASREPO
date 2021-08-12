      *****************************************************************
      *                                                               *
      *  Midas GENERAL LEDGER MODULE                                  *
      *                                                               *
      *  GL0420FFPG - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC132             DATE 30Jul19               *
      *  Prev Amend No. LUC108  *CREATE    DATE 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC132 - Amendments to Statement of Account feature AG       *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
     FSDBSRTL1  IF   E           K DISK    USROPN
      *
     F**APOSTVB   IF   F  331    18AIDISK    KEYLOC(2)                            LUC132
     FAPOSTVB   IF   F  620    24AIDISK    KEYLOC(2)                              LUC132
     F
      *****************************************************************
      * End of /COPY GL0420FFPG                                       *
      *****************************************************************
