      *****************************************************************
      *                                                               *
      *  Midas - STP Functions                                        *
      *                                                               *
      *  ME1000DDC1 -  Mapping for Mt101                              *
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
      *  If ok and Mt101 apply extra routing                                                  UUC104
     C********** UUC104    IFEQ 'Y'                                                  UUC104 MD059365
     C********** PMTPY     ANDEQ'101'                                                UUC104 MD059365
     C********** ##JOB     ANDNEC#FTJB                                               UUC104 MD059365
     C********** UUC104    OREQ 'Y'                                                  UUC104 MD059365
     C********** PMTPY     ANDEQ'191'                                                UUC104 MD059365
     C********** ##JOB     ANDNEC#FTJB                                               UUC104 MD059365
     C**********           CALL 'MEM0001'                                            UUC104 MD059365
     C**********           PARM 'IC'      PRETN   7        Action                    UUC104 MD059365
     C**********           PARM           PHEAD            General Details           UUC104 MD059365
     C**********           PARM           PDATA            Message Details           UUC104 MD059365
     C**********           PARM           PDAT2                                      UUC104 MD059365
     C**********           PARM           PDUM1 251        Dummy 1                   UUC104 MD059365
     C**********           PARM           PDUM2  32        Dummy 2                   UUC104 MD059365
     C**********           PARM           PDUM3   2        Dummy 3                   UUC104 MD059365
     C**********           ENDIF                                                     UUC104 MD059365
     C     UUC104        IFEQ      'Y'                                                      MD059365
     C     PMTPY         ANDEQ     '101'                                                    MD059365
     C     ##JOB         ANDNE     C#FTJB                                                   MD059365
     C     UUC104        OREQ      'Y'                                                      MD059365
     C     PMTPY         ANDEQ     '191'                                                    MD059365
     C     ##JOB         ANDNE     C#FTJB                                                   MD059365
     C                   CALL      'MEM0001'                                                MD059365
     C                   PARM      'IC'          PRETN             7            Action      MD059365
     C                   PARM                    PHEAD                          General Det MD059365
     C                   PARM                    PDATA                          Message Det MD059365
     C                   PARM                    PDAT2                                      MD059365
     C                   PARM                    PDUM1           251            Dummy 1     MD059365
     C                   PARM                    PDUM2            32            Dummy 2     MD059365
     C                   PARM                    PDUM3             2            Dummy 3     MD059365
     C                   ENDIF                                                              MD059365
      *                                                                                       UUC104
      *****************************************************************
