/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Initialisation program for CGL157')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC000562 - Midas SD Initialisation program for CGL157      */
/*                                                                   */
/*       (c) Finastra International Limited 2016                     */
/*                                                                   */
/*       Last Amend No. MD040557           Date 17Aug16              */
/*       Prev Amend No. CGL177  *CREATE    Date 11Jan16              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD040557 - CRS Details Initialization Program did not run   */
/*       CGL177 - CRS Reporting Phase 2                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)

             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2016')

/** Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGJOB     SWS(XXXXXX00)

/** Mode 1 - First call */
/** or Mode 2 - Second call */                                                          /*MD040557*/

/**********  IF         COND(&PMODE *EQ '1') THEN(DO)                                   /*MD040557*/
             IF         COND((&PMODE *EQ '1') *OR (&PMODE *EQ '2')) +
                          THEN(DO)                                                      /*MD040557*/
                CALL       PGM(SD000562)
             ENDDO

/** Mode 3 - Deletion  */

             IF         COND(&PMODE *EQ '3') THEN(DO)
                CALL       PGM(SD000563)
             ENDDO


/** Database error processing */

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             GOTO       CMDLBL(END)

/** Abnormal termination */

ABNOR:
             CHGJOB     SWS(XXXXXX11)

             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')

/** Send the error message */

             SNDPGMMSG  MSG('Program SDC000562 ended abnormally') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)

/** End program */

END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
