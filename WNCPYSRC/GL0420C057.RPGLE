      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL0420)                                *
      *                                                               *
      *  GL0420C057 - Midas GL Balance Statements                     *
      *                                                               *
      *  Last Amend No. UUC102 *CREATE  Date 16Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC102 - Upgrade of CAR UUC063 to BF Midas 2.1               *
      *           UUC063 - Balance Statement Enhancement              *
      *                                                               *
      *****************************************************************
      *
     C     KBTBI         KLIST                                                  UUC102
     C                   KFLD                    BTNB                           UUC102
     C                   KFLD                    BINB                           UUC102
     C                   KFLD                    PSTD                           UUC102
     C                   KFLD                    DRCR                           UUC102
      *                                                                         UUC102
     C**  Check to see if SAR is installed.                                     UUC102
     C                   MOVE      'N'           UUC102                         UUC102
     C                   MOVE      *OFF          *INKP                          UUC102
     C                   CALL      'AOSARDR0'                                   UUC102
     C                   PARM      '       '     @RTCD                          UUC102
     C                   PARM      '*VERIFY'     @OPTN                          UUC102
     C                   PARM      'UUC102'      @SARD             6            UUC102
     C     SCSARD        PARM      SCSARD        DSFDY                          UUC102
     C*                                                                         UUC102
     C     @RTCD         IFEQ      *BLANKS                                      UUC102
     C                   MOVE      'Y'           UUC102            1            UUC102
     C                   MOVE      *ON           *INKP                          UUC102
     C                   EVAL      POPT( 2 ) = 'FTStmtNarrPgm'                  UUC102
     C                   OPEN      XXAPOSV1                                     UUC102
     C                   OPEN      GLJENAPD                                     UUC102
     C                   END                                                    UUC102
      *                                                                         UUC102
