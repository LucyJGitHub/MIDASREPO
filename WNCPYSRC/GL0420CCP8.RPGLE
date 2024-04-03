      *****************************************************************                       UUC105
      *                                                               *                       UUC105
      *  Midas - General Ledger Module                                *                       UUC105
      *                                                               *                       UUC105
      *  GL0420CCP8 - Midas GL Balance statements                     *                       UUC105
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
      ** Check account if flagged as NRA.                                                     UUC105
      *                                                                                       UUC105
     C                   MOVE      *OFF          *INKM                                        UUC105
     C     UUC105        IFEQ      'Y'                                                        UUC105
     C     ACNO          ANDNE     *ZEROS                                                     UUC105
     C                   MOVEL     *BLANKS       @ACNO            13                          UUC105
     C                   MOVEL     *BLANKS       XACNO            10                          UUC105
     C     ACNO          CHAIN     XXACCNL0                           77                      UUC105
     C     *IN77         IFEQ      *OFF                                                       UUC105
     C                   MOVEL     ACNO          XACNO                                        UUC105
     C     A1NRA         CAT       XACNO:0       @ACNO                                        UUC105
     C                   MOVE      *ON           *INKM                                        UUC105
     C                   ENDIF                                                                UUC105
     C                   ENDIF                                                                UUC105
      *                                                                                       UUC105
      *****************************************************************                       UUC105
      * End of /COPY GL0420CCP8                                       *                       UUC105
      *****************************************************************                       UUC105
