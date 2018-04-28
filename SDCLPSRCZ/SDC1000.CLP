/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas BRT FR Countries List Control')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC1000 - FR Countries List Control                         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*       Last Amend No. CRE007 *Create     Date 01Mar01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE007 - Base Rate Tax 2001.                                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&RTN) TYPE(*CHAR)  LEN(7)
             DCL        VAR(&ARSI) TYPE(*CHAR)  LEN(1)
             DCL        VAR(&RSEQ) TYPE(*CHAR)  LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR)  LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR)  LEN(3)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/** Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             SNDPGMMSG  MSG('SDC1000 - FR Countries List') +
                          TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
 
/* Call the FR Countries List program */
 
             CALL       PGM(SD1000P) PARM(&RTN &ARSI &RSEQ &RLEV &RENT)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/**/
/** If no errors, exit */
/**/
             GOTO       CMDLBL(END)
 
/**/
/** Abnormal termination */
/**/
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SD1000P ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/**/
/** End of program */
/**/
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
