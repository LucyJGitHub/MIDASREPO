      *****************************************************************
      *                                                               *
      *  MIDAS - /COPY MEMBER (GL0420)                                *
      *                                                               *
      *  UUC102_007 - Midas GL Balance Statements                     *
      *                                                               *
      *  Last Amend No. MD058791A       Date 23Sep21                  *
      *  Prev Amend No. UUC102 *CREATE  Date 16Oct20                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD058791A - Lack of space between '/' and STPG, results in   *
      *              '/' overprinted by STPG. Moved the printing of   *
      *              '/' 1 position to the left.                      *
      *  UUC102 - Upgrade of CAR UUC063 to BF Midas 2.1               *
      *           UUC063 - Balance Statement Enhancement              *
      *                                                               *
      *****************************************************************
     O**********     KP                         101 '/'                             UUC102 MD058791A
     O               KP                         100 '/'                                    MD058791A
     O               KP      STPG          3    103                             UUC102
