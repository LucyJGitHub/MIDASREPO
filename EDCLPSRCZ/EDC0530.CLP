/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Extract of FO book positions')               */
/********************************************************************/
/*                                                                  */
/*       Midas - Export Data Interface Module                       */
/*                                                                  */
/*       EDC0530 -  Extract of FO Book Positions                    */
/*                                                                  */
/*       Function : This program is called during the Close of      */
/*                  Business processing via the Components and      */
/*                  Dependencies files. It is called after all FO   */
/*                  updates have been completed and before bulk     */
/*                  transfer is performed.                          */
/*                                                                  */
/*       Called By: CBC0050  Midas Close of Business component      */
/*                                                                  */
/*       Calls :    *None                                           */
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
/*       PREV AMEND NO. CED006 *CREATE     DATE 30JUL97             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       CED006 - Midas ED Enhancements                             */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Copyright statement definition */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MKTC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MRKT) TYPE(*CHAR) LEN(2)
 
             DCLF       FILE(MARKTD)
 
/* Global error monitor */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(00000000)
 
/* Clear extract file  */
             CLRPFM     FILE(EDFFBPPD)
 
/* Process OTC first */
             CHGVAR     VAR(&MKTC) VALUE('OTC')
LOOP:
             OVRDBF     FILE(POSTNKD) MBR(&MKTC)
             OVRDBF     FILE(PRICSD) MBR(&MKTC)
             CALL       PGM(ED0530) PARM(&MKTC)
             DLTOVR     FILE(POSTNKD PRICSD)
 
/* Process next market centre. */
 READ:       RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDLOOP))
 
/* Skip deleted market centres */
             IF         COND(&RECI *EQ '*') THEN(GOTO CMDLBL(READ))
 
             CHGVAR     VAR(&MKTC) VALUE(&MRKT)
             GOTO       CMDLBL(LOOP)
 
ENDLOOP:
/* Normal termination */
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(ENDCLPGM))
 
 
/* Abnormal termination */
ABNOR:
 
             SNDPGMMSG  MSG('EDC0530 - Extract of FO Book Positions +
                          TERMINATED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
