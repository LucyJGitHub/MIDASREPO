      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL0340 - Daily Journal                                       *
      *                                                               *
      *  (C) Copyright Midas-Kapiti International Ltd. 1998           *
      *                                                               *
      *  Last Amend No. LUC140             Date 23Feb21               *
      *  Prev Amend No. MMI013   *Create   Date 29Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      * LUC140  - Upgrade MMI013 to FM2.1                             *
      *           (MMI013 - Midas Italy RE Stamp Duty and Account)    *
      * MMI013  - Increase size of arrays for Stamp Duty Postings     *
      *                                                               *
      *****************************************************************
      *                                                                                       LUC140
      */OMITEND                                                                               LUC140
     D ARGP            S              1    DIM(28) CTDATA PERRCD(28)                          LUC140
     D ARLT            S             29    DIM(28) CTDATA PERRCD(1)                           LUC140
     D POST            S             16    DIM(7) CTDATA PERRCD(1)                            LUC140
     D ARNP            S              6  0 DIM(28)                                            LUC140
     D BRNP            S              6  0 DIM(28)                                            LUC140
     D ARTI            S             15  0 DIM(28)                                            LUC140
     D BRTI            S             15  0 DIM(28)                                            LUC140
     D ARTD            S              3  0 DIM(28)                                            LUC140
     D BRTD            S              3  0 DIM(28)                                            LUC140
      *****************************************************************
      * End of /COPY GL0340EEP1                                       *
      *****************************************************************
