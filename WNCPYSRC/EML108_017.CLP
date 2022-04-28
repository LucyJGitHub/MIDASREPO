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

/*********   IF         COND(&FMD003 *EQ 'Y') THEN(DO)               */                  /*EML108*/
             IF         COND(&EML108 *EQ 'Y') THEN(DO)                                   /*EML108*/
                 CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(GLLDB3 +
                              ''%SUM(WAMT3)'') (GLLDB4 ''%SUM(WAMT4)'') +
                             (GLLDB5 ''%SUM(WAMT5)'')')
                 CHGVAR     VAR(&OPQF) VALUE(&OPQF *BCAT '(GLRTYP ''''''' +
                              *TCAT &MCTRM1 *TCAT ''''''')')
             ENDDO
