/*********************************************************************/
/*                                                                   */
/*       Last Amend No. EML108             Date 15Jan20              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   EML108 - Upgrade FMD003 to FBM2.1SP21                           */
/*            Incorporate GEMS 222591                                */
/*                                                                   */
/*********************************************************************/
            IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                           'TERM1  ' *AND &RTCD *NE 'TERM2  ' +
                           *AND &IN40 *EQ '1') THEN(DO)
            CHGVAR     VAR(&IN18) VALUE('1')
            CHGVAR     VAR(&MSG2) VALUE('Relative Period does not +
                         exist for this Control Group')
            GOTO       CMDLBL(ERRMC)
            ENDDO

            ELSE       CMD(DO)
