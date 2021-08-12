/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IR ICD - List')                                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - European Reporting Module - Italy.                  */
/*                                                                   */
/* ***** ERC9105 - ICD - List                                        */
/*       IRC9105 - ICD - List                                        */
/*                                                                   */
/*       (C) Copyright Midas-Kapiti International Ltd. 1997          */
/*                                                                   */
/*       Last Amend No. LUC139             Date 21Dec20              */
/*       Prev Amend No. UIT021             Date 12FEB97              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - Upgrade UCI Italian Returns                        */
/*       UIT021 - BOI Monthly Reporting                              */
/*                Renamed from ERC9105 for RCF reasons               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PSEQ &PLVL &PENT)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                      Copyright Midas-Kapiti International Ltd. 1997')

             DCL        VAR(&PSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&PLVL)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PENT)  TYPE(*CHAR) LEN(3)

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('IRC9105 - I.C.D. - Report') +
                          TOMSGQ(MRUNQ)

/*   Create Local Data Area                                          */

             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
             CHGJOB     SWS(00000000)

/*  Run report */

             CALL       PGM(IR9105) PARM(&PSEQ &PLVL &PENT)

/*  If no errors, exit */

             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(END))

/*  Database error */

 ABNOR:      SNDPGMMSG  MSG('Job Terminated - Database in Error - +
                          IRC9105') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('Copyright Midas-Kapiti +
                          International Ltd.')
             MONMSG     MSGID(CPF0000)

             ENDPGM
