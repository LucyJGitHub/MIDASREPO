/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IRInternal Table Report - List')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module - Italy.                  */
/*                                                                   */
/*       IRC5000 - Internal Table Report - List                      */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 14Jan21              */
/*       Prev Amend No. UIT022             Date 17jan97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - UCI Italian returns upgrade to FM2.1               */
/*       UIT022 - Telegramma Decadale / Puma 2 interface             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Copyright Midas-Kapiti International Ltd. 1997')

             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('IRC5000 - Internal Table Report - +
                          Report') TOMSGQ(MRUNQ)

/*   Create Local Data Area                                          */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(00000000)

/*  Run report */

             CALL       PGM(IR5000) PARM(&RSEQ &RENT &RPARM)

/*  If no errors, exit */

             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))

/*  Database error */

 ABNOR:      SNDPGMMSG  MSG('Job Terminated - Database in Error - +
                          IRC5000') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('Copyright Midas-Kapiti +
                          International Ltd.')
             MONMSG     MSGID(CPF0000)

             ENDPGM
