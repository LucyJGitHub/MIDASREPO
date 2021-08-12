      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL0420CP56 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (C) Copyright Finastra Internatonal Limited 2019             *
      *                                                               *
      *  Last Amend No. LUC132  *CREATE    DATE 30Jul19               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC132 - Amendments to Statement of Account feature AG       *
      *                                                               *
      *****************************************************************
      *
     C                   ELSE                                                   LUC132
     C     MATCH         SETGT     APOSTVB                                      LUC132
     C                   SETOFF                                         11      LUC132
     C                   READP     APOSTVB                              1515    LUC132
     C                   ENDIF                                                  LUC132
      *
      *****************************************************************
      * End of /COPY GL0420CP57                                       *
      *****************************************************************
