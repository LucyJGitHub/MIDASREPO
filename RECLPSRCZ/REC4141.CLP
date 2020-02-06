/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CASH Reconciliation Control')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4141  - RE CASH Reconciliation Control                   */
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
/*       Prev Amend No. CAP006             Date 10May99              */
/*                      122060             Date 21Aug97              */
/*                      CRT003             Date 22Jul96              */
/*                      CRT002 *CREATE     Date  1DEC95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAP006 - APIs Phase IV                                      */
/*                Scope commitment control to the job rather than    */
/*                the activation group                               */
/*       122060 - Drafts Issuance.                                   */
/*       CRT003 - Cashier Interface.                                 */
/*       CRT002 - Retail Branch Access.                              */
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
/*********** DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0) VALUE(0)   */ /*122060*/
             DCL        VAR(&ENDSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB)    TYPE(*CHAR) LEN(10)              /*CRT003*/
             DCL        VAR(&USR)    TYPE(*CHAR) LEN(10)              /*CRT003*/
             DCL        VAR(&NBR)    TYPE(*CHAR) LEN(6)               /*CRT003*/
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
             SNDPGMMSG  MSG('REC4141 - RE CASH Batch Control') +
                          TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXXX00)
/**/                                                                  /*122060*/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)               /*122060*/
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)               /*122060*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)        /*122060*/
             ENDDO                                                    /*122060*/
/* */
/* Retrieve job attributes from data area CASH */
/* */
/* */
/* Retrieve job attributes from data area CASH */
/* */
/*********** CHGVAR     VAR(&JOB) VALUE('RE4144    ')   */ /*CRT003*/ /*122060*/
             CHGVAR     VAR(&JOB) VALUE('CASH_REC  ')                 /*CRT003*/
             RTVDTAARA  DTAARA(CASH (171 10)) RTNVAR(&USR)            /*CRT003*/
             RTVDTAARA  DTAARA(CASH (181 6) ) RTNVAR(&NBR)            /*CRT003*/
/* */
/* Call data queue creation and allocation */
/* */
             CALL       PGM(REC4142) PARM(&RTN_CODE 'Start     ')
/* */
/* Process already active or close down requested */
/* */
             IF         COND(&RTN_CODE *EQ 'MRC0009') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Start Commitment Control */
/* */
/**********  STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))            /*CAP006*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CAP006*/
             MONMSG     MSGID(CPF8351)
/* */                                                                 /*CRT003*/
/* Add job name to CI Active Jobs File                             */ /*CRT003*/
/* */                                                                 /*CRT003*/
             CALL       PGM(RE4436) PARM('I' &JOB &USR &NBR)          /*CRT003*/
 
/* */
/* Loop calling  CASH Reconciliation Process */
/* */
 LOOP:
/*********** CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)              */ /*122060*/
/* */
/* Check for Cancellation of process - look at end status */
/* */
             RTVJOBA    ENDSTS(&ENDSTS)
             IF         COND(&ENDSTS *EQ '1') THEN(DO)
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Run CASH Reconciliation Process */
/* */
             CALL       PGM(REC4140) PARM(&RTN_CODE)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11) *OR +
                             %SWITCH(XXXXXXX1) *OR +
                             (&RTN_CODE *NE ' ')) THEN(DO)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* Reset switches */
/* */
             CHGJOB     SWS(XXXXXX00)
/***/                                                                 /*122060*/
/**If*count*less*than*10*then*wait*for*next*entry**/                  /*122060*/
/***/                                                                 /*122060*/
/*********** IF         COND(&COUNT *LE 1000) THEN(DO)             */ /*122060*/
/* */
/* Call data queue creation and allocation get next action */
/* */
             CALL       PGM(REC4142) PARM(&RTN_CODE 'Next      ')
/* */
/* End of process requested */
/* */
             IF         COND(&RTN_CODE *EQ 'MIN0128') THEN(DO)
/*********** CALL       PGM(RE4436) PARM('D' &JOB &USR &NBR)*/ /*CRT003 122060*/
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
/* */
/* Re-run process */
/* */
             GOTO       CMDLBL(LOOP)
/* */
/*********** ENDDO                                                 */ /*122060*/
/*********** ELSE       CMD(DO)                                    */ /*122060*/
/***/                                                                 /*122060*/
/**Check*for*Cancellation*of*process*-*look*at*end*status**/          /*122060*/
/***/                                                                 /*122060*/
/*********** RTVJOBA    ENDSTS(&ENDSTS)                            */ /*122060*/
/*********** IF         COND(&ENDSTS *EQ '1') THEN(DO)             */ /*122060*/
/*********** GOTO       CMDLBL(ENDCLPGM)                           */ /*122060*/
/*********** ENDDO                                                 */ /*122060*/
/***/                                                                 /*122060*/
/**Call*data*queue*creation*and*allocation*to*end*process**/          /*122060*/
/***/                                                                 /*122060*/
/*********** CALL       PGM(REC4142) PARM(&RTN_CODE 'Re-submit ')  */ /*122060*/
/*********** ENDDO                                                 */ /*122060*/
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program REC4141 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4141 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
ENDCLPGM:    CALL       PGM(RE4436) PARM('D' &JOB &USR &NBR)          /*122060*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*122060*/
/***********ENDCLPGM:   RCLRSC     LVL(*CALLER)                    */ /*122060*/
             RCLRSC     LVL(*CALLER)                                  /*122060*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLACTGRP  ACTGRP(*ELIGIBLE)                             /*CAP006*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CAP006*/
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
