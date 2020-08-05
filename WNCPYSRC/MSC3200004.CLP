/******************************************************************/                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/*  Midas - /COPY Member MSC3200                                  */                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/*  MSC3200004 - Call AOSARDR0                                    */                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/*  Last Amend No. LCI020  *CREATE    Date 27Jul20                */                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/******************************************************************/                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/*  LCI020 - Enable Inter.Pel transmission of SWIFT outgoing      */                      /*LCI020*/
/*           messages from Midas (Upgrade to FBM 2.1)             */                      /*LCI020*/
/******************************************************************/                      /*LCI020*/
                                                                                          /*LCI020*/
            CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &DSDY)                        /*LCI020*/
            IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                         VAR(&LCI020) VALUE('Y'))                                         /*LCI020*/
/*********************************************************************/                   /*LCI020*/
/* End of /COPY MSC3200004                                           */                   /*LCI020*/
/*********************************************************************/                   /*LCI020*/

