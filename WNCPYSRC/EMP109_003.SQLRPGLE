      *****************************************************************
      *  Start of /COPY EMP109_003                                    *
      *****************************************************************
      *                                                               *
      *  Last Amend No. EMP109  *Create    Date 07Jul21               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EMP109 - Fixed number of days in RE APR Calculation          *
      *                                                               *
      *****************************************************************
      *                                                                                  EMP109
     C                   else                                                            EMP109
     C                   Move      '365'         AEDNB                                   EMP109
     C                   Z-Add     CLDID         ZDAYNO                                  EMP109
     C                   Exsr      ZDATE2                                                EMP109
     C                   Move      ZDATE         CAPYR             2 0                   EMP109
     C     CAPYR         Div       4             ZLYR              2 0                   EMP109
     C                   Mvr                     LYR               1 0                   EMP109
     C     LYR           Ifeq      0                                                     EMP109
     C                   Move      '366'         AEDNB                                   EMP109
     C                   Endif                                                           EMP109
     C                   Endif                                                           EMP109
      *                                                                                  EMP109
      *****************************************************************
      *  End of /COPY EMP109_003                                      *
      *****************************************************************
