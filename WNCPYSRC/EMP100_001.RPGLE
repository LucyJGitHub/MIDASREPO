      *****************************************************************
      *  Start of /COPY EMP100_001                                    *
      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GOSETLOAN - Define variables                                 *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. EMP100A            Date 12Aug20               *
      *  Prev Amend No. EMP100   *Create   Date 16Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EMP100A - ML Date Adjustment (Upg from SP21 to SP23)         *
      *  EMP100 - ML Date Adjustment                                  *
      *                                                               *
      *****************************************************************
                                                                                         EMP100
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                             EMP100
     D*SDBANK***     E DS                  EXTNAME(SDBANKPD)                     EMP100 EMP100A
     D*DSFDY****     E DS                  EXTNAME(DSFDY)                        EMP100 EMP100A
                                                                                         EMP100
      ** Access Object Parameters                                                        EMP100
     D PRetCode        S              7A                                                 EMP100
     D PSysValK1       S             20A                                                 EMP100
     D PSysVal1        S            200A                                                 EMP100
     D PSysValK2       S             20A                                                 EMP100
     D PSysVal2        S            200A                                                 EMP100
     D PSysValK3       S             20A                                                 EMP100
     D PSysVal3        S            200A                                                 EMP100
     D PSysValK4       S             20A                                                 EMP100
     D PSysVal4        S            200A                                                 EMP100
     D PSysValK5       S             20A                                                 EMP100
     D PSysVal5        S            200A                                                 EMP100
     D PSysValK6       S             20A                                                 EMP100
     D PSysVal6        S            200A                                                 EMP100
     D PSysValK7       S             20A                                                 EMP100
     D PSysVal7        S            200A                                                 EMP100
     D PSysValK8       S             20A                                                 EMP100
     D PSysVal8        S            200A                                                 EMP100
     D PSysValK9       S             20A                                                 EMP100
     D PSysVal9        S            200A                                                 EMP100
     D PSysValK10      S             20A                                                 EMP100
     D PSysVal10       S            200A                                                 EMP100
     D EMP100          S              1A                                                 EMP100
                                                                                         EMP100
     D MaxEndDate      S              5P 0 Inz(0)                                        EMP100
                                                                                         EMP100
     D DateIn          S              6  0                                               EMP100
     D DaynoOut        S              5  0                                               EMP100
     D ErrorFlag       S              1A                                                 EMP100
     D WUDFF           S              1                                                  EMP100
                                                                                         EMP100
      *****************************************************************
      *  End of /COPY EMP100_001                                      *
      *****************************************************************
