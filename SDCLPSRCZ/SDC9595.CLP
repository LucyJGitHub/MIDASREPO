/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Correspondence manager control data')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - User Defined Correspondence                         */
/*                                                                   */
/*       SDC9595 - Correspondence Manager Control Data               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Prev Amend No. CCG015  *CREATE    Date 12Nov01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*      CCG015 - Correspondence Manager Phase 1                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
 
/** Global monitor message                                         */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
 
/** Set job switches                                               */
             CHGJOB     SWS(XXXXXX00)
 
/** Call Correspondence Manager Control Data Program               */
             CALL       PGM(SD9595)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(+
                          GOTO CMDLBL(ABNORMAL))
 
             GOTO       CMDLBL(ENDCLPGM)
 
/** Abnormal termination processing */
ABNORMAL:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program SDC9595 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
