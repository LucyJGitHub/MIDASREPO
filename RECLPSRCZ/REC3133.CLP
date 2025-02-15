/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Commission Cap'n - End Sub-Task ANWD')       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC3133 - Commission Capitalisation - End Sub-Task          */
/*                 ANWD Version                                      */
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
/*       Prev Amend No. CCB003  *CREATE    Date 01Apr97              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                End Sub-Task                                       */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,REC3133INT                                          */
 
/* Declare variables */
 
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE('COMMCSERVE')
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10) +
                          VALUE('*LIBL     ')
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50) +
                          VALUE('FINISH')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,REC3133MPS                                          */
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('REC3133 - Commission Capitalisation - +
                          End Sub-Task') TOMSGQ(MRUNQ)
 
/* Send FINISH message to main data queue */
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('Program REC3133 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,REC3133END                                          */
 
             ENDPGM
