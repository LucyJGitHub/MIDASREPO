/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Initialisation program for CSE040')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC00040 - Initialisation program for CSE040                */
/*                                                                   */
/*       (c) Finastra International Limited 2023                     */
/*                                                                   */
/*       Last Amend No. 259902  *CREATE    Date 09Oct23              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       259902 - Fields SDDTAQ and SDLIB in SDSESTPD are not        */
/*                initialised when switchable feature CSE040 is      */
/*                switched ON.                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)

             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2023')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     SWS(XXXXXX00)

/* Mode 1 - First call or Mode 2 - Second call */

             IF         COND((&PMODE *EQ '1') *OR (&PMODE *EQ '2')) +
                          THEN(CALL PGM(SD00040))
/* Mode 3 - Deletion */

             IF         COND(&PMODE *EQ '3') THEN(DO)
             ENDDO

/* Database error processing */

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             GOTO       CMDLBL(END)

/* Abnormal termination */

ABNOR:
             CHGJOB     SWS(XXXXXX11)
             ROLLBACK
             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')

/* Send the error message */

             SNDPGMMSG  MSG('Program SDC00040 ended abnormally') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

/* End program */

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
