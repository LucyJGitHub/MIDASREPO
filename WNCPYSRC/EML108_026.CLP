/*********************************************************************/
/*                                                                   */
/*       Last Amend No. EML108             Date 15Jan20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Upgrade FMD003 to FBM2.1SP21                           */
/*                                                                   */
/*********************************************************************/
             ENDDO
             IF         COND(&IN40 *EQ '1') THEN(DO)
               IF         COND(&TERM1 *NE 'P' *AND &TERM1 *NE 'Y' *AND +
                            &TERM1 *NE '1' *AND &TERM1 *NE '2' *AND +
                            &TERM1 *NE 'D') THEN(DO)
                 CHGVAR     VAR(&IN19) VALUE('1')
                 CHGVAR     VAR(&MSG2) VALUE('Entry not ''P'', ''Y'', +
                            ''1'', ''2'' or ''D''')
                 GOTO       CMDLBL(ERRMC)
               ENDDO
               IF         COND(&RPDN *NE 0 *AND &TERM1 *EQ 'D') THEN(DO)
                 CHGVAR     VAR(&IN19) VALUE('1')
                 CHGVAR     VAR(&MSG2) VALUE('Daily Report not allowed +
                            when Relative period number is not 0')
                 GOTO       CMDLBL(ERRMC)
               ENDDO
             ENDDO
