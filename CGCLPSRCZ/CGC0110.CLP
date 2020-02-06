/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Format command string and prompt')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC0110  - Format Command String and Prompt                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. 190022             Date 25Jan99              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 21Nov94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       190022 - Increased the size of OVRPRTF string string to     */
/*                accomodate more options for the OVRPRTF command.   */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &STRING)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
/*********** DCL        VAR(&STRING) TYPE(*CHAR) LEN(256)  ***/       /*190222*/
             DCL        VAR(&STRING) TYPE(*CHAR) LEN(1024)            /*190022*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Set switches */
/* */
             CHGJOB     SWS(XXXXX000)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
/* */
/* Prompt command */
/* */
/*********** CALL       PGM(QCMDCHK) PARM(&STRING 256)  ***/          /*190022*/
             CALL       PGM(QCMDCHK) PARM(&STRING 1024)               /*190022*/
             MONMSG     MSGID(CPF6801) EXEC(DO)
             CHGVAR     VAR(&RTN_CODE) VALUE('CGD1398')
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
             SNDPGMMSG  MSG('Program CGC0110 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC0110 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
