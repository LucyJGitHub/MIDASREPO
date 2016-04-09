/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG UDC Dummy Periodic Report Component')        */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC5240  - Dummy Periodic Report Component                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01522             DATE 17JAN95              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&RSEQ &RLVL &RBCH &RPARM)
 
/* Copyright Statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
 
/* Parameters received for RCF                                       */
             DCL        VAR(&RSEQ)        TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&RBCH)        TYPE(*CHAR) LEN(3)
/*/COPY WNCPYSRC,CGC5240001                                          */
             DCL        VAR(&RPARM)       TYPE(*CHAR) LEN(100)
/*/COPY WNCPYSRC,CGC5240002                                          */
 
/* General                                                           */
             DCL        VAR(&RTN_CODE)    TYPE(*CHAR) LEN(7)
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNORMAL)
 
/* Copyright Statement                                               */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('CGC5240 - Dummy Periodic Report +
                          Component') TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
 
/* Terminate Program normally                                        */
 
             GOTO       CMDLBL(ENDCLPGM)
 
 
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC5240 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC5240 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
