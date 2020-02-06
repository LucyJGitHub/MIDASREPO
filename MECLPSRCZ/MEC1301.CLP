/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ME FT IMM Auto Gen Control')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Message Management Module                       */
/*                                                                   */
/*       MEC1301  - ME FT IMM Auto Gen Control - Batch process       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAP006             Date 20Nov98              */
/*                      S01435             Date 21Sep93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP006 - APIs Phase IV                                      */
/*                Scope commitment control to the job rather than    */
/*                the activation group                               */
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0) VALUE(0)
             DCL        VAR(&COUNT100) TYPE(*DEC) LEN(4 2) VALUE(0)
             DCL        VAR(&ENDSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MSG_REF) TYPE(*CHAR) LEN(8)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MEC1301 - ME FT IMM Control') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
/* */
/* Change date format to YYMMDD */
/* */
             CHGJOB     DATFMT(*YMD)
/* */
/* Create SPF environment for Auto Generation user */
/* */
             CALL       PGM(MEC1310)
/* */
/* Call data queue creation and allocation */
/* */
             CALL       PGM(MEC1302) PARM(&RTN_CODE 'Start     ' +
                          &MSG_REF)
/* */
/* Process already active or close down requested */
/* */
             IF         COND(&RTN_CODE *EQ 'MIN0222') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Start Commitment Control */
/* */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))   **/                          /*CAP006*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                                                  /*CAP006*/
             MONMSG     MSGID(CPF8351)
/* */
/* If allocation of MEINMRPD allowed then clear */
/* */
             ALCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(MISS_CLEAR)
             ENDDO
             CLRPFM     FILE(MEINMRPD)
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST))
             MONMSG     MSGID(CPF0000)
 MISS_CLEAR:
             ALCOBJ     OBJ((MEINMRPD *FILE *SHRUPD)) WAIT(600)
/* */
/* Loop calling  FT Auto Generation */
/* */
 LOOP:
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
/* */
/* Check MEINMRPD lock every 100 times */
/* */
             CHGVAR     VAR(&COUNT100) VALUE(&COUNT / 100)
             IF         COND(&COUNT100 *EQ 0) THEN(DO)
/* */
/* If allocation of MEINMRPD allowed then clear */
/* */
             ALCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST)) WAIT(0)
             MONMSG     MSGID(CPF1002) EXEC(DO)
             GOTO       CMDLBL(MISS_CLER2)
             ENDDO
             CLRPFM     FILE(MEINMRPD)
             MONMSG     MSGID(CPF0000)
             DLCOBJ     OBJ((MEINMRPD *FILE *EXCL *FIRST))
             MONMSG     MSGID(CPF0000)
 MISS_CLER2:
             ENDDO
/* */
/* Check for Cancellation of process - look at end status */
/* */
             RTVJOBA    ENDSTS(&ENDSTS)
             IF         COND(&ENDSTS *EQ '1') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Call MEC1300 - FT Auto Generation */
/* */
             SNDPGMMSG  MSG('Reference ' *CAT &MSG_REF *TCAT ' being +
                          processed.') TOPGMQ(*SAME)
             CALL       PGM(MEC1300) PARM(&RTN_CODE &MSG_REF)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11) *OR +
                             %SWITCH(XXXXXXX1) *OR +
                            ((&RTN_CODE *NE 'MIN0230') *AND +
                             (&RTN_CODE *NE ' '))) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* MIN0230 - Close down requested */
/* */
             IF         COND(&RTN_CODE *EQ 'MIN0230') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Reset switches */
/* */
             CHGJOB     SWS(XXXXXX00)
/* */
/* If count less than 10 then wait for next entry */
/* */
             IF         COND(&COUNT *LE 1000) THEN(DO)
/* */
/* Call data queue creation and allocation get next action */
/* */
             CALL       PGM(MEC1302) PARM(&RTN_CODE 'Next      ' +
                          &MSG_REF)
/* */
/* End of process requested */
/* */
             IF         COND(&RTN_CODE *EQ 'MIN0223') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Re-run process */
/* */
             GOTO       CMDLBL(LOOP)
/* */
             ENDDO
             ELSE       CMD(DO)
/* */
/* Check for Cancellation of process - look at end status */
/* */
             RTVJOBA    ENDSTS(&ENDSTS)
             IF         COND(&ENDSTS *EQ '1') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Call data queue creation and allocation to end process */
/* */
             CALL       PGM(MEC1302) PARM(&RTN_CODE 'Re-submit ' +
                          &MSG_REF)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MEC1301 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1301 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)                                                 /*CAP006*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                    /*CAP006*/
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
