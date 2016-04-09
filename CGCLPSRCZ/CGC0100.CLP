/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Extract Message Information')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                     */
/*                                                                   */
/*       CGC0100  - Extract Message Information                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 087868             Date 17May95              */
/*                      086127             Date 03Mar95              */
/*                      S01522             DATE 21NOV94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       087868 - Input parameter needs to be longer to accomodate   */
/*                posting narrative data from AOPNARR0.              */
/*       086127 - Monitor for no message in CGUSRMSG                 */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGID &MSGF &MSGDTA &TXT1 &TXT2 +
                          &RTN_CODE)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
/*********** DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(205) **************087868*/
/**********  DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(244)                      /*087868*/ /*CGL029*/
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(250)                                 /*CGL029*/
             DCL        VAR(&TXT1) TYPE(*CHAR) LEN(132)
             DCL        VAR(&TXT2) TYPE(*CHAR) LEN(512)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches & remove messages */
/* */
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
             CHGJOB     SWS(XXXXX000)
/* */
/* Send message to program */
/* */
             RTVMSG     MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA) +
                          MSG(&TXT1) SECLVL(&TXT2)
/************MONMSG     MSGID(CPF2419) EXEC(DO)                        *086127*/
             MONMSG     MSGID(CPF2419 CPF2407) EXEC(DO)               /*086127*/
/* */
/* Message not found */
/* */
             RTVMSG     MSGID(CGD1018) MSGF(CGUSRMSG) MSGDTA(&MSGID +
                          *CAT &MSGF) MSG(&TXT1) SECLVL(&TXT2)
             CHGVAR     VAR(&RTN_CODE) VALUE('*NRF')
             ENDDO
/* */
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC0100 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC0100 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
