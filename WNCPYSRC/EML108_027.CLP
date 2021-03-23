/*********************************************************************/
/*                                                                   */
/*       Last Amend No. EML108             Date 15Jan20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   UMD001 - Upgrade FMD003 to FBM2.1SP21                           */
/*                                                                   */
/*********************************************************************/
             IF         COND(&IN40 *EQ '1' *AND &TERM1 *EQ 'D' *AND +
                          &TYPE *NE 'M') THEN(DO)
               CHGVAR     VAR(&IN21) VALUE('1')
               CHGVAR     VAR(&MSG2) VALUE('Daily report only allowed +
                            for Movements(M)')
               GOTO       CMDLBL(ERRMC)
             ENDDO

             IF         COND(&IN40 *EQ '1') THEN(DO)
               IF         COND(&ACCY *EQ ' ') THEN(DO)
                 CHGVAR     VAR(&IN41) VALUE('1')
                 CHGVAR     VAR(&MSG2) VALUE('Account currency must not +
                            be blank')
                 GOTO       CMDLBL(ERRMC)
               ENDDO
               IF         COND(&ACCY *NE '*ALL') THEN(DO)
                 CALL       PGM(AOCURRR0) PARM(&RTCD '*VERIFY'  &ACCY &FMT)
                 IF         COND(&RTCD *EQ '*NRF') THEN(DO)
                   CHGVAR     VAR(&IN41) VALUE('1')
                   CHGVAR     VAR(&MSG2) VALUE('Account currency must be a +
                          valid currency')
                   GOTO       CMDLBL(ERRMC)
                 ENDDO
               ENDDO
             ENDDO

             IF         COND((&IN40 *NE '1') *OR (&IN40 *EQ '1' *AND +
                          &TERM1 *NE 'D' *AND &TYPE *NE 'A') *OR +
                          (&IN40 *EQ '1' *AND &TYPE *EQ 'A' *AND +
                          &TERM2 *NE ' ')) THEN(DO)
