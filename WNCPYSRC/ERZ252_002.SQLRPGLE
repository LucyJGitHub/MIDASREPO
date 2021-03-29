      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  ERZ252_002 - Midas LE PDP Available Balance Computation      *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. ERZ252 *CREATE     Date 11Feb21               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  ERZ252 - Use External Account Balance in PDP                 *
      *****************************************************************
     D RetrieveBANK    pr                  extpgm('AOBANKR0')                                 ERZ252
     D  pReturnCode                   7a                                                      ERZ252
     D  pOption                       7a                                                      ERZ252
     D  pDSSDY                      200a                                                      ERZ252
                                                                                              ERZ252
     D EditAmount      pr                  extpgm('ZSEDIT')                                   ERZ252
     D  pZField                      15p 0                                                    ERZ252
     D  pZDec                         1p 0                                                    ERZ252
     D  pZecode                       1a                                                      ERZ252
     D  pzOut21                      21a                                                      ERZ252
                                                                                              ERZ252
     D RetrieveCCY     pr                  extpgm('AOCURRR0')                                 ERZ252
     D  pReturnCode                   7A                                                      ERZ252
     D  pOption                       7A                                                      ERZ252
     D  pCurrency                     3A                                                      ERZ252
     D  pDSSDY                      200A                                                      ERZ252
      *****************************************************************
