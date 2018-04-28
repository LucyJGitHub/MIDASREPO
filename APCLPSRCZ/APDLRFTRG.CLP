/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Rate Fix Trigger Program for DEALSDG')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - APIs                                                */
/*                                                                   */
/*       APDLRFTRG - Midas DL Rate Fix Trigger Program for DEALSDG   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG2692  *CREATE    Date 18May2004           */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG2692 - Batch submit of confirmations programs            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM1 &PARM2)
 
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(100)
             DCL        VAR(&PARM2) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(12)
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(10)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&DTAQ) VALUE('APDLRTFDQ   ')
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')
             CHGVAR     VAR(%SST(&MSGDATA 1 8)) VALUE('DLRTCONF')
             CALL       PGM(QSNDDTAQ) PARM(&DTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
            GOTO       CMDLBL(END)
 ABNOR:
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
               ROLLBACK
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                           APDLRFTRG ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
ENDPGM
