/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Check job activity')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Message Management Module                   */
/*                                                                   */
/*       MEC1026  - Check job activity                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 108266             DATE 16FEB98              */
/*       PREV AMEND NO. S01435             DATE 19AUG93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       108266 - I/C Termination failed due to MS_ME_IMM job running*/
/*       S01435 - Incoming Message Management                        */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &JOB_INFO &FORMAT &JOB +
                          &INT_JOB_ID)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOB_INFO) TYPE(*CHAR) LEN(512)
             DCL        VAR(&RTN_INFO) TYPE(*CHAR) LEN(512)
             DCL        VAR(&RTN_BIN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(26)
             DCL        VAR(&INT_JOB_ID) TYPE(*CHAR) LEN(16)
/*Start 108266*/
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)                /*108266*/
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(256)             /*108266*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1 0)               /*108266*/
/*End 108266*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/* */
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MEC1026 - Check job activity') +
                          TOMSGQ(MRUNQ)
             CHGVAR     VAR(&RTN_CODE) VALUE(' ')
             CHGVAR     VAR(&JOB_INFO) VALUE(' ')
             CHGVAR     VAR(&RTN_BIN) VALUE(X'00000200')
/*Start 108266*/
             CHGVAR     VAR(&COUNT) VALUE(0)                          /*108266*/
/*End 108266*/
/* */
/* Call IBM API to obtain information */
/* Note error code not coded to allow API to send diagonistics */
/* */
/*********** CALL*******PGM(QUSRJOBI) PARM(&RTN_INFO &RTN_BIN +***      108266*/
/*************************&FORMAT &JOB &INT_JOB_ID)***************      108266*/
/************MONMSG*****MSGID(CPF3C53 CPF3C55) EXEC(DO)***********      108266*/
/*****************************************************************      108266*/
/**Job not found or does not exist********************************      108266*/
/*****************************************************************      108266*/
/*Start 108266*/
 RETRY:      CALL       PGM(QUSRJOBI) PARM(&RTN_INFO &RTN_BIN +
                          &FORMAT &JOB &INT_JOB_ID)                   /*108266*/
             MONMSG     MSGID(CPF3C53 CPF3C55 CPF3C54) EXEC(DO)       /*108266*/
/* Job not found or does not exist or not available*/                 /*108266*/
/* */
/*Check if job not available*/                                        /*108266*/
             RCVMSG     RMV(*NO) MSGDTA(&MSGDTA) MSGID(&MSGID)        /*108266*/
             IF  COND(&MSGID *EQ 'CPF3C54') THEN(DO)                  /*108266*/
 
                      IF COND(&COUNT *LT 3) THEN(DO)                  /*108266*/
                         CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)     /*108266*/
                         DLYJOB     DLY(20)                           /*108266*/
                         GOTO       CMDLBL(RETRY)                     /*108266*/
                         ENDDO                                        /*108266*/
                      ELSE (DO)                                       /*108266*/
                         GOTO CMDLBL(ABNORMAL)                        /*108266*/
                      ENDDO                                           /*108266*/
 
                 ENDDO                                                /*108266*/
 
             ELSE CMD(DO)                                             /*108266*/
/*End 108266*/
             CHGVAR     VAR(&RTN_CODE) VALUE('MIN0125')
/*Start 108266*/
             ENDDO                                                    /*108266*/
/*End 108266*/
             ENDDO
/* */
/* Set up return information */
/* */
             CHGVAR     VAR(&JOB_INFO) VALUE(&RTN_INFO)
/**/
             GOTO       CMDLBL(ENDCLPGM)
/**/
/* Abnormal termination processing                       */
/* Terminate with escape message */
/**/
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program MEC1026 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MEC1026 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDPGM
