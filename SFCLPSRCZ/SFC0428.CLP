/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SF Extract message information')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Security profile Module                         */
/*                                                                   */
/*       SFC0428  - Extract Message Information                      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       LAST AMEND NO. CSF001 *CREATE     DATE 07JAN00              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGID &MSGF &MSGDTA &TXT1 &TXT2)
 
/*/COPY WNCPYSRC,SFC0428INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Declare variables */
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
             DCL        VAR(&TXT1) TYPE(*CHAR) LEN(132)
             DCL        VAR(&TXT2) TYPE(*CHAR) LEN(512)
 
/* Global Monitor Message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/* Set switches & remove messages */
 
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
             CHGJOB     SWS(XXXXX000)
 
/*/COPY WNCPYSRC,SFC0428MPS                                          */
 
/* Send message to program */
 
             RTVMSG     MSGID(&MSGID) MSGF(&MSGF) MSGDTA(&MSGDTA) +
                          MSG(&TXT1) SECLVL(&TXT2)
             MONMSG     MSGID(CPF2407 CPF2419 CPF0001) EXEC(DO)
 
/* Message not found */
 
             RTVMSG     MSGID(SFM0310) MSGF(SFUSRMSG) MSGDTA(&MSGID +
                          *CAT &MSGF) MSG(&TXT1) SECLVL(&TXT2)
             ENDDO
 
/*/COPY WNCPYSRC,SFC0428MPE                                          */
 
             GOTO       CMDLBL(ENDCLPGM)
 
/* Abnormal termination processing                       */
 
ABNORMAL:
/*/COPY WNCPYSRC,SFC0428ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program SFC0428 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SFC0428 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDCLPGM:
/*/COPY WNCPYSRC,SFC0428END                                          */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
