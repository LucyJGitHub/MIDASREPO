/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Bulk Update of GZFCLTLVPD: t-s End SubTsk')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOCFCLV004 - Midas GO Bulk update of Facilities Listview    */
/*                    End Sub-task                                   */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CGP015  *CREATE    Date 06Mar09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGP015 - Task Split of Bulk update of Facilities listview   */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Declare variables */
 
             DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE('GOFCLVSRV')
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
             SNDPGMMSG  MSG('GOCFCLV004 - Midas GO Bulk update of +
                          Facilities Listview - End Sub-task') +
                          TOMSGQ(MRUNQ)
 
/* Send FINISH message to main data queue */
             CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)
 
             GOTO       CMDLBL(END)
 
 ABNOR:      SNDPGMMSG  MSG('Program GOCFCLV004 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
