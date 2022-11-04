/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('On-line gend Position Settlements Rept Parms')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       XXC118002B- On-line gend Position Settlements Rept Parms    */
/*                                                                   */
/*       Called By: XX118001 - On-Line Positions Generation         */
/*                                                                  */
/*       (c) Finastra International Limited 2022                     */
/*                                                                   */
/*       Last Amend No. HUT118  *CREATE   Date 03Nov22               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       HUT118 - Online Generation of Position Settlements          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)

             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&XXONLGEN) TYPE(*CHAR) LEN(24)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2020')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

/* Set-off Database Error Switches */

             CHGJOB     SWS(XXXXXX00)

/* Retrieve the data area from QTEMP and prepare the parameter */

             RTVDTAARA  DTAARA(QTEMP/XXONLGEN) RTNVAR(&XXONLGEN)

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGVAR     VAR(&RPARM) VALUE(&XXONLGEN)
             ENDDO

/* Return to RCF with action code = ' '  */

             CHGVAR     VAR(&RCMD) VALUE(' ')

/* End program */

             GOTO       CMDLBL(END)

 ABNOR:
             SNDPGMMSG  MSG('On-line gend Position Settlements Rept Parms') +
                          TOMSGQ(MOPERQ)

 END:        ENDPGM
