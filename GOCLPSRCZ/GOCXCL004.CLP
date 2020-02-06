/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Universal transactions upd: t/s End SbTsk')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GOCXCL004 - Midas GO Extract Controller Customer Loans      */
/*                   End Sub-task                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CGP014  *CREATE    Date 27Feb09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGP014 - Task split of Extract Controller, Customer Loans   */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Declare variables */
 
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE('GOXCLNSRV')
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10) +
                          VALUE('*LIBL     ')
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50) +
                          VALUE('FINISH')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('GOCXCL004 - Midas GO Extract Controller +
                          Customer Loans - End Sub-task') TOMSGQ(MRUNQ)
 
/* Send FINISH message to main data queue */
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('Program GOCXCL004 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
