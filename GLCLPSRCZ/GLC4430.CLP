/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Control Print of Today's Mvmnts')               */
/*****************************************************************/
/*                                                               */
/*     Midas - General Ledger Module                     */
/*                                                               */
/*     GLC4430  - Control Print of Today's Movements             */
/*                                                               */
/*       (c) Finastra International Limited 2001                     */
/*                                                               */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 041693             Date : 05jAN9             */
/*                                                               */
/*---------------------------------------------------------------*/
/*                                                               */
/*       MD046248 - Finastra Rebranding                              */
/*    041693 - Delivered as part of fix.                         */
/*                                                               */
/*****************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PGM &SEQ &LEVEL &ENTITY &DATA)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PARAMETERS) TYPE(*CHAR) LEN(256)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('GLC4430 - Today''s Movements Report') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
/* */
/* Run GL4430 - Today's Movements  */
/* */
             CHGVAR     VAR(&ACTION) VALUE(%SST(&DATA 1 8))
             CHGVAR     VAR(&PARAMETERS) VALUE(%SST(&DATA 9 92))
/* */
             CALL       PGM(GL4430) PARM(&RTN_CODE &ACTION +
                          &PARAMETERS &SEQ)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* Shut dowm GL4430  */
/* */
             CHGVAR     VAR(&ACTION) VALUE('*CLOSE  ')
             CALL       PGM(GL4430) PARM(&RTN_CODE &ACTION +
                          &PARAMETERS &SEQ)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(&RTN_CODE *NE '       ') THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
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
             SNDPGMMSG  MSG('Program GLC4430 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          GLC4430 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
