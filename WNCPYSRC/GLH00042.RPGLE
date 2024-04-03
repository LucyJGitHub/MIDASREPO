      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL0063)                                *
      *                                                               *
      *  GLH00042 - Midas GL Statement of Account Prompt              *
      *                                                               *
      *  Last Amend No. UUC102 *CREATE  Date 16Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC102 - Upgrade of CAR UUC063 to BF Midas 2.1               *
      *           UUC063 - Balance Statement Enhancement              *
      *                                                               *
      *****************************************************************
      *                                                                         UUC102
      **  Check to see if SAR is installed.                                     UUC102
     C                   MOVE      'N'           UUC102            1            UUC102
     C                   CALL      'AOSARDR0'                                   UUC102
     C                   PARM      '       '     @RTCD                          UUC102
     C                   PARM      '*VERIFY'     @OPTN                          UUC102
     C                   PARM      'UUC102'      @SARD             6            UUC102
     C     SCSARD        PARM      SCSARD        DSFDY                          UUC102
      *                                                                         UUC102
     C     @RTCD         IFEQ      *BLANKS                                      UUC102
     C                   MOVE      'Y'           UUC102                         UUC102
     C                   END                                                    UUC102
      *                                                                         UUC102
