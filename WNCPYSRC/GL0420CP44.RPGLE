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
      *   HVB PROCESSING - CONVERT TRANSACTION TYPE TO TEXT                                   LUC108
     C     TRAT          IFNE      *BLANKS                                                    LUC108
     C     TRAT          ANDNE     *ZEROS                                                     LUC108
     C     CHQN          ANDEQ     0                                                          LUC108
     C     RECI          ANDEQ     'P'                                                        LUC108
     C     *IN06         ANDEQ     *ON                                                        LUC108
     C                   CALL      'AORETRR0'                                                 LUC108
     C                   PARM      '*MSG   '     @RTCD             7                          LUC108
     C                   PARM      '*KEY   '     @OPTN             7                          LUC108
     C                   PARM                    TRAT                                         LUC108
     C     SDRETR        PARM      SDRETR        DSSDY                                        LUC108
     C     @RTCD         IFNE      *BLANKS                                                    LUC108
     C                   Z-ADD     888           DBASE                       **************** LUC108
     C                   MOVEL     *BLANKS       DBKEY                       * Dbase Err 888* LUC108
     C                   MOVEL     TRAT          DBKEY                       **************** LUC108
     C                   MOVE      'SDRETRPD'    DBFILE                                       LUC108
     C                   EXSR      *PSSR                                                      LUC108
     C                   GOTO      FINISH                                                     LUC108
     C                   ENDIF                                                                LUC108
     C                   MOVE      *BLANKS       DUMY1            20                          LUC108
     C                   MOVE      *BLANKS       DUMY2            30                          LUC108
     C                   MOVE      *BLANKS       DUMY3            10                          LUC108
     C                   MOVEL     A1RTNM        DUMY1                                        LUC108
     C*****              MOVE      *BLANKS       DUMY1                                        LUC108
     C                   MOVEL     DUMY1         DUMY2                                        LUC108
     C     DPMT          IFNE      'FTR'                                                      LUC108
     C                   MOVEL     PNAR          DUMY3                                        LUC108
     C                   ELSE                                                                 LUC108
     C     LUC132        IFEQ      'Y'                                                        LUC132
     C                   MOVE      *BLANKS       DUMY3                                        LUC132
     C                   ELSE                                                                 LUC132
     C                   MOVE      OTST          DUMY3                                        LUC108
     C                   ENDIF                                                                LUC132
     C                   ENDIF                                                                LUC108
     C                   MOVE      DUMY3         DUMY2                                        LUC108
     C                   MOVE      DUMY2         PNAR                                         LUC108
     C                   ENDIF                                                                LUC108
     C                   ENDIF                                                                LUC108
      *
      *****************************************************************
      * End of /COPY GL0420CP44                                       *
      *****************************************************************
