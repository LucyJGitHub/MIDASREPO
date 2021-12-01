       // *****************************************************************
       // *                                                               *
       // *  Midas - Customer Lending Module                              *
       // *                                                               *
       // *  ERZ252_008 - Midas LE PDP Available Balance Computation      *
       // *                                                               *
       // *  (c) Finastra International Limited 2021                      *
       // *                                                               *
       // *  Last Amend No. ERZ252 *CREATE     Date 11Feb21               *
       // *                                                               *
       // *****************************************************************
       // *                                                               *
       // *  ERZ252 - Use External Account Balance in PDP                 *
       // *****************************************************************
                                                                                            //ERZ252
                   pOption = '*FIRST';                                                      //ERZ252
                   RetrieveBank(                                                            //ERZ252
                                  pReturnCode                                               //ERZ252
                                : pOption                                                   //ERZ252
                                : pDSSDY                                                    //ERZ252
                               );                                                           //ERZ252
                   SDBANK = pDSSDY;                                                         //ERZ252
                                                                                            //ERZ252
       //Check if ERZ252 is switched on                                                     //ERZ252
                   pOption = '*VERIFY';                                                     //ERZ252
                   pSARD = 'ERZ252';                                                        //ERZ252
                   callp check_SARD(                                                        //ERZ252
                                  pReturnCode                                               //ERZ252
                                : pOption                                                   //ERZ252
                                : pSARD                                                     //ERZ252
                                : pDSSDY                                                    //ERZ252
                               );                                                           //ERZ252
                   SCSARD = pDSSDY;                                                         //ERZ252
                                                                                            //ERZ252
       //Open files, setup variables and enable switch                                      //ERZ252
                   if pReturnCode = *blanks;                                                //ERZ252
                                                                                            //ERZ252
                      ERZ252 = 'Y';                                                         //ERZ252
                                                                                            //ERZ252
                      PrtLn1 = 0;                                                           //ERZ252
                      open XX900004P1;                                                      //ERZ252
                                                                                            //ERZ252
                      XBRCA = *blanks;                                                      //ERZ252
                      XCNUM = *blanks;                                                      //ERZ252
                      XCCY  = *blanks;                                                      //ERZ252
                      XACOD = *zeros;                                                       //ERZ252
                      XACSQ = *zeros;                                                       //ERZ252
                                                                                            //ERZ252
                   endif;                                                                   //ERZ252
                                                                                            //ERZ252
       // *****************************************************************

