      *****************************************************************
      *  Start of /COPY EMP100_004                                    *
      *****************************************************************
      *                                                               *
      *  Midas - /COPY Member (RPG)                                   *
      *                                                               *
      *  GOSETLOAN - Max End date                                     *
      *                                                               *
      *  (c) Finastra International Limited 2020                      *
      *                                                               *
      *  Last Amend No. EMP100   *Create   Date 16Apr20               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  EMP100 - ML Date Adjustment                                  *
      *                                                               *
      *****************************************************************
      *                                                                                  EMP100
     C     EMP100        Ifeq      'Y'                                                   EMP100
     C                   If        T_EDAT > MaxEndDate                                   EMP100
     C                   Z-Add     MaxEndDate    T_EDAT                                  EMP100
     C                   Endif                                                           EMP100
     C                   Endif                                                           EMP100
      *                                                                                  EMP100
      *****************************************************************
      *  End of /COPY EMP100_004                                      *
      *****************************************************************
