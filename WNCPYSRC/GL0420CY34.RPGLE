      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL0420)                                *
      *                                                               *
      *  GL0420CY34 - Balance Statements (A/C Formats)                *
      *                                                               *
      *  Last Amend No. UUC102 *CREATE  Date 16Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  UUC102 - Upgrade of CAR UUC063 to BF Midas 2.1               *
      *           UUC063 - Balance Statement Enhancement              *
      *                                                               *
      *****************************************************************
     C     UUC102        IFEQ      'Y'
     C                   Z-ADD     LSTPX         STPAX             3 0
     C                   Z-ADD     1             STPG              3 0
     C                   ENDIF
