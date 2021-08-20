      *****************************************************************
      *                                                               *
      *  Midas GENERAL LEDGER MODULE                                  *
      *                                                               *
      *  GL0420CP44 - BALANCE STATEMENTS (A/C FORMATS)                *
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
      *
     C     LUC108        IFEQ      'Y'
      *   HVB PROCESSING - CONVERT TRANSACTION TYPE TO TEXT
     C     TRAT          IFNE      *BLANKS
     C     TRAT          ANDNE     *ZEROS
     C     CHQN          ANDEQ     0
     C     RECI          ANDEQ     'P'
     C     *IN06         ANDEQ     *ON
     C                   CALL      'AORETRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    TRAT
     C     SDRETR        PARM      SDRETR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   Z-ADD     888           DBASE                       ****************
     C                   MOVEL     *BLANKS       DBKEY                       * Dbase Err 888*
     C                   MOVEL     TRAT          DBKEY                       ****************
     C                   MOVE      'SDRETRPD'    DBFILE
     C                   EXSR      *PSSR
     C                   GOTO      FINISH
     C                   ENDIF
     C                   MOVE      *BLANKS       DUMY1            20
     C                   MOVE      *BLANKS       DUMY2            30
     C                   MOVE      *BLANKS       DUMY3            10
     C                   MOVEL     A1RTNM        DUMY1
     C*****              MOVE      *BLANKS       DUMY1
     C                   MOVEL     DUMY1         DUMY2
     C     DPMT          IFNE      'FTR'
     C                   MOVEL     PNAR          DUMY3
     C                   ELSE
     C     LUC132        IFEQ      'Y'                                          LUC132
     C                   MOVE      *BLANKS       DUMY3                          LUC132
     C                   ELSE                                                   LUC132
     C                   MOVE      OTST          DUMY3
     C                   ENDIF                                                  LUC132
     C                   ENDIF
     C                   MOVE      DUMY3         DUMY2
     C                   MOVE      DUMY2         PNAR
     C                   ENDIF
     C                   ENDIF
      *
      *****************************************************************
      * End of /COPY GL0420CP44                                       *
      *****************************************************************
