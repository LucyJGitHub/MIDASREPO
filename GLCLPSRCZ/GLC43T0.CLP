/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GL Load Statement Requests with Priority')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC43T0 - Midas GL Load Statement Requests with Priority    */
/*                                                                   */
/*       (c) Finastra International Limited 2018                     */
/*                                                                   */
/*       Last Amend No. CGL188  *Create    Date 19Feb18              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGL188 - COB Optimisation of GL0420                         */
/*                                                                   */
/*********************************************************************/
             PGM

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Send message to MRUNQ */
             SNDPGMMSG  MSG('GLC43T0 - Midas GL Load Statement Requests with +
                          Priority') TOMSGQ(MRUNQ)

             CLRPFM     FILE(GLSTPRPD)

             OVRDBF     FILE(GLSTPRPD) SEQONLY(*YES 500)
             OVRDBF     FILE(STMTS) SEQONLY(*YES 500)

             CALL       PGM(GL43T0)

             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             GOTO       CMDLBL(END)

 ABNOR:      SNDPGMMSG  MSG('Program GLC43T0 ended abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited')
             ENDPGM
