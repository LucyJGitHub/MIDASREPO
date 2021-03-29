       // *****************************************************************
       // *                                                               *
       // *  Midas - Customer Lending Module                              *
       // *                                                               *
       // *  ERZ252_006 - Midas LE PDP Available Balance Computation      *
       // *                                                               *
       // *  (c) Finastra International Limited 2021                      *
       // *                                                               *
       // *  Last Amend No. ERZ252 *CREATE     Date 11Feb21               *
       // *                                                               *
       // *****************************************************************
       // *                                                               *
       // *  ERZ252 - Use External Account Balance in PDP                 *
       // *****************************************************************
                   if ERZ252 = 'Y';                                                         //ERZ252
                                                                                            //ERZ252
                      if PrtLn1 > 60;                                                       //ERZ252
                         exsr printHeaderReport;                                            //ERZ252
                      endif;                                                                //ERZ252
                      write XX900004T1;                                                     //ERZ252
                                                                                            //ERZ252
                   endif;                                                                   //ERZ252
                                                                                            //ERZ252
       // *****************************************************************

