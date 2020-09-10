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
/**********                                                          */                   /*EML108*/
/**********  IF         COND(&IN40 *EQ '1') THEN(CHGVAR VAR(&RPARM) +*/                   /*EML108*/
/**********               VALUE(&CCY || &RSNO || &RSLV || &RPCD || + */                   /*EML108*/
/**********               &GRPCD || &SRPDN || &TERM1 || &TERM2 || +  */                   /*EML108*/
/**********               &TYPE || &ANAL || &ACCY))                  */            /*FMD003 EML108*/
/**********  ELSE       CMD(DO)                                      */            /*FMD003 EML108*/
             IF         COND(&IN40 *EQ '1') THEN(CHGVAR VAR(&RPARM) +
                          VALUE(&CCY *CAT &RSNO *CAT &RSLV *CAT +
                          &RPCD *CAT &GRPCD *CAT &SRPDN *CAT &TERM1 +
                          *CAT &TERM2 *CAT &TYPE *CAT &ANAL *CAT +
                          &ACCY))                                                         /*EML108*/
             ELSE       CMD(DO)                                                           /*EML108*/
