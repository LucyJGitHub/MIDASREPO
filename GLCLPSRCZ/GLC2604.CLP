/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Batch Trans. File Split - End Sub-Task')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC2604 - Batch Transaction File Split - End Sub-Task       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CCB003  *Create    Date 11Oct96              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                End Sub-Task                                       */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,GLC2604INT                                          */
 
/* Declare variables */
 
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE('BATCHSERVE')
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10) +
                          VALUE('*LIBL     ')
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50) +
                          VALUE('FINISH')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,GLC2604MPS                                          */
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('GLC2604 - Batch Transaction File Split +
                          - End Sub-Task') TOMSGQ(MRUNQ)
 
/* Send FINISH message to main data queue */
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('Program GLC2604 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,GLC2604END                                          */
 
             ENDPGM
