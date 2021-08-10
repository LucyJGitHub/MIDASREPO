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
/**********  IF         COND(&FMD003 *EQ 'Y') THEN(CHGVAR VAR(&OPQF) +                    /*EML108*/
/**********               VALUE(&OPQF *BCAT 'FORMAT(MCBLRPX0)'))                          /*EML108*/
/**********  ELSE       CMD(DO)                                                           /*EML108*/
             IF         COND(&EML108 *EQ 'Y') THEN(CHGVAR VAR(&OPQF) +
                          VALUE(&OPQF *BCAT 'FORMAT(MCBLRPX0)'))
             ELSE       CMD(DO)                                                           /*EML108*/
