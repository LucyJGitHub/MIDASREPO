      *****************************************************************
      *                                                               *
      *  Midas - STP Functions                                        *
      *                                                               *
      *  ME1100C008 -  Mapping for Mt101                              *
      *                                                               *
      *  Function: This function maps the Mt101 format onto the       *
      *            Mt103.                                             *
      *                                                               *
      *  Component of: *None                                          *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. MD059365           Date 06Dec21               *
      *  Prev Amend No. UUC104             Date 12Oct20               *
      *                 xxxxxx             Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD059365 - Mis-aligned ME1100 copy sources                   *
      *  UUC104 - MPM Integration (Upgrade of 1.4.11.06 CAR UUC069)   *
      *                                                               *
      *****************************************************************
      *                                                                                       UUC104
     C**********           CALL 'AOSARDR0'                                           UUC104 MD059365
     C**********           PARM *BLANKS   @RTCD                                      UUC104 MD059365
     C**********           PARM '*VERIFY' @OPTN                                      UUC104 MD059365
     C**********           PARM 'UUC104'  @SARD                                      UUC104 MD059365
     C********** SCSARD    PARM SCSARD    DSFDY                                      UUC104 MD059365
     C                   CALL      'AOSARDR0'                                               MD059365
     C                   PARM      *BLANKS       @RTCD                                      MD059365
     C                   PARM      '*VERIFY'     @OPTN                                      MD059365
     C                   PARM      'UUC104'      @SARD                                      MD059365
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD059365
      *                                                                              UUC104 MD059365
     C********** @RTCD     IFEQ *BLANKS                                              UUC104 MD059365
     C**********           MOVEL'Y'       UUC104  1                                  UUC104 MD059365
     C**********           ELSE                                                      UUC104 MD059365
     C**********           MOVEL'N'       UUC104                                     UUC104 MD059365
     C**********           ENDIF                                                     UUC104 MD059365
     C     @RTCD         IFEQ      *BLANKS                                                  MD059365
     C                   MOVEL     'Y'           UUC104            1                        MD059365
     C                   ELSE                                                               MD059365
     C                   MOVEL     'N'           UUC104                                     MD059365
     C                   ENDIF                                                              MD059365
      *****************************************************************
