/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ABS Italian Decision table - Accounts')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module - Italy.                  */
/*                                                                   */
/*       ERCIT35 - Italian Decision table - Accounts                 */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 10Feb21              */
/*       Prev Amend No. UIT021             Date 12FEB97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - UCI Italian returns upgrade to FM2.1               */
/*       UIT021 - BOI Monthly Reporting                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PSEQ &PLVL &PENT &PAR)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Copyright Midas-Kapiti International Ltd. 1997')

             DCL        VAR(&PSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&PLVL)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&PAR)  TYPE(*CHAR) LEN(2)

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('ERCIT35 - Italian Decision Table - +
                          Accounts') TOMSGQ(MRUNQ)

/*   Create Local Data Area                                          */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(00000000)

/*  Run report */

             CALL       PGM(ERIT35) PARM(&PSEQ &PLVL &PENT &PAR)

/*  If no errors, exit */

             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))

/*  Database error */

 ABNOR:      SNDPGMMSG  MSG('Job Terminated - Database in Error - +
                          ERCIT35') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('Copyright Midas-Kapiti +
                          International Ltd.')
             MONMSG     MSGID(CPF0000)

             ENDPGM
