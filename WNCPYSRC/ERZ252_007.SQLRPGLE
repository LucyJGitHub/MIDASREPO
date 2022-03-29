       // *****************************************************************
       // *                                                               *
       // *  Midas - Customer Lending Module                              *
       // *                                                               *
       // *  ERZ252_007 - Midas LE PDP Available Balance Computation      *
       // *                                                               *
       // *  (c) Finastra International Limited 2021                      *
       // *                                                               *
       // *  Last Amend No. ERZ252 *CREATE     Date 11Feb21               *
       // *                                                               *
       // *****************************************************************
       // *                                                               *
       // *  ERZ252 - Use External Account Balance in PDP                 *
       // *****************************************************************
                            if ERZ252 = 'Y';                                                //ERZ252
                               exsr rtvExtBal;                                              //ERZ252
                               exsr prcExtBal;                                              //ERZ252
                            endif;                                                          //ERZ252
       // *****************************************************************

