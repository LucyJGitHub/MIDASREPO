       // *****************************************************************
       // *                                                               *
       // *  Midas - Customer Lending Module                              *
       // *                                                               *
       // *  ERZ252_009 - Midas LE PDP Available Balance Computation      *
       // *                                                               *
       // *  (c) Finastra International Limited 2021                      *
       // *                                                               *
       // *  Last Amend No. ERZ252 *CREATE     Date 11Feb21               *
       // *                                                               *
       // *****************************************************************
       // *                                                               *
       // *  ERZ252 - Use External Account Balance in PDP                 *
       // *****************************************************************
       //*************************************************************                      //ERZ252
       /EJECT                                                                               //ERZ252
       //*************************************************************                      //ERZ252
       //                                                            *                      //ERZ252
       // printHeaderReport                                          *                      //ERZ252
       //                                                            *                      //ERZ252
       // Called by: Main Processing                                 *                      //ERZ252
       //                                                            *                      //ERZ252
       // Calls: None                                                *                      //ERZ252
       //                                                            *                      //ERZ252
       //*************************************************************                      //ERZ252
                                                                                            //ERZ252
       begsr printHeaderReport;                                                             //ERZ252
                                                                                            //ERZ252
                   PAGEP2 = PAGEP2 + 1;                                                     //ERZ252
                                                                                            //ERZ252
                   write XX900004H1;                                                        //ERZ252
                                                                                            //ERZ252
       endsr;                                                                               //ERZ252
                                                                                            //ERZ252
       //*************************************************************                      //ERZ252
       /EJECT                                                                               //ERZ252
       //*************************************************************                      //ERZ252
       //                                                            *                      //ERZ252
       // prcExtBal                                                  *                      //ERZ252
       //                                                            *                      //ERZ252
       // Called by: Main Processing                                 *                      //ERZ252
       //                                                            *                      //ERZ252
       // Calls: None                                                *                      //ERZ252
       //                                                            *                      //ERZ252
       //*************************************************************                      //ERZ252
                                                                                            //ERZ252
       begsr prcExtBal;                                                                     //ERZ252
                                                                                            //ERZ252
                   if ExtBalFound = 'Y';                                                    //ERZ252
                                                                                            //ERZ252
                      //                                                                    //ERZ252
                      // Report Amounts                                                     //ERZ252
                      //                                                                    //ERZ252
                                                                                            //ERZ252
                      // Get Currency                                                       //ERZ252
                      CURLKUP = %Lookup( CustomerDS(i).SEACCY                               //ERZ252
                                        :Currencies);                                       //ERZ252
                      if CURLKUP > 0;                                                       //ERZ252
                         %Occur(SDCURR) = CURLKUP;                                          //ERZ252
                      else;                                                                 //ERZ252
                         Currencies(IdxCur) = CustomerDS(i).SEACCY;                         //ERZ252
                         %Occur(SDCURR) = IdxCur;                                           //ERZ252
                         IdxCur = IdxCur + 1;                                               //ERZ252
                         pOption = '*KEY';                                                  //ERZ252
                         RetrieveCCY( pReturnCode                                           //ERZ252
                                     :pOption                                               //ERZ252
                                     :CustomerDS(i).SEACCY                                  //ERZ252
                                     :SDCURR                                                //ERZ252
                                     );                                                     //ERZ252
                         ZECODE = 'A';                                                      //ERZ252
                         ZDECS    = A6NBDP;                                                 //ERZ252
                      endif;                                                                //ERZ252
                                                                                            //ERZ252
                      // Opening Balance                                                    //ERZ252
                      ZFLD15 = CustomerDS(i).SEAAMT;                                        //ERZ252
                      exsr FormatAmt;                                                       //ERZ252
                      W@OPEN = ZOUT22;                                                      //ERZ252
                                                                                            //ERZ252
                      // Held Items                                                         //ERZ252
                      wZField = CustomerDS(i).SEHELD;                                       //ERZ252
                      wzDec = A6NBDP;                                                       //ERZ252
                      WZeCode = 'J';                                                        //ERZ252
                      wZout21 = *blanks;                                                    //ERZ252
                      Callp EditAmount( wZField                                             //ERZ252
                                       :wZDec                                               //ERZ252
                                       :wZecode                                             //ERZ252
                                       :wZout21);                                           //ERZ252
                      W@HELD = wZout21;                                                     //ERZ252
                                                                                            //ERZ252
                      // Overdraft Amount                                                   //ERZ252
                      wZField = CustomerDS(i).SEOAMT *-1;                                   //ERZ252
                      wzDec = A6NBDP;                                                       //ERZ252
                      wZout21 = *blanks;                                                    //ERZ252
                      Callp EditAmount( wZField                                             //ERZ252
                                       :wZDec                                               //ERZ252
                                       :wZecode                                             //ERZ252
                                       :wZout21);                                           //ERZ252
                      W@OVLN = wZout21;                                                     //ERZ252
                                                                                            //ERZ252
                      // External Balance                                                   //ERZ252
                      ZFLD15 = XAVBL;                                                       //ERZ252
                      exsr FormatAmt;                                                       //ERZ252
                      W@EXTR = ZOUT22;                                                      //ERZ252
                                                                                            //ERZ252
                      //                                                                    //ERZ252
                      // Override amounts                                                   //ERZ252
                      //                                                                    //ERZ252
                                                                                            //ERZ252
                      CustomerDS(i).SEAAMT = XAVBL;                                         //ERZ252
                      CustomerDS(i).SECLBL = XAVBL;                                         //ERZ252
                                                                                            //ERZ252
                      //                                                                    //ERZ252
                      // Write data to report                                               //ERZ252
                      //                                                                    //ERZ252
                                                                                            //ERZ252
                      if PrtLn1 > 60;                                                       //ERZ252
                         exsr printHeaderReport;                                            //ERZ252
                      endif;                                                                //ERZ252
                                                                                            //ERZ252
                      SEACNO = wRetailAc;                                                   //ERZ252
                      write XX900004D1;                                                     //ERZ252
                                                                                            //ERZ252
                   endif;                                                                   //ERZ252
                                                                                            //ERZ252
       endsr;                                                                               //ERZ252
