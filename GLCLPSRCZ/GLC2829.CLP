/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Drop Fontis historic IATs and TPPs')         */
/*********************************************************************/
/*                                                                   */
/*   Midas - Midas-Fontis Interface                                  */
/*                                                                   */
/*   GLC2829 - Drop Fontis historic IATs and TPPs                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*   Prev Amendment No. CGL009 *CREATE   Date 02JUN99                */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   CGL009 - Midas-Fontis IAT/TPP Interface                         */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('Message Management - Drop historic +
                          Fontis IATs and TPPs') TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
 
/* Clear Fontis IAT and TPP backup files */
             CLRPFM     FILE(GLIATXBK)
             CLRPFM     FILE(GLIATJBK)
             CLRPFM     FILE(MGTPPXBK)
             CLRPFM     FILE(MGTPPMBK)
 
/**/
/* Copy all the non-historic messages to backup files */
             CALL       PGM(GL2829) PARM(' ')
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                 GOTO       CMDLBL(ERR)
             ENDDO
 
/* Copy from back up file to GLIATXPD */
             CPYF     FROMFILE(GLIATXBK) TOFILE(*LIBL/GLIATXPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
/* If GLAITXBK is empty we clear the file */
             MONMSG   MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM  FILE(GLIATXPD))
 
/* Copy from back up file to GLAITJPD */
             CPYF     FROMFILE(GLIATJBK) TOFILE(*LIBL/GLIATJPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
/* If GLIATJBK is empty we clear the file */
             MONMSG   MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM  FILE(GLIATJPD))
 
/* Copy from back up file to MGTPPXPD */
             CPYF     FROMFILE(MGTPPXBK) TOFILE(*LIBL/MGTPPXPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
/* If MGTPPXBK is empty we clear the file */
             MONMSG   MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM  FILE(MGTPPXPD))
 
/* Copy from back up file to MGTPPMPD */
             CPYF     FROMFILE(MGTPPMBK) TOFILE(*LIBL/MGTPPMPD) +
                          MBROPT(*REPLACE) CRTFILE(*NO)
/* If MGTPPMBK is empty we clear the file */
             MONMSG   MSGID(CPF2817) CMPDTA(CPF2869) +
                          EXEC(CLRPFM  FILE(MGTPPMPD))
 
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('Message Management - Drop Historic +
                          Fontis IATs and TPPs ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
