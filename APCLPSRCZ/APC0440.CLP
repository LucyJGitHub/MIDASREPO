/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AP End Confirmations Job')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - APIs                                                */
/*                                                                   */
/*       APC0440   - End Confirmations job                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG2381  *CREATE    Date 13May04             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG2381 - Batch submit of confirmations programs            */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,APC0440INT                                          */
 
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
 
/*/COPY WNCPYSRC,APC0440MPS                                          */
 
             CHGVAR     VAR(&DTAQ) VALUE('APCONFDTQ   ')
             CHGVAR     VAR(&DTAQLIBL) VALUE('*LIBL')
             CHGVAR     VAR(%SST(&MSGDATA 1 3)) VALUE('END')
             CALL       PGM(QSNDDTAQ) PARM(&DTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
/*/COPY WNCPYSRC,APC0440MPE                                          */
 
            GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,APC0440ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
               ROLLBACK
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            APC0440 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,APC0440END                                          */
 
ENDPGM
