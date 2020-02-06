/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RC II - Print ledger details')                  */
/********************************************************************/
/*                                                                  */
/*       Midas     - Automatic Reconciliations II               */
/*                                                                  */
/*       RCC2015 - Print Ledger Details - CoB                       */
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
             SNDPGMMSG  MSG('AutoRecs II - Print Ledger Details') +
                          TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches. */
             CHGJOB     SWS(XXXXXX00)
 
/* Call report program to print out today's ledger details */
             CALL       PGM(RC2065) PARM('     ' 'S' '   ' +
                          0000000000XXX)
 
/* If database error detected recover data from LDA and send message */
/* to MOPERQ.                                                        */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                 GOTO END
             ENDDO
 
/* Skip error processing */
             GOTO END
 
 ERR:        SNDPGMMSG  MSG('AutoRecs II - Print Ledger Details +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
             CHGJOB SWS(XXXXXX11)
             MONMSG MSGID(CPF0000 MCH0000)
 
 END:        RCLRSC
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
