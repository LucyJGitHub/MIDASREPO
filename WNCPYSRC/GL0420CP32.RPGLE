      *****************************************************************
      *                                                               *
      *  Midas GENERAL LEDGER MODULE                                  *
      *                                                               *
      *  GL0420CP32 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC108  *CREATE    DATE 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      *
     C     LUC108        IFEQ      'Y'                                                        LUC108
     C     KLS99         KLIST                                                                LUC108
     C                   KFLD                    G@CCY             3                          LUC108
     C                   KFLD                    G@DRIB            2                          LUC108
      *                                                                                       LUC108
     C                   MOVE      CCY           G@CCY                                        LUC108
     C                   MOVE      DRIB          G@DRIB                                       LUC108
      *                                                                                       LUC108
     C                   MOVE      *ON           *IN16                                        LUC108
     C                   Z-ADD     *ZEROS        G@BRTE                                       LUC108
      * Print only if DRIB input.                                                             LUC108
     C     G@DRIB        IFNE      *BLANKS                                                    LUC108
     C     G@DRIB        ANDNE     '00'                                                       LUC108
     C                   Z-ADD     *ZEROS        G@BRTE                                       LUC108
     C     KLS99         CHAIN     SDBSRTL1                           99                      LUC108
     C     *IN99         IFEQ      *OFF                                                       LUC108
     C                   Z-ADD     BACBSR        G@BRTE           11 7                        LUC108
     C                   MOVE      *OFF          *IN16                                        LUC108
     C                   ENDIF                                                                LUC108
     C                   ENDIF                                                                LUC108
     C                   ENDIF                                                                LUC108
      *
      *****************************************************************
      * End of /COPY GL0420CP32                                       *
      *****************************************************************
