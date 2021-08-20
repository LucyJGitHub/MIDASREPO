      *****************************************************************
      *                                                               *
      *  Midas - General Ledger                                       *
      *                                                               *
      *  GL0340 - Daily Journal                                       *
      *                                                               *
      *  (C) Copyright Midas-Kapiti International Ltd. 1998           *
      *                                                               *
      *  Last Amend No. LUC140             Date 26Feb21               *
      *  Prev Amend No. MMI013             Date 29Sep98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      * LUC140  - Upgrade MMI013 to FM2.1                             *
      * MMI013  - Increase size of arrays for Stamp Duty Postings     *
      *                                                               *
      *****************************************************************
      *                                                                         LUC140
      */OMITEND                                                                 LUC140
     C*R******** X         IFGT 25                                  MMI018MMI013
     CLR   X             IFGT      27                                                         LUC140
      *****************************************************************
      * End of /COPY GL0340CP10                                       *
      *****************************************************************
