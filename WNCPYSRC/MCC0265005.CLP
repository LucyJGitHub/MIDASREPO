/*********************************************************************/
/*                                                                   */
/*       Last Amend No. EML108             Date 15Jan20              */
/*       Prev Amend No. UMD001             Date 07Jan09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Upgrade FMD103 to FBM2.1SP21                           */
/*   UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19                */
/*                                                                   */
/*********************************************************************/
/**********  CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'FMD003' +*/                   /*EML108*/
/**********               &DSFDY)                                    */           /*FMD003 *EML108*/
/**********  IF         COND(&RTCD *EQ ' ') THEN(CHGVAR VAR(&FMD003) +/                   /*EML108*/
/**********               VALUE('Y'))                                */           /*FMD003 *EML108*/
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'EML108' +
                          &DSFDY)                                                         /*EML108*/
             IF         COND(&RTCD *EQ ' ') THEN(CHGVAR VAR(&EML108) +
                          VALUE('Y'))                                                     /*EML108*/
