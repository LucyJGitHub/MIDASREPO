      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL4114 - Postings file check                                 *
      *                                                               *
      *  (c) Finastra International Systems Ltd. 2021                 *
      *                                                               *
      *  Last Amend No. LUC140  *Create    Date 05Feb21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC140 - Upgrade MMI013 Italian Stamp Duty to FM2.1          *
      *                                                               *
      *****************************************************************
      *
     C     *IN09         IFEQ      '1'                                                       LUC140
     C     NORE          SUB       2             @NORE             5 0                       LUC140
     C     @NORE         IFGT      0                                                         LUC140
     C                   ADD       @NORE         TNORE             5 0                       LUC140
     C                   ENDIF                                                               LUC140
     C                   ADD       ZZINT         TTOTI            15 0                       LUC140
     C                   ADD       ZZDEC         @TOTD             6 0                       LUC140
     C                   ENDIF                                                               LUC140
      *                                                                                      LUC140
     C     *IN10         IFEQ      '1'                                                       LUC140
     C     NORE          SUB       2             @NORE             5 0                       LUC140
     C     @NORE         IFGT      0                                                         LUC140
     C                   ADD       @NORE         TNORE             5 0                       LUC140
     C                   ENDIF                                                               LUC140
     C                   ADD       ZZINT         TTOTI            15 0                       LUC140
     C                   ADD       ZZDEC         @TOTD             6 0                       LUC140
     C                   ENDIF                                                               LUC140
      *
      *****************************************************************
      * End of /COPY LUC140_024                                       *
      *****************************************************************
