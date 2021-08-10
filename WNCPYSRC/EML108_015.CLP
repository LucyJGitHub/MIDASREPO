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
/**********  IF         COND(&FMD003 *EQ 'Y') THEN(DO)               */                   /*EML108*/
             IF         COND(&EML108 *EQ 'Y') THEN(DO)                                    /*EML108*/
             CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(WAMT1' *BCAT +
                          &ENAM1 *TCAT ') (WAMT2' *BCAT &ENAM2 +
                          *TCAT ') (WAMT3' *BCAT &ENAM3 *TCAT ') +
                          (WAMT4' *BCAT &ENAM4 *TCAT ') (WAMT5' +
                          *BCAT &ENAM5 *TCAT ') (FLG +
                          ''%MIN(%ABSVAL(WAMT1) 1)'') (WAMT +
                          ''(WAMT1 * FLG) + (WAMT2 * (1 - FLG))'')')
             ENDDO
             ELSE       CMD(DO)
