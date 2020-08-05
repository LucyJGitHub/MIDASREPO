/******************************************************************/                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/*  Midas - /COPY Member MSC3200                                  */                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/*  MSC3200002 - Declare variables                                */                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/*  Last Amend No. LCI020  *CREATE    Date 27Jul20                */                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/******************************************************************/                      /*LCI020*/
/*                                                                */                      /*LCI020*/
/*  LCI020 - Enable Inter.Pel transmission of SWIFT outgoing      */                      /*LCI020*/
/*           messages from Midas (Upgrade to FBM 2.1)             */                      /*LCI020*/
/******************************************************************/                      /*LCI020*/
                                                                                          /*LCI020*/
            DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                      /*LCI020*/
            DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                     /*LCI020*/
            DCL        VAR(&SARD) TYPE(*CHAR) LEN(7) VALUE('LCI020')                      /*LCI020*/
            DCL        VAR(&DSDY) TYPE(*CHAR) LEN(200)                                    /*LCI020*/
            DCL        VAR(&LCI020) TYPE(*CHAR) LEN(1) VALUE('N')                         /*LCI020*/
            DCL        VAR(&DIR) TYPE(*CHAR) LEN(50) VALUE('/usr/bin/')                   /*LCI020*/
                                                                                          /*LCI020*/
/*********************************************************************/                   /*LCI020*/
/* End of /COPY MSC3200002                                           */                   /*LCI020*/
/*********************************************************************/                   /*LCI020*/
