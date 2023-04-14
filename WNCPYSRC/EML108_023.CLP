/*********************************************************************/
/*                                                                   */
/*       Last Amend No. EML108             Date 15Jan20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Upgrade FMD003 to FBM2.1SP21                           */
/*   UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19                */
/*                                                                   */
/*********************************************************************/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'FMD003' +                     /*EML108*/
/**********               &DSFDY)                                    */            /*FMD003 EML108*/
/**********  IF         COND(&RTCD *EQ ' ') THEN(CHGVAR +                                 /*EML108*/
/**********               VAR(&IN40) VALUE('1'))                                   /*FMD003 EML108*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'EML108' +
                          &DSFDY)                                                         /*EML108*/
             IF         COND(&RTCD *EQ ' ') THEN(CHGVAR +
                          VAR(&IN40) VALUE('1'))                                          /*EML108*/
