      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (GL0420)                                *
      *                                                               *
      *  GL0420CP32 - BALANCE STATEMENTS (A/C FORMATS)                *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2016            *
      *                                                               *
      *  Last Amend No. LUC108   *CREATE   Date 19Apr16               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  LUC108 - Statement of Accounts                               *
      *                                                               *
      *****************************************************************
      *
     C     LUC108        IFEQ      'Y'
     C     KLS99         KLIST
     C                   KFLD                    G@CCY             3
     C                   KFLD                    G@DRIB            2
      *
     C                   MOVE      CCY           G@CCY
     C                   MOVE      DRIB          G@DRIB
      *
     C                   MOVE      *ON           *IN16
     C                   Z-ADD     *ZEROS        G@BRTE
      * Print only if DRIB input.
     C     G@DRIB        IFNE      *BLANKS
     C     G@DRIB        ANDNE     '00'
     C                   Z-ADD     *ZEROS        G@BRTE
     C     KLS99         CHAIN     SDBSRTL1                           99
     C     *IN99         IFEQ      *OFF
     C                   Z-ADD     BACBSR        G@BRTE           11 7
     C                   MOVE      *OFF          *IN16
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL0420CP32                                       *
      *****************************************************************
