/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Prompt CG IMMEDS Extraction I/C only')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC5217  - Prompt CG IMMEDS Extraction I/C only             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG6604            Date 20Apr05              */
/* Midas Release 4 --------------- Base -- --------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             DATE 30JAN95              */
/*                      Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       BUG6604- Removal of RCLRSC from this program                */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE)
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
             DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)
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
/**/
/*           Get Midas Phase                                         */
/**/
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&PHASE)
/**/
/*           If "A" Input Cycle call prompt program                  */
/**/
/**********  IF         COND(&PHASE *EQ 'A') THEN(DO)                                  */ /*CCB020*/
             IF         COND(&PHASE *EQ 'A' *OR &PHASE *EQ 'G') +
                          THEN(DO)                                                        /*CCB020*/
             CHGVAR     VAR(&RTN_CODE) VALUE('       ')
             CALL       PGM(CGC5214) PARM(&RTN_CODE)
             ENDDO
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
             SNDPGMMSG  MSG('Program CGC5217 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5217 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:                                                                               /*BUG6604*/
/***** ENDCLPGM:   RCLRSC     LVL(*CALLER)  *******/                                     /*BUG6604*/
/*******     MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                   /*BUG6604*/
             ENDPGM
