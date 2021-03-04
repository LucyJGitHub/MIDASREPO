      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  ERZ252_004 - Midas LE PDP Available Balance Computation      *
      *                                                               *
      *  (c) Finastra International Limited 2021                      *
      *                                                               *
      *  Last Amend No. ERZ252 *CREATE     Date 11Feb21               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  ERZ252 - Use External Account Balance in PDP                 *
      *****************************************************************
     D ERZ252          s              1a                                                      ERZ252
     D ExtBalFound     s              1a                                                      ERZ252
     D CURLKUP         S              3  0 INZ(0)                                             ERZ252
     D IDXCUR          S              3  0 INZ(1)                                             ERZ252
     D Currencies      S                   INZ DIM(250) LIKE(SEACCY)                          ERZ252
     D wZField         s             15p 0                                                    ERZ252
     D wZDec           s              1p 0                                                    ERZ252
     D wZecode         s              1a                                                      ERZ252
     D wzOut21         s             21a                                                      ERZ252
     D SEACODT         s             10a                                                      ERZ252
     D SEACSQT         s              2a                                                      ERZ252
      *****************************************************************
