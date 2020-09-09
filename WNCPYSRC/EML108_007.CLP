/*********************************************************************/
/*                                                                   */
/*       Last Amend No. EML108             Date 15Jan20              */
/*       Prev Amend No. UMD001             Date 07Jan09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Ugrade FMD003 to FBM2.1SP21                            */
/*   UMD001 - Upgrade FMD003 to Midas Plus 1.2.1 SP19                */
/*                                                                   */
/*********************************************************************/
/**********  IF         COND(&FMD003 *EQ 'Y') THEN(CALL +            */                  /*EML108*/
/**********               PGM(MCCF299A) PARM(&PERIODSET &POSTINGBAS +*/                  /*EML108*/
/**********               &STARTDATE &SECTIONS &ANALYSIS 'N' +       */                  /*EML108*/
/**********               &STARTTIME &GROUPCODE))                    */           /*FMD003 EML108*/
/**********  ELSE       CMD(DO)                                      */           /*FMD003 EML108*/
             IF         COND(&EML108 *EQ 'Y') THEN(CALL +
                          PGM(XXCF299A) PARM(&PERIODSET &POSTINGBAS +
                          &STARTDATE &SECTIONS &ANALYSIS 'N' +
                          &STARTTIME &GROUPCODE))                                        /*EML108*/
             ELSE       CMD(DO)                                                          /*EML108*/
