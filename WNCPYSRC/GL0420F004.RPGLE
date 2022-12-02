      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL0420)                                *
      *                                                               *
      *  GL0420F004 - Balance Statements (A/C Formats)                *
      *                                                               *
      *  Last Amend No. UUC102 *CREATE  Date 16Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC102 - Upgrade of CAR UUC063 to BF Midas 2.1               *
      *           UUC063 - Balance Statement Enhancement              *
      *                                                               *
      *****************************************************************
     FXXAPOSV1  IF   F  620    24AIDISK                                         UUC102
     F                                     USROPN                               UUC102
     F*                                    RENAME(GLRSACD0:GLRSACR0)
      *                                                                         UUC102
     FGLJENAPD  IF   E           K DISK                                         UUC102
     F                                     USROPN                               UUC102
     F*       76      CHAIN FAILED TO GLJENAPD FILE                             UUC102
