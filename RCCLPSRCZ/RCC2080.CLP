/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RC II - Drop ledger details')                   */
/********************************************************************/
/*                                                                  */
/*       Midas     - Automatic Reconciliations II               */
/*                                                                  */
/*       RCC2080 - Drop ledger details - CoB                        */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND NO.  X00000           DATE 00XXX00              */
/*                       X00000           DATE 00XXX00              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERR)
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('AutoRecs II - Drop ledger details') +
                          TOMSGQ(MRUNQ)
 
/* Set-off database error switches. */
             CHGJOB     SWS(XXXXXX00)
 
             CLRPFM     FILE(RCLDGRBK)
             CLRPFM     FILE(RCLDGDBK)
 
/* Call RPG program */
             CALL       PGM(RC2080)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                 GOTO END
             ENDDO
 
/* No error, so copy work files to masters */
             CPYF       FROMFILE(RCLDGRBK) TOFILE(RCLDGRPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)
             CPYF       FROMFILE(RCLDGDBK) TOFILE(RCLDGDPD) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817)
 
/* Skip error processing */
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('AutoRecs II - Drop ledger details +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG MSGID(CPF0000 MCH0000)
 
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
