      *****************************************************************                       UUC105
      *                                                               *                       UUC105
      *  Midas - General Ledger Module                                *                       UUC105
      *                                                               *                       UUC105
      *  GL0420C111 - Midas GL Balance statements                     *                       UUC105
      *                                                               *                       UUC105
      *  (c) Finastra Ltd 2020                                        *                       UUC105
      *                                                               *                       UUC105
      *  Last Amend No. UUC105  *CREATE    Date 19Oct20               *                       UUC105
      *                                                               *                       UUC105
      *****************************************************************                       UUC105
      *                                                               *                       UUC105
      *  UUC105 - upgrade of UUC070 to FBM 2.1                        *                       UUC105
      *           NRA in Retail Account Information                   *                       UUC105
      *                                                               *                       UUC105
      *****************************************************************                       UUC105
      *                                                                                       UUC105
      **  Access SAR details file to see if UUC105 is installed.                              UUC105
     C                   CALL      'AOSARDR0'                                                 UUC105
     C                   PARM      *BLANKS       @RTCD                                        UUC105
     C                   PARM      '*VERIFY'     @OPTN                                        UUC105
     C                   PARM      'UUC105'      @SARD                                        UUC105
     C     SCSARD        PARM      SCSARD        DSFDY                                        UUC105
      *                                                                                       UUC105
     C                   MOVE      'N'           UUC105            1                          UUC105
     C     @RTCD         IFEQ      *BLANKS                                                    UUC105
     C                   MOVE      'Y'           UUC105                                       UUC105
     C                   OPEN      XXACCNL0                                                   UUC105
     C                   ELSE                                                                 UUC105
     C     @RTCD         IFNE      '*NRF   '                                                  UUC105
     C                   SETON                                        76                      UUC105
     C                   MOVEL     'SCSARDPD'    DBFILE                     ************      UUC105
     C                   MOVEL     '*VERIFY'     DBKEY                      * DBERR 32 *      UUC105
     C                   Z-ADD     32            DBASE                      ************      UUC105
     C                   EXSR      *PSSR                                                      UUC105
     C                   ENDIF                                                                UUC105
     C                   ENDIF                                                                UUC105
      *                                                                                       UUC105
      *****************************************************************                       UUC105
      * End of /COPY GL0420C111                                       *                       UUC105
      *****************************************************************                       UUC105
